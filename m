Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279D0CA6F
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 05:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717652871; cv=none; b=VkfU2EpLvEuvNQO9V39QH8Ch1idrGiragUhQ6moLjUXk5s5E76gBDnSHXDBaEZqVc8wU99zpjs0ikBI7n/qth00mWalhIjgmpV+v8sJqNZppLAol1M3QZPyz1gTlciLD6mxhYBeiIYvOc+5FIiMf+V6L1EMtGpKA3pjNmLIf5QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717652871; c=relaxed/simple;
	bh=lUHu9OndElE80PMgf+km0f5g9eCe2jomO9hpWaUxI6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l8x6KlEQ/82+noWL1cbgQewZn2EkwgN2BrdRCmSouQ3ySO7od+Qu81rYkLoG5gAw3h8c4h6EHLvV4ajk8F7WVCSBC0j1vJA0tK+7dwVAjrkIv/4U3jjy/0fP4Ib/SMUz7rPXcCnwysCmh+Eys7kH3T4o2yeKjXdlTPCcKXonfQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLZaxdRU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLZaxdRU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BB5C2BD10;
	Thu,  6 Jun 2024 05:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717652870;
	bh=lUHu9OndElE80PMgf+km0f5g9eCe2jomO9hpWaUxI6Y=;
	h=From:To:Cc:Subject:Date:From;
	b=PLZaxdRUZM4P2dWHWQleCl6dAvU5nx5LksOkMMA7ANafRuSPWyWX5xxAQUwebpPXn
	 yOY7ohXZzzvwNN0jrZqREz90HOWHu6sUgRVnP6yanHUp9wR0MxST7O+FHrSiE5xAn/
	 P6aWzUg6mgubxqWfC+kDFw5OCJdnLsCpFDOTJMxZjsFcP/BesSJRq/zOZZ/dDGBs5+
	 KfU1mDHh2lXPtjvi9rOfRrs8s0yUM1j+y6CwhoV6H9AM/k9Z5iiUNgneNGYhZgUAhN
	 0I8Kqd/pQopRPxW4ADUWc5A+CutUITItuk1saquRq6k2CLZsf9ch8EfX/VbObFpYib
	 0eiXMglazxvQQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] scsi: mpi3mr: Fix SATA NCQ priority support
Date: Thu,  6 Jun 2024 14:47:49 +0900
Message-ID: <20240606054749.55708-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function mpi3mr_qcmd() of the mpi3mr driver is able to indicate to
the HBA if a read or write command directed at a SATA device should be
executed using NCQ high priority, if the request uses the RT priority
class and the user has enabled NCQ priority through sysfs.

However, unlike the mpt3sas driver, the mpi3mr driver does not define
the sas_ncq_prio_supported and sas_ncq_prio_enable sysfs attributes, so
the ncq_prio_enable field of struct mpi3mr_sdev_priv_data is never
actually set and NCQ Priority cannot ever be used.

Fix this by defining these missing atributes to allow a user to check if
a device supports NCQ priority and to enable/disable the use of NCQ
priority. To do this, lift the function scsih_ncq_prio_supp() out of the
mpt3sas driver and make it the generic scsi device function
scsi_ncq_prio_supported(). Nothing in that function is hardware
specific, so this function can be used for both the mpt3sas driver and
the mpi3mr driver.

Reported-by: Scott McCoy <scott.mccoy@wdc.com>
Fixes: 023ab2a9b4ed ("scsi: mpi3mr: Add support for queue command processing")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c     | 62 ++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 --
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 23 -----------
 drivers/scsi/scsi_lib.c              | 22 ++++++++++
 include/scsi/scsi_device.h           |  2 +
 6 files changed, 88 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1638109a68a0..d3736068ec3a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2163,10 +2163,72 @@ persistent_id_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(persistent_id);
 
