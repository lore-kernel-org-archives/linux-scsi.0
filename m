From: "Penchala Narasimha Reddy Chilakala, TLS-Chennai"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Wed, 4 Nov 2009 12:30:56 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C87F5@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
References: <4AF07E59.1070000@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:37351 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbZKDHBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 02:01:52 -0500
In-Reply-To: <4AF07E59.1070000@s5r6.in-berlin.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@suse.de>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi Stefan,

All your feedback will be considered, and need to be discussed with other people before trying it out in aacraid code, but it would be taken as experiment bases because we need to work on other customer defects as well and it needs lot of testing as I said earlier. So it will take quite a sometime.

Thanks,
Narasimha Reddy

-----Original Message-----
From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de]
Sent: Wednesday, November 04, 2009 12:33 AM
To: Penchala Narasimha Reddy Chilakala, TLS-Chennai
Cc: James Bottomley; 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: Re: [PATCH ] scsi-misc-2.6: File System going into read-only mode

Penchala Narasimha Reddy Chilakala, TLS-Chennai wrote:
> Hi Stefan,
>
> Thanks a lot for your suggestion and feedback.
>
> Aacraid driver has been using down_interruptible () and up () for
> quite some time. We will take your suggestion into consideration
> and keep in our mind. But it is quite difficult to implement your
> suggestion at this point of time as we need to modify the code in
> lot places and we need to test a lot.

dpcsup.c:       2x up(&fib->event_wait)
commsup.c:      allocation and initialization of the semaphore
                1x down_trylock(&fibptr->event_wait) +
                1x down_interruptible(&fibptr->event_wait) + up()
                1x up(&fib->event_wait)

So there are just two places which conditionally wait for completion (or
just one place but with a differentiation between sync and async mode),
and three places which signal "done".

You are right that this would be a non-trivial change and will require
respective testing.  However, (1.) only the place which waits for
completion is the non-trivial part (because it's currently coded in a
rather obfuscated way), (2.) I expect that the result would be cleaner
code which is (3.) more obvious to be correct and (4.) can also be
checked for correctness by the lockdep facility --- this is not possible
with legacy semaphores.

Anyway; it's up to those who use or maintain this driver.  I for one
converted another subsystem away from two or three different misused
semaphores to more appropriate APIs and it wasn't too hard; but I can't
do this for aacraid since I don't have hardware to test.

(In my rather irrelevant opinion, whatever you decide for now, just do
_not_ do this here:

>>> we can replace the above code with either
>>>
>>>             } else if (down_interruptible (&fibptr->event_wait));
>>>
>>>                         Or
>>>
>>>             } else {
>>>                  if (down_interruptible (&fibptr->event_wait))
>>>                         ;
>>>             }

because it can really hurt in the long run if sensible warnings are hidden.)
--
Stefan Richter
-=====-==--= =-== ---==
http://arcgraph.de/sr/

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
