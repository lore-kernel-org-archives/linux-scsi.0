From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] megaraid: outb_p extermination
Date: Fri, 8 Feb 2008 15:34:24 +0000
Message-ID: <20080208153424.29683d17@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33110 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756822AbYBHPkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 10:40:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, akpm@osdl.org

>From conversations with the maintainers the _p isn't needed so kill it.
That removes the last non ISA _p user from the SCSI layer to my knowledge.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/scsi/megaraid.c linux-2.6.24-mm1/drivers/scsi/megaraid.c
--- linux.vanilla-2.6.24-mm1/drivers/scsi/megaraid.c	2008-02-06 14:14:41.000000000 +0000
+++ linux-2.6.24-mm1/drivers/scsi/megaraid.c	2008-02-06 14:35:38.000000000 +0000
@@ -151,19 +151,19 @@
 	 */
 	if( adapter->flag & BOARD_IOMAP ) {
 
-		outb_p(adapter->mbox_dma & 0xFF,
+		outb(adapter->mbox_dma & 0xFF,
 				adapter->host->io_port + MBOX_PORT0);
 
-		outb_p((adapter->mbox_dma >> 8) & 0xFF,
+		outb((adapter->mbox_dma >> 8) & 0xFF,
 				adapter->host->io_port + MBOX_PORT1);
 
-		outb_p((adapter->mbox_dma >> 16) & 0xFF,
+		outb((adapter->mbox_dma >> 16) & 0xFF,
 				adapter->host->io_port + MBOX_PORT2);
 
-		outb_p((adapter->mbox_dma >> 24) & 0xFF,
+		outb((adapter->mbox_dma >> 24) & 0xFF,
 				adapter->host->io_port + MBOX_PORT3);
 
-		outb_p(ENABLE_MBOX_BYTE,
+		outb(ENABLE_MBOX_BYTE,
 				adapter->host->io_port + ENABLE_MBOX_REGION);
 
 		irq_ack(adapter);
