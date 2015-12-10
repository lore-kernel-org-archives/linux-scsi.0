From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 5/6] cxlflash: Resolve oops in wait_port_offline
Date: Thu, 10 Dec 2015 16:54:34 -0600
Message-ID: <1449788074-23208-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:54617 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbbLJWzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2015 17:55:03 -0500
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Thu, 10 Dec 2015 15:55:02 -0700
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 2878219D8042
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 15:43:06 -0700 (MST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBAMt0109830640
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 15:55:00 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBAMsxSb031699
	for <linux-scsi@vger.kernel.org>; Thu, 10 Dec 2015 15:55:00 -0700
In-Reply-To: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

From: Manoj Kumar <manoj@linux.vnet.ibm.com>

If an async error interrupt is generated, and the error requires the FC
link to be reset, it cannot be performed in the interrupt context. So
a work element is scheduled to complete the link reset in a process
context. If either an EEH event or an escalation occurs in between
when the interrupt is generated and the scheduled work is started, the
MMIO space may no longer be available. This will cause an oops in the
worker thread.

[  606.806583] NIP kthread_data+0x28/0x40
[  606.806633] LR wq_worker_sleeping+0x30/0x100
[  606.806694] Call Trace:
[  606.806721] 0x50 (unreliable)
[  606.806796] wq_worker_sleeping+0x30/0x100
[  606.806884] __schedule+0x69c/0x8a0
[  606.806959] schedule+0x44/0xc0
[  606.807034] do_exit+0x770/0xb90
[  606.807109] die+0x300/0x460
[  606.807185] bad_page_fault+0xd8/0x150
[  606.807259] handle_page_fault+0x2c/0x30
[  606.807338] wait_port_offline.constprop.12+0x60/0x130 [cxlflash]

To prevent the problem space area from being unmapped, when there is
pending work, a mapcount (using the kref mechanism) is held.  The mapcount
is released only when the work is completed.  The last reference release
is tied to the unmapping service.

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  2 ++
 drivers/scsi/cxlflash/main.c   | 27 ++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index c11cd19..5ada926 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -165,6 +165,8 @@ struct afu {
 	struct sisl_host_map __iomem *host_map;		/* MC host map */
 	struct sisl_ctrl_map __iomem *ctrl_map;		/* MC control map */
 
+	struct kref mapcount;
+
 	ctx_hndl_t ctx_hndl;	/* master's context handle */
 	u64 *hrrq_start;
 	u64 *hrrq_end;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 5d1d627..021b526 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -368,6 +368,7 @@ out:
 
 no_room:
 	afu->read_room = true;
+	kref_get(&cfg->afu->mapcount);
 	schedule_work(&cfg->work_q);
 	rc = SCSI_MLQUEUE_HOST_BUSY;
 	goto out;
@@ -473,6 +474,16 @@ out:
 	return rc;
 }
 
+static void afu_unmap(struct kref *ref)
+{
+	struct afu *afu = container_of(ref, struct afu, mapcount);
+
+	if (likely(afu->afu_map)) {
+		cxl_psa_unmap((void __iomem *)afu->afu_map);
+		afu->afu_map = NULL;
+	}
+}
+
 /**
  * cxlflash_driver_info() - information handler for this host driver
  * @host:	SCSI host associated with device.
@@ -503,6 +514,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	ulong lock_flags;
 	short lflag = 0;
 	int rc = 0;
+	int kref_got = 0;
 
 	dev_dbg_ratelimited(dev, "%s: (scp=%p) %d/%d/%d/%llu "
 			    "cdb=(%08X-%08X-%08X-%08X)\n",
@@ -547,6 +559,9 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 		goto out;
 	}
 
+	kref_get(&cfg->afu->mapcount);
+	kref_got = 1;
+
 	cmd->rcb.ctx_id = afu->ctx_hndl;
 	cmd->rcb.port_sel = port_sel;
 	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
@@ -587,6 +602,8 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	}
 
 out:
+	if (kref_got)
+		kref_put(&afu->mapcount, afu_unmap);
 	pr_devel("%s: returning rc=%d\n", __func__, rc);
 	return rc;
 }
@@ -661,6 +678,7 @@ static void stop_afu(struct cxlflash_cfg *cfg)
 			cxl_psa_unmap((void __iomem *)afu->afu_map);
 			afu->afu_map = NULL;
 		}
+		kref_put(&afu->mapcount, afu_unmap);
 	}
 }
 
@@ -746,8 +764,8 @@ static void cxlflash_remove(struct pci_dev *pdev)
 		scsi_remove_host(cfg->host);
 		/* fall through */
 	case INIT_STATE_AFU:
-		term_afu(cfg);
 		cancel_work_sync(&cfg->work_q);
+		term_afu(cfg);
 	case INIT_STATE_PCI:
 		pci_release_regions(cfg->dev);
 		pci_disable_device(pdev);
@@ -1331,6 +1349,7 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 				__func__, port);
 			cfg->lr_state = LINK_RESET_REQUIRED;
 			cfg->lr_port = port;
+			kref_get(&cfg->afu->mapcount);
 			schedule_work(&cfg->work_q);
 		}
 
@@ -1351,6 +1370,7 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 
 		if (info->action & SCAN_HOST) {
 			atomic_inc(&cfg->scan_host_needed);
+			kref_get(&cfg->afu->mapcount);
 			schedule_work(&cfg->work_q);
 		}
 	}
@@ -1746,6 +1766,7 @@ static int init_afu(struct cxlflash_cfg *cfg)
 		rc = -ENOMEM;
 		goto err1;
 	}
+	kref_init(&afu->mapcount);
 
 	/* No byte reverse on reading afu_version or string will be backwards */
 	reg = readq(&afu->afu_map->global.regs.afu_version);
@@ -1780,8 +1801,7 @@ out:
 	return rc;
 
 err2:
-	cxl_psa_unmap((void __iomem *)afu->afu_map);
-	afu->afu_map = NULL;
+	kref_put(&afu->mapcount, afu_unmap);
 err1:
 	term_mc(cfg, UNDO_START);
 	goto out;
@@ -2354,6 +2374,7 @@ static void cxlflash_worker_thread(struct work_struct *work)
 
 	if (atomic_dec_if_positive(&cfg->scan_host_needed) >= 0)
 		scsi_scan_host(cfg->host);
+	kref_put(&afu->mapcount, afu_unmap);
 }
 
 /**
-- 
2.1.0

