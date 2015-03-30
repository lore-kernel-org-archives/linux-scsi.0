From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 03/20] [SCSI] mpt3sas: Added module parameter 'unblock_io' to unblock IO's during disk addition
Date: Mon, 30 Mar 2015 19:25:06 +0530
Message-ID: <1427723723-12676-4-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35188 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbbC3Nz5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2015 09:55:57 -0400
Received: by patj18 with SMTP id j18so11960388pat.2
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2015 06:55:56 -0700 (PDT)
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

During hot-plugging of a disk(having a flaky link), the disk addition
stops and any further disk addition or removal doesn't happen on that controller.

This is because, when driver receives DELAY_NOT_RESPONDING event for a disk while
it is undergoing addition at the SCSI Transport layer, the driver would block the I/O to that disk
resulting in a deadlock. i.e the disk addition work couldn't be completed at the SCSI Transport Layer
as it can't send any I/Os (such as Inquiry, Report LUNs etc) to the disk as I/Os are blocked to this drive.
Also any subsequent device removal (TARGET_NOT_RESPONDING) or link update(RC_PHY_CHANGED) event
couldn't be processed as they are in the queue to get processed after disk addition event.

Description of Change:
To handle such cases, unblock the I/Os to the disk in ISR context if the disk is undergoing
addition. The I/Os would get unblocked only if the driver receives RC_PHY_CHANGED reason
code when the device addition is within the SAS Transport layer.

An module parameter 'unblock_io' is introduced which needs to be set to have this
functionality enabled. By default this functionality is disabled.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  4 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 63 +++++++++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 14 +++++++
 3 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 6b8d8f1..8dac951 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -294,7 +294,8 @@ struct _internal_cmd {
  * @responding: used in _scsih_sas_device_mark_responding
  * @fast_path: fast path feature enable bit
  * @pfa_led_on: flag for PFA LED status
- *
+ * @pend_sas_rphy_add: flag to check if device is in sas_rphy_add()
+ *	addition routine
  */
 struct _sas_device {
 	struct list_head list;
@@ -315,6 +316,7 @@ struct _sas_device {
 	u8	responding;
 	u8	fast_path;
 	u8	pfa_led_on;
+	u8	pend_sas_rphy_add;
 };
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5a97e32..2f45e8b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -111,6 +111,11 @@ static int missing_delay[2] = {-1, -1};
 module_param_array(missing_delay, int, NULL, 0);
 MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
 
+static int unblock_io;
+module_param(unblock_io, int, 0);
+MODULE_PARM_DESC(unblock_io,
+"unblocks IO if set to 1 when device is undergoing addition (default=0)");
+
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPT3SAS_MAX_LUN (16895)
 static u64 max_lun = MPT3SAS_MAX_LUN;
@@ -2606,6 +2611,34 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
 	}
 }
 
+/*
+ *_scsih_ublock_io_device_to_running - set the device state to SDEV_RUNNING
+ *@ioc: per adapter object
+ *@sas_addr: sas address
+ *
+ *unblock the device to receive IO during device addition. Device
+ *responsiveness is not checked before unblocking
+ */
+static void
+_scsih_ublock_io_device_to_running(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (sas_device_priv_data->sas_target->sas_address
+		      != sas_address)
+			continue;
+		if (sas_device_priv_data->block) {
+			sas_device_priv_data->block = 0;
+			scsi_internal_device_unblock(sdev, SDEV_RUNNING);
+		}
+	}
+}
+
 /**
  * _scsih_block_io_all_device - set the device state to SDEV_BLOCK
  * @ioc: per adapter object
@@ -2713,20 +2746,22 @@ _scsih_block_io_to_children_attached_to_ex(struct MPT3SAS_ADAPTER *ioc,
 }
 
 /**
- * _scsih_block_io_to_children_attached_directly
+ * _scsih_handle_io_to_children_attached_directly
  * @ioc: per adapter object
  * @event_data: topology change event data
  *
- * This routine set sdev state to SDEV_BLOCK for all devices
+ * This routine set sdev state to SDEV_BLOCK or SDEV_RUNNING for all devices
  * direct attached during device pull.
  */
 static void
