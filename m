From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 19/20] [SCSI] mpt3sas: When device is blocked followed by
 unblock fails, unfreeze the I/Os
Date: Mon, 15 Jun 2015 11:58:40 +0200
Message-ID: <20150615095840.GK5660@c203.arch.suse.de>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <1434102153-38581-20-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434102153-38581-20-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 12, 2015 at 03:12:31PM +0530, Sreekanth Reddy wrote:
> Issue: When the disks are getting discovered and assigned device
> handles by the kernel, a device block followed by an unblock
> (due to broadcast primitives) issued by the driver is
> interspersed by the kernel changing the state of the device.
> Therefore the unblock by the driver results in a no operation
> within the kernel API.
>=20
> To fix this one, the below patch checks the return of the unblock API
> and performs a block followed by an unblock to unfreeze the block
> layer's I/O queue. Sufficient checks and prints are also added in the
> driver to identify this condition caused by the kernel.
>=20
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 89 ++++++++++++++++++++++++++=
++++------
>  1 file changed, 75 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3=
sas/mpt3sas_scsih.c
> index 42bb731..5405a2f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -2605,6 +2605,75 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_A=
DAPTER *ioc)
>  }
> =20
>  /**
> + * _scsih_internal_device_block - block the sdev device
> + * @sdev: per device object
> + * @sas_device_priv_data : per device driver private data
> + *
> + * make sure device is blocked without error, if not
> + * print an error
> + */
> +static void
> +_scsih_internal_device_block(struct scsi_device *sdev,
> +			struct MPT3SAS_DEVICE *sas_device_priv_data)
> +{
> +	int r =3D 0;
> +
> +	sdev_printk(KERN_INFO, sdev, "device_block, handle(0x%04x)\n",
> +	    sas_device_priv_data->sas_target->handle);
> +	sas_device_priv_data->block =3D 1;
> +
> +	r =3D scsi_internal_device_block(sdev);
> +	if (r =3D=3D -EINVAL)
> +		sdev_printk(KERN_WARNING, sdev,
> +		    "device_block failed with return(%d) for handle(0x%04x)\n",
> +		    sas_device_priv_data->sas_target->handle, r);
> +}
> +
> +/**
> + * _scsih_internal_device_unblock - unblock the sdev device
> + * @sdev: per device object
> + * @sas_device_priv_data : per device driver private data
> + * make sure device is unblocked without error, if not retry
> + * by blocking and then unblocking
> + */
> +
> +static void
> +_scsih_internal_device_unblock(struct scsi_device *sdev,
> +			struct MPT3SAS_DEVICE *sas_device_priv_data)
> +{
> +	int r =3D 0;
> +
> +	sdev_printk(KERN_WARNING, sdev, "device_unblock and setting to runn=
ing, "
> +	    "handle(0x%04x)\n", sas_device_priv_data->sas_target->handle);
> +	sas_device_priv_data->block =3D 0;
> +	r =3D scsi_internal_device_unblock(sdev, SDEV_RUNNING);
> +	if (r =3D=3D -EINVAL) {
> +		/* The device has been set to SDEV_RUNNING by SD layer during
> +		 * device addition but the request queue is still stopped by
> +		 * our earlier block call. We need to perform a block again
> +		 * to get the device to SDEV_BLOCK and then to SDEV_RUNNING */
> +
> +		sdev_printk(KERN_WARNING, sdev,
> +		    "device_unblock failed with return(%d) for handle(0x%04x) "
> +		    "performing a block followed by an unblock\n",
> +		    sas_device_priv_data->sas_target->handle, r);
> +		sas_device_priv_data->block =3D 1;
> +		r =3D scsi_internal_device_block(sdev);
> +		if (r)
> +			sdev_printk(KERN_WARNING, sdev, "retried device_block "
> +			    "failed with return(%d) for handle(0x%04x)\n",
> +			    sas_device_priv_data->sas_target->handle, r);
> +
> +		sas_device_priv_data->block =3D 0;
> +		r =3D scsi_internal_device_unblock(sdev, SDEV_RUNNING);
> +		if (r)
> +			sdev_printk(KERN_WARNING, sdev, "retried device_unblock"
> +			    " failed with return(%d) for handle(0x%04x)\n",
> +			    sas_device_priv_data->sas_target->handle, r);
> +	}
> +}
> +
> +/**
>   * _scsih_ublock_io_all_device - unblock every device
>   * @ioc: per adapter object
>   *
> @@ -2623,11 +2692,10 @@ _scsih_ublock_io_all_device(struct MPT3SAS_AD=
APTER *ioc)
>  		if (!sas_device_priv_data->block)
>  			continue;
> =20
> -		sas_device_priv_data->block =3D 0;
>  		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev,
>  			"device_running, handle(0x%04x)\n",
>  		    sas_device_priv_data->sas_target->handle));
> -		scsi_internal_device_unblock(sdev, SDEV_RUNNING);
> +		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
>  	}
>  }
> =20
> @@ -2652,10 +2720,9 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER=
 *ioc, u64 sas_address)
>  		if (sas_device_priv_data->sas_target->sas_address
>  		    !=3D sas_address)
>  			continue;
> -		if (sas_device_priv_data->block) {
> -			sas_device_priv_data->block =3D 0;
> -			scsi_internal_device_unblock(sdev, SDEV_RUNNING);
> -		}
> +		if (sas_device_priv_data->block)
> +			_scsih_internal_device_unblock(sdev,
> +				sas_device_priv_data);
>  	}
>  }
> =20
> @@ -2678,10 +2745,7 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAP=
TER *ioc)
>  			continue;
>  		if (sas_device_priv_data->block)
>  			continue;
> -		sas_device_priv_data->block =3D 1;
> -		scsi_internal_device_block(sdev);
> -		sdev_printk(KERN_INFO, sdev, "device_blocked, handle(0x%04x)\n",
> -		    sas_device_priv_data->sas_target->handle);
> +		_scsih_internal_device_block(sdev, sas_device_priv_data);
>  	}
>  }
> =20
> @@ -2713,10 +2777,7 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER =
*ioc, u16 handle)
>  			continue;
>  		if (sas_device->pend_sas_rphy_add)
>  			continue;
> -		sas_device_priv_data->block =3D 1;
> -		scsi_internal_device_block(sdev);
> -		sdev_printk(KERN_INFO, sdev,
> -			"device_blocked, handle(0x%04x)\n", handle);
> +		_scsih_internal_device_block(sdev, sas_device_priv_data);
>  	}
>  }
> =20
> --=20
> 2.0.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
