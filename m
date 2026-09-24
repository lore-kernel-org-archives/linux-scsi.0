Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDBA4A8A13;
	Thu, 24 Sep 2026 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790273920; cv=none; b=s23VtGRCnQRRcAjECAUgwwVrVCCxLZghEW8dFBAk+HGeu3PaIYkMWF2p1X4KrgBJSrt7aBgFQkpAxq/sKZFmPMbV51+nuAXY0K2sqIPtpYQ+3XRNWY6NGw1tiWqWWfegVLcUnoNhxzEyrfXy0U83ENNRHoeVpH3N702qO5xBx5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790273920; c=relaxed/simple;
	bh=SONmCX+xf3gha2wHVDrvsIHpdyhgYGABl98DEQDrbLU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JLcpxV5UsobUNzmfJwEL9I7Wh70BfQUAZl5P8eKZ86f4Y1bRbk+5r/L3SH1+wmSW825o+Y1ASqj0TGlLOfOn/WpMRMhoO8dEjCAh4UYkR30pKXVUYsBM1li7X4lpUd5tNRvyev/uInBYUdwzoBzlUwo1C78x5ikGcGqRTCQYLOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a89LbviR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a89LbviR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DF11F000FF;
	Thu, 24 Sep 2026 18:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790273918;
	bh=VbmQ7qLu7LScG9euJN58KcimpI1CSP75iwiM88CCRug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a89LbviR0iVxZMY98vISlY2MNwbUKZqHqbxlGOil0gx5L/B/qcDccsJSVuL7qnCcz
	 x9WPoBx0Vj+ViCxejXkADXIBa6BGRiX6+ZFcYxKmtA2r464JGZEt0osZPyxs0sU+Sa
	 ZKK5uiF2QmzvAl3Fg3q3uyP03KKrb9lORiAUCQ166KWT+nVTHzwBz/TeJcHeigxEfO
	 TNGeJl4Ghd26+u4eBEdQcOpKaptXSvsXuq+iIiAECPPgrMfFMMk9DWAqLoadl8Dh0/
	 uBj0vU0VB7FFNhAWYLNQxVL/YAzCJ+H6Wl7/phdJsHyoqbUcFAIHSwK9W1ad7I1Cav
	 EEHJGSKXct9Eg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ata: libata-scsi: do not lose CHECK CONDITION for
 failed ATAPI commands
Reply-To: sashiko-reviews@lists.linux.dev
To: hengyul@cs.unc.edu
Cc: dlemoal@kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260924180414.2102946-1-hengyul@cs.unc.edu>
References: <20260924180414.2102946-1-hengyul@cs.unc.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 18:18:37 +0000
Message-Id: <20260924181838.43DF11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: midlayer byte wiped in atapi_qc_complete() breaks error tran=
slation
--

commit a67971887516df13f132f00266219f908c09e9aa
Author: Hengyu Liang <hengyul@cs.unc.edu>

ata: libata-scsi: do not lose CHECK CONDITION for failed ATAPI commands

This commit modifies atapi_qc_complete() to preserve cmd->result only if the
host byte is set. For other errors, it sets the status to
SAM_STAT_CHECK_CONDITION to avoid losing the CHECK CONDITION status for
failed ATAPI commands.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index d2160ee7ca7d4..436ddf5ed4748 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3020,7 +3020,14 @@ static void atapi_qc_complete(struct ata_queued_cm=
d *qc)
>  		if (qc->cdb[0] =3D=3D ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
>  			qc->dev->sdev->locked =3D 0;
> =20
> -		if (cmd->result)
> +		/*
> +		 * Only preserve the result of a command that was terminated
> +		 * with a host byte set, e.g. DID_TIME_OUT. A failed command
> +		 * may also have the SCSI midlayer internal byte set by
> +		 * scsi_check_sense(), which must not prevent reporting the
> +		 * CHECK CONDITION status.
> +		 */
> +		if (get_host_byte(cmd) !=3D DID_OK)
>  			ata_scsi_qc_done(qc, false, 0);
>  		else
>  			ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this assignment destroy the upper 24 bits of cmd->result, completely
erasing the midlayer byte?

When an ATAPI command fails, ata_eh_analyze_tf() fetches sense data and
delegates to scsi_check_sense(), which translates sense keys (e.g.,
MEDIUM_ERROR) by setting the SCSI midlayer internal byte in cmd->result.

When atapi_qc_complete() calls ata_scsi_qc_done() with set_result =3D true:

drivers/ata/libata-scsi.c:ata_scsi_qc_done() {
    ...
	if (set_result)
		cmd->result =3D scmd_result;
    ...
}

This directly overwrites the 32-bit field and silently erases the midlayer
byte previously set by scsi_check_sense().

Consequently, scsi_result_to_blk_status() sees an empty midlayer byte and
translates legitimate ATAPI block errors to generic BLK_STS_IOERR (-EIO)
instead of the specific status (like BLK_STS_MEDIUM), breaking block layer
error translation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924180414.2102=
946-1-hengyul@cs.unc.edu?part=3D1
