Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1553338AC7D;
	Mon, 31 Aug 2026 02:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143284; cv=none; b=SD+c2y2iHkaWr8BR+vZngyobbpn2NxEfIOdLKmDDT4Pxyf2hHQuXZRkRS9iFuqhesbg2QarPmR8Bbt9oF1+pyi3u4Hinh2fAWy0frSpXxm2K3eRBprI0xNDIqlHy+0c83/XfVtfcwX+cWwAzhCa/ENyGN1mc3qAF56PPWGjywEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143284; c=relaxed/simple;
	bh=PvmddoJHEsWnr5LRcxc/6xEwcf+Y5IXgS/UbUT0ZNDc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B6KxnTTQvxu6YPyHhglHBOG6Lt+5z0+fgW1mGd8SVftzQ/RbmFUCHYiL+TZ1noF8sLNMmJcuQCQ6vvIJzpLB9HGcdNJlnvf/BLPITRPt7qqT/PmsFfhtkhQY5xJ8MtZo2YEsKpz+Fyi5t9BZFIeTCAltkLu1oigM2MomcFhp5Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaIDTx4D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaIDTx4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784271F000E9;
	Mon, 31 Aug 2026 02:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788143270;
	bh=a00nxVyRL8NXFQRkwbec2IgYxyyFB9Ys24l1ESfCubs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KaIDTx4Da8XvMV1KXWF2nsi2i4yr4hodQhFGmgTfNFZ1E4MKAtx/xSQgW7iY7XSI6
	 LtK9rsnoDHOjC3AV3McIutw+Xwzmd1ilKuxeiLhLVsC5acM4h7ttsilWlYLw4/6PgJ
	 Pmpf4cFgDcuJGftcem4kZwkWMZN1dn4vmKre+6YqQFkSdralUYZkh46FtKJdqGIJB+
	 IxIOzSzFUk1/r/BOfEDCnD2tDFNGXM6YzdAWTKvZKOahdWDuCslgp9tCYD4P/fxTWa
	 2BtodOeaZQdzn7C8l0C/wPLxOOrm4IeSX19COt/K/DEH+LXqCB3ZxawaPPLv0FCG3q
	 cUWiGgCcux/cA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 30/37] scsi: ibmvscsi_tgt: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-ide@vger.kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260831020451.585944-31-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-31-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:27:50 +0000
Message-Id: <20260831022750.784271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing `SAM_STAT_CHECK_CONDITION` assignment causes sense dat=
a to be ignored on DMA failure, resulting in silent data corruption.
--

commit 9055c36d0afa69c58f35f6c4cc3a76397be71645
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: ibmvscsi_tgt: use 16-bits defined sense codes

This commit refactors the IBM virtual SCSI target driver to use
scsi_set_sense_buffer() and defined sense code enums instead of
hard-coded values. This improves code clarity and self-documentation
without intending any functional changes.

> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
> index 61f6828007654..e2af90b6da39b 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3757,9 +3757,8 @@ static int ibmvscsis_queue_data_in(struct se_cmd *s=
e_cmd)
>  		dev_err(&vscsi->dev, "srp_transfer_data failed: %d\n", rc);
>  		se_cmd->scsi_sense_length =3D 18;
>  		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
> -		/* Logical Unit Communication Time-out asc/ascq =3D 0x0801 */
> -		scsi_build_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
> -					0x08, 0x01);
> +		scsi_set_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
> +				      LU_COMMUNICATION_TIMEOUT);
>  	}
> =20
>  	srp_build_response(vscsi, cmd, &len);

[Severity: Critical]
This is a pre-existing issue, but does this error path properly notify the
initiator of the failure?=20

When srp_transfer_data() fails in ibmvscsis_queue_data_in(), the sense
buffer is built, but it appears se_cmd->scsi_status is never set to
SAM_STAT_CHECK_CONDITION.

Because the status remains 0 (SAM_STAT_GOOD), when srp_build_response()
is subsequently called, the check for rsp->status evaluates to false:

srp_build_response()
    ...
	rsp->status =3D ibmvscsis_fast_fail(vscsi, cmd);
	if (rsp->status) {
		...
		if (se_cmd->scsi_sense_length && se_cmd->sense_buffer) {
			rsp->sense_data_len =3D cpu_to_be32(se_cmd->scsi_sense_length);
			...

This causes the built sense data to be skipped, returning a success
response to the initiator despite the DMA transfer failing. Can this lead
to silent data corruption where the initiator incorrectly assumes the read
was successful?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D30
