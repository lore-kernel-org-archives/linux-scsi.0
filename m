From: Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: Re: [PATCH] [ConfigFS]: Add struct
	configfs_item_operations->check_link()
Date: Fri, 3 Apr 2009 11:51:28 +0200
Message-ID: <20090403095128.GE32106@hawkmoon.kerlabs.com>
References: <1238747107.4250.448.camel@haakon2.linux-iscsi.org>
Reply-To: Louis.Rilling@kerlabs.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-6500-1238752280-0001-2"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762463AbZDCJvo@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1238747107.4250.448.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-6500-1238752280-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On 03/04/09  1:25 -0700, Nicholas A. Bellinger wrote:
> Hi Joel and co,
>=20
> This patch adds struct configfs_item_operations->check_link() and
> changes fs/configfs/symlink.c:configfs_unlink() so that
> when (*check_link) is present, an ConfigFS unlink will fail, based upon
> input by said symlinked struct config_item *parent_item.
>=20
> If a non zero return is returned from (*check_link), said non zero value =
is
> expected to use include/asm-generic/errno* values, and the failure is ret=
urned
> to userspace via the unlink(2) system call.
>=20
> Please consider this patch for v2.6.30.  It requires no changes to existi=
ng consumers
> of ConfigFS like fs/ocfs2, and I have tested it with running LIO-Target v=
3.0 code.
>=20
> Many thanks for your most valuable of time,

I can't judge the actual need for that since I don't really know your useca=
se
(I've seen the second patch). However check_link() without target_item as
parameter looks a bit restrictive for no valuable reason.

See inline for a concern about the error returned.
Other than that, the patch looks ok.

Louis

>=20
> --nab
>=20
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  fs/configfs/symlink.c    |   13 +++++++++++++
>  include/linux/configfs.h |    1 +
>  2 files changed, 14 insertions(+), 0 deletions(-)
>=20
> diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
> index 932a92b..a5dede6 100644
> --- a/fs/configfs/symlink.c
> +++ b/fs/configfs/symlink.c
> @@ -202,6 +202,19 @@ int configfs_unlink(struct inode *dir, struct dentry=
 *dentry)
>  	parent_item =3D configfs_get_config_item(dentry->d_parent);
>  	type =3D parent_item->ci_type;
> =20
> +	/*
> +	 * See if the underlying struct config_item has dependent
> +	 * symlinks, and should return -EACCES here.
> +	 */

I think that -EPERM is more natural than -EACCES. check_link() actually che=
cks
that the operation is permitted.

> +	if (type && type->ct_item_ops &&
> +	    type->ct_item_ops->check_link) {
> +		ret =3D type->ct_item_ops->check_link(parent_item);
> +		if (ret !=3D 0) {
> +			config_item_put(parent_item);
> +			goto out;
> +		}
> +	}
> +
>  	spin_lock(&configfs_dirent_lock);
>  	list_del_init(&sd->s_sibling);
>  	spin_unlock(&configfs_dirent_lock);
> diff --git a/include/linux/configfs.h b/include/linux/configfs.h
> index 7f62777..b026f16 100644
> --- a/include/linux/configfs.h
> +++ b/include/linux/configfs.h
> @@ -226,6 +226,7 @@ struct configfs_item_operations {
>  	ssize_t	(*show_attribute)(struct config_item *, struct configfs_attribu=
te *,char *);
>  	ssize_t	(*store_attribute)(struct config_item *,struct configfs_attribu=
te *,const char *, size_t);
>  	int (*allow_link)(struct config_item *src, struct config_item *target);
> +	int (*check_link)(struct config_item *src);
>  	int (*drop_link)(struct config_item *src, struct config_item *target);
>  };
> =20
> --=20
> 1.5.4.1
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-6500-1238752280-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ1dwgVKcRuvQ9Q1QRAr2pAJ4ptuh4seE57ozpAZ8F4f/tdNXcVgCfVgzr
MD/pqYRm6dvr061pgwMzaJ0=
=rCd0
-----END PGP SIGNATURE-----

--=_bohort-6500-1238752280-0001-2--
