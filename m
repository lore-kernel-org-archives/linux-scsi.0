From: Pekka J Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
Date: Fri, 25 Apr 2008 11:19:02 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0804251116000.758@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org>
 <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <20080424225604.GA18737@kroah.com>
 <20080424233048.GQ16272@one-eyed-alien.net> <Pine.LNX.4.64.0804250921090.27978@sbz-30.cs.Helsinki.FI>
 <20080425070439.GA18915@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080425070439.GA18915-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Dharm <mdharm-kernel-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dsd-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vegardno-6miFZF/5cTBuMpJDpNschA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Matthew,

On Thu, 24 Apr 2008, Matthew Dharm wrote:
> > > This also has all sorts of races between do_mounts 'waiting' and the actual
> > > USB device enumeration.  It's entirely possible that the kernel loads via
> > > BIOS, the USB drivers are loaded, that forces devices to disconnect/reset,
> > > and they take a while to re-enumerate.  During that delay, the kernel gets
> > > to do_mount; now, no devices show in this "waiting for scan" count.

On Fri, Apr 25, 2008 at 09:30:52AM +0300, Pekka J Enberg wrote:
> > So how does that happen? ->storage_probe fails and driver core calls it 
> > later at some point?

On Fri, 25 Apr 2008, Matthew Dharm wrote:
> There's no guarantee that storage_probe is going to get called in a timely
> manner.

How can we add such a guarantee? Don't we have this problem with any other 
storage devices?

			Pekka
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
