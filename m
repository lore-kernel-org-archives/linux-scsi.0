Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0D436A34E
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304669; cv=none; b=TGROTjpSbDR1oJm+7E4qf159SzeFKrV1tbhsq0J7T44/QLHPZrHmZIj98XUWBakOa7/m5LZknlKWHZtfkFHswMhQkVFi4oV6DyuyiatQ0/quUxLR1fyfRo7uf3iwsFDkFb5gCDurC1Jediivv4y0XVxBdprhk4NE/0qwkNpuSVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304669; c=relaxed/simple;
	bh=KQzF2pSSkhcE3XK5MIoWeHAR8qAT9Y03agnGoo09eSU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mIntVWYPu4UefzeyurKZmf9SVXLZql2sP+EWTN7C2n91DdtodjYFAlaEYT9Ov5bKT21kS/PEv84d+kDS+kk/yAI//0ZHBFrQ5FKoOQwFHTNXdEanxA2Iwm7MRLP0+NI0XnTWmmqumPoqkBTGNrCMwRLqh4r6OPkUFNUqHmJpEU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TtfzJNcs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TtfzJNcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7AB1F000E9;
	Fri, 17 Jul 2026 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304667;
	bh=0dx1gp73NAu+toKMR56dzpS+lCGLZetxni9T4yIG4Ek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TtfzJNcs6twHrNSeUTE0jaH8O6CTURxEOOMcwB2Ivj9gNiVUTd2LR7Yz96g8xAuq3
	 zGf1T4IwDwHn2oTwLqZjoq+xVHdVmkKx6DZQ/SM4EaTCTjWjEJ1vc5itFpE0htkjzq
	 /OopXFwWfOE7PTZ5lfJsrNt16/2YZqmgoQ9CslNO9BDZJHccIdRmEQG5hkaVMvD9mP
	 HwYSKVrH4CygKcIShhLSR18xzxaT9PRnLunJO8diGgvQVI4rS6XmTeF1QAFo9W7hE3
	 cNIS9teJo610pItmQnxypDi/QiLtke9btazud7DzXIkTDA+EYM4gYPWGP0fp1bGKdA
	 o6W5AA9WAygUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 25/56] scsi: qla2xxx: Handle sts_cont_entry_ext_t for
 29xx adapters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-26-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-26-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:11:06 +0000
Message-Id: <20260717161107.4A7AB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Critical] FORTIFY_SOURCE buffer overread panic in continuation IOCB proc=
essing

Pre-existing issues:
- [High] Remote Denial of Service (Infinite Loop) via crafted payload colli=
ding with RESPONSE_PROCESSED
- [Medium] Missing read memory barrier after signature polling loop
--

--- Patch [25]: [PATCH v5 25/56] scsi: qla2xxx: Handle sts_cont_entry_ext_t=
 for 29xx adapters ---
commit 5af8ad3c722085f26948d73f06875dd765494eea
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Handle sts_cont_entry_ext_t for 29xx adapters

This commit updates all status continuation IOCB processing paths to branch
on adapter type and handle 128-byte response queue entries for QLA29XX
hardware. It modifies several functions to use the correct data payload
size and structure cast to prevent truncation.

Closes: https://lore.kernel.org/oe-kbuild-all/202607142020.gqDaApes-lkp@int=
el.com/

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c

[ ... ]

