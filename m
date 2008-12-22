From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: BUG: bad: [58e2a02eb18393e76a469580fedf7caec190eb5e] [SCSI]
 eata: convert to use the data buffer accessors
Date: Mon, 22 Dec 2008 11:09:17 +0900
Message-ID: <20081222110935D.fujita.tomonori@lab.ntt.co.jp>
References: <494E69F0.3060300@internode.on.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:55886 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYLVCJ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Dec 2008 21:09:27 -0500
In-Reply-To: <494E69F0.3060300@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arthur.marsh@internode.on.net
Cc: linux-scsi@vger.kernel.org, ballabio_dario@emc.com

On Mon, 22 Dec 2008 02:38:16 +1030
Arthur Marsh <arthur.marsh@internode.on.net> wrote:

> I've recently installed Debian on a PII-266 machine with DPT2044W SCSI 
> controller.
> 
> Kernels 2.6.18-2.6.22 work fine, and kernels 2.6.23-2.6.27 lock up after 
> loading the eata module using modprobe, with the error:
> 
> modprobe exited with preempt_count 1
> 
> I've run a git bisection and have a few more passes to go, but suspect 
> the commit in the subject line,
> 
> [58e2a02eb18393e76a469580fedf7caec190eb5e] [SCSI] eata: convert to use 
> the data buffer accessors
> 
> to be the patch which triggers the problem.
> 
> I'm not a C programmer, let alone a kernel programmer, but can build and 
> check any suggested patches.
> 
> Is anyone successfully using the eata module since the data buffer 
> accessors patch?
> 
> Is anyone able to examine the code to see if anything was done wrong in 
> the data buffer accessors patch?

Sorry about the problem. Can you try this patch?


diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index a73a6bb..976cdd5 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1626,8 +1626,15 @@ static void map_dma(unsigned int i, struct hostdata *ha)
 
 	cpp->sense_len = SCSI_SENSE_BUFFERSIZE;
 
-	count = scsi_dma_map(SCpnt);
-	BUG_ON(count < 0);
+	if (!scsi_sg_count(SCpnt)) {
+		cpp->data_len = 0;
+		return;
+	}
+
+	count = pci_map_sg(ha->pdev, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
+			   pci_dir);
+	BUG_ON(!count);
+
 	scsi_for_each_sg(SCpnt, sg, count, k) {
 		cpp->sglist[k].address = H2DEV(sg_dma_address(sg));
 		cpp->sglist[k].num_bytes = H2DEV(sg_dma_len(sg));
@@ -1655,7 +1662,9 @@ static void unmap_dma(unsigned int i, struct hostdata *ha)
 		pci_unmap_single(ha->pdev, DEV2H(cpp->sense_addr),
 				 DEV2H(cpp->sense_len), PCI_DMA_FROMDEVICE);
 
-	scsi_dma_unmap(SCpnt);
+	if (scsi_sg_count(SCpnt))
+		pci_unmap_sg(ha->pdev, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
+			     pci_dir);
 
 	if (!DEV2H(cpp->data_len))
 		pci_dir = PCI_DMA_BIDIRECTIONAL;
