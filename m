From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] UAS driver
Date: Tue, 28 Sep 2010 02:45:49 -0400
Message-ID: <20100928064549.GD3799@linux.intel.com>
References: <20100928050733.GB3799@linux.intel.com>
 <20100928055649.GB8922@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1623 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab0I1Gp7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 02:45:59 -0400
Content-Disposition: inline
In-Reply-To: <20100928055649.GB8922@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>

On Mon, Sep 27, 2010 at 10:56:49PM -0700, Greg KH wrote:
> On Tue, Sep 28, 2010 at 01:07:34AM -0400, Matthew Wilcox wrote:
> > +static struct usb_device_id uas_usb_ids[] = {
> > +	{ USB_INTERFACE_INFO(8, 6, 0x50) },
> > +	{ USB_INTERFACE_INFO(8, 6, 0x62) },
> > +	{ USB_INTERFACE_INFO(8, 6, 0xaa) }, /* A prototype */
> > +	{ }
> 
> Don't we have the proper #defines in the usb/ch9.h file that you can use
> here?  If not, please add them so that we don't have "magic" numbers.

We've got
#define USB_CLASS_MASS_STORAGE          8
in usb/ch9.h, which I can use.

The other numbers are in include/linux/usb_usual.h, which is actually a pain
to include (I haven't figured out everything I need to do to include it).

What I'd like to do is pull the subclasses and protocols out into a new
include file, include/linux/usb/storage.h to match audio.h.  Would you be
likely to accept such a patch?


I don't intend to add 0xaa to a header file ... I see its inclusion in
this driver as a temporary thing, and I'd rather remove support for it
than add it to a header.
