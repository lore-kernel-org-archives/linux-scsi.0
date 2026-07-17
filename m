Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E3346E70
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304342; cv=none; b=eNm0TI2jJy7r8vbqKmsc/XbBnDB9zkQGW7S4scxVgjMAIdfUR58emVJF2P7w2FpyIPu+1/xvn52v/n+c8zW8SpyeLO6v3snGa1pSDqvFGbYGekJcCOF+Ycaw30iNeLQ2lCg7UCn/ZuhTbYRWzHT4wSj4140ImsvwLwDYUK91XfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304342; c=relaxed/simple;
	bh=nIWyrxl07xd+NIwVDWJzCbB2rv4Eqars7VVlEDrOhvY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xa7mkqo2dYxjbNZ9Oy2zPBfl+VkTZYnQeWp1wjEvITU+zM/L8tEHjP4xm9z9smJ4lh8PAH+Dxae456xRc1603pJxU6nJktDS/aUfNw+lPAsgML5n6BrGaasq6HeWR3mJRB2ewh+sn/TjD2OgKLvlWQBwwt/0kWYpeZUtr50aXGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHCqqC3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHCqqC3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2841F000E9;
	Fri, 17 Jul 2026 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304341;
	bh=FiQIjq4ysi0fns2l1Sx9KPFZBk3RmVeWZvUh3zt2UNg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HHCqqC3KB5f9jqXv1/CZsauVfGo0tiMKXyAfEnbi1Zk9oYeU1EqiIezSeGxrXHWOn
	 9BmRXPf0VzsHDsI7ZXE41juk6ZwtQNd9bdq8+8H7jLy0U5ZqVYsjnl8B16In4tUkKr
	 856Hb9NHdwZQ1/E002QxlsPhQk4PweN5Eks/4hQCRs8p27fWb8zJxtobex353DuIuw
	 M5rI9EHpCD+iS4cWtWg1bnwDxXYI7JGs+EhpNs5HUUCO/luqoW6BFbdmexYB5CBoW2
	 ppM1AyEqZoEtm3xqp1MBNhIh2zy+Sq0LKNCRzk/+EMS1z4NGGtHksaRe3MNjTIUmra
	 2bQxsxSXkzKOQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/56] scsi: qla2xxx: Add flash read/write interface
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-3-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:05:40 +0000
Message-Id: <20260717160541.4C2841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing `isp_ops` hooks for 29xx flash read/write cause sysfs MMIO=
 out-of-bounds crashes.
- [High] Concurrent stateful flash read operations cause firmware state cor=
ruption due to missing `optrom_mutex`.
--

--- Patch [2]: [PATCH v5 02/56] scsi: qla2xxx: Add flash read/write interfa=
ce for 29xx ---
commit 3849a5ddec04d8b5a4e4730fd38a29a1014a62fa
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add flash read/write interface for 29xx

The 29xx series uses a different flash access mechanism than earlier adapte=
rs.
This patch adds the mailbox wrappers and helpers needed for flash read and
write operations so that the existing flash infrastructure can drive the new
hardware.

Link: https://lore.kernel.org/oe-kbuild-all/202607141520.k9T31Dpp-lkp@intel=
.com/

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
[ ... ]
> @@ -3237,6 +3237,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struc=
t pci_device_id *id)
>  		ha->flash_data_off =3D ~0;
>  		ha->nvram_conf_off =3D ~0;
>  		ha->nvram_data_off =3D ~0;
> +		ha->flt_segment_length =3D QLA_SEGMENT_LENGTH;
>  	}

[Severity: High]
Are the isp_ops hooks for the 29xx flash read/write missing here?

The newly introduced qla29xx_read_optrom_data() and=20
qla29xx_write_optrom_data() functions appear to be left unassigned to the=20
29xx operations table. If the legacy handlers (like qla25xx_read_optrom_dat=
a)=20
are still used by default, would reading or writing the optrom sysfs node=20
attempt MMIO operations at iobase + ~0 and cause out-of-bounds PCIe memory=
=20
crashes, since flash_conf_off and flash_data_off are initialized to ~0?

[ ... ]
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_su=
p.c
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
[ ... ]
> +static void
> +qla29xx_get_boot_version(scsi_qla_host_t *vha, void *mbuf)
> +{
> +	struct qla_hw_data *ha =3D vha->hw;
> +	uint8_t *bcode =3D mbuf;
> +	uint32_t pcids;
> +	uint8_t code_type;
> +
> +	if (!qla29xx_read_optrom_data(vha, FLT_REG_BOOT_CODE, 0, mbuf, 0,
> +				      QLA29XX_BOOT_PROBE_LEN)) {

[Severity: High]
Is it safe to call qla29xx_read_optrom_data() here without holding=20
ha->optrom_mutex?

During an adapter reset, the background DPC thread can call=20
qla2x00_initialize_adapter() which invokes ha->isp_ops->get_flash_version()=
,=20
leading to this code without acquiring the mutex.=20

If a user is concurrently reading or writing the sysfs optrom file (which=20
does hold the mutex but wouldn't block this background path), could the=20
interleaved stateful mailbox commands (MBC_RD_WR_FLASH) violate the firmwar=
e's=20
flash state machine sequence and cause corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D2
