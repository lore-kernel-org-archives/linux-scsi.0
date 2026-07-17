Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771E42F7EE4
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784308215; cv=none; b=m5yI4ExiePAJZbFv1SWNEH/28/aVBzzUtzVVATCqijnx8ZqNSb1HLkR2d1D/Lnosox/X/+22ab3E2CUMwdIOZ2EZNPBzK8cjnWkvdqGpNsBjEOeNU3NHXR266Wnp+8Xm4lfxQnQc8D2HGoIGCzMUGmkaaqJvhaRi5OYlhvxP3yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784308215; c=relaxed/simple;
	bh=TVcg1+cxsAHeJ62WHb50+LhSVS7qXtFkCEky7Dk2aes=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sU7AzE105d7BQivYs8Vz/B6SCmxLItjcMAPIteGuTmljAtKWyh1q9FECBFdnvMsEFajoi0Kx+6WtensuYrUCWx3frSwVAp6zOK3feukqnmrnCLHyKssIOxMRxhL5ZMKRyNT/FOMaubsIdRjS1zNISNvybxz1s938ReWwFCThE7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnSLg9Y2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnSLg9Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8601F000E9;
	Fri, 17 Jul 2026 17:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784308214;
	bh=TMCgXy3+HCBLo57BMZiTKoBEPYh23lDMmnrUJjGWRF0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gnSLg9Y2dns91mxdD5+FfIQq2hR9qAPK882+jwBvcGrC4qy5jFDrNAHKcs4dg/Pmz
	 ilnUu65LG9URm7P3TUEFaSDg0/T97+aPufew70l3WmBYX0fRUiiReZdVEa+zE52oHc
	 E/Pv9DaznGeoSCX7AE7H8jbLWMy6YZ4HJnCKVuEckCIHyJdZ7bgwal3oyrYARX8n0/
	 b5a0B/DSsaCtWDuNI27FZOTaeYtSWSC9nnTZCC74OWWV/vK5sc7WEvgCUDWz9lvtPu
	 RuCRNW36bUcO/V3lEHLXs05dhu6MLgt+DHktTgBvywyLdHdOiUAH3f8ZHhw0E3co0D
	 Y64mIeFSd9oXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 53/56] scsi: qla2xxx: Zero dport diagnostics buffer
 to avoid info leak
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-54-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-54-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 17:10:13 +0000
Message-Id: <20260717171014.3D8601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing bounds checks on user-provided lengths cause severe st=
ack and heap buffer overflows, as well as out-of-bounds DMA transfers.
- [High] DMA API violation: modifying a buffer via memset() immediately aft=
er mapping it for DMA.
- [High] Uninitialized stack buffer leaks kernel stack memory to user space=
 via BSG replies.
- [High] Unlocked read-modify-write of `vha->dport_status` across process a=
nd hardirq contexts leads to a data race.
- [Medium] A struct field at an unaligned offset is mapped for DMA, resulti=
ng in unsafe cache-line sharing with adjacent struct fields.
--

--- Patch [53]: [PATCH v5 53/56] scsi: qla2xxx: Zero dport diagnostics buff=
er to avoid info leak ---
commit d9e6712c9051d0111bc1221f583961121d35d896
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak

This commit changes kmalloc_obj to kzalloc_obj in
qla2x00_do_dport_diagnostics. This ensures the qla_dport_diag response
buffer is fully zeroed, preventing uninitialized fields from being
leaked to user space.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 9ee56ccd52b01..3bf3a7b96eb50 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2858,7 +2858,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
b)
>  	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
>  		return -EPERM;
> =20
> -	dd =3D kmalloc_obj(*dd);
> +	dd =3D kzalloc_obj(*dd);

[Severity: Medium]
This isn't a bug introduced by this patch, but does mapping the buf field
of this struct for DMA cause unsafe cache-line sharing?

Looking at struct qla_dport_diag in qla_bsg.h, the __packed attribute
places the buf array at an unaligned 2-byte offset:

struct qla_dport_diag {
        uint16_t options;
        uint32_t buf[16];
        uint8_t  unused[62];
} __packed;

This same unaligned buffer is then mapped for DMA:

qla_mbx.c:qla26xx_dport_diagnostics() {
    dd_dma =3D dma_map_single(&vha->hw->pdev->dev,
        dd_buf, size, DMA_FROM_DEVICE);
}

Because the struct is packed, the mapped buf array shares a cache line
with the preceding options field, which violates DMA mapping hardware
cache alignment rules. Can this lead to data corruption on architectures
with non-coherent DMA caches?

