From: Andi Kleen <ak@muc.de>
Subject: [PATCH] IOMMU overflow handling fix for MPT fusion
Date: Sun, 10 Aug 2003 16:13:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030810141316.GA13529@averell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:19463 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S269575AbTHJONm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2003 10:13:42 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: Pam.Delaney@lsil.com


Currently mpt fusion does not handle IOMMU overflow (pci_map_sg returning 0) 
very gracefully. It gets not reported to the upper layers. This patch fixes this.

As a related note the fusion driver tends to trigger the NMI watchdog as soon
as it goes into any error recovery, because it busy waits for seconds with
interrupts disabled (seems to be still true with the new error handling in 2.6).
This is a big inconvenient because it leads to a forced oops. 

I tried to work around it by exporting touch_nmi_watchdog and using it in
the delays, but Linus was opposed to this approach. It would be nice
if someone could fix this. Afaik in 2.6 the error recovery should mostly
run in process context, so it should be possible to use schedule_timeout()
with interrupts on for the delays. 

At least on x86-64 the NMI watchdog runs by default and even on i386 it is a
very useful debugging tool.

-Andi

diff -burpN -X ../KDIFX linux/drivers/message/fusion/mptscsih.c linux-2.6.0test3-amd64/drivers/message/fusion/mptscsih.c
--- linux/drivers/message/fusion/mptscsih.c	2003-07-28 23:12:23.000000000 +0200
+++ linux-2.6.0test3-amd64/drivers/message/fusion/mptscsih.c	2003-08-03 12:15:10.000000000 +0200
@@ -475,6 +476,8 @@ mptscsih_AddSGE(MPT_SCSI_HOST *hd, Scsi_
 			       (struct scatterlist *) SCpnt->request_buffer,
 			       SCpnt->use_sg,
 			       scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+		if (sges_left == 0) 
+			return FAILED;
 	} else if (SCpnt->request_bufflen) {
 		dma_addr_t	 buf_dma_addr;
 		scPrivate	*my_priv;

 
