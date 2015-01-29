From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH 0/17] Clear up bidi command confusion
Date: Thu, 29 Jan 2015 16:56:25 +0200
Message-ID: <54CA4A19.2090905@plexistor.com>
References: <54C2390A.3000700@sandisk.com>	 <20150123131249.GA8045@infradead.org> <54CA2EDF.7060405@plexistor.com> <1422542489.2091.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64509 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbA2O43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 09:56:29 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so27445585wiv.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2015 06:56:27 -0800 (PST)
In-Reply-To: <1422542489.2091.2.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/29/2015 04:41 PM, James Bottomley wrote:
> On Thu, 2015-01-29 at 15:00 +0200, Boaz Harrosh wrote:
>> On 01/23/2015 03:12 PM, Christoph Hellwig wrote:
>>> On Fri, Jan 23, 2015 at 01:05:30PM +0100, Bart Van Assche wrote:
>>>> There is some confusion in the SCSI core and in SCSI LLDs around the
>>>> meaning of sc_data_direction and whether or not this member can have the
>>>> value DMA_BIDIRECTIONAL. Clear up this confusion. The patches in this
>>>> series are:
>>>
>>> I wonder if we should change the code to set DMA_BIDIRECTIONAL for
>>> bidi commands.  That seems a lot more logical than the current
>>> version.
>>>
>>
>> You cannot do this. Because a Bidi Command is actually two commands
>> one for the WRITE side (DMA_TO_DEVICE) which is this one, and another
>> command for the READ side (DMA_FROM_DEVICE).
> 
> You're not thinking about this the correct way.  DMA_BIDIRECTIONAL is a
> DMA engine flag.  We use it in SCSI for historical reasons (mainly to
> prevent a translation from the SCSI version).  Since it was never used,
> most SCSI drivers have code to check and reject commands with it set.
> For actual bidirectional commands, you have to check scsi_bidi_command()
> and programme the DMA engine separately for both phases, so the flag is
> useless in this case.
> 

This is what I meant how is above different from what I said?

> The proposal is to make it the signal for bidirectional commands

This I disagree, and would be a very bad idea and will take us back, to
hacking time. As you noted, please let us leave DMA_BIDIRECTIONAL to the
DMA engines. Let us just stir away from the DMA_XXX flags altogether and
move back to block layer flags. 

 (in which case most HBAs would make it do the right thing; i.e. reject) 

This is not necessary, (the check and rejection), commands will not be issued
to LLDs that did not mark support for BiDi. So they will never receive
such commands and it is added dead code.

> but
> it still wouldn't be how you'd program the DMA enigne; that still would
> have to be done in two phases as it is today.
> 

Exactly my point. Only one small correction, these are not two phases, as in
phases-1 then phases-2. These are "two" memory buffers independently programmed
for DMA transfer. The actual transfer occurs simultaneously, on both buffers.

> James
> 
> 

Thanks
Boaz

