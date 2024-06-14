Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893BE196C8B;
	Fri, 14 Jun 2024 12:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718367947; cv=none; b=Ducb4JsNn6k13b0JV6c9bakW0PmWHJ4nbHYaJMFpvKWvqBgAh90aAJwU9cu178IYRTVzDB2yUH3WSSzk42HbLs8ZqyZI6MKOqmWqn/Sax0rI1EIcGLYRxAc1wBIa5L1gRDlx7sBYFzCxYHpzwe3zMjx0VTUoXtEx1QVinrc/ef4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718367947; c=relaxed/simple;
	bh=TCX96QRs5NwdKwKReUAFtWYxvlgFUefcImNfcca0Lqk=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=Go6gMIGfV4l4gfEuhnu111b2jcoefYnysUDv+ueEnvypo3PJgDqZCFl6vcbnvjXixhm/xCAMrR6/cy8lP+F94TWepCosZrmaYeFJw7b7DobDSy72+9VoBUzFCYU+9qPlf/yP2gEQqYqlv+0lKuyxbamEey3GmKqQEIrbOk3jv0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=oY2vcw5i; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=oY2vcw5i; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="oY2vcw5i";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="oY2vcw5i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1718367944;
	bh=TCX96QRs5NwdKwKReUAFtWYxvlgFUefcImNfcca0Lqk=;
	h=Message-ID:Subject:From:To:Date:From;
	b=oY2vcw5iERqvAEj1TnCVmIVAdvyEcPwBzYMqbgb24Uu5pCRzHvN9Z5eeFJgR1USGO
	 uQ2z5s7iwGAC7Vhr6o/3/76IhE0toH0gzoaKFfzzA9Zl4ly6FjUbcQTpoElXBCmOG1
	 bN7xFFeqJVyb3HbkhIBecvCXHeRJFMbhF96wO8N8=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id CF4E31281015;
	Fri, 14 Jun 2024 08:25:44 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id EhlF1_kZ8RjV; Fri, 14 Jun 2024 08:25:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1718367944;
	bh=TCX96QRs5NwdKwKReUAFtWYxvlgFUefcImNfcca0Lqk=;
	h=Message-ID:Subject:From:To:Date:From;
	b=oY2vcw5iERqvAEj1TnCVmIVAdvyEcPwBzYMqbgb24Uu5pCRzHvN9Z5eeFJgR1USGO
	 uQ2z5s7iwGAC7Vhr6o/3/76IhE0toH0gzoaKFfzzA9Zl4ly6FjUbcQTpoElXBCmOG1
	 bN7xFFeqJVyb3HbkhIBecvCXHeRJFMbhF96wO8N8=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3C2B81280A77;
	Fri, 14 Jun 2024 08:25:44 -0400 (EDT)
Message-ID: <a04853cd4be2533dc0fb724a788fb3cce0f535ba.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.10-rc3
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 14 Jun 2024 08:25:42 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Three obvious driver fixes.  The two core fixes are to disable Command
Duration Limits by default to fix an inconsistency in SATA and some USB
devices.  The other is to change the default read size for block zero
to follow the device preference (some USB bridges preferring 16 byte
commands don't have a translation for READ(10) and thus don't scan
properly).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Breno Leitao (1):
      scsi: mpt3sas: Avoid test/set_bit() operating in non-allocated memory

Damien Le Moal (2):
      scsi: mpi3mr: Fix ATA NCQ priority support
      scsi: core: Disable CDL by default

Martin K. Petersen (1):
      scsi: sd: Use READ(16) when reading block zero on large capacity disks

Ziqi Chen (1):
      scsi: ufs: core: Quiesce request queues before checking pending cmds

and the diffstat:

 drivers/scsi/mpi3mr/mpi3mr_app.c     | 62 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 19 +++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  3 --
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |  4 +--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 23 -------------
 drivers/scsi/scsi.c                  |  7 ++++
 drivers/scsi/scsi_transport_sas.c    | 23 +++++++++++++
 drivers/scsi/sd.c                    | 17 +++++++---
 drivers/ufs/core/ufshcd.c            |  6 ++--
 include/scsi/scsi_transport_sas.h    |  2 ++
 10 files changed, 130 insertions(+), 36 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1638109a68a0..cd261b48eb46 100644
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
+	return sysfs_emit(buf, "%d\n", sas_ata_ncq_prio_supported(sdev));
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
+	if (!sas_ata_ncq_prio_supported(sdev))
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
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 258647fc6bdd..1092497563b2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -8512,6 +8512,12 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->pd_handles_sz = (ioc->facts.MaxDevHandle / 8);
 	if (ioc->facts.MaxDevHandle % 8)
 		ioc->pd_handles_sz++;
