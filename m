From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Sat, 29 Mar 2003 14:15:13 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030329141512.B10565@one-eyed-alien.net>
References: <20030325100704.GC3868@beaverton.ibm.com> <1048613872.2070.12.camel@mulgrave> <20030325184530.GA1202@beaverton.ibm.com> <1048618939.1790.29.camel@mulgrave> <20030325232920.GB2692@beaverton.ibm.com> <1048779761.1789.21.camel@mulgrave> <20030328173253.A32352@one-eyed-alien.net> <1048948992.21525.1.camel@mulgrave> <20030329125302.A10565@one-eyed-alien.net> <1048974903.21704.313.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1048974903.21704.313.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Mar 29, 2003 at 03:54:59PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 29, 2003 at 03:54:59PM -0600, James Bottomley wrote:
> On Sat, 2003-03-29 at 14:53, Matthew Dharm wrote:
> > My understanding was that I couldn't call set_device_offline with the h=
ost
> > lock held, which is a problem because I need the host lock to traverse =
the
> > device list.
>=20
> The solution we're talking about here is from the user level hotplug
> scripts.  Once we get the remove-single-device fixed, you simply use the
> device hot unplug script to traverse the attached SCSI devices, clean up
> the user land (kill processes, unmount filesystems etc.) and then blow
> the devices away.  After the host has no devices, you should simply be
> able to trigger a host removal from within your driver.

So, the sequence goes something like this:

(1) user removes device, causing disconnect() callback in USB system to be
called

(2) usb-storage driver markes device as gone so as to make all commands
fail immediately, but does nothing else

(3) hotplug script is notified of USB device removal, figures out that this
is a usb-storage device (possibly a USB/SCSI bridge), and invokes the
hot-unplug for SCSI for each SCSI device (after unmount, etc.)  NOTE: I
don't know how hotplug is supposed to be able to identify the bridge case.

(4) SCSI hot-unplugging offlines the device, then removes them.

(5) Someone notices that the dead virtual host has no devices left, and
signals the usb-storage driver that it's safe to unregister?!??!

(6) SCSI mid-layer does cleanup and notifies usb-storage when it is safe to
free resources

(7) usb-storage destroys all structures and completes cleanup

I can see how this all works, except for step #5 -- how does usb-storage
know that it's time to unregister?

This seems awfully complicated... usb -> usb-storage -> userspace -> scsi
-> unknown -> usb-storage -> scsi -> usb-storage is the sequence of events.

It also means that if the hotplug scripts don't do the job right, we can
wind up with lots of dead virtual HBAs lying around.  Not fatal, I guess...
but pretty bad.

Originally we had been talking about usb -> usb-storage -> scsi ->
usb-storage as the sequence.  userspace never got involved except as a
helper -- it was never in the critical path. This also put the
responsibility for faking-out devices that had been detached but not yet
logically removed in one central place -- with this model, each HBA is
responsible for faking-out devices on it's own.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+hhrwIjReC7bSPZARArYjAKCueAGWcGeG56TFH0apLRgEg6BwtgCeNZwb
SsVCyv3H+AVd5nQTwd8bxrg=
=KgUy
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
