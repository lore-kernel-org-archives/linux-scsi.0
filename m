From: "Penchala Narasimha Reddy Chilakala, TLS-Chennai"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Tue, 3 Nov 2009 15:08:23 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8546@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
References: <1257183957.2472.156.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:58304 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbZKCJir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 04:38:47 -0500
In-Reply-To: <1257183957.2472.156.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi James,

I can do the following thing, I hope which works well and it would not change any existing functionality behavior and I hope you agree with me. I could not able accept your suggestion because of the following reason.

As the warning fix, here is my suggestion on top of my original patch (I will resubmit a patch with this modification, please let me know if it is ok for you)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index d29af45..1712ebe 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -535,11 +535,11 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 				}
 				udelay(5);
 			}
-		} else
-			down_interruptible(&fibptr->event_wait);
-
+		} else if (down_interruptible(&fibptr->event_wait)) {
+			fibptr->done |= 2;
+		}
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-		if (fibptr->done == 0) {
+		if (!(fibptr->done & 1)) {
 			fibptr->done = 2; /* Tell interrupt we aborted */
 			spin_unlock_irqrestore(&fibptr->event_lock, flags);
 			return -ERESTARTSYS;


Reason:
---------
	Whatever explanation I have given here is based on our test results and problems we encountered during our testing. Nobody might have done this much testing on this code after replacing the "down ()" with "down_interruptible () kernel function. 

"down_interruptible" is not a single statement or single instruction function. It has set of statements, which have to be executed based on its conditions. When it receives a soft interrupt signal, a set of statements will be executed and when it gets semaphore, some other set of statements will be executed. 

	Now, assume that down_interruptible received a soft interrupt signal from X source and started executing those statements and while executing those statements, host driver received a interrupt from aacraid controller and suspends the currently executing task and starts executing the aacraid driver interrupt service route (ISR).  The ISR checks the responses for the requests sent to firmware, if it gets response for the management request then it sets fibptr->done = 1 and it comes out of the ISR and starts executing the suspended task. Now the suspended task will modify the fibptr->done with 2. This is not correct behavior. So, to over come that we have done those changes, after doing those changes, we have executed all the test cases we executed before the changes and we have not seen the
  issue we encountered before the change.

Thanks,
Narasimha Reddy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Monday, November 02, 2009 11:16 PM
To: Penchala Narasimha Reddy Chilakala, TLS-Chennai
Cc: 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: RE: [PATCH ] scsi-misc-2.6: File System going into read-only mode

On Mon, 2009-11-02 at 13:05 +0530, Penchala Narasimha Reddy Chilakala,
TLS-Chennai wrote:
> Please let me know your opinion on the explanation given by me in the
> previous e-mail to the issue raised by you so that I will proceed
> further based on your feedback as lot of IBM customers and RedHat have
> been waiting for this patch to come in linux-scsi upstream even though
> we have given private build to some of the IBM customers like Cisco
> and SAP?

I need the warning fixed.

How about this as the fix suggestion on top of your original patch:

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index d29af45..1712ebe 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -535,11 +535,11 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 				}
 				udelay(5);
 			}
-		} else
-			down_interruptible(&fibptr->event_wait);
-
+		} else if (down_interruptible(&fibptr->event_wait)) {
+			fibptr->done = 2;
+		}
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-		if (fibptr->done == 0) {
+		if ((fibptr->done == 0) || (fibptr->done == 2)) {
 			fibptr->done = 2; /* Tell interrupt we aborted */
 			spin_unlock_irqrestore(&fibptr->event_lock, flags);
 			return -ERESTARTSYS;

It preserves the original code, even though setting fibptr->done to 2 is
a bit superfluous, it makes it much more obvious to someone looking at
the diff what the actual fix is.

James



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
