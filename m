From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 0/2] mpt2sas,mpt3sas - PCI master abort fixups
Date: Mon, 13 Apr 2015 11:44:05 -0400
Message-ID: <552BE445.8020607@stratus.com>
References: <1419948455-31624-1-git-send-email-joe.lawrence@stratus.com>		 <552B0998.1050808@stratus.com>	 <1428886445.2196.43.camel@HansenPartnership.com>	 <552BCD57.6090509@stratus.com> <1428935880.2314.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o145.mxlogic.net ([208.65.144.78]:49658 "EHLO
	p02c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbbDMPwb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2015 11:52:31 -0400
In-Reply-To: <1428935880.2314.7.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Christoph Hellwig <hch@infradead.org>

On 04/13/2015 10:38 AM, James Bottomley wrote:
> On Mon, 2015-04-13 at 10:06 -0400, Joe Lawrence wrote:
>> On 04/12/2015 08:54 PM, James Bottomley wrote:
>>> On Sun, 2015-04-12 at 20:11 -0400, Joe Lawrence wrote:
>>>> On 12/30/2014 09:07 AM, Joe Lawrence wrote:
>>>>> A colleague noticed that the mpt2 and mpt3sas drivers do not correctly
>>>>> check the PCI master abort pattern in _base_wait_for_doorbell_ack.  This
>>>>> pattern should be checked *prior* to any valid bit patterns, which would
>>>>> always return true since a PCI read on master abort sets all bits high.
>>>>>
>>>>> The second patch adds similar checking to _base_wait_for_doorbell_int and
>>>>> _base_wait_for_doorbell_not_used to avoid potentially long loops around
>>>>> PCI reads.
>>>>>
>>>>> Joe Lawrence (2):
>>>>>   mpt2sas,mpt3sas: correct master-abort checking in doorbell ack
>>>>>   mpt2sas,mpt3sas: additional master abort checks
>>>>>
>>>>>  drivers/scsi/mpt2sas/mpt2sas_base.c |   17 ++++++++++++-----
>>>>>  drivers/scsi/mpt3sas/mpt3sas_base.c |   17 ++++++++++++-----
>>>>>  2 files changed, 24 insertions(+), 10 deletions(-)
>>>>>
>>>>
>>>> Avago ping?
>>>>
>>>> This one was pretty straightforward: check 0xFFFFFFFF *before* any
>>>> individual bit(s), i.e. before reading the doorbell register.
>>>
>>> OK, Joe, explain why this patch is important: what problems could result
>>> from it not being present?  If you convince everyone then no more mpt2/3
>>> sas patches until this is at least commented on and a plan of action
>>> proposed.
>>
>> Hi James,
>>
>> As currently coded:  If the PCI read returns a master abort,
>> _base_wait_for_doorbell_ack will loop until it exhausts its timeout (up
>> to 15 seconds).  Other parts of the driver, like the periodic watchdog
>> or EEH, may detect a similar problem before such a long time and cleanup
>> the mess.  However, complete device removal may be stalled until whoever
>> called _base_wait_for_doorbell_ack is satisfied that it has finished.
> 
> I think we all picked this up from the changelog.  What I meant was in
> what situations might a card get a master abort ... because that's when
> the problem becomes user visible.  It sounds like it's something that
> might not occur very often or is a bit theoretical, is that right?

Got it -- yes, master abort should be an infrequent event.  On Stratus
HW it typically indicates PCI hotplug removal of a device.  We run many
automated removal/add tests, which find corner case bugs and other race
conditions in driver error paths and whatnot.

>> This behavior is not really a bug, but feels like one in the making.
>> Should additional code be introduced, copy/pasted, etc. it may not do
>> what was intended.
>>
>> For future reference, would a repost have been more appropriate?  This
>> changeset was so small that I figured a status ping would have sufficed.
> 
> Either works.  I was just trying to work out what sort of attention
> needs to be paid to the fix based on what sort of problem it fixes for
> the end user.

Ok.  This particular piece of code isn't going to crash the machine or
cause corruption, etc.  It only seemed proper to fix the check that was
already there.

-- Joe