>  	if (!dd) {
>  		ql_log(ql_log_warn, vha, 0x70db,
>  		    "Failed to allocate memory for dport.\n");

[Severity: High]
This is a pre-existing issue, but is it safe to modify a buffer with
memset while it is actively mapped for DMA?

In the underlying diagnostic functions called after this allocation, the
CPU modifies the buffer via memset after mapping it:

qla_mbx.c:qla26xx_dport_diagnostics() {
    dd_dma =3D dma_map_single(&vha->hw->pdev->dev,
        dd_buf, size, DMA_FROM_DEVICE);
    if (dma_mapping_error(&vha->hw->pdev->dev, dd_dma)) {
        ql_log(ql_log_warn, vha, 0x1194, "Failed to map dma buffer.\n");
        return QLA_MEMORY_ALLOC_FAILED;
    }

    memset(dd_buf, 0, size);
}

A similar pattern exists in qla26xx_dport_diagnostics_v2(). Since the
DMA API strictly prohibits the CPU from accessing or modifying a buffer
while it is mapped for device access, could the CPU cache lines dirtied
by memset be evicted during the DMA operation and overwrite the
diagnostic test data written by the device?

[Severity: Critical]
This is a pre-existing issue, but does this code lack bounds checks on
user-provided lengths, leading to buffer overflows?

In several BSG handler paths, user-controlled lengths dictate memory
operations without bounds checking:

qla_bsg.c:qla2x00_read_i2c() {
    rval =3D qla2x00_read_sfp(vha, sfp_dma, sfp,
        i2c->device, i2c->offset, i2c->length, i2c->option);
   =20
    if (rval) {
        ...
    }

    memcpy(i2c->buffer, sfp, i2c->length);
}

Here, the user-controlled i2c->length is passed directly to the firmware
for DMA, potentially overflowing the 256-byte sfp allocation. It is then
used in a memcpy to overflow the 256-byte bsg array on the stack.

Similarly, in qla2x00_write_i2c():

qla_bsg.c:qla2x00_write_i2c() {
    memcpy(sfp, i2c->buffer, i2c->length);
    rval =3D qla2x00_write_sfp(vha, sfp_dma, sfp,
        i2c->device, i2c->offset, i2c->length, i2c->option);
}

This causes an out-of-bounds memcpy from the stack into the 256-byte
sfp heap chunk.

Finally, in qla2x00_update_fru_versions():

qla_bsg.c:qla2x00_update_fru_versions() {
    count =3D list->count;
    while (count--) {
        memcpy(sfp, &image->field_info, sizeof(image->field_info));
        ...
        image++;
    }
}

An unbounded count dictates unbounded traversal of the image pointer
beyond the stack buffer. Could these lead to out-of-bounds DMA transfers
and severe memory corruption?

[Severity: High]
This isn't a bug introduced by this patch, but does this code leak
uninitialized stack memory to user space?

There are uninitialized stack buffers populated by BSG requests that
are fully copied back to user space:

qla_bsg.c:qla2x00_read_fru_status() {
    uint8_t bsg[DMA_POOL_SIZE];
    struct qla_status_reg *sr =3D (void *)bsg;
    ...
    sg_copy_to_buffer(bsg_job->request_payload.sg_list,
        bsg_job->request_payload.sg_cnt, sr, sizeof(*sr));
    ...
    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
        bsg_job->reply_payload.sg_cnt, sr, sizeof(*sr));
}

A similar pattern exists in qla2x00_read_i2c(). If a user issues a BSG
request with a small or zero payload size, the rest of the array remains
uninitialized. Will the entire structure size then be copied back via
sg_copy_from_buffer(), leaking kernel stack frames to user space?

[Severity: High]
This is a pre-existing issue, but does this code have an unlocked data
race on vha->dport_status?

In process context:

qla_bsg.c:qla2x00_do_dport_diagnostics_v2() {
    if (options =3D=3D QLA_START_DPORT_TEST_V2 ||
        options =3D=3D QLA_RESTART_DPORT_TEST_V2) {
        dd->mbx1 =3D mcp->mb[0];
        dd->mbx2 =3D mcp->mb[1];
        vha->dport_status |=3D  DPORT_DIAG_IN_PROGRESS;
    }
}

In hardirq context:

qla_isr.c:qla2x00_async_event() {
    ...
    case MBA_DPORT_DIAGNOSTICS:
        vha->dport_status &=3D ~DPORT_DIAG_IN_PROGRESS;
}

Both contexts modify the status field asynchronously without locks.
If the async completion interrupt fires before or during the process
context's bitwise OR operation, could the clear operation performed
by the interrupt be overwritten, permanently sticking the flag in
DPORT_DIAG_IN_PROGRESS?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D53