-_scsih_block_io_to_children_attached_directly(struct MPT3SAS_ADAPTER *ioc,
+_scsih_handle_io_to_children_attached_directly(struct MPT3SAS_ADAPTER *ioc,
 	Mpi2EventDataSasTopologyChangeList_t *event_data)
 {
 	int i;
 	u16 handle;
 	u16 reason_code;
+	struct _sas_device *sas_device;
+	u8 link_rate, prev_link_rate;
 
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
@@ -2736,6 +2771,24 @@ _scsih_block_io_to_children_attached_directly(struct MPT3SAS_ADAPTER *ioc,
 		    MPI2_EVENT_SAS_TOPO_RC_MASK;
 		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING)
 			_scsih_block_io_device(ioc, handle);
+		else if ((reason_code == MPI2_EVENT_SAS_TOPO_RC_PHY_CHANGED) &&
+		    (unblock_io == 1)) {
+			/* unblock only if device is in the process of addition
+			 * within the SCSI Mid Layer (sas_rphy_add) to prevent
+			 * deadlock. Unblocking in other cases can lead to data
+			 * corruption */
+
+			link_rate = event_data->PHY[i].LinkRate >> 4;
+			prev_link_rate = event_data->PHY[i].LinkRate & 0xF;
+			sas_device = _scsih_sas_device_find_by_handle(ioc,
+								       handle);
+			if (!sas_device)
+				continue;
+			if ((link_rate > prev_link_rate) &&
+			    (sas_device->pend_sas_rphy_add == 1))
+				_scsih_ublock_io_device_to_running(ioc,
+				    sas_device->sas_address);
+		}
 	}
 }
 
@@ -3143,7 +3196,7 @@ _scsih_check_topo_delete_events(struct MPT3SAS_ADAPTER *ioc,
 
 	expander_handle = le16_to_cpu(event_data->ExpanderDevHandle);
 	if (expander_handle < ioc->sas_hba.num_phys) {
-		_scsih_block_io_to_children_attached_directly(ioc, event_data);
+		_scsih_handle_io_to_children_attached_directly(ioc, event_data);
 		return;
 	}
 	if (event_data->ExpStatus ==
@@ -3161,7 +3214,7 @@ _scsih_check_topo_delete_events(struct MPT3SAS_ADAPTER *ioc,
 				_scsih_block_io_device(ioc, handle);
 		} while (test_and_clear_bit(handle, ioc->blocking_handles));
 	} else if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_RESPONDING)
-		_scsih_block_io_to_children_attached_directly(ioc, event_data);
+		_scsih_handle_io_to_children_attached_directly(ioc, event_data);
 
 	if (event_data->ExpStatus != MPI2_EVENT_SAS_TOPO_ES_NOT_RESPONDING)
 		return;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index efb98af..1695f0f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -649,6 +649,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	unsigned long flags;
 	struct _sas_node *sas_node;
 	struct sas_rphy *rphy;
+	struct _sas_device *sas_device = NULL;
 	int i;
 	struct sas_port *port;
 
@@ -731,10 +732,23 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		    mpt3sas_port->remote_identify.device_type);
 
 	rphy->identify = mpt3sas_port->remote_identify;
+	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+		    mpt3sas_port->remote_identify.sas_address);
+		if (!sas_device) {
+			dfailprintk(ioc, printk(MPT3SAS_FMT
+			    "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__));
+			goto out_fail;
+		}
+		sas_device->pend_sas_rphy_add = 1;
+	}
 	if ((sas_rphy_add(rphy))) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
 	}
+	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE)
+		sas_device->pend_sas_rphy_add = 0;
 	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
 		dev_printk(KERN_INFO, &rphy->dev,
 			"add: handle(0x%04x), sas_addr(0x%016llx)\n",
-- 
2.0.2

