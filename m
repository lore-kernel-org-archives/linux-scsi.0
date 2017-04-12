From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 06/17] cxlflash: Remove port configuration assumptions
Date: Wed, 12 Apr 2017 14:14:05 -0500
Message-ID: <1492024445-55845-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34457 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752643AbdDLTOY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:14:24 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ98B0020163
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:14:24 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29srxsukce-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:14:23 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 15:14:22 -0400
In-Reply-To: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

At present, the cxlflash driver only supports hardware with two FC
ports. The code was initially designed with this assumption and is
dependent on having two FC ports - adding more ports will break logic
within the driver.

To mitigate this issue, remove the existing port assumptions and
transition the code to support more than two ports. As a side effect,
clarify the interpretation of the DK_CXLFLASH_ALL_PORTS_ACTIVE flag.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 Documentation/powerpc/cxlflash.txt |  5 +++
 drivers/scsi/cxlflash/common.h     |  4 ++
 drivers/scsi/cxlflash/lunmgt.c     |  4 +-
 drivers/scsi/cxlflash/main.c       | 13 +++---
 drivers/scsi/cxlflash/sislite.h    |  2 +-
 drivers/scsi/cxlflash/superpipe.c  |  2 +-
 drivers/scsi/cxlflash/superpipe.h  |  3 --
 drivers/scsi/cxlflash/vlun.c       | 89 +++++++++++++++++++++++++-------------
 8 files changed, 77 insertions(+), 45 deletions(-)

diff --git a/Documentation/powerpc/cxlflash.txt b/Documentation/powerpc/cxlflash.txt
index 6d9a2ed..66b4496 100644
--- a/Documentation/powerpc/cxlflash.txt
+++ b/Documentation/powerpc/cxlflash.txt
@@ -239,6 +239,11 @@ DK_CXLFLASH_USER_VIRTUAL
     resource handle that is provided is already referencing provisioned
     storage. This is reflected by the last LBA being a non-zero value.
 
+    When a LUN is accessible from more than one port, this ioctl will
+    return with the DK_CXLFLASH_ALL_PORTS_ACTIVE return flag set. This
+    provides the user with a hint that I/O can be retried in the event
+    of an I/O error as the LUN can be reached over multiple paths.
+
 DK_CXLFLASH_VLUN_RESIZE
 -----------------------
     This ioctl is responsible for resizing a previously created virtual
diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index 6a04867..ee23e81 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -29,6 +29,10 @@ extern const struct file_operations cxlflash_cxl_fops;
 #define NUM_FC_PORTS	CXLFLASH_NUM_FC_PORTS	/* ports per AFU */
 #define MAX_FC_PORTS	CXLFLASH_MAX_FC_PORTS	/* ports per AFU */
 
+#define CHAN2PORTMASK(_x)	(1 << (_x))	/* channel to port mask */
+#define PORTMASK2CHAN(_x)	(ilog2((_x)))	/* port mask to channel */
+#define PORTNUM2CHAN(_x)	((_x) - 1)	/* port number to channel */
+
 #define CXLFLASH_BLOCK_SIZE	4096	/* 4K blocks */
 #define CXLFLASH_MAX_XFER_SIZE	16777216	/* 16MB transfer */
 #define CXLFLASH_MAX_SECTORS	(CXLFLASH_MAX_XFER_SIZE/512)	/* SCSI wants
