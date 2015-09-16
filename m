From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2 09/30] cxlflash: Fix to stop interrupt processing on remove
Date: Wed, 16 Sep 2015 16:28:01 -0500
Message-ID: <1442438881-49507-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:52597 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbIPV21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 17:28:27 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 16 Sep 2015 17:28:27 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id DA39338C8026
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 17:28:24 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8GLSOYX54788238
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 21:28:24 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8GLSNR7026457
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 17:28:24 -0400
In-Reply-To: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Interrupt processing can run in parallel to a remove operation. This
can lead to a condition where the interrupt handler is processing with
memory that has been freed.
    
To avoid processing an interrupt while memory may be yanked, check for
removal while in the interrupt handler. Bail when removal is imminent.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  2 ++
 drivers/scsi/cxlflash/main.c   | 21 +++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 1abe4e0..03d2cc6 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -103,6 +103,8 @@ struct cxlflash_cfg {
 	enum cxlflash_lr_state lr_state;
 	int lr_port;
 
+	atomic_t remove_active;
+
 	struct cxl_afu *cxl_afu;
 
 	struct pci_pool *cxlflash_cmd_pool;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 6e85c77..89ee648 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -892,6 +892,7 @@ static void cxlflash_remove(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
 
 	cfg->state = STATE_FAILTERM;
+	atomic_inc(&cfg->remove_active);
 	cxlflash_stop_term_user_contexts(cfg);
 
 	switch (cfg->init_state) {
@@ -1380,16 +1381,20 @@ static void afu_err_intr_init(struct afu *afu)
 static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
 {
 	struct afu *afu = (struct afu *)data;
+	struct cxlflash_cfg *cfg = afu->parent;
 	u64 reg;
 	u64 reg_unmasked;
 
+	if (atomic_read(&cfg->remove_active))
+		goto out;
+
 	reg = readq_be(&afu->host_map->intr_status);
 	reg_unmasked = (reg & SISL_ISTATUS_UNMASK);
 
 	if (reg_unmasked == 0UL) {
 		pr_err("%s: %llX: spurious interrupt, intr_status %016llX\n",
 		       __func__, (u64)afu, reg);
-		goto cxlflash_sync_err_irq_exit;
+		goto out;
 	}
 
 	pr_err("%s: %llX: unexpected interrupt, intr_status %016llX\n",
@@ -1397,7 +1402,7 @@ static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
 
 	writeq_be(reg_unmasked, &afu->host_map->intr_clear);
 
-cxlflash_sync_err_irq_exit:
+out:
 	pr_debug("%s: returning rc=%d\n", __func__, IRQ_HANDLED);
 	return IRQ_HANDLED;
 }
@@ -1412,6 +1417,7 @@ cxlflash_sync_err_irq_exit:
 static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 {
 	struct afu *afu = (struct afu *)data;
+	struct cxlflash_cfg *cfg = afu->parent;
 	struct afu_cmd *cmd;
 	bool toggle = afu->toggle;
 	u64 entry,
@@ -1421,8 +1427,10 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 
 	/* Process however many RRQ entries that are ready */
 	while (true) {
-		entry = *hrrq_curr;
+		if (atomic_read(&cfg->remove_active))
+			goto out;
 
+		entry = *hrrq_curr;
 		if ((entry & SISL_RESP_HANDLE_T_BIT) != toggle)
 			break;
 
@@ -1440,7 +1448,7 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 
 	afu->hrrq_curr = hrrq_curr;
 	afu->toggle = toggle;
-
+out:
 	return IRQ_HANDLED;
 }
 
@@ -1454,7 +1462,7 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 {
 	struct afu *afu = (struct afu *)data;
-	struct cxlflash_cfg *cfg;
+	struct cxlflash_cfg *cfg = afu->parent;
 	u64 reg_unmasked;
 	const struct asyc_intr_info *info;
 	struct sisl_global_map *global = &afu->afu_map->global;
@@ -1462,7 +1470,8 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 	u8 port;
 	int i;
 
-	cfg = afu->parent;
+	if (atomic_read(&cfg->remove_active))
+		goto out;
 
 	reg = readq_be(&global->regs.aintr_status);
 	reg_unmasked = (reg & SISL_ASTATUS_UNMASK);
-- 
2.1.0

