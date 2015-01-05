From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH 2/2] ahci_xgene: Implement the workaround to support PMP enumeration and discovery for APM X-Gene SoC AHCI SATA Host Controller driver.
Date: Mon,  5 Jan 2015 15:51:45 +0530
Message-ID: <1420453305-15986-3-git-send-email-stripathi@apm.com>
References: <1420453305-15986-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1420453305-15986-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Due to H/W errata, the controller is unable to save the PMP
field fetched from command header before sending the H2D FIS.
When the device returns the PMP port field in the D2H FIS, there is
a mismatch and results in command completion failure. The workaround
is to write the pmp value to PxFBS.DEV field before issuing any command
to PMP.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 124 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 2180223..a194ddd 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -85,6 +85,7 @@ struct xgene_ahci_context {
 	struct ahci_host_priv *hpriv;
 	struct device *dev;
 	u8 last_cmd[MAX_AHCI_CHN_PERCTR]; /* tracking the last command issued*/
+	u32 class[MAX_AHCI_CHN_PERCTR]; /* tracking the class of device */
 	void __iomem *csr_core;		/* Core CSR address of IP */
 	void __iomem *csr_diag;		/* Diag CSR address of IP */
 	void __iomem *csr_axi;		/* AXI CSR address of IP */
@@ -181,6 +182,13 @@ static int xgene_ahci_restart_engine(struct ata_port *ap)
  * clear the BSY bit after receiving the PIO setup FIS. This results in the dma
  * state machine goes into the CMFatalErrorUpdate state and locks up. By
  * restarting the dma engine, it removes the controller out of lock up state.
+ *
+ * Due to H/W errata, the controller is unable to save the PMP
+ * field fetched from command header before sending the H2D FIS.
+ * When the device returns the PMP port field in the D2H FIS, there is
+ * a mismatch and results in command completion failure. The
+ * workaround is to write the pmp value to PxFBS.DEV field before issuing
+ * any command to PMP.
  */
 static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
 {
@@ -188,6 +196,19 @@ static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct xgene_ahci_context *ctx = hpriv->plat_data;
 	int rc = 0;
+	u32 port_fbs;
+	void *port_mmio = ahci_port_base(ap);
+
+	/*
+	 * Write the pmp value to PxFBS.DEV
+	 * for case of Port Mulitplier.
+	 */
+	if (ctx->class[ap->port_no] == ATA_DEV_PMP) {
+		port_fbs = readl(port_mmio + PORT_FBS);
+		port_fbs &= ~PORT_FBS_DEV_MASK;
+		port_fbs |= qc->dev->link->pmp << PORT_FBS_DEV_OFFSET;
+		writel(port_fbs, port_mmio + PORT_FBS);
+	}

 	if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA))
 		xgene_ahci_restart_engine(ap);
@@ -415,12 +436,115 @@ static void xgene_ahci_host_stop(struct ata_host *host)
 	ahci_platform_disable_resources(hpriv);
 }

+/**
+ * xgene_ahci_pmp_softreset - Issue the softreset to the drives connected
+ *                            to Port Multiplier.
+ * @link: link to reset
+ * @class: Return value to indicate class of device
+ * @deadline: deadline jiffies for the operation
+ *
+ * Due to H/W errata, the controller is unable to save the PMP
+ * field fetched from command header before sending the H2D FIS.
+ * When the device returns the PMP port field in the D2H FIS, there is
+ * a mismatch and results in command completion failure. The workaround
+ * is to write the pmp value to PxFBS.DEV field before issuing any command
+ * to PMP.
+ */
+static int xgene_ahci_pmp_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline)
+{
+	int pmp = sata_srst_pmp(link);
+	struct ata_port *ap = link->ap;
+	u32 rc;
+	void *port_mmio = ahci_port_base(ap);
+	u32 port_fbs;
+
+	/*
+	 * Set PxFBS.DEV field with pmp
+	 * value.
+	 */
+	port_fbs = readl(port_mmio + PORT_FBS);
+	port_fbs &= ~PORT_FBS_DEV_MASK;
+	port_fbs |= pmp << PORT_FBS_DEV_OFFSET;
+	writel(port_fbs, port_mmio + PORT_FBS);
+
+	rc = ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
+
+	return rc;
+}
+
+/**
+ * xgene_ahci_softreset - Issue the softreset to the drive.
+ * @link: link to reset
+ * @class: Return value to indicate class of device
+ * @deadline: deadline jiffies for the operation
+ *
+ * Due to H/W errata, the controller is unable to save the PMP
+ * field fetched from command header before sending the H2D FIS.
+ * When the device returns the PMP port field in the D2H FIS, there is
+ * a mismatch and results in command completion failure. The workaround
+ * is to write the pmp value to PxFBS.DEV field before issuing any command
+ * to PMP. Here is the algorithm to detect PMP :
+ *
+ * 1. Save the PxFBS value
+ * 2. Program PxFBS.DEV with pmp value send by framework. Framework sends
+ *    0xF for both PMP/NON-PMP initially
+ * 3. Issue softreset
+ * 4. If signature class is PMP goto 6
+ * 5. restore the original PxFBS and goto 3
+ * 6. return
+ */
+static int xgene_ahci_softreset(struct ata_link *link, unsigned int *class,
+			  unsigned long deadline)
+{
+	int pmp = sata_srst_pmp(link);
+	struct ata_port *ap = link->ap;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct xgene_ahci_context *ctx = hpriv->plat_data;
+	void *port_mmio = ahci_port_base(ap);
+	u32 port_fbs;
+	u32 port_fbs_save;
+	u32 retry = 1;
+	u32 rc;
+
+	port_fbs_save = readl(port_mmio + PORT_FBS);
+
+	/*
+	 * Set PxFBS.DEV field with pmp
+	 * value.
+	 */
+	port_fbs = readl(port_mmio + PORT_FBS);
+	port_fbs &= ~PORT_FBS_DEV_MASK;
+	port_fbs |= pmp << PORT_FBS_DEV_OFFSET;
+	writel(port_fbs, port_mmio + PORT_FBS);
+
+softreset_retry:
+	rc = ahci_do_softreset(link, class, pmp,
+			       deadline, ahci_check_ready);
+
+	ctx->class[ap->port_no] = *class;
+	if (*class != ATA_DEV_PMP) {
+		/*
+		 * Retry for normal drives without
+		 * setting PxFBS.DEV field with pmp value.
+		 */
+		if (retry--) {
+			writel(port_fbs_save, port_mmio + PORT_FBS);
+			goto softreset_retry;
+		}
+	}
+
+	return rc;
+}
+
 static struct ata_port_operations xgene_ahci_ops = {
 	.inherits = &ahci_ops,
 	.host_stop = xgene_ahci_host_stop,
 	.hardreset = xgene_ahci_hardreset,
 	.read_id = xgene_ahci_read_id,
 	.qc_issue = xgene_ahci_qc_issue,
+	.softreset = xgene_ahci_softreset,
+	.pmp_softreset = xgene_ahci_pmp_softreset
 };

 static const struct ata_port_info xgene_ahci_port_info = {
--
1.8.2.1

