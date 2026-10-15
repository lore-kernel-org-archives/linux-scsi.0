Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5BC479869
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 07:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792049198; cv=none; b=osMgJVAAyfjUhg/hIYrHpfi+mLu7uJrTfx8G03gMA2nfLfIK8Vnmc10y2lCP3QcVt2UXodJtcXQIPvbVhGudzkKJZLQWFQwl5lVDfyuq9JxTYCJw2S+rqkqCI6xLdQOdy0i26L1bbKzufDi85NzAv2S+G3ZeZ6ZeXQlXhq9znhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792049198; c=relaxed/simple;
	bh=55fngw8U7i276yUTXQntdbIZF4Wd6ep68zhxSVkxCO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkhPS2XC9d5gdMi9RN+bGWeOx4YUUMvB54mFVOC41BVjvgubQIXwU1j0/mSRdc6QL2W7IWqDNzBNC9YPGOKvBr4bYVMcDoh36+fHIQ2lGL0BcDlqh6TubcqapdsvdIzqCMPvDGmWtBk/NVjmX2du3TRVcgD83NPVfR4btisgHvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=GJI3uEIH; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="GJI3uEIH"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3a4cdc9025bso2731913a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792049186; x=1792653986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i6VprNe7yjepyKxDyWl/GS5n+61wlhCAhAo3qvs5zaA=;
        b=GJI3uEIHj20+6V+mGjtCAY8MK4iFB8mWOlPqtEMJS/ilIx/Tpk8bb7cAMCW+Qgmns7
         I+faRk1YMn3Bygc+hMZTQGFdp7s7mk0jKWXTiF3ANdHFnDeBjrfmzNMvhKyvaeaK+2h2
         RKVFjTkXPMLzFovHLSePSyMgebS7a5XF1bsDjCBFjW7Q+g8PzxJjwMiZCWBn9f7QcGw7
         +IJUicSt9v3h4Dgba5PqLZYvWMiDxRkJ4ALUdc7Ef3Il3BrlDayMIPbhKPnDVoLrXrT4
         f6R+EkNN8vH0vQMxCFzxaUfS2d/ltBca12OgDFtmlg8D7GJwKCfmEgu5mmbZ7ioRWjOz
         LPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792049186; x=1792653986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i6VprNe7yjepyKxDyWl/GS5n+61wlhCAhAo3qvs5zaA=;
        b=suwqbQM0bAGBL7QLZBNhmTnXaCKzHYjToCsEx2tyO8Hnk6xHrL00RFcY+UXfmPDdLO
         ezk4/FvhVE6tUvfrcB6QE4zQojoGziezOPii3ubY2dd18Ky3a2v5q1faO2AYbwfGsqX0
         n5NclErdESJ4cyq1WN1J3f/eR8ksG7QTj/VE53U0mjcnegpSf0PkPCEqTyM9l3Vhcshj
         GeTLNktLHrlnw1riQnvYDDrJmF51nyrvmo7Gy/YmJ0+Ce6xbyB2ua/J5IPbWhk2nfN7M
         d7TMkzCc95KD6Tq28exmt53P9SRQb76h/ZfpGMuEZjLKfpOXdXOvsMUSjsH8RcwWwatH
         CydQ==
X-Gm-Message-State: AFq9FYIM0A/OO8X7QxHqMNUlG9ZM6qwTKgvTKzL4Npu8D2RbweZ7OArl
	3VStN1BRlwyf517Mopcc8K8zUmJ9DGgFyhPDTJ3H9HDssmg68iHIzRbySSMUfrXlTcc=
