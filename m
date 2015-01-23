From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 08/17] ibmvscsi: Fix bidi command test
Date: Fri, 23 Jan 2015 13:10:23 +0100
Message-ID: <54C23A2F.1090005@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0081.outbound.protection.outlook.com ([207.46.100.81]:38086
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752249AbbAWMK2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:10:28 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Nathan Fontenot <nfont@linux.vnet.ibm.com>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index acea5d6..cf26b33 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -765,16 +765,18 @@ static int map_data_for_srp_cmd(struct scsi_cmnd *cmd,
 				struct srp_event_struct *evt_struct,
 				struct srp_cmd *srp_cmd, struct device *dev)
 {
+	if (scsi_bidi_cmnd(cmd)) {
+		sdev_printk(KERN_ERR, cmd->device,
+			    "Bidirectional commands are not yet supported\n");
+		return 0;
+	}
+
 	switch (cmd->sc_data_direction) {
 	case DMA_FROM_DEVICE:
 	case DMA_TO_DEVICE:
 		break;
 	case DMA_NONE:
 		return 1;
-	case DMA_BIDIRECTIONAL:
-		sdev_printk(KERN_ERR, cmd->device,
-			    "Can't map DMA_BIDIRECTIONAL to read/write\n");
-		return 0;
 	default:
 		sdev_printk(KERN_ERR, cmd->device,
 			    "Unknown data direction 0x%02x; can't map!\n",
-- 
2.1.2

