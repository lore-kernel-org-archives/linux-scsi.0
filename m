From: Adam Manzanares <adam.manzanares@hgst.com>
Subject: [PATCH v5 4/4] ata: ATA Command Priority Disabled By Default
Date: Thu, 13 Oct 2016 16:00:31 -0700
Message-ID: <1476399631-5799-5-git-send-email-adam.manzanares@hgst.com>
References: <1476399631-5799-1-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62749 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbcJMXB6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 19:01:58 -0400
In-Reply-To: <1476399631-5799-1-git-send-email-adam.manzanares@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, tj@kernel.org, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@hgst.com>, Adam Manzanares <adam.manzanares@wdc.com>

Add a sysfs entry to turn on priority information being passed
to a ATA device. By default this feature is turned off.

This patch depends on ata: Enabling ATA Command Priorities

Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
---
 drivers/ata/libahci.c     |  1 +
 drivers/ata/libata-core.c |  2 +-
 drivers/ata/libata-scsi.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libata.h    |  8 ++++++
 4 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index dcf2c72..383adf7 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -140,6 +140,7 @@ EXPORT_SYMBOL_GPL(ahci_shost_attrs);
 struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
 	&dev_attr_unload_heads,
+	&dev_attr_enable_prio,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ahci_sdev_attrs);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 181b530..d0cf987 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -787,7 +787,7 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 		if (tf->flags & ATA_TFLAG_FUA)
 			tf->device |= 1 << 7;
 
-		if (ata_ncq_prio_enabled(dev)) {
+		if (ata_ncq_prio_enabled(dev) && ata_prio_enabled(dev)) {
 			if (class == IOPRIO_CLASS_RT)
 				tf->hob_nsect |= ATA_PRIO_HIGH <<
 						 ATA_SHIFT_PRIO;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 18629e8..10ba118 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -271,6 +271,73 @@ DEVICE_ATTR(unload_heads, S_IRUGO | S_IWUSR,
 	    ata_scsi_park_show, ata_scsi_park_store);
 EXPORT_SYMBOL_GPL(dev_attr_unload_heads);
 
+static ssize_t ata_enable_prio_show(struct device *device,
+				    struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	int rc = 0;
+	int enable_prio;
+
+	ap = ata_shost_to_port(sdev->host);
+
+	spin_lock_irq(ap->lock);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (!dev) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+
+	enable_prio = ata_prio_enabled(dev);
+
+unlock:
+	spin_unlock_irq(ap->lock);
+
+	return rc ? rc : snprintf(buf, 20, "%u\n", enable_prio);
+}
+
+static ssize_t ata_enable_prio_store(struct device *device,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	long int input;
+	unsigned long flags;
+	int rc;
+
+	rc = kstrtol(buf, 10, &input);
+	if (rc)
+		return rc;
+	if ((input < 0) || (input > 1))
+		return -EINVAL;
+
+	ap = ata_shost_to_port(sdev->host);
+
+	spin_lock_irqsave(ap->lock, flags);
+	dev = ata_scsi_find_dev(ap, sdev);
+	if (unlikely(!dev)) {
+		rc = -ENODEV;
+		goto unlock;
+	}
+
+	if (input)
+		dev->flags |= ATA_DFLAG_ENABLE_PRIO;
+	else
+		dev->flags &= ~ATA_DFLAG_ENABLE_PRIO;
+
+unlock:
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return rc ? rc : len;
+}
+
+DEVICE_ATTR(enable_prio, S_IRUGO | S_IWUSR,
+	    ata_enable_prio_show, ata_enable_prio_store);
+EXPORT_SYMBOL_GPL(dev_attr_enable_prio);
+
 void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
 			u8 sk, u8 asc, u8 ascq)
 {
@@ -402,6 +469,7 @@ EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 
 struct device_attribute *ata_common_sdev_attrs[] = {
 	&dev_attr_unload_heads,
+	&dev_attr_enable_prio,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 244f261..c8acb16 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -166,6 +166,7 @@ enum {
 	ATA_DFLAG_UNLOCK_HPA	= (1 << 18), /* unlock HPA */
 	ATA_DFLAG_NCQ_SEND_RECV = (1 << 19), /* device supports NCQ SEND and RECV */
 	ATA_DFLAG_NCQ_PRIO	= (1 << 20), /* device supports NCQ priority */
+	ATA_DFLAG_ENABLE_PRIO	= (1 << 21), /* User enable device priority */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),
@@ -544,6 +545,7 @@ typedef void (*ata_postreset_fn_t)(struct ata_link *link, unsigned int *classes)
 
 extern struct device_attribute dev_attr_link_power_management_policy;
 extern struct device_attribute dev_attr_unload_heads;
+extern struct device_attribute dev_attr_enable_prio;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
 extern struct device_attribute dev_attr_sw_activity;
@@ -1627,6 +1629,12 @@ static inline int ata_ncq_prio_enabled(struct ata_device *dev)
 	return (dev->flags & ATA_DFLAG_NCQ_PRIO) == ATA_DFLAG_NCQ_PRIO;
 }
 
+static inline int ata_prio_enabled(struct ata_device *dev)
+{
+	return ((dev->flags & ATA_DFLAG_ENABLE_PRIO) ==
+		 ATA_DFLAG_ENABLE_PRIO);
+}
+
 static inline bool ata_fpdma_dsm_supported(struct ata_device *dev)
 {
 	return (dev->flags & ATA_DFLAG_NCQ_SEND_RECV) &&
-- 
2.1.4

