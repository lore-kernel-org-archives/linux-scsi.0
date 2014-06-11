From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Fwd: Re: [PATCH v3 3/6] virtio-scsi: avoid cancelling
 uninitialized work items
Date: Wed, 11 Jun 2014 15:19:31 +0200
Message-ID: <20140611131931.GA6670@stefanha-thinkpad.str.redhat.com>
References: <20140611124731.GA16990@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140611124731.GA16990@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
List-Id: linux-scsi@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 02:53:46PM +0200, Paolo Bonzini wrote:
> -------- Messaggio originale --------
> From: Christoph Hellwig <hch@infradead.org>
> To: Paolo Bonzini <pbonzini@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de,=
        JBottomley@Parallels.com, venkateshs@google.com
> Subject: Re: [PATCH v3 3/6] virtio-scsi: avoid cancelling uninitialized w=
ork items
> Message-ID: <20140611124731.GA16990@infradead.org>
> In-Reply-To: <1401881699-1456-4-git-send-email-pbonzini@redhat.com>
>=20
> Can I get a second review on this one from anyone?

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

> On Wed, Jun 04, 2014 at 01:34:56PM +0200, Paolo Bonzini wrote:
> > Calling the workqueue interface on uninitialized work items isn't a
> > good idea even if they're zeroed. It's not failing catastrophically only
> > through happy accidents.
> >=20
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  drivers/scsi/virtio_scsi.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> > index f0b4cdbfceb0..d66c4ee2c774 100644
> > --- a/drivers/scsi/virtio_scsi.c
> > +++ b/drivers/scsi/virtio_scsi.c
> > @@ -253,6 +253,8 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
> >  	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
> >  };
> > =20
> > +static void virtscsi_handle_event(struct work_struct *work);
> > +
> >  static int virtscsi_kick_event(struct virtio_scsi *vscsi,
> >  			       struct virtio_scsi_event_node *event_node)
> >  {
> > @@ -260,6 +262,7 @@ static int virtscsi_kick_event(struct virtio_scsi *=
vscsi,
> >  	struct scatterlist sg;
> >  	unsigned long flags;
> > =20
> > +	INIT_WORK(&event_node->work, virtscsi_handle_event);
> >  	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event)=
);
> > =20
> >  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
> > @@ -377,7 +380,6 @@ static void virtscsi_complete_event(struct virtio_s=
csi *vscsi, void *buf)
> >  {
> >  	struct virtio_scsi_event_node *event_node =3D buf;
> > =20
> > -	INIT_WORK(&event_node->work, virtscsi_handle_event);
> >  	schedule_work(&event_node->work);
> >  }
> > =20
> > --=20
> > 1.8.3.1
>=20

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTmFdjAAoJEJykq7OBq3PI72wH/jpk0DOf7BL1bfCTlVU0bUWu
H3J/yC8thQOIlQlgKTrM+dlKbv/3E6JzZyuYSgJkQx6Cit59h/ytZtKRMv+pJy3E
gZXrTiM6itzZ4Mir/BgGe1Ot+kvccSI6H40lvxr7rzqg87whNro5HamKNtAuuXP2
AkxcPrdKCnrrpK+tWrlOuVUbGajDXCEtDEAxkU3LGlRuf20+lqv+uPTXTvh4Lnxx
QlGRpA7PzJy78DFAtM8ZTMHs3cIDYFmZcwP/Ji8DAkAxZLuXLxs1zVUfit/5v77l
klXnciZ4M/f6oFKdPZtvyBxPYrIBMvg4M/K0kdxqZO09brc/eQl4KIQKYxw8pKw=
=2EdB
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
