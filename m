From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 15:25:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030124152540.B27859@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301232159.28656.oliver@neukum.name> <20030123213423.GA26415@redhat.com> <200301232339.40892.oliver@neukum.name> <20030123152554.F12788@one-eyed-alien.net> <20030124214831.GA28812@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030124214831.GA28812@redhat.com>; from dledford@redhat.com on Fri, Jan 24, 2003 at 04:48:31PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

So, if I read this correctly, you're saying that the correct sequence is:

(1) get disconnect notification from USB
(2) Call scsi_set_device_offline() (must hold host lock for this)
(3) call scsi_done() for all command in queue (max: 1)
(4) Call scsi_remove_host(), which should now work because no commands are
outstanding
(5) Call scsi_unregister()

And we're done, all structures can be freed.  And, as I understand it, the
following is true:

(a) once (2) is done, no more commands will be queued
(b) once (3) is done, (4) is guaranteed to work
(c) there is nothing the user can do to make this sequence take a long time

Tho, this does leave me with a couple of questions:

(i) Doesn't scsi_set_device_offline() work on devices, not hosts?  How do I
map from my host to my device list?
(ii) Do I need to call scsi_set_device_offline() for each device?  I
presume 'yes'.
(iii) What should I shove into the status field of the scsi command before
I scsi_done() it?

Oh, and as for my being a 'prick'.... my big problem is that the documented
interface is synchronous.  Async is fine with me, but up until this e-mail,
all I've seen is people arguing over what the sequence is, and theoretical
issues of what users should and should not do.  And I also think that a
large number of hotplugable hosts are going to replicate a whole bunch of
code to do (2)+(3)+(4) in one, synchronous burst.

If someone will step forward with a 'yes' or 'no' on this sequence, then
I'll get it done.  If the answer is 'no', then what did I miss?

Matt

