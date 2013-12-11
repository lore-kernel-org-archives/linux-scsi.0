From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: BTRFS doesn't handle USB device disconnect
Date: Wed, 11 Dec 2013 16:18:17 +0000
Message-ID: <20131211161817.GL9738@carfax.org.uk>
References: <20131211011755.GA3574@xanatos>
 <Pine.LNX.4.44L0.1312111058340.1531-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DheUW4aQn8WJk6WR"
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1312111058340.1531-100000@iolanthe.rowland.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org, linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--DheUW4aQn8WJk6WR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2013 at 11:03:09AM -0500, Alan Stern wrote:
> On Tue, 10 Dec 2013, Sarah Sharp wrote:
> 
> > In order to stress test the uas driver (next-gen USB storage driver), I
> > decided to run some tests with a USB 3.0 storage device with four 10GB
> > partitions: BTRFS, ext3, ext4, and fat32.
> > 
> > It seems that BTRFS doesn't handle unexpected USB disconnect very well.
> > Is that expected behavior?

   It's something that's been known about for a while, but is clearly
undesirable behaviour. I don't think anyone with the detailed
knowledge of the FS code has investigated in enough depth to get to
the point of proposing patches. I suspect it's just not shown up with
enough disastrous consequences to bubble to the top of the stack of
things to fix yet.

   I think we're still at the point of "you can use USB if you like,
but don't be surprised if, sometimes, Bad Things happen when the bus
disconnects briefly".

   The problems you show below do look quite like the kind of things
we've seen btrfs doing on USB disconnects, so on only this evidence I
wouldn't be quick to point any fingers at the USB layer (unless other
filesystems corroborate the behaviour).

   Hugo.

   (I'm not a btrfs developer, but I do a reasonable amount of
first-line support for it on IRC and linux-btrfs; we see these things
every week or two).

> > The BTRFS partition was created on an Ubuntu 13.10 system, with
> > btrfs-tools version 0.19+20130705-1.
> > 
> > On 3.12-rc6, if all partitions are mounted, and I yank the USB cable,
> > the BTRFS filesystem still shows up as mounted.  If I yank it multiple
> > times, sometimes it's listed twice when the device is disconnected:
> > 
> > /dev/sdb3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e4 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
> > /dev/sdc3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e41 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
> > 
> > Sometimes (but not always) when I plug it back in, I can get /dev/sdc3
> > listed twice:
> > 
> > /dev/sdb3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e4 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
> > /dev/sdc3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e42 type btrfs (rw,nosuid,nodev,uhelper=udisks2)
> > /dev/sdc1 on /media/sarah/ext3-part type ext3 (rw,nosuid,nodev,uhelper=udisks2)
> > /dev/sdc2 on /media/sarah/ext4-part type ext4 (rw,nosuid,nodev,uhelper=udisks2)
> > /dev/sdc4 on /media/sarah/fat32-part type vfat (rw,nosuid,nodev,uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush,uhelper=udisks2)
> > /dev/sdc3 on /media/sarah/9f21ef28-0eac-4736-9964-db5378b877e41 type btrfs (rw,nosuid,nodev,uhelper=udisks2)

> > On 3.13-rc1, the btrfs partion from the disconnected USB device
> > continues to be listed as mounted.  Yanking the cable produces some
> > additional oops messages.  It also produced a couple hard-hangs.
> > Unfortunately, I didn't capture the dmesg during the hard-hangs, so I
> > can't tell for sure which driver is to blame (uas, btrfs, or xhci).
> 
> Does this happen with usb-storage instead of uas?
> 
> What about with ehci-hcd instead of xhci-hcd?
> 
> And just to be exotic, what about with dummy-hcd and the uas or
> g_mass_storage gadget driver?

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- UNIX: British manufacturer of modular shelving units. ---      

--DheUW4aQn8WJk6WR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUqiQSVheFHXiqx3kAQLK+g//ckRFICvgTZSjj+vEZHLnnAZ8VTPzGvwT
GFAziaoyBxXh95WQPyQDPg/rEyzrxiWg+maRboUO0jzrNs1t80KYDk8MtAgPHy/2
px6k/MneQDJGaHiI4UDufGeqp/Vp8WVZ26qgh29kslKDIm28g+PMF9FNOkqX5gKW
1GvqC9hxU0zlJ8CyhbHI5g+5jvXhgfrLW7wdBgiT0h3dT0/LJzqxAJ7gtiAwTOBU
CvF9V8AwUyOytFXYNH9ozeMJ9S9t8kRR9vkfEAtVcAZv+QaMJ5tCCjliHon67i40
SNO0TOMynsTcPnquFuEW8OIzIumWKA2xrYMlJnUb+xv/AEGDBwP/PXu+JtnLdjTt
cT8Zi42gsFwhE309qwkJ4/t7FHMDNflw0u/51iRwi1XWnQegZuPkvri1ckgy40OQ
UZgMH08KCaoj77FdSkqoq70SsQiYs7ZYuPram2OIc/znLTBQEoY612nUdFdTAVq2
OIupO8jUMaU2tn5lgV+ndi/eRog9Ph39M5/2NNMHo93+gY0qBuGkp3t3Q/2WCkgN
5inPmaLunjhsuB3yj9wmui4a5Fh8TL+Jzfa0MpYCg0yh11VPqK1C1TucFk4/ez8Z
MttO/KX83Y+ea2ZHXEbBw5yKfnqVlnhG7ETDZg2Eooh+ZOwpWGLsPZIgHw8vGkfL
iUQ1KZ9FgkE=
=Ptdu
-----END PGP SIGNATURE-----

--DheUW4aQn8WJk6WR--
