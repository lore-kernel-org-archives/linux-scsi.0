From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [patch 1/1] scsi: cover up bugs^W^W^WFix up compiler warnings in megaraid driver
Date: Fri, 25 May 2007 14:28:19 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229AE1465@NAMAIL2.ad.lsil.com>
References: <200705232311.l4NNBlfZ007264@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38080 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbXEYU2o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 May 2007 16:28:44 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200705232311.l4NNBlfZ007264@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, mbligh@google.com


Ack.

--Sumant

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
akpm@linux-foundation.org
Sent: Wednesday, May 23, 2007 4:12 PM
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org;
mbligh@google.com
Subject: [patch 1/1] scsi: cover up bugs^W^W^WFix up compiler warnings
in megaraid driver

From: Martin Bligh <mbligh@google.com>

Fix up compiler warnings in megaraid driver

Signed-off-by: Martin J. Bligh <mbligh@google.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN
drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in-m
egaraid-driver drivers/scsi/megaraid.c
---
a/drivers/scsi/megaraid.c~scsi-cover-up-bugs-fix-up-compiler-warnings-in
-megaraid-driver
+++ a/drivers/scsi/megaraid.c
@@ -3571,7 +3571,7 @@ megadev_ioctl(struct inode *inode, struc
 			/*
 			 * The user passthru structure
 			 */
-			upthru = (mega_passthru __user
*)MBOX(uioc)->xferaddr;
+			upthru = (mega_passthru __user *)(unsigned
long)MBOX(uioc)->xferaddr;
 
 			/*
 			 * Copy in the user passthru here.
@@ -3623,7 +3623,7 @@ megadev_ioctl(struct inode *inode, struc
 				/*
 				 * Get the user data
 				 */
-				if( copy_from_user(data, (char __user
*)uxferaddr,
+				if( copy_from_user(data, (char __user
*)(unsigned long) uxferaddr,
 
pthru->dataxferlen) ) {
 					rval = (-EFAULT);
 					goto freemem_and_return;
@@ -3649,7 +3649,7 @@ megadev_ioctl(struct inode *inode, struc
 			 * Is data going up-stream
 			 */
 			if( pthru->dataxferlen && (uioc.flags & UIOC_RD)
) {
-				if( copy_to_user((char __user
*)uxferaddr, data,
+				if( copy_to_user((char __user
*)(unsigned long) uxferaddr, data,
 
pthru->dataxferlen) ) {
 					rval = (-EFAULT);
 				}
@@ -3702,7 +3702,7 @@ freemem_and_return:
 				/*
 				 * Get the user data
 				 */
-				if( copy_from_user(data, (char __user
*)uxferaddr,
+				if( copy_from_user(data, (char __user
*)(unsigned long) uxferaddr,
 							uioc.xferlen) )
{
 
 					pci_free_consistent(pdev,
@@ -3742,7 +3742,7 @@ freemem_and_return:
 			 * Is data going up-stream
 			 */
 			if( uioc.xferlen && (uioc.flags & UIOC_RD) ) {
-				if( copy_to_user((char __user
*)uxferaddr, data,
+				if( copy_to_user((char __user
*)(unsigned long) uxferaddr, data,
 							uioc.xferlen) )
{
 
 					rval = (-EFAULT);
_
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
