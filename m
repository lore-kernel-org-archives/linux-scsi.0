Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF0823F295;
	Sat, 16 Aug 2025 09:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755335527; cv=none; b=QSv9GUUp4ZBWnSNQ3BAoPRy47coeSCLZ+Tl9SWEsHTK/3GrNEQfGTdY1poO3+8QWOd3fir9jbdcfhkU13/LrLJ7REGth3zp6qk272JkPRiPyDzFL4FB7Z7P35XouTn06wQUEJWyA2J9ft6NhGcsAqnFr6ViOvAmHV5eUl5GSOhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755335527; c=relaxed/simple;
	bh=m8UDmGU4+3aehgMOMlBPzcggmP/G2qZElSdr9yPggC0=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=NMdZJ6IvSOFYIWZqgFGaJKsjPMyeEJQ1ZnX43MHvxU47ZAXimMM5QXS76YVtFrVGBwalDNPEz2pSz2tlmfr32SsY/T0E7/OeBxO9lv00rwksEZY2X1JArVX262Dvzgv/3qm7Teaj2G0ZLypK0ihJpfpf0hxCkUgvimHtDcPF6M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=b8WrPvmW; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="b8WrPvmW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1755335524;
	bh=m8UDmGU4+3aehgMOMlBPzcggmP/G2qZElSdr9yPggC0=;
	h=Message-ID:Subject:From:To:Date:From;
	b=b8WrPvmWgPjaK/o7Vbv/Y6Twby2u4r6/RKKD0Pj0U98Ej8U4yTgX3ukresQfmey5k
	 i3NVpcv5wp/UhlBda8V70gvJZpO5MhDgGMnxDLx1WhHma0HpkRP7TB9dcNSllyYkRs
	 3EjWeIPHvecLka6EA28eF0FhQnIZTEaxBmCMeT80=
