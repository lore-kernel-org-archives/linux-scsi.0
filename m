From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Tue, 03 Nov 2009 20:02:49 +0100
Message-ID: <4AF07E59.1070000@s5r6.in-berlin.de>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8553@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46584 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZKCTDQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 14:03:16 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8553@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: James Bottomley <James.Bottomley@suse.de>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

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

dpcsup.c:	2x up(&fib->event_wait)
commsup.c:	allocation and initialization of the semaphore
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
