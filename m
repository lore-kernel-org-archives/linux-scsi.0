From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] SCSI & usb-storage: add try_rc_10_first flag
Date: Fri, 22 Jun 2012 22:06:52 -0700
Message-ID: <20120623050652.GA27751@kroah.com>
References: <4FDEE8A1.5030200@redhat.com>
 <Pine.LNX.4.44L0.1206201558090.1804-100000@iolanthe.rowland.org>
 <20120620201310.GA8822@kroah.com>
 <1340372398.19210.3.camel@dabdike.int.hansenpartnership.com>
 <1340382187.19210.9.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43267 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab2FWFG4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jun 2012 01:06:56 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so4380631pbb.19
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2012 22:06:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1340382187.19210.9.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Hans de Goede <hdegoede@redhat.com>, Torsten Wohlfarth <towo@siduction.org>, Sturm Flut <sturmflut@lieberbiber.de>, Sergey <sergeyn@gmail.com>, Philippe Valembois - Phil <lephilousophe@users.sourceforge.net>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jun 22, 2012 at 05:23:07PM +0100, James Bottomley wrote:
> On Fri, 2012-06-22 at 14:39 +0100, James Bottomley wrote:
> > On Wed, 2012-06-20 at 13:13 -0700, Greg KH wrote:
> > > On Wed, Jun 20, 2012 at 04:04:19PM -0400, Alan Stern wrote:
> > > > Several bug reports have been received recently for USB mass-storage
> > > > devices that don't handle READ CAPACITY(16) commands properly.  They
> > > > report bogus sizes, in some cases becoming unusable as a result.
> > > > 
> > > > The bugs were triggered by commit
> > > > 09b6b51b0b6c1b9bb61815baf205e4d74c89ff04 (SCSI & usb-storage: add
> > > > flags for VPD pages and REPORT LUNS), which caused usb-storage to stop
> > > > overriding the SCSI level reported by devices.  By default, the sd
> > > > driver will try READ CAPACITY(16) first for any device whose level is
> > > > above SCSI_SPC_2.
> > > > 
> > > > It seems likely that any device large enough to require the use of
> > > > READ CAPACITY(16) (i.e., 2 TB or more) would be able to handle READ
> > > > CAPACITY(10) commands properly.  Indeed, I don't know of any devices
> > > > that don't handle READ CAPACITY(10) properly.
> > > > 
> > > > Therefore this patch (as1559) adds a new flag telling the sd driver
> > > > to try READ CAPACITY(10) before READ CAPACITY(16), and sets this flag
> > > > for every USB mass-storage device.  If a device really is larger than
> > > > 2 TB, sd will fall back to READ CAPACITY(16) just as it used to.
> > > > 
> > > > This fixes Bugzilla #43391.
> > > > 
> > > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > > > Acked-by: Hans de Goede <hdegoede@redhat.com>
> > > > CC: "James E.J. Bottomley" <JBottomley@parallels.com>
> > > > CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
> > > > CC: <stable@vger.kernel.org>
> > > 
> > > James, mind if I take this through my trees?
> > 
> > Actually, you can take 1/2 but I need to do 2/2 as a postmerge.  I
> > foresee a conflict with another patch I'm queuing that needs resolving.
> > 
> > Let me know when you've got 1/2 in and I'll build the postmerge tree.
> 
> Actually, forget I said this ... the postmerge has to be the other way
> around.  

As these will probably make it to Linus before 3.5 is out, why would
that be needed?

Anyway, they are in my tree now, hopefully all should be fine.

thanks,

greg k-h
