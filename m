From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Fri, 1 Oct 2004 12:07:24 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410011142470.1838-100000@ida.rowland.org>
References: <415D0310.6020308@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5892 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264113AbUJAQHZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2004 12:07:25 -0400
In-Reply-To: <415D0310.6020308@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

On Fri, 1 Oct 2004, Hannes Reinecke wrote:

> Ok. (I knew there was something subtle going on).
> What about the check for disconnecting later in 
> usb.c:usb_stor_control_thread?
> It will only trigger if usb_stor_control_thread has been awakened by 
> some other command and the device has been disconnected between 
> awakening and executing this check.

If by "awakened" you mean the call to up(&us->sema), then that's right.  
Remember that there will be some time between the call to up() and when 
the thread starts running.

> (This may well be impossible to trigger,

No, it isn't.  Uncommon yes, but not impossible.

>  but the set_bit() in 
> storage_disconnect() appears not to be protected by any lock).

set_bit, test_bit, test_and_clear_bit, etc. don't need to be protected by
locks because they execute atomically with appropriate memory barriers.  
That's one of the reasons they are useful.

> And I doubt it will work properly in that case as no scsi_done is not 
> called nor a proper status is set.

It's impossible for the control thread to set a status or call scsi_done
because us->srb will point to storage that probably has been deallocated.  
It works correctly nevertheless, because the SCSI core terminates the
command automatically within scsi_remove_host.

> Is this check still needed or can it be removed?

The check is definitely needed.

Here's a diagram to help make things clearer.  Things don't have to 
execute in this order, but it is a possible scenario:

	User unplugs the USB cable and USB core calls storage_disconnect

	SCSI core calls queuecommand

	queuecommand does up(&us->sema);

	storage_disconnect does set_bit(US_FLIDX_DISCONNECTING...)

	storage_disconnect does down(&us->dev_semaphore),
	up(&us->dev_semaphore)

	storage_disconnect calls scsi_remove_host

	The SCSI core terminates the command and deallocates the srb

	usb_stor_control_thread wakes up, sees the DISCONNECTING bit is 
	set, does nothing, and goes back to sleep

Now you see, if that test weren't present then the control thread would 
try to dereference the srb pointer, causing an oops.

Alan Stern

