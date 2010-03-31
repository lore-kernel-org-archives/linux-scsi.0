From: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 18:58:07 +0200
Message-ID: <20100331165807.GA20547@tango.0pointer.de>
References: <Pine.LNX.4.44L0.1003311054500.1739-100000@iolanthe.rowland.org>
 <1270048801.16657.8.camel@localhost.localdomain>
 <4BB37454.8070808@interlog.com>
 <1270053444.16657.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1270053444.16657.17.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Zeuthen <david-o55+BOBDEFg@public.gmane.org>
Cc: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 31.03.10 12:37, David Zeuthen (david-o55+BOBDEFg@public.gmane.org) wrote:

> > > and this definitely runs for this USB device assuming removable is 0 in
> > > sysfs. Perhaps http://bugs.freedesktop.org/show_bug.cgi?id=25673 is
> > > related? Maybe try with the latest libatasmart?
> > 
> > Since the sequence of commands was IDENTIFY DEVICE,
> > SET FEATURES then IDENTIFY DEVICE again my guess is
> > that SET FEATURES caused the problem. Why would a
> > program called ata_id try to change the state of
> > the device?
> 
> As I said above, I don't think it's ata_id that is the problem - I think
> it's udisks-probe-ata-smart, via libatasmart, that is responsible for
> submitting the SET FEATURES command:
> 
> http://git.0pointer.de/?p=libatasmart.git;a=blob;f=atasmart.c;h=a4b60c0eedf8e4f1ebafd932b7070c030459ef16;hb=HEAD#l2561
> 
> when it finds out that the SMART feature is available, yet not turned
> on. I actually don't think libatasmart has any business making such
> decisions on behalf of the user... Lennart, any chance we can stop
> libatasmart from doing this? Thanks.

Uh. I think it definitely needs to call this. I am pretty sure most USB
HDDs you plug in have SMART disabled by default until libatasmart
enables it. So, libatasmart would stop enabling it automatically you'd
end up with no SMART at all for these devices.

Also, on my desktop here, when you reset the BIOS settings to the
defaults, SMART is off. So, that means that somebody needs to enable
SMART from Linux, and who should do that if not libatasmart?

if that device chokes on SETFEATURES then we might need to blacklist
that, not disabled SMART for all devices right-away...

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
