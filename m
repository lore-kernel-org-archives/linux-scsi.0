From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 08/17] cxlflash: SISlite updates to support 4 ports
Date: Wed, 12 Apr 2017 14:14:28 -0500
Message-ID: <1492024468-55918-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32785 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752401AbdDLTOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:14:49 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ98X7054247
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:14:49 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29sqnn77nh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:14:49 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 15:14:48 -0400
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Update the SISlite header to support 4 ports as outlined in the
SISlite specification. Address fallout from structure renames and
refreshed organization throughout the driver. Determine the number
of ports supported by a card from the global port selection mask
register reset value.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h  | 25 ++++++++---
 drivers/scsi/cxlflash/main.c    | 77 +++++++++++++++++++++++++--------
 drivers/scsi/cxlflash/sislite.h | 96 ++++++++++++++++++++++++++++-------------
 3 files changed, 141 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index e6a7c97..28bb716 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -26,8 +26,11 @@
 extern const struct file_operations cxlflash_cxl_fops;
 
 #define MAX_CONTEXT	CXLFLASH_MAX_CONTEXT	/* num contexts per afu */
-#define NUM_FC_PORTS	CXLFLASH_NUM_FC_PORTS	/* ports per AFU */
-#define MAX_FC_PORTS	CXLFLASH_MAX_FC_PORTS	/* ports per AFU */
+#define MAX_FC_PORTS	CXLFLASH_MAX_FC_PORTS	/* max ports per AFU */
+#define LEGACY_FC_PORTS	2			/* legacy ports per AFU */
+
+#define CHAN2PORTBANK(_x)	((_x) >> ilog2(CXLFLASH_NUM_FC_PORTS_PER_BANK))
+#define CHAN2BANKPORT(_x)	((_x) & (CXLFLASH_NUM_FC_PORTS_PER_BANK - 1))
 
 #define CHAN2PORTMASK(_x)	(1 << (_x))	/* channel to port mask */
 #define PORTMASK2CHAN(_x)	(ilog2((_x)))	/* port mask to channel */
@@ -67,7 +70,7 @@ extern const struct file_operations cxlflash_cxl_fops;
 
 static inline void check_sizes(void)
 {
-	BUILD_BUG_ON_NOT_POWER_OF_2(CXLFLASH_NUM_CMDS);
+	BUILD_BUG_ON_NOT_POWER_OF_2(CXLFLASH_NUM_FC_PORTS_PER_BANK);
 }
 
 /* AFU defines a fixed size of 4K for command buffers (borrow 4K page define) */
@@ -240,18 +243,26 @@ static inline u64 lun_to_lunid(u64 lun)
 	return be64_to_cpu(lun_id);
 }
 
-static inline __be64 __iomem *get_fc_port_regs(struct cxlflash_cfg *cfg, int i)
+static inline struct fc_port_bank __iomem *get_fc_port_bank(
+					    struct cxlflash_cfg *cfg, int i)
 {
 	struct afu *afu = cfg->afu;
 
-	return &afu->afu_map->global.fc_regs[i][0];
+	return &afu->afu_map->global.bank[CHAN2PORTBANK(i)];
+}
+
+static inline __be64 __iomem *get_fc_port_regs(struct cxlflash_cfg *cfg, int i)
+{
+	struct fc_port_bank __iomem *fcpb = get_fc_port_bank(cfg, i);
+
+	return &fcpb->fc_port_regs[CHAN2BANKPORT(i)][0];
 }
 
 static inline __be64 __iomem *get_fc_port_luns(struct cxlflash_cfg *cfg, int i)
 {
-	struct afu *afu = cfg->afu;
+	struct fc_port_bank __iomem *fcpb = get_fc_port_bank(cfg, i);
 
-	return &afu->afu_map->global.fc_port[i][0];
+	return &fcpb->fc_port_luns[CHAN2BANKPORT(i)][0];
 }
 
 int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index e198605..64ad76b 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1028,25 +1028,29 @@ static void afu_link_reset(struct afu *afu, int port, __be64 __iomem *fc_regs)
 
 /*
  * Asynchronous interrupt information table
+ *
+ * NOTE: The checkpatch script considers the BUILD_SISL_ASTATUS_FC_PORT macro
+ * as complex and complains because it is not wrapped with parentheses/braces.
  */
