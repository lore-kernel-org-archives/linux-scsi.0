From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/12] IB/srp: Fix connection state tracking
Date: Tue, 05 May 2015 10:10:29 -0400
Message-ID: <1430835029.2407.187.camel@redhat.com>
References: <5541EE21.3050809@sandisk.com> <5541EE9F.8090605@sandisk.com>
	 <1430410094.102408.71.camel@redhat.com> <55488BAE.7070006@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-b/9kMWqo69srs43lW7Xj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55488BAE.7070006-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--=-b/9kMWqo69srs43lW7Xj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-05 at 11:21 +0200, Bart Van Assche wrote:
> On 04/30/15 18:08, Doug Ledford wrote:
> > On Thu, 2015-04-30 at 10:58 +0200, Bart Van Assche wrote:
> >> @@ -2367,7 +2368,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id=
, struct ib_cm_event *event)
> >>   	case IB_CM_DREQ_RECEIVED:
> >>   		shost_printk(KERN_WARNING, target->scsi_host,
> >>   			     PFX "DREQ received - connection closed\n");
> >> -		srp_change_conn_state(target, false);
> >> +		ch->connected =3D false;
> >
> > So, in this patch, you modify disconnect to set srp_change_conn_state()
> > to false for the target, then loop through all the channels sending
> > cm_dreq's, and on the receiving side, you modify the cm_dreq handler to
> > set each channel to false.  However, once you get to 0 channels open,
> > shouldn't you then set the target state to false too just to keep thing=
s
> > consistent?
>=20
> Hello Doug,
>=20
> What is not visible in this patch but only in the ib_srp.c source code=
=20
> is that the first received DREQ initiates a reconnect (the queue_work()=
=20
> call below):
>=20
> 	case IB_CM_DREQ_RECEIVED:
> 		shost_printk(KERN_WARNING, target->scsi_host,
> 			     PFX "DREQ received - connection closed\n");
> 		ch->connected =3D false;
> 		if (ib_send_cm_drep(cm_id, NULL, 0))
> 			shost_printk(KERN_ERR, target->scsi_host,
> 				     PFX "Sending CM DREP failed\n");
> 		queue_work(system_long_wq, &target->tl_err_work);
> 		break;
>=20
> That should be sufficient to restore communication after a DREQ has been=
=20
> received.

Sure, but there is no guarantee that the wq is not busy with something
else, or that the reconnect attempt will succeed.  So, it would seem to
me that if you want to make sure your internal driver state is always
consistent, you should set the device connected state to 0 when there
are no connected channels any more.

However, while looking through the driver to research this, I noticed
something else that seems more important if you ask me.  With this patch
we now implement individual channel connection tracking.  However, in
srp_queuecommand() you pick the channel based on the tag, and the blk
layer has no idea of these disconnects, so the blk layer is free to
assign a tag/channel to a channel that's disconnected, and then as best
I can tell, you will simply try to post a work request to a channel
that's already disconnected, which I would expect to fail if we have
already disconnected this particular qp and not brought up a new one
yet.  So it seems to me there is a race condition between new incoming
SCSI commands and this disconnect/reconnect window, and that maybe we
should be sending these commands back to the mid layer for requeueing
when the channel the blk_mq tag points to is disconnected.  Or am I
missing something in there?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-b/9kMWqo69srs43lW7Xj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVSM9VAAoJELgmozMOVy/d11wP/A1hUawxgttKhRyQG1UNqovW
WjcJvVmRXzvjN2Ae+qQtGDWzlDaS7k/opjfHLs2NbR+CnuHfhWgz7IPa8iVVUfqE
M0X4b51w2NCp2oLwoLJc+dp+Q21QAoBNmHq95+Dfdf8IK1wK7neYvPcIg0EVYgD1
CzJXyj7dfBPP3qh425K7Pl5ZVGmpmJx1aRRfdDkZiz6Sfq4FKoDBPnFO9MCsZAy7
v/GkNa5RE1ljAwj7ydFyzEzlfCuQWr5C/zG24hHSLDO6ygQiOEQxyY+k4o6nWfja
/xLK0m33bxORDcqMl2Ypyrxuw0GyvKS1l6QkVZzwqOzySBhVbm7rA9kZSLpdxd4g
IBbnOC5RD9BkGvW7sru44YY1w9IZz7jxSzrxgFttCTD916N9AnpWc/j2IjHwP/L1
bNNQXuL5CdD1QzFzMZQU4lbe+iEo2w2/jW/ByZf4XQfbBfhUl1tZJ/2/OhBQZWZE
HDo/dnz2kXf3vGWDEocSnd16uPZZnk+ZUxKYglzjybpLfCt6/idaW+Hzdh+CEH8/
6MgZPlYFL1gfM/TstufPOK6onmbcPALYjL67lFyhtbwNEoj1njGW0KrcFpkUDTei
lxphrakRSa1AiWMCk2WUPLmrbrQtVd2VYJDVITHNmWfiQn/flbls51a3s4A16Xl3
BgGs/xD1Lzz2LYNI6Gf8
=CjzJ
-----END PGP SIGNATURE-----

--=-b/9kMWqo69srs43lW7Xj--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
