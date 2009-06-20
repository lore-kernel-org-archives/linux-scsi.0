From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: generic_make_request fucntion for scsi_disk
Date: Sat, 20 Jun 2009 10:39:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906201032170.12994-100000@netrider.rowland.org>
References: <e42309110906200705j6a731ecay204969f639af5330@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e42309110906200705j6a731ecay204969f639af5330-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ravish Tayal <ravish.tayal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 20 Jun 2009, Ravish Tayal wrote:

> Hello,
> 
> I am debugging Filesystem code for USB mass storage devices.

What part of the filesystem code are you debugging?

Your questions talk about four separate layers: the filesystem, the
block layer, the SCSI layer, and the usb-storage driver.  Normally
people work on only one layer at a time.

Why are you concerned with more than one layer?

>  I need
> help to figure out after generic_make_request how the request is
> placed to scsi disk (sd) requeset queue and than how sd qeueuecommand
> to usb_storeage thread.  (in which context, is it system call context)
> 
> 
> inside generic_make_request
> 
> 1.   q = bdev_get_queue(bio->bi_bdev);  [is sd.c register queue this
> queue or any other scsi file?]

See scsi_alloc_sdev() in scsi_scan.c.  That's where the queue is 
allocated.

> 2.     ret = q->make_request_fn(q, bio);  [which file contain this
> make_request_fn for scsi disk driver (generic)]

scsi_request_fn() is in scsi_lib.c.  You could have found this out by 
yourself very easily with grep.  sd_prep_fn() is in sd.c.

> As per my unsderanding flow is like
> Fat_writepage ->_block_write_full_page --> blkdev_writepage-->
> block_write_full_page-->submit_bh-->generic_make_request ???  (sd ??)
> ----> queuecommand
> 
> Please suggest any sorce file, link or document.

The most relevant source files are scsi_lib.c and scsi.c.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
