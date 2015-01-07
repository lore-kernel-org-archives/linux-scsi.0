From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH v2 0/3] scsi: ufs & ums-*: fix module reference counting
Date: Wed, 7 Jan 2015 10:09:03 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1501071004310.1374-100000@iolanthe.rowland.org>
References: <20150107142830.GA659@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150107142830.GA659-jcswGhMUV9g@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sujit Reddy Thumma <sthumma-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 7 Jan 2015, Christoph Hellwig wrote:

> On Wed, Jan 07, 2015 at 11:02:59PM +0900, Akinobu Mita wrote:
> > While accessing a scsi_device, the use count of the underlying LLDD module
> > is incremented.  The module reference is retrieved through .module field of
> > struct scsi_host_template.
> > 
> > This mapping between scsi_device and underlying LLDD module works well
> > except some scsi drivers (ufs and unusual usb storage drivers).  These
> > drivers consist with core driver and actual LLDDs, and scsi_host_template
> > is defined in the core driver.  So the actual LLDDs can be unloaded even if
> > the scsi_device is being accessed.
> 
> Why don't ufs and usb-storage define the host templates in the sub drivers?
> That's what libata or the mpt fusion driver do.

Originally the subdrivers were all part of usb-storage.  When they were
split out into separate modules, there didn't seem to be any need to
copy the host template into each one.  (Especially since some of the
method pointers in the host template refer to routines in usb-storage
itself, not in the subdrivers.)  The fact that the .module member was
no longer adequate escaped our notice at the time.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
