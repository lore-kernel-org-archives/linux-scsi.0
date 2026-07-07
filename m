Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2146226CF6
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407931; cv=none; b=stC8PymMB1yqpXe+nw58KRlb3REFYm/oL/Ry3RPXPvJVHtqhyTEolg/ALjTOxMK5Kx5A2ax2EuMHZMFMKcgN4DBGBaURWJjv7QxNLjaEroAzQ0baj/BumdevFW+w3FdZZa1chAwNmB/pOJDf0ClrNSodbcXQ9w/Ck7wqIODHNFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407931; c=relaxed/simple;
	bh=NoavzckI9SPJcr+qAnUZNckMiGieX1k8IAe+gjE3j/M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z0sr1hKFJ2zS7gJIlAK2tH4npohntg33SouLW5k7VquJwdDWX8NXdHZGL42QSQ0b0E7SDECQAXLe6q/Xc0kTX+xFeIvu76HkbkjIIbPu1qVRSNeKyVboP1UjIElBZci0cngy4bnlDIJgkOltNP68f4Z4FSXYI3hQz/QR1NrDUFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAwJn3bv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAwJn3bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB191F000E9;
	Tue,  7 Jul 2026 07:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407929;
	bh=DEhbFf+YT1y/Z/0vCIQuM6snqgMqJVRpJKZWWORvYUs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iAwJn3bvRG+LoX7Djj1IPcXQBx/ggf26Qvsj9HWB6UQzEhzg0EwYNulnFCZsb57Vb
	 1/TjQjaiUuAq4VHSJXcluQ95MreOJMCVsghsNr8lRvMd9KwaiWED8rDr/fPbuOUVyN
	 gsv2XS4tSEMGa/DQGweQp5+SaPnMoE6+Xv6/gCw1YA51Zw2x6Bjw2Sa2q9ckzxpA1v
	 jDPfCjMRzJ/Eg6IJBsh8WJC5GqBQftDqI/FmEHDo5K1L5gC1W4iWRUPfl1OBYfkEMF
	 FXnwrWnnXAf9o3k93yfvgHIuSC9j/0sOKeIP0gMTPaaQPUFTTkA6Bbag/WxHcJIgw5
	 uL0ubgMT/c2Jw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 55/88] scsi: qla2xxx: Bound image count in
 qla2x00_update_fru_versions()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-56-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-56-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:05:29 +0000
Message-Id: <20260707070529.7CB191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds check on user-supplied `i2c->length` in `qla2x00_re=
ad_i2c` and `qla2x00_write_i2c` leads to severe kernel stack and DMA pool h=
eap buffer overflows.
- [High] Kernel stack memory is leaked to userspace and hardware due to uni=
nitialized `bsg` stack buffers and missing payload length validation.
- [Medium] Preexisting leak of uninitialized kernel memory to user space vi=
a `bsg_reply->reply_payload_rcv_len`.
--

--- Patch [55]: [PATCH v3 55/88] scsi: qla2xxx: Bound image count in qla2x0=
0_update_fru_versions() ---
commit 649b4e1d5ee505bfadef89861d13191eb9aaf100
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()

qla2x00_update_fru_versions() copies the user-supplied BSG request into
a fixed 256-byte stack buffer (bsg[DMA_POOL_SIZE]) and then iterates
list->count times over the qla_image_version array embedded in that
buffer, advancing the image pointer each iteration. count is taken
directly from user input with no upper bound, while only
(DMA_POOL_SIZE - sizeof(list->count)) / sizeof(struct qla_image_version)
=3D 6 entries actually fit. A larger count walks the image pointer off the
end of the stack buffer, reading adjacent kernel stack memory and
sending it to the device via qla2x00_write_sfp().

