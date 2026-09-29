Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3792519DEC;
	Tue, 29 Sep 2026 11:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790682969; cv=none; b=fmacO2BNIhVuKggoslJ5Am1fwGznit12Mh/NO64CJNT8ZdWrGdaYGX/Tmvka9RULdDcHxEEPiYaGbUCCYxSqnlAudsAnNfUcLq6T+pK12NVeJrN8VyRbPiR0uBq+HCUKmDrYVNM1YqMr8gwKaMtBJA9xvRWYqNpBZ1ZEhvK1F8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790682969; c=relaxed/simple;
	bh=oi4ecmrtRPGyQ9zN1UpyGc3XPw7K3CaoMg48WodFQB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQx3zlk2lcjH0xxNBbP1E8pXw8jhg+MVPTqYOsGM2T3+ZeHCueghIK5Oq/XKpmzR+w84LJemJyHXwvbusirHJzKa6oNKvVDr4c7XcoPDOkaBZvB3uXfxc+vHndLoLh5DwNdivucPoaiVsgesqz+714DLUva4Nr3OOaRZ1OnkA18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAfRGdMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAfRGdMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CE31F00893;
	Tue, 29 Sep 2026 11:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790682968;
	bh=zAcr7k1VFSj0FxGnV2wZTgaTAlECtx8NAJwasJV5ywQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aAfRGdMcWvekHavm3q/uHYK7Ej0wO8vA5AtpIPBUdP4gtxA2dErTsPrWW+Fjb83+I
	 c2Gs8W0TBEQKMyytzDSlLl5gnaexK6kTt2SCecoJjmzDg9JXtQhj7Tio71pYf6e65t
	 QFfditMrnvBbf4LiD23zX70P8flC8+78Kp3I6UZCxZaDZltCVPC7XlOwz+faE860lN
	 UTl5y4EJhNS+BeEgBKH/PjRzQa2QCVv2M5d3HOxOh9XFsBatlfykjyhsmwjCE2bgee
	 JAANKijL4mMkTi1BPEWHjr9hLU4e9EeH1QGhtaxq7ecHueELulevrmQteCucLlIXqF
	 E9q8Qv65nf4sw==
Date: Tue, 29 Sep 2026 13:56:03 +0200
From: Niklas Cassel <cassel@kernel.org>
To: hengyul@cs.unc.edu
Cc: dlemoal@kernel.org, mkp@kernel.org, ipylypiv@google.com,
	linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ata: libata-scsi: do not lose CHECK CONDITION for failed
 ATAPI commands
Message-ID: <arunU96ilIfG7Gt5@ryzen>
References: <20260924180414.2102946-1-hengyul@cs.unc.edu>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924180414.2102946-1-hengyul@cs.unc.edu>

Hello Hengyu,

On Thu, Sep 24, 2026 at 02:04:14PM -0400, hengyul@cs.unc.edu wrote:
> From: Hengyu Liang <hengyul@cs.unc.edu>
> 
> Since commit 2e1d2e65e773 ("ata: libata-scsi: terminate deferred commands
> on time out"), atapi_qc_complete() sets SAM_STAT_CHECK_CONDITION for a
> failed command only if cmd->result is zero, so that the DID_TIME_OUT or
> DID_REQUEUE host byte of a terminated command is preserved.
> 
> However, cmd->result can also be non-zero for a regular failed ATAPI
> command completed through libata EH: ata_eh_analyze_tf() calls
> ata_eh_decide_disposition(), that is, scsi_check_sense(), on the sense
> data obtained with REQUEST SENSE, and scsi_check_sense() sets the SCSI
> midlayer internal byte of the result for some sense codes, e.g.
> SCSIML_STAT_TGT_FAILURE for ILLEGAL REQUEST with ASC 0x20 (INVALID
> COMMAND OPERATION CODE) or 0x24 (INVALID FIELD IN CDB), or
> SCSIML_STAT_MED_ERROR for MEDIUM ERROR with ASC 0x11 (UNRECOVERED READ
> ERROR). For such commands, atapi_qc_complete() keeps the result as is and
> the command completes with a GOOD status byte, even though it failed and
> valid sense data is available.
> 
> As a result, passthrough users see these failed ATAPI commands as
> successful. For example, with the emulated IDE CD-ROM drive of QEMU and
> no medium loaded, a PLAY AUDIO MSF command issued with SG_IO completes
> with status 0x00 (and no DRIVER_SENSE) instead of 0x02 (CHECK CONDITION)
> with sense key ILLEGAL REQUEST, ASC/ASCQ 0x20/0x00, and the CDROM ioctls
> CDROMPLAYTRKIND, CDROMSUBCHNL, CDROMPAUSE, CDROMRESUME, CDROMPLAYMSF and
> CDROM_GET_MCN return 0 instead of -ENOMEDIUM or -EOPNOTSUPP.
> 
> Fix this by preserving the result only if its host byte is set, and by
> otherwise completing the command with SAM_STAT_CHECK_CONDITION, as was
> done before that commit.
> 
> Fixes: 2e1d2e65e773 ("ata: libata-scsi: terminate deferred commands on time out")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
> ---

I think it is better if you set only the status byte with set_status_byte()
instead of overwriting cmd->result, so that the SCSI midlayer byte set by
scsi_check_sense() is kept.

Something like:

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8f9aa97a519d..fb5517d51095 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3059,10 +3059,15 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
                if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
                        qc->dev->sdev->locked = 0;
 
-               if (cmd->result)
-                       ata_scsi_qc_done(qc, false, 0);
-               else
-                       ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
+               /*
+                * Report CHECK CONDITION unless the command was terminated
+                * with a host byte set. Only set the status byte, so that the
+                * SCSI midlayer internal byte, which scsi_check_sense() may
+                * have set from the sense data, is preserved.
+                */
+               if (get_host_byte(cmd) == DID_OK)
+                       set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
+               ata_scsi_qc_done(qc, false, 0);
                goto schedule_deferred;
        }
 
