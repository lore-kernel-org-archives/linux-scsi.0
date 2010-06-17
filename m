From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 05/08] mptfusion: schedule_target_reset from all Reset context
Date: Thu, 17 Jun 2010 14:40:56 +0530
Message-ID: <20100617091047.GF29165@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:48429 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932805Ab0FQJqd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 05:46:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Issue:
target reset will be queued to driver's internal queue to get schedule
later. When driver add target into internal target_reset queue we will block IOs
on those target using scsi midlayer API. Now due to some cause driver is not
executing those target_reset list and it is always in block state.

Changes:
now we are clearing target_reset queue from all other Callback context
instead of only DeviceReset context.Now wherever driver is clearing
taskmgmt_in_progress flag it is considering target_reset queue cleanup
also.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 453bcb7..a2a620c 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -580,6 +580,7 @@ struct mptfc_rport_info
 typedef void (*MPT_ADD_SGE)(void *pAddr, u32 flagslength, dma_addr_t dma_addr);
 typedef void (*MPT_ADD_CHAIN)(void *pAddr, u8 next, u16 length,
 		dma_addr_t dma_addr);
+typedef void (*MPT_SCHEDULE_TARGET_RESET)(void *ioc);
 
 /*
  *  Adapter Structure - pci_dev specific. Maximum: MPT_MAX_ADAPTERS
@@ -738,6 +739,7 @@ typedef struct _MPT_ADAPTER
 	int			 taskmgmt_in_progress;
 	u8			 taskmgmt_quiesce_io;
 	u8			 ioc_reset_in_progress;
+	MPT_SCHEDULE_TARGET_RESET schedule_target_reset;
 	struct work_struct	 sas_persist_task;
 
 	struct work_struct	 fc_setup_reset_work;
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index f06b291..9bd89ce 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -261,10 +261,16 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 	/* We are done, issue wake up
 	 */
 	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_PENDING) {
-		if (req->u.hdr.Function == MPI_FUNCTION_SCSI_TASK_MGMT)
+		if (req->u.hdr.Function == MPI_FUNCTION_SCSI_TASK_MGMT) {
 			mpt_clear_taskmgmt_in_progress_flag(ioc);
-		ioc->ioctl_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
-		complete(&ioc->ioctl_cmds.done);
+			ioc->ioctl_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
+			complete(&ioc->ioctl_cmds.done);
+			if (ioc->bus_type == SAS)
+				ioc->schedule_target_reset(ioc);
+		} else {
+			ioc->ioctl_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
+			complete(&ioc->ioctl_cmds.done);
+		}
 	}
 
  out_continuation:
@@ -298,6 +304,8 @@ mptctl_taskmgmt_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 		mpt_clear_taskmgmt_in_progress_flag(ioc);
 		ioc->taskmgmt_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
 		complete(&ioc->taskmgmt_cmds.done);
+		if (ioc->bus_type == SAS)
+			ioc->schedule_target_reset(ioc);
 		return 1;
 	}
 	return 0;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 92f033a..ecd1dcd 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -126,6 +126,7 @@ static void mptsas_scan_sas_topology(MPT_ADAPTER *ioc);
 static void mptsas_broadcast_primative_work(struct fw_event_work *fw_event);
 static void mptsas_handle_queue_full_event(struct fw_event_work *fw_event);
 static void mptsas_volume_delete(MPT_ADAPTER *ioc, u8 id);
+void	mptsas_schedule_target_reset(void *ioc);
 
 static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
 					MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
@@ -1139,6 +1140,44 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
 }
 
 /**
+ * mptsas_schedule_target_reset- send pending target reset
+ * @iocp: per adapter object
+ *
+ * This function will delete scheduled target reset from the list and
+ * try to send next target reset. This will be called from completion
+ * context of any Task managment command.
+ */
+
+void
+mptsas_schedule_target_reset(void *iocp)
+{
+	MPT_ADAPTER *ioc = (MPT_ADAPTER *)(iocp);
+	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
+	struct list_head *head = &hd->target_reset_list;
+	struct mptsas_target_reset_event	*target_reset_list;
+	u8		id, channel;
+	/*
+	 * issue target reset to next device in the queue
+	 */
+
+	head = &hd->target_reset_list;
+	if (list_empty(head))
+		return;
+
+	target_reset_list = list_entry(head->next,
+		struct mptsas_target_reset_event, list);
+
+	id = target_reset_list->sas_event_data.TargetID;
+	channel = target_reset_list->sas_event_data.Bus;
+	target_reset_list->time_count = jiffies;
+
+	if (mptsas_target_reset(ioc, channel, id))
+		target_reset_list->target_reset_issued = 1;
+	return;
+}
+
+
+/**
  *	mptsas_taskmgmt_complete - complete SAS task management function
  *	@ioc: Pointer to MPT_ADAPTER structure
  *
@@ -1227,23 +1266,7 @@ mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			&target_reset_list->sas_event_data);
 
 
-	/*
-	 * issue target reset to next device in the queue
-	 */
-
-	head = &hd->target_reset_list;
-	if (list_empty(head))
-		return 1;
-
-	target_reset_list = list_entry(head->next, struct mptsas_target_reset_event,
-	    list);
-
-	id = target_reset_list->sas_event_data.TargetID;
-	channel = target_reset_list->sas_event_data.Bus;
-	target_reset_list->time_count = jiffies;
-
-	if (mptsas_target_reset(ioc, channel, id))
-		target_reset_list->target_reset_issued = 1;
+	ioc->schedule_target_reset(ioc);
 
 	return 1;
 }
@@ -4961,7 +4984,7 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->DoneCtx = mptsasDoneCtx;
 	ioc->TaskCtx = mptsasTaskCtx;
 	ioc->InternalCtx = mptsasInternalCtx;
-
+	ioc->schedule_target_reset = &mptsas_schedule_target_reset;
 	/*  Added sanity check on readiness of the MPT adapter.
 	 */
 	if (ioc->last_state != MPI_IOC_STATE_OPERATIONAL) {
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 2a32c8d..4d579ce 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2134,6 +2134,8 @@ mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf,
 		mpt_clear_taskmgmt_in_progress_flag(ioc);
 		ioc->taskmgmt_cmds.status &= ~MPT_MGMT_STATUS_PENDING;
 		complete(&ioc->taskmgmt_cmds.done);
+		if (ioc->bus_type == SAS)
+			ioc->schedule_target_reset(ioc);
 		return 1;
 	}
 	return 0;
