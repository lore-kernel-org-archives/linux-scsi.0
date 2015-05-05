From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Tue, 05 May 2015 12:10:01 -0400
Message-ID: <1430842201.2407.226.camel@redhat.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
	 <1430410094.102408.71.camel@redhat.com> <55488BAE.7070006@sandisk.com>
	 <1430835029.2407.187.camel@redhat.com> <5548D2FF.7030501@sandisk.com>
	 <1430838637.2407.209.camel@redhat.com> <5548E155.70007@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-BXLfnfHHxW3m1wV/cNj4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5548E155.70007-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--=-BXLfnfHHxW3m1wV/cNj4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-05 at 17:27 +0200, Bart Van Assche wrote:
> On 05/05/15 17:10, Doug Ledford wrote:
> > On Tue, 2015-05-05 at 16:26 +0200, Bart Van Assche wrote:
> >> On 05/05/15 16:10, Doug Ledford wrote:
> >>> However, while looking through the driver to research this, I noticed
> >>> something else that seems more important if you ask me.  With this pa=
tch
> >>> we now implement individual channel connection tracking.  However, in
> >>> srp_queuecommand() you pick the channel based on the tag, and the blk
> >>> layer has no idea of these disconnects, so the blk layer is free to
> >>> assign a tag/channel to a channel that's disconnected, and then as be=
st
> >>> I can tell, you will simply try to post a work request to a channel
> >>> that's already disconnected, which I would expect to fail if we have
> >>> already disconnected this particular qp and not brought up a new one
> >>> yet.  So it seems to me there is a race condition between new incomin=
g
> >>> SCSI commands and this disconnect/reconnect window, and that maybe we
> >>> should be sending these commands back to the mid layer for requeueing
> >>> when the channel the blk_mq tag points to is disconnected.  Or am I
> >>> missing something in there?
> >>
> >> Hello Doug,
> >>
> >> Around the time a cable disconnect or other link layer failure is
> >> detected by the SRP initiator or any other SCSI LLD it is unavoidable
> >> that one or more SCSI requests fail. It is up to a higher layer (e.g.
> >> dm-multipath + multipathd) to decide what to do with such requests, e.=
g.
> >> queue these requests and resend these over another path.
> >
> > Sure, but that wasn't my point.  My point was that if you know the
> > channel is disconnected, then why don't you go immediately to the
> > correct action in queuecommand (where correct action could be requeue
> > waiting on reconnect or return with error, whatever is appropriate)?
> > Instead you attempt to post a command to a known disconnected queue
> > pair.
> >
> >> The SRP initiator driver has been tested thoroughly with the multipath
> >> queue_if_no_path policy, with a fio job with I/O verification enabled
> >> running on top of a dm device while concurrently repeatedly simulating
> >> link layer failures (via ibportstate).
> >
> > Part of my questions here are because I don't know how the blk_mq
> > handles certain conditions.  However, your testing above only handles
> > one case: all channels get dropped.  As unlikely it may be, what if
> > resource constraints caused just one channel to be dropped out of the
> > bunch and the others stayed alive?  Then the blk_mq would see requests
> > on just one queue come back errored, while the others finished
> > successfully.  Does it drop that one queue out of rotation, or does it
> > fail over the entire connection?
>=20
> Hello Doug,
>=20
> Sorry but I don't think that a SCSI LLD is the appropriate layer to=20
> choose between requeuing or failing a request.

Be that as it may, that doesn't change what I said about posting a
command to a known disconnected QP.  You could just fail immediately.
Something like:

if (!ch->connected) {
	scmnd->result =3D DID_NO_CONNECT;
	goto err;
}

right after getting the channel in queuecommand would work.  That would
save a couple spinlocks, several DMA mappings, a call into the low level
driver, and a few other things.  (And I only left requeue on the table
because I wasn't sure how the blk_mq dealt with just a single channel
being down versus all of them being down)

>  If multiple paths are=20
> available between an initiator system and a SAN and if one path fails

Who says the path failed?  The path may be just fine.

> only the multipath layer knows whether there are other working paths=20
> available. If a working path is still available then the request should=
=20
> be resent as soon as possible over another path. The multipath layer can=
=20
> only take such a decision after a SCSI LLD has failed a request.

Sure.  I totally get failing fast and unilaterally for multipath managed
devices.  That's all assuming multipath though.  There are uses without
that.

But my point in all of this is that if you have a single qp between
yourself and the target, then any error including a qp resource error =3D=
=3D
path error since you only have one path.  When you have a multi queue
device, that's no longer true.  A transient resource problem on one qp
does not mean a path event (at least not necessarily, although your
statement below converts a QP event into a path event by virtue
disconnecting and reconnecting all of the QPs).  My curiosity is now
moot given what you wrote about tearing everything down and reconnecting
(unless the error handling is modified to be more subtle in its
workings), but the original question in my mind was what happens at the
blk_mq level if you did have a single queue drop but not all of them and
you weren't using multipath.

> If only one channel fails all other channels are disconnected and the=20
> transport layer error handling mechanism is started.

I missed that.  I assume it's done in srp_start_tl_fail_timers()?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-BXLfnfHHxW3m1wV/cNj4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVSOtZAAoJELgmozMOVy/d0ZoP/A/I6hrvlZtBy5Wgmms6cbyk
yjIlJbzYrmkOzajbLmCdTdwmCANRoAlsUubGbBy/j+hHehT327mG72ZSiYKZfE0K
b3Tpi9tvhUOaDHqOtLIvyfO45Fh5wnrQKba38JcDRARxzxjaPqyA1qQBFPeOX650
H2j594CAUUz3SYKaNuUWrpaphPqI2XLIhUCsJ+6ndj2qKH2TqX2CWmz0gxo4yN2e
uevBOtGKXSizZsp7r9hP+VL6TdeHTngvMe8nUpWMMm2Gm/tWQ3fXSY7+c1iBqh6a
+b4a9xcTeoe0aSS6BRv+dwQonbrOVHOtqNea1G4uRGxIQDCB2NDYjbg6+cTgTxcO
MWTo0o+w4+oYGVMzDQzphaEqxMZozhEUDTrOO8DJKr4mBlRqTA9nCGR2ru8ec1bn
cBftgOERRF38HYETFtlscJCDCMZgzgIkazgyXfL6UmS9ka4xtaZ5UARHXasKCCS1
8E4Mjgg0K1UIporoyjcSgLUhWXgY6KBdjsJVNWR13Hzd6yqOdlnbEScMVhY9Hxs3
+6wpC2ujuK0WQVbG4XgwuLuW0zHLJ20xPNyXWmB18vuyef3vOESRfsCBnAYiQvuK
qt8WsIQTbUFK2uPggznGSBeOWqmS7jn9AUTHv4I45CzpKnV158aJxORohyvn1Trp
IwiGLz/9+BsHXXF3YT2s
=TTLN
-----END PGP SIGNATURE-----

--=-BXLfnfHHxW3m1wV/cNj4--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
