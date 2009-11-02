From: "Penchala Narasimha Reddy Chilakala, TLS-Chennai"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Mon, 2 Nov 2009 13:05:56 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E9134556F@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:33631 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZKBHgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 02:36:04 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi James,


Please let me know your opinion on the explanation given by me in the previous e-mail to the issue raised by you so that I will proceed further based on your feedback as lot of IBM customers and RedHat have been waiting for this patch to come in linux-scsi upstream even though we have given private build to some of the IBM customers like Cisco and SAP?

Thanks,
Narasimha Reddy

-----Original Message-----
From: Penchala Narasimha Reddy Chilakala, TLS-Chennai
Sent: Friday, October 23, 2009 6:41 PM
To: 'James Bottomley'
Cc: 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: RE: [PATCH ] scsi-misc-2.6: File System going into read-only mode

Hi James,

Thanks a lot for your feedback.

Here is my explanation for the change. We have done good amount of review and testing before finalizing the change. We found the following code also caused to exit the management request prematurely without getting response from the firmware during our review, which in turn caused to generated False Raid Alert events in the application layer.

So after doing good amount of review and testing, we replace the below code

            else if (down_interruptible(&fibptr->event_wait)) {
                      fibptr->done = 2;
                      up(&fibptr->event_wait);
          }

With the following code
            } else
                down_interruptible (&fibptr->event_wait);

To overcome the warning, we can replace the above code with either

            } else if (down_interruptible (&fibptr->event_wait));

                        Or

            } else {
                 if (down_interruptible (&fibptr->event_wait))
                        ;
            }

I am ok to do the above mentioned change in the code and resubmit the patch with the above change as there is no issue with respect to functionality and other aspects as such.

Please let me know your opinion on this so that I will proceed further based on your feedback.


Important note:
-----------------

fibptr->event_wait is initialized with the following OS kernel function call during the driver initialization.

        init_MUTEX_LOCKED(&fibptr->event_wait);

The above OS kernel function call initializes the semaphore to locked (unavailable) state. On using the fibptr->event_wait by down_interruptible, the semaphore is not available so process/task will enter into sleep mode until the semaphore is available. The semaphore will be available only when the response gets from the firmware for the request delivered to the firmware. When response comes from the firmware then driver's response path code calls the up() if the fibpter->done is equal to zero. So the corresponding task/process gets semaphore and wakes the task/process up and proceeds with further processing.

Suppose the process/task, who is waiting for semaphore, gets exited before getting response from the firmware due to some signal, then driver should not call up() function as there is no point calling up() function after exiting as the fibptr->event_wait was initialized to locked (unavailable) state during the driver initialization.

So my point, here, is that we should not call up() if process/task is exited prematurely before getting the response from the firmware for the request delivered to firmware as the fibptr->event_wait was initialized to locked (unavailable) state.
---------------------------------------------------------------------------

Thanks,
Narasimha Reddy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de]
Sent: Thursday, October 22, 2009 6:40 AM
To: Penchala Narasimha Reddy Chilakala, TLS-Chennai
Cc: 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: RE: [PATCH ] scsi-misc-2.6: File System going into read-only mode

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
