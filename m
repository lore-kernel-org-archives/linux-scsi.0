Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3981B3E9286
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264758; cv=none; b=hUuG78l3OaRxNQ1T5RnpMngQ/Ziri/BSQWDhfm6NUUct3pPBPSAoUu4umIbrC7BywtwlCSmxM8beuOa9QSZwVFssIlRo6U1IThxioGk5N6vF8elTM6Ni2D8d0R7qxloPaB2HGVKzme+jAKho0K2TOuzUx5yBmtGCidC9gHCy7gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264758; c=relaxed/simple;
	bh=HEPq660xzn2FXKFXqQ8nh5uxDEtSJwaE760j+H7fc+E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RV5kRsJZCz0nnqrynBjcRipgBnifG6+34Vs9vqGF7FaLMe2ezgzX+nlP0Ses8TFhR3ycaNmdoplCQwdchvu25XkJ9TNJgr1pHamaQ9LJzvdygAVWSqYeLHLOy5rAcNLL7HEydh/96/2pLxvTELuMI22LvuWQHfVFLs/b0uCaMPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNCeh+i+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNCeh+i+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D0D1F000E9;
	Fri, 12 Jun 2026 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781264756;
	bh=LGwVi+gUKpUHSiOSj8nhRswGyLeOGXIX0hGYsljefSs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aNCeh+i+KaTjldRSm137Tw9UDiimLv7UppvDT4ZsAKgZ76l4hsmSZnN0PszXsW/X3
	 3lGDWwOqCP1PYl2o1EfhXbq58AGSCZZvqwuoRB6A8u/L48PkjQAIP07voyE86j0JeD
	 iNWqfn9/cx+snHYG9JHnkHeAyr5of/zv1lHdFwWwSMvs+l1EubH6uT/txLtDYVRvAZ
	 lEhjIzBby2can48H6t5DbHXV+tghRMsnb2bLHR9ocZYhAbouwiaWGw3NPMOJLqOD5a
	 OszxxnqaVUxBbEAfeZPezzc8sw2KSA9gwP6METh7VHl4Lctk3PJf3uV2x4r1vzpdWE
	 pXR93fnsMHEPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 60/60] scsi: qla2xxx: Bound image count in
 qla2x00_update_fru_versions()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-61-njavali@marvell.com>
References: <20260612095333.1666592-61-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:45:55 +0000
Message-Id: <20260612114556.B5D0D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Lack of bounds checking on `i2c->length` leads to severe kerne=
l stack and DMA heap buffer overflows.
- [High] The patch bounds-checks `count` but fails to verify that the user'=
s request payload actually contains enough data for the requested `count`. =
This allows the function to use uninitialized kernel stack memory.
- [High] Short user payloads leak uninitialized kernel stack memory directl=
y to user space in FRU status handlers.
- [High] The DMA pool buffer `sfp` is allocated without being zeroed, leaki=
ng uninitialized kernel DMA memory to the SFP device due to a user-controll=
ed length override.
--

commit 5c0e5610a345e0804d665fbbbd2f23719341a171
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
> index 22be6c822ddae..bcca4ef3c23e1 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -1929,6 +1929,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_jo=
b)
> =20
>  	image =3D list->version;
>  	count =3D list->count;
> +
> +	if (struct_size(list, version, count) > sizeof(bsg)) {

[Severity: High]
This isn't a bug introduced by this patch, but the patch fails to properly
prevent uninitialized stack memory use.

If the user provides a short payload, sg_copy_to_buffer() leaves the traili=
ng
portions of the uninitialized bsg array untouched:

	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
	    bsg_job->request_payload.sg_cnt, list, sizeof(bsg));

Because struct_size(list, version, count) is only checked against
sizeof(bsg), not the actual payload length, does this still allow the loop =
to
read uninitialized stack memory and write it to the SFP flash?

[Severity: High]
This is a pre-existing issue, but while we are looking at
qla2x00_update_fru_versions(), the sfp buffer is allocated without zeroing:

	void *sfp =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &sfp_dma);

If the user sets BIT_0 in image->field_address.option, qla2x00_write_sfp()
overrides the transfer length to the first byte of sfp (which is user
controlled):

drivers/scsi/qla2xxx/qla_mbx.c:qla2x00_write_sfp() {
...
	if (opt & BIT_0)
		len =3D *sfp;
...
}

Could this cause the hardware to read past the initialized 36 bytes and leak
up to 219 bytes of uninitialized DMA heap memory to the device flash?

> +		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D
> +		    EXT_STATUS_INVALID_PARAM;
> +		goto dealloc;
> +	}
> +
>  	while (count--) {
>  		memcpy(sfp, &image->field_info, sizeof(image->field_info));
>  		rval =3D qla2x00_write_sfp(vha, sfp_dma, sfp,

[Severity: Critical]
This isn't a bug introduced by this patch, but looking at the same file, th=
ere
appears to be a severe bounds checking issue in qla2x00_write_i2c() and
qla2x00_read_i2c().

The user-controlled i2c->length is an unbounded 16-bit integer passed direc=
tly
to memcpy():

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_write_i2c() {
...
	memcpy(sfp, i2c->buffer, i2c->length);
...
}

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_read_i2c() {
...
	memcpy(i2c->buffer, sfp, i2c->length);
...
}

Since sfp is a 256-byte buffer and i2c->buffer points to the 256-byte bsg
stack array, doesn't this cause a massive out-of-bounds read and stack/heap
buffer overflow if a large length up to 65535 is provided?

[Severity: High]
This is a pre-existing issue, but similar to the short payload issue above,
qla2x00_read_fru_status() also seems to leak uninitialized stack memory.

If the user provides a short payload, sg_copy_to_buffer() leaves the sr
buffer uninitialized:

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_read_fru_status() {
...
	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
	    bsg_job->request_payload.sg_cnt, sr, sizeof(*sr));
...
}

Then sg_copy_from_buffer() blindly copies it back to the user's reply paylo=
ad:

	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
	    bsg_job->reply_payload.sg_cnt, sr, sizeof(*sr));

Does this directly leak kernel stack memory to userspace?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D60
