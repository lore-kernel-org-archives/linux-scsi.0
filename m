Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972F9334C08
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405425; cv=none; b=JjpaKVOyPPipKyhPx5C8cRUAybswPlgK/HGlTE6Khvrt1I8j2mLwQ0X2YuBG39kcQuItQmxDDu2JML2HvXzBz1cZKTU7eB4izfyyxPt0p0m1ZpYzW95jjJMpz4rp4mY/+L101zEe2gQsQUoT0Rw1ZM7x06+bFu5g0/0qs0ZnC44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405425; c=relaxed/simple;
	bh=sCjHrZ+2gDUgkk9pGcS2Ow1+H/bVijj5fEJ2wZpv2h8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BOaKY7Yo/0bETrilgK0EfE3R7LyqnXNX2E4a0z27I246i4JafHsa2H7OJAAD9pIhhbsEbZXlkoVuJsKfO59F7GDRjwiOELafe2H6tvrMBGNtY3dcgLIjGyLZbLf07afU2ELbBtgzdk/IPumRPpVYlq1lWdahZfxIXNG2FPJ7JEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQVoixns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQVoixns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DC01F000E9;
	Tue,  7 Jul 2026 06:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405424;
	bh=7kTApiD/TSZDK//XWKQdKgqxYQLlNIgPEXr6Odk9DFw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DQVoixnsUQtk6wJzaTXyYfUjdS3yKCWObVV8k9v43JgeXmvRhDVoVEvKtMgzpefhM
	 YtdXPB+CbXbkHAWEE3Jezp2n8DLuiW13UwnLKtKhK5raJA1Ro2tRUMHe/XjcVn/Yrv
	 /g/XDCiPAfhkAWH6+z+B++SLfafUbSt58hWGK/JbhYBTGkpn2Fw0OWZk4GsZ+cXue6
	 ahN1tQSCzv+hKbrPzm5prQWxSuZxsTyI4J8TpkstF4/C0zb7r0oj6O/FErLvC2SXUO
	 /3r8XtWw19iErHtb5p3imdfbN8oZRGrRIe65Vit0wPC7+s7a86M/6mnBIUoz+3C5f/
	 8A5baL9cgOSHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 15/88] scsi: qla2xxx: Extend execute_fw mailbox to
 include 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-16-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-16-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:23:43 +0000
Message-Id: <20260707062344.18DC01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Structure mismatch when preparing CT/FDMI MS IOCBs for QLA29XX=
 adapters results in firmware executing wild DMAs using uninitialized garba=
ge addresses.
--

--- Patch [15]: [PATCH v3 15/88] scsi: qla2xxx: Extend execute_fw mailbox t=
o include 29xx ---
commit 29bbcde0cc31e2b4641ba7302984a3c7980dc0ef
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Extend execute_fw mailbox to include 29xx

Add IS_QLA29XX() to the BPM capability macros and to the
execute-firmware mailbox command so that NVMe enable, minimum
speed negotiation, 128 Gbps speed reporting, EDIF hardware
detection, and FW-semaphore retry logic all apply to 29xx
adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c

[ ... ]

> @@ -727,14 +728,13 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t r=
isc_addr)
>  				    ha->lr_distance << LR_DIST_FW_POS;
>  		}
> =20
> -		if (ql2xnvmeenable && (IS_QLA27XX(ha) || IS_QLA28XX(ha)))
> +		if (ql2xnvmeenable && (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(=
ha)))
>  			mcp->mb[4] |=3D NVME_ENABLE_FLAG;
> =20
> -		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> -			struct nvram_81xx *nv =3D ha->nvram;
> +		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(h=
a)) {

[Severity: Critical]
Since this patch enables initialization and capabilities for 29xx adapters,
does it also need to update CT/FDMI MS IOCB preparation to use the 128-byte
extended format required by QLA29XX hardware?

When the driver sends FDMI registrations or CT pass-through commands on
QLA29xx hardware, it unconditionally prepares the buffer using the legacy
64-byte struct ct_entry_24xx format. For example, in
qla24xx_prep_ms_fdmi_iocb():

drivers/scsi/qla2xxx/qla_gs.c:qla24xx_prep_ms_fdmi_iocb() {
    ...
    ct_pkt =3D (struct ct_entry_24xx *)ha->ms_iocb;
    memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
    ...
}

And similarly in qla24xx_prep_ms_iocb():

drivers/scsi/qla2xxx/qla_gs.c:qla24xx_prep_ms_iocb() {
    ...
    ct_pkt =3D (struct ct_entry_24xx *)arg->iocb;
    memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
    ...
}

QLA29XX firmware expects the 128-byte struct ct_entry_24xx_ext format,
where lengths are at offsets 64/68 and DSDs begin at offset 72. Because
ha->ms_iocb is allocated via dma_pool_alloc without __GFP_ZERO, offsets
beyond 64 contain uninitialized memory.=20

Can this cause the 29xx firmware to read garbage lengths and DSD DMA addres=
ses
and perform wild DMAs, leading to arbitrary memory corruption or HBA firmwa=
re
panics during adapter initialization?

>  			/* set minimum speed if specified in nvram */
>  			if (nv->min_supported_speed >=3D 2 &&
> -			    nv->min_supported_speed <=3D 5) {
> +			    nv->min_supported_speed <=3D 7) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D15
