From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] isd200: Fix memory leak in isd200_get_inquiry_data
Date: Wed, 12 Mar 2008 15:55:29 +0200
Message-ID: <47D7E0D1.8050403@panasas.com>
References: <Pine.LNX.4.44L0.0803111456590.26916-100000@iolanthe.rowland.org> <47D7D580.5060406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:55265 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbYCLN4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 09:56:22 -0400
In-Reply-To: <47D7D580.5060406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>

On Wed, Mar 12 2008 at 15:07 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Tue, Mar 11 2008 at 21:18 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
>> On Tue, 11 Mar 2008, Boaz Harrosh wrote:
>>
>>>> You can first get to the scsi_device in isd200_ata_command().  
>>> I was afraid of that. I don't think I want to call scsi_get_command
>>> from within .queuecommand. I will leave the code hacked as today.
>> What are you talking about?  isd200_ata_command isn't called by 
>> queuecommand.
>>
>>>> The last
>>>> place you can get to the scsi_device (if one exists!) is
>>>> quiesce_and_remove_host() -- but that's part of the core, not specific
>>>> to isd200.
>>>>
>>> Here two, it looks like I need to introduce a new function pointer for isd200
>> Why?  And why do you need to get to the scsi_device in the first place?
>>
>>> I'll leave it for now. Though I know this is not the last I'll see of this driver.
>>>
> 
> OK Now I see isd200_ata_command() is called from a usb.c internal thread.
> 
> What I need to do is call scsi_get_command(scsi_device*) on first invocation.
> Now for the call to scsi_put_command()? At the time of the call to 
> isd200_free_info_ptrs() do you think I still have a valid scsi_device at this point?
> 
> What I will do is this. I will resend my original patch with your comments
> fixed. This is for the 2.6.25-rc. And I will send another patch that uses
> the proper scsi_get/put_command() for testing and inclusion into the 2.6.26 kernel.
> Please ACK on the patch
> 
>>>>> (And one more stupid question. Why does isd200_init_info allocates the info 
>>>>> structure but the isd200_free_info_ptrs does not free it, it kind of
>>>>> limits the way it can be allocated, no?)
>>>> Not at all.  isd200_free_info_ptrs() frees everything pointed to by the
>>>> info structure, and the info structure itself is freed later on by the
>>>> usb-storage core in usb_stor_release_resources().
>>>>
>>> OK so in isd200_get_inquiry_data() at the end near the call to:
>>> 			us->extra_destructor(info);
>>> 			us->extra = NULL;
>>>
>>> It leaks the info.
>> Yes.  The three lines of code there are unnecessary.  You should remove
>> them (and the comment) instead of adding more somewhere else.  Or if
>> you want to keep them, just add a line to kfree(us->extra) before 
>> us->extra is set to NULL.
> 
> How are they unnecessary? who will free them? other wise they will only be
> freed at the very end. And that is only because usb_stor_transparent_scsi_command()
> does not need any us->extra of it's own. But if ever it will, then this code
> buried here will become a leak.
> 
> And I disagree. with your solution. The module that did the allocation should
> do the freeing. The above is just an example of what happens with bad programing
> style. the core should not have attempted a free on a void pointer just so
> protocols can get lazy and not register a destructor. Other wise we do not
> learn from passed mistakes and keep doing the same errors. The free should
> always be at same file right next to the alloc. (And don't get me started
> on the flexibility that enables)
> 
> I keep the patch as it is, I recommend to commit it for solving the leak.
> 

rrr only I cannot do that because the destructor does not have access to the us_data
that contains it. As I said, very ugly. New patch attached.

Boaz
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Tue, 11 Mar 2008 20:30:53 +0200
Subject: [PATCH] isd200: Fix memory leak in isd200_get_inquiry_data

if the inquiry fails then the info structure on
us->extra was not freed.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index ac1764b..2de1f1e 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1231,6 +1231,7 @@ static int isd200_get_inquiry_data( struct us_data *us )
 	    
 			/* Free driver structure */	    
 			us->extra_destructor(info);
+			kfree(info);
 			us->extra = NULL;
 			us->extra_destructor = NULL;
 		}
-- 
1.5.3.3


