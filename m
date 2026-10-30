Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793371808;
	b=fEA6vIA9bHB7IPSn3NteFAXEvwVkUdjGjipjCcvA9nQGFTmABeNPs2ueHabnQBXE+TgF
	 7zcPvvGyTGLntsMxI9LqNWxyHk7rq2QTM0eEhAMcwFTb70qDmnMOtfCcJoAd98xJ9DyDc
	 b667AsgT15lveLOzp05BXdq+2uabw5c1ZVtfjoGkF3fkK2F0GvkOpHtm/sHOPhwE/W29d
	 7SA9fD6NJENkPw16qYtgW/8X4iqyCLKMPm8hUjo0ms+vmrDkoQFI2Q3TTk68GpbVxoTUA
	 N8h90jZBlOYloI3OkM0FK6eWgt/b7W9m5yzhySSAUx/MIahITdrEY9OQt8mypQsj7tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793371808;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=FvakPVYddoS6NiMfxwZ1O3BH1zokpKzHwnt9Wog63Fg=;
	b=yPKuOasdAXXYjAvVc9Ov2iRUNwGKBrb8Ep+8ShGGqcvYB3MFn/jAssunDNv6EBRCILNn
	 0540JKIGA/d2IdlNTM33nCE7SOFzWCWyEqSPRXGBt8j/v+RQLQq4Y55hO4f+8V7jTH6M7
	 9qRqtOxt/+yWS/QgawRHFf6myiaU4bZ2L3S3sfgMocK3ONJ8eycZIOnErG8D/PyBjn5Dz
	 Tu2DTpnt7p7E+nPZz12uIwFQSuVFrVe6SSa7B2tnVkCR/MdTxOiVkDQCxwBWHJHQL7/76
	 mfilwl2vW2mqkt37I7Mlf3Vh9+6sVwdLnxu/utqhLgxjFuhDQzEpIrtkQ/8w9y6ej3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GyMooQU4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5588F606A31A;
	Fri, 30 Oct 2026 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GyMooQU4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E181F0093A;
	Fri, 30 Oct 2026 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793371807;
	bh=FvakPVYddoS6NiMfxwZ1O3BH1zokpKzHwnt9Wog63Fg=;
	h=From:Date:Subject:To:Cc;
	b=GyMooQU4YJ1rwUHOf87xNcBREsb+afyHifpHZjznnS3pLcBUkbWZ9ZTlWQuLBK43a
	 VfDR0yVuvAtkqWFIq0xuFJqY0t6xeT9fQoeXVbTw7hjXutaU8AsX96xebcOywH6t+4
	 YRRys3MiA/IWChX03/BKML/j/Qrg6IE1i5oQ99vjN5B0o5iLqmt15dMvLQbZly4R/l
	 q06AvmS+wEE2Uob3m0xulQY6YByMHSvNqmgdtFHWf2M7cEklGRfH+EenLALXJXE7PG
	 /akTwmkRa5bq7xUFznmop5rHydRdW8Lw0k7hRDmWQ3feOmQBqb3ecp4ecr3vZYidHX
	 xuWQj+xJwOYeA==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 30 Oct 2026 10:49:51 -0400
Subject: [PATCH] scsi: mpt3sas: Time out delayed not-responding device
 blocks
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
Message-Id: <20261030-sas-abba-v1-1-b8cdd714a37c@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDA2MD3eLEYt3EpKRE3dTE5LTkZBPTtFRjMyWg8oKi1LTMCrBR0bG1tQA
 Eb7leWgAAAA==
X-Change-ID: 20261030-sas-abba-eacfcc45fe36
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, 
 James Bottomley <JBottomley@Parallels.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, 
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Keith Busch <kbusch@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=11602; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=N5NAT1rqT41gS3vgYe0Dkstejbnubg2rN9jYWW/JKdc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq5K6aeURdP7oH97Wd8HUCab1ksgse+v8VRcrKr
 Q0AtKAkOJSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCauSumgAKCRAADmhBGVaC
 FYwRD/oDl+7GFwx022gswu1nmoT0vdEKs5yL3jbF2oo83uVeTrzOF4Jcyd+ROpNUC/KOEpp7gfb
 HM18ZbUJwW72/7oyq3LeRUau0jq1sE3pvyGVQ8bjy/EqilR0bTPv/q+clAligw6V5jVnSlSr+ac
 SdkxBI3IL+ZhyLVpyJofBeWFu5hrwkwoediyecaNFDuQxnNZ6KmeIN7PeY2y7nRImoWq/QUJInN
 5m+KG9VopEqXt2xBCXhEBcD27Jd/NzW8EO5PQynE76nEDQqCJsJ91SrcHAO4Fmfr1fH4lCVo4gl
 SIZxyUArJ9QU/2VQvpSp6YvqB/zt73TBSuynx89HZdy5ZqGZUKVxCE1qlm8m7ak7zD6IhzQUgvN
 twpX+0hEMSJVADqjmuk24Z/FDPd/++haFASsfsQhkEa8qXXA1drlC6eRLHms4YK43LNBgxbqwj1
 VNTBghbwcux7O1fBAjMtMRYK9DeNx0oj1t86jET5sHT2l+Ia1515F77OVpfmdWm/19ymhvcU9UU
 Y3ApBGtSeS73djL7oSOaZhDBazrzmbxdnCwGeup3NhnjED8AVn6PzUcxdSG7b5ABUssc4nZlYrX
 Wfv/2AMnVfevxk+QtAWDzIk64LLJTxKNGCgZEmrgNPrV0n/YP0p8UO3e9Ey0PDB1wX6hf8wF271
 AEluJRYDbguI91A==
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
has come back. Past that delay the block has no further use. So:

Schedule delayed_work to the system_wq for the missing delay plus 30s.
When it runs, unblock any expired sdevs.

Cc: Keith Busch <kbusch@kernel.org>
Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 10 +++++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  7 +++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 82 ++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+)

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
index 47255bf9cdda..4d12b1f6231c 100644
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
@@ -1251,6 +1255,7 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @pcie_device_lock:
  * @io_missing_delay: time for IO completed by fw when PDR enabled
  * @device_missing_delay: time for device missing by fw when PDR enabled
+ * @pcie_device_missing_delay: time for PCIe device missing by fw
  * @sas_id : used for setting volume target IDs
  * @pcie_target_id: used for setting pcie target IDs
  * @blocking_handles: bitmask used to identify which devices need blocking
@@ -1350,6 +1355,7 @@ struct MPT3SAS_ADAPTER {
 	/* fw fault handler */
 	struct workqueue_struct *fault_reset_work_q;
 	struct delayed_work fault_reset_work;
+	struct delayed_work dnr_unblock_work;
 
 	/* fw event handler */
 	struct workqueue_struct	*firmware_event_thread;
@@ -1487,6 +1493,7 @@ struct MPT3SAS_ADAPTER {
 	spinlock_t	raid_device_lock;
 	u8		io_missing_delay;
 	u16		device_missing_delay;
+	u16		pcie_device_missing_delay;
 	int		sas_id;
 	int		pcie_target_id;
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 085d4672db85..dda5a429a917 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3878,6 +3878,7 @@ _scsih_internal_device_block(struct scsi_device *sdev,
 	sdev_printk(KERN_INFO, sdev, "device_block, handle(0x%04x)\n",
 	    sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 1;
+	sas_device_priv_data->block_deadline = 0;
 
 	r = scsi_internal_device_block_nowait(sdev);
 	if (r == -EINVAL)
@@ -3903,6 +3904,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 	sdev_printk(KERN_WARNING, sdev, "device_unblock and setting to running, "
 	    "handle(0x%04x)\n", sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 0;
+	sas_device_priv_data->block_deadline = 0;
 	r = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
 	if (r == -EINVAL) {
 		/* The device has been set to SDEV_RUNNING by SD layer during
@@ -4121,6 +4123,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 			&& count++ <= command_retry_count);
 
 		sas_device_priv_data->block = 0;
+		sas_device_priv_data->block_deadline = 0;
 		if (rc != DEVICE_READY)
 			sas_device_priv_data->deleted = 1;
 		scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
@@ -4221,6 +4224,74 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
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
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
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
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data || !sas_device_priv_data->block)
+			continue;
+		deadline = sas_device_priv_data->block_deadline;
+		if (!deadline)
+			continue;
+		if (time_before(jiffies, deadline)) {
+			if (!next || time_before(deadline, next))
+				next = deadline;
+			continue;
+		}
+		sdev_printk(KERN_WARNING, sdev,
+		    "delayed not-responding block expired, handle(0x%04x)\n",
+		    sas_device_priv_data->sas_target->handle);
+		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
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
@@ -4234,6 +4305,8 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
 	struct _sas_device *sas_device;
+	unsigned long timeout = _scsih_dnr_block_timeout(ioc);
+	bool blocked = false;
 
 	sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
 
@@ -4254,10 +4327,16 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			continue;
 		}
 		_scsih_internal_device_block(sdev, sas_device_priv_data);
+		sas_device_priv_data->block_deadline = (jiffies + timeout) ?: 1;
+		blocked = true;
 	}
 
 	if (sas_device)
 		sas_device_put(sas_device);
+
+	if (blocked)
+		queue_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work,
+		    timeout);
 }
 
 /**
@@ -12541,6 +12620,7 @@ static void scsih_remove(struct pci_dev *pdev)
 		return;
 
 	ioc->remove_host = 1;
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
@@ -12641,6 +12721,7 @@ scsih_shutdown(struct pci_dev *pdev)
 		return;
 
 	ioc->remove_host = 1;
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
@@ -13553,6 +13634,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
 	INIT_LIST_HEAD(&ioc->reply_queue_list);
 	INIT_LIST_HEAD(&ioc->port_table_list);
+	INIT_DELAYED_WORK(&ioc->dnr_unblock_work, _scsih_dnr_unblock_work);
 
 	sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
 

---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261030-sas-abba-eacfcc45fe36

Best regards,
-- 
Jeff Layton <jlayton@kernel.org>