Reject requests whose declared count does not fit in the buffer.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1977,6 +1977,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_jo=
b)
> =20
>  	image =3D list->version;
>  	count =3D list->count;
> +
> +	if (struct_size(list, version, count) > sizeof(bsg)) {
> +		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D
> +		    EXT_STATUS_INVALID_PARAM;
> +		goto dealloc;
> +	}
> +
>  	while (count--) {
>  		memcpy(sfp, &image->field_info, sizeof(image->field_info));
>  		rval =3D qla2x00_write_sfp(vha, sfp_dma, sfp,

[ ... ]

> @@ -2005,6 +2012,8 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_job)
> =20
>  done:
>  	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
>  	bsg_reply->result =3D DID_OK << 16;
>  	bsg_job_done(bsg_job, bsg_reply->result,
>  		       bsg_reply->reply_payload_rcv_len);

[Severity: Medium]
This is a pre-existing issue, but is bsg_reply->reply_payload_rcv_len prope=
rly
initialized here?=20

Both error paths (including the newly added length check) and the success p=
ath
jump to the done label, but bsg_reply->reply_payload_rcv_len is passed to
bsg_job_done() without ever being assigned a value.

Does this leak 4 bytes of uninitialized kernel memory to user space via the=
 BSG
reply?

[ ... ]

> @@ -2012,6 +2021,21 @@ qla2x00_read_fru_status(struct bsg_job *bsg_job)
>  {
>  	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
>  	struct Scsi_Host *host =3D fc_bsg_to_shost(bsg_job);
>  	scsi_qla_host_t *vha =3D shost_priv(host);
>  	struct qla_hw_data *ha =3D vha->hw;
>  	int rval =3D 0;
>  	uint8_t bsg[DMA_POOL_SIZE];
>  	struct qla_status_reg *sr =3D (void *)bsg;

[Severity: High]
This isn't a bug introduced by this patch, but does this uninitialized bsg =
array
cause a memory leak?

If a user issues a BSG command (e.g., QL_VND_READ_FRU_STATUS) with a trunca=
ted
payload length, sg_copy_to_buffer partially populates the uninitialized 256=
-byte
bsg stack array.=20

The uninitialized data is then used in device commands and copied back to t=
he
user reply via sg_copy_from_buffer. Can this leak up to 256 bytes of
uninitialized kernel stack memory to userspace and hardware?

[ ... ]

> @@ -2115,18 +2124,31 @@ qla2x00_write_i2c(struct bsg_job *bsg_job)
>  {
>  	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
>  	struct Scsi_Host *host =3D fc_bsg_to_shost(bsg_job);
>  	scsi_qla_host_t *vha =3D shost_priv(host);
>  	struct qla_hw_data *ha =3D vha->hw;
>  	int rval =3D 0;
>  	uint8_t bsg[DMA_POOL_SIZE];
>  	struct qla_i2c_access *i2c =3D (void *)bsg;
>  	dma_addr_t sfp_dma;
>  	uint8_t *sfp =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
> =20
>  	if (!sfp) {
>  		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D
>  		    EXT_STATUS_NO_MEMORY;
>  		goto done;
>  	}
> =20
>  	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
>  	    bsg_job->request_payload.sg_cnt, i2c, sizeof(*i2c));
> =20
>  	memcpy(sfp, i2c->buffer, i2c->length);

[Severity: High]
This is a pre-existing issue, but does this lack bounds checking on i2c->le=
ngth?

A user can invoke the BSG interface with QL_VND_WRITE_I2C and provide an
i2c->length larger than the 256-byte DMA pool allocation (sfp).

Will this cause an unbounded read from the stack and an unbounded write int=
o the
256-byte DMA pool buffer?

[ ... ]

> @@ -2157,20 +2179,35 @@ qla2x00_read_i2c(struct bsg_job *bsg_job)
>  {
>  	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
>  	struct Scsi_Host *host =3D fc_bsg_to_shost(bsg_job);
>  	scsi_qla_host_t *vha =3D shost_priv(host);
>  	struct qla_hw_data *ha =3D vha->hw;
>  	int rval =3D 0;
>  	uint8_t bsg[DMA_POOL_SIZE];
>  	struct qla_i2c_access *i2c =3D (void *)bsg;

[Severity: High]
This is a pre-existing issue, but does this uninitialized bsg array
cause a memory leak?

Similar to qla2x00_read_fru_status, if a user issues a BSG command (e.g.,
QL_VND_READ_I2C) with a truncated payload length, sg_copy_to_buffer partial=
ly
populates the uninitialized 256-byte bsg stack array.=20

Can this leak up to 256 bytes of uninitialized kernel stack memory to users=
pace
and hardware?

>  	dma_addr_t sfp_dma;
>  	uint8_t *sfp =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);
> =20
>  	if (!sfp) {
>  		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D
>  		    EXT_STATUS_NO_MEMORY;
>  		goto done;
>  	}
> =20
>  	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
>  	    bsg_job->request_payload.sg_cnt, i2c, sizeof(*i2c));
> =20
>  	rval =3D qla2x00_read_sfp(vha, sfp_dma, sfp,
>  		i2c->device, i2c->offset, i2c->length, i2c->option);
> =20
>  	if (rval) {
>  		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D
>  		    EXT_STATUS_MAILBOX;
>  		goto dealloc;
>  	}
> =20
>  	memcpy(i2c->buffer, sfp, i2c->length);

[Severity: High]
This is a pre-existing issue, but is there a missing bounds check on
i2c->length here as well?

If a user invokes the BSG interface with QL_VND_READ_I2C and provides an
i2c->length larger than the 64-byte stack buffer (i2c->buffer) inside the
256-byte bsg array, can this cause an unbounded copy into the fixed 64-byte
stack buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D55
