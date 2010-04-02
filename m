From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 2 Apr 2010 11:19:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004021114160.1615-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1004021052040.1615-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1004021052040.1615-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Cc: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2 Apr 2010, Alan Stern wrote:

> > Best guess (and it's a guess only) would be that the USB bridge SAT
> > layer doesn't implement ATA_16 and so fails in interesting ways when it
> > comes in.  Does the ATA_12 version of IDENTIFY DEVICE succeed?
> 
> It does.  And in between the two is an ATA_16 SET FEATURES command
> which also (apparently) succeeds.  That is, there is no error
> indication from the device -- but goodness knows if it actually carries
> out the command.

Incidentally, there's a discussion of this problem with input from an
engineer at the company that makes the bridge chip here:

https://bugs.launchpad.net/ubuntu/+source/linux-fsl-imx51/+bug/431963

See comment #25 and later.  He claims that the ATA pass-through command
contains a SECTOR COUNT field of 0 even though it asks for 512 bytes of
IDENTIFY data.  This invalid parameter combination causes the bridge
chip to get confused, and instead of failing gracefully, it messes up
the USB protocol.

Does anybody know where to find out why hdparm is sending an IDENTIFY 
command with invalid parameters?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
