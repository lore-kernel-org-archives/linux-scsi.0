From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 14/17] cxlflash: Improve asynchronous interrupt processing
Date: Wed, 12 Apr 2017 14:15:29 -0500
Message-ID: <1492024529-56138-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36577 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752643AbdDLTPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:15:49 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ99x5020232
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:49 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29srxsunbx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:15:49 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:15:47 -0600
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The method used to decode asynchronous interrupts involves unnecessary
loops to match up bits that are set with corresponding entries in the
asynchronous interrupt information table. This algorithm is wasteful
and does not scale well as new status bits are supported.

As an improvement, use the for_each_set_bit() service to iterate over
the asynchronous status bits and refactor the information table such
that it can be indexed by bit position.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 94 ++++++++++++++++++++------------------------
 1 file changed, 42 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index f5c952c..c60936f 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1017,52 +1017,6 @@ static void afu_link_reset(struct afu *afu, int port, __be64 __iomem *fc_regs)
 	dev_dbg(dev, "%s: returning port_sel=%016llx\n", __func__, port_sel);
 }
 
-/*
- * Asynchronous interrupt information table
- *
- * NOTE: The checkpatch script considers the BUILD_SISL_ASTATUS_FC_PORT macro
- * as complex and complains because it is not wrapped with parentheses/braces.
- */
-#define ASTATUS_FC(_a, _b, _c, _d)					 \
-	{ SISL_ASTATUS_FC##_a##_##_b, _c, _a, (_d) }
-
-#define BUILD_SISL_ASTATUS_FC_PORT(_a)					 \
-	ASTATUS_FC(_a, OTHER, "other error", CLR_FC_ERROR | LINK_RESET), \
-	ASTATUS_FC(_a, LOGO, "target initiated LOGO", 0),		 \
-	ASTATUS_FC(_a, CRC_T, "CRC threshold exceeded", LINK_RESET),	 \
-	ASTATUS_FC(_a, LOGI_R, "login timed out, retrying", LINK_RESET), \
-	ASTATUS_FC(_a, LOGI_F, "login failed", CLR_FC_ERROR),		 \
-	ASTATUS_FC(_a, LOGI_S, "login succeeded", SCAN_HOST),		 \
-	ASTATUS_FC(_a, LINK_DN, "link down", 0),			 \
-	ASTATUS_FC(_a, LINK_UP, "link up", 0)
-
-static const struct asyc_intr_info ainfo[] = {
-	BUILD_SISL_ASTATUS_FC_PORT(2),
-	BUILD_SISL_ASTATUS_FC_PORT(3),
-	BUILD_SISL_ASTATUS_FC_PORT(0),
-	BUILD_SISL_ASTATUS_FC_PORT(1),
-	{ 0x0, "", 0, 0 }
-};
-
-/**
- * find_ainfo() - locates and returns asynchronous interrupt information
- * @status:	Status code set by AFU on error.
- *
- * Return: The located information or NULL when the status code is invalid.
- */
-static const struct asyc_intr_info *find_ainfo(u64 status)
-{
-	const struct asyc_intr_info *info;
-
-	BUILD_BUG_ON(ainfo[ARRAY_SIZE(ainfo) - 1].status != 0);
-
-	for (info = &ainfo[0]; info->status; info++)
-		if (info->status == status)
-			return info;
-
-	return NULL;
-}
-
 /**
  * afu_err_intr_init() - clears and initializes the AFU for error interrupts
  * @afu:	AFU associated with the host.
@@ -1293,6 +1247,35 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+/*
+ * Asynchronous interrupt information table
+ *
+ * NOTE:
+ *	- Order matters here as this array is indexed by bit position.
+ *
+ *	- The checkpatch script considers the BUILD_SISL_ASTATUS_FC_PORT macro
+ *	  as complex and complains due to a lack of parentheses/braces.
+ */
+#define ASTATUS_FC(_a, _b, _c, _d)					 \
+	{ SISL_ASTATUS_FC##_a##_##_b, _c, _a, (_d) }
+
+#define BUILD_SISL_ASTATUS_FC_PORT(_a)					 \
+	ASTATUS_FC(_a, LINK_UP, "link up", 0),				 \
+	ASTATUS_FC(_a, LINK_DN, "link down", 0),			 \
+	ASTATUS_FC(_a, LOGI_S, "login succeeded", SCAN_HOST),		 \
+	ASTATUS_FC(_a, LOGI_F, "login failed", CLR_FC_ERROR),		 \
+	ASTATUS_FC(_a, LOGI_R, "login timed out, retrying", LINK_RESET), \
+	ASTATUS_FC(_a, CRC_T, "CRC threshold exceeded", LINK_RESET),	 \
+	ASTATUS_FC(_a, LOGO, "target initiated LOGO", 0),		 \
+	ASTATUS_FC(_a, OTHER, "other error", CLR_FC_ERROR | LINK_RESET)
+
+static const struct asyc_intr_info ainfo[] = {
+	BUILD_SISL_ASTATUS_FC_PORT(1),
+	BUILD_SISL_ASTATUS_FC_PORT(0),
+	BUILD_SISL_ASTATUS_FC_PORT(3),
+	BUILD_SISL_ASTATUS_FC_PORT(2)
+};
+
 /**
  * cxlflash_async_err_irq() - interrupt handler for asynchronous errors
  * @irq:	Interrupt number.
@@ -1305,18 +1288,18 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 	struct afu *afu = (struct afu *)data;
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
-	u64 reg_unmasked;
 	const struct asyc_intr_info *info;
 	struct sisl_global_map __iomem *global = &afu->afu_map->global;
 	__be64 __iomem *fc_port_regs;
+	u64 reg_unmasked;
 	u64 reg;
+	u64 bit;
 	u8 port;
-	int i;
 
 	reg = readq_be(&global->regs.aintr_status);
 	reg_unmasked = (reg & SISL_ASTATUS_UNMASK);
 
-	if (reg_unmasked == 0) {
+	if (unlikely(reg_unmasked == 0)) {
 		dev_err(dev, "%s: spurious interrupt, aintr_status=%016llx\n",
 			__func__, reg);
 		goto out;
@@ -1326,10 +1309,17 @@ static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
 	writeq_be(reg_unmasked, &global->regs.aintr_clear);
 
 	/* Check each bit that is on */
-	for (i = 0; reg_unmasked; i++, reg_unmasked = (reg_unmasked >> 1)) {
-		info = find_ainfo(1ULL << i);
-		if (((reg_unmasked & 0x1) == 0) || !info)
+	for_each_set_bit(bit, (ulong *)&reg_unmasked, BITS_PER_LONG) {
+		if (unlikely(bit >= ARRAY_SIZE(ainfo))) {
+			WARN_ON_ONCE(1);
 			continue;
+		}
+
+		info = &ainfo[bit];
+		if (unlikely(info->status != 1ULL << bit)) {
+			WARN_ON_ONCE(1);
+			continue;
+		}
 
 		port = info->port;
 		fc_port_regs = get_fc_port_regs(cfg, port);
-- 
2.1.0
