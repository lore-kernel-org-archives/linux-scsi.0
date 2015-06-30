From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 03/20] [SCSI] mpt3sas: Don't block the drive  when drive addition under the control of SML
Date: Tue, 30 Jun 2015 12:24:49 +0530
Message-ID: <1435647306-36956-4-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35682 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbbF3Gzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 02:55:38 -0400
Received: by pactm7 with SMTP id tm7so644634pac.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 23:55:36 -0700 (PDT)
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

During hot-plugging of a disk(having a flaky link), the disk addition
stops and any further disk addition or removal doesn't happen on that
controller.

This is because, when driver receives DELAY_NOT_RESPONDING event for a disk
while it is undergoing addition at the SCSI Transport layer, the driver
would block the I/O to that disk resulting in a deadlock. i.e the disk
addition work couldn't be completed at the SCSI Transport Layer as it
can't send any I/Os (such as Inquiry, Report LUNs etc) to the disk as
I/Os are blocked to this drive. Also any subsequent device removal
(TARGET_NOT_RESPONDING) or link update(RC_PHY_CHANGED) event couldn't be
processed as they are in the queue to get processed after disk addition
event.

Description of Change:
Don't block the drive when drive addition is under the control of SML.
So that SML won't be blocked of issuing the device dicovery commands
(such as Inquiry, Report LUNs etc).

Changes in v2:
	Patch version change only.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  4 +++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     |  7 +++++++
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 18 ++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index a7386ee..01d92db 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -301,7 +301,8 @@ struct _internal_cmd {
  * @responding: used in _scsih_sas_device_mark_responding
  * @fast_path: fast path feature enable bit
  * @pfa_led_on: flag for PFA LED status
- *
+ * @pend_sas_rphy_add: flag to check if device is in sas_rphy_add()
+ *	addition routine.
  */
 struct _sas_device {
 	struct list_head list;
@@ -322,6 +323,7 @@ struct _sas_device {
 	u8	responding;
 	u8	fast_path;
 	u8	pfa_led_on;
+	u8	pend_sas_rphy_add;
 };
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5a97e32..d457dba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2644,6 +2644,11 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
+	struct _sas_device *sas_device;
+
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (!sas_device)
+		return;
 
 	shost_for_each_device(sdev, ioc->shost) {
 		sas_device_priv_data = sdev->hostdata;
@@ -2653,6 +2658,8 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			continue;
 		if (sas_device_priv_data->block)
 			continue;
+		if (sas_device->pend_sas_rphy_add)
+			continue;
 		sas_device_priv_data->block = 1;
 		scsi_internal_device_block(sdev);
 		sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index efb98af..7a7aa68 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -649,6 +649,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	unsigned long flags;
 	struct _sas_node *sas_node;
 	struct sas_rphy *rphy;
+	struct _sas_device *sas_device = NULL;
 	int i;
 	struct sas_port *port;
 
@@ -731,10 +732,27 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		    mpt3sas_port->remote_identify.device_type);
 
 	rphy->identify = mpt3sas_port->remote_identify;
+
+	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+				    mpt3sas_port->remote_identify.sas_address);
+		if (!sas_device) {
+			dfailprintk(ioc, printk(MPT3SAS_FMT
+				"failure at %s:%d/%s()!\n",
+				ioc->name, __FILE__, __LINE__, __func__));
+			goto out_fail;
+		}
+		sas_device->pend_sas_rphy_add = 1;
+	}
+
 	if ((sas_rphy_add(rphy))) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
 	}
+
+	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE)
+		sas_device->pend_sas_rphy_add = 0;
+
 	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
 		dev_printk(KERN_INFO, &rphy->dev,
 			"add: handle(0x%04x), sas_addr(0x%016llx)\n",
-- 
2.0.2

