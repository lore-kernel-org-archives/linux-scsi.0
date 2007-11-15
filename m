From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: 2.6.24-rc2-mm1
Date: Thu, 15 Nov 2007 22:42:53 +0100
Message-ID: <473CBD5D.5060407@googlemail.com>
References: <473A678C.2020507@googlemail.com> <20071114034924.GA26048@kroah.com> <20071114043923.GK6089@one-eyed-alien.net> <473A88B3.3010303@googlemail.com> <20071114082332.GM6089@one-eyed-alien.net> <473ABE7D.6060703@googlemail.com> <20071115171508.GQ6089@one-eyed-alien.net> <473C8C97.9030707@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:37453 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbXKOVnA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 16:43:00 -0500
Received: by nf-out-0910.google.com with SMTP id g13so624371nfb
        for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 13:42:58 -0800 (PST)
In-Reply-To: <473C8C97.9030707@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, bk@suse.de, khali@linux-fr.org, James <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> On Thu, Nov 15 2007 at 19:15 +0200, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
>> On Wed, Nov 14, 2007 at 10:23:09AM +0100, Gabriel C wrote:
>>> Matthew Dharm wrote:
>>>> On Wed, Nov 14, 2007 at 06:33:39AM +0100, Gabriel C wrote:
>>>>> Matthew Dharm wrote:
>>>>>> On Tue, Nov 13, 2007 at 07:49:24PM -0800, Greg KH wrote:
>>>>>>> Matt, are these the errors you were worried about with the patch we were
>>>>>>> just talking about tha tis in my tree?
>>>>>> I can't tell from these logs.
>>>>> There is the dmesg with CONFIG_USB_STORAGE_DEBUG :
>>>>>
>>>>> http://194.231.229.228/dmesg-2.6.24-rc2-mm1
>>>> Good news: This isn't the bug Greg was worried about.
>>>>
>>>> Bad news: Something is seriously strange here.  Note the following from the
>>>> logs:
>>>>
>>>> Nov 14 06:07:43 lara [   41.890614] usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
>>>> Nov 14 06:07:43 lara [   41.890616] usb-storage: -- unexpectedly short transfer
>>>>
>>>> Note the 'R' value of zero -- this is the residue value.  It indicates a
>>>> complete transfer, and that matches the log lines immediately previous
>>>> which indicate a 4K transfer which completed properly.
>>>>
>>>> If residue is zero, then srb->resid should be zero.  Take a look in
>>>> linux/usb/storage/transport.c in usb_stor_Bulk_transport()
>>>>
>>>> If srb->resid is zero, then you should NEVER get the "unexpectedly short
>>>> transfer" message.  Look at usb_stor_invoke_transport() in the same file.
>>> That code got replaced recently but I have no idea about it.
>>>
>>> ( http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=shortlog  see the patches from Boaz Harrosh) 
>>>
>>> srb->resid got replaced by scsi_get_resid() it I see that right.
>>>
>>> I'm CC'ing the author , he will know I think.
>> The replacement looks, to my eye, to be logically correct.  The patch was
>> pretty clean.
>>
>> Then again, I haven't looked at what is "under the hood" of the accessor
>> functions.  Perhaps there is a side-effect somewhere in there?
>>
>> Perhaps a quick debugging test -- print the value of scsi_get_resid(srb)
>> just after it's initialized to zero at the top of
>> usb_stor_invoke_transport(), and then just after the call to
>> us->transport().
>>
> 
> I have found the bug. My bad sorry about that. Patch below
> It is because I switched from use of usb_stor_bulk_transfer_sg()
> to usb_stor_bulk_transfer_sglist, but forgot the residual handling.


Your patch fixes the problem. Thx.

> 
> (Please send scsi bugs to scsi list. My lkml mental filters are
> much higher, Sorry for not seeing this yesterday)

Uhh sorry I forgot to CC linux-scsi =)


> 
> ----
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Thu, 15 Nov 2007 20:07:56 +0200
> Subject: [PATCH] Fix bug in last usb accessor patch
> 
>>>> Bad news: Something is seriously strange here.  Note the following from the
>>>> logs:
>>>>
>>>> Nov 14 06:07:43 lara [   41.890614] usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
>>>> Nov 14 06:07:43 lara [   41.890616] usb-storage: -- unexpectedly short transfer
>>>>
>>>> Note the 'R' value of zero -- this is the residue value.  It indicates a
>>>> complete transfer, and that matches the log lines immediately previous
>>>> which indicate a 4K transfer which completed properly.
>>>>
>>>> If residue is zero, then srb->resid should be zero.  Take a look in
>>>> linux/usb/storage/transport.c in usb_stor_Bulk_transport()
>>>>
>>>> If srb->resid is zero, then you should NEVER get the "unexpectedly short
>>>> transfer" message.  Look at usb_stor_invoke_transport() in the same file.
>>> That code got replaced recently but I have no idea about it.
> 
>   wrong resid handling fixed
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/usb/storage/transport.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
> index d3a84a2..d9f4912 100644
> --- a/drivers/usb/storage/transport.c
> +++ b/drivers/usb/storage/transport.c
> @@ -465,11 +465,12 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
>  int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
>  		      struct scsi_cmnd* srb)
>  {
> -	int resid = scsi_get_resid(srb);
> +	unsigned int partial;
>  	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
>  				      scsi_sg_count(srb), scsi_bufflen(srb),
> -				      &resid);
> -	scsi_set_resid(srb, resid);
> +				      &partial);
> +
> +	scsi_set_resid(srb, scsi_bufflen(srb) - partial);
>  	return result;
>  }
>  
