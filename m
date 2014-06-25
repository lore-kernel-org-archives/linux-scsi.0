From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Subject: [RESEND][PATCH 09/10][SCSI]mpt2sas: Added module parameter
 'unblock_io' to unblock IO's during disk addition
Date: Wed, 25 Jun 2014 16:06:15 +0530
Message-ID: <20140625103615.GA12959@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, sreekanth.reddy@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org


During hot-plugging of a disk(having a flaky link) the disk addition
stops and any further disk addition or removal doesn't happen on that controller.

This is because, when driver receives DELAY_NOT_RESPONDING for a disk when it is undergoing
addition in the SCSI Mid layer, the driver would block the I/O to that disk
resulting in a deadlock. i.e the disk addition work couldn't be completed
as it can't send any I/O to the disk as I/Os are blocked. Any device removal (TARGET_NOT_RESPONDING)
or link update(RC_PHY_CHANGED) couldn't be processed as they are in the queue
to get processed after disk addition.

Description of Change:
To handle such cases, unblock the I/Os to the disk in ISR context if the disk is undergoing
addition. The I/Os would get unblocked only if the driver receives RC_PHY_CHANGED reason
code when the device addition is within the SAS Transport layer.

An module parameter 'unblock_io' is introduced which needs to be set to have this
functionality enabled. By default this functionality is disabled.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h      |    3 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c     |   67 ++++++++++++++++++++++++++---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |   13 ++++++
 3 files changed, 76 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 32181a6..7de7ba4 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -356,6 +356,8 @@ struct _internal_cmd {
  * @phy: phy identifier provided in sas device page 0
  * @responding: used in _scsih_sas_device_mark_responding
  * @pfa_led_on: flag for PFA LED status
+ * @pend_sas_rphy_add: flag to check if device is in sas_rphy_add()
+ *			addition routine
  */
 struct _sas_device {
 	struct list_head list;
@@ -375,6 +377,7 @@ struct _sas_device {
 	u8	phy;
 	u8	responding;
 	u8	pfa_led_on;
+	u8	pend_sas_rphy_add;
 };
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 4a0728a..b08d8fd 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -105,6 +105,11 @@ static int missing_delay[2] = {-1, -1};
 module_param_array(missing_delay, int, NULL, 0);
 MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
 
+static int unblock_io;
+module_param(unblock_io, int, 0);
+MODULE_PARM_DESC(unblock_io,
+"unblocks I/O if set to 1 when device is undergoing addition (default=0)");
+
 /* scsi-mid layer global parmeter is max_report_luns, which is 511 */
 #define MPT2SAS_MAX_LUN (16895)
 static int max_lun = MPT2SAS_MAX_LUN;
@@ -2972,6 +2977,34 @@ _scsih_ublock_io_device(struct MPT2SAS_ADAPTER *ioc, u64 sas_address)
 }
 
 /**
+ * _scsih_ublock_io_device_to_running - set the device state to SDEV_RUNNING
+ * @ioc: per adapter object
+ * @sas_addr: sas address
+ *
+ * unblock the device to receive IO during device addition. Device
+ * responsiveness is not checked before unblocking
+ */
+static void
+_scsih_ublock_io_device_to_running(struct MPT2SAS_ADAPTER *ioc, u64 sas_address)
+{
+	struct MPT2SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (sas_device_priv_data->sas_target->sas_address
+		    != sas_address)
+			continue;
+		if (sas_device_priv_data->block) {
+			sas_device_priv_data->block = 0;
+			scsi_internal_device_unblock(sdev, SDEV_RUNNING);
+		}
+	}
+}
+
+/**
  * _scsih_block_io_all_device - set the device state to SDEV_BLOCK
  * @ioc: per adapter object
  * @handle: device handle
@@ -3081,21 +3114,23 @@ _scsih_block_io_to_children_attached_to_ex(struct MPT2SAS_ADAPTER *ioc,
 }
 
 /**
- * _scsih_block_io_to_children_attached_directly
+ * _scsih_handle_io_to_children_attached_directly
  * @ioc: per adapter object
  * @event_data: topology change event data
  *
- * This routine set sdev state to SDEV_BLOCK for all devices
- * direct attached during device pull.
+ * This routine set sdev state to SDEV_BLOCK or SDEV_RUNNING for all devices
+ * direct attached during device pull/reconnect.
  */
 static void
-_scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
-    Mpi2EventDataSasTopologyChangeList_t *event_data)
+_scsih_handle_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
+	Mpi2EventDataSasTopologyChangeList_t *event_data)
 {
 	int i;
 	u16 handle;
 	u16 reason_code;
 	u8 phy_number;
+	struct _sas_device *sas_device;
+	u8 link_rate, prev_link_rate;
 
 	for (i = 0; i < event_data->NumEntries; i++) {
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
@@ -3106,6 +3141,24 @@ _scsih_block_io_to_children_attached_directly(struct MPT2SAS_ADAPTER *ioc,
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
+					handle);
+			if (!sas_device)
+				continue;
+			if ((link_rate > prev_link_rate) &&
+			    (sas_device->pend_sas_rphy_add == 1))
+				_scsih_ublock_io_device_to_running(ioc,
+				    sas_device->sas_address);
+		}
 	}
 }
 
@@ -3497,7 +3550,7 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 
 	expander_handle = le16_to_cpu(event_data->ExpanderDevHandle);
 	if (expander_handle < ioc->sas_hba.num_phys) {
-		_scsih_block_io_to_children_attached_directly(ioc, event_data);
+		_scsih_handle_io_to_children_attached_directly(ioc, event_data);
 		return;
 	}
 	if (event_data->ExpStatus ==
@@ -3515,7 +3568,7 @@ _scsih_check_topo_delete_events(struct MPT2SAS_ADAPTER *ioc,
 				_scsih_block_io_device(ioc, handle);
 		} while (test_and_clear_bit(handle, ioc->blocking_handles));
 	} else if (event_data->ExpStatus == MPI2_EVENT_SAS_TOPO_ES_RESPONDING)
-		_scsih_block_io_to_children_attached_directly(ioc, event_data);
+		_scsih_handle_io_to_children_attached_directly(ioc, event_data);
 
 	if (event_data->ExpStatus != MPI2_EVENT_SAS_TOPO_ES_NOT_RESPONDING)
 		return;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 0d1d064..f09f5f3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -654,6 +654,7 @@ mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 	unsigned long flags;
 	struct _sas_node *sas_node;
 	struct sas_rphy *rphy;
+	struct _sas_device *sas_device = NULL;
 	int i;
 	struct sas_port *port;
 
@@ -736,10 +737,22 @@ mpt2sas_transport_port_add(struct MPT2SAS_ADAPTER *ioc, u16 handle,
 		    mpt2sas_port->remote_identify.device_type);
 
 	rphy->identify = mpt2sas_port->remote_identify;
+	if (mpt2sas_port->remote_identify.device_type == SAS_END_DEVICE) {
+		sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+		    mpt2sas_port->remote_identify.sas_address);
+		if (!sas_device) {
+			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			goto out_fail;
+		}
+		sas_device->pend_sas_rphy_add = 1;
+	}
 	if ((sas_rphy_add(rphy))) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
 	}
+	if (mpt2sas_port->remote_identify.device_type == SAS_END_DEVICE)
+		sas_device->pend_sas_rphy_add = 0;
 	if ((ioc->logging_level & MPT_DEBUG_TRANSPORT))
 		dev_printk(KERN_INFO, &rphy->dev, "add: handle(0x%04x), "
 		    "sas_addr(0x%016llx)\n", handle,
-- 
1.7.1
