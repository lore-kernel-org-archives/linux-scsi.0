From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 5/6] mpt fusion: Link speed change display support
Date: Tue, 14 Aug 2007 16:19:32 +0530
Message-ID: <20070814104932.GE9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39724 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbXHNKw5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2007 06:52:57 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l7EApQLS024965
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 03:51:26 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

When there is state change in FC links, a message is displayed with old and new link speed.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 04ef0a3..1197eba 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -698,6 +698,8 @@ typedef struct _MPT_ADAPTER
 
 	struct work_struct	 fc_setup_reset_work;
 	struct list_head	 fc_rports;
+	struct work_struct	 fc_lsc_work;
+	u8			 fc_link_speed[2];
 	spinlock_t		 fc_rescan_work_lock;
 	struct work_struct	 fc_rescan_work;
 	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 2b3e27a..aadb071 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -675,6 +675,50 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 }
 
 /*
+ *	mptfc_display_port_link_speed - displaying link speed
+ *	@ioc: Pointer to MPT_ADAPTER structure
+ *	@portnum: IOC Port number
+ *	@pp0dest: port page0 data payload
+ *
+ */
+static void
+mptfc_display_port_link_speed(MPT_ADAPTER *ioc, int portnum, FCPortPage0_t *pp0dest)
+{
+	u8	old_speed, new_speed, state;
+	char	*old, *new;
+
+	if (portnum >= 2)
+		return;
+
+	old_speed = ioc->fc_link_speed[portnum];
+	new_speed = pp0dest->CurrentSpeed;
+	state = pp0dest->PortState;
+
+	if (state != MPI_FCPORTPAGE0_PORTSTATE_OFFLINE &&
+	    new_speed != MPI_FCPORTPAGE0_CURRENT_SPEED_UKNOWN) {
+
+		old = old_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_1GBIT ? "1 Gbps" :
+		       old_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_2GBIT ? "2 Gbps" :
+			old_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_4GBIT ? "4 Gbps" :
+			 "Unknown";
+		new = new_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_1GBIT ? "1 Gbps" :
+		       new_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_2GBIT ? "2 Gbps" :
+			new_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_4GBIT ? "4 Gbps" :
+			 "Unknown";
+		if (old_speed == 0)
+			printk(MYIOC_s_NOTE_FMT
+				"FC Link Established, Speed = %s\n",
+				ioc->name, new);
+		else if (old_speed != new_speed)
+			printk(MYIOC_s_WARN_FMT
+				"FC Link Speed Change, Old Speed = %s, New Speed = %s\n",
+				ioc->name, old, new);
+
+		ioc->fc_link_speed[portnum] = new_speed;
+	}
+}
+
+/*
  *	mptfc_GetFcPortPage0 - Fetch FCPort config Page0.
  *	@ioc: Pointer to MPT_ADAPTER structure
  *	@portnum: IOC Port number
@@ -773,6 +817,7 @@ mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
 							" complete.\n",
 						ioc->name);
 			}
+			mptfc_display_port_link_speed(ioc, portnum, pp0dest);
 		}
 
 		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc, page0_dma);
@@ -1023,6 +1068,18 @@ mptfc_init_host_attr(MPT_ADAPTER *ioc,int portnum)
 }
 
 static void
+mptfc_link_status_change(struct work_struct *work)
+{
+	MPT_ADAPTER             *ioc =
+		container_of(work, MPT_ADAPTER, fc_rescan_work);
+	int ii;
+
+	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++)
+		(void) mptfc_GetFcPortPage0(ioc, ii);
+
+}
+
+static void
 mptfc_setup_reset(struct work_struct *work)
 {
 	MPT_ADAPTER		*ioc =
@@ -1163,6 +1220,7 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->fc_rescan_work_lock);
 	INIT_WORK(&ioc->fc_rescan_work, mptfc_rescan_devices);
 	INIT_WORK(&ioc->fc_setup_reset_work, mptfc_setup_reset);
+	INIT_WORK(&ioc->fc_lsc_work, mptfc_link_status_change);
 
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
@@ -1337,6 +1395,14 @@ mptfc_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply)
 		}
 		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
 		break;
+	case MPI_EVENT_LINK_STATUS_CHANGE:
+		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
+		if (ioc->fc_rescan_work_q) {
+			queue_work(ioc->fc_rescan_work_q,
+				   &ioc->fc_lsc_work);
+		}
+		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
+		break;
 	default:
 		rc = mptscsih_event_process(ioc,pEvReply);
 		break;
