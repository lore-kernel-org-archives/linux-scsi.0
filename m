Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E99B28690
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 21:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782855237; cv=none; b=X9uARZHUEVtxocjm6o8z7ttfwuFJmtxcw0O/VgdJIcqPwLSNUK2IeoHOvX5BAwz9x8sa32HT7TVAW027+JK/AJuJ28yNVGkIfNvOxMeyFh6Sz3kazhJGfcpukLsI+tWKA1JlxMn11TA4pe/766Qg0PC2P2HyPMrn8FkyQLA2Q4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782855237; c=relaxed/simple;
	bh=FfBVfHzv5namIa+rD9Xbtnw4eccVvGzW06xXiQQoMsQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DToG+jd6COub+FG0grzvSK2P4SpjGt7ZC/HYOlLUR0fp2MokBNm9J1imw4kd8Ao+VHhzlOF+ndK8ChLORP8yb/PFVeUAVtIVgVksY6L/fSGfDUcp+lkBPwToDA7262UnMD3ZAOM17KlKGrj8um6AghvQjGMs5uaG8CJy8rccNoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9Q4DK+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9Q4DK+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C300F1F000E9;
	Tue, 30 Jun 2026 21:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782855235;
	bh=XdNzjhtrXRrBfK4RZ5zAJeQf9XRR8DQ5B3JpB1Ic5+w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K9Q4DK+D8lI8NOiIGcOsCA6nTSH6qjCJsge7931vB23y7P0yoOMOD1GV+R9N+v74r
	 6EhmgpCSg5s6ePqkVQ4aERDDh+1EdFeVik+Q1DEYNa4KRglI53aM1M/13jYP3BgZZ3
	 id8gxDCnrQh9g5NdCW6y0nX5LBUqzegtsxYphmzwyu+KGZs9jLwigsJ9fPtt+vhblr
	 L4NROSdj7MgvQKfBGmoKnOAsZ2QCZ3EH8l5y3QJIfy7wc2Tw43mUnDstWzFGO7egaa
	 ewIArAbAo2obyv/sq4OnhqhoxcqyuqYu5S3/YLqSzyo7wT3vAnT7mUsQKyJlifbjSb
	 tNKSqUI4TjloA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: 3w-9xxx: validate ioctl result buffer lengths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yousef Alhouseen" <alhouseenyousef@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260630211900.50548-1-alhouseenyousef@gmail.com>
References: <20260630211900.50548-1-alhouseenyousef@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 21:33:55 +0000
Message-Id: <20260630213355.C300F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Unvalidated oldcommand->size in TW_IOCTL_FIRMWARE_PASS_THROUGH=
 allows arbitrary physical memory DMA (Privilege Escalation).
- [High] Missing buffer length check for TW_OP_AEN_LISTEN in 3w-xxxx.c allo=
ws a 0-length allocation and an out-of-bounds write.
- [Medium] Lockless access to the event queue in twa_chrdev_ioctl leads to =
data races with the hardware interrupt handler.
--

commit 2334694dbb5a411bd3dbe914b4286f0439a2acf2
Author: Yousef Alhouseen <alhouseenyousef@gmail.com>

scsi: 3w-9xxx: validate ioctl result buffer lengths

Several management ioctls copy a fixed-size event, compatibility record,
or lock structure into the flexible data buffer without checking the
user-supplied buffer length. This commit determines the minimum data length
for each fixed-result command before allocating the ioctl buffer and rejects
undersized requests.

> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index a56a7b243e91f..96ef9ca346c6a 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
[ ... ]
> @@ -675,6 +676,26 @@ static long twa_chrdev_ioctl(struct file *file, unsi=
gned int cmd, unsigned long
>  		goto out2;
>  	}
> =20
> +	switch (cmd) {
> +	case TW_IOCTL_GET_COMPATIBILITY_INFO:
> +		min_buffer_length =3D sizeof(TW_Compatibility_Info);
> +		break;
> +	case TW_IOCTL_GET_LAST_EVENT:

[Severity: Medium]
This is a pre-existing issue, but does lockless access to the event queue in
twa_chrdev_ioctl() lead to data races with the hardware interrupt handler?

In twa_chrdev_ioctl(), event retrieval reads tw_dev->error_index, copies fr=
om
tw_dev->event_queue, and updates its retrieved status while holding only the
ioctl_lock mutex:

    event_index =3D (tw_dev->error_index - 1 + TW_Q_LENGTH) % TW_Q_LENGTH;
    memcpy(tw_ioctl->data_buffer, tw_dev->event_queue[event_index], sizeof(=
TW_Event));
    tw_dev->event_queue[event_index]->retrieved =3D TW_AEN_RETRIEVED;

Concurrently, a hardware interrupt can fire, acquire host_lock, and execute
twa_aen_queue_event(), which modifies error_index and overwrites elements in
event_queue.

Because the ioctl path fails to acquire host_lock or disable interrupts, it
seems it can race with the ISR. This could lead to corrupted AEN events bei=
ng
copied to userspace or newly arrived events being erroneously flagged as
retrieved.

> +	case TW_IOCTL_GET_FIRST_EVENT:
> +	case TW_IOCTL_GET_NEXT_EVENT:
> +	case TW_IOCTL_GET_PREVIOUS_EVENT:
> +		min_buffer_length =3D sizeof(TW_Event);
> +		break;
> +	case TW_IOCTL_GET_LOCK:
> +		min_buffer_length =3D sizeof(TW_Lock);
> +		break;
> +	}
> +

[Severity: Critical]
This is a pre-existing issue, but can unvalidated oldcommand->size in
TW_IOCTL_FIRMWARE_PASS_THROUGH allow arbitrary physical memory DMA?

A user can issue TW_IOCTL_FIRMWARE_PASS_THROUGH with an oldcommand format a=
nd
an artificially large size value. In twa_load_sgl(), the kernel overwrites
only the first scatter-gather (SG) list entry (sgl[0]) to point to its secu=
re
DMA buffer, but it fails to truncate or validate oldcommand->size:

    sgl->address =3D TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache)=
 - 1);
    sgl->length =3D cpu_to_le32(length);

    oldcommand->size +=3D pae;

It leaves subsequent user-supplied SG entries intact. The hardware firmware
will process size DWORDs and consume the subsequent, maliciously crafted SG
entries (sgl[1], sgl[2], etc.) to perform DMA directly to/from arbitrary
physical addresses.

Since twa_chrdev_open() lacks a capable(CAP_SYS_ADMIN) check, can any
unprivileged user who can open the device node reach this to gain arbitrary
physical memory read/write?

[Severity: High]
This isn't a bug introduced by this patch, but it appears a similar missing
buffer length check was left unpatched in drivers/scsi/3w-xxxx.c for
TW_OP_AEN_LISTEN. Does this allow a 0-length allocation and an out-of-bounds
write?

In tw_chrdev_ioctl(), if a user sets data_buffer_length to 0 during a
TW_OP_AEN_LISTEN operation, data_buffer_length_adjusted becomes 0. The DMA
allocation allocates exactly sizeof(TW_New_Ioctl) - 1 bytes, aligning the e=
nd
of the buffer right before tw_ioctl->data_buffer.

The ioctl then executes a memcpy writing beyond the allocated boundary:

        case TW_OP_AEN_LISTEN:
            ...
            memcpy(tw_ioctl->data_buffer, &tw_aen_code, sizeof(tw_aen_code)=
);
            break;

Can this write 2 bytes (sizeof(tw_aen_code)) past the end of the DMA
allocation, potentially causing memory corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630211900.5054=
8-1-alhouseenyousef@gmail.com?part=3D1
