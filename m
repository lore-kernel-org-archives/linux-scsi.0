Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF3838D6A8;
	Mon, 31 Aug 2026 02:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143427; cv=none; b=iATLC7LEPMnV8/NsVfeqbOGJEpn2Vg3hrcX9swmcgs5LWJ/M4Zh4DPTQTHy9eIePfTtYJ905MhF8UeIZmpfVamFYK6c+m1eeqENgf7QqmpF3SO1Wx+HSRHR+fWjlnCokuwV/AnWJAa9OKcryhFmBlElsm/Kv4KwIskhGIOeDqdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143427; c=relaxed/simple;
	bh=VYYun25ij8vgNROCly+/55YsTo7X9QTx3o6qwnnKM/A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L7JZeXDF9mfczeAWZt0y4+aDcukSeGoAnCSAenUjAbqjnmm2RcEEjA/C/pTyGrB1FaU4vtEIOy1r81odHSxscD5U8kg1wd/7TUpAdrAtMPUK/RJifDZZvUheUK14PS+sn22xm24Nfy8pAUr8sgL5KX87aBF+40SMw9jj3OpS58A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqWt4pGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqWt4pGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9460B1F000E9;
	Mon, 31 Aug 2026 02:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788143412;
	bh=l2gtNxIOimXTZXuc0VLVOOcOJzIk2nJCV9hzX+KOcpw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eqWt4pGLQ3aC4ka7f0hTVGAurBCxLFt1rAuYTisAH0Mmbgi+e0S/ACTP9b8VtSwmz
	 Mya8Hg4QgVdUiN9m4UdsJuCc+Il1li0Xrh2AVnpBfGQgddMelz69dkR2h5tLqCvbNg
	 r2jBMZQV1Ishix62Or3rFfU+WXa4u1O01zJvnkGSBfCSb5ms/U7rfPMVsOlGcZiK64
	 yXd4+dgh4PSBY6Ff7DHU39IHCoV13rw1be4GsgkXlaw9kcYVz0FvC5DKUKLYAx9rqm
	 6MbdN9lVhTnTCg3I2pFwl17riLcJdSzU6hDSkjjZkvwD7WwfaKq4/r7cbH6pOOSWvW
	 kuneBZkfH2A9A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 22/37] scsi: myrX: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260831020451.585944-23-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:30:12 +0000
Message-Id: <20260831023012.9460B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing check for scsi_dma_map() returning an error (-ENOMEM), lea=
ding to out-of-bounds DMA, uninitialized DMA memory usage, or memory corrup=
tion.
- [High] Missing scsi_done() call on REQUEST_SENSE command completion.
--

commit 3566a2a2b43f8a90937be5314f52e6262a307f13
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: myrX: use 16-bits defined sense codes

Refactor the Mylex RAID controller driver to use scsi_set_sense() and the
16-bits sense_code field of struct scsi_sense_hdr and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 3678b66310ed0..e7d796add9864 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
[ ... ]
> @@ -1493,8 +1495,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(s=
truct Scsi_Host *shost,
>  		return 0;

[Severity: High]
This isn't a bug introduced by this patch, but does this code miss a call to
scsi_done() on REQUEST_SENSE command completion?

A SCSI command completes but its completion callback is never invoked. The =
block
layer and SCSI midlayer are left waiting indefinitely for the command to fi=
nish,
leading to an I/O hang followed by SCSI timeout and error recovery:

drivers/scsi/myrb.c:myrb_ldev_queuecommand() {
    ...
	case REQUEST_SENSE:
		myrb_request_sense(cb, scmd);
		scmd->result =3D (DID_OK << 16);
		return 0;
    ...
}

>  	case SEND_DIAGNOSTIC:
>  		if (scmd->cmnd[1] !=3D 0x04) {
> -			/* Illegal request, invalid field in CDB */
> -			scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x24, 0);
> +			scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +				       INVALID_FIELD_IN_CDB);
>  		} else {
[ ... ]
> @@ -1544,8 +1546,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(s=
truct Scsi_Host *shost,
>  		block_cnt =3D get_unaligned_be32(&scmd->cmnd[6]);
>  		break;
>  	default:
> -		/* Illegal request, invalid opcode */
> -		scsi_build_sense(scmd, 0, ILLEGAL_REQUEST, 0x20, 0);
> +		scsi_set_sense(scmd, 0, ILLEGAL_REQUEST,
> +			       INVALID_COMMAND_OP_CODE);
>  		scsi_done(scmd);
>  		return 0;
>  	}

[Severity: High]
This is a pre-existing issue, but does this code proceed without checking if
scsi_dma_map() returned a negative error code (like -ENOMEM)?

If scsi_dma_map() fails, the driver does not check for < 0 and assigns the
negative value to mbox->type5.sg_count (which is cast to an unsigned 8-bit
integer, e.g. -12 becomes 244):

drivers/scsi/myrb.c:myrb_ldev_queuecommand() {
    ...
	nsge =3D scsi_dma_map(scmd);
	if (nsge =3D=3D 1) {
    ...
	} else {
    ...
		mbox->type5.sg_count =3D nsge;
    ...
}

This would cause the hardware to execute a scatter-gather DMA reading hundr=
eds
of uninitialized SGEs from memory, leading to wild out-of-bounds DMA
reads/writes, memory corruption, or IOMMU faults.

A similar issue exists in drivers/scsi/myrs.c where the result is only chec=
ked
against 1:

drivers/scsi/myrs.c:myrs_queuecommand() {
    ...
	nsge =3D scsi_dma_map(scmd);
	if (nsge =3D=3D 1) {
    ...
	} else {
    ...
		if (nsge > 2) {
    ...
}

Are these missing failure checks for scsi_dma_map() intentional?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D22
