From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 3/4] cciss 2.4: adds 2 ioctls for ia64 based systems
Date: Mon, 15 Aug 2005 16:22:24 -0500
Message-ID: <20050815212224.GD12760@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel11.hp.com ([156.153.255.246]:17876 "EHLO palrel11.hp.com")
	by vger.kernel.org with ESMTP id S964973AbVHOVWq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 17:22:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Patch 3/4
This patch adds 2 ioctls required for IPF systems. Without this change
parted may fail. This causes some vendor installs to fail.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

 cciss.c |    5 +++++
 1 files changed, 5 insertions(+)
--------------------------------------------------------------------------------
diff -burNp lx2431-p002/drivers/block/cciss.c lx2431/drivers/block/cciss.c
--- lx2431-p002/drivers/block/cciss.c	2005-08-15 15:13:15.484004000 -0500
+++ lx2431/drivers/block/cciss.c	2005-08-15 15:18:32.863755640 -0500
@@ -748,7 +748,12 @@ static int cciss_ioctl(struct inode *ino
 	case BLKELVGET:
 	case BLKELVSET:
 	case BLKSSZGET:
+#ifdef CONFIG_IA64
+        case BLKGETLASTSECT:
+        case BLKSETLASTSECT:
+#endif
 		return blk_ioctl(inode->i_rdev, cmd, arg);
+
 	case CCISS_GETPCIINFO:
 	{
 		cciss_pci_info_struct pciinfo;
