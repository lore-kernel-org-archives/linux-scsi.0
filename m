From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Wed, 11 Nov 2009 13:26:41 -0600
Message-ID: <1257967601.11985.10.camel@mulgrave.site>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8D1E@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651AbZKKT0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2009 14:26:44 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8D1E@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

On Thu, 2009-11-05 at 18:57 +0530, Penchala Narasimha Reddy Chilakala,
TLS-Chennai wrote:
> Hi James and linux-scsi community,
> 
>        I would request you that please review the attached updated patch with the following modification, which is suggested by James in the previous mails and do the needful to incorporate the patch in up-coming release.
> 
> 
> else if (down_interruptible(&fibptr->event_wait)) {
>         /* Do nothing ... satisfy
>          * down_interruptible must_check */
>  }
> 

Yes, that's fine.

The management fib stuff is still racy as I pointed out previously. The
attached should fix it up, is this OK with you?

James

---

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index b1fc0a0..795fb05 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -855,10 +855,11 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
 		spin_unlock_irqrestore(&dev->manage_lock, mflags);
 		return -EBUSY;
 	}
+	dev->management_fib_count++;
 	spin_unlock_irqrestore(&dev->manage_lock, mflags);
 	status = aac_dev_ioctl(dev, cmd, arg);
 	if (status != -ENOTTY)
-		return status;
+		goto out;
 
 	switch (cmd) {
 	case FSACTL_MINIPORT_REV_CHECK:
@@ -887,6 +888,13 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
 		status = -ENOTTY;
 		break;
 	}
+ out:
+	if (status != -ERESTARTSYS) {
+		spin_lock_irqsave(&dev->manage_lock, mflags);
+		--dev->management_fib_count;
+		spin_unlock_irqrestore(&dev->manage_lock, mflags);
+	}
+		
 	return status;
 }
 
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 99729a6..e00c6a9 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -494,13 +494,8 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	 */
 
 	if (wait) {
-		unsigned long mflags;
 		spin_unlock_irqrestore(&fibptr->event_lock, flags);
 
-		spin_lock_irqsave(&dev->manage_lock, mflags);
-		dev->management_fib_count++;
-		spin_unlock_irqrestore(&dev->manage_lock, mflags);
-
 		/* Only set for first known interruptable command */
 		if (wait < 0) {
 			/*
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index 9c7408f..d06bfd2 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -57,7 +57,7 @@ unsigned int aac_response_normal(struct aac_queue * q)
 	struct hw_fib * hwfib;
 	struct fib * fib;
 	int consumed = 0;
-	unsigned long flags, mflags;
+	unsigned long flags;
 
 	spin_lock_irqsave(q->lock, flags);
 	/*
@@ -131,13 +131,13 @@ unsigned int aac_response_normal(struct aac_queue * q)
 			}
 			spin_unlock_irqrestore(&fib->event_lock, flagv);
 
-			spin_lock_irqsave(&dev->manage_lock, mflags);
-			dev->management_fib_count--;
-			spin_unlock_irqrestore(&dev->manage_lock, mflags);
-
 			FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
 			if (fib->done == 2) {
-				spin_lock_irqsave(&fib->event_lock, flagv);
+				spin_lock_irqsave(&dev->manage_lock, flagv);
+				dev->management_fib_count--;
+				spin_unlock(&dev->manage_lock);
+
+				spin_lock(&fib->event_lock);
 				fib->done = 0;
 				spin_unlock_irqrestore(&fib->event_lock, flagv);
 				aac_fib_complete(fib);
@@ -241,7 +241,6 @@ unsigned int aac_command_normal(struct aac_queue *q)
 
 unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
 {
-	unsigned long mflags;
 	dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, index));
 	if ((index & 0x00000002L)) {
 		struct hw_fib * hw_fib;
@@ -336,13 +335,13 @@ unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
 			}
 			spin_unlock_irqrestore(&fib->event_lock, flagv);
 
-			spin_lock_irqsave(&dev->manage_lock, mflags);
-			dev->management_fib_count--;
-			spin_unlock_irqrestore(&dev->manage_lock, mflags);
-
 			FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
 			if (fib->done == 2) {
-				spin_lock_irqsave(&fib->event_lock, flagv);
+				spin_lock_irqsave(&dev->manage_lock, flagv);
+				dev->management_fib_count--;
+				spin_unlock(&dev->manage_lock);
+
+				spin_lock(&fib->event_lock);
 				fib->done = 0;
 				spin_unlock_irqrestore(&fib->event_lock, flagv);
 				aac_fib_complete(fib);



