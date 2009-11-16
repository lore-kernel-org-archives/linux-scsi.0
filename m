From: "Penchala Narasimha Reddy Chilakala, ERS-HCLTech"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Mon, 16 Nov 2009 08:55:12 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E9150B996@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
References: <1258145722.5965.55.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:59978 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZKPDZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2009 22:25:18 -0500
In-Reply-To: <1258145722.5965.55.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi James,

Thanks a lot for your nice review, feedback and support so far. I hope that we have sorted out all the issues raised by you except the racy issue.

Thanks,
Narasimha Reddy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Saturday, November 14, 2009 2:25 AM
To: Penchala Narasimha Reddy Chilakala, ERS-HCLTech
Cc: 'linux-scsi@vger.kernel.org'; James Bottomley; ServeRAID Driver
Subject: RE: [PATCH ] scsi-misc-2.6: File System going into read-only mode

On Thu, 2009-11-12 at 13:58 +0530, Penchala Narasimha Reddy Chilakala,
ERS-HCLTech wrote:
> Hi James,
>
> Thank you very much for your suggestion.
>
> I feel that we need to work out for a better solution which would not
> create any issues. We have to go ahead with the patch as it is tested
> and working as expected (with out any issues) even though we are
> thinking there might be some racy issue until we come out with a
> better solution than the current one

Sure, I can wait for a better solution.

> I am not quite ok with the fix because of the following reasons:
>
>         1. I feel that calling the dev->management_fib_count--
> statement in one place, that is in dpcsup.c (Whenever interrupt comes
> from arcraid controller, the corresponding ISR route will be called
> and the value will be decremented, if the response is for the
> requested management fib) is good  instead of calling the statement in
> two places, which are dpcsup.c and commctrl.c.

Um, so that's the same mechanism you implemented for this undone fib
problem: setting the ->done flag as mediator.

>      2. Moving the dev->management_fib_count++ from aac_fib_send ()
> function to aac_do_ioctl () function did not work well during our
> testing (This was suggested by you in one of the earlier mails).

That doesn't give me a lot to go on.

However, I'm not particularly bothered whose solution it is, just that
we have a solution that isn't demonstrably racy.

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
