Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256AC3CEB8F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 18:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784052791; cv=none; b=LDBOkqlgxv43cNYo6gusYqCiOvzuxGNI2YlI9taFfTBRloLRj4PGH8Ljd/Pv08wwDnTGdYQGznpM2QsPuADCwwxw+rMNidfwqmFfbgjD9NHml8EiDCRtl8C08PmTHcQv/FDWIGwiMBheVBu9pG7LgM5U/q9mvGXVK1TqGjWe4Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784052791; c=relaxed/simple;
	bh=0JyPicwgRRbt9eDu36wlGIK357jLh1SDj89OwcE/SZI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tZVm3idmEKtFhEMZtcjWdWSVqXzbvlJNvX8lL+mJBPWG8uHPxWZ52H7NI24A3n0lfhRiGx7DcGu96FwXsXM7H05PQDXmZQAOR3g2Ye3HuXN25fmu1UO9VqeDSkQbZpHpCn4i6WxOmAi5ABBj+jCAVNqL6T/w1BFI6qgc2oQbhxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/uUPZv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/uUPZv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629991F000E9;
	Tue, 14 Jul 2026 18:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784052789;
	bh=/0X+iNsdZ8SoQKIOz9TWdDJKMT3eOaOTHhSMAT23Gu0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H/uUPZv02/J9FxyBvfxnOhYNkGVJ7U+jO9X2sjpHcPIZVsoYYCsAZXIqilBTnqvI/
	 S16F/IB6WjfZVCIsnx56J60Ln9xdqMyRHDEZUTWjTOLIwySo3xiI4QlJkqE1HBgD7j
	 vmo3qTEIe9BiU3eOTHOkYg8yWhKFNEl5CpLJdKbM8baRFrXdF6dhIVGWkWfID3KZHn
	 OmInyrYAIH45Z6g17cGrdtP7gKZaw2jNIUaUV3e4hXHpX8TpIX9BvmlcOUM/899OPf
	 aGjRdr4VDpegFkZF94H5CFTSs0nn7eR30fgYL/lG5Qu133Yb2beKn/Hpfo0Rx3wZYC
	 8Zx7dSikI41UA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 54/56] scsi: qla2xxx: Fix BSG job leak on validate
 flash image error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-55-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-55-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 18:13:08 +0000
Message-Id: <20260714181309.629991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds checking on user-provided bsg_job->request_len allo=
ws out-of-bounds reads from the kernel heap.
- [High] DMA mapping leaks and invalid unmaps occur on failure paths when m=
apping payloads via `dma_map_sg()`.
--

--- Patch [54]: [PATCH v4 54/56] scsi: qla2xxx: Fix BSG job leak on validat=
e flash image error path ---
commit c1ae0a57e30ac8c74b5da4918b71bbf4e075035d
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix BSG job leak on validate flash image error path

This commit fixes a BSG job leak in qla28xx_validate_flash_image() by
ensuring bsg_job_done() is called unconditionally. Since the function
returns QLA_SUCCESS, the FC BSG transport will not complete the job,
requiring the driver to do so to prevent the request from dangling.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 3bf3a7b96eb50..2f73c9af418d7 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c

[ ... ]

[Severity: High]
This isn't a bug introduced by this patch, but I noticed a potential bounds
checking issue when handling user-provided bsg_job->request_len:

drivers/scsi/scsi_transport_fc.c:fc_bsg_host_dispatch() {
    ...
	case FC_BSG_HST_VENDOR:
		cmdlen +=3D sizeof(struct fc_bsg_host_vendor);
		if ((shost->hostt->vendor_id =3D=3D 0L) ||
		    (bsg_request->rqst_data.h_vendor.vendor_id !=3D
			shost->hostt->vendor_id)) {
    ...
}

Is it possible for this to result in an out-of-bounds read from the kernel =
heap?

The request_len is not validated against the new cmdlen size before accessi=
ng
vendor_id. If a user-space program creates a BSG request with a small
request_len but sets msgcode to FC_BSG_HST_VENDOR, would the transport layer
read vendor_id out of bounds?

This same pattern appears in the LLDD handler:

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_process_vendor_specific() {
    ...
	switch (bsg_request->rqst_data.h_vendor.vendor_cmd[0]) {
	case QL_VND_LOOPBACK:
		return qla2x00_process_loopback(bsg_job);
    ...
}

Does this function blindly access flexible array elements assuming they are
within the bounds of the user-provided request length?


[Severity: High]
This is also a pre-existing issue, but I found potential DMA mapping leaks =
and
invalid unmaps on failure paths when mapping payloads via dma_map_sg():

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_process_els() {
    ...
	req_sg_cnt =3D
		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
	if (!req_sg_cnt) {
		dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
		    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
		rval =3D -ENOMEM;
		goto done_free_fcport;
	}

	rsp_sg_cnt =3D dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
		bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
        if (!rsp_sg_cnt) {
		dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
		    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
		rval =3D -ENOMEM;
		goto done_free_fcport;
	}
    ...
}

If dma_map_sg() fails for req_sg_cnt, does it incorrectly attempt to unmap =
the
failed list?

Additionally, on reply payload mapping failure, it jumps to done_free_fcpor=
t,
which bypasses the done_unmap_sg label. Does this permanently leak the
successfully mapped request payload?

A similar issue appears here:

drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_process_ct() {
    ...
	req_sg_cnt =3D
		dma_map_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
			bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
	if (!req_sg_cnt) {
    ...
		goto done;
	}

	rsp_sg_cnt =3D dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
		bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
	if (!rsp_sg_cnt) {
    ...
		goto done;
	}
    ...
}

If the reply payload mapping fails, it jumps directly to done, skipping the
done_unmap_sg block. Can this exhaust IOMMU space or DMA pools over time by
leaking the mapped request payload?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D54