X-Gm-Gg: AYBFou3dgAKlpyV+imbmCNgcZnRsS/aTBVSiMDAN5GX98TQpGwIpMk6CyQGhZFo/hbI
	Lr2Z4JZBKxDgWP4vAz0JhS3B2ZB+A0TOWPv61US194y3LWQyR2GCokqZ7dH1lgZ0ke+Dn+HP3dR
	dWphh3KcPLoJU4VWgKxP7XxguaJYWWrHelSiu1pYJ4IuBaaGBh+tSTUecXir1DoP+xzNyIIrQYN
	b1Y1Fp3ifVCB3xv50RC0LDwGvvM+vtKBn6Ud8KVcPVNbGtFMN43LOb0LsBHzywe3pJPnZps2LIF
	jeulcoIDddsA1kri3RdR6TM/2kfNyJrj4X0JCDAepqmc6IzY4ephVDQgExvnTqdMi4RzB4Hptfm
	0IhvEdLcy2/bVTk+52CpOMMByms8jANS/uQez/JS/KpeC1crHTCCIOafuapiXmA3FAedOjF7MfG
	WwvjnzaO8mM++iDRztq2gVklqFr9Txd6misq4guxFdJyBOqS08dUSqfVgy2lGRbnAPyntIlHbxk
	KV3Sw==
X-Received: by 2002:a17:90b:2d86:b0:39e:359f:8539 with SMTP id 98e67ed59e1d1-3ab3a90b5f4mr13828970a91.15.1792049185606;
        Thu, 15 Oct 2026 00:26:25 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac937c4e7asm1754279a91.3.2026.10.15.00.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 00:26:25 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 1/3] scsi: aic94xx: bail out of escb_tasklet_complete() on a bad EDB index
Date: Thu, 15 Oct 2026 16:26:10 +0900
Message-ID: <20261015072612.4144043-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
References: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

escb_tasklet_complete() derives the empty data buffer index from the done
list opcode the sequencer wrote:

	int edb = (dl->opcode & DL_PHY_MASK) - 1; /* [0xc1,0xc7] -> [0,6] */

DL_PHY_MASK is 7, so the subtraction yields -1 through 6, and the
function already says that anything outside [0,6] is wrong:

	if (edb > 6 || edb < 0) {
		ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n", ...);
		...
	}

The block reports the problem and then falls through to let it happen.
edb is used twice afterwards: asd_bytes_dmaed_tasklet() adds
ascb->edb_index to it to index seq->edb_arr[], and the out: label at the
end of the function hands the same value to asd_invalidate_edb(), which
indexes both escb->eb[] and seq->edb_arr[]. asd_assign_edbs2escbs() gives
the first ESCB edb_index 0, so for that one edb == -1 reads
seq->edb_arr[-1], one pointer before the array, and dereferences whatever
it finds.

Finish the check the way it reads: return instead of falling through.

Whether the sequencer can really report an opcode that makes this zero is
not something the tree answers. It is firmware loaded with
request_firmware(), the done list opcode is described only by the comment
above, and there is no Documentation/ file and no MAINTAINERS entry for
this driver. This is not a claim of a reachable out-of-bounds access,
only that the driver goes on to index an array with a value it has just
decided is invalid. The intent to bound what the sequencer supplies is
already in the same file, in asd_bytes_dmaed_tasklet():

	size = min(size, (u16) sizeof(phy->frame_rcvd));

which clamps a device-supplied length a few lines after indexing
seq->edb_arr[] with a device-supplied index and no bound.

One consequence worth naming: an ESCB dropped this way is not invalidated
and so is not reposted to the sequencer, because the repost happens
inside asd_invalidate_edb(). That takes one empty buffer out of
circulation per malformed opcode. It is the lesser of the two, and
recovering the ESCB instead would mean choosing some other buffer to
invalidate, which this index cannot tell us.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aic94xx/aic94xx_scb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 08c8dad9ad621..d050e5325b943 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -421,6 +421,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 			    le64_to_cpu(ascb->scb->header.next_scb),
 			    le16_to_cpu(ascb->scb->header.index),
 			    ascb->scb->header.opcode);
+		return;
 	}
 
 	/* Catch these before we mask off the sb_opcode bits */
-- 
2.43.0

