Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E0C2F8EB4
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 17:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307871; cv=none; b=U7wTV/EIvoFWWbJSKBVvw9s64f2MXUGh8N2h/YfV8k4JST6sIznf8SUuH5q2zARBjVwWGA3ypEibSDHST4Jdxg7jPU7/0Ve5xW8R16XkcacPfSBYBx2tsxX1zTHS9M8/zbLeGWqTT19crMp1p5g7hBQkamSidYRqLoAYkFJWfP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307871; c=relaxed/simple;
	bh=q0a4Qtb9zXUoEFSp2kwfAnLxNnULWnjEpIQ2GG1CdSM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tIi/AZF7BIXzfg0HbNgKkmcywRxplFv2vBwikzbjG+HX1r/yONQ4jOO4z6kpBE7iwClYHM/mOetsl85Rs/JiMxxKhy5oBDUnldi+qaEN+S4rY4tQHGnHtYCGMRWpIV2/VJp5vff7UB85KaKW542/FiwwZOfUTRxpeAsrfGNK/rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nE31VTk8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nE31VTk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3241A1F000E9;
	Fri, 17 Jul 2026 17:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307870;
	bh=lsHWBi61KyGp7habTJ9gJJWDBJm8ZgHCEjV7CMPJMC4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nE31VTk8JuZ6UoDLbjTWLAKJwTjbLQYmq5vs+yHu7gy7FJQvj3qPcHAlQ+XdLOcXr
	 6FWeU2RAeeE5Z+TmL5QMzZiPuozf6juVPprL8tf0IaMjuX1ollNJRwO+eAR+weXCoC
	 Dut4TNCjY2PiULRCHODfjMSyU+8RS6bzIMIgvP64UHshpcpwLnWdbSYIoQZcu3wx9z
	 rgl4pIgGbd8hgM0fcNfQQfDZDIZrO+GZdWNZ5l0GnFv1vNyDbKJ1U1ojDiGHK3bxGt
	 V1e+p1dRkwHmFsd+OBQEKramKZbs3VloNQendvUwSKEGrT1fAyHe2bvhjWuTN2V7KP
	 9SwdSLN1uDVug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 55/56] scsi: qla2xxx: Bound image count in
 qla2x00_update_fru_versions()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-56-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-56-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 17:04:29 +0000
Message-Id: <20260717170430.3241A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Severe heap and stack buffer overflows in adjacent I2C BSG han=
dlers due to unvalidated length parameters.
- [High] Systemic uninitialized kernel stack memory disclosure due to lack =
of request payload length validation.
--

--- Patch [55]: [PATCH v5 55/56] scsi: qla2xxx: Bound image count in qla2x0=
0_update_fru_versions() ---
commit f53c11833e45a89be53a1b6f8eff4d77147f2782
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()

This commit introduces a bounds check in qla2x00_update_fru_versions() to
ensure the user-supplied count does not exceed the size of the local stack
buffer. It rejects requests where the declared count would cause an
out-of-bounds read.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 2f73c9af418d7..95cfdb020319d 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2043,6 +2043,13 @@ qla2x00_update_fru_versions(struct bsg_job *bsg_jo=
b)
> =20
>  	image =3D list->version;
>  	count =3D list->count;
> +
> +	if (struct_size(list, version, count) > sizeof(bsg)) {

[Severity: High]
This isn't a bug introduced by this patch, but does this bounds check
fully protect against reading uninitialized memory?

The check limits the loop count against the fixed sizeof(bsg) (256 bytes),
but it doesn't appear to check bsg_job->request_payload.payload_len.

If a user issues a BSG request with a short payload, sg_copy_to_buffer()
will only populate a portion of the 256-byte array, leaving the remainder
uninitialized:

qla2x00_update_fru_versions() {
    ...
    sg_copy_to_buffer(bsg_job->request_payload.sg_list,
        bsg_job->request_payload.sg_cnt, list, sizeof(bsg));
    ...
    while (count--) {
        memcpy(sfp, &image->field_info, sizeof(image->field_info));
        rval =3D qla2x00_write_sfp(...);
}

Could a short payload cause the loop to read uninitialized kernel stack
memory and send it to the device?

Similarly, in adjacent functions like qla2x00_read_fru_status() and
qla2x00_read_i2c(), if the initial request payload is short, could
sg_copy_from_buffer() copy uninitialized stack memory back to user space?

[Severity: Critical]
This is a pre-existing issue, but do adjacent I2C BSG handlers lack length
validation?

In qla2x00_write_i2c(), i2c->length comes from user input and appears to be
unconstrained. Could this cause a massive out-of-bounds read from the
stack into the sfp DMA pool allocation?

qla2x00_write_i2c() {
    ...
    memcpy(sfp, i2c->buffer, i2c->length);
    ...
}

Likewise, in qla2x00_read_i2c(), could an unvalidated i2c->length allow the
device to DMA up to 65535 bytes into the 256-byte sfp heap buffer, followed
by a stack buffer overflow?

qla2x00_read_i2c() {
    ...
    rval =3D qla2x00_read_sfp(vha, sfp_dma, sfp,
        i2c->device, i2c->offset, i2c->length, i2c->option);
    ...
    memcpy(i2c->buffer, sfp, i2c->length);
    ...
}

> +		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D
> +		    EXT_STATUS_INVALID_PARAM;
> +		goto dealloc;
> +	}
> +
>  	while (count--) {
>  		memcpy(sfp, &image->field_info, sizeof(image->field_info));
>  		rval =3D qla2x00_write_sfp(vha, sfp_dma, sfp,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D55
