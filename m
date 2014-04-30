From: ching <ching2048@areca.com.tw>
Subject: [PATCH v1.0 8/16] arcmsr: Replace calling
 arcmsr_hbb_enable_driver_mode
Date: Wed, 30 Apr 2014 19:08:18 +0800
Message-ID: <1398856098.6930.31.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:37356 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbaD3LIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2014 07:08:25 -0400
Received: by mail-ve0-f177.google.com with SMTP id sa20so1892156veb.36
        for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2014 04:08:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

From: Ching<ching2048@areca.com.tw>

Replacing call arcmsr_hbb_enable_driver_mode by in-line code.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:10:46.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:11:32.000000000 +0800
@@ -906,17 +906,6 @@ static uint8_t arcmsr_abort_allcmd(struc
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
@@ -2729,7 +2718,12 @@ static int arcmsr_iop_confirm(struct Ada
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


