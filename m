From: Daniel Drake <dsd@gentoo.org>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs   disabled
 - dmesg filled with warnings
Date: Sat, 16 Feb 2008 23:37:41 +0000
Message-ID: <47B773C5.2000905@gentoo.org>
References: <47ADC74B.9080009@control.aau.dk>	 <1202580076.4254.24.camel@localhost.localdomain>	 <20080209193518.GC11299@hoblitt.com>	 <1202586219.4254.35.camel@localhost.localdomain>	 <20080212205345.GB7640@hoblitt.com> <20080212222109.GC7640@hoblitt.com>	 <1202855436.3137.153.camel@localhost.localdomain>	 <20080215205657.GB23625@hoblitt.com>	 <1203112643.3058.48.camel@localhost.localdomain>	 <1203113047.3058.50.camel@localhost.localdomain>	 <47B6CDDB.8000605@gentoo.org> <1203173535.3182.11.camel@localhost.localdomain> <47B7738C.9050107@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010204070307060606070403"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:60961 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYBPXfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2008 18:35:55 -0500
In-Reply-To: <47B7738C.9050107@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Joshua Hoblitt <josh@hoblitt.com>, Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, j_gentoo@hoblitt.com, nick.cheng@areca.com.tw

This is a multi-part message in MIME format.
--------------010204070307060606070403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Daniel Drake wrote:
> Here is a patch to address your comments.
> Joshua, would you mind testing this before I submit it properly? It will 
> apply cleanly to 2.6.24 on top of the previous patch you tested. I have 
> compile-tested it.

It would help to include the patch.

--------------010204070307060606070403
Content-Type: text/plain;
 name="0001-arcmsr-fix-message-allocation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-arcmsr-fix-message-allocation.patch"

>From 0a9cd6133fe4f0c3a8906d6be1b9d1ef083345dc Mon Sep 17 00:00:00 2001
From: Daniel Drake <dsd@gentoo.org>
Date: Sat, 16 Feb 2008 23:25:02 +0000
Subject: [PATCH] arcmsr: fix message allocation

---
 drivers/scsi/arcmsr/arcmsr_hba.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4f9ff32..f91f79c 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1387,18 +1387,16 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 	switch(controlcode) {
 
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {
-		unsigned long *ver_addr;
+		unsigned char *ver_addr;
 		uint8_t *pQbuffer, *ptmpQbuffer;
 		int32_t allxfer_len = 0;
-		void *tmp;
 
-		tmp = kmalloc(1032, GFP_KERNEL|GFP_DMA);
-		ver_addr = (unsigned long *)tmp;
-		if (!tmp) {
+		ver_addr = kmalloc(1032, GFP_ATOMIC);
+		if (!ver_addr) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
-		ptmpQbuffer = (uint8_t *) ver_addr;
+		ptmpQbuffer = ver_addr;
 		while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
 			&& (allxfer_len < 1031)) {
 			pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
@@ -1427,26 +1425,24 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 			}
 			arcmsr_iop_message_read(acb);
 		}
-		memcpy(pcmdmessagefld->messagedatabuffer, (uint8_t *)ver_addr, allxfer_len);
+		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);
 		pcmdmessagefld->cmdmessage.Length = allxfer_len;
 		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
-		kfree(tmp);
+		kfree(ver_addr);
 		}
 		break;
 
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
-		unsigned long *ver_addr;
+		unsigned char *ver_addr;
 		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
 		uint8_t *pQbuffer, *ptmpuserbuffer;
-		void *tmp;
 
-		tmp = kmalloc(1032, GFP_KERNEL|GFP_DMA);
-		ver_addr = (unsigned long *)tmp;
-		if (!tmp) {
+		ver_addr = kmalloc(1032, GFP_ATOMIC);
+		if (!ver_addr) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
-		ptmpuserbuffer = (uint8_t *)ver_addr;
+		ptmpuserbuffer = ver_addr;
 		user_len = pcmdmessagefld->cmdmessage.Length;
 		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);
 		wqbuf_lastindex = acb->wqbuf_lastindex;
@@ -1492,7 +1488,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 				retvalue = ARCMSR_MESSAGE_FAIL;
 			}
 			}
-			kfree(tmp);
+			kfree(ver_addr);
 		}
 		break;
 
-- 
1.5.4


--------------010204070307060606070403--
