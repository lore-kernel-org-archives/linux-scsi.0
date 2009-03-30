From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [stable] [PATCH] [SCSI] libiscsi: fix iscsi pool error path
Date: Mon, 30 Mar 2009 21:34:30 +0200
Message-ID: <200903302134.30706.jdelvare@suse.de>
References: <200903291119.42080.jdelvare@suse.de> <20090330184458.GB11116@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759145AbZC3Tef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2009 15:34:35 -0400
In-Reply-To: <20090330184458.GB11116@hera.kernel.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: stable@kernel.org, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Hi Chris,

Le lundi 30 mars 2009, Chris Wright a =E9crit=A0:
> * Jean Delvare (jdelvare@suse.de) wrote:
> > --- linux-2.6.29-rc5.orig/drivers/scsi/libiscsi.c	2009-01-29 08:27:=
19.000000000 +0100
> > +++ linux-2.6.29-rc5/drivers/scsi/libiscsi.c	2009-02-16 21:19:14.00=
0000000 +0100
> > @@ -1944,7 +1944,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
> >  		num_arrays++;
> >  	q->pool =3D kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL)=
;
> >  	if (q->pool =3D=3D NULL)
> > -		goto enomem;
> > +		return -ENOMEM;
> > =20
> >  	q->queue =3D kfifo_init((void*)q->pool, max * sizeof(void*),
> >  			      GFP_KERNEL, NULL);
> > @@ -1979,8 +1979,7 @@ void iscsi_pool_free(struct iscsi_pool *
> > =20
> >  	for (i =3D 0; i < q->max; i++)
> >  		kfree(q->pool[i]);
> > -	if (q->pool)
> > -		kfree(q->pool);
> > +	kfree(q->pool);
> >  	kfree(q->queue);
>=20
> AFAICT, This is still broken.
>=20
> thanks,
> -chris
> --
>=20
> Subject: [PATCH] libiscsi: fix error path on iscsi_pool_init
>=20
> From: Chris Wright <chrisw@sous-sol.org>
>=20
> I'm not all that keen on kfifo_init returning ERR_PTR, but...

Ah, I had not noticed this. Good catch!

> q->queue could be ERR_PTR(-ENOMEM) which will break unwinding
> on error.  Make iscsi_pool_free more defensive.
>=20
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index dfaa8ad..2f4df53 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1995,7 +1995,7 @@ iscsi_pool_init(struct iscsi_pool *q, int max, =
void ***items, int item_size)
>  		num_arrays++;
>  	q->pool =3D kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
>  	if (q->pool =3D=3D NULL)
> -		return -ENOMEM;
> +		goto enomem;
> =20
>  	q->queue =3D kfifo_init((void*)q->pool, max * sizeof(void*),
>  			      GFP_KERNEL, NULL);
> @@ -2028,10 +2028,13 @@ void iscsi_pool_free(struct iscsi_pool *q)
>  {
>  	int i;
> =20
> -	for (i =3D 0; i < q->max; i++)
> -		kfree(q->pool[i]);
> -	kfree(q->pool);
> -	kfree(q->queue);
> +	if (q->pool) {
> +		for (i =3D 0; i < q->max; i++)
> +			kfree(q->pool[i]);
> +		kfree(q->pool);
> +		if (!IS_ERR(q->queue))
> +			kfree(q->queue);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(iscsi_pool_free);

Making the freeing of q->queue dependent on q->pool being set looks
really weird (although it is correct at the moment. But this seems
to be fixable in a much simpler way:

---
 drivers/scsi/libiscsi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.30-rc0.orig/drivers/scsi/libiscsi.c	2009-03-30 09:27:48.0=
00000000 +0200
+++ linux-2.6.30-rc0/drivers/scsi/libiscsi.c	2009-03-30 21:15:13.000000=
000 +0200
@@ -1999,8 +1999,10 @@ iscsi_pool_init(struct iscsi_pool *q, in
=20
 	q->queue =3D kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
-	if (q->queue =3D=3D ERR_PTR(-ENOMEM))
+	if (q->queue =3D=3D ERR_PTR(-ENOMEM)) {
+		q->queue =3D NULL;
 		goto enomem;
+	}
=20
 	for (i =3D 0; i < max; i++) {
 		q->pool[i] =3D kzalloc(item_size, GFP_KERNEL);

With the benefit that only the error case is slowed down. In both
cases we have a problem if q->queue contains an error value but it's
not -ENOMEM. Apparently this can't happen today, but it doesn't feel
right to assume this will always be true. Maybe it's the right time
to fix this as well.

--=20
Jean Delvare
Suse L3
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
