From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 15:25:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123152554.F12788@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="Pgaa2uWPnPrfixyx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200301232339.40892.oliver@neukum.name>; from oliver@neukum.name on Thu, Jan 23, 2003 at 11:39:40PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Doug Ledford <dledford@redhat.com>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--Pgaa2uWPnPrfixyx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Well, I've been watching this go on for days.  I hate to weigh in now, but
I think someone needs to understand what the guy writing the code that is
facing this problem really wants.

First, let me say that a USB storage device shows up as a HBA.  That's
because some devices are actually USB/SCSI bridges.  But, since I work at
the 'emulated host' level, that's where I'm focused.

What I want:

I want to be able to free resources associated with a device within a
finite (and well bounded) amount of time after I am notified that the
device is gone.

I want to be able to inform the SCSI mid-layer, which will then inform
higher layers, that the device is gone.  This is so that all may deal with
this however they want.  I really don't care who does what, as long as we
don't crash.  This implies that all block-type drivers will need to become
hotplug aware, or the SCSI mid-layer will have to fake command failures.

I want to be able to do as little command-trickery as possible.  If I have
to do it, then that means the next hotplug-capable LLDD must do it also.
Duplication of code is bad -- it should all be handled in the mid-layer.

As yet, the interface I have to the SCSI mid-layer fails on all three
points here.

And now, some of my opinions on how this should all work:

It would be nice if the user informed us about removing the device before
they did it.  But we shouldn't crash if they don't.

I don't want to be hanging around after a device is gone, spinning my
wheels because some other part of the kernel can't handle the fact that the
device is gone.  My driver is a passthru between the a SCSI emualted host
and a physical USB device -- if my device is gone, I want to be out of
there.  (Oddly enough, I'm starting to think there may be a DoS attack here
if you force the LLDD to stay -- after all, it consumes memory....)

Remember, the physical plug doesn't ask me if it's okay, and I don't get to
ask the SCSI mid-layer if it's okay.  Yes, starting with the user clicking
to tell us would be nice, but I don't get to see that.  All I get to see is
an indication that the plug is pulled.

I don't really give a rat's a** about 'how SCSI works' or how it's
specified or CAM models or any of that.  I try to live in the real world as
much as possible.  In that world, I'm not asking to remove an HBA -- I'm
telling you it's been removed.  I can't call it back.  I can't even fake a
command (other than perhaps INQUIRY) in any meaningful way.  THERE IS
NOTHING I CAN DO BUT KEEP INSISTING THAT THE DEVICE IS GONE!

It would be nice if the user could inform various parts of the kernel that
this device was going away, and then all sorts of cleanup could happen.
But I really don't care -- all I'm trying to do is exit without a resource
leak under all circumstances.

It would be nice if the SCSI mid-layer kept track of what commands were in
what stages in who's queues.  After all, if I hot-unplug a PCI SCSI
controller, the controller really isn't going to be able to complete those
commands for us -- we have to assume that commands queued by a LLDD are
really just being sent to the hardware for queuing.  If that wasn't the
case, then having LLDD queue capability doesn't make sense.

Now, here's the kicker -- this is what I think Linus wants:

Linus said to me, with a degree of annoyance, that he doesn't want
usb-storage to keep any associations of departed devices with SCSI emulated
hosts.  That means that I need to be able to add and remove hosts at the
will of the end-user.  In the end, what drives the entire process is what
Linus' hand does when it's placed on his USB flashcard reader.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--Pgaa2uWPnPrfixyx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+MHoCIjReC7bSPZARArbPAJ0Y2dzLae21lY9pucJcRabKLCmLZACfU9d7
1BAb94Be9hiU/jtF44q+QqE=
=d0PW
-----END PGP SIGNATURE-----

--Pgaa2uWPnPrfixyx--
