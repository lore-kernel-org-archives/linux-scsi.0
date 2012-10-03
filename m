From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 5/5]  arcmsr: Add the spinlock for queue buffer access
Date: Wed, 3 Oct 2012 20:39:01 +0800
Message-ID: <6DCABD06F49D4AA58CABCB5835F0A9C0@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44725 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2JCMij (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2012 08:38:39 -0400
Received: by padhz1 with SMTP id hz1so6289404pad.19
        for <linux-scsi@vger.kernel.org>; Wed, 03 Oct 2012 05:38:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org

From: Nick Cheng <nick.cheng@areca.com.tw>

Add the spinlock for queue buffer access
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---
diff -uprN -X linux-vanilla/Documentation/dontdiff
linux-vanilla//drivers/scsi/arcmsr/arcmsr.h
linux-development//drivers/scsi/arcmsr/arcmsr.h
--- linux-vanilla//drivers/scsi/arcmsr/arcmsr.h	2012-10-03
19:31:31.742620819 +0800
+++ linux-development//drivers/scsi/arcmsr/arcmsr.h	2012-10-03
19:31:04.098621088 +0800
@@ -617,6 +617,8 @@ struct AdapterControlBlock
 	spinlock_t                      			eh_lock;
 	spinlock_t
ccblist_lock;
 	spinlock_t				postq_lock;
+	spinlock_t				rqbuffer_lock;
+	spinlock_t				wqbuffer_lock;
 	union {
 		struct MessageUnit_A __iomem *pmuA;
 		struct MessageUnit_B 	*pmuB;
diff -uprN -X linux-vanilla/Documentation/dontdiff
linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c
linux-development//drivers/scsi/arcmsr/arcmsr_hba.c
--- linux-vanilla//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
19:31:31.754620820 +0800
+++ linux-development//drivers/scsi/arcmsr/arcmsr_hba.c	2012-10-03
19:31:04.118621087 +0800
@@ -987,6 +987,8 @@ static int arcmsr_probe(struct pci_dev *
 	spin_lock_init(&acb->eh_lock);
 	spin_lock_init(&acb->ccblist_lock);
 	spin_lock_init(&acb->postq_lock);
+	spin_lock_init(&acb->rqbuffer_lock);
+	spin_lock_init(&acb->wqbuffer_lock);
 	acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
 			ACB_F_MESSAGE_RQBUFFER_CLEARED |
 			ACB_F_MESSAGE_WQBUFFER_READED);
@@ -1927,10 +1929,12 @@ static struct QBUFFER __iomem *arcmsr_ge
 
 static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock
*acb)
 {
+	uint8_t __iomem *iop_data;
 	struct QBUFFER __iomem *prbuffer;
 	struct QBUFFER *pQbuffer;
-	uint8_t __iomem *iop_data;
 	int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;
+	unsigned long flags;
+	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
 	rqbuf_lastindex = acb->rqbuf_lastindex;
 	rqbuf_firstindex = acb->rqbuf_firstindex;
 	prbuffer = arcmsr_get_iop_rqbuffer(acb);
@@ -1952,10 +1956,13 @@ static void arcmsr_iop2drv_data_wrote_ha
 	} else {
 		acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
 	}
+	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
 }
 
 static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock
*acb)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
 	acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
 	if (acb->wqbuf_firstindex != acb->wqbuf_lastindex) {
 		uint8_t *pQbuffer;
@@ -1984,6 +1991,7 @@ static void arcmsr_iop2drv_data_read_han
 	if (acb->wqbuf_firstindex == acb->wqbuf_lastindex) {
 		acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;
 	}
+	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
 }
 
 static void arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)
@@ -2403,6 +2411,7 @@ static int arcmsr_iop_message_xfer(struc
 		unsigned char *ver_addr;
 		uint8_t *pQbuffer, *ptmpQbuffer;
 		int32_t allxfer_len = 0;
+		unsigned long flags;
 
 		ver_addr = kmalloc(1032, GFP_ATOMIC);
 		if (!ver_addr) {
@@ -2411,6 +2420,7 @@ static int arcmsr_iop_message_xfer(struc
 		}
 				
 		ptmpQbuffer = ver_addr;
+		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
 		while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
 			&& (allxfer_len < 1031)) {
 			pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
@@ -2439,6 +2449,7 @@ static int arcmsr_iop_message_xfer(struc
 			}
 			arcmsr_iop_message_read(acb);
 		}
+		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
 		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr,
allxfer_len);
 		pcmdmessagefld->cmdmessage.Length = allxfer_len;
 		if(acb->fw_flag == FW_DEADLOCK) {
@@ -2452,8 +2463,9 @@ static int arcmsr_iop_message_xfer(struc
 
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
 		unsigned char *ver_addr;
-		int32_t my_empty_len, user_len, wqbuf_firstindex,
wqbuf_lastindex;
 		uint8_t *pQbuffer, *ptmpuserbuffer;
+		int32_t my_empty_len, user_len, wqbuf_firstindex,
wqbuf_lastindex;
+		unsigned long flags;
 
 		ver_addr = kmalloc(1032, GFP_ATOMIC);
 		if (!ver_addr) {
@@ -2470,6 +2482,7 @@ static int arcmsr_iop_message_xfer(struc
 		ptmpuserbuffer = ver_addr;
 		user_len = pcmdmessagefld->cmdmessage.Length;
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer,
user_len);
+		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
 		wqbuf_lastindex = acb->wqbuf_lastindex;
 		wqbuf_firstindex = acb->wqbuf_firstindex;
 		if (wqbuf_lastindex != wqbuf_firstindex) {
@@ -2513,7 +2526,8 @@ static int arcmsr_iop_message_xfer(struc
 				retvalue = ARCMSR_MESSAGE_FAIL;
 			}
 			}
-			kfree(ver_addr);
+		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
+		kfree(ver_addr);
 		}
 		break;


