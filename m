From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 4/4] cxlflash: Cancel scheduled workers before stopping AFU
Date: Fri,  6 Jan 2017 08:05:36 -0600
Message-ID: <1483711536-18341-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1483711379-18188-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932330AbdAFOFw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2017 09:05:52 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id v06E3huj051971
        for <linux-scsi@vger.kernel.org>; Fri, 6 Jan 2017 09:05:51 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0b-001b2d01.pphosted.com with ESMTP id 27t9t36hsm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2017 09:05:50 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Fri, 6 Jan 2017 09:05:49 -0500
In-Reply-To: <1483711379-18188-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

When processing an AFU asynchronous interrupt, if the action results in an
operation that requires off level processing (a link reset for example),
the worker thread is scheduled. In the meantime a reset event (i.e.: EEH)
could unmap the AFU to recover. This results in an Oops when the worker
thread tries to access the AFU mapping.

[c000000f17e03b90] d000000007cd5978 cxlflash_worker_thread+0x268/0x550
[c000000f17e03c40] c00000000011883c process_one_work+0x1dc/0x680
[c000000f17e03ce0] c000000000118e80 worker_thread+0x1a0/0x520
[c000000f17e03d80] c000000000126174 kthread+0xf4/0x100
[c000000f17e03e30] c00000000000a47c ret_from_kernel_thread+0x5c/0xe0

In an effort to avoid this, a mapcount was introduced in
commit b45cdbaf9f7f ("cxlflash: Resolve oops in wait_port_offline")
but due to the race condition described above, this solution is incomplete.

In order to fully resolve this problem and to simplify things, this commit
removes the mapcount solution. Instead, the scheduled worker thread is
cancelled after interrupts have been disabled and prior to the mapping
being freed.

Fixes: b45cdbaf9f7f ("cxlflash: Resolve oops in wait_port_offline")
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  2 --
 drivers/scsi/cxlflash/main.c   | 34 ++++++----------------------------
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index dee8657..d11dcc5 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -174,8 +174,6 @@ struct afu {
 	struct sisl_host_map __iomem *host_map;		/* MC host map */
 	struct sisl_ctrl_map __iomem *ctrl_map;		/* MC control map */
 
-	struct kref mapcount;
-
 	ctx_hndl_t ctx_hndl;	/* master's context handle */
 
 	atomic_t hsq_credits;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index ab38bca..7069639 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -419,16 +419,6 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 	return rc;
 }
 
-static void afu_unmap(struct kref *ref)
-{
-	struct afu *afu = container_of(ref, struct afu, mapcount);
-
-	if (likely(afu->afu_map)) {
-		cxl_psa_unmap((void __iomem *)afu->afu_map);
-		afu->afu_map = NULL;
-	}
-}
-
 /**
  * cxlflash_driver_info() - information handler for this host driver
  * @host:	SCSI host associated with device.
@@ -459,7 +449,6 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	ulong lock_flags;
 	int nseg = 0;
 	int rc = 0;
-	int kref_got = 0;
 
 	dev_dbg_ratelimited(dev, "%s: (scp=%p) %d/%d/%d/%llu "
 			    "cdb=(%08x-%08x-%08x-%08x)\n",
@@ -497,9 +486,6 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 		break;
 	}
 
-	kref_get(&cfg->afu->mapcount);
-	kref_got = 1;
-
 	if (likely(sg)) {
 		nseg = scsi_dma_map(scp);
 		if (unlikely(nseg < 0)) {
@@ -530,8 +516,6 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	if (unlikely(rc))
 		scsi_dma_unmap(scp);
 out:
-	if (kref_got)
-		kref_put(&afu->mapcount, afu_unmap);
 	return rc;
 }
 
@@ -569,13 +553,15 @@ static void free_mem(struct cxlflash_cfg *cfg)
  *
  * Safe to call with AFU in a partially allocated/initialized state.
  *
- * Waits for any active internal AFU commands to timeout and then unmaps
- * the MMIO space.
+ * Cancels scheduled worker threads, waits for any active internal AFU
+ * commands to timeout and then unmaps the MMIO space.
  */
 static void stop_afu(struct cxlflash_cfg *cfg)
 {
 	struct afu *afu = cfg->afu;
 
+	cancel_work_sync(&cfg->work_q);
+
 	if (likely(afu)) {
 		while (atomic_read(&afu->cmds_active))
 			ssleep(1);
@@ -583,7 +569,6 @@ static void stop_afu(struct cxlflash_cfg *cfg)
 			cxl_psa_unmap((void __iomem *)afu->afu_map);
 			afu->afu_map = NULL;
 		}
-		kref_put(&afu->mapcount, afu_unmap);
 	}
 }
 
@@ -767,7 +752,6 @@ static void cxlflash_remove(struct pci_dev *pdev)
 		scsi_remove_host(cfg->host);
 		/* fall through */
 	case INIT_STATE_AFU:
-		cancel_work_sync(&cfg->work_q);
 		term_afu(cfg);
 	case INIT_STATE_PCI:
 		pci_disable_device(pdev);
@@ -1277,7 +1261,6 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 				__func__, port);
 			cfg->lr_state = LINK_RESET_REQUIRED;
 			cfg->lr_port = port;
-			kref_get(&cfg->afu->mapcount);
 			schedule_work(&cfg->work_q);
 		}
 
@@ -1298,7 +1281,6 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 
 		if (info->action & SCAN_HOST) {
 			atomic_inc(&cfg->scan_host_needed);
-			kref_get(&cfg->afu->mapcount);
 			schedule_work(&cfg->work_q);
 		}
 	}
@@ -1704,7 +1686,6 @@ static int init_afu(struct cxlflash_cfg *cfg)
 		rc = -ENOMEM;
 		goto err1;
 	}
-	kref_init(&afu->mapcount);
 
 	/* No byte reverse on reading afu_version or string will be backwards */
 	reg = readq(&afu->afu_map->global.regs.afu_version);
@@ -1716,7 +1697,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 			"interface version %016llx\n", afu->version,
 		       afu->interface_version);
 		rc = -EINVAL;
-		goto err2;
+		goto err1;
 	}
 
 	if (afu_is_sq_cmd_mode(afu)) {
@@ -1733,7 +1714,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	rc = start_afu(cfg);
 	if (rc) {
 		dev_err(dev, "%s: start_afu failed, rc=%d\n", __func__, rc);
-		goto err2;
+		goto err1;
 	}
 
 	afu_err_intr_init(cfg->afu);
@@ -1746,8 +1727,6 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
 	return rc;
 
-err2:
-	kref_put(&afu->mapcount, afu_unmap);
 err1:
 	term_intr(cfg, UNMAP_THREE);
 	term_mc(cfg);
@@ -2341,7 +2320,6 @@ static void cxlflash_worker_thread(struct work_struct *work)
 
 	if (atomic_dec_if_positive(&cfg->scan_host_needed) >= 0)
 		scsi_scan_host(cfg->host);
-	kref_put(&afu->mapcount, afu_unmap);
 }
 
 /**
-- 
2.1.0

