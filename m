From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mpt2sas: Abort initialization if no memory I/O
 resources, detected
Date: Tue, 23 Jun 2015 10:56:09 -0700
Message-ID: <1435082169.2251.120.camel@HansenPartnership.com>
References: <557B578D.50706@raptorengineeringinc.com>
			 <55804E9C.2030802@raptorengineeringinc.com>
	 <55805FE8.7000806@stratus.com>
			 <55806FB0.7070706@raptorengineeringinc.com>
			 <55870668.4070405@raptorengineeringinc.com>
	 <5588D884.7030804@stratus.com>
			 <CAK=zhgoRJ+Naae9sms0TJtaD86KJ7cOkL75jKGh2eO7V_trRpw@mail.gmail.com>
		 <1435066507.2251.10.camel@HansenPartnership.com>
		 <55899867.3010400@raptorengineeringinc.com>
	 <1435081516.2251.118.camel@HansenPartnership.com>
	 <55899BBA.5030509@raptorengineeringinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36801 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932587AbbFWR4L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jun 2015 13:56:11 -0400
In-Reply-To: <55899BBA.5030509@raptorengineeringinc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Timothy Pearson <tpearson@raptorengineeringinc.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Joe Lawrence <joe.lawrence@stratus.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "Support (LSI)" <support@lsi.com>, DL-MPTFusionLinux@lsi.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2015-06-23 at 12:47 -0500, Timothy Pearson wrote:
> On 06/23/2015 12:45 PM, James Bottomley wrote:
> > On Tue, 2015-06-23 at 12:33 -0500, Timothy Pearson wrote:
> >> On 06/23/2015 08:35 AM, James Bottomley wrote:
> >>> On Tue, 2015-06-23 at 18:06 +0530, Sreekanth Reddy wrote:
> >>>> Hi,
> >>>>
> >>>> Upstream contributor should not add copyright to this driver code.
> >>>
> >>> I can't agree with that as a general rule: it depends on the
> >>> significance of the contribution.  The somewhat ill defined standard for
> >>> this is the contribution must be "an original work of authorship".
> >>>
> >>> I can agree that a trivial bug fix like this is not an original work of
> >>> authorship, so in this case adding copyright isn't appropriate.
> >>>
> >>> James
> >>>
> >>>> Regards,
> >>>> Sreekanth
> >>>>
> >>>> On Tue, Jun 23, 2015 at 9:24 AM, Joe Lawrence<joe.lawrence@stratus.com>   wrote:
> >>>>>
> >>>>>
> >>>>> On 06/21/2015 02:46 PM, Timothy Pearson wrote:
> >>>>>> On 06/16/2015 01:49 PM, Timothy Pearson wrote:
> >>>>>>> On 06/16/2015 12:42 PM, Joe Lawrence wrote:
> >>>>>>>> On 06/16/2015 12:28 PM, Timothy Pearson wrote:
> >>>>>>>>> On 06/12/2015 05:05 PM, Timothy Pearson wrote:
> >>>>>>>>>> The mpt2sas driver crashes if the BIOS does not set up at least one
> >>>>>>>>>> memory I/O resource. This failure can happen if the device is too
> >>>>>>>>>> slow to respond during POST and is missed by the BIOS, but Linux
> >>>>>>>>>> then detects the device later in the boot process.
> >>>>>>>>>>
> >>>>>>>>>> This patch aborts initialization and prints a warning if no memory I/O
> >>>>>>>>>> resources are found.
> >>>>>>>>>>
> >>>>>>>>>> Signed-off-by: Timothy Pearson<tpearson@raptorengineeringinc.com>
> >>>>>>>>>> Tested-by: Timothy Pearson<tpearson@raptorengineeringinc.com>
> >>>>>>>>>> ---
> >>>>>>>>>> drivers/scsi/mpt2sas/mpt2sas_base.c | 9 +++++++++
> >>>>>>>>>> 1 file changed, 9 insertions(+)
> >>>>>>>>>>
> >>>>>>>>>> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> >>>>>>>>>> b/drivers/scsi/mpt2sas/mpt2sas_base.c
> >>>>>>>>>> index 11248de..15c9504 100644
> >>>>>>>>>> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> >>>>>>>>>> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> >>>>>>>>>> @@ -6,6 +6,8 @@
> >>>>>>>>>> * Copyright (C) 2007-2014 LSI Corporation
> >>>>>>>>>> * Copyright (C) 20013-2014 Avago Technologies
> >>>>>>>>>> * (mailto: MPT-FusionLinux.pdl@avagotech.com)
> >>>>>>>>>> + * Copyright (C) 2015 Raptor Engineering
> >>>>>>>>>> + * (mailto: support@araptorengineeringinc.com)
> >>>>>>>>>> *
> >>>>>>>>>> * This program is free software; you can redistribute it and/or
> >>>>>>>>>> * modify it under the terms of the GNU General Public License
> >>>>>>>>>> @@ -1582,6 +1584,13 @@ mpt2sas_base_map_resources(struct
> >>>>>>>>>> MPT2SAS_ADAPTER
> >>>>>>>>>> *ioc)
> >>>>>>>>>> }
> >>>>>>>>>> }
> >>>>>>>>>>
> >>>>>>>>>> + if (ioc->chip == NULL) {
> >>>>>>>>>> + printk(MPT2SAS_ERR_FMT "unable to map "
> >>>>>>>>>> + "adapter memory (resource not found)!\n", ioc->name);
> >>>>>>>>>> + r = -EINVAL;
> >>>>>>>>>> + goto out_fail;
> >>>>>>>>>> + }
> >>>>>>>>>> +
> >>>>>>>>>> _base_mask_interrupts(ioc);
> >>>>>>>>>>
> >>>>>>>>>> r = _base_get_ioc_facts(ioc, CAN_SLEEP);
> >>>>>>>>>
> >>>>>>>>> Just following up on this patch as I have not yet received any
> >>>>>>>>> response.
> >>>>>>>>>
> >>>>>>>>> Thanks!
> >>>>>>>>
> >>>>>>>> Hi Tim -- just curious, why was the similar check on ioc->chip just a
> >>>>>>>> few lines above the one added by the patch insufficient?
> >>>>>>>>
> >>>>>>>> That loop block sets memap_sz when it finds an IORESOURCE_MEM so that it
> >>>>>>>> only sets ioc->chip once. I wonder if the fix might be simpler if the
> >>>>>>>> existing ioc->chip check relocated entirely to where you put it (maybe
> >>>>>>>> also pulling the entire error text onto one line for easier grepping).
> >>>>>>>>
> >>>>>>>> Regards,
> >>>>>>>>
> >>>>>>>> -- Joe
> >>>>>>>
> >>>>>>> If there are no IORESOURCE_MEM resources allocated by the BIOS (i.e. if
> >>>>>>> the BIOS does not run resource allocation on the mpt2sas device) then
> >>>>>>> the check you are referring to is not executed, and the driver attempts
> >>>>>>> to perform operations on a null ioc->chip pointer.
> >>>>>>>
> >>>>>>> I can relocate the check if desired.
> >>>>>>>
> >>>>>>
> >>>>>> On looking more closely at the code I think having the two separate
> >>>>>> checks is useful for debugging.  The first error message is triggered if
> >>>>>> the resource exists but Linux cannot map it for some reason, and the
> >>>>>> second error message is triggered if the resource does not exist at all
> >>>>>> (buggy BIOS).
> >>>>>
> >>>>> Fair enough.  The two error messages are unique, so grepping will lead
> >>>>> to the correct check.
> >>>>>
> >>>>> Only other nits would be the addition of a copyright (up to Avago I
> >>>>> guess) and an mpt3sas version (these drivers are 99% the same code).
> >>>>>
> >>>>> Acked-by: Joe Lawrence<joe.lawrence@stratus.com>
> >>>>>
> >>>>> -- Joe
> >>>>
> >>>>
> >>>>
> >>>
> >>
> >> Thank you for clarifying the guidelines on copyright lines.  I wasn't
> >> sure if this was significant enough of a contribution to justify the
> >> line or not.
> >>
> >> Do I need to re-send or can I just state here that the patch can be
> >> merged without the copyright line?
> >
> > It's easier if you send a clean copy rather than risk me botching
> > something in the hand edit.
> 
> OK, will do.
> 
> >> I don't have any mpt3sas hardware to test with; should I just send in a
> >> patch anyway without a Tested-by line?
> >
> > Well, if you haven't actually tested it, adding a tested-by line
> > wouldn't be correct.
> 
> Of course not.  My question was, should I send in a patch anyway (with 
> appropriate commit message fields) even though it has not been tested?

You mean do you need to retest for a non-material change to a patch
still to have a tested-by on it?  Ideally, yes, but as long as there are
no actual code changes, I don't think it's required.

James


