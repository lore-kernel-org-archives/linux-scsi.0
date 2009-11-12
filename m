From: "Penchala Narasimha Reddy Chilakala, ERS-HCLTech"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Thu, 12 Nov 2009 13:58:32 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E9150B4EE@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
References: <1257967601.11985.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws07.mail.hcl.in ([203.105.186.27]:58179 "EHLO gws07.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbZKLI3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2009 03:29:16 -0500
In-Reply-To: <1257967601.11985.10.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi James,

Thank you very much for your suggestion.

I feel that we need to work out for a better solution which would not create any issues. We have to go ahead with the patch as it is tested and working as expected (with out any issues) even though we are thinking there might be some racy issue until we come out with a better solution than the current one

I am not quite ok with the fix because of the following reasons:

        1. I feel that calling the dev->management_fib_count-- statement in one place, that is in dpcsup.c (Whenever interrupt comes from arcraid controller, the corresponding ISR route will be called and the value will be decremented, if the response is for the requested management fib) is good  instead of calling the statement in two places, which are dpcsup.c and commctrl.c.

     2. Moving the dev->management_fib_count++ from aac_fib_send () function to aac_do_ioctl () function did not work well during our testing (This was suggested by you in one of the earlier mails).


Thanks,
Narasimha Reddy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de]
Sent: Thursday, November 12, 2009 12:57 AM
To: Penchala Narasimha Reddy Chilakala, ERS-HCLTech
Cc: 'linux-scsi@vger.kernel.org'; James Bottomley; ServeRAID Driver
Subject: Re: [PATCH ] scsi-misc-2.6: File System going into read-only mode

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
+       dev->management_fib_count++;
        spin_unlock_irqrestore(&dev->manage_lock, mflags);
        status = aac_dev_ioctl(dev, cmd, arg);
        if (status != -ENOTTY)
-               return status;
+               goto out;

        switch (cmd) {
        case FSACTL_MINIPORT_REV_CHECK:
@@ -887,6 +888,13 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
                status = -ENOTTY;
                break;
        }
+ out:
+       if (status != -ERESTARTSYS) {
+               spin_lock_irqsave(&dev->manage_lock, mflags);
+               --dev->management_fib_count;
+               spin_unlock_irqrestore(&dev->manage_lock, mflags);
+       }
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
-               unsigned long mflags;
                spin_unlock_irqrestore(&fibptr->event_lock, flags);

-               spin_lock_irqsave(&dev->manage_lock, mflags);
-               dev->management_fib_count++;
-               spin_unlock_irqrestore(&dev->manage_lock, mflags);
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
-       unsigned long flags, mflags;
+       unsigned long flags;

        spin_lock_irqsave(q->lock, flags);
        /*
@@ -131,13 +131,13 @@ unsigned int aac_response_normal(struct aac_queue * q)
                        }
                        spin_unlock_irqrestore(&fib->event_lock, flagv);

-                       spin_lock_irqsave(&dev->manage_lock, mflags);
-                       dev->management_fib_count--;
-                       spin_unlock_irqrestore(&dev->manage_lock, mflags);
-
                        FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
                        if (fib->done == 2) {
-                               spin_lock_irqsave(&fib->event_lock, flagv);
+                               spin_lock_irqsave(&dev->manage_lock, flagv);
+                               dev->management_fib_count--;
+                               spin_unlock(&dev->manage_lock);
+
+                               spin_lock(&fib->event_lock);
                                fib->done = 0;
                                spin_unlock_irqrestore(&fib->event_lock, flagv);
                                aac_fib_complete(fib);
@@ -241,7 +241,6 @@ unsigned int aac_command_normal(struct aac_queue *q)

 unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
 {
-       unsigned long mflags;
        dprintk((KERN_INFO "aac_intr_normal(%p,%x)\n", dev, index));
        if ((index & 0x00000002L)) {
                struct hw_fib * hw_fib;
@@ -336,13 +335,13 @@ unsigned int aac_intr_normal(struct aac_dev * dev, u32 index)
                        }
                        spin_unlock_irqrestore(&fib->event_lock, flagv);

-                       spin_lock_irqsave(&dev->manage_lock, mflags);
-                       dev->management_fib_count--;
-                       spin_unlock_irqrestore(&dev->manage_lock, mflags);
-
                        FIB_COUNTER_INCREMENT(aac_config.NormalRecved);
                        if (fib->done == 2) {
-                               spin_lock_irqsave(&fib->event_lock, flagv);
+                               spin_lock_irqsave(&dev->manage_lock, flagv);
+                               dev->management_fib_count--;
+                               spin_unlock(&dev->manage_lock);
+
+                               spin_lock(&fib->event_lock);
                                fib->done = 0;
                                spin_unlock_irqrestore(&fib->event_lock, flagv);
                                aac_fib_complete(fib);




DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
