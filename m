From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Thu, 22 Oct 2009 01:09:36 +0000
Message-ID: <1256173776.7297.28.camel@localhost.localdomain>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E9134554A@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbZJVBJs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 21:09:48 -0400
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E9134554A@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

On Fri, 2009-10-09 at 14:53 +0530, Penchala Narasimha Reddy Chilakala,
TLS-Chennai wrote:
> Hi James and linux-scsi community,
> 
> Can you please let us know your feedback on my response to the queries
> raised by James so that I will proceed further based on your feedback?

Sorry, press of conferences has delayed me getting around to looking at
this.

The patch is spitting this compile warning:

drivers/scsi/aacraid/commsup.c: In function 'aac_fib_send':
drivers/scsi/aacraid/commsup.c:539: warning: ignoring return value of 'down_interruptible', declared with attribute warn_unused_result

Because of this hunk:

@@ -515,15 +535,14 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned
                                }
                                udelay(5);
                        }
-               } else if (down_interruptible(&fibptr->event_wait)) {
-                       fibptr->done = 2;
-                       up(&fibptr->event_wait);
-               }
+               } else
+                       down_interruptible(&fibptr->event_wait);


The reason for the warning is that down_interruptible() will return an
error if it gets interrupted without acquiring the semaphore, and the
kernel checkers believe you can't write correct code without knowing
whether you acquired the semaphore or not.

Now, the original use case didn't care it was just waiting for the
semaphore to become available but didn't actually want to acquire it, so
I suspect what you want is:

} else if (down_interruptible(&fibptr->event_wait))
                     up(&fibptr->event_wait);

If you suddenly do care about acquiring the semaphore, you need to do
something about the interrupted failure case.

James



