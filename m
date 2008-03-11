From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL
 pointer dereference
Date: Tue, 11 Mar 2008 15:18:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803111456590.26916-100000@iolanthe.rowland.org>
References: <47D6D148.1090304@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:59385 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751241AbYCKTSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 15:18:32 -0400
In-Reply-To: <47D6D148.1090304@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>

On Tue, 11 Mar 2008, Boaz Harrosh wrote:

> > You can first get to the scsi_device in isd200_ata_command().  
> 
> I was afraid of that. I don't think I want to call scsi_get_command
> from within .queuecommand. I will leave the code hacked as today.

What are you talking about?  isd200_ata_command isn't called by 
queuecommand.

> > The last
> > place you can get to the scsi_device (if one exists!) is
> > quiesce_and_remove_host() -- but that's part of the core, not specific
> > to isd200.
> > 
> 
> Here two, it looks like I need to introduce a new function pointer for isd200

Why?  And why do you need to get to the scsi_device in the first place?

> I'll leave it for now. Though I know this is not the last I'll see of this driver.
> 
> >> (And one more stupid question. Why does isd200_init_info allocates the info 
> >> structure but the isd200_free_info_ptrs does not free it, it kind of
> >> limits the way it can be allocated, no?)
> > 
> > Not at all.  isd200_free_info_ptrs() frees everything pointed to by the
> > info structure, and the info structure itself is freed later on by the
> > usb-storage core in usb_stor_release_resources().
> > 
> 
> OK so in isd200_get_inquiry_data() at the end near the call to:
> 			us->extra_destructor(info);
> 			us->extra = NULL;
> 
> It leaks the info.

Yes.  The three lines of code there are unnecessary.  You should remove
them (and the comment) instead of adding more somewhere else.  Or if
you want to keep them, just add a line to kfree(us->extra) before 
us->extra is set to NULL.

> Please ACK the first patch sent, so James can put it in scsi-rc-fixes as part
> of the sense_buffer effort for 2.6.25-rc

The first patch is okay except for style violations:

> @@ -294,6 +294,7 @@ struct isd200_info {
>  	unsigned char MaxLUNs;
> 	struct scsi_cmnd srb;
> 	struct scatterlist sg;
> +	u8*	sense_buffer;

This should be

	u8 *sense_buffer;

And

>  			isd200_free_info_ptrs(info);
>  			kfree(info);
>  			retStatus = ISD200_ERROR;
>  		}
> +		else
> +			info->srb.sense_buffer = info->sense_buffer;

The "else" should go on the same line as the closing brace, and it
should have its own opening brace.

Alan Stern

