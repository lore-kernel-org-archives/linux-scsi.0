From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: BTRFS doesn't handle USB device disconnect
Date: Wed, 11 Dec 2013 11:03:09 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312111058340.1531-100000@iolanthe.rowland.org>
References: <20131211011755.GA3574@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131211011755.GA3574@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Chris Mason <chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org>, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 10 Dec 2013, Sarah Sharp wrote:

> In order to stress test the uas driver (next-gen USB storage driver), I
> decided to run some tests with a USB 3.0 storage device with four 10GB
> partitions: BTRFS, ext3, ext4, and fat32.
> 
> It seems that BTRFS doesn't handle unexpected USB disconnect very well.
> Is that expected behavior?
> 
> The BTRFS partition was created on an Ubuntu 13.10 system, with
> btrfs-tools version 0.19+20130705-1.
> 
> On 3.12-rc6, if all partitions are mounted, and I yank the USB cable,
> the BTRFS filesystem still shows up as mounted.  If I yank it multiple
> times, sometimes it's listed twice when the device is disconnected:
> 
> /dev/sdb3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e4 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
> /dev/sdc3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e41 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
> 
> Sometimes (but not always) when I plug it back in, I can get /dev/sdc3
> listed twice:
> 
> /dev/sdb3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e4 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
> /dev/sdc3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e42 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
> /dev/sdc1 on /media/sarah/ext3-part type ext3 (rw,nosuid,nodev,uhelper=udisks2)
> /dev/sdc2 on /media/sarah/ext4-part type ext4 (rw,nosuid,nodev,uhelper=udisks2)
> /dev/sdc4 on /media/sarah/fat32-part type vfat (rw,nosuid,nodev,uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush,uhelper=udisks2)
> /dev/sdc3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e41 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
> 
> On 3.13-rc1, the btrfs partion from the disconnected USB device
> continues to be listed as mounted.  Yanking the cable produces some
> additional oops messages.  It also produced a couple hard-hangs.
> Unfortunately, I didn't capture the dmesg during the hard-hangs, so I
> can't tell for sure which driver is to blame (uas, btrfs, or xhci).

Does this happen with usb-storage instead of uas?

What about with ehci-hcd instead of xhci-hcd?

And just to be exotic, what about with dummy-hcd and the uas or
g_mass_storage gadget driver?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
