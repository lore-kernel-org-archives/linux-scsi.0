From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Tue, 28 Sep 2010 18:56:09 -0700
Message-ID: <20100929015609.GA27861@kroah.com>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com> <1285668896-6356-2-git-send-email-willy@linux.intel.com> <20100928175122.GE25677@one-eyed-alien.net> <20100928181134.GA17657@kroah.com> <20100928185236.GF25677@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:39556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab0I2CB7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 22:01:59 -0400
Content-Disposition: inline
In-Reply-To: <20100928185236.GF25677@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, sarah.a.sharp@linux.intel.com, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Tue, Sep 28, 2010 at 11:52:36AM -0700, Matthew Dharm wrote:
> On Tue, Sep 28, 2010 at 11:11:34AM -0700, Greg KH wrote:
> > On Tue, Sep 28, 2010 at 10:51:22AM -0700, Matthew Dharm wrote:
> > > On Tue, Sep 28, 2010 at 06:14:56AM -0400, Matthew Wilcox wrote:
> > > > From: Matthew Wilcox <matthew.r.wilcox@intel.com>
> > > > 
> > > > USB Attached SCSI is a new protocol specified jointly by the SCSI T10
> > > > committee and the USB Implementors Forum.
> > > > 
> > > > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > > > ---
> > > >  MAINTAINERS                  |    8 +
> > > >  drivers/usb/storage/Kconfig  |   13 +
> > > >  drivers/usb/storage/Makefile |    1 +
> > > >  drivers/usb/storage/uas.c    |  751 ++++++++++++++++++++++++++++++++++++++++++
> > > >  4 files changed, 773 insertions(+), 0 deletions(-)
> > > >  create mode 100644 drivers/usb/storage/uas.c
> > > 
> > > Given that this is distinctly not usb-storage, and it is entirely contained
> > > within a single file, does it really belong in the drivers/usb/storage
> > > directory?
> > > 
> > > That just seems like a plan for confusion.  The fact that there is a big
> > > "this is not usb-storage" message in the comments of uas.c would seem to
> > > support this position.
> > > 
> > > Given that it is a single file, I would put it in drivers/usb directly.  If
> > > you wanted your own directory for possible future refactoring into multiple
> > > files or addid other files (like usb-storage did to support oddball
> > > devices), then maybe create a drivers/usb/uas directory.
> > 
> > What about drivers/usb/class/ where a number of other USB class drivers
> > live.  That would make more sense, right?
> 
> No argument from me.  Heck, maybe someone wants to move usb-storage into
> that directory also?

Heh, nah, that's not needed :)

> My main point is that it doesn't belong in the same directory as
> usb-storage.  There are lots of good alternatives.

Actually it will need to tie into libusual as the driver is going to
need to unbind the "older" protocol on the device to get usb-storage to
not control it anymore and switch to the uas driver.  So I think it will
need to be in this directory.

thanks,

greg k-h