Received: from [IPv6:2a00:23c8:101e:bb01:5bfe:95b6:ba99:a97b] (unknown [IPv6:2a00:23c8:101e:bb01:5bfe:95b6:ba99:a97b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 5FBBA1C00A7;
	Sat, 16 Aug 2025 05:12:03 -0400 (EDT)
Message-ID: <5597dc1584d9b50c6f003c77b474d22443d81bf6.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.17-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2025 10:12:01 +0100
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

One core change removing the 'w' access flag of attributes that don't
have a set routine (and therefore can't be written to) which should
have no practical impact.  The big scsi_debug update is caused by
reformatting lots of arrays and the rest of the bug fixes in drivers
are trivial.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Colin Ian King (1):
      scsi: scsi_debug: Make read-only arrays static const

Damien Le Moal (1):
      scsi: core: sysfs: Correct sysfs attributes access rights

Jean Delvare (1):
      scsi: lpfc: Fix wrong function reference in a comment

Jiasheng Jiang (1):
      scsi: lpfc: Remove redundant assignment to avoid memory leak

Nitin Rawat (1):
      scsi: ufs: core: Fix interrupt handling for MCQ Mode

Peter Wang (1):
      scsi: ufs: mediatek: Fix out-of-bounds access in MCQ IRQ mapping

Waqar Hameed (1):
      scsi: ufs: core: Remove error print for devm_add_action_or_reset()

And the diffstat:

 drivers/scsi/lpfc/lpfc_debugfs.c |  1 -
 drivers/scsi/lpfc/lpfc_vport.c   |  2 +-
 drivers/scsi/scsi_debug.c        | 91 +++++++++++++++++++++++++-----------=
----
 drivers/scsi/scsi_sysfs.c        |  4 +-
 drivers/ufs/core/ufshcd.c        | 12 ++++--
 drivers/ufs/host/ufs-mediatek.c  |  2 +-
 6 files changed, 69 insertions(+), 43 deletions(-)

With full diff below.

Regards,

James

---

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debu=
gfs.c
index 2db8d9529b8f..7c4d7bb3a56f 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6280,7 +6280,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on =3D 1;
 			phba->nvmeio_trc_output_idx =3D 0;
-			phba->nvmeio_trc =3D NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size =3D 0;
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.=
c
index 2797aa75a689..aff6c9d5e7c2 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -666,7 +666,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	 * Take early refcount for outstanding I/O requests we schedule during
 	 * delete processing for unreg_vpi.  Always keep this before
 	 * scsi_remove_host() as we can no longer obtain a reference through
-	 * scsi_host_get() after scsi_host_remove as shost is set to SHOST_DEL.
+	 * scsi_host_get() after scsi_remove_host as shost is set to SHOST_DEL.
 	 */
 	if (!scsi_host_get(shost))
 		return VPORT_INVAL;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0847767d4d43..353cb60e1abe 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2674,8 +2674,10 @@ static int resp_rsup_tmfs(struct scsi_cmnd *scp,
=20
 static int resp_err_recov_pg(unsigned char *p, int pcontrol, int target)
 {	/* Read-Write Error Recovery page for mode_sense */
-	unsigned char err_recov_pg[] =3D {0x1, 0xa, 0xc0, 11, 240, 0, 0, 0,
-					5, 0, 0xff, 0xff};
+	static const unsigned char err_recov_pg[] =3D {
+		0x1, 0xa, 0xc0, 11, 240, 0, 0, 0,
+		5, 0, 0xff, 0xff
+	};
=20
 	memcpy(p, err_recov_pg, sizeof(err_recov_pg));
 	if (1 =3D=3D pcontrol)
@@ -2685,8 +2687,10 @@ static int resp_err_recov_pg(unsigned char *p, int p=
control, int target)
=20
 static int resp_disconnect_pg(unsigned char *p, int pcontrol, int target)
 { 	/* Disconnect-Reconnect page for mode_sense */
-	unsigned char disconnect_pg[] =3D {0x2, 0xe, 128, 128, 0, 10, 0, 0,
-					 0, 0, 0, 0, 0, 0, 0, 0};
+	static const unsigned char disconnect_pg[] =3D {
+		0x2, 0xe, 128, 128, 0, 10, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0
+	};
=20
 	memcpy(p, disconnect_pg, sizeof(disconnect_pg));
 	if (1 =3D=3D pcontrol)
@@ -2696,9 +2700,11 @@ static int resp_disconnect_pg(unsigned char *p, int =
pcontrol, int target)
=20
 static int resp_format_pg(unsigned char *p, int pcontrol, int target)
 {       /* Format device page for mode_sense */
-	unsigned char format_pg[] =3D {0x3, 0x16, 0, 0, 0, 0, 0, 0,
-				     0, 0, 0, 0, 0, 0, 0, 0,
-				     0, 0, 0, 0, 0x40, 0, 0, 0};
+	static const unsigned char format_pg[] =3D {
+		0x3, 0x16, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0x40, 0, 0, 0
+	};
=20
 	memcpy(p, format_pg, sizeof(format_pg));
 	put_unaligned_be16(sdebug_sectors_per, p + 10);
@@ -2716,10 +2722,14 @@ static unsigned char caching_pg[] =3D {0x8, 18, 0x1=
4, 0, 0xff, 0xff, 0, 0,
=20
 static int resp_caching_pg(unsigned char *p, int pcontrol, int target)
 { 	/* Caching page for mode_sense */
-	unsigned char ch_caching_pg[] =3D {/* 0x8, 18, */ 0x4, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
-	unsigned char d_caching_pg[] =3D {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
-		0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0,     0, 0, 0, 0};
+	static const unsigned char ch_caching_pg[] =3D {
+		/* 0x8, 18, */ 0x4, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+	};
+	static const unsigned char d_caching_pg[] =3D {
+		0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
+		0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0, 0, 0, 0, 0
+	};
=20
 	if (SDEBUG_OPT_N_WCE & sdebug_opts)
 		caching_pg[2] &=3D ~0x4;	/* set WCE=3D0 (default WCE=3D1) */
@@ -2738,8 +2748,10 @@ static int resp_ctrl_m_pg(unsigned char *p, int pcon=
trol, int target)
 { 	/* Control mode page for mode_sense */
 	unsigned char ch_ctrl_m_pg[] =3D {/* 0xa, 10, */ 0x6, 0, 0, 0, 0, 0,
 					0, 0, 0, 0};
-	unsigned char d_ctrl_m_pg[] =3D {0xa, 10, 2, 0, 0, 0, 0, 0,
-				     0, 0, 0x2, 0x4b};
+	static const unsigned char d_ctrl_m_pg[] =3D {
+		0xa, 10, 2, 0, 0, 0, 0, 0,
+		0, 0, 0x2, 0x4b
+	};
=20
 	if (sdebug_dsense)
 		ctrl_m_pg[2] |=3D 0x4;
@@ -2794,10 +2806,14 @@ static int resp_grouping_m_pg(unsigned char *p, int=
 pcontrol, int target)
=20
 static int resp_iec_m_pg(unsigned char *p, int pcontrol, int target)
 {	/* Informational Exceptions control mode page for mode_sense */
-	unsigned char ch_iec_m_pg[] =3D {/* 0x1c, 0xa, */ 0x4, 0xf, 0, 0, 0, 0,
-				       0, 0, 0x0, 0x0};
-	unsigned char d_iec_m_pg[] =3D {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
-				      0, 0, 0x0, 0x0};
+	static const unsigned char ch_iec_m_pg[] =3D {
+		/* 0x1c, 0xa, */ 0x4, 0xf, 0, 0, 0, 0,
+		0, 0, 0x0, 0x0
+	};
+	static const unsigned char d_iec_m_pg[] =3D {
+		0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
+		0, 0, 0x0, 0x0
+	};
=20
 	memcpy(p, iec_m_pg, sizeof(iec_m_pg));
 	if (1 =3D=3D pcontrol)
@@ -2809,8 +2825,9 @@ static int resp_iec_m_pg(unsigned char *p, int pcontr=
ol, int target)
=20
 static int resp_sas_sf_m_pg(unsigned char *p, int pcontrol, int target)
 {	/* SAS SSP mode page - short format for mode_sense */
-	unsigned char sas_sf_m_pg[] =3D {0x19, 0x6,
-		0x6, 0x0, 0x7, 0xd0, 0x0, 0x0};
+	static const unsigned char sas_sf_m_pg[] =3D {
+		0x19, 0x6, 0x6, 0x0, 0x7, 0xd0, 0x0, 0x0
+	};
=20
 	memcpy(p, sas_sf_m_pg, sizeof(sas_sf_m_pg));
 	if (1 =3D=3D pcontrol)
@@ -2854,9 +2871,10 @@ static int resp_sas_pcd_m_spg(unsigned char *p, int =
pcontrol, int target,
=20
 static int resp_sas_sha_m_spg(unsigned char *p, int pcontrol)
 {	/* SAS SSP shared protocol specific port mode subpage */
-	unsigned char sas_sha_m_pg[] =3D {0x59, 0x2, 0, 0xc, 0, 0x6, 0x10, 0,
-		    0, 0, 0, 0, 0, 0, 0, 0,
-		};
+	static const unsigned char sas_sha_m_pg[] =3D {
+		0x59, 0x2, 0, 0xc, 0, 0x6, 0x10, 0,
+		0, 0, 0, 0, 0, 0, 0, 0,
+	};
=20
 	memcpy(p, sas_sha_m_pg, sizeof(sas_sha_m_pg));
 	if (1 =3D=3D pcontrol)
@@ -2923,8 +2941,10 @@ static int process_medium_part_m_pg(struct sdebug_de=
v_info *devip,
 static int resp_compression_m_pg(unsigned char *p, int pcontrol, int targe=
t,
 	unsigned char dce)
 {	/* Compression page for mode_sense (tape) */
-	unsigned char compression_pg[] =3D {0x0f, 14, 0x40, 0, 0, 0, 0, 0,
-		0, 0, 0, 0, 00, 00};
+	static const unsigned char compression_pg[] =3D {
+		0x0f, 14, 0x40, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0
+	};
=20
 	memcpy(p, compression_pg, sizeof(compression_pg));
 	if (dce)
@@ -3282,9 +3302,10 @@ static int resp_mode_select(struct scsi_cmnd *scp,
=20
 static int resp_temp_l_pg(unsigned char *arr)
 {
-	unsigned char temp_l_pg[] =3D {0x0, 0x0, 0x3, 0x2, 0x0, 38,
-				     0x0, 0x1, 0x3, 0x2, 0x0, 65,
-		};
+	static const unsigned char temp_l_pg[] =3D {
+		0x0, 0x0, 0x3, 0x2, 0x0, 38,
+		0x0, 0x1, 0x3, 0x2, 0x0, 65,
+	};
=20
 	memcpy(arr, temp_l_pg, sizeof(temp_l_pg));
 	return sizeof(temp_l_pg);
@@ -3292,8 +3313,9 @@ static int resp_temp_l_pg(unsigned char *arr)
=20
 static int resp_ie_l_pg(unsigned char *arr)
 {
-	unsigned char ie_l_pg[] =3D {0x0, 0x0, 0x3, 0x3, 0x0, 0x0, 38,
-		};
+	static const unsigned char ie_l_pg[] =3D {
+		0x0, 0x0, 0x3, 0x3, 0x0, 0x0, 38,
+	};
=20
 	memcpy(arr, ie_l_pg, sizeof(ie_l_pg));
 	if (iec_m_pg[2] & 0x4) {	/* TEST bit set */
@@ -3305,11 +3327,12 @@ static int resp_ie_l_pg(unsigned char *arr)
=20
 static int resp_env_rep_l_spg(unsigned char *arr)
 {
-	unsigned char env_rep_l_spg[] =3D {0x0, 0x0, 0x23, 0x8,
-					 0x0, 40, 72, 0xff, 45, 18, 0, 0,
-					 0x1, 0x0, 0x23, 0x8,
-					 0x0, 55, 72, 35, 55, 45, 0, 0,
-		};
+	static const unsigned char env_rep_l_spg[] =3D {
+		0x0, 0x0, 0x23, 0x8,
+		0x0, 40, 72, 0xff, 45, 18, 0, 0,
+		0x1, 0x0, 0x23, 0x8,
+		0x0, 55, 72, 35, 55, 45, 0, 0,
+	};
=20
 	memcpy(arr, env_rep_l_spg, sizeof(env_rep_l_spg));
 	return sizeof(env_rep_l_spg);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 169af7d47ce7..15ba493d2138 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -265,7 +265,7 @@ show_shost_supported_mode(struct device *dev, struct de=
vice_attribute *attr,
 	return show_shost_mode(supported_mode, buf);
 }
=20
-static DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported=
_mode, NULL);
+static DEVICE_ATTR(supported_mode, S_IRUGO, show_shost_supported_mode, NUL=
L);
=20
 static ssize_t
 show_shost_active_mode(struct device *dev,
@@ -279,7 +279,7 @@ show_shost_active_mode(struct device *dev,
 		return show_shost_mode(shost->active_mode, buf);
 }
=20
-static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode,=
 NULL);
+static DEVICE_ATTR(active_mode, S_IRUGO, show_shost_active_mode, NULL);
=20
 static int check_reset_type(const char *str)
 {
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 96ad57c3144b..efd7a811a002 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7138,14 +7138,19 @@ static irqreturn_t ufshcd_threaded_intr(int irq, vo=
id *__hba)
 static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
 	struct ufs_hba *hba =3D __hba;
+	u32 intr_status, enabled_intr_status;
=20
 	/* Move interrupt handling to thread when MCQ & ESI are not enabled */
 	if (!hba->mcq_enabled || !hba->mcq_esi_enabled)
 		return IRQ_WAKE_THREAD;
=20
+	intr_status =3D ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+	enabled_intr_status =3D intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENA=
BLE);
+
+	ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
+
 	/* Directly handle interrupts since MCQ ESI handlers does the hard job */
-	return ufshcd_sl_intr(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
-				   ufshcd_readl(hba, REG_INTERRUPT_ENABLE));
+	return ufshcd_sl_intr(hba, enabled_intr_status);
 }
=20
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
@@ -10516,8 +10521,7 @@ int ufshcd_alloc_host(struct device *dev, struct uf=
s_hba **hba_handle)
 	err =3D devm_add_action_or_reset(dev, ufshcd_devres_release,
 				       host);
 	if (err)
-		return dev_err_probe(dev, err,
-				     "failed to add ufshcd dealloc action\n");
+		return err;
=20
 	host->nr_maps =3D HCTX_TYPE_POLL + 1;
 	hba =3D shost_priv(host);
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediate=
k.c
index 86ae73b89d4d..f902ce08c95a 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -818,7 +818,7 @@ static u32 ufs_mtk_mcq_get_irq(struct ufs_hba *hba, uns=
igned int cpu)
 	unsigned int q_index;
=20
 	q_index =3D map->mq_map[cpu];
-	if (q_index > nr) {
+	if (q_index >=3D nr) {
 		dev_err(hba->dev, "hwq index %d exceed %d\n",
 			q_index, nr);
 		return MTK_MCQ_INVALID_IRQ;

