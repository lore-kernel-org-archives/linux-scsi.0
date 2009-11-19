From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch for 2.6.32? 3/3] scsi: fix another crash at disconnect
 of usb strorage
Date: Thu, 19 Nov 2009 12:57:05 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911191249440.2720-100000@iolanthe.rowland.org>
References: <20091119125947.GB23095@ms2.inr.ac.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44465 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752005AbZKSR5A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2009 12:57:00 -0500
In-Reply-To: <20091119125947.GB23095@ms2.inr.ac.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, den@openvz.org

On Thu, 19 Nov 2009, Alexey Kuznetsov wrote:

> Hello!
> 
> > Alexey, have you seen the patches I posted?
> 
> Sorry, I have not.
> 
> 
> > It does what you want to accomplish and more.
> 
> Yes, it looks like this.
> 
> I am no expert in this area and cannot tell exactly.
> 
> I can only suggest a practical way to test the patch: you take some USB flash
> (the older and the slower is the better, usb1.1 flash is the best),
> then do the following:
> 
>         for (;;) {
> 	        usb_detach_kernel_driver_np(handle, 0);
>         	usleep(1000*(random() % 10000));
> 	        usb_attach_kernel_driver_np(handle, 0);
>         	usleep(1000*(random() % 10000));
>     	}
> 
> (handle is libusb handle for the device)
> 
> Unpatched kernels crash almost instantly.

Using an old kernel without any patches, the test crashed twice: once 
after 10 iterations and once after 49 iterations.  Using a new kernel 
with my patches, the test ran okay for 100 iterations.  Not an 
exhaustive check, to be sure, but a good sign.  The test is rather 
slow, since each iteration requires an average of 10 seconds.

The patches were submitted during October and I still haven't received 
any feedback at all from James Bottomley regarding them.  In fact, 
James hasn't responded to any of my emails for several months.

Andrew, can you do anything to help get these four patches reviewed and 
(hopefully) merged?  They are:

	http://marc.info/?l=linux-scsi&m=125675695827770&w=2
	http://marc.info/?l=linux-scsi&m=125675696627788&w=2
	http://marc.info/?l=linux-scsi&m=125675698027801&w=2
	http://marc.info/?l=linux-scsi&m=125675699627826&w=2

Alan Stern

