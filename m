From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 01/41] cxlflash: Preserve number of interrupts for master
 contexts
Date: Mon, 26 Mar 2018 11:29:56 -0500
Message-ID: <1522081796-57486-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The number of interrupts requested for user contexts are stored in the
context specific structures and utilized to manage the interrupts. For the
master contexts, this number is only used once and therefore not saved.

To prepare for future commits where the number of interrupts will be
required in more than one place, preserve the value in the master context
structure.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  1 +
 drivers/scsi/cxlflash/main.c   | 11 ++++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 102fd26..5d7ca01 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -211,6 +211,7 @@ struct hwq {
 	struct sisl_ctrl_map __iomem *ctrl_map;		/* MC control map */
 	ctx_hndl_t ctx_hndl;	/* master's context handle */
 	u32 index;		/* Index of this hwq */
+	int num_irqs;		/* Numer of interrupts requested for context */
 	struct list_head pending_cmds;	/* Commands pending completion */
 
 	atomic_t hsq_credits;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index d8fe7ab8..3d3e003 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1911,7 +1911,7 @@ static enum undo_level init_intr(struct cxlflash_cfg *cfg,
 	int rc = 0;
 	enum undo_level level = UNDO_NOOP;
 	bool is_primary_hwq = (hwq->index == PRIMARY_HWQ);
-	int num_irqs = is_primary_hwq ? 3 : 2;
+	int num_irqs = hwq->num_irqs;
 
 	rc = cfg->ops->allocate_afu_irqs(ctx, num_irqs);
 	if (unlikely(rc)) {
@@ -1965,16 +1965,20 @@ static int init_mc(struct cxlflash_cfg *cfg, u32 index)
 	struct device *dev = &cfg->dev->dev;
 	struct hwq *hwq = get_hwq(cfg->afu, index);
 	int rc = 0;
+	int num_irqs;
 	enum undo_level level;
 
 	hwq->afu = cfg->afu;
 	hwq->index = index;
 	INIT_LIST_HEAD(&hwq->pending_cmds);
 
-	if (index == PRIMARY_HWQ)
+	if (index == PRIMARY_HWQ) {
 		ctx = cfg->ops->get_context(cfg->dev, cfg->afu_cookie);
-	else
+		num_irqs = 3;
+	} else {
 		ctx = cfg->ops->dev_context_init(cfg->dev, cfg->afu_cookie);
+		num_irqs = 2;
+	}
 	if (IS_ERR_OR_NULL(ctx)) {
 		rc = -ENOMEM;
 		goto err1;
@@ -1982,6 +1986,7 @@ static int init_mc(struct cxlflash_cfg *cfg, u32 index)
 
 	WARN_ON(hwq->ctx_cookie);
 	hwq->ctx_cookie = ctx;
+	hwq->num_irqs = num_irqs;
 
 	/* Set it up as a master with the CXL */
 	cfg->ops->set_master(ctx);
-- 
2.1.0
