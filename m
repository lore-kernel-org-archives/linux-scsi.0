Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793626870;
	b=fLr+ZJChucgO4akujQE2qMsMxRex49CtL2xnuFZUSJfq4Us8lP4bAxp+jGXLMjhQ0+SC
	 f19ec/b7XGgN8BZzbgunBBCI2+U+VN7Ol6LqnhN/d6pvldTPhkaV13efNQ4iRvBSXqOIz
	 Id5JHMQpUMnNsv+8iptMjLiTT8g/O7S1uLRjpLS15UhtDnzFfqET58L4IerOHVIfVhi1S
	 eLqSV3KvOgM7thRomheNsNr9rpmkdb7oXA6O8oJ1CXloFWpOwiQVSsPmZ6sFrKh9q81S7
	 GS0rOmZluanDmBdhC/bL/VSE0DBddgymCdJuQeK4VkLNc7Z+YaNZ7n64Fn/usmcJh8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793626870;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=CbdbnSXTBBpNI6V/PFphDNfPDoeo1OyyfQqOsXBrUqo=;
	b=g8stMPuUrxCbARC+ToFXOgdZxtQ1Ttt56uqoTRKh5h1eazMYyl+oMRvVn3UgEc5BuGOa
	 iLd30RaA1PTv55Y2Z37/xYMwOgBrhxwly1qcbFEim7fjJ/W2EIv2n6aTklDqBQmPd639l
	 FyTb7A0jse2zJ0NwDIkLESx26Pg/BVhIDIzP/doE47wvLRV//Anesv+XEWMIegATt/xuI
	 WrQvJ9AJWikiZw02nEp67XvQRiCfbzKScantZhzUx0Qt+lvCeDJSh8RygzYWlwHNxt7em
	 LJJlqF8gUffatoCDzKVQBfXeQloVmseZub8FeQvsRd4KPRV++C1cYlLxe+MFvTuUoXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VaHWZrqe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB0260A6F71;
	Mon,  2 Nov 2026 13:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VaHWZrqe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756091F00A18;
	Mon,  2 Nov 2026 13:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793626869;
	bh=CbdbnSXTBBpNI6V/PFphDNfPDoeo1OyyfQqOsXBrUqo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VaHWZrqetnbZRnInqoetUvaowDTRWC2/VDE78PkebLr9GGVOVf8LQJa88hcm+//Gz
	 006QXGyT81d183qTqUNYSOm1BqvVlO33Ezyltif3KnPPg//vPW9kxBfb0BHPHW6CAu
	 ZpCE4BrMtm4iGjy0pwtV29LrqVjD70Tb8dMU2xd7dI92blfzRfvaPKzmLISUm1Qblq
	 6EDH5yg/9pTmKKuWc8z3P/BIfWKEhjuXR2IgTAw5EkMrJz0oTxSoeeUFS8o2+6Fw/3
	 +mJYVhp4XtsfcfcLjdNluOCnifoFulqKtLS8V/G1qztXrVZi8b5W4K9X4u0cMFqY9B
	 geT3RZlWVPDjw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 02 Nov 2026 08:40:46 -0500
Subject: [PATCH v2 2/2] scsi: mpt3sas: Time out delayed not-responding
 device blocks
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-sas-abba-v2-2-b3b9ba874b5a@kernel.org>
References: <20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org>
In-Reply-To: <20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Keith Busch <kbusch@kernel.org>, 
 Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=13640; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Ay1sckbv0Qy8zYMSXgYwcaXkzTq7uk5LLsNXltM7FSg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq6JLxyvf8EW3BpVtI94SIcBpl202tZWVBvgR68
 mdMO+Y7qmCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauiS8QAKCRAADmhBGVaC
 FY0AD/4vL6N/Y6UZQwwUQrm5o04JJD17+hVedtwOxAi7mnDtBy1AHB1toanouOel5UYpENjv3OV
 ac/Gzgtt2t2e6g0p2z7oeq7ThMJVed3dalTYsK74CajhyZ3bIbaSpSB97EWMTqQ3xScKXilRrBZ
 doRs94uQ0R8ogkGyAdgxYpigrBguRrerKSZSYUxk6EwyklsnG+YB352nIf1vWq8vB4en06AIu3M
 sgfcJf2C35jwSg9lOmc9AegkuEy6GgwG3kQ0qZsUR88HFXD5ERGshvBnqtmm4SrPdQHEvRUKKYP
 KK+Ch9YoAhCLf7GwrUtGj7a746ayxmR/X2Qc5vuCusl0GhQqFkyWomlKkZ6dsTWqFa6EPfflECJ
 0uNEkZGT/ZkTPiSZmvKOTt87UVaF+PVqg42mdlKDHfMvwplLbtoiKhAj5mXULzpYtknfK964VOa
 ud1UxgKHfBw/etNe+zBX9gzR3UWa+Hc4ISEmxdsaavM/IBebbGUeF+QL3S4liNwk7Dy0n9rbdkW
 5ZKafu8jPJl/RwJAgXMOMBMRyBdzRFj0Bu8vzMjlHaOsggIBdqAiRsee/v7JCquR0bGyBi0adae
 R+rhDESoQ0cYKm4L+LwQzBXW1jdtJeNuiY6TuonNrqLnuXJetTXfZXBCQcXmoOiY9Eoz8x9sYpy
 XuX4zhrIGbtQl0Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

