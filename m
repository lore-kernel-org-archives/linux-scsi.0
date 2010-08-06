From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/12] scsi: megaraid_sas - Add input parameter for max_sectors
Date: Fri, 06 Aug 2010 12:43:43 +0200
Message-ID: <4C5BE75F.1050105@suse.de>
References: <4B6A08C587958942AA3002690DD4F8C3D080455E@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C3D09274AC@cosmail02.lsi.com> <4B6A08C587958942AA3002690DD4F8C3DBD67FAE@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3DBD67FAE@cosmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Yang, Bo wrote:
> RESUBMIT requested by James Bottomley:
>=20
> Driver add the input parameters support for max_sectors for our gen2 =
chip.  Customer can
> Set the max_sectors support to 1MB for gen2 chip during the driver lo=
ad.
>=20
> Signed-off-by Bo Yang<bo.yang@lsi.com>
>=20
> ---
> drivers/scsi/megaraid/megaraid_sas.c |   74 +++++++++++++++++++++++++=
++++++++++
>  drivers/scsi/megaraid/megaraid_sas.h |    1
>  2 files changed, 75 insertions(+)
>=20
> diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/=
megaraid/megaraid_sas.c
> --- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 09:04:38.0000=
00000 -0400
> +++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 09:51:56.0000=
00000 -0400
> @@ -57,6 +57,15 @@ module_param_named(poll_mode_io, poll_mo
>  MODULE_PARM_DESC(poll_mode_io,
>  	"Complete cmds from IO path, (default=3D0)");
> =20
> +/*
> + * Number of sectors per IO command
> + * Will be set in megasas_init_mfi if user does not provide
> + */
> +static unsigned int max_sectors;
> +module_param_named(max_sectors, max_sectors, int, 0);
> +MODULE_PARM_DESC(max_sectors,
> +	"Maximum number of sectors per IO command");
> +
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(MEGASAS_VERSION);
>  MODULE_AUTHOR("megaraidlinux@lsi.com");
> @@ -3566,6 +3575,32 @@ static int megasas_start_aen(struct mega
>  				    class_locale.word);
>  }
> =20
> +static ssize_t
> +sysfs_max_sectors_read(struct kobject *kobj, struct bin_attribute *b=
in_attr,
> +			char *buf, loff_t off, size_t count)
> +{
> +	struct device *dev =3D container_of(kobj, struct device, kobj);
> +
> +	struct Scsi_Host *host =3D class_to_shost(dev);
> +
> +	struct megasas_instance *instance =3D
> +				(struct megasas_instance *)host->hostdata;
> +
> +	count =3D sprintf(buf, "%u\n", instance->max_sectors_per_req);
> +
> +	return count+1;
> +}
> +
> +static struct bin_attribute sysfs_max_sectors_attr =3D {
> +	.attr =3D {
> +		.name =3D "max_sectors",
> +		.mode =3D S_IRUSR|S_IRGRP|S_IROTH,
> +		.owner =3D THIS_MODULE,
> +	},
> +	.size =3D 7,
> +	.read =3D sysfs_max_sectors_read,
> +};
> +
>  /**
>   * megasas_io_attach -	Attaches this driver to SCSI mid-layer
>   * @instance:		Adapter soft state
> @@ -3573,6 +3608,7 @@ static int megasas_start_aen(struct mega
>  static int megasas_io_attach(struct megasas_instance *instance)
>  {
>  	struct Scsi_Host *host =3D instance->host;
> +	u32		error;
> =20
>  	/*
>  	 * Export parameters required by SCSI mid-layer
> @@ -3588,6 +3624,27 @@ static int megasas_io_attach(struct mega
>  			instance->max_fw_cmds - MEGASAS_INT_CMDS;
>  	host->this_id =3D instance->init_id;
>  	host->sg_tablesize =3D instance->max_num_sge;
> +	/*
> +	 * Check if the module parameter value for max_sectors can be used
> +	 */
> +	if (max_sectors && max_sectors < instance->max_sectors_per_req)
> +		instance->max_sectors_per_req =3D max_sectors;
> +	else {
> +		if (max_sectors) {
> +			if (((instance->pdev->device =3D=3D
> +				PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
> +				(instance->pdev->device =3D=3D
> +				PCI_DEVICE_ID_LSI_SAS0079GEN2)) &&
> +				(max_sectors <=3D MEGASAS_MAX_SECTORS)) {
> +				instance->max_sectors_per_req =3D max_sectors;
> +			} else {
> +			printk(KERN_INFO "megasas: max_sectors should be > 0"
> +				"and <=3D %d (or < 1MB for GEN2 controller)\n",
> +				instance->max_sectors_per_req);
> +			}
> +		}
> +	}
> +
>  	host->max_sectors =3D instance->max_sectors_per_req;
>  	host->cmd_per_lun =3D 128;
>  	host->max_channel =3D MEGASAS_MAX_CHANNELS - 1;
> @@ -3604,10 +3661,27 @@ static int megasas_io_attach(struct mega
>  	}
> =20
>  	/*
> +	 * Create sysfs entries for module paramaters
> +	 */
> +	error =3D sysfs_create_bin_file(&instance->host->shost_dev.kobj,
> +			&sysfs_max_sectors_attr);
> +
Errm. sysfs_create_bin_file?=20
Do you expect a user to paste binary values in there?
Please use the standard interface here.
sysfs_create_bin_file should only be used for 'real' binary values,
like raw f/w commands.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
