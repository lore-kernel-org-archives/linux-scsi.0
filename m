From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Tue, 11 Mar 2008 16:09:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803111543220.26916-100000@iolanthe.rowland.org>
References: <20080311070956E.tomof@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080311070956E.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: bharrosh@panasas.com, linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 11 Mar 2008, FUJITA Tomonori wrote:

> On Mon, 10 Mar 2008 16:10:36 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:

> > Have you had a look at drivers/usb/storage/protocol.c usb_stor_access_xfer_buf() ?
> > It looks like it could also use these, but there they have a twist where they want
> > to do it in parts. Do you think that the code there could also use the helpers 
> > presented here somehow? (I know that one of the USB guys was asking about it)
> 
> I've not. If the USB people are eager to use the new APIs, I'll try
> though I prefer to keep them simple.

It would be great if the code could be removed from usb-storage and put
in a central library.  The problem is, as Boaz mentioned, that some of
the subdrivers need to transfer their data in pieces.

It may be that the device is able to send or receive only a few blocks 
at a time, or it may be that the blocks aren't stored in continguous 
locations on the device.  Either way, the drivers need to do multiple 
transfers, each starting from where the previous one left off.

It shouldn't be too hard to adjust your code to make this work.  
Instead of passing sgl and nents directly to sg_copy_buffer(), pass a
pointer to a structure containing fields for sgl, nents, n, sg_off, and
sg_copy.  Then the caller could retain the ending values for use in a
later call.

Does this sound reasonable?

Alan Stern

