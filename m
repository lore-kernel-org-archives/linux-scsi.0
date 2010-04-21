From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 10:53:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004211032460.1728-100000@iolanthe.rowland.org>
References: <1271859728.2893.72.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1271859728.2893.72.camel-0iu6Cu4xQGLYCGPCin2YbQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Cc: Mark Lord <mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dinh.Nguyen-KZfg59tc24xl57MIdRCFDg@public.gmane.org, Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Apr 2010, James Bottomley wrote:

> > That said.. what would you recommend as a way for a userspace
> > program to figure out whether to use ATA_12 or ATA_16 to talk
> > to a given arbitrary device name ?
> 
> To be honest, no.  For USB, All USB is SCSI or RBC command based. You
> don't have any idea whether it's a real SCSI device or an ATA device
> behind a SAT  ... the only reason you assume it's ATA is because USB
> gadget builders tend to be cheapskates.
> 
> > I guess the info is in sysfs somewhere.
> 
> Only for direct interconnects.  For USB most bets are off.

You can find out whether the device might be MMC by sending an ordinary
SCSI INQUIRY command.  (Or you can get the device type from the
"modalias" attribute file in the device's sysfs directory, which just
shows the information the kernel got when _it_ sent an INQUIRY
command.)  If it might be MMC, _don't_ try to use ATA_12!

The interpretation of the commands sent from hdparm is done by the
device's bridge chip.  In theory these chips can apply different
translations depending on whether the attached drive is ATA or ATAPI.  
I don't know if any existing bridge chips behave this way, though --
and either way, I don't know how a program can figure out what type the
drive is.  Especially since the bridge chip isn't obliged to understand 
SAT in the first place.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
