From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 3/3] ata: ATA Command Priority Disabled By Default
Date: Wed, 19 Oct 2016 14:38:29 -0400
Message-ID: <20161019183829.GK18532@htj.duckdns.org>
References: <1476728850-2309-1-git-send-email-adam.manzanares@hgst.com>
 <1476728850-2309-4-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476728850-2309-4-git-send-email-adam.manzanares@hgst.com>
Sender: linux-ide-owner@vger.kernel.org
To: Adam Manzanares <adam.manzanares@hgst.com>
Cc: axboe@kernel.dk, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

Removed ata_ncq_prio_on() and renamed _on to _enable.  If I messed up
anything, please let me know.

Also, can you please send a follow-up patch to make the store function
reject prio enabling if the device doesn't support it?

Thanks.

------ 8< ------
>From 84f95243b5439a20c33837075b88926bfa00c4ec Mon Sep 17 00:00:00 2001
From: Adam Manzanares <adam.manzanares@hgst.com>
Date: Mon, 17 Oct 2016 11:27:30 -0700
Subject: [PATCH 2/2] ata: ATA Command Priority Disabled By Default

Add a sysfs entry to turn on priority information being passed
to a ATA device. By default this feature is turned off.

This patch depends on ata: Enabling ATA Command Priorities

tj: Renamed ncq_prio_on to ncq_prio_enable and removed trivial
    ata_ncq_prio_on() and open-coded the test.

Signed-off-by: Adam Manzanares <adam.manzanares@hgst.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libahci.c     |  1 +
 drivers/ata/libata-core.c |  3 ++-
 drivers/ata/libata-scsi.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/libata.h    |  2 ++
 4 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 0d028ea..ee7db31 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -140,6 +140,7 @@ EXPORT_SYMBOL_GPL(ahci_shost_attrs);
 struct device_attribute *ahci_sdev_attrs[] = {
 	&dev_attr_sw_activity,
 	&dev_attr_unload_heads,
+	&dev_attr_ncq_prio_enable,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ahci_sdev_attrs);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8346faf..b294339 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -787,7 +787,8 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 		if (tf->flags & ATA_TFLAG_FUA)
 			tf->device |= 1 << 7;
 
-		if (dev->flags & ATA_DFLAG_NCQ_PRIO) {
+		if ((dev->flags & ATA_DFLAG_NCQ_PRIO) &&
+		    (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLE)) {
 			if (class == IOPRIO_CLASS_RT)
 				tf->hob_nsect |= ATA_PRIO_HIGH <<
 						 ATA_SHIFT_PRIO;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2bccc3c..87597a3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -271,6 +271,73 @@ DEVICE_ATTR(unload_heads, S_IRUGO | S_IWUSR,
 	    ata_scsi_park_show, ata_scsi_park_store);
 EXPORT_SYMBOL_GPL(dev_attr_unload_heads);
 
+static ssize_t ata_ncq_prio_enable_show(struct device *device,
+					struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(device);
+	struct ata_port *ap;
+	struct ata_device *dev;
+	bool ncq_prio_enable;
+	int rc = 0;
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
+	ncq_prio_enable = dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLE;
+
+unlock:
+	spin_unlock_irq(ap->lock);
+
+	return rc ? rc : snprintf(buf, 20, "%u\n", ncq_prio_enable);
+}
+
+static ssize_t ata_ncq_prio_enable_store(struct device *device,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len)
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
+		dev->flags |= ATA_DFLAG_NCQ_PRIO_ENABLE;
+	else
+		dev->flags &= ~ATA_DFLAG_NCQ_PRIO_ENABLE;
+
+unlock:
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	return rc ? rc : len;
+}
+
+DEVICE_ATTR(ncq_prio_enable, S_IRUGO | S_IWUSR,
+	    ata_ncq_prio_enable_show, ata_ncq_prio_enable_store);
+EXPORT_SYMBOL_GPL(dev_attr_ncq_prio_enable);
+
 void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
 			u8 sk, u8 asc, u8 ascq)
 {
@@ -402,6 +469,7 @@ EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 
 struct device_attribute *ata_common_sdev_attrs[] = {
 	&dev_attr_unload_heads,
+	&dev_attr_ncq_prio_enable,
 	NULL
 };
 EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 90b69a6..c170be5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -167,6 +167,7 @@ enum {
 	ATA_DFLAG_UNLOCK_HPA	= (1 << 18), /* unlock HPA */
 	ATA_DFLAG_NCQ_SEND_RECV = (1 << 19), /* device supports NCQ SEND and RECV */
 	ATA_DFLAG_NCQ_PRIO	= (1 << 20), /* device supports NCQ priority */
+	ATA_DFLAG_NCQ_PRIO_ENABLE = (1 << 21), /* Priority cmds sent to dev */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),
@@ -545,6 +546,7 @@ typedef void (*ata_postreset_fn_t)(struct ata_link *link, unsigned int *classes)
 
 extern struct device_attribute dev_attr_link_power_management_policy;
 extern struct device_attribute dev_attr_unload_heads;
+extern struct device_attribute dev_attr_ncq_prio_enable;
 extern struct device_attribute dev_attr_em_message_type;
 extern struct device_attribute dev_attr_em_message;
 extern struct device_attribute dev_attr_sw_activity;
-- 
2.7.4