On Fri, Jan 24, 2003 at 04:48:31PM -0500, Doug Ledford wrote:
> On Thu, Jan 23, 2003 at 03:25:54PM -0800, Matthew Dharm wrote:
> > Well, I've been watching this go on for days.  I hate to weigh in now, =
but
> > I think someone needs to understand what the guy writing the code that =
is
> > facing this problem really wants.
> >=20
> > First, let me say that a USB storage device shows up as a HBA.  That's
> > because some devices are actually USB/SCSI bridges.  But, since I work =
at
> > the 'emulated host' level, that's where I'm focused.
> >=20
> > What I want:
> >=20
> > I want to be able to free resources associated with a device within a
> > finite (and well bounded) amount of time after I am notified that the
> > device is gone.
>=20
> This is doable.  Partly.  You need to do it within the framework of what=
=20
> the scsi subsys needs, but it can be done.  Basically, the scsi core has=
=20
> an object allocation oriented paridigm where the lldd is expected to act=
=20
> as a driver that handles creation, use, and destruction of objects at the=
=20
> mid layer's direction.  Changing that paridigm would be very difficult. =
=20
> However, we don't need the usb subsys to maintain full state on the devic=
e=20
> once it has gone away, just enough state to be able to talk to the mid=20
> layer and tell it where the outstanding commands are.  Once the mid layer=
=20
> is finally done with it, the mid layer will tell your subsys to do a fina=
l=20
> free of the device by calling your release routine (for hosts) or your=20
> slave_destroy routine (for devices).  So, what you should be doing in=20
> order to be both a nice scsi host that plays well with the generic=20
> mechanism we have in place is when you get this removal event, you should=
=20
> be free'ing all the state you needed about the usb bus and such and takin=
g=20
> this usb device off line or whatever you do.  Then let the scsi mid layer=
=20
> clean up at it's leisure.  You don't need to worry about it because the=
=20
> only thing you will have left is to wait for the scsi subsys to call you=
=20
> when it's time to delete things.  You don't even have to keep device=20
> references around because we pass those in to your deletion routines=20
> anyway.
>=20
> > I want to be able to inform the SCSI mid-layer, which will then inform
> > higher layers, that the device is gone.
>=20
> scsi_set_device_offline() as we've been discussing.
>=20
> >  This is so that all may deal with
> > this however they want.  I really don't care who does what, as long as =
we
> > don't crash.  This implies that all block-type drivers will need to bec=
ome
> > hotplug aware, or the SCSI mid-layer will have to fake command failures.
>=20
> As I stated in my proposed design email, this will already be taken care=
=20
> of.  As long as you call scsi_set_device_offline() while holding the host=
=20
> lock for this host, then there will be no races between this call and the=
=20
> queuecommand() call which should be *all* that you care about.  You will=
=20
> no longer get commands for this device.  Now let me inform you of what th=
e=20
> scsi subsys cares about.  You need to return *all* outstanding commands=
=20
> that this device has in your lldd before you go off and play "my device i=
s=20
> gone so I'm free'ing everything".  That hasn't been the case from what=20
> I've seen, and that's what the scsi subsys needs.  If you don't return=20
> absolutely *all* outstanding commands before you go around free'ing stuff=
,=20
> then what happens is the scsi subsys needs those commands back in order t=
o=20
> free up the scsi structs and it calls into the usb stack to get a reset o=
r=20
> abort on the command and you guys have already free'd up your stuff and=
=20
> you don't claim to know what we are talking about.  At that point, we hav=
e=20
> a permanently stuck device.  This is the part where I said yesterday that=
=20
> you could handle this at the time you set the device offline by adding th=
e=20
> code to return all the commands or you could just let your already presen=
t=20
> error handler code get called by the error handler thread and return the=
=20
> outstanding commands that way.  But, one way or the other, it has to be=
=20
> done.
>=20
> > I want to be able to do as little command-trickery as possible.  If I h=
ave
> > to do it, then that means the next hotplug-capable LLDD must do it also.
> > Duplication of code is bad -- it should all be handled in the mid-layer.
>=20
> No one has to do anything of the sort if you follow what I wrote.  Once=
=20
> the device is marked offline, any further commands already present in the=
=20
> request queue but not yet sent to the device plus any commands that come=
=20
> in to the request queue will all be sent back as I/O errors immediately=
=20
> before ever coming to you.
>=20
> > As yet, the interface I have to the SCSI mid-layer fails on all three
> > points here.
>=20
> SCSI <-> USB interaction is wrong right now.  We know that.
>=20
> > And now, some of my opinions on how this should all work:
> >=20
> > It would be nice if the user informed us about removing the device befo=
re
> > they did it.  But we shouldn't crash if they don't.
>=20
> Correct.
>=20
> > I don't want to be hanging around after a device is gone, spinning my
> > wheels because some other part of the kernel can't handle the fact that=
 the
