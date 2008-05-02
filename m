From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] u14-34f: Fix 32bit only problem
Date: Fri, 2 May 2008 14:21:50 +0100
Message-ID: <20080502142150.01c66d70@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50602 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761833AbYEBN3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 09:29:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, linux-scsi@vger.kernel.org

Another user of 32bit time

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/scsi/u14-34f.c linux-2.6.25-mm1/drivers/scsi/u14-34f.c
--- linux.vanilla-2.6.25-mm1/drivers/scsi/u14-34f.c	2008-04-28 11:36:50.000000000 +0100
+++ linux-2.6.25-mm1/drivers/scsi/u14-34f.c	2008-05-02 14:07:05.000000000 +0100
@@ -745,7 +745,8 @@
 static int board_inquiry(unsigned int j) {
    struct mscp *cpp;
    dma_addr_t id_dma_addr;
-   unsigned int time, limit = 0;
+   unsigned int limit = 0;
+   unsigned long time;
 
    id_dma_addr = pci_map_single(HD(j)->pdev, HD(j)->board_id,
                     sizeof(HD(j)->board_id), PCI_DMA_BIDIRECTIONAL);
@@ -1393,7 +1394,8 @@
 }
 
 static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
-   unsigned int i, j, time, k, c, limit = 0;
+   unsigned int i, j, k, c, limit = 0;
+   unsigned long time;
    int arg_done = FALSE;
    struct scsi_cmnd *SCpnt;
 
