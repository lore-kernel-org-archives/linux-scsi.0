From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 7/7] libiscsi: fix iscsi pool error path
Date: Thu, 2 Apr 2009 16:02:55 +0200
Message-ID: <200904021602.55587.jdelvare@suse.de>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu> <12386094922477-git-send-email-michaelc@cs.wisc.edu> <12386094933319-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbZDBOC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 10:02:58 -0400
In-Reply-To: <12386094933319-git-send-email-michaelc@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

Hi Mike,

Sorry for the late answer, I have been traveling for the last 2 days.

Le mercredi 01 avril 2009, michaelc@cs.wisc.edu a =C3=A9crit=C2=A0:
> From: Jean Delvare <jdelvare@suse.de>
>=20
> Le lundi 30 mars 2009, Chris Wright a =C3=A9crit=C2=A0:
> > q->queue could be ERR_PTR(-ENOMEM) which will break unwinding
> > on error.  Make iscsi_pool_free more defensive.
> >
>=20
> Making the freeing of q->queue dependent on q->pool being set looks
> really weird (although it is correct at the moment. But this seems
> to be fixable in a much simpler way.
>=20
> With the benefit that only the error case is slowed down. In both
> cases we have a problem if q->queue contains an error value but it's
> not -ENOMEM. Apparently this can't happen today, but it doesn't feel
> right to assume this will always be true. Maybe it's the right time
> to fix this as well.
>=20
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/libiscsi.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index dfaa8ad..6896283 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1999,8 +1999,10 @@ iscsi_pool_init(struct iscsi_pool *q, int max,=
 void ***items, int item_size)
> =20
>  	q->queue =3D kfifo_init((void*)q->pool, max * sizeof(void*),
>  			      GFP_KERNEL, NULL);
> -	if (q->queue =3D=3D ERR_PTR(-ENOMEM))
> +	if (IS_ERR(q->queue)) {

This indeed solves the problem I had underlined before, but
introduces a new one. Right now the only error returned by kfifo_init
is -ENOMEM. This may however change in the future, and then the
above code would silently convert the other error code to -ENOMEM.
This might make it difficult to trace errors.

I know this is all just theoretical, at the moment your code is
correct, but I don't much like relying on assumptions which are not
guaranteed to last. So I would rather cleanly transmit the error code
up to the caller, or change the calling convention of kfifo_init() to
return NULL on error. The former will add a few lines of code, the
latter will result in faster code but is obviously more intrusive.
The latter might also be undesirable for some reason I am
overlooking; I'm really not familiar with kfifo.

Or you can consider I am too perfectionist and ignore me and go with
the current fix, that's also fine with me ;)

> +		q->queue =3D NULL;
>  		goto enomem;
> +	}
> =20
>  	for (i =3D 0; i < max; i++) {
>  		q->pool[i] =3D kzalloc(item_size, GFP_KERNEL);



--=20
Jean Delvare
Suse L3
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