> > device is gone.  My driver is a passthru between the a SCSI emualted ho=
st
> > and a physical USB device -- if my device is gone, I want to be out of
> > there.  (Oddly enough, I'm starting to think there may be a DoS attack =
here
> > if you force the LLDD to stay -- after all, it consumes memory....)
>=20
> The device will go away.  But, because we clean up multiple things on a=
=20
> host, like an error handler thread that needs to be woke up and we have t=
o=20
> wait for it to run and acknowledge the death, instantaneous removal of al=
l=20
> the structs is simply unrealistic.  Unplugging your internal structs from=
=20
> the actual bus and then letting the scsi subsys clean them up at it's=20
> leisure is possible though, and that's what I'm asking for.
>=20
> > Remember, the physical plug doesn't ask me if it's okay, and I don't ge=
t to
> > ask the SCSI mid-layer if it's okay.  Yes, starting with the user click=
ing
> > to tell us would be nice, but I don't get to see that.  All I get to se=
e is
> > an indication that the plug is pulled.
>=20
> I don't disagree.  But because a plug is pulled has nothing to do with=20
> objects that might hold a reference to your object.  Just because you=20
> *want* it that way doesn't mean it's realistic to actually try and make i=
t=20
> that way.  We can delete an object only after the last reference is=20
> released.
>=20
> > I don't really give a rat's a** about 'how SCSI works' or how it's
> > specified or CAM models or any of that.  I try to live in the real worl=
d as
> > much as possible.  In that world, I'm not asking to remove an HBA -- I'm
> > telling you it's been removed.  I can't call it back.  I can't even fak=
e a
> > command (other than perhaps INQUIRY) in any meaningful way.  THERE IS
> > NOTHING I CAN DO BUT KEEP INSISTING THAT THE DEVICE IS GONE!
>=20
> I wouldn't suggest otherwise.  I'm saying that in the real world of=20
> software design, it doesn't matter if your device is gone or not, if ther=
e=20
> are still references outstanding to the object then a free of that object=
=20
> is a software bug.  Come on now, quit being a prick about all this becaus=
e=20
> you know I'm right on that point.  I'm not asking you to leave shit aroun=
d=20
> forever, I'm asking you guys to work within the generic framework of=20
> object allocation and freeing that already exists in the scsi subsys to=
=20
> get things done.  The real problem is that you guys want this clean up=20
> process to be syncronous and I'm telling you that it's ever so slightly=
=20
> async because we have a couple schedules that have to take place and=20
> possibly a request queue to clean out.  No one seems willing to accept=20
> that a slightly async process is going to be OK.  Whatever.
>=20
> > It would be nice if the user could inform various parts of the kernel t=
hat
> > this device was going away, and then all sorts of cleanup could happen.
> > But I really don't care -- all I'm trying to do is exit without a resou=
rce
> > leak under all circumstances.
>=20
> And so you shall if you follow the guidelines I set forth.
>=20
> > It would be nice if the SCSI mid-layer kept track of what commands were=
 in
> > what stages in who's queues.  After all, if I hot-unplug a PCI SCSI
> > controller, the controller really isn't going to be able to complete th=
ose
> > commands for us -- we have to assume that commands queued by a LLDD are
> > really just being sent to the hardware for queuing.  If that wasn't the
> > case, then having LLDD queue capability doesn't make sense.
>=20
> See, now you're just being a prick again.  You know the reason that the=
=20
> scsi mid layer *makes* the lldd tell us it is done with the commands is=
=20
> because if we go around saying "oh, this command was outstanding, let's=
=20
> free it" without getting clearance from the lldd then the lldd might stil=
l=20
> yet have state associated with the command.  We can't *ASSUME* jack crap=
=20
> in the mid layer.  You have to *TELL* us that you are done with a command=
. =20
> It is the only way to avoid races, resource leaks, and all sorts of other=
=20
> crap.  It amazes me that you think you should be excused from the job of=
=20
> cleaning up your queues after something happens like that.  Maybe the USB=
=20
> code doesn't allocate any internal command structs to go along with each=
=20
> scsi command, but pretty much every real scsi driver does and it's=20
> imperative that the driver go through all those commands and clean up=20
> after an event such as a removal, so what's the big deal about calling=20
> scsi_done() to *tell* us that you've cleaned up?
>=20
> > Now, here's the kicker -- this is what I think Linus wants:
> >=20
> > Linus said to me, with a degree of annoyance, that he doesn't want
> > usb-storage to keep any associations of departed devices with SCSI emul=
ated
> > hosts.  That means that I need to be able to add and remove hosts at the
> > will of the end-user.  In the end, what drives the entire process is wh=
at
> > Linus' hand does when it's placed on his USB flashcard reader.
>=20
> Well, the few milliseconds it might take to properly clean this stuff out
> is well within the specifications of how fast a human can go around
> plugging and unplugging a flashcard reader, so I'm not concerned that my
> proposal doesn't meet these requirements.
>=20
>=20
>=20
> --=20
>   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
>          Red Hat, Inc.=20
>          1801 Varsity Dr.
>          Raleigh, NC 27606
>  =20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Sir, for the hundreth time, we do NOT carry 600-round boxes of belt-fed=20
suction darts!
					-- Salesperson to Greg
User Friendly, 12/30/1997

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Mct0IjReC7bSPZARAropAJ9t8TSUCuFwOWm8eoTxpd5NnosLrgCfSm0X
/+xZc5Qb14apgRIgBxTNm/E=
=gI9B
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
