Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [104.223.66.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDE2194C8B;
	Sat,  8 Feb 2025 19:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.223.66.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739042637; cv=none; b=eOHQVo7lxQn73+X71LAInCxDO947PxJMJR6eDVRu4l7kADpDLUrL3lComEK8y1wEKg3z4AbjQjGF2KIRCYaVeyI9pTOLYbMML/wI4ued48Pfx2DsNTNQXTpvo9gviPmk+i5Ts43CE89+SyPCFYfZ91d4IGVB4rsDyzRPtvbyaAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739042637; c=relaxed/simple;
	bh=VoAGpv/86sMwdZqrc7EpFd3Xlxd8ycSqZ7unfU6myo0=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=aBwanbAKsW4zUacn3ZQXowXQQWGf+Tr0uLcdOghoWmH2urUfttz+Dr33xB+AohGuz+AmSpUo9uhrEwvW4GLPhADZoruS/FwIp58N0deU9g6N+DcHyWOtMt7RphTXT+8wPRltDnHHjEgX0byKUgJ97gwGa+2UR3HLhOJULiA22U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=YqDhxZ47; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=YqDhxZ47; arc=none smtp.client-ip=104.223.66.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="YqDhxZ47";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="YqDhxZ47"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1739042633;
	bh=VoAGpv/86sMwdZqrc7EpFd3Xlxd8ycSqZ7unfU6myo0=;
	h=Message-ID:Subject:From:To:Date:From;
	b=YqDhxZ47uZ0xsfBAsVlU7FDUu5OSwvdGCtKCtFRK9fJtXkey7BeOnoQtafEpX8T2N
	 zi/RDuN+ulh++pSBM509BZ73QELDOYsw6IhIzVHDkoFFjGmfq68D1Q4Galn3g2HyYJ
	 wiRNwlDoR88G2U4MF8qWWZ0PYkP3siiigQth38/I=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id D541E128615D;
	Sat, 08 Feb 2025 14:23:53 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id jRItgOcEX86v; Sat,  8 Feb 2025 14:23:53 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1739042633;
	bh=VoAGpv/86sMwdZqrc7EpFd3Xlxd8ycSqZ7unfU6myo0=;
	h=Message-ID:Subject:From:To:Date:From;
	b=YqDhxZ47uZ0xsfBAsVlU7FDUu5OSwvdGCtKCtFRK9fJtXkey7BeOnoQtafEpX8T2N
	 zi/RDuN+ulh++pSBM509BZ73QELDOYsw6IhIzVHDkoFFjGmfq68D1Q4Galn3g2HyYJ
	 wiRNwlDoR88G2U4MF8qWWZ0PYkP3siiigQth38/I=
Received: from lingrow.int.hansenpartnership.com (c-67-166-174-65.hsd1.va.comcast.net [67.166.174.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3425B1281666;
	Sat, 08 Feb 2025 14:23:53 -0500 (EST)
Message-ID: <fa30513f6dbeb074de75d33b2270dcc60c1f8faa.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.14-rc1
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 08 Feb 2025 14:23:51 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A number of fairly small fixes, mostly in drivers but two in the core
to change a retry for depopulation (a trendy new hdd thing that
reorganizes blocks away from failing elements) and one to fix a GFP_
annotation to avoid a lock dependency (the third core patch is all in
testing).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

André Draszik (1):
      scsi: ufs: core: Fix use-after free in init error and remove paths

Avri Altman (3):
      scsi: ufs: Fix toggling of clk_gating.state when clock gating is not allowed
      scsi: ufs: core: Ensure clk_gating.lock is used only after initialization
      scsi: ufs: core: Simplify temperature exception event handling

Bao D. Nguyen (1):
      scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit Definitions

Guixin Liu (1):
      scsi: target: core: Add line break to status show

Igor Pylypiv (1):
      scsi: core: Do not retry I/Os during depopulation

Long Li (1):
      scsi: storvsc: Set correct data length for sending SCSI command without payload

Magnus Lindholm (1):
      scsi: qla1280: Fix kernel oops when debug level > 2

Mike Christie (1):
      scsi: core: Add passthrough tests for success and no failure definitions

Rik van Riel (1):
      scsi: core: Use GFP_NOIO to avoid circular locking dependency

Seunghui Lee (1):
      scsi: ufs: core: Fix error return with query response

And the diffstat:

 drivers/scsi/qla1280.c            |  2 +-
 drivers/scsi/scsi_lib.c           |  9 ++++--
 drivers/scsi/scsi_lib_test.c      |  7 ++++
 drivers/scsi/scsi_scan.c          |  2 +-
 drivers/scsi/storvsc_drv.c        |  1 +
 drivers/target/target_core_stat.c |  4 +--
 drivers/ufs/core/ufshcd.c         | 68 ++++++++++++++++++++-------------------
 drivers/ufs/host/ufshcd-pci.c     |  2 --
 drivers/ufs/host/ufshcd-pltfrm.c  | 28 ++++++----------
 include/ufs/ufs.h                 |  4 +--
 include/ufs/ufshcd.h              |  1 -
 11 files changed, 65 insertions(+), 63 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 1fd2da0264e3..47d74f881948 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2867,7 +2867,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
 				cpu_to_le32(upper_32_bits(dma_handle)),
 				cpu_to_le32(lower_32_bits(dma_handle)),
-				cpu_to_le32(sg_dma_len(sg_next(s))));
+				cpu_to_le32(sg_dma_len(s)));
 			remseg--;
 		}
 		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d776f13cd160..be0890e4e706 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -872,13 +872,18 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				case 0x1a: /* start stop unit in progress */
 				case 0x1b: /* sanitize in progress */
 				case 0x1d: /* configuration in progress */
