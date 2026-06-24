Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C2F3DD536
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782323787; cv=none; b=OuhjcaFYjy7qMioaQFrPbTgfCcqIMx+hf+OCM/Hrn98+nsFTKb20W+nes27KSV9V6wJhIs+R3KrNLRSnWEn5PEai+qkeL7YE6mCkShngWtdV9vPP4jm0mYkUEcNlwz/vygGtYn8BSid/3e8aQ/Z40SrJfSR5XrvTD0WN/dQ6Y/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782323787; c=relaxed/simple;
	bh=/i0ainW1wdjaffWloK6I/2GvZbe9EetfowI1hIjqKXI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=onn8/1JuqQyv+OKZOO+33WPIumuV8Mi4CKd/j66fkFqE9lL9/CCCHmyTp2Sfhru4HJhMRPZmPA6TIsp3FZ51Emi4ilmOfHcFV/Ad2SxaqtorX4X5vUepSlevCHlubshz6QS151L1hdIDPDKx+A5EnCOkiclLCFr2Ukt6D71jqVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPuBDZKL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPuBDZKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA04A1F000E9;
	Wed, 24 Jun 2026 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782323786;
	bh=9UPYVgLlxZGziU8DkIzaPcedCgZ5YDimChOrNidY36s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YPuBDZKLOhadNRD8ctgrQhCve2I55SKl8vjCAge7mqHsPZXfwVlJite8AIyxUld0e
	 5SBxMSyap4YgRQme5x1RZUqD+mgnyGH+3YglzgI80D1YOo2PhF4h3YOTr3Mj++M1+0
	 K1IhQgComglOisPFGoEuUhLoXG3jkxjy4zFoptTiNr9oXaLS2aBx6NfV6MowSuK9T1
	 9xpCdWgqY4221f17mAArJDxSx4pqIPnthTopJlkwGyQcT5MDKXZJvesCn62ai6/fxE
	 nGrKtebvzSl3mAEQNRVU6A0lZcatjJGbXph7hBPG04Et01sJsQ4M+9un9hmdeiFMVE
	 QKOP5WE/2P3YA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: megaraid: cap passthrough copyout length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yousef Alhouseen" <alhouseenyousef@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624174053.5274-1-alhouseenyousef@gmail.com>
References: <20260624174053.5274-1-alhouseenyousef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 17:56:25 +0000
Message-Id: <20260624175625.EA04A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] DMA buffer overflow leading to physical memory corruption for =
non-passthrough commands.
- [High] Stale DMA buffer information leak via short reads for both passthr=
ough and non-passthrough commands.
--

commit a08c5cc745806f0bc84fe8025d810aeb7a2f7d82
Author: Yousef Alhouseen <alhouseenyousef@gmail.com>

scsi: megaraid: cap passthrough copyout length

MIMD passthrough commands store the DMA transfer length in dataxferlen.
The common ioctl path copied xferlen bytes back to userspace instead.
For read commands, a larger xferlen can expose stale DMA buffer bytes.

> diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/=
megaraid_mm.c
> index a70692779a16c..1e49b437e8e5f 100644
> --- a/drivers/scsi/megaraid/megaraid_mm.c
> +++ b/drivers/scsi/megaraid/megaraid_mm.c
> @@ -484,12 +484,14 @@ mimd_to_kioc(mimd_t __user *umimd, mraid_mmadp_t *a=
dp, uioc_t *kioc)
>  		return (-EFAULT);
>  	}
> =20
> +	if (pthru32->dataxferlen > kioc->xferlen)
> +		return -EINVAL;
> +	kioc->user_data_len =3D pthru32->dataxferlen;
> +

[Severity: High]
This isn't a bug introduced by this patch, but does this still leave an
information leak if the hardware performs a short read?

Since pthru32->dataxferlen is fully user-controlled and does not reflect
the actual byte count transferred by the firmware, a user can request a lar=
ge
transfer size but send a command that returns fewer bytes.

Because mraid_mm_attach_buf() allocates the DMA buffer without zeroing it,
won't kioc_to_mimd() then copy uninitialized kernel pool memory back to
userspace based on this inflated kioc->user_data_len?

[Severity: Critical]
This is a pre-existing issue, but while this patch fixes the bounds check
for MBOXCMD_PASSTHRU commands, what about regular DCMD commands?

Looking earlier in mimd_to_kioc(), for non-passthrough commands, the driver
copies the raw 14-byte mailbox from userspace:

	memcpy(mbox, mimd.mbox, 14);

	if (mbox->cmd !=3D MBOXCMD_PASSTHRU) {
		mbox->xferaddr	=3D (uint32_t)kioc->buf_paddr;
		...
		return 0;
	}

If a user allocates a small DMA pool buffer via a small mimd.outlen but
embeds a huge transfer size in the raw mailbox payload, there doesn't
appear to be any validation against kioc->xferlen.

When mbox_post_cmd() issues this to the firmware, could it cause an
out-of-bounds DMA transfer into adjacent physical memory?

>  	pthru32->dataxferaddr	=3D kioc->buf_paddr;
>  	if (kioc->data_dir & UIOC_WR) {
> -		if (pthru32->dataxferlen > kioc->xferlen)
> -			return -EINVAL;
>  		if (copy_from_user(kioc->buf_vaddr, kioc->user_data,
> -						pthru32->dataxferlen)) {
> +							pthru32->dataxferlen)) {
>  			return (-EFAULT);
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624174053.5274=
-1-alhouseenyousef@gmail.com?part=3D1
