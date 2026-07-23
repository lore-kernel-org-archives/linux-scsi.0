Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B6C3B95EC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784785889; cv=none; b=QV16tGP7J4A7Y+WKuGLRhNLgqcZFzNIYpPpK5XaCVbvqT3QJTLQiwifKBC1tcBDcNHsuQN6513zGIs3EhbuIcXsUigKzkz40Zzyr74Zq02NPAWmPkMRkMuC7zHJIfM6Q4BeKby3I1lkbCP86haS/ekqXFWFZt5eQzGF/+E9MPMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784785889; c=relaxed/simple;
	bh=Y6JPlFh8W2SgZqiacSX5DHlFPskO3zKvP4ai4O4Nwso=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JyuTIyKM8kb3EVjf6ONTpifmTMku4neuQwikJbOX+eD/66q9VZvOuXar4T0mHoSuCj52Uwmx4Fd7iCDRFU2UawX/PsaHEzwxLkeJvYX2jrX+QE5O82Kynxkw/B/Tat3lm11lDmca8h9PnPFevQKN6a+EgmGwkWLxpIDwa0qrfJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U9qlA/Kb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9qlA/Kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC35A1F000E9;
	Thu, 23 Jul 2026 05:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784785881;
	bh=yVJQGhhYTFVAseFFDTSjQOGnkSl3pR4P52Tj0lluN18=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U9qlA/KbYu1ZD4aauwXIW4jxGLN5v36qYRTBNSC97UWtYpkxq6J/HgqSJ9Nn5A0dP
	 Xoja6abjn5dCowJlEuvYmOvLe0KJonwcrXLgksZa1ekuncUIC3rf0L+8xcEqq8DN1l
	 AT4osLr2LGQw246hzNf2FRjHnZZTiDuhkQ5qOLQR1gLkhnIBeNWcXCuJ2aP+n6RkcY
	 HPSdbpYppDYbEVhBO68m1Ts1O3AGlwgyKUX1ShRQH4mOYyeWx4ogwGaBOPVvlfw9ou
	 6Cn8Ji6Y0qRbPtF7+Kf9baYOV4X3dhlB4RP4HSRmEXP7Uw9RqJ+BO5T5NMIKzOK7hl
	 GMj4PfaqkCu+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 02/56] scsi: qla2xxx: Add flash read/write interface
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-3-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 05:51:21 +0000
Message-Id: <20260723055121.AC35A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The new 29xx-specific flash read/write handlers (`qla29xx_read_opt=
rom_data` and `qla29xx_write_optrom_data`) are not wired into the `isp_ops`=
 table, breaking generic sysfs/bsg flash infrastructure for 29xx hardware.
--

--- Patch [2]: [PATCH v6 02/56] scsi: qla2xxx: Add flash read/write interfa=
ce for 29xx ---
commit dc1689f4151bef091f39c3e7154f59adc5ea0501
Author: Manish Rangankar <mrangankar@marvell.com>
scsi: qla2xxx: Add flash read/write interface for 29xx

This patch adds mailbox wrappers and helper functions to support flash read
and write operations for the 29xx series adapters. It also intends to wire
these operations into the existing flash infrastructure.

Link: https://lore.kernel.org/oe-kbuild-all/202607141520.k9T31Dpp-lkp@intel=
.com/

>     The 29xx series uses a different flash access mechanism than
>     earlier adapters.  Add the mailbox wrappers and qla_sup helpers
>     needed for flash read and write operations, including the
>     necessary hooks in isp_ops so that the existing flash
>     infrastructure can drive the new hardware.

Is this commit message accurate? The patch introduces the new 29xx-specific
flash handlers, but it does not appear to register them in the isp_ops tabl=
e.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c91d2b8bd08e7..ebb97329e6eac 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3237,6 +3237,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struc=
t pci_device_id *id)
>  		ha->flash_data_off =3D ~0;
>  		ha->nvram_conf_off =3D ~0;
>  		ha->nvram_data_off =3D ~0;
> +		ha->flt_segment_length =3D QLA_SEGMENT_LENGTH;
>  	}

[Severity: High]
Will this cause the generic sysfs/bsg flash infrastructure to crash when
used on 29xx hardware?

Because the new 29xx-specific handlers are missing from the isp_ops table,
interactions with standard sysfs/BSG optrom interfaces will route to the
legacy flash routines instead.

When legacy routines like qla25xx_read_optrom_data run, they calculate the
flash address by adding ha->flash_data_off. Since flash_data_off is
initialized to ~0 here, the resulting address wraps around to 0xFFFFFFFF.

Could this lead to severe PCIe errors (Target Abort), SError faults on ARM,
or firmware lockups when the hardware is instructed to read or write to
0xFFFFFFFF?

> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_su=
p.c
> index b6c36a8a2d60b..ea5e4901cc70a 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
[ ... ]
> +void *
> +qla29xx_read_optrom_data(struct scsi_qla_host *vha, uint16_t reg_code,
> +			 uint16_t opts, void *buf, uint32_t offset,
> +			 uint32_t length)

[Severity: High]
How will this be hooked up to isp_ops->read_optrom?

The standard isp_ops->read_optrom hook expects a 4-argument signature, but
this newly defined function has 6 arguments. Was a wrapper function intended
to bridge this gap so it could actually be assigned to the isp_ops table?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D2
