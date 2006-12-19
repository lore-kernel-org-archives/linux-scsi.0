From: akpm@osdl.org
Subject: [patch 26/26] scsi: cover up bugs^W^W^WFix up compiler warnings in megaraid driver
Date: Tue, 19 Dec 2006 13:15:00 -0800
Message-ID: <200612192115.kBJLF1qa010772@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36125 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbWLSVPL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 16:15:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, mbligh@google.com

From: Martin Bligh <mbligh@google.com>

Fix up compiler warnings in megaraid driver

[akpm@osdl.org: build fix]
Signed-off-by: Martin J. Bligh <mbligh@google.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver
+++ a/drivers/scsi/megaraid.c
@@ -73,10 +73,14 @@ static unsigned short int max_mbox_busy_
 module_param(max_mbox_busy_wait, ushort, 0);
 MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in microseconds if busy (default=MBOX_BUSY_WAIT=10)");
 
-#define RDINDOOR(adapter)	readl((adapter)->mmio_base + 0x20)
-#define RDOUTDOOR(adapter)	readl((adapter)->mmio_base + 0x2C)
-#define WRINDOOR(adapter,value)	 writel(value, (adapter)->mmio_base + 0x20)
-#define WROUTDOOR(adapter,value) writel(value, (adapter)->mmio_base + 0x2C)
+#define RDINDOOR(adapter)		readl((volatile void __iomem *) \
+							(adapter)->base + 0x20)
+#define RDOUTDOOR(adapter)		readl((volatile void __iomem *) \
+							(adapter)->base + 0x2C)
+#define WRINDOOR(adapter,value)		writel(value, (volatile void __iomem *)\
+							(adapter)->base + 0x20)
+#define WROUTDOOR(adapter,value)	writel(value, (volatile void __iomem *)\
+							(adapter)->base + 0x2C)
 
 /*
  * Global variables
@@ -3571,7 +3575,7 @@ megadev_ioctl(struct inode *inode, struc
 			/*
 			 * The user passthru structure
 			 */
-			upthru = (mega_passthru __user *)MBOX(uioc)->xferaddr;
+			upthru = (mega_passthru __user *)(unsigned long)MBOX(uioc)->xferaddr;
 
 			/*
 			 * Copy in the user passthru here.
@@ -3623,7 +3627,7 @@ megadev_ioctl(struct inode *inode, struc
 				/*
 				 * Get the user data
 				 */
-				if( copy_from_user(data, (char __user *)uxferaddr,
+				if( copy_from_user(data, (char __user *)(unsigned long) uxferaddr,
 							pthru->dataxferlen) ) {
 					rval = (-EFAULT);
 					goto freemem_and_return;
@@ -3649,7 +3653,7 @@ megadev_ioctl(struct inode *inode, struc
 			 * Is data going up-stream
 			 */
 			if( pthru->dataxferlen && (uioc.flags & UIOC_RD) ) {
-				if( copy_to_user((char __user *)uxferaddr, data,
+				if( copy_to_user((char __user *)(unsigned long) uxferaddr, data,
 							pthru->dataxferlen) ) {
 					rval = (-EFAULT);
 				}
@@ -3702,7 +3706,7 @@ freemem_and_return:
 				/*
 				 * Get the user data
 				 */
-				if( copy_from_user(data, (char __user *)uxferaddr,
+				if( copy_from_user(data, (char __user *)(unsigned long) uxferaddr,
 							uioc.xferlen) ) {
 
 					pci_free_consistent(pdev,
@@ -3742,7 +3746,7 @@ freemem_and_return:
 			 * Is data going up-stream
 			 */
 			if( uioc.xferlen && (uioc.flags & UIOC_RD) ) {
-				if( copy_to_user((char __user *)uxferaddr, data,
+				if( copy_to_user((char __user *)(unsigned long) uxferaddr, data,
 							uioc.xferlen) ) {
 
 					rval = (-EFAULT);
_
