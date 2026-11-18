Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043417;
	b=ifFnn5SzICh345wzNdV+lOlgW6Ely+Bc8IlyoEfWl9mdaHIWvvQ50h8PeB2428Fb7bJ3
	 I6KV06rQ3WXIRKmUcxZyVloqnC/h9SmtOvedL7qDgnilylCrWGL1PXal604g0BmAq5UWw
	 mfPvxbb9Jmi//df0Z5oWBE8LvKIGmtkXOI4pL1B/Zn/3vN8Q2tyPWEr7rA/2X5YcOIuki
	 VXM5Gy7P8z3Jdh81ZTpclxgembzP/SmDLZnHMhvWZCAra2Mro2WxpFMHrDgHBiKhUC9JF
	 jHoWBq2QkiKMtKQ3L03AFtiI9kCj7I7xXGR11Dw5FUI8WXtj5JwuojQlRnqOn52VFcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043417;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=EspZf2gqNK0/yMViAgwJMp2BAsoorW0htHEKOkzNOmU=;
	b=LIjljP2ZhVpZhHIbSyfpMT4P/Q4XHbfWFFlVI5s6+tWN516iqvmPk071x3MY4f9f0uHE
	 2gZ7QtBxgY/X2xdTC/KxeSwmaL5xuGpfVjqR1Z4Ch2ot1qLNDSO1grgFYVe8vtW+RSnKJ
	 qPTi/jepSGnzYKHuk8VzdInyZq1BpoRVAg8/BaEB0q0TxWMqCq63yh2YaHxolmMD4ZgbU
	 J5rgPDo+oiwl/jbwSOZorN2RgA5jey+HY3C1/dKcsHNOHnz244qX2XhPXhht7TFoV+tzl
	 AI+vGwsLxaszI7D59BFp7rgvGjLNyj4lVxpa47LTGU5+A93e2IFylKk7JqR8fSQk7yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTCBOiVf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490BB60A5BD4;
	Wed, 18 Nov 2026 23:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kTCBOiVf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E251F000D3;
	Wed, 18 Nov 2026 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795043417;
	bh=EspZf2gqNK0/yMViAgwJMp2BAsoorW0htHEKOkzNOmU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kTCBOiVf98o93U3yk7kIRFKfDiRUTXEMTs9ePYDAHH2fdGTJK83RchQ8OkZjqoPbA
	 GwNKPvFdpJSFGNkqu2yVlCWI3sBMqzntHa9IRlLSWVc8DHGLx/TPjiS0SAqrFnx+Ad
	 rXyLrxRgoBt/geAHU8LnuxjLx8Cll+TApANL1f/QmMzIxPc95ro3Q8Cnpo5Uwfgeh8
	 lmI4g1Se1wGeLSVARQJGxnvsv9/4O92mo9yVoaPe3gco+3eCzyR7zu2qGLvzdDNHlL
	 fOROzSyFCATbMsZc6WYVwmiHRTOdoV1xQYFCTU+nt2djeC4+Sd9ICuBtlOdWjBjUFx
	 muvCAS/nNBetQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 18 Nov 2026 15:10:08 -0800
Subject: [PATCH v3 11/11] scsi: mpt3sas: Time out delayed not-responding
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
Message-Id: <20261118-sas-abba-v3-11-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
In-Reply-To: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=32150; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Gmxq7DmHcsi46iYCDGm/OPO3gWYbZJl8Kg3PjeMQzIg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq/jBSDjLdZpM/P92rn4MB1iAyCg4iEUfde4UNv
 DpgjQvZNkGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCav4wUgAKCRAADmhBGVaC
 FVY9EACZJBQSAZ0aM0x1Tz2nGBCG5vIIv9uQgqcC7PArdmrnzP0sHZdM39xj/FdXwhQY3/ML1jR
 BLAqTj6u8DT42KcpVjDgn5tVthhBuwz8LUdCBTrd+iYMRt8A4BZbSWZP0HEeoMBUncFQdK5GDuO
 kwx7bcFpCSBo+TYKT5vadI1Cwl8KTWWny/LiG8Va877Z8g8h5b6t9Ma2zrRds07L2z7AImTqE8P
 i0g8OmPTwVh5RiB3W0AjY5FO/y2vb3Ie2oRbW1a/RIyHnRUjPhwdPModM9eYDj5zvQQ5gAbUEb1
 1QQOPrEoCk6N9jXLZpG84quhlUCSlLRuyGaEGgUrWgJ7yFO1zYgXeRQQB/gFMHw8v6VUud4i4f8
 B4zaG5JkmODHzn+XkQ/UNZhMZagezQfkaVi/j//73e/jfM1e/vDfb4bRsk4MOHFjrD98lZLcEMr
 GhaJ16x/reFPv4uYFTZQShcWalpmhuw3XNQXWt4BGxdL3naESv9kYJNFJMaT5bJSu3wxQldNheW
 wPDsnHFh8wNmKREtkR2aqIu1zllsvY0UFOZLmNj68Gql+BC1O7qxYH9hyVHp5r1gQFVvRxna+Uy
 bOeQJ8YT/Qf30lfVICzkbXN2+szg6o2s9HecfGMz5QD2t2SBsle4o8SAysa2o3sHXLkfjFJLd91
 gfo0ZKFmCJK7gMQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

