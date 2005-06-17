From: mike.miller@hp.com
Subject: [PATCH] cciss 2.6: pci domain info
Date: Fri, 17 Jun 2005 13:31:24 -0500
Message-ID: <20050617183124.GA9913@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:13493 "EHLO
	ccerelbas02.cce.hp.com") by vger.kernel.org with ESMTP
	id S262070AbVFQTav (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2005 15:30:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch adds pci domain info to our CCISS_GETPCIINFO ioctl. This is to support the next generation of Itanium platforms. We had a couple of spare bytes in the structure. Impact to existing apps should be minimal. Please consider this patch for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

 drivers/block/cciss.c       |    1 +
 include/linux/cciss_ioctl.h |    1 +
 2 files changed, 2 insertions(+)
--------------------------------------------------------------------------------
diff -burNp lx2612-rc6.orig/drivers/block/cciss.c lx2612-rc6/drivers/block/cciss.c
--- lx2612-rc6.orig/drivers/block/cciss.c	2005-06-14 12:04:34.000000000 -0500
+++ lx2612-rc6/drivers/block/cciss.c	2005-06-17 13:04:52.384575144 -0500
@@ -636,6 +636,7 @@ static int cciss_ioctl(struct inode *ino
 		cciss_pci_info_struct pciinfo;
 
 		if (!arg) return -EINVAL;
+		pciinfo.domain = pci_domain_nr(host->pdev->bus);
 		pciinfo.bus = host->pdev->bus->number;
 		pciinfo.dev_fn = host->pdev->devfn;
 		pciinfo.board_id = host->board_id;
diff -burNp lx2612-rc6.orig/include/linux/cciss_ioctl.h lx2612-rc6/include/linux/cciss_ioctl.h
--- lx2612-rc6.orig/include/linux/cciss_ioctl.h	2005-03-02 01:38:07.000000000 -0600
+++ lx2612-rc6/include/linux/cciss_ioctl.h	2005-06-17 13:06:42.082898464 -0500
@@ -9,6 +9,7 @@
 
 typedef struct _cciss_pci_info_struct
 {
+	unsigned int	domain;
 	unsigned char 	bus;
 	unsigned char 	dev_fn;
 	__u32 		board_id;
