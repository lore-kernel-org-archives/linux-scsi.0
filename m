From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/4] aacraid:  interruptible ioctl
Date: Thu, 03 Aug 2006 08:02:24 -0700
Message-ID: <1154617344.31319.20.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:36580 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932419AbWHCPC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2006 11:02:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

This patch allows the FSACTL_SEND_LARGE_FIB, FSACTL_SENDFIB and
FSACTL_SEND_RAW_SRB ioctl calls into the aacraid driver to be
interruptible. Only necessary if the adapter and/or the management
software has gone into some sort of misbehavior and the system is being
rebooted, thus permitting the user management software applications to
be killed relatively cleanly. The FIB queue resource is held out of the
free queue until the adapter finally, if ever, completes the command.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2006-07-31 11:00:22.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2006-07-31 14:33:19.000000000 -0700
@@ -38,7 +38,7 @@
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
-#include <linux/delay.h>
+#include <linux/delay.h> /* ssleep prototype */
 #include <linux/kthread.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
@@ -140,7 +140,8 @@
 		fibptr->hw_fib_pa = hw_fib_pa;
 		fibptr->hw_fib = hw_fib;
 	}
-	aac_fib_free(fibptr);
+	if (retval != -EINTR)
+		aac_fib_free(fibptr);
 	return retval;
 }
 
@@ -621,7 +622,13 @@
 
 		actual_fibsize = sizeof (struct aac_srb) + (((user_srbcmd->sg.count & 0xff) - 1) * sizeof (struct sgentry));
 		if(actual_fibsize != fibsize){ // User made a mistake - should not continue
-			dprintk((KERN_DEBUG"aacraid: Bad Size specified in Raw SRB command\n"));
+			dprintk((KERN_DEBUG"aacraid: Bad Size specified in "
+			  "Raw SRB command calculated fibsize=%d "
+			  "user_srbcmd->sg.count=%d aac_srb=%d sgentry=%d "
+			  "issued fibsize=%d\n",
+			  actual_fibsize, user_srbcmd->sg.count,
+			  sizeof(struct aac_srb), sizeof(struct sgentry),
+			  fibsize));
 			rcode = -EINVAL;
 			goto cleanup;
 		}
@@ -663,6 +670,10 @@
 		psg->count = cpu_to_le32(sg_indx+1);
 		status = aac_fib_send(ScsiPortCommand, srbfib, actual_fibsize, FsaNormal, 1, 1, NULL, NULL);
 	}
+	if (status == -EINTR) {
+		rcode = -EINTR;
+		goto cleanup;
+	}
 
 	if (status != 0){
 		dprintk((KERN_DEBUG"aacraid: Could not send raw srb fib to hba\n")); 
@@ -696,8 +707,10 @@
 	for(i=0; i <= sg_indx; i++){
 		kfree(sg_list[i]);
 	}
-	aac_fib_complete(srbfib);
-	aac_fib_free(srbfib);
+	if (rcode != -EINTR) {
+		aac_fib_complete(srbfib);
+		aac_fib_free(srbfib);
+	}
 
 	return rcode;
 }
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-07-31 11:00:22.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-07-31 14:33:19.000000000 -0700
@@ -464,6 +464,8 @@
 	dprintk((KERN_DEBUG "  hw_fib pa being sent=%lx\n",(ulong)fibptr->hw_fib_pa));
 	dprintk((KERN_DEBUG "  fib being sent=%p\n",fibptr));
 
+	if (!dev->queues)
+		return -ENODEV;
 	q = &dev->queues->queue[AdapNormCmdQueue];
 
 	if(wait)
@@ -527,8 +529,15 @@
 				}
 				udelay(5);
 			}
-		} else
-			down(&fibptr->event_wait);
+		} else if (down_interruptible(&fibptr->event_wait)) {
+			spin_lock_irqsave(&fibptr->event_lock, flags);
+			if (fibptr->done == 0) {
+				fibptr->done = 2; /* Tell interrupt we aborted */
+				spin_unlock_irqrestore(&fibptr->event_lock, flags);
+				return -EINTR;
+			}
+			spin_unlock_irqrestore(&fibptr->event_lock, flags);
+		}
 		BUG_ON(fibptr->done == 0);
 			
 		if((fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT)){
@@ -795,7 +804,7 @@
 
 	/* Sniff for container changes */
 
-	if (!dev)
+	if (!dev || !dev->fsa_dev)
 		return;
 	container = (u32)-1;
 
--- scsi-misc-aac.orig/drivers/scsi/aacraid/dpcsup.c	2006-07-31 11:00:22.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/dpcsup.c	2006-07-31 11:29:51.000000000 -0700
@@ -124,10 +124,15 @@
 		} else {
 			unsigned long flagv;
 			spin_lock_irqsave(&fib->event_lock, flagv);
-			fib->done = 1;
+			if (!fib->done)
+				fib->done = 1;
 			up(&fib->event_wait);
 			spin_unlock_irqrestore(&fib->event_lock, flagv);
 			FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
+			if (fib->done == 2) {
+				aac_fib_complete(fib);
+				aac_fib_free(fib);
+			}
 		}
 		consumed++;
 		spin_lock_irqsave(q->lock, flags);
@@ -316,7 +321,8 @@
 			unsigned long flagv;
 	  		dprintk((KERN_INFO "event_wait up\n"));
 			spin_lock_irqsave(&fib->event_lock, flagv);
-			fib->done = 1;
+			if (!fib->done)
+				fib->done = 1;
 			up(&fib->event_wait);
 			spin_unlock_irqrestore(&fib->event_lock, flagv);
 			FIB_COUNTER_INCREMENT(aac_config.NormalRecved);

-- 
Mark Haverkamp <markh@osdl.org>

