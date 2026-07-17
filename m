Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3FEE54B
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306768; cv=none; b=H2CV5W2wO7jG6q+s9p1ucpaOLMKpzL2D9z5TGW4LaUM28zfmQacU2/oari1zjxeGpsyH6DCIReYxZVf4sb1lflXMSWXEyaFViH3eiQ3vluVTunm4mHkvEff9gQh2l7WUEzV+6uFX3U/ZLC9ui+2vZZx6Vw4e042oIpI5UocktVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306768; c=relaxed/simple;
	bh=euNt+vPmifzrLPDpepwd6geJuHnrRhH81nkKH5grb2s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j6lZIr1NchCmHZ2qV9Crfp4xXGnEInCQkOekGnY60HCX8Uz6Mcsd+nhhCXvwebJ0ekmvggFekmymSvTUwEfQF1qEbI5zS35kn0lM/oDAFau+37fg4Demarl1x9o0DLUPVTj9dciPfK6uUh6vRQBEyssmenw+2i9oEG2bS5qabDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZiwcWsyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZiwcWsyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74E31F00A3D;
	Fri, 17 Jul 2026 16:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306767;
	bh=DlNxNxzmQ6iQ/alL8H858DPwf5a2exMkPp3nyeOb9aU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZiwcWsyR5ttlCXv8gomrvHktVzBBoIXci6ujLAJZ+JjJL+yIdw+yA/pkiNjtwBEEO
	 gDQKBFTr04NRuiyDpCIdMpdpvJ5qWGO1ORw4/p6o9QxJrgoFKA/jAoANfjykjGQWC+
	 vqDzoWwG9Uk60g14ASu6Uarz72qKNWBqzu32SKUueUVdn8S0FLfHeNxAFn65lRNvmu
	 WAjtX0Mz4vtwrG4UP84mNGNBZr6jmBq+4fCjLUyZL2SC04sFkRIj9nMdcRLGvE2hri
	 oQVXKstqpuLZGZRkCTwsW+Ie8Uhcpv/otyaN5wrkfI49A1EYhj/V0Gr05DPNKOYGiL
	 m0gRcc369hAaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 41/56] scsi: qla2xxx: Replace __le16 bitfields with
 scalar and accessors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-42-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-42-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:46:06 +0000
Message-Id: <20260717164606.C74E31F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Incomplete fix: `struct vp_rpt_id_entry_24xx_ext` still contains `=
__le16` bitfields, which causes endianness corruption on big-endian hosts.

Pre-existing issues:
- [High] Hardware-mapped target mode structures use `uint8_t` bitfields tha=
t are improperly packed on big-endian architectures.
--

--- Patch [41]: [PATCH v5 41/56] scsi: qla2xxx: Replace __le16 bitfields wi=
th scalar and accessors ---
commit 0d741959136e452484c2d9e17866323337b3d108
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Replace __le16 bitfields with scalar and accessors

This commit replaces __le16 bitfields in the 29xx extended IOCB structures
with a single __le16 scalar field and accessor functions. This change
addresses endianness corruption on big-endian hosts caused by C bitfield
packing order.

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
> =20

[Severity: High]
Does this patch miss replacing the __le16 bitfields in the
vp_rpt_id_entry_24xx_ext structure?

Looking at drivers/scsi/qla2xxx/qla_fw29.h:

struct vp_rpt_id_entry_24xx_ext {
        ...
        __le16  vp_idx : 9;
        __le16  vp_status : 7;
        ...
};

When the firmware sends a 29xx extended VP Report ID IOCB,
qla24xx_report_id_acquisition() extracts the port ID from the bitfield:

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_report_id_acquisition() {
        ...
        vp_idx =3D rptid_entry_ext->vp_idx;
        vp_status =3D rptid_entry_ext->vp_status;
        ...
}

On big-endian architectures, C bitfield packing allocates from MSB to LSB.
Could the vp_idx field map to the wrong bits of the 16-bit word, causing
virtual port lookup to fail and breaking NPIV operations?

[Severity: High]
This is a pre-existing issue, but do the hardware-mapped target mode
structures use uint8_t bitfields that are improperly packed on big-endian
architectures?

In drivers/scsi/qla2xxx/qla_target.h, both abts_recv_from_24xx and
abts_resp_to_24xx define bitfields:

struct abts_recv_from_24xx {
        ...
        uint8_t  reserved_3:4;
        uint8_t  sof_type:4;
        ...
};

On big-endian hosts, sof_type maps to bits 0-3 instead of bits 4-7.

When qlt_24xx_send_abts_resp() assigns the response:

drivers/scsi/qla2xxx/qla_target.c:qlt_24xx_send_abts_resp() {
        ...
        resp->sof_type =3D abts->sof_type;
        ...
}

Will the hardware receive a corrupted byte where sof_type is encoded in the
wrong nibble, breaking target mode ABTS task management responses?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D41