We have an agent that writes "- - -" to the sysfs scan attribute at
regular intervals. Several of these scans deadlocked:

 1. A drive in reset failed its initial scan. Thus the worker started
    to remove the drive.
 2. A sysfs scan took sas_host->lock, allocated an sdev for the drive
    and sent an INQUIRY.
 3. A DELAY_NOT_RESPONDING event blocked the new sdev.
 4. The worker waited for sas_host->lock in sas_rphy_free():

      __mutex_lock
      sas_port_delete+0x75 [scsi_transport_sas]
      mpt3sas_transport_port_remove
      _scsih_add_device

After that, all later scan attempts hung while they waited for
sas_host->lock.

On DELAY_NOT_RESPONDING, the event callback blocks every sdev on the
handle. Only these two paths release the block:
 - the callback, if the firmware later reports TARG_NOT_RESPONDING
 - the firmware event worker, when it processes a later event

Commit e4bc7f5c21a1 ("mpt3sas: Don't block the drive when drive addition
under the control of SML") partially fixed a similar issue. That commit
stops the driver from blocking sdevs that a scan still probes. This is
not sufficient. When LUN 0 is visible, the scan also sends REPORT LUNS
to it. LUN 0 may be blocked before or during the scan.

Within the report device missing delay, one of two things occurs:
 - The firmware reports the device as not responding, and the callback
   unblocks it.
 - The device returns.

After that delay, the block has no further use.

Schedule delayed_work on system_dfl_wq for the missing delay plus 30s.
When the work runs, unblock all expired sdevs, except during a host
reset. Do not wait for SCSI EH to end. scsi_send_eh_cmnd() waits for
SDEV_BLOCK to end only up to the EH command timeout. Thus EH would
fail its TURs to a device that is back, and set it offline.
Meanwhile, the unblock by the event worker waits for EH to end.

The driver tracked only the SAS missing delay. Also read the PCIe
missing delay from PCIe IO Unit Page 1. The driver already reads this
page for the NVMe queue depth. Use the delay that applies to the device
type. Until the first read of the page, assume the longest PCIe delay
that the firmware supports. Because the timeouts differ, always queue
the work for the earliest deadline.

Before the worker polls a blocked sdev, clear the deadline of the sdev
under ioc->block_lock. Then dnr_unblock_work leaves the sdev to the
worker. Do not put a timed block on offline sdevs. Expiry would set
them running again with no TUR check. This includes sdevs that failed
the TUR check of the worker. They are marked deleted under block_lock,
but set offline only after the lock is released.

If a hard reset cancels the polling, give new deadlines to the sdevs
that are still blocked. A failed reset queues no new scan. Also, the
next scan removes missing devices before it polls the others. That
removal can deadlock again.

If a host reset starts during a broadcast primitive pass, the pass
skips its unblock. For the same reason as above, give deadlines to the
sdevs that the pass blocks. Let sdevs that are already blocked keep
their deadlines. While the pass queries and aborts the commands of
these sdevs, prevent dnr_unblock_work from unblocking them.

Exclude offline sdevs from the pass. They take no I/O. The unblock by
the pass, or an expiry, would set them running again without a TUR
check.

A repeat DNR on a blocked sdev restarts its deadline, but at most
MPT3SAS_DNR_BLOCK_MAX_EXTENDS times. Thus a drive that continues to
flap cannot make a scan wait on it for as long as the flapping lasts.

An expired block may end before the device returns. Thus, at its next
unblock, the worker still sends TURs to those sdevs. It sets them
offline if they are not ready. If the driver makes a new delayed
not-responding block during polling, keep that block until its own
expiry or the next event.

Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  16 ++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  26 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 339 +++++++++++++++++++++++++++++++++--
 3 files changed, 369 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 07e16acc8abc..b7169253ca6e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5421,6 +5421,7 @@ _base_update_diag_trigger_pages(struct MPT3SAS_ADAPTER *ioc)
 /**
  * _base_assign_fw_reported_qd	- Get FW reported QD for SAS/SATA devices.
  *				- On failure set default QD values.
+ *				- Also get the PCIe device missing delay.
  * @ioc : per adapter object
  *
  * Returns 0 for success, non-zero for failure.
@@ -5432,6 +5433,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2SasIOUnitPage1_t sas_iounit_pg1;
 	Mpi26PCIeIOUnitPage1_t pcie_iounit_pg1;
 	u16 depth;
+	u8 dmd;
 	int rc = 0;
 
 	ioc->max_wideport_qd = MPT3SAS_SAS_QUEUE_DEPTH;
@@ -5469,6 +5471,20 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	ioc->max_nvme_qd = (le16_to_cpu(pcie_iounit_pg1.NVMeMaxQueueDepth)) ?
 	    (le16_to_cpu(pcie_iounit_pg1.NVMeMaxQueueDepth)) :
 	    MPT3SAS_NVME_QUEUE_DEPTH;
+
+	if ((le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK) !=
+	    MPI2_IOCSTATUS_SUCCESS) {
+		ioc_warn(ioc, "PCIe device missing delay unknown, using %us\n",
+		    ioc->pcie_device_missing_delay);
+		goto out;
+	}
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
index f5e1edf1a280..6d3ded18c3a2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -469,6 +469,14 @@ struct MPT3SAS_TARGET {
  * @flags: MPT_DEVICE_XXX flags
  * @configured_lun: lun is configured
  * @block: device is in SDEV_BLOCK state
+ * @block_deadline: jiffies after which a delayed not-responding block is
+ *	released without waiting for the firmware event worker, 0 if none
+ * @dnr_expired: a delayed not-responding block expired before the firmware
+ *	event worker checked the device; it still needs a readiness check
+ * @block_extends: times a repeat delayed not-responding event has pushed
+ *	out @block_deadline
+ * @block_seq: incremented on each new block, so the firmware event worker
+ *	can tell whether the device was blocked again while it polled it
  * @tlr_snoop_check: flag used in determining whether to disable TLR
  * @eedp_enable: eedp support enable bit
  * @eedp_type: 0(type_1), 1(type_2), 2(type_3)
@@ -486,6 +494,10 @@ struct MPT3SAS_DEVICE {
 	u8	ignore_delay_remove;
 	/* Iopriority Command Handling */
 	u8	ncq_prio_enable;
+	u8	dnr_expired;
+	u8	block_extends;
+	unsigned int	block_seq;
+	unsigned long	block_deadline;
 	/*
 	 * Bug workaround for SATL handling: the mpt2/3sas firmware
 	 * doesn't return BUSY or TASK_SET_FULL for subsequent
@@ -1165,6 +1177,9 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  *			pci resource handling
  * @fault_reset_work_q: fw fault workqueue
  * @fault_reset_work: fw fault work
+ * @dnr_unblock_work: releases expired delayed not-responding blocks
+ * @dnr_unblock_deadline: jiffies dnr_unblock_work is set to run at, 0 if
+ *	it isn't pending.  Protected by block_lock.
  * @firmware_event_thread: fw event work queue
  * @fw_event_lock:
  * @fw_event_list: list of fw events
@@ -1172,6 +1187,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @fw_event_cleanup: set to one while cleaning up the fw events
  * @aen_event_read_flag: event log was read
  * @broadcast_aen_busy: broadcast aen waiting to be serviced
+ * @broadcast_tm_active: broadcast primitive pass running, with every device
+ *	blocked; dnr_unblock_work waits for it
  * @shost_recovery: host reset in progress
  * @ioc_reset_in_progress_lock:
  * @ioc_link_reset_in_progress: phy/hard reset in progress
@@ -1249,10 +1266,11 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  * @pcie_device_list: pcie device object list
  * @pcie_device_init_list: pcie device object list (used only at init time)
  * @pcie_device_lock:
- * @block_lock: serializes sdev blocking and unblocking against sdev
- *	hostdata teardown
+ * @block_lock: serializes sdev blocking and unblocking against
+ *	dnr_unblock_work and sdev hostdata teardown
  * @io_missing_delay: time for IO completed by fw when PDR enabled
  * @device_missing_delay: time for device missing by fw when PDR enabled
+ * @pcie_device_missing_delay: time for PCIe device missing by fw
  * @sas_id : used for setting volume target IDs
  * @pcie_target_id: used for setting pcie target IDs
  * @blocking_handles: bitmask used to identify which devices need blocking
@@ -1352,6 +1370,8 @@ struct MPT3SAS_ADAPTER {
 	/* fw fault handler */
 	struct workqueue_struct *fault_reset_work_q;
 	struct delayed_work fault_reset_work;
+	struct delayed_work dnr_unblock_work;
+	unsigned long dnr_unblock_deadline;
 
 	/* fw event handler */
 	struct workqueue_struct	*firmware_event_thread;
@@ -1363,6 +1383,7 @@ struct MPT3SAS_ADAPTER {
 	 /* misc flags */
 	int		aen_event_read_flag;
 	u8		broadcast_aen_busy;
+	u8		broadcast_tm_active;
 	u16		broadcast_aen_pending;
 	u8		shost_recovery;
 	u8		got_task_abort_from_ioctl;
@@ -1490,6 +1511,7 @@ struct MPT3SAS_ADAPTER {
 	spinlock_t	raid_device_lock;
 	u8		io_missing_delay;
 	u16		device_missing_delay;
+	u16		pcie_device_missing_delay;
 	int		sas_id;
 	int		pcie_target_id;
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 814c18289cf1..6eb92bd4f122 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4014,6 +4014,8 @@ _scsih_internal_device_block(struct scsi_device *sdev,
 	sdev_printk(KERN_INFO, sdev, "device_block, handle(0x%04x)\n",
 	    sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 1;
+	sas_device_priv_data->block_deadline = 0;
+	sas_device_priv_data->block_seq++;
 
 	r = scsi_internal_device_block_nowait(sdev);
 	if (r == -EINVAL)
@@ -4039,6 +4041,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 	sdev_printk(KERN_WARNING, sdev, "device_unblock and setting to running, "
 	    "handle(0x%04x)\n", sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 0;
+	sas_device_priv_data->block_deadline = 0;
 	r = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
 	if (r == -EINVAL) {
 		/* The device has been set to SDEV_RUNNING by SD layer during
@@ -4125,23 +4128,106 @@ _scsih_get_target_ids(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev,
 	return live;
 }
 
+/*
+ * Margin on top of the firmware's report device missing delay before
+ * _scsih_dnr_unblock_work() releases a delayed not-responding block.
+ */
+#define MPT3SAS_DNR_BLOCK_SLACK	30
+
+/*
+ * A repeat DNR on a blocked device extends its block, at most this many
+ * times, so a drive that keeps flapping can't hold it forever.
+ */
+#define MPT3SAS_DNR_BLOCK_MAX_EXTENDS	3
+
+static unsigned long
+_scsih_dnr_block_timeout(struct MPT3SAS_ADAPTER *ioc,
+			 struct MPT3SAS_TARGET *sas_target)
+{
+	u16 delay = (sas_target->flags & MPT_TARGET_FLAGS_PCIE_DEVICE) ?
+	    ioc->pcie_device_missing_delay : ioc->device_missing_delay;
+
+	return (delay + MPT3SAS_DNR_BLOCK_SLACK) * HZ;
+}
+
+/*
+ * Make dnr_unblock_work run no later than @deadline.  The caller holds
+ * block_lock.  Timeouts differ between SAS and PCIe devices, so a new
+ * block can expire before the one the work is pending for.
+ */
+static void
+__scsih_dnr_unblock_work_by(struct MPT3SAS_ADAPTER *ioc,
+			    unsigned long deadline)
+{
+	if (ioc->dnr_unblock_deadline &&
+	    !time_before(deadline, ioc->dnr_unblock_deadline))
+		return;
+	ioc->dnr_unblock_deadline = deadline;
+	mod_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work,
+	    max_t(long, deadline - jiffies, 1));
+}
+
+/**
+ * _scsih_claim_block - keep dnr_unblock_work off a blocked sdev
+ * @ioc: per adapter object
+ * @sdev: scsi device struct
+ * @sas_device_priv_data: hostdata of @sdev, as read by the caller
+ * @block_seq: set to the block_seq of @sdev, for _scsih_end_poll()
+ *
+ * Called by the firmware event worker before it polls a device with TURs.
+ * The worker unblocks the device when polling ends, and must not have
+ * dnr_unblock_work send I/O to it in the meantime.
+ *
+ * A device whose block expired is already running, but still gets polled,
+ * and offlined if it is not ready.
+ *
+ * Return: true if @sdev needs polling: it is blocked, or its block expired
+ * since the last poll.  False otherwise.
+ */
+static bool
+_scsih_claim_block(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev,
+		   struct MPT3SAS_DEVICE *sas_device_priv_data,
+		   unsigned int *block_seq)
+{
+	unsigned long flags;
+	bool claimed = false;
+
+	spin_lock_irqsave(&ioc->block_lock, flags);
+	if (sdev->hostdata == sas_device_priv_data &&
+	    (sas_device_priv_data->block || sas_device_priv_data->dnr_expired)) {
+		sas_device_priv_data->block_deadline = 0;
+		sas_device_priv_data->dnr_expired = 0;
+		*block_seq = sas_device_priv_data->block_seq;
+		claimed = true;
+	}
+	spin_unlock_irqrestore(&ioc->block_lock, flags);
+	return claimed;
+}
+
 /**
  * _scsih_end_poll - unblock a device after polling it
  * @ioc: per adapter object
  * @sdev: scsi device struct
  * @sas_device_priv_data: hostdata of @sdev when polling began
+ * @block_seq: block_seq of @sdev when _scsih_claim_block() claimed it
  * @ready: the device passed the readiness check
  * @ids: filled in with the target fields, if true is returned
  *
  * Unblock @sdev, and mark it deleted if it is not @ready.  Nothing is
  * done if @sdev lost its hostdata while it was polled.
  *
+ * Nothing is done either if a new delayed not-responding block was made
+ * on @sdev.  Polling then began before the firmware last reported the
+ * device missing, and the expiry of that block or the firmware's next
+ * event decides instead.
+ *
  * Return: true if the caller should act on @ready, false otherwise.
  */
 static bool
 _scsih_end_poll(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev,
 		struct MPT3SAS_DEVICE *sas_device_priv_data,
-		bool ready, struct _scsih_target_ids *ids)
+		unsigned int block_seq, bool ready,
+		struct _scsih_target_ids *ids)
 {
 	unsigned long flags;
 	bool ret = false;
@@ -4149,8 +4235,15 @@ _scsih_end_poll(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev,
 	spin_lock_irqsave(&ioc->block_lock, flags);
 	if (!__scsih_get_target_ids(sdev, sas_device_priv_data, ids))
 		goto out;
+	if (sas_device_priv_data->block_seq != block_seq) {
+		sdev_printk(KERN_INFO, sdev,
+		    "blocked again while polled, handle(0x%04x)\n",
+		    ids->handle);
+		goto out;
+	}
 	if (!ready)
 		sas_device_priv_data->deleted = 1;
+	/* not blocked if dnr_unblock_work released it before polling */
 	if (sas_device_priv_data->block)
 		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
 	ret = true;
@@ -4175,6 +4268,50 @@ _scsih_unresponding_scan_cancelled(struct MPT3SAS_ADAPTER *ioc)
 	return READ_ONCE(ioc->remove_host) || READ_ONCE(ioc->fw_events_cleanup);
 }
 
+/**
+ * _scsih_cancel_poll - hand devices back to dnr_unblock_work
+ * @ioc: per adapter object
+ * @sdev: device being polled when the scan was cancelled
+ * @sas_device_priv_data: hostdata of @sdev when it was claimed
+ * @block_seq: block_seq of @sdev when it was claimed
+ *
+ * _scsih_ublock_io_all_device() cleared the deadlines of the devices it
+ * was going to poll.  Give those still blocked a new one: a failed reset
+ * queues no new scan, and the scan removes missing devices before it
+ * polls the others.  If @sdev's block expired, it still needs a TUR check.
+ */
+static void
+_scsih_cancel_poll(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev,
+		   struct MPT3SAS_DEVICE *sas_device_priv_data,
+		   unsigned int block_seq)
+{
+	struct MPT3SAS_DEVICE *priv;
+	struct scsi_device *iter;
+	unsigned long flags, deadline;
+
+	/* dnr_unblock_work is disabled, and the devices are going away */
+	if (READ_ONCE(ioc->remove_host))
+		return;
+
+	shost_for_each_device(iter, ioc->shost) {
+		spin_lock_irqsave(&ioc->block_lock, flags);
+		priv = iter->hostdata;
+		if (!priv || !priv->sas_target || priv->sas_target->deleted)
+			goto next;
+		if (priv->block && !priv->block_deadline) {
+			deadline = (jiffies +
+			    _scsih_dnr_block_timeout(ioc, priv->sas_target)) ?: 1;
+			priv->block_deadline = deadline;
+			__scsih_dnr_unblock_work_by(ioc, deadline);
+		} else if (iter == sdev && priv == sas_device_priv_data &&
+			   priv->block_seq == block_seq && !priv->block) {
+			priv->dnr_expired = 1;
+		}
+next:
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
+	}
+}
+
 /**
  * _scsih_ublock_io_all_device - unblock every device
  * @ioc: per adapter object
@@ -4195,8 +4332,22 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 	int count;
 	u8 tr_method = 0;
 	u8 tr_timeout = 30;
+	unsigned int block_seq;
 	unsigned long flags;
 
+	/* polling one device can outlast another's deadline */
+	if (!no_turs && issue_scsi_cmd_to_bringup_drive) {
+		shost_for_each_device(sdev, ioc->shost) {
+			spin_lock_irqsave(&ioc->block_lock, flags);
+			sas_device_priv_data = sdev->hostdata;
+			if (sas_device_priv_data &&
+			    sas_device_priv_data->sas_target &&
+			    !sas_device_priv_data->sas_target->deleted)
+				sas_device_priv_data->block_deadline = 0;
+			spin_unlock_irqrestore(&ioc->block_lock, flags);
+		}
+	}
+
 	shost_for_each_device(sdev, ioc->shost) {
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data)
@@ -4206,13 +4357,14 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 		if (!sas_target || sas_target->deleted)
 			continue;
 
-		if (!sas_device_priv_data->block)
-			continue;
-
 		if ((no_turs) || (!issue_scsi_cmd_to_bringup_drive)) {
 			spin_lock_irqsave(&ioc->block_lock, flags);
 			if (sdev->hostdata != sas_device_priv_data)
 				goto next;
+			/*
+			 * dnr_unblock_work may have released it.  Leave
+			 * dnr_expired for the next scan that sends TURs.
+			 */
 			if (sas_device_priv_data->block) {
 				sdev_printk(KERN_WARNING, sdev,
 				    "device_unblocked handle(0x%04x)\n",
@@ -4225,6 +4377,9 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 			continue;
 		}
 
+		if (!_scsih_claim_block(ioc, sdev, sas_device_priv_data,
+		    &block_seq))
+			continue;
 		/*
 		 * Polling can take minutes, and sdev_destroy() and
 		 * scsi_target_reap() can free the hostdata meanwhile.
@@ -4255,11 +4410,13 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 			!_scsih_unresponding_scan_cancelled(ioc));
 		if (_scsih_unresponding_scan_cancelled(ioc)) {
 			/* a reset queues a new scan, which polls the rest */
+			_scsih_cancel_poll(ioc, sdev, sas_device_priv_data,
+			    block_seq);
 			scsi_device_put(sdev);
 			return;
 		}
 		if (!_scsih_end_poll(ioc, sdev, sas_device_priv_data,
-		    rc == DEVICE_READY, &ids))
+		    block_seq, rc == DEVICE_READY, &ids))
 			continue;
 
 		if (rc != DEVICE_READY) {
@@ -4318,6 +4475,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	struct _scsih_target_ids ids;
 	u8 tr_timeout = 30;
 	u8 tr_method = 0;
+	unsigned int block_seq;
 	int count;
 	unsigned long flags;
 
@@ -4333,6 +4491,8 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		if (sas_target->sas_address != sas_address ||
 		    sas_target->port != port)
 			goto next;
+		/* polling one device can outlast another's deadline */
+		sas_device_priv_data->block_deadline = 0;
 		if (sdev->sdev_state == SDEV_OFFLINE) {
 			sas_device_priv_data->block = 1;
 			sas_device_priv_data->deleted = 0;
@@ -4354,7 +4514,8 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		if (sas_target->sas_address != sas_address ||
 		    sas_target->port != port)
 			continue;
-		if (!sas_device_priv_data->block)
+		if (!_scsih_claim_block(ioc, sdev, sas_device_priv_data,
+		    &block_seq))
 			continue;
 
 		/*
@@ -4405,7 +4566,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 			&& count++ <= command_retry_count);
 
 		if (!_scsih_end_poll(ioc, sdev, sas_device_priv_data,
-		    rc == DEVICE_READY, &ids))
+		    block_seq, rc == DEVICE_READY, &ids))
 			continue;
 
 		if (rc != DEVICE_READY) {
@@ -4472,6 +4633,8 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc,
 			goto next;
 		if (sas_device_priv_data->sas_target->port != port)
 			goto next;
+		/* the caller has decided this device won't be polled */
+		sas_device_priv_data->dnr_expired = 0;
 		if (sas_device_priv_data->block)
 			_scsih_internal_device_unblock(sdev,
 				sas_device_priv_data);
@@ -4485,19 +4648,26 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc,
  * @ioc: per adapter object
  *
  * During device pull we need to appropriately set the sdev state.
+ *
+ * The caller unblocks the devices when its broadcast primitive pass ends,
+ * and dnr_unblock_work leaves them alone until then.  The blocks still
+ * get a deadline: if a host reset skips that unblock, the next unblock is
+ * after the firmware event worker removes unresponding devices, which
+ * needs the locks a scan waiting on one of these devices holds.
  */
 static void
 _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
-	unsigned long flags;
+	unsigned long flags, deadline;
 
 	shost_for_each_device(sdev, ioc->shost) {
 		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data)
 			goto next;
+		/* it keeps its deadline, if it has one */
 		if (sas_device_priv_data->block)
 			goto next;
 		if (sas_device_priv_data->ignore_delay_remove) {
@@ -4506,12 +4676,124 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 			__func__, sas_device_priv_data->sas_target->handle);
 			goto next;
 		}
+		/*
+		 * Leave offline devices alone: they take no I/O, and the
+		 * caller's unblock, or an expiry, would bring them back
+		 * running without a TUR check.  That includes devices that
+		 * failed their TUR check, which are marked deleted under
+		 * block_lock before they are set offline.
+		 */
+		if (sdev->sdev_state == SDEV_OFFLINE ||
+		    sas_device_priv_data->deleted)
+			goto next;
 		_scsih_internal_device_block(sdev, sas_device_priv_data);
+		deadline = (jiffies + _scsih_dnr_block_timeout(ioc,
+		    sas_device_priv_data->sas_target)) ?: 1;
+		sas_device_priv_data->block_deadline = deadline;
+		sas_device_priv_data->block_extends = 0;
+		__scsih_dnr_unblock_work_by(ioc, deadline);
 next:
 		spin_unlock_irqrestore(&ioc->block_lock, flags);
 	}
 }
 
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
+	/*
+	 * Wait out a host reset, which can begin while
+	 * _scsih_dnr_unblock_work() walks the devices.  Don't wait for SCSI
+	 * EH, though: scsi_send_eh_cmnd() waits out SDEV_BLOCK only up to
+	 * the EH command timeout, so EH would fail its TURs to a device
+	 * that has come back and offline it, while the event worker's
+	 * unblock waits for EH to end.  Past the deadline, the device is
+	 * back, or the firmware has reported it missing and its handle is
+	 * no longer valid.
+	 *
+	 * A broadcast primitive pass keeps every device blocked while it
+	 * queries and aborts their commands, and unblocks them when it ends.
+	 */
+	if (ioc->shost_recovery || ioc->pci_error_recovery ||
+	    READ_ONCE(ioc->broadcast_tm_active)) {
+		deadline = (jiffies + HZ) ?: 1;
+		goto out;
+	}
+	sdev_printk(KERN_WARNING, sdev,
+	    "delayed not-responding block expired, handle(0x%04x)\n",
+	    sas_device_priv_data->sas_target->handle);
+	_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+	/* if the device came back, the firmware event worker still polls it */
+	if (issue_scsi_cmd_to_bringup_drive)
+		sas_device_priv_data->dnr_expired = 1;
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
+	unsigned long flags, deadline, next = 0;
+
+	/* from here on, a new block requeues the work */
+	spin_lock_irqsave(&ioc->block_lock, flags);
+	ioc->dnr_unblock_deadline = 0;
+	spin_unlock_irqrestore(&ioc->block_lock, flags);
+
+	if (ioc->remove_host)
+		return;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		deadline = _scsih_dnr_unblock_sdev(ioc, sdev);
+		if (deadline && (!next || time_before(deadline, next)))
+			next = deadline;
+	}
+
+	/*
+	 * Requeue for the earliest deadline seen here; the next run
+	 * requeues for the rest.  A block made meanwhile may already
+	 * have requeued the work for an earlier deadline; keep that.
+	 */
+	if (next) {
+		spin_lock_irqsave(&ioc->block_lock, flags);
+		__scsih_dnr_unblock_work_by(ioc, next);
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
+	}
+}
+
 /**
  * _scsih_block_io_device - set the device state to SDEV_BLOCK
  * @ioc: per adapter object
@@ -4525,7 +4807,7 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
 	struct _sas_device *sas_device;
-	unsigned long flags;
+	unsigned long flags, deadline;
 
 	sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
 
@@ -4536,10 +4818,30 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			goto next;
 		if (sas_device_priv_data->sas_target->handle != handle)
 			goto next;
-		if (sas_device_priv_data->block)
+		deadline = (jiffies + _scsih_dnr_block_timeout(ioc,
+		    sas_device_priv_data->sas_target)) ?: 1;
+		if (sas_device_priv_data->block) {
+			/* a repeat DNR restarts the firmware's missing delay */
+			if (sas_device_priv_data->block_deadline &&
+			    sas_device_priv_data->block_extends <
+			    MPT3SAS_DNR_BLOCK_MAX_EXTENDS) {
+				sas_device_priv_data->block_extends++;
+				sas_device_priv_data->block_deadline = deadline;
+				__scsih_dnr_unblock_work_by(ioc, deadline);
+			}
 			goto next;
+		}
 		if (sas_device && sas_device->pend_sas_rphy_add)
 			goto next;
+		/*
+		 * Expiry would bring it back running without a TUR check.
+		 * _scsih_ublock_io_device_wait() polls offline devices anyway.
+		 * A device that failed its TUR check is marked deleted under
+		 * block_lock, before it is set offline.
+		 */
+		if (sdev->sdev_state == SDEV_OFFLINE ||
+		    sas_device_priv_data->deleted)
+			goto next;
 		if (sas_device_priv_data->ignore_delay_remove) {
 			sdev_printk(KERN_INFO, sdev,
 			"%s skip device_block for SES handle(0x%04x)\n",
@@ -4547,6 +4849,9 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			goto next;
 		}
 		_scsih_internal_device_block(sdev, sas_device_priv_data);
+		sas_device_priv_data->block_deadline = deadline;
+		sas_device_priv_data->block_extends = 0;
+		__scsih_dnr_unblock_work_by(ioc, deadline);
 next:
 		spin_unlock_irqrestore(&ioc->block_lock, flags);
 	}
@@ -10215,6 +10520,7 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	ioc_info(ioc, "%s: enter: phy number(%d), width(%d)\n",
 		 __func__, event_data->PhyNum, event_data->PortWidth);
 
+	WRITE_ONCE(ioc->broadcast_tm_active, 1);
 	_scsih_block_io_all_device(ioc);
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
@@ -10345,6 +10651,7 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 	ioc->broadcast_aen_busy = 0;
 	if (!ioc->shost_recovery)
 		_scsih_ublock_io_all_device(ioc, 1);
+	WRITE_ONCE(ioc->broadcast_tm_active, 0);
 	mutex_unlock(&ioc->tm_cmds.mutex);
 }
 
