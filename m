From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: PATCH: st.c: Fix blk_get_queue usage
Date: Thu, 14 Nov 2013 23:08:53 +0200 (EET)
Message-ID: <alpine.LSU.2.11.1311142306240.7347@kai.makisara.private>
References: <61eb00$4bjf3p@dgate20u.abg.fsc.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-718716577-1384463344=:7347"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:58207 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab3KNVJG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2013 16:09:06 -0500
In-Reply-To: <61eb00$4bjf3p@dgate20u.abg.fsc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-718716577-1384463344=:7347
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Nov 2013, Bodo Stroesser wrote:

...
> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Date: Thu, 14 Nov 2013 14:35:00 +0100
> Subject: [PATCH] sg: fix blk_get_queue usage
>=20
> If blk_queue_get() in st_probe fails, disk->queue must not
> be set to SDp->request_queue, as that would result in
> put_disk() dropping a not taken reference.
>=20
> Thus, disk->queue should be set only after a successful
> blk_queue_get().
> Revised patch due to a hint from Kai Makisara.
>=20
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>

Acked-by: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>

>=20
> ---
>=20
> --- a/drivers/scsi/st.c	2013-11-14 14:10:40.000000000 +0100
> +++ b/drivers/scsi/st.c	2013-11-14 14:10:57.000000000 +0100
> @@ -4107,11 +4107,11 @@
>  	kref_init(&tpnt->kref);
>  	tpnt->disk =3D disk;
>  	disk->private_data =3D &tpnt->driver;
> -	disk->queue =3D SDp->request_queue;
>  	/* SCSI tape doesn't register this gendisk via add_disk().  Manually
>  	 * take queue reference that release_disk() expects. */
> -	if (blk_get_queue(disk->queue))
> +	if (blk_get_queue(SDp->request_queue))
>  		goto out_put_disk;
> +	disk->queue =3D SDp->request_queue;
>  	tpnt->driver =3D &st_template;
> =20
>  	tpnt->device =3D SDp;

Thanks for the fix,
Kai

---1463811327-718716577-1384463344=:7347--
