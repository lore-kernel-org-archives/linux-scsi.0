From: Andi Kleen <ak@muc.de>
Subject: Re: [BK PATCH] essential SCSI fixes for 2.6.5-rc2
Date: Sat, 20 Mar 2004 13:33:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3u10jr93e.fsf@averell.firstfloor.org>
References: <1079793048.1778.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:50695 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S262575AbUCTOsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Mar 2004 09:48:12 -0500
In-Reply-To: <1079793048.1778.6.camel@mulgrave> (James Bottomley's message
 of "20 Mar 2004 09:30:46 -0500")
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@steeleye.com> writes:

> These are the two oops related fixes from the scsi-misc-2.6 tree that
> testing has shaken out.  They are available at
>
> bk://linux-scsi.bkbits.net/scsi-for-linus-2.6
>
> The shortlog is:
>

[...]

Any chance you could include the fusion consistent mask patch with this? 

Without this fusion is completely unusable with >4GB on 64bit.

-Andi

diff -burpN -X ../KDIFX -x '*-SLAB' linux-vanilla-2.6.5rc2/drivers/message/fusion/mptbase.c linux-2.6.5rc2-amd64/drivers/message/fusion/mptbase.c
--- linux-vanilla-2.6.5rc2/drivers/message/fusion/mptbase.c	2004-03-20 03:55:31.000000000 +0100
+++ linux-2.6.5rc2-amd64/drivers/message/fusion/mptbase.c	2004-03-20 04:11:24.000000000 +0100
@@ -1280,12 +1280,17 @@ mptbase_probe(struct pci_dev *pdev, cons
 		return r;
 	}
 
+#if 0
+	/* broken because some code assumes that multiple calls
+	   to pci_alloc_consistent return data in the same 4GB segment. 
+	   This cannot work on machines with enough memory. */
 	if (!pci_set_consistent_dma_mask(pdev, mask))
 		dprintk((KERN_INFO MYNAM
 			": Using 64 bit consistent mask\n"));
 	else
 		dprintk((KERN_INFO MYNAM
 			": Not using 64 bit consistent mask\n"));
+#endif
 
 	ioc = kmalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {

