From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Seagate External SMR drive USB resets (was: Re: [PATCH] uas:
 Add US_FL_NO_ATA_1X quirk for one more Seagate device)
Date: Wed, 15 Nov 2017 17:02:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1711151656350.1363-100000@iolanthe.rowland.org>
References: <20171115164902.00d1330d@Vantage.cJ>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115164902.00d1330d-WI5o+PA4G9BYumZHjSPV5A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens <jens-bugzilla.kernel.org-pLZ6rgtf4/bvLhUCWVjhBQ@public.gmane.org>, Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 15 Nov 2017, Jérôme Carretero wrote:

> (Adding Tejun Heo who was assigned on still-open bugzilla #93581 which
> is about SATA but seems terribly related.)
> 
> On Wed, 15 Nov 2017 16:43:14 -0500
> Jérôme Carretero <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org> wrote:
> 
> > Hi Hans,
> > 
> > 
> > Tests are currently undergoing with drives operating in plain USB mass
> > storage class. In a first time, I'm filling drives with data
> > (uncontrolled corpus, just TBs that I have on hand). It looks like the
> > drives with most usage history are the ones that drop most often.
> > 
> > kernel: usb 3-4.1.1: reset SuperSpeed USB device number 6 using
> > xhci_hcd kernel: usb 3-4.2.1: reset SuperSpeed USB device number 7
> > using xhci_hcd kernel: usb 3-4.3.1.1: reset SuperSpeed USB device
> > number 13 using xhci_hcd kernel: usb 3-4.3.2.1: reset SuperSpeed USB
> > device number 14 using xhci_hcd kernel: usb 3-4.4: reset SuperSpeed
> > USB device number 8 using xhci_hcd kernel: usb 6-4.3.2.1: reset
> > SuperSpeed USB device number 8 using xhci_hcd kernel: usb 6-4.3.3.1:
> > reset SuperSpeed USB device number 9 using xhci_hcd kernel: usb
> > 6-4.4.1: reset SuperSpeed USB device number 6 using xhci_hcd
> > 
> > Will provide some more interesting/visual data later.
> > 
> > 
> > I'm surprised that the message "reset SuperSpeed USB device ..." is
> > displayed without prior information about why.
> > Someone with more background could give hints?

usb-storage resets a drive whenever the SCSI layer tells it to or when
a protocol error occurs.  As far as I know, the SCSI layer issues these
resets only when a command has timed out.

> > I took a look at the USB MSC code and have few questions /
> > observations:
> > 
> > - It looks like (haven't tested it yet) the CONFIG_DYNAMIC_DEBUG isn't
> >   used with the USB mass storage debugging infrastructure, please
> >   confirm? If unused, are we interested to have a patch that would go
> >   back to regular pr_debug() that can work with dynamic debugging?

dev_dbg() please, not pr_debug().  But yes, that would be worthwhile.

Note, however, that usb-storage debugging is meant only for debugging
problems in the usb-storage driver itself, not for debugging problems
in attached devices.  We use usbmon or wireshark for the latter.

> >   Because with several of these drives / lots of activity / occasional
> >   issues, it looks like it will be hard to catch (yes I can use
> > usbmon).
> > 
> > - It looks like there is no configurable timeout for USB MSC requests.
> >   Perhaps the device is not responding in time and this is why it's
> >   reset?

Timeouts are set by the SCSI layer.  I believe they are rather long (30 
seconds, by default).  Presumably they are configurable, although I 
would have to do some digging to figure out how.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