-				case 0x24: /* depopulation in progress */
-				case 0x25: /* depopulation restore in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
 					action = ACTION_DELAYED_REPREP;
 					break;
+				/*
+				 * Depopulation might take many hours,
+				 * thus it is not worthwhile to retry.
+				 */
+				case 0x24: /* depopulation in progress */
+				case 0x25: /* depopulation restore in progress */
+					fallthrough;
 				default:
 					action = ACTION_FAIL;
 					break;
diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
index 99834426a100..ae8af0e0047a 100644
--- a/drivers/scsi/scsi_lib_test.c
+++ b/drivers/scsi/scsi_lib_test.c
@@ -67,6 +67,13 @@ static void scsi_lib_test_multiple_sense(struct kunit *test)
 	};
 	int i;
 
+	/* Success */
+	sc.result = 0;
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, NULL));
+	/* Command failed but caller did not pass in a failures array */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, NULL));
 	/* Match end of array */
 	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
 	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 087fcbfc9aaa..96d7e1a9a7c7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -246,7 +246,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 	}
 	ret = sbitmap_init_node(&sdev->budget_map,
 				scsi_device_max_queue_depth(sdev),
-				new_shift, GFP_KERNEL,
+				new_shift, GFP_NOIO,
 				sdev->request_queue->node, false, true);
 	if (!ret)
 		sbitmap_resize(&sdev->budget_map, depth);
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5a101ac06c47..a8614e54544e 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1800,6 +1800,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 
 	length = scsi_bufflen(scmnd);
 	payload = (struct vmbus_packet_mpb_array *)&cmd_request->mpb;
+	payload->range.len = 0;
 	payload_sz = 0;
 
 	if (scsi_sg_count(scmnd)) {
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index c42cbde8a31b..210648a0092e 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -117,9 +117,9 @@ static ssize_t target_stat_tgt_status_show(struct config_item *item,
 		char *page)
 {
 	if (to_stat_tgt_dev(item)->export_count)
-		return snprintf(page, PAGE_SIZE, "activated");
+		return snprintf(page, PAGE_SIZE, "activated\n");
 	else
-		return snprintf(page, PAGE_SIZE, "deactivated");
+		return snprintf(page, PAGE_SIZE, "deactivated\n");
 }
 
 static ssize_t target_stat_tgt_non_access_lus_show(struct config_item *item,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cd404ade48dc..1893a7ad9531 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2120,8 +2120,6 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 	INIT_DELAYED_WORK(&hba->clk_gating.gate_work, ufshcd_gate_work);
 	INIT_WORK(&hba->clk_gating.ungate_work, ufshcd_ungate_work);
 
-	spin_lock_init(&hba->clk_gating.lock);
-
 	hba->clk_gating.clk_gating_workq = alloc_ordered_workqueue(
 		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
 		hba->host->host_no);
@@ -3106,8 +3104,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case UPIU_TRANSACTION_QUERY_RSP: {
 		u8 response = lrbp->ucd_rsp_ptr->header.response;
 
-		if (response == 0)
+		if (response == 0) {
 			err = ufshcd_copy_query_response(hba, lrbp);
+		} else {
+			err = -EINVAL;
+			dev_err(hba->dev, "%s: unexpected response in Query RSP: %x\n",
+					__func__, response);
+		}
 		break;
 	}
 	case UPIU_TRANSACTION_REJECT_UPIU:
@@ -5976,24 +5979,6 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
-static void ufshcd_temp_exception_event_handler(struct ufs_hba *hba, u16 status)
-{
-	u32 value;
-
-	if (ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
-				QUERY_ATTR_IDN_CASE_ROUGH_TEMP, 0, 0, &value))
-		return;
-
-	dev_info(hba->dev, "exception Tcase %d\n", value - 80);
-
-	ufs_hwmon_notify_event(hba, status & MASK_EE_URGENT_TEMP);
-
-	/*
-	 * A placeholder for the platform vendors to add whatever additional
-	 * steps required
-	 */
-}
-
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
 	u8 index;
@@ -6214,7 +6199,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 		ufshcd_bkops_exception_event_handler(hba);
 
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
-		ufshcd_temp_exception_event_handler(hba, status);
+		ufs_hwmon_notify_event(hba, status & MASK_EE_URGENT_TEMP);
 
 	ufs_debugfs_exception_event(hba, status);
 }
