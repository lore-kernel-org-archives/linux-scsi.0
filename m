Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793996991;
	b=vIpKoSPWmq/fqOkdWgzOdovVrbsGg3k/oE8Ec8Ek/9aRXMp4ZrSJESgtyAuHRuav6YYF
	 A4OkO4gTqWI5BBeFMJBt1J/SW7IoAOWnDGTbpfmzI7o38JpTDO5+csaMCHUP1P0F5VWB6
	 WS6R2tc3m8EDkXc+u91G8JNWYbuiqDi9NyOAmKlpFn0ciOcUMPzBrNxhG4CkXyrvhTcSg
	 LtJ+JjEJ31KD8FyqNzkYndUOMleXYhtt8M0zdvQTu3FCOFTTI6WxisgKGZXQdvGWv0f61
	 xHfBX+/eMxvqpnCu85EK3mr6kJ6Mvp/wNFWXrlsCvhKeK40Gg+or+0j+NnIASIpU/4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793996991;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=6oy9nr1xb0ho1PpeVZQMBAD5LEzfpsV6Ksry1t/sSVw=;
	b=zGotNsHZ/7dUzYEcxsfX8Oy7rpa2+c+O0yE6G9ZoMxZdBXeiAOST85RgsU4A0yqZ4Chp
	 DtBc5CgO172+dfzw5fgJqfsPR8GGW4PmqO1Xxl9aKl0jdz4nX9MJ80OGMlUftXhA23m4y
	 1t/F0+qk/65fJ4xTRJifHhvHvARojVtVjZuOaoX+WBFPoBxPa+0gjqPHf31q8neyv4RTg
	 hPnqdwng0XRlsk7daJXKzoX8NcaBgjCVn9AsoAaqzrEHhg+TpcCvdGQ14mFCdAai1fiTS
	 R8L4InaaS20jFQzgIS/N2w6v1o8ETwuxRDB6s2o4ZnAbMxYGghCFwPJNb+BhZt4V2mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gKBc165g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6C606A332;
	Fri,  6 Nov 2026 20:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gKBc165g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467B31F008A1;
	Fri,  6 Nov 2026 20:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793996991;
	bh=6oy9nr1xb0ho1PpeVZQMBAD5LEzfpsV6Ksry1t/sSVw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gKBc165gXnYHARNBJMkyi5epy9NuDIQCyjbwVp7V5HjRwWw2rFaT4fAASQPlgm9F9
	 XniOqriEV6fnMYhvRylAXIp/15onpdsdhtr/Pl4zcOibHWCSZG3tnJ67SwgmlxzVzN
	 m8wZoUYeD8jBeKp1ULgZyAl4VqJux2BvIFuUVkriBhcLr3JNoLcH2f5kgytJ0kmliQ
	 s5nlgyli+uct7pTD3gFWchR9nMnb4eN0N+WJ38s6psJWZ5yXjqL2nhLrG/NajytQkV
	 2O04U6mU8mIwH4oJ7gFnvgkk9aY8tgFewp7d5Jh4eVhe6kjqyYgWhT1BLDNdnnBkEX
	 g6kacR5TUifAg==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 06 Nov 2026 15:29:27 -0500
