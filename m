From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Sun, 30 Mar 2003 10:21:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030330102156.B19226@one-eyed-alien.net>
References: <20030325184530.GA1202@beaverton.ibm.com> <1048618939.1790.29.camel@mulgrave> <20030325232920.GB2692@beaverton.ibm.com> <1048779761.1789.21.camel@mulgrave> <20030328173253.A32352@one-eyed-alien.net> <1048948992.21525.1.camel@mulgrave> <20030329125302.A10565@one-eyed-alien.net> <1048974903.21704.313.camel@mulgrave> <20030329141512.B10565@one-eyed-alien.net> <1049041398.21704.1451.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1049041398.21704.1451.camel@mulgrave>; from James.Bottomley@steeleye.com on Sun, Mar 30, 2003 at 10:23:10AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I happen to agree with Oliver on this...

As I see it, what we need to do is support both user-initiated removal and
hardware-initiated removal.  Refcounting should get us pretty far along for
this.

As I see it, when either usb-storage or the userspace tells SCSI that a
device is gone/going away, cleanup should begin.  Since everything is
refcounted, the virtual HBA stays around only long enough for cleanup to
occur.

If the request comes from userspace, then scripts should have made sure to
umount/close/sync everything first.  If the device is just yanked, we
simply don't have that opportunity.

Regardless of where the request comes from, the kernel needs to be able to
handle bad user apps -- if nothing else, some app could ignore the message
from the unplug request (regardless of where it comes from).  If the
userspace script did everything well, there are no references and
everything gets cleaned up.  If some app didn't close a device, the SCSI
layer can just DID_ERROR all commands in the mid-layer while the LLDD has
already cleaned-up -- but this is a case that must be handled!

Forcing usb-storage to go outside of kernelspace and then back into
kernelspace is silly and dangerous.  The potential for DoS or other evil is
just too high.

Matt

On Sun, Mar 30, 2003 at 10:23:10AM -0600, James Bottomley wrote:
> On Sat, 2003-03-29 at 16:15, Matthew Dharm wrote:
> > So, the sequence goes something like this:
> >=20
> > (1) user removes device, causing disconnect() callback in USB system to=
 be
> > called
> >=20
> > (2) usb-storage driver markes device as gone so as to make all commands
> > fail immediately, but does nothing else
> >=20
> > (3) hotplug script is notified of USB device removal, figures out that =
this
> > is a usb-storage device (possibly a USB/SCSI bridge), and invokes the
> > hot-unplug for SCSI for each SCSI device (after unmount, etc.)  NOTE: I
> > don't know how hotplug is supposed to be able to identify the bridge ca=
se.
>=20
> Ideally, yes.  The driver throwing the hotplug event is supposed to be
> able to distinguish between device and bridge removal.
>=20
> > (4) SCSI hot-unplugging offlines the device, then removes them.
> >=20
> > (5) Someone notices that the dead virtual host has no devices left, and
> > signals the usb-storage driver that it's safe to unregister?!??!
>=20
> That's the (unimplemented in scsi) refcounting in the generic device
> core.  In theory, once the struct device belonging to the host's
> refcount decrements to zero (and you trigger this by doing a device_put
> in the first usb remove), it calls the ->release() hook.  The code
> plugged into this hook knows that the devices are gone, so does the
> final USB cleanup (and the scsi host removal).
>=20
> > (6) SCSI mid-layer does cleanup and notifies usb-storage when it is saf=
e to
> > free resources
> >=20
> > (7) usb-storage destroys all structures and completes cleanup
> >=20
> > I can see how this all works, except for step #5 -- how does usb-storage
> > know that it's time to unregister?
> >=20
> > This seems awfully complicated... usb -> usb-storage -> userspace -> sc=
si
> > -> unknown -> usb-storage -> scsi -> usb-storage is the sequence of eve=
nts.
>=20
> Well, USB storage devices with filesystems on top are rather complex
> things to clean up after.
>=20
> > It also means that if the hotplug scripts don't do the job right, we can
> > wind up with lots of dead virtual HBAs lying around.  Not fatal, I gues=
s...
> > but pretty bad.
> >=20
> > Originally we had been talking about usb -> usb-storage -> scsi ->
> > usb-storage as the sequence.  userspace never got involved except as a
> > helper -- it was never in the critical path. This also put the
> > responsibility for faking-out devices that had been detached but not yet
> > logically removed in one central place -- with this model, each HBA is
> > responsible for faking-out devices on it's own.
>=20
> There's just too much specific knowledge to put into the kernel.  Even
> if SCSI were to offline the device, who does something about the filesys
> or other applications using it?  All you gain is moving one step closer
> to the solution, not the solution itself.
>=20
> The way to think about this, I think, is "what would we do if the user
> asked nicely before removing the device" (i.e. requested device ejection
> rather than forced it).  Then the above makes perfect sense because we
> have to start at the top and move down.  Since requested ejection is the
> model for things like hotplug PCI busses, I'm hoping someone else is
> thinking about this.
>=20
> As far as the state of play today, I'm not sure if the SCSI refcounting
> is correct or not.  The SCSI list traversals are certainly racy and
> unsafe, and we have no SCSI hotplug event.
>=20
> This is probably because no-one who develops for SCSI has access to true
> hotplug hardware.  However, we do have other uses for the hotplug
> infrastructure (FC device addition/removal, even SES device handling),
> we're just not entirely sure how to proceed.
>=20
> James
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  They kicked your ass, didn't they?
S:  They were cheating!
					-- The Chief and Stef
User Friendly, 11/19/1997

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+hzXEIjReC7bSPZARAg6LAKCLvc2V3Sh2X2SchM6b07j+KgtOiwCgt2gh
uGWMEeOWaC0zap50sdBW8W4=
=MR6v
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
