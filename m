From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Tue, 05 May 2015 11:10:37 -0400
Message-ID: <1430838637.2407.209.camel@redhat.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
	 <1430410094.102408.71.camel@redhat.com> <55488BAE.7070006@sandisk.com>
	 <1430835029.2407.187.camel@redhat.com> <5548D2FF.7030501@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4z0o58xM8Lp0/8BUm61k"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993318AbbEEPKv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 May 2015 11:10:51 -0400
In-Reply-To: <5548D2FF.7030501@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--=-4z0o58xM8Lp0/8BUm61k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-05 at 16:26 +0200, Bart Van Assche wrote:
> On 05/05/15 16:10, Doug Ledford wrote:
> > However, while looking through the driver to research this, I noticed
> > something else that seems more important if you ask me.  With this patc=
h
> > we now implement individual channel connection tracking.  However, in
> > srp_queuecommand() you pick the channel based on the tag, and the blk
> > layer has no idea of these disconnects, so the blk layer is free to
> > assign a tag/channel to a channel that's disconnected, and then as best
> > I can tell, you will simply try to post a work request to a channel
> > that's already disconnected, which I would expect to fail if we have
> > already disconnected this particular qp and not brought up a new one
> > yet.  So it seems to me there is a race condition between new incoming
> > SCSI commands and this disconnect/reconnect window, and that maybe we
> > should be sending these commands back to the mid layer for requeueing
> > when the channel the blk_mq tag points to is disconnected.  Or am I
> > missing something in there?
>=20
> Hello Doug,
>=20
> Around the time a cable disconnect or other link layer failure is=20
> detected by the SRP initiator or any other SCSI LLD it is unavoidable=20
> that one or more SCSI requests fail. It is up to a higher layer (e.g.=20
> dm-multipath + multipathd) to decide what to do with such requests, e.g.=
=20
> queue these requests and resend these over another path.

Sure, but that wasn't my point.  My point was that if you know the
channel is disconnected, then why don't you go immediately to the
correct action in queuecommand (where correct action could be requeue
waiting on reconnect or return with error, whatever is appropriate)?
Instead you attempt to post a command to a known disconnected queue
pair.

>  The SRP=20
> initiator driver has been tested thoroughly with the multipath=20
> queue_if_no_path policy, with a fio job with I/O verification enabled=20
> running on top of a dm device while concurrently repeatedly simulating=
=20
> link layer failures (via ibportstate).

Part of my questions here are because I don't know how the blk_mq
handles certain conditions.  However, your testing above only handles
one case: all channels get dropped.  As unlikely it may be, what if
resource constraints caused just one channel to be dropped out of the
bunch and the others stayed alive?  Then the blk_mq would see requests
on just one queue come back errored, while the others finished
successfully.  Does it drop that one queue out of rotation, or does it
fail over the entire connection?

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-4z0o58xM8Lp0/8BUm61k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVSN1tAAoJELgmozMOVy/dL4QP/1zrRLCUIpTUnQaGrOKNU4ML
J1GrmWzLNjxC8qEybp/wZqHl1jT8kKiF8lrhHDtAMGRriU42a+8ZWIF+yfKnrelL
y7qW8kXn4k+PH/m0i4j2/sBBlthfjpjOuOI2MrX4RGVHnrjjMkYLgMtWLbvMmQ4C
ArxXe+BvQg3yIe2z7WUsbSOzqvwQuFKsxOC8J/BEaH5ATsLS4y4Fq/TxD5oWRPGh
XyH/lb6019wd/ELpWEjdUbHuIV/1aNbMW+rVd6Zakb64PstAjwHwEv8aYXv6R5gE
2X/3NREzLnPBOxXxEhItHT9BRGTUK6RPAuFeN/Hw3Jyj6c5eN2u2TiIPfFbPU7Uu
0HdDHd1dF3P28+7OSt9AlsMqdZ1gpwpI1JS+gLHhdUiWb8AsUw3fow5goHprhCo8
6dpfb2/QybGyk8BZmsklyqskNBlWjJNfADahtVB6wFgFM1TFzdypUa2CJQaMddBE
MgQUyHXPR5Q6FQwIyu3G9fD9UpQoqYGdIPo1yLXyyjcTaa6GZEEO/4VWIyV/MFVu
FSMvZxImjAby54OgNgGiVzE1G8FcT+Ju9vsJwoU6YvOevnTWeYFvNS3G54yLS72b
WHNCQvCcY0jofqBtbdxzREgWEOnZjTXaG0g2O9w5nlYnpy2HrpouzACiYWa1IGc4
IPK3ozDG+Q7C0yItAl+7
=93fA
-----END PGP SIGNATURE-----

--=-4z0o58xM8Lp0/8BUm61k--