> @@ -271,10 +276,12 @@ int __qla_copy_purex_to_buffer(struct scsi_qla_host=
 *vha,
> =20
>  	do {
>  		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
> -			new_pkt =3D (sts_cont_entry_t *)rsp_q->ring_ptr;
> -			*pkt =3D new_pkt;
> +			*pkt =3D rsp_q->ring_ptr;
> +			data =3D ((sts_cont_entry_t *)*pkt)->data;
> +			data_sz =3D qla_sts_cont_data_size(ha);

[Severity: Critical]
Can this cast trigger a FORTIFY_SOURCE panic?

Looking at __qla_copy_purex_to_buffer() in drivers/scsi/qla2xxx/qla_isr.c,
the pointer data is initialized by casting the packet to sts_cont_entry_t,
which defines the data field as a statically known 60-byte array.

On QLA29XX adapters, data_sz is set to 124 bytes. When the subsequent
memcpy attempts to copy up to 124 bytes from this 60-byte pointer,
FORTIFY_SOURCE will detect a field-spanning read using __builtin_object_size
and panic the kernel with __read_overflow2.

Does this need to cast to the extended struct for 29xx adapters before
taking the address of the data field?

> =20
> -			if (new_pkt->entry_type !=3D STATUS_CONT_TYPE) {
> +			if (((sts_cont_entry_t *)*pkt)->entry_type !=3D
> +			    STATUS_CONT_TYPE) {

[ ... ]

> @@ -906,28 +915,24 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha=
, void **pkt,
>  				continue;
>  			}

[Severity: High]
This is a pre-existing issue, but could this loop spin infinitely?

Looking at the context above this diff block in qla27xx_copy_multiple_pkt(),
the driver waits for the firmware to populate the continuation IOCB by
spinning until signature !=3D RESPONSE_PROCESSED.

Since the signature field is at offset 60, it overlaps with the payload
data written by the firmware. If a remote endpoint sends a crafted
payload where the bytes at offset 60 happen to match the
RESPONSE_PROCESSED constant, the driver will never see the signature
change and will loop infinitely with interrupts disabled.

Is there a safer way to poll for DMA completion without risking payload
collisions?

[Severity: Medium]
This is a pre-existing issue, but is a read memory barrier missing here?

After breaking out of the cpu_relax() polling loop, the code immediately
reads the payload data from the ring buffer. On weakly-ordered
architectures, the CPU can speculatively load the payload data before
the signature validation completes.

Does this need a dma_rmb() after the signature check to ensure the CPU
processes the newly DMA'd packet instead of stale ring memory?

> =20
> -			new_pkt =3D (sts_cont_entry_t *)rsp_q->ring_ptr;
> -			*pkt =3D new_pkt;
> +			*pkt =3D rsp_q->ring_ptr;
> +			data =3D ((sts_cont_entry_t *)*pkt)->data;
> +			data_sz =3D qla_sts_cont_data_size(ha);

[Severity: Critical]
Can this cast also trigger a FORTIFY_SOURCE panic during memcpy?

Similar to __qla_copy_purex_to_buffer(), casting to sts_cont_entry_t
bounds the data pointer to 60 bytes, causing a panic when copying
up to 124 bytes on QLA29XX hardware.

[ ... ]

> @@ -1190,10 +1206,12 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, =
void **pkt,
>  				continue;
>  			}
> =20
> -			new_pkt =3D (sts_cont_entry_t *)rsp_q->ring_ptr;
> -			*pkt =3D new_pkt;
> +			*pkt =3D rsp_q->ring_ptr;
> +			data =3D ((sts_cont_entry_t *)*pkt)->data;
> +			data_sz =3D qla_sts_cont_data_size(ha);

[Severity: Critical]
Does this copy path also suffer from the FORTIFY_SOURCE panic?

The same 60-byte array limitation applies here when qla27xx_copy_fpin_pkt()
processes FPIN packets on QLA29XX adapters.

[ ... ]

> @@ -3691,6 +3711,7 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_=
cont_entry_t *pkt)
>  	struct scsi_cmnd *cp;
>  	uint32_t sense_len;
>  	uint8_t *sense_ptr;
> +	u8 *data =3D ((sts_cont_entry_t *)pkt)->data;

[Severity: Critical]
Can this cast trigger a FORTIFY_SOURCE panic when copying sense data?

Looking at qla2x00_status_cont_entry() in drivers/scsi/qla2xxx/qla_isr.c,
the data pointer is bounded to 60 bytes due to the sts_cont_entry_t cast.

When sense_sz exceeds 60 bytes on 29xx adapters, the subsequent memcpy
at the end of this function will panic the kernel.

Does this need to branch on adapter type to extract the data pointer safely?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D25
