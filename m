From: Dirk Hohndel <hohndel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 14:39:44 -0800
Message-ID: <20090128143944.62665eb8@infradead.org>
References: <20090128120129.68d04cd6@infradead.org>
	<Pine.LNX.4.44L0.0901281622210.2231-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0901281622210.2231-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009 16:23:37 -0500 (EST)
Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:

> On Wed, 28 Jan 2009, Dirk Hohndel wrote:
> 
> > Any recommendations how to best approach debugging this? Attaching
> > strace to some processes before inserting the usb stick?
> 
> No really good recommendations.  The guilty party is often hal, so you 
> can try turning off the haldaemon service before plugging in your 
> stick.

I ran with that and figured it out. I rebooted into runlevel 3 and
stopped one daemon after another. udev was the culprit. As part of the
installation of a 3G modem a broken udev script had been installed
(unbeknownst to me). That issued an eject on anything that identified
itself as being removable (it was supposed to only do that for the
specific device but a syntax error in it made it eject any removable
device).

So not a kernel issue at all.

Thanks for all the help tracking this down.

/D


-- 
Dirk Hohndel
Intel Open Source Technology Center
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
