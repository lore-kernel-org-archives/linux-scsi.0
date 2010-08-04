From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH resend 1/4] scsi/sr: add no_read_disc_info scsi_device
 flag
Date: Wed, 4 Aug 2010 10:41:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1008041032420.1998-100000@iolanthe.rowland.org>
References: <20100803224207.GA8682@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100803224207.GA8682-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 3 Aug 2010, Matthew Dharm wrote:

> I'm willing to bet there are more devices out there like this.  Experience
> has shown that the more we make the stack issue commands to the device like
> one of the "popular" OSes, the fewer problems we have.  Thus, I prefer to
> fix these where commands originate.

This is a good point.  Since Windows apparently never sends 
READ_DISC_INFO commands, we court trouble by using those commands in 
the cdrom driver.  Is there any way to avoid using them?

As far as the READ-CAPACITY(16) bug, there may be a simpler fix.  In
sd_read_capacity(), change

	if (sdp->fix_capacity ||

to

	if ((sdp->fix_capacity && sdkp->capacity > 0) ||

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