+/**
+ * sas_ncq_prio_supported_show - Indicate if device supports NCQ priority
+ * @dev: pointer to embedded device
+ * @attr: sas_ncq_prio_supported attribute descriptor
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read-only' sdev attribute, only works with SATA devices
+ */
+static ssize_t
+sas_ncq_prio_supported_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return sysfs_emit(buf, "%d\n", scsi_ncq_prio_supported(sdev));
+}
+static DEVICE_ATTR_RO(sas_ncq_prio_supported);
+
+/**
+ * sas_ncq_prio_enable_show - send prioritized io commands to device
+ * @dev: pointer to embedded device
+ * @attr: sas_ncq_prio_enable attribute descriptor
+ * @buf: the buffer returned
+ *
+ * A sysfs 'read/write' sdev attribute, only works with SATA devices
+ */
+static ssize_t
+sas_ncq_prio_enable_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct mpi3mr_sdev_priv_data *sdev_priv_data =  sdev->hostdata;
+
+	if (!sdev_priv_data)
+		return 0;
+
+	return sysfs_emit(buf, "%d\n", sdev_priv_data->ncq_prio_enable);
+}
+
+static ssize_t
+sas_ncq_prio_enable_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct mpi3mr_sdev_priv_data *sdev_priv_data =  sdev->hostdata;
+	bool ncq_prio_enable = 0;
+
+	if (kstrtobool(buf, &ncq_prio_enable))
+		return -EINVAL;
+
+	if (!scsi_ncq_prio_supported(sdev))
+		return -EINVAL;
+
+	sdev_priv_data->ncq_prio_enable = ncq_prio_enable;
+
+	return strlen(buf);
+}
+static DEVICE_ATTR_RW(sas_ncq_prio_enable);
+
 static struct attribute *mpi3mr_dev_attrs[] = {
 	&dev_attr_sas_address.attr,
 	&dev_attr_device_handle.attr,
 	&dev_attr_persistent_id.attr,
+	&dev_attr_sas_ncq_prio_supported.attr,
+	&dev_attr_sas_ncq_prio_enable.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index bf100a4ebfc3..fe1e96fda284 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -2048,9 +2048,6 @@ void
 mpt3sas_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	struct _raid_device *raid_device, Mpi25SCSIIORequest_t *mpi_request);
 
-/* NCQ Prio Handling Check */
-bool scsih_ncq_prio_supp(struct scsi_device *sdev);
-
 void mpt3sas_setup_debugfs(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_destroy_debugfs(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_init_debugfs(void);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 1c9fd26195b8..8759bc7b8056 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -4088,7 +4088,7 @@ sas_ncq_prio_supported_show(struct device *dev,
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
-	return sysfs_emit(buf, "%d\n", scsih_ncq_prio_supp(sdev));
+	return sysfs_emit(buf, "%d\n", scsi_ncq_prio_supported(sdev));
 }
 static DEVICE_ATTR_RO(sas_ncq_prio_supported);
 
@@ -4123,7 +4123,7 @@ sas_ncq_prio_enable_store(struct device *dev,
 	if (kstrtobool(buf, &ncq_prio_enable))
 		return -EINVAL;
 
-	if (!scsih_ncq_prio_supp(sdev))
+	if (!scsi_ncq_prio_supported(sdev))
 		return -EINVAL;
 
 	sas_device_priv_data->ncq_prio_enable = ncq_prio_enable;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 89ef43a5ef86..3a1ed6a4f370 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12571,29 +12571,6 @@ scsih_pci_mmio_enabled(struct pci_dev *pdev)
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
-/**
- * scsih_ncq_prio_supp - Check for NCQ command priority support
- * @sdev: scsi device struct
- *
- * This is called when a user indicates they would like to enable
- * ncq command priorities. This works only on SATA devices.
- */
-bool scsih_ncq_prio_supp(struct scsi_device *sdev)
-{
-	struct scsi_vpd *vpd;
-	bool ncq_prio_supp = false;
-
-	rcu_read_lock();
-	vpd = rcu_dereference(sdev->vpd_pg89);
-	if (!vpd || vpd->len < 214)
-		goto out;
-
-	ncq_prio_supp = (vpd->data[213] >> 4) & 1;
-out:
-	rcu_read_unlock();
-
-	return ncq_prio_supp;
-}
 /*
  * The pci device ids are defined in mpi/mpi2_cnfg.h.
  */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ec39acc986d6..a0b25c7156e5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3412,6 +3412,28 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 }
 EXPORT_SYMBOL(scsi_vpd_tpg_id);
 
+/**
+ * scsi_ncq_prio_supported - Check for NCQ command priority support
+ * @sdev: SCSI device
+ *
+ * Check if a (SATA) device supports NCQ priority. For non-SATA devices,
+ * this always return false.
+ */
+bool scsi_ncq_prio_supported(struct scsi_device *sdev)
+{
+	struct scsi_vpd *vpd;
+	bool ncq_prio_supported = false;
+
+	rcu_read_lock();
+	vpd = rcu_dereference(sdev->vpd_pg89);
+	if (vpd && vpd->len >= 214)
+		ncq_prio_supported = (vpd->data[213] >> 4) & 1;
+	rcu_read_unlock();
+
+	return ncq_prio_supported;
+}
+EXPORT_SYMBOL_GPL(scsi_ncq_prio_supported);
+
 /**
  * scsi_build_sense - build sense data for a command
  * @scmd:	scsi command for which the sense should be formatted
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c540f5468eb..c00aefcb8fa3 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -555,6 +555,8 @@ extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
 extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
 
+bool scsi_ncq_prio_supported(struct scsi_device *sdev);
+
 #ifdef CONFIG_PM
 extern int scsi_autopm_get_device(struct scsi_device *);
 extern void scsi_autopm_put_device(struct scsi_device *);
-- 
2.45.2

