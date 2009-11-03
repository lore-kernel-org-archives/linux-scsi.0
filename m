From: "Penchala Narasimha Reddy Chilakala, TLS-Chennai"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Tue, 3 Nov 2009 15:24:54 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8553@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
References: <4AEF0909.5050809@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:60493 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZKCJzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 04:55:12 -0500
In-Reply-To: <4AEF0909.5050809@s5r6.in-berlin.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@suse.de>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi Stefan,

Thanks a lot for your suggestion and feedback.

Aacraid driver has been using down_interruptible () and up () for quite some time. We will take your suggestion into consideration and keep in our mind. But it is quite difficult to implement your suggestion at this point of time as we need to modify the code in lot places and we need to test a lot.

Thanks,
Narasimha Reddy


-----Original Message-----
From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de]
Sent: Monday, November 02, 2009 10:00 PM
To: Penchala Narasimha Reddy Chilakala, TLS-Chennai
Cc: James Bottomley; 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: Re: [PATCH ] scsi-misc-2.6: File System going into read-only mode

Penchala Narasimha Reddy Chilakala, TLS-Chennai wrote:
> Hi James,
>
> Please let me know your opinion on the explanation given by me in the
> previous e-mail to the issue raised by you so that I will proceed
> further based on your feedback
[...]
> -----Original Message-----
> From: Penchala Narasimha Reddy Chilakala, TLS-Chennai
> Sent: Friday, October 23, 2009 6:41 PM
[...]
> Here is my explanation for the change. We have done good amount of
> review and testing before finalizing the change. We found the following
> code also caused to exit the management request prematurely without
> getting response from the firmware during our review, which in turn
> caused to generated False Raid Alert events in the application layer.
>
> So after doing good amount of review and testing, we replace the below
> code
>
>             else if (down_interruptible(&fibptr->event_wait)) {
>                       fibptr->done = 2;
>                       up(&fibptr->event_wait);
>           }
>
> With the following code
>             } else
>                 down_interruptible (&fibptr->event_wait);
>
> To overcome the warning,

[i.e. "warning: ignoring return value of 'down_interruptible', declared
with attribute warn_unused_result"]

> we can replace the above code with either
>
>             } else if (down_interruptible (&fibptr->event_wait));
>
>                         Or
>
>             } else {
>                  if (down_interruptible (&fibptr->event_wait))
>                         ;
>             }
>
> I am ok to do the above mentioned change in the code and resubmit the
> patch with the above change as there is no issue with respect to
> functionality and other aspects as such.

I'm not James, but I do have a suggestion:

Leave the compiler warning there for the short term.  And then, instead
of suppressing the warning with hard to read code, convert from
semaphore to completion (or waitqueue perhaps).

I'm not familiar with aacraid but your problem description sounds to me
as if the legacy counting semaphore API is not the correct kernel API to
use here.
--
Stefan Richter
-=====-==--= =-=- ===--
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
