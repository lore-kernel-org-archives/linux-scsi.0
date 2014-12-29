From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v3 2/2] ahci_xgene: Fix the DMA state machine lockup for the ATA_CMD_PACKET PIO mode command.
Date: Mon, 29 Dec 2014 08:52:47 +0530
Message-ID: <1419823367-11279-3-git-send-email-stripathi@apm.com>
References: <1419823367-11279-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1419823367-11279-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch addresses the issue with ATA_CMD_PACKET pio mode
command for enumeration and device detection with ATAPI devices.
The X-Gene AHCI controller has an errata in which it cannot clear
the BSY bit after the PIO setup FIS. The dma state machine enters
CMFatalErrorUpdate state and locks up.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 0ffd3c9..d332161 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -125,10 +125,11 @@ static int xgene_ahci_restart_engine(struct ata_port *ap)
  * xgene_ahci_qc_issue - Issue commands to the device
  * @qc: Command to issue
  *
- * Due to Hardware errata for IDENTIFY DEVICE command, the controller cannot
- * clear the BSY bit after receiving the PIO setup FIS. This results in the dma
- * state machine goes into the CMFatalErrorUpdate state and locks up. By
- * restarting the dma engine, it removes the controller out of lock up state.
+ * Due to Hardware errata for IDENTIFY DEVICE command and PACKET
+ * command of ATAPI protocol set, the controller cannot clear the BSY bit
+ * after receiving the PIO setup FIS. This results in the DMA state machine
+ * going into the CMFatalErrorUpdate state and locks up. By restarting the
+ * DMA engine, it removes the controller out of lock up state.
  */
 static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
 {
@@ -137,7 +138,8 @@ static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
 	struct xgene_ahci_context *ctx = hpriv->plat_data;
 	int rc = 0;

-	if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA))
+	if (unlikely((ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA) ||
+	    (ctx->last_cmd[ap->port_no] == ATA_CMD_PACKET)))
 		xgene_ahci_restart_engine(ap);

 	rc = ahci_qc_issue(qc);
--
1.8.2.1

