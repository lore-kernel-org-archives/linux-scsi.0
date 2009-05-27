From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 15/22] mpt fusion: RESEND [2.6.30-rc6]  Rescan SAS topology added
Date: Wed, 27 May 2009 18:11:44 +0530
Message-ID: <20090527124139.GP20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og114.obsmtp.com ([64.18.2.215]:60505 "EHLO
	exprod7og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763980AbZE0NDA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 09:03:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


1.) SAS topology Rescan is added. If Firmware is doing Reset and we get
Device add interrupt from Firmware, we will not receive it as part of Reset
is going ON. After Reset we will do special Rescan of SAS topology.
2.) Driver version changed from 3.04.08 to 3.04.09.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 8d1aadb..11fc8f3 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2008 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.04.08"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.08"
+#define MPT_LINUX_VERSION_COMMON	"3.04.09"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.04.09"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -711,6 +711,7 @@ typedef struct _MPT_ADAPTER
 	u16			 hba_port_num_phy;
 	struct list_head	 sas_device_info_list;
 	struct mutex		 sas_device_info_mutex;
+	u8			 old_sas_discovery_protocal;
 	u8			 sas_discovery_quiesce_io;
 	int			 sas_index; /* index refrencing */
 	MPT_MGMT		 sas_mgmt;
@@ -741,6 +742,7 @@ typedef struct _MPT_ADAPTER
 	spinlock_t		 fault_reset_work_lock;
 
 	u8			sg_addr_size;
+	u8			in_rescan;
 	u8			SGE_size;
 
 } MPT_ADAPTER;
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 01cdbe1..ce67815 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -119,6 +119,8 @@ static struct mptsas_portinfo	*mptsas_find_portinfo_by_sas_address
 static void mptsas_expander_delete(MPT_ADAPTER *ioc,
 		struct mptsas_portinfo *port_info, u8 force);
 static void mptsas_send_expander_event(struct fw_event_work *fw_event);
+static void mptsas_not_responding_devices(MPT_ADAPTER *ioc);
+static void mptsas_scan_sas_topology(MPT_ADAPTER *ioc);
 
 static void mptsas_print_phy_data(MPT_ADAPTER *ioc,
 					MPI_SAS_IO_UNIT0_PHY_DATA *phy_data)
@@ -844,6 +846,24 @@ mptsas_queue_device_delete(MPT_ADAPTER *ioc,
 	mptsas_add_fw_event(ioc, fw_event, msecs_to_jiffies(1));
 }
 
