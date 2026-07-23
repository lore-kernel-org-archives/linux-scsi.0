Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C42D381E88
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 20:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784837135; cv=none; b=XI/BEUndM4G3AMQh7MSj7VBGYCVLISPVep0nphf73CkQjwd9zufUnCxl/6MaYug1Wm6jtVjZef/8oy+THf6UttMAob2+dnXyJDMVPrjNc2B5wtVHL/ovMnxX5LF6+RtCbwCZwPOJSJVXP+TW9cdVQ8so9QGmWZP/zCy8MLBA1eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784837135; c=relaxed/simple;
	bh=0Il4jFv8/TBk8vzfFx8gA+g1O/sWnIqpmOb++wTZGfM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fvzF2gsa+WaeDQVFDdWFCB5w89UPdoyie6IauwzfcbfQuPMtx0ctHqffeYBtT6IVVSZMRV9srhLnv5fGdPe6kvuYGHGXt+xSNx7ja2xUD2o+SoqNAn4zwX9WjBBVFIf90+M/Hlju9F0yi004fTsUtQUkDQVh0Q50Lme5g3QYRzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MB3n2f7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MB3n2f7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DF81F000E9;
	Thu, 23 Jul 2026 20:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784837132;
	bh=TY71AR4tcNYIvsnrs5hQxGxh9kpX1yfWt6AXoN6Qhdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MB3n2f7iv8NkIMc3Tw3nz2T06RMEs1CgO2bnR9sC6omp6Qp26tnM+/R9280oDa4cV
	 rBtNBENXWCuxVK2RbSCKr1f5588WX8VlOdPheJP03A4J6ML30u5eUVoFLamrjWt934
	 7BcEnAeS7j2t5en/lddhDX/1iIHILOnx5hqkoYj7+iu1G4L2KY4T7V2MfONoDv3T+F
	 kvgeSGZfyr7WV7MkTsaCYLhllpXcHtXYp4tc3ItljkMTvGgza0qe02ITPQ8B14ykte
	 bAHFyOi/7+B1LCYlzVULwVajq/WWM4eD4RhqC4Yot8GQ0s6WeC1vUpioG3+baKE/4f
	 ri1g/w3Ixkk1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 54/56] scsi: qla2xxx: Fix BSG job leak on validate
 flash image error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-55-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-55-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 20:05:32 +0000
Message-Id: <20260723200532.C8DF81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds check on `request_len` allows out-of-bounds heap re=
ad when accessing the variable-length `vendor_cmd` array from user-supplied=
 BSG requests.
--

--- Patch [54]: [PATCH v6 54/56] scsi: qla2xxx: Fix BSG job leak on validat=
e flash image error path ---
commit 9de1723bd73d3b6f0fef869a49941dbe6b59c23b
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix BSG job leak on validate flash image error path

qla28xx_validate_flash_image() returns QLA_SUCCESS (0) unconditionally,
telling the FC BSG transport that the driver owns and will complete the
request. But bsg_job_done() was guarded by "if (!rval)", so on the error
path neither the driver nor the transport completes the job, leaking
resources. This commit removes the guard and always calls bsg_job_done().

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 4a9cf8da67a6b..76c57e574c220 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -3796,9 +3796,8 @@ static int qla28xx_validate_flash_image(struct bsg_=
job *bsg_job)
>  	bsg_reply->result =3D DID_OK << 16;
>  	bsg_reply->reply_payload_rcv_len =3D 0;
>  	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> -	if (!rval)
> -		bsg_job_done(bsg_job, bsg_reply->result,
> -			     bsg_reply->reply_payload_rcv_len);
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);

[Severity: High]
This is a pre-existing issue, but does this BSG ioctl path allow an
out-of-bounds heap read if userspace provides a maliciously small request_l=
en?

When a process with CAP_SYS_RAWIO issues a BSG ioctl specifying
FC_BSG_HST_VENDOR with a small request_len (e.g., 4 bytes), the transport
layer expands cmdlen but never re-validates job->request_len:

drivers/scsi/scsi_transport_fc.c:fc_bsg_host_dispatch() {
    ...
    cmdlen +=3D sizeof(struct fc_bsg_host_vendor);
    if ((shost->hostt->vendor_id =3D=3D 0L) ||
        (bsg_request->rqst_data.h_vendor.vendor_id !=3D
         shost->hostt->vendor_id)) {
    ...
}

This leads to an immediate out-of-bounds read of vendor_id. Later in the
qla2xxx driver, the handler unconditionally reads vendor_cmd[0] before
verifying the message code:

drivers/scsi/qla2xxx/qla_bsg.c:qla24xx_bsg_request() {
    ...
    if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D=20
            QL_VND_MANAGE_HOST_PORT ||
        bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D=20
            QL_VND_GET_HOST_STATS)
    ...
}

And specifically for the validate flash image command, it blindly reads
vendor_cmd[1] without verifying the request buffer is large enough:

drivers/scsi/qla2xxx/qla_bsg.c:qla28xx_do_validate_flash_image() {
    ...
    img_idx =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
    ...
}

Should there be a bounds check on request_len in fc_bsg_host_dispatch() or
the driver to prevent this?

> =20
>  	return QLA_SUCCESS;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D54