@@ -12846,6 +13153,7 @@ static void scsih_remove(struct pci_dev *pdev)
 		return;
 
 	ioc->remove_host = 1;
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
@@ -12946,6 +13254,7 @@ scsih_shutdown(struct pci_dev *pdev)
 		return;
 
 	ioc->remove_host = 1;
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
@@ -13843,6 +14152,14 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ioc->pcie_device_lock);
 	spin_lock_init(&ioc->diag_trigger_lock);
 	spin_lock_init(&ioc->block_lock);
+	/*
+	 * Until PCIe IO Unit Page 1 is read, assume the longest delay the
+	 * firmware can be set to, so blocked PCIe devices aren't released
+	 * before the firmware has reported them missing.  A reset keeps
+	 * the delay read before if it can't read the page.
+	 */
+	ioc->pcie_device_missing_delay =
+	    MPI26_PCIEIOUNIT1_DMDRPT_DELAY_TIME_MASK * 16;
 
 	INIT_LIST_HEAD(&ioc->sas_device_list);
 	INIT_LIST_HEAD(&ioc->sas_device_init_list);
@@ -13859,6 +14176,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
 	INIT_LIST_HEAD(&ioc->reply_queue_list);
 	INIT_LIST_HEAD(&ioc->port_table_list);
+	INIT_DELAYED_WORK(&ioc->dnr_unblock_work, _scsih_dnr_unblock_work);
 
 	sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
 
@@ -13969,6 +14287,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mpt3sas_setup_debugfs(ioc);
 	return 0;
 out_add_shost_fail:
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 	mpt3sas_base_detach(ioc);
  out_attach_fail:
 	destroy_workqueue(ioc->firmware_event_thread);

-- 
2.56.1

