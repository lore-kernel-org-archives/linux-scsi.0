Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD9A3ACA43
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406978; cv=none; b=a5PCNkYFY8XF6fQ01iOkbJd4UBmNedztUvk4+Ibwftno84hfmRYm7WF5BRbhA0cNPU58v5AvzHt9wXWOK9wRuEH92TiZ0uAxlga0RjwhP96vppep2e+nVNljT80oLYSEMetGjyCAhMZ5DdqnTDqg21Y9iZblhzmIT0UIBOdnduA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406978; c=relaxed/simple;
	bh=18U2qX5uAop/9q270QeOfHARMuIHKcHmWevG1k7KpM8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D3p5Vw9FunbpnSDsSJJtsJJhUZxFOHyRrt6JtUzy7M7mYrcv4nPhcSfPPJ0dWcaU30QnMr2luMiWKKBaxwbr0Yx+447Z1JzOebfJKiLTc9Qb6DWoiERytKcChJZUG9snddQh5I5In4u2dw3bol2YuSJlPJxNoUtr5UI4f9pn0J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LG83wCYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LG83wCYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFC51F00A3A;
	Tue,  7 Jul 2026 06:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406974;
	bh=rpFko+ZNRS3kP3Qxs73HZTLOKlbUsw44ORDo+auOhTk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LG83wCYKggC41smDBrmpZRZSYMhBBdi3coNK2jJlv9A4rOdmiDK/1pV4N3uwS2TNd
	 IQHr0jobJj5nQkQIeOFa8bUnc8PRZ6fHbjBxfIOQQLrgYZNAC5tT9xY4NtWL9SmtWl
	 HGHlIhHGVP88ZCvQoanvrghxQPJJvH9xmpJvxxvbE4lVdW28xc3jE/z7SxLQ3g3AvS
	 +vavJ8qwxnQdUDJwaiB82l71MxsIWnfTfGj6N5dquUaI1FvbU/LVhooTvIyiiqrnPm
	 keRYV+FrQQwswQILj+7fkAjc+r7QUYWKCvUC0rX2R9aazIcCSsO3onnD13NOZ97eiC
	 YyeknaU4lG8gQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 41/88] scsi: qla2xxx: Replace __le16 bitfields with
 scalar and accessors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-42-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-42-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:49:33 +0000
Message-Id: <20260707064933.EFFC51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch fixes endianness issues for `__le16` bitfields in 29xx e=
xtended IOCBs, but misses the identical bitfield layout bug in `struct vp_r=
pt_id_entry_24xx_ext`.

Pre-existing issues:
- [High] Target mode structures rely on `uint8_t` bitfields that are broken=
 on big-endian architectures.
--

--- Patch [41]: [PATCH v3 41/88] scsi: qla2xxx: Replace __le16 bitfields wi=
th scalar and accessors ---
commit 2a52cf1de747d5bdd6a7b2e026697c3d01b78f41
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Replace __le16 bitfields with scalar and accessors

This commit fixes endianness issues for __le16 bitfields in the 29xx extend=
ed
IOCB structures by replacing them with a single __le16 scalar field and
accessor functions. It applies this fix to els_entry_24xx_ext,
els_sts_entry_24xx_ext, and abts_entry_24xx_ext to prevent incorrect bit
positions on big-endian hosts.

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
Are there other structures in this file that require a similar update?

It appears struct vp_rpt_id_entry_24xx_ext uses a similar __le16 bitfield=20
layout that could result in hardware payload parsing corruption on=20
big-endian systems:

struct vp_rpt_id_entry_24xx_ext {
	...
	__le16 vp_idx : 9;
	__le16 vp_status : 7;
	...
}

If left unpatched, could qla24xx_report_id_acquisition() read incorrect=20
VP IDs and statuses during firmware responses on big-endian platforms?

[Severity: High]
This is a pre-existing issue, but does the target mode code suffer from a=20
similar problem?=20

Looking at struct abts_recv_from_24xx and struct atio7_fcp_cmnd in=20
drivers/scsi/qla2xxx/qla_target.h, they use uint8_t bitfields directly mapp=
ed=20
to hardware structures without endianness protections:

struct abts_recv_from_24xx {
	...
	uint8_t reserved_3:4;
	uint8_t sof_type:4;
	...
}

struct atio7_fcp_cmnd {
	...
	uint8_t task_attr:3;
	uint8_t reserved:5;
	...
}

Could these declarations cause hardware payload corruption on big-endian=20
hosts for target-mode FC communication, given they lack the usual endiannes=
s=20
guards?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D41
