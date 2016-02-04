From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V6 07/10] aacraid: Created new mutex for ioctl path
Date: Thu, 4 Feb 2016 13:33:39 +0100
Message-ID: <20160204123339.GZ27969@c203.arch.suse.de>
References: <1454540768-12271-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1454540768-12271-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbcBDMdo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 07:33:44 -0500
Content-Disposition: inline
In-Reply-To: <1454540768-12271-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, thenzl@redhat.com, shane.seymour@hpe.com

On Wed, Feb 03, 2016 at 03:06:05PM -0800, Raghava Aditya Renukunta wrot=
e:
> aac_mutex was used to create protect the ioctl path for only the
> compat path, it would be make more sense to place mutex in
> aac_do_ioctl, which is the main ioctl function call that handles
> all ioctl commands.
>=20
> Created new mutex ioctl_mutex in struct aac_dev to protect switch
> case in aac_do_ioctl and removed aac_mutex from aac_cfg_ioctl and
> aac_compat_do_ioctl
>=20
> Changes in V1:
> Unlock ioctl_mutex incase of error
> Fix compilation error with aac->adapter_shutdown
>=20
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs=
=2Ecom>
> ---
>  drivers/scsi/aacraid/aacraid.h  |  1 +
>  drivers/scsi/aacraid/commctrl.c |  8 +++++++-
>  drivers/scsi/aacraid/linit.c    | 13 ++++---------
>  3 files changed, 12 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index 2916288..75bc65e 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1124,6 +1124,7 @@ struct aac_dev
>  	struct fib		*free_fib;
>  	spinlock_t		fib_lock;
> =20
> +	struct mutex		ioctl_mutex;
>  	struct aac_queue_block *queues;
>  	/*
>  	 *	The user API will use an IOCTL to register itself to receive
> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/c=
ommctrl.c
> index 54195a1..ebf214b 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -855,13 +855,15 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd,=
 void __user *arg)
>  {
>  	int status;
> =20
> +	mutex_lock(&dev->ioctl_mutex);
> +
>  	/*
>  	 *	HBA gets first crack
>  	 */
> =20
>  	status =3D aac_dev_ioctl(dev, cmd, arg);
>  	if (status !=3D -ENOTTY)
> -		return status;
> +		goto cleanup;
> =20
>  	switch (cmd) {
>  	case FSACTL_MINIPORT_REV_CHECK:
> @@ -890,6 +892,10 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, =
void __user *arg)
>  		status =3D -ENOTTY;
>  		break;
>  	}
> +
> +cleanup:
> +	mutex_unlock(&dev->ioctl_mutex);
> +
>  	return status;
>  }
> =20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 48e2a79..3f9c741 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -703,23 +703,18 @@ static int aac_cfg_open(struct inode *inode, st=
ruct file *file)
>  static long aac_cfg_ioctl(struct file *file,
>  		unsigned int cmd, unsigned long arg)
>  {
> -	int ret;
> -	struct aac_dev *aac;
> -	aac =3D (struct aac_dev *)file->private_data;
> +	struct aac_dev *aac =3D (struct aac_dev *)file->private_data;
> +
>  	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
>  		return -EPERM;
> -	mutex_lock(&aac_mutex);
> -	ret =3D aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
> -	mutex_unlock(&aac_mutex);
> =20
> -	return ret;
> +	return aac_do_ioctl(aac, cmd, (void __user *)arg);
>  }
> =20
>  #ifdef CONFIG_COMPAT
>  static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, u=
nsigned long arg)
>  {
>  	long ret;
> -	mutex_lock(&aac_mutex);
>  	switch (cmd) {
>  	case FSACTL_MINIPORT_REV_CHECK:
>  	case FSACTL_SENDFIB:
> @@ -753,7 +748,6 @@ static long aac_compat_do_ioctl(struct aac_dev *d=
ev, unsigned cmd, unsigned long
>  		ret =3D -ENOIOCTLCMD;
>  		break;
>  	}
> -	mutex_unlock(&aac_mutex);
>  	return ret;
>  }
> =20
> @@ -1194,6 +1188,7 @@ static int aac_probe_one(struct pci_dev *pdev, =
const struct pci_device_id *id)
>  		goto out_free_host;
>  	spin_lock_init(&aac->fib_lock);
> =20
> +	mutex_init(&aac->ioctl_mutex);
>  	/*
>  	 *	Map in the registers from the adapter.
>  	 */
> --=20
> 1.9.1
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