Subject: [PATCH v3 2/2] scsi: mpt3sas: Time out delayed not-responding
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
Message-Id: <20261106-sas-abba-v3-2-571b854594aa@kernel.org>
References: <20261106-sas-abba-v3-0-571b854594aa@kernel.org>
In-Reply-To: <20261106-sas-abba-v3-0-571b854594aa@kernel.org>
To: Sathya Prakash <sathya.prakash@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, 
 Ranjan Kumar <ranjan.kumar@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Keith Busch <kbusch@kernel.org>, MPT-FusionLinux.pdl@broadcom.com, 
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=20949; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=TZJRgn9FJwWlEFNdqaJyd5ycOrTeeEEbkgFYclpI1qY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBq7ji7lcNMtgVclUSF4XSmaiM88bsCU5Nkk+cHT
 SOLTvLT2OCJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCau44uwAKCRAADmhBGVaC
 FTcHD/9dDzu6a5dODnZt2wllHJkEtg80YszSoXOL9v1c4LtjDfIf2mrqrzhgn7XHWz8m8jujXu3
 H47awGmt3x3a7BLqDTgeZ2W895GBSPoyaydU/v7sGQPj2CfT3iYVBb6lESZ0DCGM29BAcVsUqoU
 sojWgQH+0tAZ4PpKNZKbZaZ1DvSzLJT37eIqBmjNJbGLAtwzvh72BTnpsBL8Y17vKvCxg1iwinI
 0l7f/kNOjjzvbWq7dsuW4QXEyxqURpZlZ0JwPlrwQGMxer8OmjYG2XFrqmfQIOzJ3uR2iKqMxO5
 SxsC6SVaeuVFCHHEKtHplQBv+A/tC/vUYMRTI25WXsTfj1LHGCvYIXMul6xa+j9FrHWae8I6HAP
 2VPU68hpHZPB51H6r1iS+kByaqs4/SiRobkGZLJ9ywK9YPWwpSt12+QMv+a+vbZ520ai72L1xAP
 y5xIaFoAbpZU4NpPnTbCwNL3TRpjD3AQRSH1iMWb4DLNdqh73oLtYRN41APF13igW40GgRgeivM
 frKGlQFya/3iHUucBy3FFEAd8UAcfkeMMqtzUEW1eerRGjVzd+q3lIC7ZGBNa3iWdKWtlVdJdVt
 tclK5f3xnD22tN1keAm6aBo286ZyEsnUOiQr+MH43zGnUNLeQIurrFlcxqgGY35TEsLUu8rPbFb
 Ov9DMzJmjfKGgVg==
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

Schedule delayed_work to the system_dfl_wq for the missing delay plus
30s. When it runs, unblock any expired sdevs. The driver only tracked
the SAS missing delay, so also read the PCIe one from PCIe IO Unit
Page 1, already fetched for the NVMe queue depth, and use the larger.

Take ioc->block_lock around the worker's unblocks, so they can't race
the interrupt-time block and lose its deadline. Don't timed-block
offline sdevs: expiry would bring them back running with no TUR check.

Cc: Keith Busch <kbusch@kernel.org>
Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  13 +++
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  10 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 215 ++++++++++++++++++++++++++++++++---
 3 files changed, 224 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1af25a22611a..cc2dcbce0491 100644
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
@@ -5453,6 +5455,17 @@ static int _base_assign_fw_reported_qd(struct MPT3SAS_ADAPTER *ioc)
 	ioc->max_nvme_qd = (le16_to_cpu(pcie_iounit_pg1.NVMeMaxQueueDepth)) ?
 	    (le16_to_cpu(pcie_iounit_pg1.NVMeMaxQueueDepth)) :
 	    MPT3SAS_NVME_QUEUE_DEPTH;