@@ -9160,7 +9145,7 @@ static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
 		}
-	} else if (!ret && on) {
+	} else if (!ret && on && hba->clk_gating.is_initialized) {
 		scoped_guard(spinlock_irqsave, &hba->clk_gating.lock)
 			hba->clk_gating.state = CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
@@ -10246,16 +10231,6 @@ int ufshcd_system_thaw(struct device *dev)
 EXPORT_SYMBOL_GPL(ufshcd_system_thaw);
 #endif /* CONFIG_PM_SLEEP  */
 
-/**
- * ufshcd_dealloc_host - deallocate Host Bus Adapter (HBA)
- * @hba: pointer to Host Bus Adapter (HBA)
- */
-void ufshcd_dealloc_host(struct ufs_hba *hba)
-{
-	scsi_host_put(hba->host);
-}
-EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
-
 /**
  * ufshcd_set_dma_mask - Set dma mask based on the controller
  *			 addressing capability
@@ -10274,12 +10249,26 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
 }
 
+/**
+ * ufshcd_devres_release - devres cleanup handler, invoked during release of
+ *			   hba->dev
+ * @host: pointer to SCSI host
+ */
+static void ufshcd_devres_release(void *host)
+{
+	scsi_host_put(host);
+}
+
 /**
  * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
  *
  * Return: 0 on success, non-zero value on failure.
+ *
+ * NOTE: There is no corresponding ufshcd_dealloc_host() because this function
+ * keeps track of its allocations using devres and deallocates everything on
+ * device removal automatically.
  */
 int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 {
@@ -10301,6 +10290,13 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
+
+	err = devm_add_action_or_reset(dev, ufshcd_devres_release,
+				       host);
+	if (err)
+		return dev_err_probe(dev, err,
+				     "failed to add ufshcd dealloc action\n");
+
 	host->nr_maps = HCTX_TYPE_POLL + 1;
 	hba = shost_priv(host);
 	hba->host = host;
@@ -10429,6 +10425,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->irq = irq;
 	hba->vps = &ufs_hba_vps;
 
+	/*
+	 * Initialize clk_gating.lock early since it is being used in
+	 * ufshcd_setup_clocks()
+	 */
+	spin_lock_init(&hba->clk_gating.lock);
+
 	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index ea39c5d5b8cf..9cfcaad23cf9 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -562,7 +562,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 	pm_runtime_forbid(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 	ufshcd_remove(hba);
-	ufshcd_dealloc_host(hba);
 }
 
 /**
@@ -605,7 +604,6 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
-		ufshcd_dealloc_host(hba);
 		return err;
 	}
 
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 505572d4fa87..ffe5d1d2b215 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -465,21 +465,17 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 
 	mmio_base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(mmio_base)) {
-		err = PTR_ERR(mmio_base);
-		goto out;
-	}
+	if (IS_ERR(mmio_base))
+		return PTR_ERR(mmio_base);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		err = irq;
-		goto out;
-	}
+	if (irq < 0)
+		return irq;
 
 	err = ufshcd_alloc_host(dev, &hba);
 	if (err) {
 		dev_err(dev, "Allocation failed\n");
-		goto out;
+		return err;
 	}
 
 	hba->vops = vops;
@@ -488,13 +484,13 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	if (err) {
 		dev_err(dev, "%s: clock parse failed %d\n",
 				__func__, err);
-		goto dealloc_host;
+		return err;
 	}
 	err = ufshcd_parse_regulator_info(hba);
 	if (err) {
 		dev_err(dev, "%s: regulator init failed %d\n",
 				__func__, err);
-		goto dealloc_host;
+		return err;
 	}
 
 	ufshcd_init_lanes_per_dir(hba);
@@ -502,25 +498,20 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	err = ufshcd_parse_operating_points(hba);
 	if (err) {
 		dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
-		goto dealloc_host;
+		return err;
 	}
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err_probe(dev, err, "Initialization failed with error %d\n",
 			      err);
-		goto dealloc_host;
+		return err;
 	}
 
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
 	return 0;
-
-dealloc_host:
-	ufshcd_dealloc_host(hba);
-out:
-	return err;
 }
 EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
 
@@ -534,7 +525,6 @@ void ufshcd_pltfrm_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(&pdev->dev);
 	ufshcd_remove(hba);
-	ufshcd_dealloc_host(hba);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 }
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 89672ad8c3bb..f151feb0ca8c 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -385,8 +385,8 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
-	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
-	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
+	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(4),
+	UFS_DEV_LOW_TEMP_NOTIF		= BIT(5),
 	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 650ff238cd74..8bf31e6ca4e5 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1309,7 +1309,6 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 void ufshcd_enable_irq(struct ufs_hba *hba);
 void ufshcd_disable_irq(struct ufs_hba *hba);
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
-void ufshcd_dealloc_host(struct ufs_hba *);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
 int ufshcd_link_recovery(struct ufs_hba *hba);

