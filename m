From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] drivers/scsi/*: use time_after() and friends
Date: Thu, 13 Oct 2005 02:54:39 +0400
Message-ID: <20051012225439.GB7873@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.197]:27152 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932444AbVJLWm6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 18:42:58 -0400
Received: by wproxy.gmail.com with SMTP id 57so57804wri
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2005 15:42:57 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <james.bottomley@steeleye.com>
Cc: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>, linux-scsi@vger.kernel.org

From: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>

They deal with wrapping correctly and are nicer to read.

Signed-off-by: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/BusLogic.c  |    4 +++-
 drivers/scsi/osst.c      |    5 +++--
 drivers/scsi/ppa.c       |    3 ++-
 drivers/scsi/qlogicfc.c  |    3 ++-
 drivers/scsi/qlogicpti.c |    4 +++-
 5 files changed, 13 insertions(+), 6 deletions(-)

diff -uprN linux-vanilla/drivers/scsi/BusLogic.c linux-1/drivers/scsi/BusLogic.c
--- linux-vanilla/drivers/scsi/BusLogic.c	2005-10-12 18:58:22.000000000 +0400
+++ linux-1/drivers/scsi/BusLogic.c	2005-10-13 02:49:18.000000000 +0400
@@ -41,6 +41,7 @@
 #include <linux/stat.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/jiffies.h>
 #include <scsi/scsicam.h>
 
 #include <asm/dma.h>
@@ -2895,7 +2896,8 @@ static int BusLogic_QueueCommand(struct 
 		 */
 		if (HostAdapter->ActiveCommands[TargetID] == 0)
 			HostAdapter->LastSequencePoint[TargetID] = jiffies;
-		else if (jiffies - HostAdapter->LastSequencePoint[TargetID] > 4 * HZ) {
+		else if (time_after(jiffies,
+			 HostAdapter->LastSequencePoint[TargetID] + 4 * HZ)) {
 			HostAdapter->LastSequencePoint[TargetID] = jiffies;
 			QueueTag = BusLogic_OrderedQueueTag;
 		}
diff -uprN linux-vanilla/drivers/scsi/osst.c linux-1/drivers/scsi/osst.c
--- linux-vanilla/drivers/scsi/osst.c	2005-10-12 18:58:24.000000000 +0400
+++ linux-1/drivers/scsi/osst.c	2005-10-13 02:49:18.000000000 +0400
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
diff -uprN linux-vanilla/drivers/scsi/ppa.c linux-1/drivers/scsi/ppa.c
--- linux-vanilla/drivers/scsi/ppa.c	2005-10-12 18:58:24.000000000 +0400
+++ linux-1/drivers/scsi/ppa.c	2005-10-13 02:49:18.000000000 +0400
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
diff -uprN linux-vanilla/drivers/scsi/qlogicfc.c linux-1/drivers/scsi/qlogicfc.c
--- linux-vanilla/drivers/scsi/qlogicfc.c	2005-10-12 18:58:24.000000000 +0400
+++ linux-1/drivers/scsi/qlogicfc.c	2005-10-13 02:49:18.000000000 +0400
@@ -1325,7 +1325,8 @@ static int isp2x00_queuecommand(Scsi_Cmn
 		cmd->control_flags = cpu_to_le16(CFLAG_READ);
 
 	if (Cmnd->device->tagged_supported) {
-		if ((jiffies - hostdata->tag_ages[Cmnd->device->id]) > (2 * ISP_TIMEOUT)) {
+		if (time_after(jiffies, hostdata->tag_ages[Cmnd->device->id]
+					+ (2 * ISP_TIMEOUT))) {
 			cmd->control_flags |= cpu_to_le16(CFLAG_ORDERED_TAG);
 			hostdata->tag_ages[Cmnd->device->id] = jiffies;
 		} else
diff -uprN linux-vanilla/drivers/scsi/qlogicpti.c linux-1/drivers/scsi/qlogicpti.c
--- linux-vanilla/drivers/scsi/qlogicpti.c	2005-10-12 18:58:24.000000000 +0400
+++ linux-1/drivers/scsi/qlogicpti.c	2005-10-13 02:49:18.000000000 +0400
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

