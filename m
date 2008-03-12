From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer
 dereference
Date: Wed, 12 Mar 2008 15:07:12 +0200
Message-ID: <47D7D580.5060406@panasas.com>
References: <Pine.LNX.4.44L0.0803111456590.26916-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:41609 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYCLNId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 09:08:33 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803111456590.26916-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>

On Tue, Mar 11 2008 at 21:18 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 11 Mar 2008, Boaz Harrosh wrote:
> 
>>> You can first get to the scsi_device in isd200_ata_command().  
>> I was afraid of that. I don't think I want to call scsi_get_command
>> from within .queuecommand. I will leave the code hacked as today.
> 
> What are you talking about?  isd200_ata_command isn't called by 
> queuecommand.
> 
>>> The last
>>> place you can get to the scsi_device (if one exists!) is
>>> quiesce_and_remove_host() -- but that's part of the core, not specific
>>> to isd200.
>>>
>> Here two, it looks like I need to introduce a new function pointer for isd200
> 
> Why?  And why do you need to get to the scsi_device in the first place?
> 
>> I'll leave it for now. Though I know this is not the last I'll see of this driver.
>>

OK Now I see isd200_ata_command() is called from a usb.c internal thread.

What I need to do is call scsi_get_command(scsi_device*) on first invocation.
Now for the call to scsi_put_command()? At the time of the call to 
isd200_free_info_ptrs() do you think I still have a valid scsi_device at this point?

What I will do is this. I will resend my original patch with your comments
fixed. This is for the 2.6.25-rc. And I will send another patch that uses
the proper scsi_get/put_command() for testing and inclusion into the 2.6.26 kernel.
Please ACK on the patch

>>>> (And one more stupid question. Why does isd200_init_info allocates the info 
>>>> structure but the isd200_free_info_ptrs does not free it, it kind of
>>>> limits the way it can be allocated, no?)
>>> Not at all.  isd200_free_info_ptrs() frees everything pointed to by the
>>> info structure, and the info structure itself is freed later on by the
>>> usb-storage core in usb_stor_release_resources().
>>>
>> OK so in isd200_get_inquiry_data() at the end near the call to:
>> 			us->extra_destructor(info);
>> 			us->extra = NULL;
>>
>> It leaks the info.
> 
> Yes.  The three lines of code there are unnecessary.  You should remove
> them (and the comment) instead of adding more somewhere else.  Or if
> you want to keep them, just add a line to kfree(us->extra) before 
> us->extra is set to NULL.

How are they unnecessary? who will free them? other wise they will only be
freed at the very end. And that is only because usb_stor_transparent_scsi_command()
does not need any us->extra of it's own. But if ever it will, then this code
buried here will become a leak.

And I disagree. with your solution. The module that did the allocation should
do the freeing. The above is just an example of what happens with bad programing
style. the core should not have attempted a free on a void pointer just so
protocols can get lazy and not register a destructor. Other wise we do not
learn from passed mistakes and keep doing the same errors. The free should
always be at same file right next to the alloc. (And don't get me started
on the flexibility that enables)

I keep the patch as it is, I recommend to commit it for solving the leak.

> 
>> Please ACK the first patch sent, so James can put it in scsi-rc-fixes as part
>> of the sense_buffer effort for 2.6.25-rc
> 
> The first patch is okay except for style violations:
> 
>> @@ -294,6 +294,7 @@ struct isd200_info {
>>  	unsigned char MaxLUNs;
>> 	struct scsi_cmnd srb;
>> 	struct scatterlist sg;
>> +	u8*	sense_buffer;
> 
> This should be
> 
> 	u8 *sense_buffer;
> 
> And
> 
>>  			isd200_free_info_ptrs(info);
>>  			kfree(info);
>>  			retStatus = ISD200_ERROR;
>>  		}
>> +		else
>> +			info->srb.sense_buffer = info->sense_buffer;
> 
> The "else" should go on the same line as the closing brace, and it
> should have its own opening brace.
> 
> Alan Stern
> 
> --

The important sense_buffer bugfix is posted as reply to this mail

Boaz

