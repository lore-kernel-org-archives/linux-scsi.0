From: Daniel Drake <dsd@gentoo.org>
Subject: Re: arcmsr + archttp64 calls dma_free_coherent() with irqs  disabled
 - dmesg filled with warnings
Date: Wed, 13 Feb 2008 12:55:03 +0000
Message-ID: <47B2E8A7.2030200@gentoo.org>
References: <47ADC74B.9080009@control.aau.dk> <1202580076.4254.24.camel@localhost.localdomain> <20080209193518.GC11299@hoblitt.com> <1202586219.4254.35.camel@localhost.localdomain> <20080212205345.GB7640@hoblitt.com> <20080212222109.GC7640@hoblitt.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040609070508010707080904"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from probity.mcc.ac.uk ([130.88.200.94]:61874 "EHLO
	probity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbYBMMxq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 07:53:46 -0500
In-Reply-To: <20080212222109.GC7640@hoblitt.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joshua Hoblitt <josh@hoblitt.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kim H?jgaard-Hansen <kimhh@control.aau.dk>, erich@areca.com.tw, linux-scsi@vger.kernel.org, j_gentoo@hoblitt.com

This is a multi-part message in MIME format.
--------------040609070508010707080904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Joshua Hoblitt wrote:
> I've got a few compilation errors on head.  Before I try it, is it
> possible to backport the 76d78300a6eb8b7f08e47703b7e68a659ffc2053 change
> to 2.6.24.y?

Please just try this patch instead, it's what I am planning to submit to 
-stable and add to Gentoo if you report success.

Daniel


--------------040609070508010707080904
Content-Type: text/plain;
 name="arcmsr-pci-alloc-consistent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arcmsr-pci-alloc-consistent.patch"

From: Nick Cheng <nick.cheng@areca.com.tw>

Partial backport of 76d78300 ("arcmsr: updates (1.20.00.15)") by
Daniel Drake <dsd@gentoo.org>. Removes pci_alloc_consistent usage, which
should not be used when IRQs are disabled for portability reasons. Fixes a
spew of dma_alloc_coherent irqs_disabled() warnings.

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f4a202e..4f9ff32 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1380,12 +1388,13 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {
 		unsigned long *ver_addr;
-		dma_addr_t buf_handle;
 		uint8_t *pQbuffer, *ptmpQbuffer;
 		int32_t allxfer_len = 0;
+		void *tmp;
 
-		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
-		if (!ver_addr) {
+		tmp = kmalloc(1032, GFP_KERNEL|GFP_DMA);
+		ver_addr = (unsigned long *)tmp;
+		if (!tmp) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
@@ -1421,18 +1430,19 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 		memcpy(pcmdmessagefld->messagedatabuffer, (uint8_t *)ver_addr, allxfer_len);
 		pcmdmessagefld->cmdmessage.Length = allxfer_len;
 		pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
-		pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
+		kfree(tmp);
 		}
 		break;
 
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
 		unsigned long *ver_addr;
-		dma_addr_t buf_handle;
 		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
 		uint8_t *pQbuffer, *ptmpuserbuffer;
+		void *tmp;
 
-		ver_addr = pci_alloc_consistent(acb->pdev, 1032, &buf_handle);
-		if (!ver_addr) {
+		tmp = kmalloc(1032, GFP_KERNEL|GFP_DMA);
+		ver_addr = (unsigned long *)tmp;
+		if (!tmp) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
@@ -1482,7 +1492,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 				retvalue = ARCMSR_MESSAGE_FAIL;
 			}
 			}
-			pci_free_consistent(acb->pdev, 1032, ver_addr, buf_handle);
+			kfree(tmp);
 		}
 		break;
 

--------------040609070508010707080904--
