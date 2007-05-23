From: akpm@linux-foundation.org
Subject: [patch 1/1] scsi: cover up bugs^W^W^WFix up compiler warnings in megaraid driver
Date: Wed, 23 May 2007 16:11:46 -0700
Message-ID: <200705232311.l4NNBlfZ007264@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755952AbXEWXLx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 19:11:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, mbligh@google.com

From: Martin Bligh <mbligh@google.com>

Fix up compiler warnings in megaraid driver

Signed-off-by: Martin J. Bligh <mbligh@google.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver
+++ a/drivers/scsi/megaraid.c
@@ -3571,7 +3571,7 @@ megadev_ioctl(struct inode *inode, struc
 			/*
 			 * The user passthru structure
 			 */
-			upthru = (mega_passthru __user *)MBOX(uioc)->xferaddr;
+			upthru = (mega_passthru __user *)(unsigned long)MBOX(uioc)->xferaddr;
 
 			/*
 			 * Copy in the user passthru here.
@@ -3623,7 +3623,7 @@ megadev_ioctl(struct inode *inode, struc
 				/*
 				 * Get the user data
 				 */
-				if( copy_from_user(data, (char __user *)uxferaddr,
+				if( copy_from_user(data, (char __user *)(unsigned long) uxferaddr,
 							pthru->dataxferlen) ) {
 					rval = (-EFAULT);
 					goto freemem_and_return;
@@ -3649,7 +3649,7 @@ megadev_ioctl(struct inode *inode, struc
 			 * Is data going up-stream
 			 */
 			if( pthru->dataxferlen && (uioc.flags & UIOC_RD) ) {
-				if( copy_to_user((char __user *)uxferaddr, data,
+				if( copy_to_user((char __user *)(unsigned long) uxferaddr, data,
 							pthru->dataxferlen) ) {
 					rval = (-EFAULT);
 				}
@@ -3702,7 +3702,7 @@ freemem_and_return:
 				/*
 				 * Get the user data
 				 */
-				if( copy_from_user(data, (char __user *)uxferaddr,
+				if( copy_from_user(data, (char __user *)(unsigned long) uxferaddr,
 							uioc.xferlen) ) {
 
 					pci_free_consistent(pdev,
@@ -3742,7 +3742,7 @@ freemem_and_return:
 			 * Is data going up-stream
 			 */
 			if( uioc.xferlen && (uioc.flags & UIOC_RD) ) {
-				if( copy_to_user((char __user *)uxferaddr, data,
+				if( copy_to_user((char __user *)(unsigned long) uxferaddr, data,
 							uioc.xferlen) ) {
 
 					rval = (-EFAULT);
_
