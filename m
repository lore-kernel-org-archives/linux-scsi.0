From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] convert aic94xx over to using the sas transport end device
Date: Sat, 04 Mar 2006 09:10:18 -0600
Message-ID: <1141485019.3191.10.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:57222 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751803AbWCDPKW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 10:10:22 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k24FAJ217912
	for <linux-scsi@vger.kernel.org>; Sat, 4 Mar 2006 10:10:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The elimination is pretty simple, actually; hopefully that bodes well
for the expander conversion.

James

diff --git a/drivers/scsi/aic94xx/aic94xx_dev.c b/drivers/scsi/aic94xx/aic94xx_dev.c
index 357e51a..cbb88c3 100644
--- a/drivers/scsi/aic94xx/aic94xx_dev.c
+++ b/drivers/scsi/aic94xx/aic94xx_dev.c
@@ -217,13 +217,16 @@ static int asd_init_target_ddb(struct do
 		}
 	}
 
-	if (dev->dev_type == SAS_END_DEV && dev->end_dev.itnl_timeout > 0)
-		asd_ddbsite_write_word(asd_ha, ddb, ITNL_TIMEOUT,
-				       min(dev->end_dev.itnl_timeout,
-					   (u16)ITNL_TIMEOUT_CONST));
-	else
-		asd_ddbsite_write_word(asd_ha, ddb, ITNL_TIMEOUT,
-				       (u16)ITNL_TIMEOUT_CONST);
+	if (dev->dev_type == SAS_END_DEV) {
+		struct sas_rphy_end_device *rdev = rphy_to_end_device(dev->rphy);
+		if (rdev->I_T_nexus_loss_timeout > 0)
+			asd_ddbsite_write_word(asd_ha, ddb, ITNL_TIMEOUT,
+					       min(rdev->I_T_nexus_loss_timeout,
+						   (u16)ITNL_TIMEOUT_CONST));
+		else
+			asd_ddbsite_write_word(asd_ha, ddb, ITNL_TIMEOUT,
+					       (u16)ITNL_TIMEOUT_CONST);
+	}
 	return 0;
 }
 
diff --git a/drivers/scsi/sas/sas_discover.c b/drivers/scsi/sas/sas_discover.c
index cd10c52..6c86807 100644
--- a/drivers/scsi/sas/sas_discover.c
+++ b/drivers/scsi/sas/sas_discover.c
@@ -204,13 +204,6 @@ static int sas_get_port_device(struct sa
 		return -ENODEV;
 	}
 	phy = container_of(port->phy_list.next, struct asd_sas_phy, port_phy_el);
-	rphy = sas_rphy_alloc(phy->phy);
-	if (!rphy) {
-		spin_unlock_irqrestore(&port->phy_list_lock, flags);
-		kfree(dev);
-		return -ENODEV;
-	}
-	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	spin_lock(&phy->frame_rcvd_lock);
 	memcpy(dev->frame_rcvd, phy->frame_rcvd, min(sizeof(dev->frame_rcvd),
 					     (size_t)phy->frame_rcvd_size));
