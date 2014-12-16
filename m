From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH 2/2] ahci_xgene: Fix the dma state machine lockup for the ATA_CMD_PACKET PIO mode command.
Date: Tue, 16 Dec 2014 22:19:35 +0530
Message-ID: <1418748575-27301-3-git-send-email-stripathi@apm.com>
References: <1418748575-27301-1-git-send-email-stripathi@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418748575-27301-1-git-send-email-stripathi-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch addresses the issue with ATA_CMD_PACKET pio mode
command for enumeration and device detection with ATAPI devices.It is the
same issue as in patch

www.spinics.net/lists/linux-ide/msg49092.html

Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
 drivers/ata/ahci_xgene.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 0ffd3c9..9730907 100644
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
+ * Due to Hardware errata for IDENTIFY DEVICE command and COMMAND PACKET
+ * command of ATAPI protocol set, the controller cannot clear the BSY bit
+ * after receiving the PIO setup FIS. This results in the dma state machine
+ * goes into the CMFatalErrorUpdate state and locks up. By restarting the
+ * dma engine, it removes the controller out of lock up state.
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