+#define ASTATUS_FC(_a, _b, _c, _d)					 \
+	{ SISL_ASTATUS_FC##_a##_##_b, _c, _a, (_d) }
+
+#define BUILD_SISL_ASTATUS_FC_PORT(_a)					 \
+	ASTATUS_FC(_a, OTHER, "other error", CLR_FC_ERROR | LINK_RESET), \
+	ASTATUS_FC(_a, LOGO, "target initiated LOGO", 0),		 \
+	ASTATUS_FC(_a, CRC_T, "CRC threshold exceeded", LINK_RESET),	 \
+	ASTATUS_FC(_a, LOGI_R, "login timed out, retrying", LINK_RESET), \
+	ASTATUS_FC(_a, LOGI_F, "login failed", CLR_FC_ERROR),		 \
+	ASTATUS_FC(_a, LOGI_S, "login succeeded", SCAN_HOST),		 \
+	ASTATUS_FC(_a, LINK_DN, "link down", 0),			 \
+	ASTATUS_FC(_a, LINK_UP, "link up", 0)
+
 static const struct asyc_intr_info ainfo[] = {
-	{SISL_ASTATUS_FC0_OTHER, "other error", 0, CLR_FC_ERROR | LINK_RESET},
-	{SISL_ASTATUS_FC0_LOGO, "target initiated LOGO", 0, 0},
-	{SISL_ASTATUS_FC0_CRC_T, "CRC threshold exceeded", 0, LINK_RESET},
-	{SISL_ASTATUS_FC0_LOGI_R, "login timed out, retrying", 0, LINK_RESET},
-	{SISL_ASTATUS_FC0_LOGI_F, "login failed", 0, CLR_FC_ERROR},
-	{SISL_ASTATUS_FC0_LOGI_S, "login succeeded", 0, SCAN_HOST},
-	{SISL_ASTATUS_FC0_LINK_DN, "link down", 0, 0},
-	{SISL_ASTATUS_FC0_LINK_UP, "link up", 0, 0},
-	{SISL_ASTATUS_FC1_OTHER, "other error", 1, CLR_FC_ERROR | LINK_RESET},
-	{SISL_ASTATUS_FC1_LOGO, "target initiated LOGO", 1, 0},
-	{SISL_ASTATUS_FC1_CRC_T, "CRC threshold exceeded", 1, LINK_RESET},
-	{SISL_ASTATUS_FC1_LOGI_R, "login timed out, retrying", 1, LINK_RESET},
-	{SISL_ASTATUS_FC1_LOGI_F, "login failed", 1, CLR_FC_ERROR},
-	{SISL_ASTATUS_FC1_LOGI_S, "login succeeded", 1, SCAN_HOST},
-	{SISL_ASTATUS_FC1_LINK_DN, "link down", 1, 0},
-	{SISL_ASTATUS_FC1_LINK_UP, "link up", 1, 0},
-	{0x0, "", 0, 0}		/* terminator */
+	BUILD_SISL_ASTATUS_FC_PORT(2),
+	BUILD_SISL_ASTATUS_FC_PORT(3),
+	BUILD_SISL_ASTATUS_FC_PORT(0),
+	BUILD_SISL_ASTATUS_FC_PORT(1),
+	{ 0x0, "", 0, 0 }
 };
 
 /**
@@ -1059,6 +1063,8 @@ static const struct asyc_intr_info *find_ainfo(u64 status)
 {
 	const struct asyc_intr_info *info;
 
+	BUILD_BUG_ON(ainfo[ARRAY_SIZE(ainfo) - 1].status != 0);
+
 	for (info = &ainfo[0]; info->status; info++)
 		if (info->status == status)
 			return info;
@@ -1747,6 +1753,39 @@ static int init_mc(struct cxlflash_cfg *cfg)
 }
 
 /**
+ * get_num_afu_ports() - determines and configures the number of AFU ports
+ * @cfg:	Internal structure associated with the host.
+ *
+ * This routine determines the number of AFU ports by converting the global
+ * port selection mask. The converted value is only valid following an AFU
+ * reset (explicit or power-on). This routine must be invoked shortly after
+ * mapping as other routines are dependent on the number of ports during the
+ * initialization sequence.
+ *
+ * To support legacy AFUs that might not have reflected an initial global
+ * port mask (value read is 0), default to the number of ports originally
+ * supported by the cxlflash driver (2) before hardware with other port
+ * offerings was introduced.
+ */
+static void get_num_afu_ports(struct cxlflash_cfg *cfg)
+{
+	struct afu *afu = cfg->afu;
+	struct device *dev = &cfg->dev->dev;
+	u64 port_mask;
+	int num_fc_ports = LEGACY_FC_PORTS;
+
+	port_mask = readq_be(&afu->afu_map->global.regs.afu_port_sel);
+	if (port_mask != 0ULL)
+		num_fc_ports = min(ilog2(port_mask) + 1, MAX_FC_PORTS);
+
+	dev_dbg(dev, "%s: port_mask=%016llx num_fc_ports=%d\n",
+		__func__, port_mask, num_fc_ports);
+
+	cfg->num_fc_ports = num_fc_ports;
+	cfg->host->max_channel = PORTNUM2CHAN(num_fc_ports);
+}
+
+/**
  * init_afu() - setup as master context and start AFU
  * @cfg:	Internal structure associated with the host.
  *
@@ -1803,6 +1842,8 @@ static int init_afu(struct cxlflash_cfg *cfg)
 	dev_dbg(dev, "%s: afu_ver=%s interface_ver=%016llx\n", __func__,
 		afu->version, afu->interface_version);
 
+	get_num_afu_ports(cfg);
+
 	rc = start_afu(cfg);
 	if (rc) {
 		dev_err(dev, "%s: start_afu failed, rc=%d\n", __func__, rc);
@@ -2534,7 +2575,6 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	host->max_id = CXLFLASH_MAX_NUM_TARGETS_PER_BUS;
 	host->max_lun = CXLFLASH_MAX_NUM_LUNS_PER_TARGET;
-	host->max_channel = PORTNUM2CHAN(NUM_FC_PORTS);
 	host->unique_id = host->host_no;
 	host->max_cmd_len = CXLFLASH_MAX_CDB_LEN;
 
@@ -2550,7 +2590,6 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	cfg->init_state = INIT_STATE_NONE;
 	cfg->dev = pdev;
-	cfg->num_fc_ports = NUM_FC_PORTS;
 	cfg->cxl_fops = cxlflash_cxl_fops;
 
 	/*
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index f26f41b..42d9c9e 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -292,28 +292,54 @@ struct sisl_ctrl_map {
 /* single copy global regs */
 struct sisl_global_regs {
 	__be64 aintr_status;
-	/* In cxlflash, each FC port/link gets a byte of status */
-#define SISL_ASTATUS_FC0_OTHER	 0x8000ULL /* b48, other err,
-					      FC_ERRCAP[31:20] */
-#define SISL_ASTATUS_FC0_LOGO    0x4000ULL /* b49, target sent FLOGI/PLOGI/LOGO
-						   while logged in */
-#define SISL_ASTATUS_FC0_CRC_T   0x2000ULL /* b50, CRC threshold exceeded */
-#define SISL_ASTATUS_FC0_LOGI_R  0x1000ULL /* b51, login state machine timed out
-						   and retrying */
-#define SISL_ASTATUS_FC0_LOGI_F  0x0800ULL /* b52, login failed,
-					      FC_ERROR[19:0] */
-#define SISL_ASTATUS_FC0_LOGI_S  0x0400ULL /* b53, login succeeded */
-#define SISL_ASTATUS_FC0_LINK_DN 0x0200ULL /* b54, link online to offline */
-#define SISL_ASTATUS_FC0_LINK_UP 0x0100ULL /* b55, link offline to online */
-
-#define SISL_ASTATUS_FC1_OTHER   0x0080ULL /* b56 */
-#define SISL_ASTATUS_FC1_LOGO    0x0040ULL /* b57 */
-#define SISL_ASTATUS_FC1_CRC_T   0x0020ULL /* b58 */
-#define SISL_ASTATUS_FC1_LOGI_R  0x0010ULL /* b59 */
-#define SISL_ASTATUS_FC1_LOGI_F  0x0008ULL /* b60 */
-#define SISL_ASTATUS_FC1_LOGI_S  0x0004ULL /* b61 */
-#define SISL_ASTATUS_FC1_LINK_DN 0x0002ULL /* b62 */
-#define SISL_ASTATUS_FC1_LINK_UP 0x0001ULL /* b63 */
+	/*
+	 * In cxlflash, FC port/link are arranged in port pairs, each
+	 * gets a byte of status:
+	 *
+	 *	*_OTHER:	other err, FC_ERRCAP[31:20]
+	 *	*_LOGO:		target sent FLOGI/PLOGI/LOGO while logged in
+	 *	*_CRC_T:	CRC threshold exceeded
+	 *	*_LOGI_R:	login state machine timed out and retrying
+	 *	*_LOGI_F:	login failed, FC_ERROR[19:0]
+	 *	*_LOGI_S:	login succeeded
+	 *	*_LINK_DN:	link online to offline
+	 *	*_LINK_UP:	link offline to online
+	 */
+#define SISL_ASTATUS_FC2_OTHER	 0x80000000ULL /* b32 */
+#define SISL_ASTATUS_FC2_LOGO    0x40000000ULL /* b33 */
+#define SISL_ASTATUS_FC2_CRC_T   0x20000000ULL /* b34 */
+#define SISL_ASTATUS_FC2_LOGI_R  0x10000000ULL /* b35 */
+#define SISL_ASTATUS_FC2_LOGI_F  0x08000000ULL /* b36 */
+#define SISL_ASTATUS_FC2_LOGI_S  0x04000000ULL /* b37 */
+#define SISL_ASTATUS_FC2_LINK_DN 0x02000000ULL /* b38 */
+#define SISL_ASTATUS_FC2_LINK_UP 0x01000000ULL /* b39 */
+
+#define SISL_ASTATUS_FC3_OTHER   0x00800000ULL /* b40 */
+#define SISL_ASTATUS_FC3_LOGO    0x00400000ULL /* b41 */
+#define SISL_ASTATUS_FC3_CRC_T   0x00200000ULL /* b42 */
+#define SISL_ASTATUS_FC3_LOGI_R  0x00100000ULL /* b43 */
+#define SISL_ASTATUS_FC3_LOGI_F  0x00080000ULL /* b44 */
+#define SISL_ASTATUS_FC3_LOGI_S  0x00040000ULL /* b45 */
+#define SISL_ASTATUS_FC3_LINK_DN 0x00020000ULL /* b46 */
+#define SISL_ASTATUS_FC3_LINK_UP 0x00010000ULL /* b47 */
+
+#define SISL_ASTATUS_FC0_OTHER	 0x00008000ULL /* b48 */
+#define SISL_ASTATUS_FC0_LOGO    0x00004000ULL /* b49 */
+#define SISL_ASTATUS_FC0_CRC_T   0x00002000ULL /* b50 */
+#define SISL_ASTATUS_FC0_LOGI_R  0x00001000ULL /* b51 */
+#define SISL_ASTATUS_FC0_LOGI_F  0x00000800ULL /* b52 */
+#define SISL_ASTATUS_FC0_LOGI_S  0x00000400ULL /* b53 */
+#define SISL_ASTATUS_FC0_LINK_DN 0x00000200ULL /* b54 */
+#define SISL_ASTATUS_FC0_LINK_UP 0x00000100ULL /* b55 */
+
+#define SISL_ASTATUS_FC1_OTHER   0x00000080ULL /* b56 */
+#define SISL_ASTATUS_FC1_LOGO    0x00000040ULL /* b57 */
+#define SISL_ASTATUS_FC1_CRC_T   0x00000020ULL /* b58 */
+#define SISL_ASTATUS_FC1_LOGI_R  0x00000010ULL /* b59 */
+#define SISL_ASTATUS_FC1_LOGI_F  0x00000008ULL /* b60 */
+#define SISL_ASTATUS_FC1_LOGI_S  0x00000004ULL /* b61 */
+#define SISL_ASTATUS_FC1_LINK_DN 0x00000002ULL /* b62 */
+#define SISL_ASTATUS_FC1_LINK_UP 0x00000001ULL /* b63 */
 
 #define SISL_FC_INTERNAL_UNMASK	0x0000000300000000ULL	/* 1 means unmasked */
 #define SISL_FC_INTERNAL_MASK	~(SISL_FC_INTERNAL_UNMASK)
@@ -325,7 +351,7 @@ struct sisl_global_regs {
 #define SISL_STATUS_SHUTDOWN_ACTIVE	0x0000000000000010ULL
 #define SISL_STATUS_SHUTDOWN_COMPLETE	0x0000000000000020ULL
 
-#define SISL_ASTATUS_UNMASK	0xFFFFULL		/* 1 means unmasked */
+#define SISL_ASTATUS_UNMASK	0xFFFFFFFFULL		/* 1 means unmasked */
 #define SISL_ASTATUS_MASK	~(SISL_ASTATUS_UNMASK)	/* 1 means masked */
 
 	__be64 aintr_clear;
@@ -367,10 +393,18 @@ struct sisl_global_regs {
 #define SISL_INTVER_CAP_RESERVED_CMD_MODE_B	0x100000000000ULL
 };
 
-#define CXLFLASH_MAX_FC_PORTS   2
-#define CXLFLASH_NUM_FC_PORTS   2
-#define CXLFLASH_MAX_CONTEXT  512	/* how many contexts per afu */
-#define CXLFLASH_NUM_VLUNS    512
+#define CXLFLASH_NUM_FC_PORTS_PER_BANK	2	/* fixed # of ports per bank */
+#define CXLFLASH_MAX_FC_BANKS		1	/* max # of banks supported */
+#define CXLFLASH_MAX_FC_PORTS	(CXLFLASH_NUM_FC_PORTS_PER_BANK *	\
+				 CXLFLASH_MAX_FC_BANKS)
+#define CXLFLASH_MAX_CONTEXT	512	/* number of contexts per AFU */
+#define CXLFLASH_NUM_VLUNS	512	/* number of vluns per AFU/port */
+#define CXLFLASH_NUM_REGS	512	/* number of registers per port */
+
+struct fc_port_bank {
+	__be64 fc_port_regs[CXLFLASH_NUM_FC_PORTS_PER_BANK][CXLFLASH_NUM_REGS];
+	__be64 fc_port_luns[CXLFLASH_NUM_FC_PORTS_PER_BANK][CXLFLASH_NUM_VLUNS];
+};
 
 struct sisl_global_map {
 	union {
@@ -380,11 +414,9 @@ struct sisl_global_map {
 
 	char page1[SIZE_4K];	/* page 1 */
 
-	/* pages 2 & 3 */
-	__be64 fc_regs[CXLFLASH_NUM_FC_PORTS][CXLFLASH_NUM_VLUNS];
+	struct fc_port_bank bank[CXLFLASH_MAX_FC_BANKS]; /* pages 2 - 5 */
 
-	/* pages 4 & 5 (lun tbl) */
-	__be64 fc_port[CXLFLASH_NUM_FC_PORTS][CXLFLASH_NUM_VLUNS];
+	/* pages 6 - 15 are reserved */
 
 };
 
@@ -479,6 +511,8 @@ struct sisl_rht_entry_f1 {
 
 #define PORT0  0x01U
 #define PORT1  0x02U
+#define PORT2  0x04U
+#define PORT3  0x08U
 #define PORT_MASK(_n)	((1 << (_n)) - 1)
 
 /* AFU Sync Mode byte */
-- 
2.1.0
