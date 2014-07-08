From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Tue, 8 Jul 2014 12:00:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1407081149280.1283-100000@iolanthe.rowland.org>
References: <CANudz+uRd3tRfPN-Fqcj5sSW-xkRSN-gERBP7HhUY_s5gEALbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANudz+uRd3tRfPN-Fqcj5sSW-xkRSN-gERBP7HhUY_s5gEALbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: loody <miloody-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 8 Jul 2014, loody wrote:

> You are correct.
> i can see events_poll_msecs when I change my kernel to 3.8.0
> But the device still disconnect.
> I have some question.
> 1. when I cat  /sys/block/sdX/events, I get the answer as media_change.
>     is there any events type we can choose, such as read capability or inquiry.

The only other event type is eject_request.  But that applies to CD
drives, not disk drives.

> > Probably you don't actually need to do a read.  Simply opening the
> > device file ought to be sufficient.
> 2. the open device you mean is like open(/dev/sda1)?

Yes.  That will send a SCSI TEST UNIT READY command, the same as disk
events polling.  You can use usbmon to verify this.

However, maybe TEST UNIT READY won't work.  Your drive might need to 
see a READ or WRITE command.  If that's the case then neither 
events_poll_msecs nor a simple open() will help.

Have you tried using hdparm with the -B or -S flag?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
