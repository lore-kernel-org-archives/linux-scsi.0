From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] [SCSI] gdth: Allocate sense_buffer to prevent NULL
 pointer dereference
Date: Tue, 11 Mar 2008 14:07:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803111352450.21625-100000@iolanthe.rowland.org>
References: <47D6B050.7070803@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53770 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753533AbYCKSHR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 14:07:17 -0400
In-Reply-To: <47D6B050.7070803@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>

On Tue, 11 Mar 2008, Boaz Harrosh wrote:

> I would like to fix this better by calling scsi_get/put_command but there is 
> something fundamental that bothers me with isd200 driver. I can see that 
> an isd200_info struct is allocated and put on a struct us_data->extra. But 
> as I understand the code, the struct us_data is associated with a scsi_host 
> not a scsi_device. Are we guarantied that we have only one scsi_device 
> per host at all times?
> 
> If not than the resources in isd200_info that are related to a request_queue 
> and are used from a .queuecommand code-path are not thread safe. (Like the
> srb member)
> 
> If Yes, then where in the code initialization sequence is the earliest place I
> can get to a scsi_device. I could do that on first call to .queuecommand but
> I would rather do it in a place that I could use GFP_KERNEL for allocation
> of the extra command? (Same question on the tear down of the scsi_device)

You can first get to the scsi_device in isd200_ata_command().  The last
place you can get to the scsi_device (if one exists!) is
quiesce_and_remove_host() -- but that's part of the core, not specific
to isd200.

> (And one more stupid question. Why does isd200_init_info allocates the info 
> structure but the isd200_free_info_ptrs does not free it, it kind of
> limits the way it can be allocated, no?)

Not at all.  isd200_free_info_ptrs() frees everything pointed to by the
info structure, and the info structure itself is freed later on by the
usb-storage core in usb_stor_release_resources().

If you wanted to free it in isd200_free_info_ptrs() you could; just 
make sure to set us->extra to NULL when you do, to avoid a double-free 
error.

Alan Stern

