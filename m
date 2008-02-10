From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: scsi: Drivers not ready for sg-chaining
Date: Sun, 10 Feb 2008 18:36:17 +0200
Message-ID: <47AF2801.5060806@panasas.com>
References: <478F8435.5000907@panasas.com>  <478F878F.6040807@panasas.com>	 <1202658166.3136.44.camel@localhost.localdomain>	 <47AF2188.2030400@panasas.com> <1202660210.3136.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10142 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259AbYBJQgY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Feb 2008 11:36:24 -0500
In-Reply-To: <1202660210.3136.51.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Feb 10 2008 at 18:16 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Sun, 2008-02-10 at 18:08 +0200, Boaz Harrosh wrote:
>> My patches *do not* attempt to fix the sg_chaining support. They only
>> make all the drivers that use SG_ALL to use SCSI_MAX_SG_SEGMENTS.
>> One by One, and not globally as your suggestion.
> 
> Yes, I know ... but it does need fixing for the listed drivers.

That is another patchset that its time as not yet come.
Once every thing settles I will send these too.
That's why I put the list as a reminder for me to check upon later.
 
> 
>> This is for two reasons.
>> 1. So drivers can be individually fixed and in the patch that fixes them
>>    they can go back to SG_ALL.
> 
> No, it's so SG_ALL can mean use chaining ... I'm not sure that's
> desirable for the default value.  Particularly for devices that key
> internal sglist arrays off SG_ALL
> 

I have fixed *all* these drivers that are based off SG_ALL for table sizes,
and all other reasons. exactly so the SG_ALL will continue to mean what
it means in English. (And this was triggered by your request)

>> 2. Those drivers that have been using SG_ALL correctly and were converted
>>    to support sg-chaining are not penalized because of bad/old drivers
> 
> I don't see they're penalised this way either ... they just have to set
> a higher value in their host template.
> 

It was you who wanted that to be SG_ALL. I wanted just an hard coded = ~0.

>> 3. Some drivers in this patchset are converted to use a real internal
>>    driver limit. That does not necessarily match SCSI_MAX_SG_SEGMENTS.
>>    In the event that SCSI_MAX_SG_SEGMENTS wants to change.
> 
> Yes, I looked at those they're all either safe or currently (eventually)
> do the right thing.
> 

What ??

>> The bulk of the patchset is very much mechanical and is not dangerous
>> and was ACKed by the more important maintainers. (That is where the
>> changes are more then trivial). So I don't see why they cannot get
>> a proper review and be accepted. Instead of doing the safe but the
>> wrong thing, cross tree.
> 
> What's wrong about this?
> 

I don't want to repeat myself. If it's fine with you, I trust your
final judgment. You are welcome to submit a patch that fixes all the
good drivers that are regressed by your suggestion.

> James
> 
> 

Boaz
