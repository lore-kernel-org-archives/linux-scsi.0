From: domen@coderock.org
Subject: [patch 1/2] drivers/scsi/: Use of time_after macro
Date: Thu, 14 Jul 2005 23:43:21 +0200
Message-ID: <20050714214321.199608000@homer>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:2977 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S263150AbVGNVnn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 17:43:43 -0400
Content-Disposition: inline; filename=time_after-drivers_scsi_
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, Marcelo Feitoza Parisi <marcelo@feitoza.com.br>, domen@coderock.org

From: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>



Use of the time_after() macro, defined at linux/jiffies.h, which deal
with wrapping correctly and are nicer to read.

Signed-off-by: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>
Signed-off-by: Domen Puncer <domen@coderock.org>

---
 BusLogic.c  |    4 +++-
 osst.c      |    5 +++--
 ppa.c       |    3 ++-
 qlogicpti.c |    4 +++-
 4 files changed, 11 insertions(+), 5 deletions(-)

Index: quilt/drivers/scsi/BusLogic.c
===================================================================
--- quilt.orig/drivers/scsi/BusLogic.c
+++ quilt/drivers/scsi/BusLogic.c
@@ -42,6 +42,7 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
+#include <linux/jiffies.h>
 #include <scsi/scsicam.h>
 
 #include <asm/dma.h>
@@ -2896,7 +2897,8 @@ static int BusLogic_QueueCommand(struct 
 		 */
 		if (HostAdapter->ActiveCommands[TargetID] == 0)
 			HostAdapter->LastSequencePoint[TargetID] = jiffies;
-		else if (jiffies - HostAdapter->LastSequencePoint[TargetID] > 4 * HZ) {
+		else if (time_after(jiffies,
+			 HostAdapter->LastSequencePoint[TargetID] + 4 * HZ)) {
 			HostAdapter->LastSequencePoint[TargetID] = jiffies;
 			QueueTag = BusLogic_OrderedQueueTag;
 		}
Index: quilt/drivers/scsi/osst.c
===================================================================
--- quilt.orig/drivers/scsi/osst.c
+++ quilt/drivers/scsi/osst.c
@@ -50,6 +50,7 @@ static const char * osst_version = "0.99
 #include <linux/moduleparam.h>
 #include <linux/devfs_fs_kernel.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
 #include <asm/system.h>
@@ -803,7 +804,7 @@ static int osst_wait_frame(struct osst_t
 		    ) && result >= 0)
 		{
 #if DEBUG			
-			if (debugging || jiffies - startwait >= 2*HZ/OSST_POLL_PER_SEC)
+			if (debugging || time_after_eq(jiffies, startwait + 2*HZ/OSST_POLL_PER_SEC))
 				printk (OSST_DEB_MSG
 					"%s:D: Succ wait f fr %i (>%i): %i-%i %i (%i): %3li.%li s\n",
 					name, curr, curr+minlast, STp->first_frame_position,
@@ -814,7 +815,7 @@ static int osst_wait_frame(struct osst_t
 			return 0;
 		}
 #if DEBUG
-		if (jiffies - startwait >= 2*HZ/OSST_POLL_PER_SEC && notyetprinted)
+		if (time_after_eq(jiffies, startwait + 2*HZ/OSST_POLL_PER_SEC) && notyetprinted)
 		{
 			printk (OSST_DEB_MSG "%s:D: Wait for frame %i (>%i): %i-%i %i (%i)\n",
 				name, curr, curr+minlast, STp->first_frame_position,
Index: quilt/drivers/scsi/ppa.c
===================================================================
--- quilt.orig/drivers/scsi/ppa.c
+++ quilt/drivers/scsi/ppa.c
@@ -18,6 +18,7 @@
 #include <linux/parport.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>
+#include <linux/jiffies.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
@@ -726,7 +727,7 @@ static int ppa_engine(ppa_struct *dev, s
 				retv--;
 
 			if (retv) {
-				if ((jiffies - dev->jstart) > (1 * HZ)) {
+				if (time_after(jiffies, dev->jstart + 1 * HZ)) {
 					printk
 					    ("ppa: Parallel port cable is unplugged!!\n");
 					ppa_fail(dev, DID_BUS_BUSY);
Index: quilt/drivers/scsi/qlogicpti.c
===================================================================
--- quilt.orig/drivers/scsi/qlogicpti.c
+++ quilt/drivers/scsi/qlogicpti.c
@@ -24,6 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/jiffies.h>
 
 #include <asm/byteorder.h>
 
@@ -1017,7 +1018,8 @@ static inline void cmd_frob(struct Comma
 	if (Cmnd->device->tagged_supported) {
 		if (qpti->cmd_count[Cmnd->device->id] == 0)
 			qpti->tag_ages[Cmnd->device->id] = jiffies;
-		if ((jiffies - qpti->tag_ages[Cmnd->device->id]) > (5*HZ)) {
+		if (time_after(jiffies,
+				qpti->tag_ages[Cmnd->device->id] + 5*HZ)) {
 			cmd->control_flags = CFLAG_ORDERED_TAG;
 			qpti->tag_ages[Cmnd->device->id] = jiffies;
 		} else

--