+
+	if ((le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK) !=
+	    MPI2_IOCSTATUS_SUCCESS)
+		goto out;
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
index 419fdf164fc6..11bbefbb9516 100644
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
+ * @block_lock: serializes sdev blocking and unblocking against
+ *	dnr_unblock_work and sdev hostdata teardown
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
index 60c9cf679a8a..acdeece20140 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3887,6 +3887,7 @@ _scsih_internal_device_block(struct scsi_device *sdev,
 	sdev_printk(KERN_INFO, sdev, "device_block, handle(0x%04x)\n",
 	    sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 1;
+	sas_device_priv_data->block_deadline = 0;
 
 	r = scsi_internal_device_block_nowait(sdev);
 	if (r == -EINVAL)
@@ -3912,6 +3913,7 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 	sdev_printk(KERN_WARNING, sdev, "device_unblock and setting to running, "
 	    "handle(0x%04x)\n", sas_device_priv_data->sas_target->handle);
 	sas_device_priv_data->block = 0;
+	sas_device_priv_data->block_deadline = 0;
 	r = scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
 	if (r == -EINVAL) {
 		/* The device has been set to SDEV_RUNNING by SD layer during
@@ -3939,6 +3941,35 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 	}
 }
 
+/**
+ * _scsih_claim_block - keep dnr_unblock_work off a blocked sdev
+ * @ioc: per adapter object
+ * @sdev: scsi device struct
+ *
+ * Called by the firmware event worker before it polls a device with TURs.
+ * The worker unblocks the device when polling ends, and must not have
+ * dnr_unblock_work send I/O to it in the meantime.
+ *
+ * Return: true if @sdev is blocked, false if it was never blocked or its
+ * block has already expired.
+ */
+static bool
+_scsih_claim_block(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	unsigned long flags;
+	bool blocked = false;
+
+	spin_lock_irqsave(&ioc->block_lock, flags);
+	sas_device_priv_data = sdev->hostdata;
+	if (sas_device_priv_data && sas_device_priv_data->block) {
+		sas_device_priv_data->block_deadline = 0;
+		blocked = true;
+	}
+	spin_unlock_irqrestore(&ioc->block_lock, flags);
+	return blocked;
+}
+
 /**
  * _scsih_ublock_io_all_device - unblock every device
  * @ioc: per adapter object
@@ -3958,7 +3989,20 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 	int count = 0;
 	u8 tr_method = 0;
 	u8 tr_timeout = 30;
+	unsigned long flags;
 
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
 
 	shost_for_each_device(sdev, ioc->shost) {
 		sas_device_priv_data = sdev->hostdata;
@@ -3975,10 +4019,18 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 		if ((no_turs) || (!issue_scsi_cmd_to_bringup_drive)) {
 			sdev_printk(KERN_WARNING, sdev, "device_unblocked handle(0x%04x)\n",
 				sas_device_priv_data->sas_target->handle);
-			_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+			spin_lock_irqsave(&ioc->block_lock, flags);
+			/* dnr_unblock_work may have released it */
+			if (sas_device_priv_data->block)
+				_scsih_internal_device_unblock(sdev,
+				    sas_device_priv_data);
+			spin_unlock_irqrestore(&ioc->block_lock, flags);
 			continue;
 		}
 
+		/* may have been blocked since the first pass */
+		if (!_scsih_claim_block(ioc, sdev))
+			continue;
 		do {
 			pcie_device = mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
 			if (pcie_device && (!ioc->tm_custom_handling) &&
@@ -3997,11 +4049,13 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 		} while ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
 		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
 			&& count++ < command_retry_count);
+		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data->block = 0;
 		if (rc != DEVICE_READY)
 			sas_device_priv_data->deleted = 1;
 
 		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
 
 		if (rc != DEVICE_READY) {
 			sdev_printk(KERN_WARNING, sdev, "%s: device_offlined,\n"
@@ -4060,24 +4114,30 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	u8 tr_timeout = 30;
 	u8 tr_method = 0;
 	int count = 0;
+	unsigned long flags;
 
 	/* moving devices from SDEV_OFFLINE to SDEV_BLOCK */
 	shost_for_each_device(sdev, ioc->shost) {
+		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data)
-			continue;
+			goto next;
 		sas_target = sas_device_priv_data->sas_target;
 		if (!sas_target)
-			continue;
+			goto next;
 		if (sas_target->sas_address != sas_address ||
 		    sas_target->port != port)
-			continue;
+			goto next;
+		/* polling one device can outlast another's deadline */
+		sas_device_priv_data->block_deadline = 0;
 		if (sdev->sdev_state == SDEV_OFFLINE) {
 			sas_device_priv_data->block = 1;
 			sas_device_priv_data->deleted = 0;
 			scsi_device_set_state(sdev, SDEV_RUNNING);
 			scsi_internal_device_block_nowait(sdev);
 		}
+next:
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
 	}
 
 	/* moving devices from SDEV_BLOCK to SDEV_RUNNING state */
@@ -4091,7 +4151,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		if (sas_target->sas_address != sas_address ||
 		    sas_target->port != port)
 			continue;
-		if (!sas_device_priv_data->block)
+		if (!_scsih_claim_block(ioc, sdev))
 			continue;
 
 		do {
@@ -4129,10 +4189,12 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
 			&& count++ <= command_retry_count);
 
+		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data->block = 0;
 		if (rc != DEVICE_READY)
 			sas_device_priv_data->deleted = 1;
 		scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
 
 		if (rc != DEVICE_READY) {
 			sdev_printk(KERN_WARNING, sdev,
@@ -4186,19 +4248,23 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc,
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
+	unsigned long flags;
 
 	shost_for_each_device(sdev, ioc->shost) {
+		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data || !sas_device_priv_data->sas_target)
-			continue;
+			goto next;
 		if (sas_device_priv_data->sas_target->sas_address
 		    != sas_address)
-			continue;
+			goto next;
 		if (sas_device_priv_data->sas_target->port != port)
-			continue;
+			goto next;
 		if (sas_device_priv_data->block)
 			_scsih_internal_device_unblock(sdev,
 				sas_device_priv_data);
+next:
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
 	}
 }
 
@@ -4213,21 +4279,119 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
+	unsigned long flags;
 
 	shost_for_each_device(sdev, ioc->shost) {
+		spin_lock_irqsave(&ioc->block_lock, flags);
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data)
-			continue;
-		if (sas_device_priv_data->block)
-			continue;
+			goto next;
+		if (sas_device_priv_data->block) {
+			/* the caller unblocks it; dnr_unblock_work must not */
+			sas_device_priv_data->block_deadline = 0;
+			goto next;
+		}
 		if (sas_device_priv_data->ignore_delay_remove) {
 			sdev_printk(KERN_INFO, sdev,
 			"%s skip device_block for SES handle(0x%04x)\n",
 			__func__, sas_device_priv_data->sas_target->handle);
-			continue;
+			goto next;
 		}
 		_scsih_internal_device_block(sdev, sas_device_priv_data);
+next:
+		spin_unlock_irqrestore(&ioc->block_lock, flags);
+	}
+}
+
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
 	}
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
+	/*
+	 * scsih_qcmd() relies on blocked devices during SCSI EH, which
+	 * outlasts shost_recovery.
+	 */
+	if (ioc->shost_recovery || ioc->pci_error_recovery ||
+	    scsi_host_in_recovery(ioc->shost)) {
+		mod_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work, HZ);
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
 }
 
 /**
@@ -4243,7 +4407,9 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
 	struct _sas_device *sas_device;
+	unsigned long timeout = _scsih_dnr_block_timeout(ioc);
 	unsigned long flags;
+	bool blocked = false;
 
 	sas_device = mpt3sas_get_sdev_by_handle(ioc, handle);
 
@@ -4254,10 +4420,23 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			goto next;
 		if (sas_device_priv_data->sas_target->handle != handle)
 			goto next;
-		if (sas_device_priv_data->block)
+		if (sas_device_priv_data->block) {
+			/* a repeat DNR restarts the firmware's missing delay */
+			if (sas_device_priv_data->block_deadline) {
+				sas_device_priv_data->block_deadline =
+				    (jiffies + timeout) ?: 1;
+				blocked = true;
+			}
 			goto next;
