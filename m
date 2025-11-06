Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54032E7623
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 10:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762425980; cv=none; b=HmoKABK0XUInx7MW1wtcvRW7YIi4jbZi7FAIEPJs+YeHUIrjvIA2DrDVevdeZ3ElF+EPixdduD36mULz9PKVQmB00tvoSEsRemDLGj5tsTtpfYTVzQk++Ne3y9CUozrwq8JVRJzi3dY38wQf596y2JmxsJTUpQQ5auhsLFAoabE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762425980; c=relaxed/simple;
	bh=UN/GKU9hvJMbqnzmKkd4b7NQH6hyTg2EHZG2w73sYZg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZIYs8Nh7vOdFUKqYGtgAH3Ku1AmXZ/h2KiFKwtpGek7FtCtLmYWSVBwKb7IFCgomUwK5fMC+Wa4qYtqb9Krjei4VUwYmm6+6831HASCCWn7pVTFrvlo1xI+/WxdGQUBpREYcW4mRDi1l2OnzNxEnVqiEXLJ8o/WInCMiTKzNzA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=PTi36yJx; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="PTi36yJx"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 482B04E41565;
	Thu,  6 Nov 2025 10:46:15 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 1AF806068C;
	Thu,  6 Nov 2025 10:46:15 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C9129118507EA;
	Thu,  6 Nov 2025 11:46:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1762425974; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=ykf8AdWKUdwglXfy0yT79Zz6cgk7FWiBvEcU7ZTGEKg=;
	b=PTi36yJxC/EF3MvdGN6SHwZ4omaZLcP+h6NMtpL/W2BM6P5PgoRt2rlThsaf1N9wgGD2qW
	Kew/PVlIZB5xij1CQj33zJxPg/z/oMpRem+mrGZyFmn4AWDxOTtTCnfgLObkO9jpfYxJA0
	yVQgJ4S6Oa9ARyAXqtFr2GCrrt3U18+pBlpPeVEGdeouED4zsY81qsqEAPE/v1meZ9KlPR
	zBPMlFbBg/yGZDIowSGnHKbr1DqHiNFwh7R9LTHFq7prc3hTccO4X3wngChfS2YFb186BD
	1779kjAa0/dKsUQUuFtVlocfOT3xLsYkwdVpT9ZovAf4bJuOrAeQT94ULQrj2g==
From: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>
Date: Thu, 06 Nov 2025 11:46:04 +0100
Subject: [PATCH] scsi: ufs: core: fix hid sysfs group update
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-scsi-ufs-core-fix-sysfs-update-hid-group-v1-1-1262037d6c97@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAGt8DGkC/x3NSwrDMAxF0a0EjSuw3Tr9bCV0EGwl0SQ2Uh1aQ
 vZekeGBy3s7KAmTwqvbQWhj5bIa/KWDtIzrTMjZDMGF6L3rUZMytkkxFSGc+Iv6U2OrefwQLpx
 xltIqxvvTRxeut4cjsLkqZPV5NbyP4w8U8rnhegAAAA==
X-Change-ID: 20251106-scsi-ufs-core-fix-sysfs-update-hid-group-57915023480e
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Daniel Lee <chullee@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Gregory CLEMENT <gregory.clement@bootlin.com>, Udit Kumar <u-kumar1@ti.com>, 
 Prasanth Mantena <p-mantena@ti.com>, Abhash Kumar <a-kumar2@ti.com>, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

Without UFSHCD_QUIRK_SKIP_PH_CONFIGURATION, the UFS core fails to create
sysfs groups due to a pre-existing hid group.