+	/*
+	 * pd_handles_sz should have, at least, the minimal room for
+	 * set_bit()/test_bit(), otherwise out-of-memory touch may occur.
+	 */
+	ioc->pd_handles_sz = ALIGN(ioc->pd_handles_sz, sizeof(unsigned long));
+
 	ioc->pd_handles = kzalloc(ioc->pd_handles_sz,
 	    GFP_KERNEL);
 	if (!ioc->pd_handles) {
@@ -8529,6 +8535,13 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->pend_os_device_add_sz = (ioc->facts.MaxDevHandle / 8);
 	if (ioc->facts.MaxDevHandle % 8)
 		ioc->pend_os_device_add_sz++;
+
+	/*
+	 * pend_os_device_add_sz should have, at least, the minimal room for
+	 * set_bit()/test_bit(), otherwise out-of-memory may occur.
+	 */
+	ioc->pend_os_device_add_sz = ALIGN(ioc->pend_os_device_add_sz,
+					   sizeof(unsigned long));
 	ioc->pend_os_device_add = kzalloc(ioc->pend_os_device_add_sz,
 	    GFP_KERNEL);
 	if (!ioc->pend_os_device_add) {
@@ -8820,6 +8833,12 @@ _base_check_ioc_facts_changes(struct MPT3SAS_ADAPTER *ioc)
 		if (ioc->facts.MaxDevHandle % 8)
 			pd_handles_sz++;
 
+		/*
+		 * pd_handles should have, at least, the minimal room for
+		 * set_bit()/test_bit(), otherwise out-of-memory touch may
+		 * occur.
+		 */
+		pd_handles_sz = ALIGN(pd_handles_sz, sizeof(unsigned long));
 		pd_handles = krealloc(ioc->pd_handles, pd_handles_sz,
 		    GFP_KERNEL);
 		if (!pd_handles) {
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
index 1c9fd26195b8..87784c96249a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -4088,7 +4088,7 @@ sas_ncq_prio_supported_show(struct device *dev,
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
-	return sysfs_emit(buf, "%d\n", scsih_ncq_prio_supp(sdev));
+	return sysfs_emit(buf, "%d\n", sas_ata_ncq_prio_supported(sdev));
 }
 static DEVICE_ATTR_RO(sas_ncq_prio_supported);
 
@@ -4123,7 +4123,7 @@ sas_ncq_prio_enable_store(struct device *dev,
 	if (kstrtobool(buf, &ncq_prio_enable))
 		return -EINVAL;
 
-	if (!scsih_ncq_prio_supp(sdev))
+	if (!sas_ata_ncq_prio_supported(sdev))
 		return -EINVAL;
 
 	sas_device_priv_data->ncq_prio_enable = ncq_prio_enable;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12d08d8ba538..870ec2cb4af4 100644
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
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index f0464db3f9de..ee69bd35889d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -673,6 +673,13 @@ void scsi_cdl_check(struct scsi_device *sdev)
 		sdev->use_10_for_rw = 0;
 
 		sdev->cdl_supported = 1;
+
+		/*
+		 * If the device supports CDL, make sure that the current drive
+		 * feature status is consistent with the user controlled
+		 * cdl_enable state.
+		 */
+		scsi_cdl_enable(sdev, sdev->cdl_enable);
 	} else {
 		sdev->cdl_supported = 0;
 	}
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 424a89513814..4e33f1661e4c 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -416,6 +416,29 @@ unsigned int sas_is_tlr_enabled(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL_GPL(sas_is_tlr_enabled);
 
+/**
+ * sas_ata_ncq_prio_supported - Check for ATA NCQ command priority support
+ * @sdev: SCSI device
+ *
+ * Check if an ATA device supports NCQ priority using VPD page 89h (ATA
+ * Information). Since this VPD page is implemented only for ATA devices,
+ * this function always returns false for SCSI devices.
+ */
+bool sas_ata_ncq_prio_supported(struct scsi_device *sdev)
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
+EXPORT_SYMBOL_GPL(sas_ata_ncq_prio_supported);
+
 /*
  * SAS Phy attributes
  */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 332eb9dac22d..fbc11046bbf6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3565,16 +3565,23 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 
 static void sd_read_block_zero(struct scsi_disk *sdkp)
 {
-	unsigned int buf_len = sdkp->device->sector_size;
-	char *buffer, cmd[10] = { };
+	struct scsi_device *sdev = sdkp->device;
+	unsigned int buf_len = sdev->sector_size;
+	u8 *buffer, cmd[16] = { };
 
 	buffer = kmalloc(buf_len, GFP_KERNEL);
 	if (!buffer)
 		return;
 
-	cmd[0] = READ_10;
-	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
-	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+	if (sdev->use_16_for_rw) {
+		cmd[0] = READ_16;
+		put_unaligned_be64(0, &cmd[2]); /* Logical block address 0 */
+		put_unaligned_be32(1, &cmd[10]);/* Transfer 1 logical block */
+	} else {
+		cmd[0] = READ_10;
+		put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
+		put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+	}
 
 	scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_len,
 			 SD_TIMEOUT, sdkp->max_retries, NULL);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0cf07194bbe8..e5e9da61f15d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1366,7 +1366,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
-	ufshcd_scsi_block_requests(hba);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
 	mutex_lock(&hba->wb_mutex);
 	down_write(&hba->clk_scaling_lock);
 
@@ -1375,7 +1375,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba, u64 timeout_us)
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
 		mutex_unlock(&hba->wb_mutex);
-		ufshcd_scsi_unblock_requests(hba);
+		blk_mq_unquiesce_tagset(&hba->host->tag_set);
 		goto out;
 	}
 
@@ -1396,7 +1396,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool sc
 
 	mutex_unlock(&hba->wb_mutex);
 
-	ufshcd_scsi_unblock_requests(hba);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	ufshcd_release(hba);
 }
 
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 0e75b9277c8c..e3b6ce3cbf88 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -200,6 +200,8 @@ unsigned int sas_is_tlr_enabled(struct scsi_device *);
 void sas_disable_tlr(struct scsi_device *);
 void sas_enable_tlr(struct scsi_device *);
 
+bool sas_ata_ncq_prio_supported(struct scsi_device *sdev);
+
 extern struct sas_rphy *sas_end_device_alloc(struct sas_port *);
 extern struct sas_rphy *sas_expander_alloc(struct sas_port *, enum sas_device_type);
 void sas_rphy_free(struct sas_rphy *);

