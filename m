From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Mon, 02 Nov 2009 17:30:01 +0100
Message-ID: <4AEF0909.5050809@s5r6.in-berlin.de>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E9134556F@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39929 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbZKBQaE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 11:30:04 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E9134556F@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: James Bottomley <James.Bottomley@suse.de>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

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