[    3.431670] Call trace:
[    3.431673]  show_stack+0x18/0x24 (C)
[    3.431682]  dump_stack_lvl+0x74/0x8c
[    3.431691]  dump_stack+0x18/0x24
[    3.431696]  sysfs_warn_dup+0x64/0x80
[    3.431704]  internal_create_group+0x450/0x46c
[    3.431709]  internal_create_groups+0x50/0xd0
[    3.431714]  sysfs_create_groups+0x18/0x24
[    3.431719]  ufs_sysfs_add_nodes+0x24/0x68
[    3.431725]  ufshcd_init+0xb3c/0xef0
[    3.431730]  ufshcd_pltfrm_init+0x514/0x7ec
[    3.431735]  cdns_ufs_pltfrm_probe+0x3c/0x80
[    3.431740]  platform_probe+0x5c/0x98
[    3.431745]  really_probe+0xbc/0x2a8
[    3.431749]  __driver_probe_device+0x78/0x12c
[    3.431752]  driver_probe_device+0xd8/0x15c
[    3.431756]  __device_attach_driver+0xb8/0x134
[    3.431760]  bus_for_each_drv+0x88/0xe8
[    3.431763]  __device_attach+0xa0/0x190
[    3.431766]  device_initial_probe+0x14/0x20
[    3.431769]  bus_probe_device+0xac/0xb0
[    3.431773]  device_add+0x5d4/0x7a4
[    3.431779]  of_device_add+0x44/0x60
[    3.431785]  of_platform_device_create_pdata+0x8c/0x120
[    3.431789]  of_platform_bus_create+0x158/0x39c
[    3.431794]  of_platform_populate+0x74/0x108
[    3.431798]  ti_j721e_ufs_probe+0xd8/0x1c0
[    3.431803]  platform_probe+0x5c/0x98
[    3.431807]  really_probe+0xbc/0x2a8
[    3.431811]  __driver_probe_device+0x78/0x12c
[    3.431814]  driver_probe_device+0xd8/0x15c
[    3.431818]  __device_attach_driver+0xb8/0x134
[    3.431821]  bus_for_each_drv+0x88/0xe8
[    3.431824]  __device_attach+0xa0/0x190
[    3.431828]  device_initial_probe+0x14/0x20
[    3.431831]  bus_probe_device+0xac/0xb0
[    3.431834]  deferred_probe_work_func+0x88/0xc0
[    3.431838]  process_one_work+0x148/0x28c
[    3.431844]  worker_thread+0x2d0/0x3d8
[    3.431848]  kthread+0x12c/0x204
[    3.431855]  ret_from_fork+0x10/0x20
[    3.432030] cdns-ufshcd 4e84000.ufs: ufs_sysfs_add_nodes: sysfs groups creation failed (err = -17)

The issue occurs because, without UFSHCD_QUIRK_SKIP_PH_CONFIGURATION, the
hid group is updated before sysfs groups creation. The sysfs_update_group()
function silently creates missing group, the subsequent call to
ufs_sysfs_add_nodes() fails when it attempts to create the already-existing
hid group.

Without UFSHCD_QUIRK_SKIP_PH_CONFIGURATION:
  ufshcd_init
    ufshcd_device_params_init
      ufs_get_device_desc
        sysfs_update_group
    ufs_sysfs_add_nodes

With UFSHCD_QUIRK_SKIP_PH_CONFIGURATION:
  ufshcd_init
    ufs_sysfs_add_nodes

Move the sysfs_update_group() call in ufshcd_device_init() after
ufshcd_device_params_init() to ensure hid group is updated once all groups
were created.

Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
Signed-off-by: Thomas Richard (TI.com) <thomas.richard@bootlin.com>
---
Issue found on a TI J784S4 EVM board. Testing confirms the issue is fixed
on my platform. However, I was unable to verify if HID attributes are
visible when the feature is supported.
---
 drivers/ufs/core/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9ca27de4767a..94bcb75ea2f8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8503,8 +8503,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
 				UFS_DEV_HID_SUPPORT;
 
-	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
-
 	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
 
 	err = ufshcd_read_string_desc(hba, model_index,
@@ -9033,6 +9031,9 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
 		ret = ufshcd_device_params_init(hba);
 		if (ret)
 			return ret;
+
+		sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
+
 		if (is_mcq_supported(hba) &&
 		    hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH) {
 			ufshcd_config_mcq(hba);

---
base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
change-id: 20251106-scsi-ufs-core-fix-sysfs-update-hid-group-57915023480e

Best regards,
-- 
Thomas Richard (TI.com) <thomas.richard@bootlin.com>

