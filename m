From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] lpfc: fix missing zero termination in debugfs
Date: Tue, 16 Feb 2016 07:52:36 +0100
Message-ID: <20160216065236.GF18134@c203.arch.suse.de>
References: <20160215191142.19028.9220.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbcBPGwi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2016 01:52:38 -0500
Content-Disposition: inline
In-Reply-To: <20160215191142.19028.9220.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 15, 2016 at 07:11:56PM +0000, Alan wrote:
> If you feed 32 bytes in then the kstrtoull() doesn't receive a termin=
ated
> string so will run off the end.
>=20
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/scsi/lpfc/lpfc_debugfs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpf=
c_debugfs.c
> index 25aa9b9..a63542b 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -1054,11 +1054,11 @@ lpfc_debugfs_dif_err_write(struct file *file,=
 const char __user *buf,
>  {
>  	struct dentry *dent =3D file->f_path.dentry;
>  	struct lpfc_hba *phba =3D file->private_data;
> -	char dstbuf[32];
> +	char dstbuf[33];
>  	uint64_t tmp =3D 0;
>  	int size;
> =20
> -	memset(dstbuf, 0, 32);
> +	memset(dstbuf, 0, 33);
>  	size =3D (nbytes < 32) ? nbytes : 32;
>  	if (copy_from_user(dstbuf, buf, size))
>  		return 0;
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