+static void
+mptsas_queue_rescan(MPT_ADAPTER *ioc)
+{
+	struct fw_event_work *fw_event;
+	int sz;
+
+	sz = offsetof(struct fw_event_work, event_data);
+	fw_event = kzalloc(sz, GFP_ATOMIC);
+	if (!fw_event) {
+		printk(MYIOC_s_WARN_FMT "%s: failed at (line=%d)\n",
+		    ioc->name, __func__, __LINE__);
+		return;
+	}
+	fw_event->event = -1;
+	fw_event->ioc = ioc;
+	mptsas_add_fw_event(ioc, fw_event, msecs_to_jiffies(1));
+}
+
 
 /**
  * mptsas_target_reset
@@ -1100,6 +1120,7 @@ mptsas_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 			complete(&ioc->sas_mgmt.done);
 		}
 		mptsas_cleanup_fw_event_q(ioc);
+		mptsas_queue_rescan(ioc);
 		mptsas_fw_event_on(ioc);
 		break;
 	default:
@@ -1406,6 +1427,23 @@ mptsas_firmware_event_work(struct work_struct *work)
 		container_of(work, struct fw_event_work, work.work);
 	MPT_ADAPTER *ioc = fw_event->ioc;
 
+	/* special rescan topology handling */
+	if (fw_event->event == -1) {
+		if (ioc->in_rescan) {
+			devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				"%s: rescan ignored as it is in progress\n",
+				ioc->name, __func__));
+			return;
+		}
+		devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT "%s: rescan after "
+		    "reset\n", ioc->name, __func__));
+		ioc->in_rescan = 1;
+		mptsas_not_responding_devices(ioc);
+		mptsas_scan_sas_topology(ioc);
+		ioc->in_rescan = 0;
+		mptsas_free_fw_event(ioc, fw_event);
+		return;
+	}
 
 	/* events handling turned off during host reset */
 	if (ioc->fw_events_off) {
@@ -3153,8 +3191,15 @@ mptsas_send_link_status_event(struct fw_event_work *fw_event)
 	if (link_rate == MPI_SAS_IOUNIT0_RATE_1_5 ||
 	    link_rate == MPI_SAS_IOUNIT0_RATE_3_0) {
 
-		if (!port_info)
+		if (!port_info) {
+			if (ioc->old_sas_discovery_protocal) {
+				port_info = mptsas_expander_add(ioc,
+					le16_to_cpu(link_data->DevHandle));
+				if (port_info)
+					goto out;
+			}
 			goto out;
+		}
 
 		if (port_info == ioc->hba_port_info)
 			mptsas_probe_hba_phys(ioc);
@@ -3176,6 +3221,116 @@ mptsas_send_link_status_event(struct fw_event_work *fw_event)
 	mptsas_free_fw_event(ioc, fw_event);
 }
 
+static void
+mptsas_not_responding_devices(MPT_ADAPTER *ioc)
+{
+	struct mptsas_portinfo buffer, *port_info;
+	struct sas_device_info	*sas_info;
+	struct mptsas_devinfo sas_device;
+	u32	handle;
+	VirtTarget *vtarget = NULL;
+	struct mptsas_phyinfo *phy_info;
+	u8 found_expander;
+	int retval, retry_count;
+	unsigned long flags;
+
+	mpt_findImVolumes(ioc);
+
+	spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+	if (ioc->ioc_reset_in_progress) {
+		dfailprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		   "%s: exiting due to a parallel reset \n", ioc->name,
+		    __func__));
+		spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
+
+	/* devices, logical volumes */
+ redo_device_scan:
+	list_for_each_entry(sas_info, &ioc->sas_device_info_list, list) {
+		sas_device.handle = 0;
+		retry_count = 0;
+retry_page:
+		retval = mptsas_sas_device_pg0(ioc, &sas_device,
+				(MPI_SAS_DEVICE_PGAD_FORM_BUS_TARGET_ID
+				<< MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+				(sas_info->fw.channel << 8) +
+				sas_info->fw.id);
+
+		if (sas_device.handle)
+			continue;
+		if (retval == -EBUSY) {
+			spin_lock_irqsave(&ioc->taskmgmt_lock, flags);
+			if (ioc->ioc_reset_in_progress) {
+				dfailprintk(ioc,
+				    printk(MYIOC_s_DEBUG_FMT
+				    "%s: exiting due to reset\n",
+				    ioc->name, __func__));
+				spin_unlock_irqrestore
+				    (&ioc->taskmgmt_lock, flags);
+				return;
+			}
+			spin_unlock_irqrestore(&ioc->taskmgmt_lock,
+			flags);
+		}
+
+		if (retval && (retval != -ENODEV)) {
+			if (retry_count < 10) {
+				retry_count++;
+				goto retry_page;
+			} else {
+				devtprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+				"%s: Config page retry exceeded retry "
+				"count deleting device 0x%llx\n",
+				ioc->name, __func__,
+				sas_info->sas_address));
+			}
+		}
+
+		/* delete device */
+		vtarget = mptsas_find_vtarget(ioc,
+				sas_info->fw.channel, sas_info->fw.id);
+		if (vtarget)
+			vtarget->deleted = 1;
+		phy_info = mptsas_find_phyinfo_by_sas_address(ioc,
+		    sas_info->sas_address);
+		if (phy_info) {
+			mptsas_del_end_device(ioc, phy_info);
+			goto redo_device_scan;
+		}
+	}
+
+	/* expanders */
+ redo_expander_scan:
+	list_for_each_entry(port_info, &ioc->sas_topology, list) {
+
+		if (port_info->phy_info &&
+		    (!(port_info->phy_info[0].identify.device_info &
+		    MPI_SAS_DEVICE_INFO_SMP_TARGET)))
+			continue;
+		found_expander = 0;
+		handle = 0xFFFF;
+		while (!mptsas_sas_expander_pg0(ioc, &buffer,
+		    (MPI_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE <<
+		     MPI_SAS_EXPAND_PGAD_FORM_SHIFT), handle) &&
+		    !found_expander) {
+
+			handle = buffer.phy_info[0].handle;
+			if (buffer.phy_info[0].identify.sas_address ==
+			    port_info->phy_info[0].identify.sas_address) {
+				found_expander = 1;
+			}
+			kfree(buffer.phy_info);
+		}
+
+		if (!found_expander) {
+			mptsas_expander_delete(ioc, port_info, 0);
+			goto redo_expander_scan;
+		}
+	}
+}
+
 /**
  *	mptsas_probe_expanders - adding expanders
  *	@ioc: Pointer to MPT_ADAPTER structure
@@ -3895,6 +4050,8 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 		MpiEventDataSasExpanderStatusChange_t *expander_data =
 		    (MpiEventDataSasExpanderStatusChange_t *)reply->Data;
 
+		if (ioc->old_sas_discovery_protocal)
+			return 0;
 
 		if (expander_data->ReasonCode ==
 		    MPI_EVENT_SAS_EXP_RC_NOT_RESPONDING &&
@@ -3910,6 +4067,8 @@ mptsas_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *reply)
 
 		discovery_status = le32_to_cpu(discovery_data->DiscoveryStatus);
 		ioc->sas_discovery_quiesce_io = discovery_status ? 1 : 0;
+		if (ioc->old_sas_discovery_protocal && !discovery_status)
+			mptsas_queue_rescan(ioc);
 		return 0;
 	}
 	case MPI_EVENT_INTEGRATED_RAID:
@@ -4117,6 +4276,9 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_mptsas_probe;
 	}
 
+	/* older firmware doesn't support expander events */
+	if ((ioc->facts.HeaderVersion >> 8) < 0xE)
+		ioc->old_sas_discovery_protocal = 1;
 	mptsas_scan_sas_topology(ioc);
 	mptsas_fw_event_on(ioc);
 	return 0;
