From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] st: unblock concurrent access in st_open()
Date: Wed, 15 Aug 2012 23:14:15 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1208152310510.5672@kai.makisara.local>
References: <1345040689-29362-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-1716271750-1345061660=:5672"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([62.142.117.202]:57744 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab2HOUX3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2012 16:23:29 -0400
In-Reply-To: <1345040689-29362-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Lee Duncan <lduncan@suse.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-1716271750-1345061660=:5672
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Aug 2012, Hannes Reinecke wrote:

> st_open() is taking a global mutex 'st_mutex' to protect
> against concurrent calls to st_open(). However, as
> st_open() might take quite some time before returning,
> _any_ open to _any_ st device will be blocked during
> that time.
>=20
> Seeing that all critical sections are already protected
> by individual spinlocks 'st_mutex' doesn't serve any
> purpose and can be removed, unblocking concurrent
> accesses.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: James Bottomley <jbottomley@parallels.com>
> Cc: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
> Cc: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/st.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index e41998c..c6c172e 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
...
> @@ -1262,16 +1258,16 @@ static int st_open(struct inode *inode, struct =
file *filp)
>  			retval =3D (-EIO);
>  		goto err_out;
>  	}
> -	mutex_unlock(&st_mutex);
>  	return 0;
> =20
>   err_out:
>  	normalize_buffer(STp->buffer);
> +	write_lock(&st_dev_arr_lock);
>  	STp->in_use =3D 0;
> +	write_unlock(&st_dev_arr_lock);

I am not sure locking here is necessary. No-one should be able to remove=20
the tape struct when in_use is non-zero. But I don't object to this extra=
=20
protection.

Acked-by: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>

Thanks,
Kai
---1463811327-1716271750-1345061660=:5672--
