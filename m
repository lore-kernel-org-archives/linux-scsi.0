From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] drivers/scsi/*: use time_after() and friends
Date: Thu, 1 Dec 2005 00:48:03 +0300
Message-ID: <20051130214803.GE12551@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nproxy.gmail.com ([64.233.182.204]:6737 "EHLO nproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750819AbVK3VdU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 16:33:20 -0500
Received: by nproxy.gmail.com with SMTP id b2so34432nfe
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2005 13:33:18 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

From: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>

They deal with wrapping correctly and are nicer to read.

Signed-off-by: Marcelo Feitoza Parisi <marcelo@feitoza.com.br>
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/BusLogic.c  |    3 ++-
 drivers/scsi/osst.c      |    5 +++--
 drivers/scsi/ppa.c       |    3 ++-
 drivers/scsi/qlogicfc.c  |    3 ++-
 drivers/scsi/qlogicpti.c |    3 ++-
 5 files changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -41,6 +41,7 @@
 #include <linux/stat.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/jiffies.h>
 #include <scsi/scsicam.h>
 
 #include <asm/dma.h>
@@ -2895,7 +2896,7 @@ static int BusLogic_QueueCommand(struct 
 		 */
 		if (HostAdapter->ActiveCommands[TargetID] == 0)
 			HostAdapter->LastSequencePoint[TargetID] = jiffies;
-		else if (jiffies - HostAdapter->LastSequencePoint[TargetID] > 4 * HZ) {
+		else if (time_after(jiffies, HostAdapter->LastSequencePoint[TargetID] + 4 * HZ)) {
 			HostAdapter->LastSequencePoint[TargetID] = jiffies;
 			QueueTag = BusLogic_OrderedQueueTag;
 		}
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
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
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
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
+				if (time_after(jiffies, dev->jstart + (1 * HZ))) {
 					printk
 					    ("ppa: Parallel port cable is unplugged!!\n");
 					ppa_fail(dev, DID_BUS_BUSY);
--- a/drivers/scsi/qlogicfc.c
+++ b/drivers/scsi/qlogicfc.c
@@ -61,6 +61,7 @@
 #include <linux/unistd.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/jiffies.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include "scsi.h"
@@ -1325,7 +1326,7 @@ static int isp2x00_queuecommand(Scsi_Cmn
 		cmd->control_flags = cpu_to_le16(CFLAG_READ);
 
 	if (Cmnd->device->tagged_supported) {
-		if ((jiffies - hostdata->tag_ages[Cmnd->device->id]) > (2 * ISP_TIMEOUT)) {
+		if (time_after(jiffies, hostdata->tag_ages[Cmnd->device->id] + (2 * ISP_TIMEOUT))) {
 			cmd->control_flags |= cpu_to_le16(CFLAG_ORDERED_TAG);
 			hostdata->tag_ages[Cmnd->device->id] = jiffies;
 		} else
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -24,6 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/jiffies.h>
 
 #include <asm/byteorder.h>
 
@@ -1017,7 +1018,7 @@ static inline void cmd_frob(struct Comma
 	if (Cmnd->device->tagged_supported) {
 		if (qpti->cmd_count[Cmnd->device->id] == 0)
 			qpti->tag_ages[Cmnd->device->id] = jiffies;
-		if ((jiffies - qpti->tag_ages[Cmnd->device->id]) > (5*HZ)) {
+		if (time_after(jiffies, qpti->tag_ages[Cmnd->device->id] + (5*HZ))) {
 			cmd->control_flags = CFLAG_ORDERED_TAG;
 			qpti->tag_ages[Cmnd->device->id] = jiffies;
 		} else

