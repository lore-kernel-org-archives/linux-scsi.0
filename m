Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67CE3AA9E8
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406757; cv=none; b=Eiu7FIup1+9hvHJDtczyCr7e5CDtZeVSZHbGvplozLH7cVNMYunWr8QvbBJMEJ80KN0CFYeF0IRRpwjJE0GO1SKwRBngjzIBzgyLTUNhS+E5d+9Dxh8RO0ITvySkHEiTl7lhqQ+9CPjmw3PCAYx6OSVTLN9rAIgK9ylc4Xtqo8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406757; c=relaxed/simple;
	bh=qBj+efeYvDI7zqU/JKviZ6vSjeXJAQe+ZCfmOaSpSfg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JfYH3yd6cJQ4oTEaWYPUJSplakWfOpQiiam7Xw2azT60Liq/+uwxw78wgRldIjIKku/BE8i591hPmInpwQUcuQFK8H7WbkN/hmrUYMZkz4wM0Vi1eWk0DfhQbTQ7ceaEDodMe4ox4F2in0y5nU4XdSGBZjMDooiY0M1vnjxWOuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JoNlRvtY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JoNlRvtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A56C1F000E9;
	Tue,  7 Jul 2026 06:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406756;
	bh=ukD18YgARa0G2CszQhVWtOWZFnfDndUoVyUDhd8ufpY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JoNlRvtYdlkTGkGZwWY/bFfKK/e19PBT8R1TZFmHavrHSSOu8ckMTtgB14+kBMsrm
	 7UP9ypBVE4Sx5vII+SLiglb92tOIdy80f1h42M9wX+sPK4BaE/MAzphK/lD5uPFSQx
	 NP5TF2Wv5qc5O9nt/r32pe1Y+m6HleK10fWUqa0OKUJVNihshYmMwWWZNQ5sBL1Ihx
	 wwIQ9lv1GfREeFnbqR1ispJKB6fXbjpg0IrcKca6f8IrL2NHmr+90tGWDeIQegUC+k
	 fS1w7MbLQTUNZZlMWqWgjRqYjpDH/bvJ+lbpMKBHH9Z2Qp5jfY94HjBgDyZpkPBHTu
	 BkfgmTke/W9BQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 38/88] scsi: qla2xxx: Add LS4 pass-through IOCB
 handling for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-39-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-39-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:45:55 +0000
Message-Id: <20260707064556.2A56C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Virtual Port Index (vp_idx) > 255 is silently truncated when bui=
lding extended NVMe Link Service Reject IOCBs for 29xx adapters.
--

--- Patch [38]: [PATCH v3 38/88] scsi: qla2xxx: Add LS4 pass-through IOCB h=
andling for 29xx series ---
commit ae8cdc66a77f292b668d7a567f0615478271726c
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add LS4 pass-through IOCB handling for 29xx series
   =20
Extend the LS4 pass-through IOCB handling to support the 128-byte
pt_ls4_request_ext layout used by 29xx series adapters.  The extension
grows inline DSD capacity from 2 to 5 entries.  Function signatures are
widened to void * so both layouts can be passed without casts.

> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 8fa980db6ce4e..0038b6274d444 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
[ ... ]
>  static void qla_nvme_lsrjt_pt_iocb(struct scsi_qla_host *vha,
> -				   struct pt_ls4_request *lsrjt_iocb,
> +				   void *lsrjt_iocb,
>  				   struct qla_nvme_lsrjt_pt_arg *a)
>  {
[ ... ]
> +	if (IS_QLA29XX(ha)) {
> +		struct pt_ls4_request_ext *ext =3D lsrjt_iocb;
> +
> +		ext->vp_index =3D cpu_to_le16(a->vp_idx);

[Severity: Medium]
Will this silently truncate Virtual Port Index (vp_idx) values > 255?

Looking at the definition of struct qla_nvme_lsrjt_pt_arg in
drivers/scsi/qla2xxx/qla_def.h, vp_idx is currently defined as a u8:

struct qla_nvme_lsrjt_pt_arg {
	struct fc_port *fcport;
	u8 opcode;
	u8 vp_idx;
...

Since the new 29xx extended layout expands the hardware vp_index to 16 bits,
is the value already truncated to 8 bits when passed through the vp_idx fie=
ld
of struct qla_nvme_lsrjt_pt_arg before being assigned here?

For instance, in qla_nvme_ls_req() the 16-bit vha->vp_idx is written to this
u8 field:

	a.vp_idx =3D vha->vp_idx;
	a.nport_handle =3D uctx->nport_handle;
	...
	qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);

> +		ext->tx_byte_count =3D cpu_to_le32(a->tx_byte_count);
> +		ext->rx_byte_count =3D 0;
> +		put_unaligned_le64(a->tx_addr, &ext->dsd[0].address);
> +		ext->dsd[0].length =3D cpu_to_le32(a->tx_byte_count);
> +		put_unaligned_le64(a->rx_addr, &ext->dsd[1].address);
> +		ext->dsd[1].length =3D 0;
> +	} else {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D38