+		}
 		if (sas_device && sas_device->pend_sas_rphy_add)
 			goto next;
+		/*
+		 * Expiry would bring it back running without a TUR check.
+		 * _scsih_ublock_io_device_wait() polls offline devices anyway.
+		 */
+		if (sdev->sdev_state == SDEV_OFFLINE)
+			goto next;
 		if (sas_device_priv_data->ignore_delay_remove) {
 			sdev_printk(KERN_INFO, sdev,
 			"%s skip device_block for SES handle(0x%04x)\n",
@@ -4265,12 +4444,18 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
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
@@ -12556,6 +12741,7 @@ static void scsih_remove(struct pci_dev *pdev)
 		return;
 
 	ioc->remove_host = 1;
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
@@ -12656,6 +12842,7 @@ scsih_shutdown(struct pci_dev *pdev)
 		return;
 
 	ioc->remove_host = 1;
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 
 	if (!pci_device_is_present(pdev)) {
 		mpt3sas_base_pause_mq_polling(ioc);
@@ -13569,6 +13756,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ioc->delayed_tr_volume_list);
 	INIT_LIST_HEAD(&ioc->reply_queue_list);
 	INIT_LIST_HEAD(&ioc->port_table_list);
+	INIT_DELAYED_WORK(&ioc->dnr_unblock_work, _scsih_dnr_unblock_work);
 
 	sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
 
@@ -13679,6 +13867,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mpt3sas_setup_debugfs(ioc);
 	return 0;
 out_add_shost_fail:
+	disable_delayed_work_sync(&ioc->dnr_unblock_work);
 	mpt3sas_base_detach(ioc);
  out_attach_fail:
 	destroy_workqueue(ioc->firmware_event_thread);

-- 
2.56.0

