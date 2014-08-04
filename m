From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v1.3 8/18] arcmsr: remove calling
 arcmsr_hbb_enable_driver_mode
Date: Mon, 04 Aug 2014 17:23:39 +0800
Message-ID: <1407144219.4756.62.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34393 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaHDJXs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2014 05:23:48 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so9751797pab.1
        for <linux-scsi@vger.kernel.org>; Mon, 04 Aug 2014 02:23:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Remove calling arcmsr_hbb_enable_driver_mode by in-line code.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-04 16:43:06.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-04 16:44:44.000000000 +0800
@@ -875,17 +875,6 @@ static uint8_t arcmsr_abort_allcmd(struc
 	return rtnval;
 }
 
-static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)
-{
-	struct MessageUnit_B *reg = pacb->pmuB;
-	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
-	if (!arcmsr_hbb_wait_msgint_ready(pacb)) {
-		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", pacb->host->host_no);
-		return false;
-	}
-    	return true;
-}
-
 static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
 {
 	struct scsi_cmnd *pcmd = ccb->pcmd;
@@ -2683,7 +2672,12 @@ static int arcmsr_iop_confirm(struct Ada
 			timeout \n",acb->host->host_no);
 			return 1;
 		}
-		arcmsr_hbb_enable_driver_mode(acb);
+		writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
+		if (!arcmsr_hbb_wait_msgint_ready(acb)) {
+			pr_err("arcmsr%d: can't set driver mode.\n",
+				acb->host->host_no);
+			return 1;
+		}
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {



