From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH resend 1/4] scsi/sr: add no_read_disc_info scsi_device
 flag
Date: Wed, 04 Aug 2010 17:32:41 +0200
Message-ID: <4C598819.3000205@redhat.com>
References: <Pine.LNX.4.44L0.1008041119370.1998-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab0HDP2h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2010 11:28:37 -0400
In-Reply-To: <Pine.LNX.4.44L0.1008041119370.1998-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

Hi,

On 08/04/2010 05:25 PM, Alan Stern wrote:
> On Wed, 4 Aug 2010, Hans de Goede wrote:
>
>> Hi,
>>
>> On 08/04/2010 04:41 PM, Alan Stern wrote:
>>> On Tue, 3 Aug 2010, Matthew Dharm wrote:
>>>
>>>> I'm willing to bet there are more devices out there like this.  Experience
>>>> has shown that the more we make the stack issue commands to the device like
>>>> one of the "popular" OSes, the fewer problems we have.  Thus, I prefer to
>>>> fix these where commands originate.
>>>
>>> This is a good point.  Since Windows apparently never sends
>>> READ_DISC_INFO commands, we court trouble by using those commands in
>>> the cdrom driver.  Is there any way to avoid using them?
>>>
>>> As far as the READ-CAPACITY(16) bug, there may be a simpler fix.  In
>>> sd_read_capacity(), change
>>>
>>> 	if (sdp->fix_capacity ||
>>>
>>> to
>>>
>>> 	if ((sdp->fix_capacity&&   sdkp->capacity>   0) ||
>>
>> That won't work, the trouble happens before fix_capacity comes into play. The
>> overflow is happening inside the mp3 player. When there is no card in the slot
>> the mp3 player tries to report a size of 0. But as scsi get_capacity uses
>> the last sector number, the mp3 player returns its internal size variable -1,
>> resulting in it returning 0xffffffff. This then gets increased by 1 by
>> read_capacity_10 to 0x100000000, which triggers the following bit:
>>
>>                   if ((sizeof(sdkp->capacity)>  4)&&
>>                       (sdkp->capacity>  0xffffffffULL)) {
>>                           int old_sector_size = sector_size;
>>                           sd_printk(KERN_NOTICE, sdkp, "Very big device. "
>>                                           "Trying to use READ CAPACITY(16).\n");
>>                           sector_size = read_capacity_16(sdkp, sdp, buffer);
>>
>> This issues a READ CAPACITY(16) and the mp3 player dies (until reset). Also
>> notice that my sd.c patch for this does more then just stop sd.c from
>> sending READ CAPACITY(16), it also turns a READ CAPACITY(10) answer
>> of 0xffffffff into 0 instead of 0x100000000 when the quirk flag is set.
>
> Okay, so much for that bright idea.
>
> On the other hand, it's clear that the sd driver doesn't even try to
> issue a READ CAPACITY command if there's no medium present.  How come
> this is happening at all?  Does the device report that a card is
> present even when the slot is empty?  Or does it claim not to have
> removable media in the first place?
>

I have not investigated, but this is not something which we can easily fix
with a quirk AFAIK, as some of the LUN's of the device are not removable
and others are, and we don't know if there is a card present or not.

More over I guess (but have not verified) the answer is:
It claims not to have removable media in the first place

Regards,

Hans
