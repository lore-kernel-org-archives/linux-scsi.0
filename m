From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Tue, 24 May 2016 07:14:24 -0700
Message-ID: <1464099264.1835.12.camel@perches.com>
References: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, JBottomley@odin.com, martin.petersen@oracle.com, tyreld@linux.vnet.ibm.com, akpm@linux-foundation.org, kvalo@codeaurora.org, davem@davemloft.net, gregkh@linuxfoundation.org, mchehab@osg.samsung.com, jslaby@suse.com, bp@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bgly <bgly@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-05-24 at 08:52 -0500, Bryant G. Ly wrote:
> From: bgly <bgly@us.ibm.com>
>=20
> This initial commit contains WIP of the IBM VSCSI Target Fabric
> Module. It currently supports read/writes, and I have tested
> the ability to create a file backstore with the driver and install
> RHEL VIA NIM and then boot up the partition via filio backstore
> through the driver.

Only trivial notes:

Maybe try checkpatch with the --strict option and see
if any of the additional messages are important to you.

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -5381,6 +5381,16 @@ S:	Supported
> =A0F:	drivers/scsi/ibmvscsi/ibmvscsi*
> =A0F:	drivers/scsi/ibmvscsi/viosrp.h
> =A0
> +IBM Power Virtual SCSI Device Target Driver
> +M:	Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> +L:	linux-scsi@vger.kernel.org
> +L:	target-devel@vger.kernel.org
> +S:	Supported
> +F:	drivers/scsi/ibmvscsi/ibmvscsis.c
> +F:=A0=A0=A0=A0=A0=A0drivers/scsi/ibmvscsi/ibmvscsis.h
> +F:	drivers/scsi/libsrp.h
> +F:=A0=A0=A0=A0=A0=A0drivers/scsi/libsrp.c

Please use a tab character consistently after the :

> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
[]
> @@ -847,6 +847,20 @@ config SCSI_IBMVSCSI
> =A0	=A0=A0To compile this driver as a module, choose M here: the
> =A0	=A0=A0module will be called ibmvscsi.
> =A0
> +config SCSI_IBMVSCSIS
> +=A0=A0	tristate "IBM Virtual SCSI Server support"
> +=A0=A0	depends on PPC_PSERIES && SCSI_SRP && TARGET_CORE
> +=A0=A0	help
> +=A0=A0	=A0=A0This is the IBM POWER Virtual SCSI Target Server
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0The userspace component needed to init=
ialize the driver and
> +=A0=A0	=A0=A0documentation can be found:

here too.

> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0https://github.com/powervm/ibmvscsis
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0To compile this driver as a module, ch=
oose M here: the
> +=A0=A0	=A0=A0module will be called ibmvstgt.
> +

[]

> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
[]
> @@ -127,7 +127,9 @@ obj-$(CONFIG_SCSI_LASI700)	+=3D 53c700.o lasi700.=
o
> =A0obj-$(CONFIG_SCSI_SNI_53C710)	+=3D 53c700.o sni_53c710.o
> =A0obj-$(CONFIG_SCSI_NSP32)	+=3D nsp32.o
> =A0obj-$(CONFIG_SCSI_IPR)		+=3D ipr.o
> +obj-$(CONFIG_SCSI_SRP)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0+=3D libsrp.o
> =A0obj-$(CONFIG_SCSI_IBMVSCSI)	+=3D ibmvscsi/
> +obj-$(CONFIG_SCSI_IBMVSCSIS)=A0=A0=A0=A0+=3D ibmvscsi/

and here

> diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.c b/drivers/scsi/ibmvscs=
i/ibmvscsis.c
[]

> +static int ibmvscsis_probe(struct vio_dev *vdev,
> +			=A0=A0=A0const struct vio_device_id *id);
[...]

It might be nice to rearrange the code to avoid these forward
function declarations.

> +static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
> +		const char *page, size_t count)
> +{
[]
> > +	ret =3D kstrtoul(page, 0, &tmp);
> +	if (ret < 0) {
> +		pr_err("Unable to extract ibmvscsis_tpg_store_enable\n");
> +		return -EINVAL;
> +	}

It might be nicer to add:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

before any #include to output all the logging messages with
a standardized prefix. =A0Then all the other logging with an
embedded prefix can have the embedded prefix removed too.

> +
> +	if ((tmp !=3D 0) && (tmp !=3D 1)) {
> +		pr_err("Illegal value for ibmvscsis_tpg_store_enable: %lu\n",
> +			tmp);
> +		return -EINVAL;
> +	}
> +
> +	if (tmp =3D=3D 1)
> +		tport->enabled =3D true;
> +	else
> +		tport->enabled =3D false;

	tport->enabled =3D tmp;
