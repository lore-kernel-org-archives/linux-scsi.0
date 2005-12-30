From: jes@trained-monkey.org (Jes Sorensen)
Subject: [RFC] migrate ch.c away from semaphores
Date: Fri, 30 Dec 2005 10:26:05 -0500
Message-ID: <17333.20877.229345.594316@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:424 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S932214AbVL3P0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Dec 2005 10:26:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Gerd Knorr <kraxel@bytesex.org>, Ingo Molnar <mingo@elte.hu>

Hi,

I have been migrating some files away from semaphores to the new mutex
code and had a go at ch.c as well. I made a few other changes which I
was hoping someone would comment upon, or at least yell if they
disagree.

Gerd I am not sure if you still maintain this driver but since you're
listed as the author you get the first blame or chance to yell ;-)

If nobody complains then I'll pass it on to Ingo.

Cheers,
Jes

Migrate drivers/scsi/ch.c to use a mutex rather than a semaphore. Fix
up allocations to be GFP_KERNEL and not GFP_DMA as it's really the job
of the device driver to figure out if it can handle the buffer or not,
not a mid layer protocol driver. Last, fix case where loop would
continue even though put_user() fails.

Signed-off-by: Jes Sorensen <jes@sgi.com>

----

 drivers/scsi/ch.c |   51 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 23 deletions(-)

Index: linux-2.6.15-rc7-quilt/drivers/scsi/ch.c
===================================================================
--- linux-2.6.15-rc7-quilt.orig/drivers/scsi/ch.c
+++ linux-2.6.15-rc7-quilt/drivers/scsi/ch.c
@@ -19,7 +19,7 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <linux/completion.h>
+#include <linux/mutex.h>
 #include <linux/ioctl32.h>
 #include <linux/compat.h>
 #include <linux/chio.h>			/* here are all the ioctls */
@@ -112,7 +112,7 @@
 	u_int               counts[CH_TYPES];
 	u_int               unit_attention;
 	u_int		    voltags;
-	struct semaphore    lock;
+	struct mutex	    lock;
 } scsi_changer;
 
 static LIST_HEAD(ch_devlist);
@@ -263,7 +263,7 @@
 	u_char  *buffer;
 	int     result;
 	
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if(!buffer)
 		return -ENOMEM;
 	
@@ -320,7 +320,7 @@
 	int     result,id,lun,i;
 	u_int   elem;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 	memset(buffer,0,512);
@@ -563,17 +563,21 @@
 static int ch_gstatus(scsi_changer *ch, int type, unsigned char __user *dest)
 {
 	int retval = 0;
-	u_char data[16];
+	u8 data[16];
 	unsigned int i;
-	
-	down(&ch->lock);
+
+	mutex_lock(&ch->lock);
 	for (i = 0; i < ch->counts[type]; i++) {
 		if (0 != ch_read_element_status
 		    (ch, ch->firsts[type]+i,data)) {
 			retval = -EIO;
 			break;
 		}
-		put_user(data[2], dest+i);
+		if (put_user(data[2], dest+i)) {
+			retval = -EFAULT;
+			goto out;
+		}
+			
 		if (data[2] & CESTATUS_EXCEPT)
 			vprintk("element 0x%x: asc=0x%x, ascq=0x%x\n",
 				ch->firsts[type]+i,
@@ -583,7 +587,8 @@
 		if (0 != retval)
 			break;
 	}
-	up(&ch->lock);
+ out:
+	mutex_unlock(&ch->lock);
 	return retval;
 }
 
@@ -688,11 +693,11 @@
 			dprintk("CHIOPOSITION: invalid parameter\n");
 			return -EBADSLT;
 		}
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_position(ch,0,
 				     ch->firsts[pos.cp_type] + pos.cp_unit,
 				     pos.cp_flags & CP_INVERT);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 	
@@ -709,12 +714,12 @@
 			return -EBADSLT;
 		}
 		
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_move(ch,0,
 				 ch->firsts[mv.cm_fromtype] + mv.cm_fromunit,
 				 ch->firsts[mv.cm_totype]   + mv.cm_tounit,
 				 mv.cm_flags & CM_INVERT);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 
@@ -732,14 +737,14 @@
 			return -EBADSLT;
 		}
 		
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_exchange
 			(ch,0,
 			 ch->firsts[mv.ce_srctype]  + mv.ce_srcunit,
 			 ch->firsts[mv.ce_fdsttype] + mv.ce_fdstunit,
 			 ch->firsts[mv.ce_sdsttype] + mv.ce_sdstunit,
 			 mv.ce_flags & CE_INVERT1, mv.ce_flags & CE_INVERT2);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 
@@ -770,10 +775,10 @@
 			return -EINVAL;
 		elem = ch->firsts[cge.cge_type] + cge.cge_unit;
 		
-		buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+		buffer = kmalloc(512, GFP_KERNEL);
 		if (!buffer)
 			return -ENOMEM;
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		
 	voltag_retry:
 		memset(cmd,0,sizeof(cmd));
@@ -823,8 +828,8 @@
 			vprintk("device has no volume tag support\n");
 			goto voltag_retry;
 		}
+		mutex_unlock(&ch->lock);
 		kfree(buffer);
-		up(&ch->lock);
 		
 		if (copy_to_user(argp, &cge, sizeof (cge)))
 			return -EFAULT;
@@ -833,9 +838,9 @@
 
 	case CHIOINITELEM:
 	{
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_init_elem(ch);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 		
@@ -852,12 +857,12 @@
 			return -EBADSLT;
 		}
 		elem = ch->firsts[csv.csv_type] + csv.csv_unit;
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_set_voltag(ch, elem,
 				       csv.csv_flags & CSV_AVOLTAG,
 				       csv.csv_flags & CSV_CLEARTAG,
 				       csv.csv_voltag);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 
@@ -930,7 +935,7 @@
 	memset(ch,0,sizeof(*ch));
 	ch->minor = ch_devcount;
 	sprintf(ch->name,"ch%d",ch->minor);
-	init_MUTEX(&ch->lock);
+	mutex_init(&ch->lock);
 	ch->device = sd;
 	ch_readconfig(ch);
 	if (init)
