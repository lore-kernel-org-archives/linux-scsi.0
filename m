From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer
 dereference
Date: Tue, 11 Mar 2008 20:36:56 +0200
Message-ID: <47D6D148.1090304@panasas.com>
References: <Pine.LNX.4.44L0.0803111352450.21625-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:40932 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYCKSiG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 14:38:06 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803111352450.21625-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>

On Tue, Mar 11 2008 at 20:07 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 11 Mar 2008, Boaz Harrosh wrote:
> 
>> I would like to fix this better by calling scsi_get/put_command but there is 
>> something fundamental that bothers me with isd200 driver. I can see that 
>> an isd200_info struct is allocated and put on a struct us_data->extra. But 
>> as I understand the code, the struct us_data is associated with a scsi_host 
>> not a scsi_device. Are we guarantied that we have only one scsi_device 
>> per host at all times?
>>
>> If not than the resources in isd200_info that are related to a request_queue 
>> and are used from a .queuecommand code-path are not thread safe. (Like the
>> srb member)
>>
>> If Yes, then where in the code initialization sequence is the earliest place I
>> can get to a scsi_device. I could do that on first call to .queuecommand but
>> I would rather do it in a place that I could use GFP_KERNEL for allocation
>> of the extra command? (Same question on the tear down of the scsi_device)
> 
> You can first get to the scsi_device in isd200_ata_command().  

I was afraid of that. I don't think I want to call scsi_get_command
from within .queuecommand. I will leave the code hacked as today.

> The last
> place you can get to the scsi_device (if one exists!) is
> quiesce_and_remove_host() -- but that's part of the core, not specific
> to isd200.
> 

Here two, it looks like I need to introduce a new function pointer for isd200
I'll leave it for now. Though I know this is not the last I'll see of this driver.

>> (And one more stupid question. Why does isd200_init_info allocates the info 
>> structure but the isd200_free_info_ptrs does not free it, it kind of
>> limits the way it can be allocated, no?)
> 
> Not at all.  isd200_free_info_ptrs() frees everything pointed to by the
> info structure, and the info structure itself is freed later on by the
> usb-storage core in usb_stor_release_resources().
> 

OK so in isd200_get_inquiry_data() at the end near the call to:
			us->extra_destructor(info);
			us->extra = NULL;

It leaks the info.

> If you wanted to free it in isd200_free_info_ptrs() you could; just 
> make sure to set us->extra to NULL when you do, to avoid a double-free 
> error.
> 

Patch attached to fix the above fix

> Alan Stern
> 

Please ACK the first patch sent, so James can put it in scsi-rc-fixes as part
of the sense_buffer effort for 2.6.25-rc

The below patch you can put threw the USB tree, it's for you.
---
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Tue, 11 Mar 2008 20:30:53 +0200
Subject: [PATCH] isd200: Fix memory leak in isd200_get_inquiry_data

if the inquiry fails then the call to us->extra_destructor()
is assumed to also free the info structure. So make that
so in isd200_free_info_ptrs()

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 9eb2cdf..77f4754 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1471,6 +1471,9 @@ static void isd200_free_info_ptrs(void *info_)
 		kfree(info->id);
 		kfree(info->RegsBuf);
 		kfree(info->sense_buffer);
+		kfree(info);
+		us->extra = NULL;
+		us->extra_destructor = NULL;
 	}
 }
 
-- 
1.5.3.3

