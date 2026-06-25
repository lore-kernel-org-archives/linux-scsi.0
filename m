Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92A731F9BA
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 09:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782379612; cv=none; b=JJFvZhAHCfuymOuB44V8GqbtOr8fM+QCCnGzPfoFTUqjPNj8V/UVNYliwDLa08fcgyybaTYjLLmIIw0SUg3gGabeXt4HK3bS9yB9Ef/S9gvbMst3h9TB96Bev503ojNnsfxA3bXsXbqq4eBfMLMO2P6cuCCtqhKcL5un+3+Llsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782379612; c=relaxed/simple;
	bh=UggMuLI7JhSyNTQZVqz2hLbvPksbSXSyjUPhQi/T5dg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZmgcQVwUlmQ3ioU1HF7bIHwSkCmd77z9j5AZ14NON5MLa0AXdllMIl7oQwSReE6mimGRioag0ULmXlsWEtPucGjvi+gnLQs3vNOpYLRRsLUX1XBVTNA2Rra5Ef5dhvO4Th8meBPFzvLyKi6dtyX5XznOykG7g6zKzFlWEdBL+iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfoP+dWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfoP+dWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFA11F000E9;
	Thu, 25 Jun 2026 09:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782379611;
	bh=xU1JKAUQWcBBj9dHlgsqIaiA39FMKujgg0MG0YwQVco=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UfoP+dWptGnj4P7vkFgVIMfzY2RqpcghuReTjWE+EyaRhQrc2bHBCjGZCnR1AZm0P
	 jLkPBQHU4A0acBbkaWuKxjtVgG1ENPSePeu1Zi1GHm39jLQtsmI7VyNL+p8v0hYouw
	 vbq4MlQIcRB/jSdRRlWE8GTkcMNKbtcUoDF4zndn25TVJQfWDgO3MHaYgjqjgReeAh
	 ckXiVdc0Ra58jqxtJfRzCNEGk3gWpLBRbV8nRegJizippy5I58H0BZ4ycqTuLinj7g
	 qExTU12hQ8jFUY/nzg1Yd83ial175nGjaF3E0EPgcJ1zfTzuCLMYF1GA51vSIFzvkV
	 YvLKWP3UUP7ng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: 3w-xxxx: sanitize passthrough SGLs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yousef Alhouseen" <alhouseenyousef@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260625085842.4522-2-alhouseenyousef@gmail.com>
References: <20260625085842.4522-1-alhouseenyousef@gmail.com>
 <20260625085842.4522-2-alhouseenyousef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 09:26:50 +0000
Message-Id: <20260625092651.4CFA11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The DMA buffer is freed while the hardware may still be actively w=
riting to it on timeout failure paths.
--

commit 046079df1a1f193432bc739db902b2c478f12b8c
Author: Yousef Alhouseen <alhouseenyousef@gmail.com>

scsi: 3w-xxxx: sanitize passthrough SGLs

TW_CMD_PACKET_WITH_DATA accepts a command packet from userspace and
patches only the first SGL entry before posting it to the controller. The
command size and remaining SGL contents can still describe user-controlled
DMA descriptors to firmware.

> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index c68678fa72c1e..58bab58083c08 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c

[ ... ]

> @@ -966,17 +967,31 @@ static long tw_chrdev_ioctl(struct file *file, unsi=
gned int cmd, unsigned long a
>  			/* Load the sg list */
>  			switch (TW_SGL_OUT(tw_ioctl->firmware_command.opcode__sgloffset)) {
>  			case 2:
> +				memset(tw_ioctl->firmware_command.byte8.param.sgl, 0,
> +				       sizeof(tw_ioctl->firmware_command.byte8.param.sgl));
> +				tw_ioctl->firmware_command.size =3D 4;
>  				tw_ioctl->firmware_command.byte8.param.sgl[0].address =3D dma_handle=
 + sizeof(TW_New_Ioctl);
>  				tw_ioctl->firmware_command.byte8.param.sgl[0].length =3D data_buffer=
_length_adjusted;
>  				break;
>  			case 3:
> +				memset(tw_ioctl->firmware_command.byte8.io.sgl, 0,
> +				       sizeof(tw_ioctl->firmware_command.byte8.io.sgl));
> +				tw_ioctl->firmware_command.size =3D 5;
>  				tw_ioctl->firmware_command.byte8.io.sgl[0].address =3D dma_handle + =
sizeof(TW_New_Ioctl);
>  				tw_ioctl->firmware_command.byte8.io.sgl[0].length =3D data_buffer_le=
ngth_adjusted;
>  				break;
>  			case 5:
> +				memset(passthru->sg_list, 0, sizeof(passthru->sg_list));
> +				passthru->size =3D 7;
>  				passthru->sg_list[0].address =3D dma_handle + sizeof(TW_New_Ioctl);
>  				passthru->sg_list[0].length =3D data_buffer_length_adjusted;
>  				break;
> +			default:
> +				retval =3D -EINVAL;
> +				tw_dev->chrdev_request_id =3D TW_IOCTL_CHRDEV_FREE;
> +				tw_state_request_finish(tw_dev, request_id);
> +				spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
> +				goto out2;
>  			}
> =20
>  			memcpy(tw_dev->command_packet_virtual_address[request_id], &(tw_ioctl=
->firmware_command), sizeof(TW_Command));

[Severity: High]
This is a pre-existing issue, but does tw_chrdev_ioctl() have a use-after-f=
ree
risk when handling command timeouts?

If wait_event_timeout() times out and tw_reset_device_extension() fails, the
driver jumps to out2 and calls dma_free_coherent() on the ioctl buffer:

tw_chrdev_ioctl() {
    ...
    timeout =3D wait_event_timeout(tw_dev->ioctl_wqueue,
                                 tw_dev->chrdev_request_id =3D=3D TW_IOCTL_=
CHRDEV_FREE,
                                 timeout);

    if (tw_dev->chrdev_request_id !=3D TW_IOCTL_CHRDEV_FREE) {
        retval =3D -EIO;
        if (tw_reset_device_extension(tw_dev)) {
            goto out2;
        }
    }
    ...
out2:
    dma_free_coherent(..., cpu_addr, dma_handle);
}

Since the hardware was not successfully reset, couldn't the controller still
be actively performing DMA writes to this freed page after it is returned to
the page allocator?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625085842.4522=
-1-alhouseenyousef@gmail.com?part=3D2
