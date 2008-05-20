From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH 6/6] mpt fusion : Adding FAULT Reset polling work
Date: Wed, 21 May 2008 01:02:18 +0530
Message-ID: <20080520193217.GG11542@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42885 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbYETTkz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 15:40:55 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id m4KJbAT8020291
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 12:37:10 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com


When the firmware is in Fault state it will be identifed only when the next time
the driver access the IOC state.
This patch includes a polling function in the driver which will be executed in
regular interval to check the status of the firmware and if it is in Fault
state, then the firmware will be reset by the driver.

Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index f64f6b3..8c89e1e 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -253,6 +253,55 @@ mpt_get_cb_idx(MPT_DRIVER_CLASS dclass)
 	return 0;
 }
 
+/**
+ *	mpt_fault_reset_work - work performed on workq after ioc fault
+ *	@work: input argument, used to derive ioc
+ *
+**/
+static void
+mpt_fault_reset_work(struct work_struct *work)
+{
+	MPT_ADAPTER	*ioc =
+	    container_of(work, MPT_ADAPTER, fault_reset_work.work);
+	u32		 ioc_raw_state;
+	int		 rc;
+	unsigned long	 flags;
+
+	if (ioc->diagPending || !ioc->active)
+		goto out;
+
+	ioc_raw_state = mpt_GetIocState(ioc, 0);
+	if ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_FAULT) {
+		printk(MYIOC_s_WARN_FMT "IOC is in FAULT state (%04xh)!!!\n",
+		    ioc->name, ioc_raw_state & MPI_DOORBELL_DATA_MASK);
+		printk(MYIOC_s_WARN_FMT "Issuing HardReset from %s!!\n",
+		    ioc->name, __FUNCTION__);
+		rc = mpt_HardResetHandler(ioc, CAN_SLEEP);
+		printk(MYIOC_s_WARN_FMT "%s: HardReset: %s\n", ioc->name,
+		    __FUNCTION__, (rc == 0) ? "success" : "failed");
+		ioc_raw_state = mpt_GetIocState(ioc, 0);
+		if ((ioc_raw_state & MPI_IOC_STATE_MASK) == MPI_IOC_STATE_FAULT)
+			printk(MYIOC_s_WARN_FMT "IOC is in FAULT state after "
+			    "reset (%04xh)\n", ioc->name, ioc_raw_state &
+			    MPI_DOORBELL_DATA_MASK);
+	}
+
+ out:
+	/*
+	 * Take turns polling alternate controller
+	 */
+	if (ioc->alt_ioc)
+		ioc = ioc->alt_ioc;
+
+	/* rearm the timer */
+	spin_lock_irqsave(&ioc->fault_reset_work_lock, flags);
+	if (ioc->reset_work_q)
+		queue_delayed_work(ioc->reset_work_q, &ioc->fault_reset_work,
+			msecs_to_jiffies(MPT_POLLING_INTERVAL));
+	spin_unlock_irqrestore(&ioc->fault_reset_work_lock, flags);
+}
+
+
 /*
  *  Process turbo (context) reply...
  */
@@ -1671,6 +1720,22 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Find lookup slot. */
 	INIT_LIST_HEAD(&ioc->list);
 
+
+	/* Initialize workqueue */
+	INIT_DELAYED_WORK(&ioc->fault_reset_work, mpt_fault_reset_work);
+	spin_lock_init(&ioc->fault_reset_work_lock);
+
+	snprintf(ioc->reset_work_q_name, KOBJ_NAME_LEN, "mpt_poll_%d", ioc->id);
+	ioc->reset_work_q =
+		create_singlethread_workqueue(ioc->reset_work_q_name);
+	if (!ioc->reset_work_q) {
+		printk(MYIOC_s_ERR_FMT "Insufficient memory to add adapter!\n",
+		    ioc->name);
+		pci_release_selected_regions(pdev, ioc->bars);
+		kfree(ioc);
+		return -ENOMEM;
+	}
+
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
 	    ioc->name, &ioc->facts, &ioc->pfacts[0]));
 
@@ -1777,6 +1842,10 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		iounmap(ioc->memmap);
 		if (r != -5)
 			pci_release_selected_regions(pdev, ioc->bars);
+
+		destroy_workqueue(ioc->reset_work_q);
+		ioc->reset_work_q = NULL;
+
 		kfree(ioc);
 		pci_set_drvdata(pdev, NULL);
 		return r;
@@ -1809,6 +1878,10 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 #endif
 
+	if (!ioc->alt_ioc)
+		queue_delayed_work(ioc->reset_work_q, &ioc->fault_reset_work,
+			msecs_to_jiffies(MPT_POLLING_INTERVAL));
+
 	return 0;
 }
 
@@ -1824,6 +1897,19 @@ mpt_detach(struct pci_dev *pdev)
 	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
 	char pname[32];
 	u8 cb_idx;
+	unsigned long flags;
+	struct workqueue_struct *wq;
+
+	/*
+	 * Stop polling ioc for fault condition
+	 */
+	spin_lock_irqsave(&ioc->fault_reset_work_lock, flags);
+	wq = ioc->reset_work_q;
+	ioc->reset_work_q = NULL;
+	spin_unlock_irqrestore(&ioc->fault_reset_work_lock, flags);
+	cancel_delayed_work(&ioc->fault_reset_work);
+	destroy_workqueue(wq);
+
 
 	sprintf(pname, MPT_PROCFS_MPTBASEDIR "/%s/summary", ioc->name);
 	remove_proc_entry(pname, NULL);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 56630c6..762575b 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -176,6 +176,8 @@
 /* debug print string length used for events and iocstatus */
 # define EVENT_DESCR_STR_SZ             100
 
+#define MPT_POLLING_INTERVAL		1000	/* in milliseconds */
+
 #ifdef __KERNEL__	/* { */
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
@@ -713,6 +715,12 @@ typedef struct _MPT_ADAPTER
 	struct workqueue_struct *fc_rescan_work_q;
 	struct scsi_cmnd	**ScsiLookup;
 	spinlock_t		  scsi_lookup_lock;
+
+	char			 reset_work_q_name[KOBJ_NAME_LEN];
+	struct workqueue_struct *reset_work_q;
+	struct delayed_work	 fault_reset_work;
+	spinlock_t		 fault_reset_work_lock;
+
 } MPT_ADAPTER;
 
 /*