diff --git a/drivers/scsi/cxlflash/lunmgt.c b/drivers/scsi/cxlflash/lunmgt.c
index 0efed17..4d232e2 100644
--- a/drivers/scsi/cxlflash/lunmgt.c
+++ b/drivers/scsi/cxlflash/lunmgt.c
@@ -252,7 +252,7 @@ int cxlflash_manage_lun(struct scsi_device *sdev,
 		 * in unpacked, AFU-friendly format, and hang LUN reference in
 		 * the sdev.
 		 */
-		lli->port_sel |= CHAN2PORT(chan);
+		lli->port_sel |= CHAN2PORTMASK(chan);
 		lli->lun_id[chan] = lun_to_lunid(sdev->lun);
 		sdev->hostdata = lli;
 	} else if (flags & DK_CXLFLASH_MANAGE_LUN_DISABLE_SUPERPIPE) {
@@ -264,7 +264,7 @@ int cxlflash_manage_lun(struct scsi_device *sdev,
 			 * tracking when no more references exist.
 			 */
 			sdev->hostdata = NULL;
-			lli->port_sel &= ~CHAN2PORT(chan);
+			lli->port_sel &= ~CHAN2PORTMASK(chan);
 			if (lli->port_sel == 0U)
 				lli->in_table = false;
 		}
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 3f9c869..04e1a8e 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -365,7 +365,6 @@ static int wait_resp(struct afu *afu, struct afu_cmd *cmd)
  */
 static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 {
-	u32 port_sel = scp->device->channel + 1;
 	struct cxlflash_cfg *cfg = shost_priv(scp->device->host);
 	struct afu_cmd *cmd = sc_to_afucz(scp);
 	struct device *dev = &cfg->dev->dev;
@@ -388,7 +387,7 @@ static int send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
 
 	cmd->rcb.ctx_id = afu->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
-	cmd->rcb.port_sel = port_sel;
+	cmd->rcb.port_sel = CHAN2PORTMASK(scp->device->channel);
 	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
 	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
 			      SISL_REQ_FLAGS_SUP_UNDERRUN |
@@ -444,7 +443,6 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 	struct device *dev = &cfg->dev->dev;
 	struct afu_cmd *cmd = sc_to_afucz(scp);
 	struct scatterlist *sg = scsi_sglist(scp);
-	u32 port_sel = scp->device->channel + 1;
 	u16 req_flags = SISL_REQ_FLAGS_SUP_UNDERRUN;
 	ulong lock_flags;
 	int nseg = 0;
@@ -503,7 +501,7 @@ static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
 
 	cmd->rcb.ctx_id = afu->ctx_hndl;
 	cmd->rcb.msi = SISL_MSI_RRQ_UPDATED;
-	cmd->rcb.port_sel = port_sel;
+	cmd->rcb.port_sel = CHAN2PORTMASK(scp->device->channel);
 	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
 
 	if (scp->sc_data_direction == DMA_TO_DEVICE)
@@ -1558,7 +1556,8 @@ static int init_global(struct cxlflash_cfg *cfg)
 		writeq_be(PORT0, &afu->afu_map->global.regs.afu_port_sel);
 		num_ports = 0;
 	} else {
-		writeq_be(BOTH_PORTS, &afu->afu_map->global.regs.afu_port_sel);
+		writeq_be(PORT_MASK(cfg->num_fc_ports),
+			  &afu->afu_map->global.regs.afu_port_sel);
 		num_ports = cfg->num_fc_ports;
 	}
 
@@ -2190,7 +2189,7 @@ static ssize_t lun_mode_store(struct device *dev,
 		if (afu->internal_lun)
 			shost->max_channel = 0;
 		else
-			shost->max_channel = cfg->num_fc_ports - 1;
+			shost->max_channel = PORTNUM2CHAN(cfg->num_fc_ports);
 
 		afu_reset(cfg);
 		scsi_scan_host(cfg->host);
@@ -2529,7 +2528,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	host->max_id = CXLFLASH_MAX_NUM_TARGETS_PER_BUS;
 	host->max_lun = CXLFLASH_MAX_NUM_LUNS_PER_TARGET;
-	host->max_channel = NUM_FC_PORTS - 1;
+	host->max_channel = PORTNUM2CHAN(NUM_FC_PORTS);
 	host->unique_id = host->host_no;
 	host->max_cmd_len = CXLFLASH_MAX_CDB_LEN;
 
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
index 0db4bc1..f26f41b 100644
--- a/drivers/scsi/cxlflash/sislite.h
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -479,7 +479,7 @@ struct sisl_rht_entry_f1 {
 
 #define PORT0  0x01U
 #define PORT1  0x02U
-#define BOTH_PORTS    (PORT0 | PORT1)
+#define PORT_MASK(_n)	((1 << (_n)) - 1)
 
 /* AFU Sync Mode byte */
 #define AFU_LW_SYNC 0x0U
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 90869ce..488330f 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1935,7 +1935,7 @@ static int cxlflash_disk_direct_open(struct scsi_device *sdev, void *arg)
 	u64 lun_size = 0;
 	u64 last_lba = 0;
 	u64 rsrc_handle = -1;
-	u32 port = CHAN2PORT(sdev->channel);
+	u32 port = CHAN2PORTMASK(sdev->channel);
 
 	int rc = 0;
 
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 690ce9c..8269ff8 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -33,9 +33,6 @@ extern struct cxlflash_global global;
 
 #define MAX_SECTOR_UNIT  512 /* max_sector is in 512 byte multiples */
 
-#define CHAN2PORT(_x)	((_x) + 1)
-#define PORT2CHAN(_x)	((_x) - 1)
-
 enum lun_mode {
 	MODE_NONE = 0,
 	MODE_VIRTUAL,
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 8fcc804..547c8ff 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -819,8 +819,8 @@ int cxlflash_vlun_resize(struct scsi_device *sdev,
 void cxlflash_restore_luntable(struct cxlflash_cfg *cfg)
 {
 	struct llun_info *lli, *temp;
-	u32 chan;
 	u32 lind;
+	int k;
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
 	struct sisl_global_map __iomem *agm = &afu->afu_map->global;
@@ -832,33 +832,41 @@ void cxlflash_restore_luntable(struct cxlflash_cfg *cfg)
 			continue;
 
 		lind = lli->lun_index;
+		dev_dbg(dev, "%s: Virtual LUNs on slot %d:\n", __func__, lind);
 
-		if (lli->port_sel == BOTH_PORTS) {
-			writeq_be(lli->lun_id[0], &agm->fc_port[0][lind]);
-			writeq_be(lli->lun_id[1], &agm->fc_port[1][lind]);
-			dev_dbg(dev, "%s: Virtual LUN on slot %d  id0=%llx "
-				"id1=%llx\n", __func__, lind,
-				lli->lun_id[0], lli->lun_id[1]);
-		} else {
-			chan = PORT2CHAN(lli->port_sel);
-			writeq_be(lli->lun_id[chan], &agm->fc_port[chan][lind]);
-			dev_dbg(dev, "%s: Virtual LUN on slot %d chan=%d "
-				"id=%llx\n", __func__, lind, chan,
-				lli->lun_id[chan]);
-		}
+		for (k = 0; k < cfg->num_fc_ports; k++)
+			if (lli->port_sel & (1 << k)) {
+				writeq_be(lli->lun_id[k],
+					  &agm->fc_port[k][lind]);
+				dev_dbg(dev, "\t%d=%llx\n", k, lli->lun_id[k]);
+			}
 	}
 
 	mutex_unlock(&global.mutex);
 }
 
 /**
+ * get_num_ports() - compute number of ports from port selection mask
+ * @psm:	Port selection mask.
+ *
+ * Return: Population count of port selection mask
+ */
+static inline u8 get_num_ports(u32 psm)
+{
+	static const u8 bits[16] = { 0, 1, 1, 2, 1, 2, 2, 3,
+				     1, 2, 2, 3, 2, 3, 3, 4 };
+
+	return bits[psm & 0xf];
+}
+
+/**
  * init_luntable() - write an entry in the LUN table
  * @cfg:	Internal structure associated with the host.
  * @lli:	Per adapter LUN information structure.
  *
- * On successful return, a LUN table entry is created.
- * At the top for LUNs visible on both ports.
- * At the bottom for LUNs visible only on one port.
+ * On successful return, a LUN table entry is created:
+ *	- at the top for LUNs visible on multiple ports.
+ *	- at the bottom for LUNs visible only on one port.
  *
  * Return: 0 on success, -errno on failure
  */
@@ -866,7 +874,9 @@ static int init_luntable(struct cxlflash_cfg *cfg, struct llun_info *lli)
 {
 	u32 chan;
 	u32 lind;
+	u32 nports;
 	int rc = 0;
+	int k;
 	struct afu *afu = cfg->afu;
 	struct device *dev = &cfg->dev->dev;
 	struct sisl_global_map __iomem *agm = &afu->afu_map->global;
@@ -876,29 +886,46 @@ static int init_luntable(struct cxlflash_cfg *cfg, struct llun_info *lli)
 	if (lli->in_table)
 		goto out;
 
-	if (lli->port_sel == BOTH_PORTS) {
+	nports = get_num_ports(lli->port_sel);
+	if (nports == 0 || nports > cfg->num_fc_ports) {
+		WARN(1, "Unsupported port configuration nports=%u", nports);
+		rc = -EIO;
+		goto out;
+	}
+
+	if (nports > 1) {
 		/*
-		 * If this LUN is visible from both ports, we will put
+		 * When LUN is visible from multiple ports, we will put
 		 * it in the top half of the LUN table.
 		 */
-		if ((cfg->promote_lun_index == cfg->last_lun_index[0]) ||
-		    (cfg->promote_lun_index == cfg->last_lun_index[1])) {
-			rc = -ENOSPC;
-			goto out;
+		for (k = 0; k < cfg->num_fc_ports; k++) {
+			if (!(lli->port_sel & (1 << k)))
+				continue;
+
+			if (cfg->promote_lun_index == cfg->last_lun_index[k]) {
+				rc = -ENOSPC;
+				goto out;
+			}
 		}
 
 		lind = lli->lun_index = cfg->promote_lun_index;
-		writeq_be(lli->lun_id[0], &agm->fc_port[0][lind]);
-		writeq_be(lli->lun_id[1], &agm->fc_port[1][lind]);
+		dev_dbg(dev, "%s: Virtual LUNs on slot %d:\n", __func__, lind);
+
+		for (k = 0; k < cfg->num_fc_ports; k++) {
+			if (!(lli->port_sel & (1 << k)))
+				continue;
+
+			writeq_be(lli->lun_id[k], &agm->fc_port[k][lind]);
+			dev_dbg(dev, "\t%d=%llx\n", k, lli->lun_id[k]);
+		}
+
 		cfg->promote_lun_index++;
-		dev_dbg(dev, "%s: Virtual LUN on slot %d  id0=%llx id1=%llx\n",
-			__func__, lind, lli->lun_id[0], lli->lun_id[1]);
 	} else {
 		/*
-		 * If this LUN is visible only from one port, we will put
+		 * When LUN is visible only from one port, we will put
 		 * it in the bottom half of the LUN table.
 		 */
-		chan = PORT2CHAN(lli->port_sel);
+		chan = PORTMASK2CHAN(lli->port_sel);
 		if (cfg->promote_lun_index == cfg->last_lun_index[chan]) {
 			rc = -ENOSPC;
 			goto out;
@@ -907,7 +934,7 @@ static int init_luntable(struct cxlflash_cfg *cfg, struct llun_info *lli)
 		lind = lli->lun_index = cfg->last_lun_index[chan];
 		writeq_be(lli->lun_id[chan], &agm->fc_port[chan][lind]);
 		cfg->last_lun_index[chan]--;
-		dev_dbg(dev, "%s: Virtual LUN on slot %d  chan=%d id=%llx\n",
+		dev_dbg(dev, "%s: Virtual LUNs on slot %d:\n\t%d=%llx\n",
 			__func__, lind, chan, lli->lun_id[chan]);
 	}
 
@@ -1016,7 +1043,7 @@ int cxlflash_disk_virtual_open(struct scsi_device *sdev, void *arg)
 	virt->last_lba = last_lba;
 	virt->rsrc_handle = rsrc_handle;
 
-	if (lli->port_sel == BOTH_PORTS)
+	if (get_num_ports(lli->port_sel) > 1)
 		virt->hdr.return_flags |= DK_CXLFLASH_ALL_PORTS_ACTIVE;
 out:
 	if (likely(ctxi))
-- 
2.1.0
