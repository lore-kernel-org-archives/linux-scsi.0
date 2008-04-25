From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/2] dpt_i2o: 64 bit support (take 4)
Date: Fri, 25 Apr 2008 09:48:42 +0200
Message-ID: <200804250948.43190.eike-kernel@sf-tec.de>
References: <20080424213459.GA21698@xs4all.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10517638.uQRhBABDnA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:37053 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbYDYHwf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 03:52:35 -0400
In-Reply-To: <20080424213459.GA21698@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-scsi@vger.kernel.org, Greg KH <gregkh@suse.de>

--nextPart10517638.uQRhBABDnA
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Miquel van Smoorenburg wrote:
> sysfs code.
>
> # -------
>
> This patch is an update for drivers/scsi/dpt_i2o.c.
> It applies to both 2.6.24.4 and 2.6.25
>
> It contains the following changes:
>
> * 64 bit code based on unofficial Adaptec 64 bit driver
> * removes scsi_module.c dependency, adds module_init / module_exit
>   this is needed because we need to pass the proper device to
>   scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
>   code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
>   because the dev pointer it is passed is NULL.
> * adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
>   can create /dev/dptiX dynamically
>
> Obviously there are more cleanups that can be done to this code,
> but we need to start somewhere. Patch has been tested heavily on
> both 32 and 64 bit x86 platforms.
>
> Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
>
> diff -ruN linux-2.6.25/drivers/scsi/dpt_i2o.c
> linux-2.6.25-sysfs/drivers/scsi/dpt_i2o.c ---
> linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-04-24 22:30:29.000000000 +0200 +=
++
> linux-2.6.25-sysfs/drivers/scsi/dpt_i2o.c	2008-04-24 23:26:08.000000000
> +0200 @@ -116,6 +116,8 @@
>  static adpt_hba* hba_chain =3D NULL;
>  static int hba_count =3D 0;
>
> +static struct class *adpt_sysfs_class;
> +
>  #ifdef CONFIG_COMPAT
>  static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long=
);
>  #endif
> @@ -259,6 +261,10 @@
>  		adpt_inquiry(pHba);
>  	}
>
> +	adpt_sysfs_class =3D class_create(THIS_MODULE, "dpt_i2o");
> +	if (IS_ERR(adpt_sysfs_class))
> +		adpt_sysfs_class =3D NULL;
> +
>  	for (pHba =3D hba_chain; pHba; pHba =3D pHba->next) {
>  		if (adpt_scsi_host_alloc(pHba, sht) < 0){
>  			adpt_i2o_delete_hba(pHba);
> @@ -266,6 +272,11 @@
>  		}
>  		pHba->initialized =3D TRUE;
>  		pHba->state &=3D ~DPTI_STATE_RESET;
> +		if (adpt_sysfs_class) {
> +			class_device_create(adpt_sysfs_class,
> +				NULL, MKDEV(DPTI_I2O_MAJOR, pHba->unit),
> +				NULL, "dpti%d", pHba->unit);
> +		}
>  	}
>
>  	// Register our control device node

class_device_create() has a return value that should probably be used for=20
something. Also Greg did many work to get rid of that class_device stuff=20
AFAIK so it's probably a bad idea to introduce a new one.

Eike

--nextPart10517638.uQRhBABDnA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIEYzbXKSJPmm5/E4RApupAJ9YiZj+ioGX3Uf9/efNnu1l4C22PgCfSeYT
Jczy7ynrwTkluwBGDCum2Sw=
=yzTn
-----END PGP SIGNATURE-----

--nextPart10517638.uQRhBABDnA--