We have an agent that writes "- - -" to the sysfs scan attribute at
regular intervals. Several of these scans ended up deadlocked:

 1. A drive in reset failed its initial scan, so the worker started to
    remove the drive.
 2. A sysfs scan took sas_host->lock, allocated an sdev for the drive
    and sent an INQUIRY.
 3. A DELAY_NOT_RESPONDING event blocked the new sdev.
 4. The worker waited for sas_host->lock in sas_rphy_free():

      __mutex_lock
      sas_port_delete+0x75 [scsi_transport_sas]
      mpt3sas_transport_port_remove
      _scsih_add_device

After that, all further scan attempts got stuck waiting on the
sas_host->lock.

On DELAY_NOT_RESPONDING the event callback blocks every sdev on the
handle. The block is released only:
 - by the callback, if the firmware later reports TARG_NOT_RESPONDING
 - by the firmware event worker, when it processes a later event

Commit e4bc7f5c21a1 ("mpt3sas: Don't block the drive when drive addition
under the control of SML") was a partial fix for a similar issue.  Not
blocking sdevs that a scan is still probing is not enough: the scan also
sends REPORT LUNS to LUN 0 once it is visible, and LUN 0 may be blocked
before or during the scan.

Within the report device missing delay, the firmware either reports the
device as not responding, and the callback unblocks it, or the device
has come back. Past that delay the block has no further use.

Schedule delayed_work to the system_wq for the missing delay plus 30s.
When it runs, unblock any expired sdevs.

Cc: Keith Busch <kbusch@kernel.org>
Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  10 +++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  10 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 121 +++++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1af25a22611a..1c4d10acc7ff 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5405,6 +5405,7 @@ _base_update_diag_trigger_pages(struct MPT3SAS_ADAPTER *ioc)
 /**
  * _base_assign_fw_reported_qd	- Get FW reported QD for SAS/SATA devices.
  *				- On failure set default QD values.
+ *				- Also get the PCIe device missing delay.
  * @ioc : per adapter object
  *
  * Returns 0 for success, non-zero for failure.
@@ -5416,6 +5417,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2SasIOUnitPage1_t sas_iounit_pg1;
 	Mpi26PCIeIOUnitPage1_t pcie_iounit_pg1;
 	u16 depth;
+	u8 dmd;
 	int rc = 0;
 
 	ioc->max_wideport_qd = MPT3SAS_SAS_QUEUE_DEPTH;
@@ -5453,6 +5455,14 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	ioc->max_nvme_qd = (le16_to_cpu(pcie_iounit_pg1.NVMeMaxQueueDepth)) ?
 	    (le16_to_cpu(pcie_iounit_pg1.NVMeMaxQueueDepth)) :
 	    MPT3SAS_NVME_QUEUE_DEPTH;
+
+	dmd = pcie_iounit_pg1.DMDReportPCIe;
+	if (dmd & MPI26_PCIEIOUNIT1_DMDRPT_UNIT_16_SEC)
+		ioc->pcie_device_missing_delay =
+		    (dmd & MPI26_PCIEIOUNIT1_DMDRPT_DELAY_TIME_MASK) * 16;
+	else
+		ioc->pcie_device_missing_delay =
+		    dmd & MPI26_PCIEIOUNIT1_DMDRPT_DELAY_TIME_MASK;
 out:
 	dinitprintk(ioc, pr_err(
 	    "MaxWidePortQD: 0x%x MaxNarrowPortQD: 0x%x MaxSataQD: 0x%x MaxNvmeQD: 0x%x\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 419fdf164fc6..e932d1d05ef1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -469,6 +469,8 @@ struct MPT3SAS_TARGET {
  * @flags: MPT_DEVICE_XXX flags
  * @configured_lun: lun is configured
  * @block: device is in SDEV_BLOCK state
+ * @block_deadline: jiffies after which a delayed not-responding block is
+ *	released without waiting for the firmware event worker, 0 if none
  * @tlr_snoop_check: flag used in determining whether to disable TLR
  * @eedp_enable: eedp support enable bit
  * @eedp_type: 0(type_1), 1(type_2), 2(type_3)
@@ -486,6 +488,7 @@ struct MPT3SAS_DEVICE {
 	u8	ignore_delay_remove;
 	/* Iopriority Command Handling */
 	u8	ncq_prio_enable;
+	unsigned long	block_deadline;
 	/*
 	 * Bug workaround for SATL handling: the mpt2/3sas firmware
 	 * doesn't return BUSY or TASK_SET_FULL for subsequent
@@ -1165,6 +1168,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  *			pci resource handling
  * @fault_reset_work_q: fw fault workqueue
  * @fault_reset_work: fw fault work
+ * @dnr_unblock_work: releases expired delayed not-responding blocks
  * @firmware_event_thread: fw event work queue
  * @fw_event_lock:
  * @fw_event_list: list of fw events
@@ -1249,9 +1253,11 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @pcie_device_list: pcie device object list
  * @pcie_device_init_list: pcie device object list (used only at init time)
  * @pcie_device_lock:
- * @block_lock: serializes sdev blocking against sdev hostdata teardown
+ * @block_lock: serializes sdev blocking against dnr_unblock_work and
+ *	sdev hostdata teardown
  * @io_missing_delay: time for IO completed by fw when PDR enabled
  * @device_missing_delay: time for device missing by fw when PDR enabled
+ * @pcie_device_missing_delay: time for PCIe device missing by fw
  * @sas_id : used for setting volume target IDs
  * @pcie_target_id: used for setting pcie target IDs
  * @blocking_handles: bitmask used to identify which devices need blocking
@@ -1351,6 +1357,7 @@ struct MPT3SAS_ADAPTER {
 	/* fw fault handler */
 	struct workqueue_struct *fault_reset_work_q;
 	struct delayed_work fault_reset_work;
+	struct delayed_work dnr_unblock_work;
 
 	/* fw event handler */
 	struct workqueue_struct	*firmware_event_thread;
@@ -1489,6 +1496,7 @@ struct MPT3SAS_ADAPTER {
 	spinlock_t	raid_device_lock;
 	u8		io_missing_delay;
 	u16		device_missing_delay;
+	u16		pcie_device_missing_delay;
 	int		sas_id;
 	int		pcie_target_id;
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c7886a12d308..af2666f9576e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3882,6 +3882,7 @@ _scsih_internal_device_block(struct scsi_device *sdev,
 	sdev_printk(KERN_INFO, sdev, "device_block, handle(0x%04x)\n",
 	    sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 1;
+	sas_device_priv_data->block_deadline = 0;
 
 	r = scsi_internal_device_block_nowait(sdev);
 	if (r == -EINVAL)
@@ -3907,6 +3908,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 	sdev_printk(KERN_WARNING, sdev, "device_unblock and setting to running, "
 	    "handle(0x%04x)\n", sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 0;
+	sas_device_priv_data->block_deadline = 0;
 	r = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
 	if (r == -EINVAL) {
 		/* The device has been set to SDEV_RUNNING by SD layer during
@@ -3934,6 +3936,26 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 	}
 }
 
+/**
+ * _scsih_clear_block_deadline - keep dnr_unblock_work off a blocked sdev
+ * @ioc: per adapter object
+ * @sas_device_priv_data: per device driver private data
+ *
+ * Called by the firmware event worker before it polls a blocked device
+ * with TURs.  The worker unblocks the device when polling ends, and
+ * must not have dnr_unblock_work send I/O to it in the meantime.
+ */
+static void
+_scsih_clear_block_deadline(struct MPT3SAS_ADAPTER *ioc,
+			    struct MPT3SAS_DEVICE *sas_device_priv_data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->block_lock, flags);
+	sas_device_priv_data->block_deadline = 0;
+	spin_unlock_irqrestore(&ioc->block_lock, flags);
+}
+
 /**
  * _scsih_ublock_io_all_device - unblock every device
  * @ioc: per adapter object
@@ -3974,6 +3996,7 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 			continue;
 		}
 
+		_scsih_clear_block_deadline(ioc, sas_device_priv_data);
 		do {
 			pcie_device = mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
 			if (pcie_device && (!ioc->tm_custom_handling) &&
@@ -4089,6 +4112,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		if (!sas_device_priv_data->block)
 			continue;
 
+		_scsih_clear_block_deadline(ioc, sas_device_priv_data);
 		do {
 			host_reset_completion_count = 0;
 			pcie_device = mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
@@ -4225,6 +4249,92 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 	}
 }
 
+/*
+ * Margin on top of the firmware's report device missing delay before
+ * _scsih_dnr_unblock_work() releases a delayed not-responding block.
+ */
+#define MPT3SAS_DNR_BLOCK_SLACK	30
+
+static unsigned long
+_scsih_dnr_block_timeout(struct MPT3SAS_ADAPTER *ioc)
+{
+	return (max(ioc->device_missing_delay, ioc->pcie_device_missing_delay) +
+	    MPT3SAS_DNR_BLOCK_SLACK) * HZ;
+}
+
+/**
+ * _scsih_dnr_unblock_sdev - release an expired delayed not-responding block
+ * @ioc: per adapter object
+ * @sdev: scsi device struct
+ *
+ * Return: the deadline of an unexpired block on @sdev, or 0 if none.
+ */
+static unsigned long
+_scsih_dnr_unblock_sdev(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	unsigned long flags, deadline = 0;
+
+	spin_lock_irqsave(&ioc->block_lock, flags);
+	sas_device_priv_data = sdev->hostdata;
+	if (!sas_device_priv_data || !sas_device_priv_data->block ||
+	    !sas_device_priv_data->block_deadline)
+		goto out;
+	if (time_before(jiffies, sas_device_priv_data->block_deadline)) {
+		deadline = sas_device_priv_data->block_deadline;
+		goto out;
+	}
+	sdev_printk(KERN_WARNING, sdev,
+	    "delayed not-responding block expired, handle(0x%04x)\n",
+	    sas_device_priv_data->sas_target->handle);
+	_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+out:
+	spin_unlock_irqrestore(&ioc->block_lock, flags);
+	return deadline;
+}
+
+/**
+ * _scsih_dnr_unblock_work - release expired delayed not-responding blocks
+ * @work: the dnr_unblock_work of the adapter
+ *
+ * Within the device missing delay, the firmware either reports the device
+ * as not responding, and the event callback unblocks it, or the device
+ * comes back, and only the firmware event worker unblocks it.  The worker
+ * may first need shost->scan_mutex or the SAS transport's host lock, and
+ * a scan holding those can have a command queued on the blocked sdev.
+ * Past the delay the block has no further use, so release it here.
+ */
+static void
+_scsih_dnr_unblock_work(struct work_struct *work)
+{
+	struct MPT3SAS_ADAPTER *ioc = container_of(to_delayed_work(work),
+	    struct MPT3SAS_ADAPTER, dnr_unblock_work);
+	struct scsi_device *sdev;
+	unsigned long deadline, next = 0;
+
+	if (ioc->remove_host)
+		return;
+	if (ioc->shost_recovery || ioc->pci_error_recovery) {
+		queue_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work, HZ);
+		return;
+	}
+
+	shost_for_each_device(sdev, ioc->shost) {
+		deadline = _scsih_dnr_unblock_sdev(ioc, sdev);
+		if (deadline && (!next || time_before(deadline, next)))
+			next = deadline;
+	}
+
+	/*
+	 * A block made while this ran may have queued the work already,
+	 * with its own later deadline.  Pull the timer in to the earliest
+	 * one seen here; the next run reschedules for the rest.
+	 */
+	if (next)
+		mod_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work,
+		    max_t(long, next - jiffies, 1));
+}
+
 /**
  * _scsih_block_io_device - set the device state to SDEV_BLOCK
  * @ioc: per adapter object
@@ -4238,7 +4348,9 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
 	struct _sas_device *sas_device;
+	unsigned long timeout = _scsih_dnr_block_timeout(ioc);
 	unsigned long flags;
+	bool blocked = false;
 
 	sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
 
@@ -4260,12 +4372,18 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			goto next;
 		}
 		_scsih_internal_device_block(sdev, sas_device_priv_data);
+		sas_device_priv_data->block_deadline = (jiffies + timeout) ?: 1;
+		blocked = true;
 next:
 		spin_unlock_irqrestore(&ioc->block_lock, flags);
 	}
 
 	if (sas_device)
 		sas_device_put(sas_device);
+
+	if (blocked)
+		queue_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work,
+		    timeout);
 }
 
 /**
@@ -12549,6 +12667,7 @@ static void scsih_remove(struct pci_dev *pdev)
 		return;
 
 	ioc->remove_host = 1;
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
@@ -12649,6 +12768,7 @@ scsih_shutdown(struct pci_dev *pdev)
 		return;
 
 	ioc->remove_host = 1;
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
@@ -13562,6 +13682,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
 	INIT_LIST_HEAD(&ioc->reply_queue_list);
 	INIT_LIST_HEAD(&ioc->port_table_list);
+	INIT_DELAYED_WORK(&ioc->dnr_unblock_work, _scsih_dnr_unblock_work);
 
 	sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
 

-- 
2.56.0

