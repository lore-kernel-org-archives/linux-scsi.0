Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B03360EF2
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784046287; cv=none; b=Bk+PY++IsKrhJGubOw0OSAsuheuCNpEkD4R+XQts/IYDL2SHl0b+KHUVxe8Bb+AdzVBROfegkK7xZF54JPEwQ4bbM9j+C5fEqf1NGbGA6YV3gJJeb3knm66egDFZVDVhS8GG+sfHv32Lf73rgTy5k3NzPWptXPGdnsw0X+2E5Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784046287; c=relaxed/simple;
	bh=1bb/ycaaPta/OO8czAGD4g9JdGtXO1iKZ+yYH5c0WXw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UiNeh8I2H80rJT37EY0SVbnMjb2wG36iZ7mLCN+8/EuQ7NJ768S3OB/brtQBpIyk1ffARX3uK1u7sj95tC5Y4sNezweIIhS6U7GTom2HPMzCJ9J8piPzZF4dreb7s4sZ3zS+SHenpluBzVk2sRHecb7PHiT+S8+rbuRu+ARJnBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hKesMgk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hKesMgk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC91F1F00A3D;
	Tue, 14 Jul 2026 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784046285;
	bh=bsgqgdXNyyik7aqes0KyBxKhwsI6emHHN3koyo+jELk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hKesMgk/SNrTzxny+OFxVxCqnn7cBjZgs+qqPPb2us8liwANsA6pr2XnBfgvJEQVb
	 w+jWKYoLXL3GLyEmsWaGH1FPPJv3/CGzSVGyMt0nqKGXTCHx/2AX/uqMIl9K6Yuddv
	 itCT7Twdq+PrLNfA1hW8e1obXv8wr7GmbZyyqoJ28O2lgBJzkQ2b43pABeUEKCzCpR
	 yFLbZ1PwQBwJ+yUMslVRPo0B7ndv80b5MtioFEoxpWKg2w71Q4f47UuZaeNJi4MEA3
	 I4I9AmV/em8mKJcCoiCe7mrrUzxUMRc7jQz5RoVtZNYPAbOwX+J54z4NpKW0WzTScV
	 kL+wvrJ5i6Icg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 41/56] scsi: qla2xxx: Replace __le16 bitfields with
 scalar and accessors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-42-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-42-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 16:24:45 +0000
Message-Id: <20260714162445.AC91F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The patch replaces `__le16` bitfields with scalar fields and acces=
sor functions in several 29xx extended IOCB structures to fix implementatio=
n-defined bitfield packing on big-endian hosts. However, it completely miss=
es `struct vp_rpt_id_entry_24xx_ext`, which exhibits the exact same buggy p=
attern (`__le16 vp_idx : 9; __le16 vp_status : 7;`).
--

--- Patch [41]: [PATCH v4 41/56] scsi: qla2xxx: Replace __le16 bitfields wi=
th scalar and accessors ---
commit 0cf9b60149a7b5c26196bf1b6738600fa9600e4f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Replace __le16 bitfields with scalar and accessors

Replace the three sets of __le16 bitfields in 29xx extended IOCB structures
with a single __le16 scalar field and provide inline accessor functions
that use proper le16_to_cpu()/cpu_to_le16() with shift-and-mask operations.
This fixes implementation-defined bitfield packing on big-endian hosts.

> diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_f=
w29.h
> index 600a40d8bd5ff..63bf350ddffc0 100644
> --- a/drivers/scsi/qla2xxx/qla_fw29.h
> +++ b/drivers/scsi/qla2xxx/qla_fw29.h
[ ... ]
> @@ -563,9 +586,7 @@ struct abts_entry_24xx_ext {
>  	__le16	nport_handle;		/* type 0x54 only */
> =20
>  	__le16	control_flags;		/* type 0x55 only */
> -	__le16	vp_idx : 9;		/* VP index 9 bits */
> -	__le16	reserved_1_sof : 3;
> -	__le16	sof_type : 4;		/* sof_type is upper nibble */
> +	__le16	vp_idx_sof;		/* bits [8:0]=3DVP index, [15:12]=3DSOF type */
> =20
>  	__le32	rx_xch_addr;

[Severity: High]
Does this patch miss updating struct vp_rpt_id_entry_24xx_ext which seems to
exhibit the exact same buggy pattern?

drivers/scsi/qla2xxx/qla_fw29.h:
struct vp_rpt_id_entry_24xx_ext {
    ...
	__le16	vp_idx : 9;		/* VP Index 9bits */
	__le16	vp_status : 7;		/* VP Status 7bits */
    ...
};

This structure is used in qla24xx_report_id_acquisition() in qla_mbx.c where
the improperly packed bitfields are accessed from the hardware DMA response:

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_report_id_acquisition() {
    ...
		vp_idx =3D rptid_entry_ext->vp_idx;
		vp_status =3D rptid_entry_ext->vp_status;
    ...
}

This could result in corrupted virtual port data on big-endian hosts.
Is this intentional or should it be converted to a scalar with accessors as
well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D41
