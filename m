From: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst [NEW HARDWARE]
Date: Tue, 14 Jan 2014 09:20:56 -0800
Message-ID: <20140114172056.GB12126@xanatos>
References: <20140109235045.GA17660@xanatos>
 <52D4791B.3030309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52D4791B.3030309-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: walt <w41ter-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 13, 2014 at 03:39:07PM -0800, walt wrote:
> On 01/09/2014 03:50 PM, Sarah Sharp wrote:
> 
> >>> On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
> >>
> >> I've wondered if my xhci problems might be caused by hardware quirks, and
> >> wondering why I seem to be the only one who has this problem.
> >>
> >> Maybe I could "take one for the team" by buying new hardware toys that I
> >> don't really need but I could use to test the xhci driver?  (I do enjoy
> >> buying new toys, necessary, or, um, maybe not :)
> > 
> > It would be appreciated if you could see if your device causes other
> > host controllers to fail.  Who am I to keep a geek from new toys? ;)
> 
> Sarah, I just fixed my xhci bug for US$19.99 :)
> 
> #lspci | tail -1
> 04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)
> 
> This new NEC usb3 controller does everything the ASMedia controller should have
> done from the start.  I can even power-up the outboard usb3 disk docking station
> after the computer is running and still everything Just Works :)
> 
> I appreciate all the debugging work you've done to fix the ASMedia problem but
> I think it's time to quit now.  If hundreds of irate linux users complain about
> the same bug then I'll be happy to test more patches.

I just got a similar report from someone with a Fresco Logic host
controller, so I may need you to test a work-around patch for the
ASMedia host at some point.

I'm considering disabling the effect of David's patch for those two host
controllers.  That will mean USB storage works fine, but USB ethernet
may fail.

I had considered just disabling scatter-gather for the hosts, but we can
still run into the ethernet issue if we need to break a TRB at a 64KB
boundary.  So disabling scatter-gather would make USB ethernet work
_most of the time_, but fail intermittently, and USB storage performance
would be impacted.  Since USB ethernet will fail in either case, I would
rather keep USB storage performance and sacrifice USB ethernet on those
particular hosts.

So please keep the ASMedia host around for testing, if possible.

Sarah Sharp
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
