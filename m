From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Fri, 13 Nov 2009 14:55:22 -0600
Message-ID: <1258145722.5965.55.camel@mulgrave.site>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E9150B4EE@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbZKMUzY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Nov 2009 15:55:24 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E9150B4EE@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, ERS-HCLTech" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

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