@@ -237,6 +230,13 @@ static int sas_get_port_device(struct sa
 
 	sas_init_dev(dev);
 
+	rphy = dev->dev_type == SAS_END_DEV ? sas_rphy_end_device_alloc(phy->phy) : sas_rphy_alloc(phy->phy);
+	if (!rphy) {
+		spin_unlock_irqrestore(&port->phy_list_lock, flags);
+		kfree(dev);
+		return -ENODEV;
+	}
+	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	memcpy(dev->sas_addr, port->attached_sas_addr, SAS_ADDR_SIZE);
 	rphy->identify.sas_address = SAS_ADDR(dev->sas_addr);
 	rphy->identify.initiator_port_protocols = dev->iproto;
@@ -471,72 +471,6 @@ static int sas_discover_sata_pm(struct d
 	return -ENODEV;
 }
 
-/* ---------- SAS end devices ---------- */
-
-static int sas_get_itnl_timeout(struct domain_device *dev)
-{
-	static const u8 mode_sense_6[16]  = { 0x1a, };
-	static const u8 mode_sense_10[16] = { 0x5a, };
-
-	int res = -ENOMEM;
-	struct sas_task *task;
-	u8 *buffer, *__buf;
-	const int buffer_size = 12;
-
-	task = sas_alloc_task(GFP_KERNEL);
-	if (!task)
-		return -ENOMEM;
-	buffer = kzalloc(buffer_size, GFP_KERNEL);
-	if (!buffer)
-		goto out;
-	__buf = buffer;
-
-	task->dev = dev;
-
-	task->ssp_task.retry_count = 1;
-	memcpy(task->ssp_task.cdb, mode_sense_6, 16);
-	task->ssp_task.cdb[1] |= (1 << 3);
-	task->ssp_task.cdb[2] = 0x19;
-	task->ssp_task.cdb[4] = buffer_size;
-
-	res = sas_execute_task(task, buffer, buffer_size, PCI_DMA_FROMDEVICE);
-	if (res) {
-		SAS_DPRINTK("task to device %llx returned stat 0x%x for "
-			    "MODE SENSE 6\n",
-			    SAS_ADDR(dev->sas_addr), task->task_status.stat);
-		memcpy(task->ssp_task.cdb, mode_sense_10, 16);
-		task->ssp_task.cdb[1] |= (1 << 3);
-		task->ssp_task.cdb[2] = 0x19;
-		task->ssp_task.cdb[8] = buffer_size;
-
-		res = sas_execute_task(task, buffer, buffer_size,
-				       PCI_DMA_FROMDEVICE);
-		if (res) {
-			SAS_DPRINTK("task to device %llx returned stat 0x%x "
-				    "for MODE SENSE 10\n",
-				    SAS_ADDR(dev->sas_addr),
-				    task->task_status.stat);
-			goto out_buf;
-		}
-		dev->end_dev.ms_10 = 1;
-		buffer += 4;
-	}
-
-	buffer += 4;		  /* skip mode parameter header */
-
-	dev->end_dev.ready_led_meaning = (buffer[2] & (1<<4)) ? 1 : 0;
-	dev->end_dev.itnl_timeout = be16_to_cpu(*(__be16 *)(buffer+4));
-	dev->end_dev.iresp_timeout= be16_to_cpu(*(__be16 *)(buffer+6));
-
-	res = 0;
-
-out_buf:
-	kfree(__buf);
-out:
-	sas_free_task(task);
-	return res;
-}
-
 /* ---------- Common/dispatchers ---------- */
 
 /**
@@ -596,16 +530,19 @@ int sas_discover_end_dev(struct domain_d
 	if (res)
 		return res;
 
-	res = sas_get_itnl_timeout(dev);
+
 	if (!res) {
-		sas_notify_lldd_dev_gone(dev);
-		sas_notify_lldd_dev_found(dev);
 	}
 
 	res = sas_rphy_add(dev->rphy);
 	if (res)
 		goto out_err;
 
+	/* do this to get the end device port attributes which will have
+	 * been scanned in sas_rphy_add */
+	sas_notify_lldd_dev_gone(dev);
+	sas_notify_lldd_dev_found(dev);
+
 	return 0;
 
 out_err:
diff --git a/drivers/scsi/sas/sas_scsi_host.c b/drivers/scsi/sas/sas_scsi_host.c
index af5fa7e..c092d9a 100644
--- a/drivers/scsi/sas/sas_scsi_host.c
+++ b/drivers/scsi/sas/sas_scsi_host.c
@@ -563,12 +563,16 @@ int sas_target_alloc(struct scsi_target 
 
 int sas_slave_configure(struct scsi_device *scsi_dev)
 {
-	struct domain_device *dev;
+	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 	struct sas_ha_struct *sas_ha;
+	struct sas_rphy_end_device *rdev = rphy_to_end_device(dev->rphy);
+
+	BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);
 
-	dev = sdev_to_domain_dev(scsi_dev);
 	sas_ha = dev->port->ha;
 
+	sas_read_port_mode_page(scsi_dev);
+
 	if (scsi_dev->tagged_supported) {
 		scsi_set_tag_type(scsi_dev, MSG_SIMPLE_TAG);
 		scsi_activate_tcq(scsi_dev, SAS_DEF_QD);
@@ -581,9 +585,9 @@ int sas_slave_configure(struct scsi_devi
 		scsi_deactivate_tcq(scsi_dev, 1);
 	}
 
-	if (dev->end_dev.itnl_timeout > 0)
+	if (rdev->I_T_nexus_loss_timeout > 0)
 		scsi_dev->timeout = HZ +
-			msecs_to_jiffies(dev->end_dev.itnl_timeout);
+			msecs_to_jiffies(rdev->I_T_nexus_loss_timeout);
 
 	return 0;
 }
diff --git a/include/scsi/sas/sas_discover.h b/include/scsi/sas/sas_discover.h
index 1584d4e..2aa56f3 100644
--- a/include/scsi/sas/sas_discover.h
+++ b/include/scsi/sas/sas_discover.h
@@ -79,18 +79,6 @@ struct sata_device {
 	struct list_head children; /* PM Ports if this is a PM */
 };
 
-/* ---------- SAS end device ---------- */
-
-#define SAS_INQUIRY_DATA_LEN 36
-
-struct end_device {
-	u8     ms_10:1;
-	u8     ready_led_meaning:1;
-	u8     rl_wlun:1;
-	u16    itnl_timeout; 	  /* 0 if you do not know it */
-	u16    iresp_timeout;
-};
-
 #include <scsi/sas/sas_expander.h>
 
 /* ---------- Domain device ---------- */
@@ -122,7 +110,6 @@ struct domain_device {
 
 	union {
 		struct expander_device ex_dev;
-		struct end_device      end_dev;
 		struct sata_device     sata_dev; /* STP & directly attached */
 	};
 
diff --git a/include/scsi/sas/sas_expander.h b/include/scsi/sas/sas_expander.h
index b7d63fb..bd00e1c 100644
--- a/include/scsi/sas/sas_expander.h
+++ b/include/scsi/sas/sas_expander.h
@@ -28,8 +28,6 @@
 
 #define ETASK 0xFA
 
-#define to_lu_device(_obj) container_of(_obj, struct LU, lu_obj)
-#define to_lu_attr(_attr) container_of(_attr, struct lu_dev_attribute, attr)
 #define to_dom_device(_obj) container_of(_obj, struct domain_device, dev_obj)
 #define to_dev_attr(_attr)  container_of(_attr, struct domain_dev_attribute,\
                                          attr)


