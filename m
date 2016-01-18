From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V3 1/9] aacraid: SCSI blk tag support
Date: Mon, 18 Jan 2016 12:13:46 +0100
Message-ID: <20160118111345.GG2742@c203.arch.suse.de>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1452842182-684-2-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbcARLOG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 06:14:06 -0500
Content-Disposition: inline
In-Reply-To: <1452842182-684-2-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, thenzl@redhat.com, shane.seymour@hpe.com, David.Carroll@pmcs.com

On Thu, Jan 14, 2016 at 11:16:14PM -0800, Raghava Aditya Renukunta wrot=
e:
> From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
>=20
> The method to allocate and free FIB's in the present code utilizes
> spinlocks.Multiple IO's have to wait on the spinlock to acquire or
> free fibs creating a performance bottleneck.
>=20
> An alternative solution would be to use block layer tags to keep trac=
k
> of the fibs allocated and freed. To this end aac_fib_alloc_tag was
> created to utilize the blk layer tags to plug into the Fib pool.These
> functions are used exclusively in the IO path. 8 fibs are reserved fo=
r
> the use of AIF management software and utilize the previous spinlock =
based
> implementations.
>=20
> Changes in V2:
> Removed aac_fib_free_tag since it was a stub function
> Moved population of fib fields that are constant to aac_fib_setup
>=20
> Changes in V3:
> None
>=20
> Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs=
=2Ecom>
> ---
>  drivers/scsi/aacraid/aachba.c  | 27 ++++++++++++---------------
>  drivers/scsi/aacraid/aacraid.h |  1 +
>  drivers/scsi/aacraid/commsup.c | 32 +++++++++++++++++++++++++++++---
>  drivers/scsi/aacraid/dpcsup.c  |  2 --
>  drivers/scsi/aacraid/linit.c   |  2 ++
>  5 files changed, 44 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aac=
hba.c
> index e4c2437..7dfd0fa 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -323,7 +323,6 @@ static inline int aac_valid_context(struct scsi_c=
mnd *scsicmd,
>  	if (unlikely(!scsicmd || !scsicmd->scsi_done)) {
>  		dprintk((KERN_WARNING "aac_valid_context: scsi command corrupt\n")=
);
>  		aac_fib_complete(fibptr);
> -		aac_fib_free(fibptr);
>  		return 0;
>  	}
>  	scsicmd->SCp.phase =3D AAC_OWNER_MIDLEVEL;
> @@ -331,7 +330,6 @@ static inline int aac_valid_context(struct scsi_c=
mnd *scsicmd,
>  	if (unlikely(!device || !scsi_device_online(device))) {
>  		dprintk((KERN_WARNING "aac_valid_context: scsi device corrupt\n"))=
;
>  		aac_fib_complete(fibptr);
> -		aac_fib_free(fibptr);
>  		return 0;
>  	}
>  	return 1;
> @@ -541,7 +539,6 @@ static void get_container_name_callback(void *con=
text, struct fib * fibptr)
>  	scsicmd->result =3D DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT=
_GOOD;
> =20
>  	aac_fib_complete(fibptr);
> -	aac_fib_free(fibptr);
>  	scsicmd->scsi_done(scsicmd);
>  }
> =20
> @@ -557,7 +554,8 @@ static int aac_get_container_name(struct scsi_cmn=
d * scsicmd)
> =20
>  	dev =3D (struct aac_dev *)scsicmd->device->host->hostdata;
> =20
> -	if (!(cmd_fibcontext =3D aac_fib_alloc(dev)))
> +	cmd_fibcontext =3D aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext)
>  		return -ENOMEM;
> =20
>  	aac_fib_init(cmd_fibcontext);
> @@ -586,7 +584,6 @@ static int aac_get_container_name(struct scsi_cmn=
d * scsicmd)
> =20
>  	printk(KERN_WARNING "aac_get_container_name: aac_fib_send failed wi=
th status: %d.\n", status);
>  	aac_fib_complete(cmd_fibcontext);
> -	aac_fib_free(cmd_fibcontext);
>  	return -1;
>  }
> =20
> @@ -1024,7 +1021,6 @@ static void get_container_serial_callback(void =
*context, struct fib * fibptr)
>  	scsicmd->result =3D DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT=
_GOOD;
> =20
>  	aac_fib_complete(fibptr);
> -	aac_fib_free(fibptr);
>  	scsicmd->scsi_done(scsicmd);
>  }
> =20
> @@ -1040,7 +1036,8 @@ static int aac_get_container_serial(struct scsi=
_cmnd * scsicmd)
> =20
>  	dev =3D (struct aac_dev *)scsicmd->device->host->hostdata;
> =20
> -	if (!(cmd_fibcontext =3D aac_fib_alloc(dev)))
> +	cmd_fibcontext =3D aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext)
>  		return -ENOMEM;
> =20
>  	aac_fib_init(cmd_fibcontext);
> @@ -1068,7 +1065,6 @@ static int aac_get_container_serial(struct scsi=
_cmnd * scsicmd)
> =20
>  	printk(KERN_WARNING "aac_get_container_serial: aac_fib_send failed =
with status: %d.\n", status);
>  	aac_fib_complete(cmd_fibcontext);
> -	aac_fib_free(cmd_fibcontext);
>  	return -1;
>  }
> =20
> @@ -1869,7 +1865,6 @@ static void io_callback(void *context, struct f=
ib * fibptr)
>  		break;
>  	}
>  	aac_fib_complete(fibptr);
> -	aac_fib_free(fibptr);
> =20
>  	scsicmd->scsi_done(scsicmd);
>  }
> @@ -1954,7 +1949,8 @@ static int aac_read(struct scsi_cmnd * scsicmd)
>  	/*
>  	 *	Alocate and initialize a Fib
>  	 */
> -	if (!(cmd_fibcontext =3D aac_fib_alloc(dev))) {
> +	cmd_fibcontext =3D aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext) {
>  		printk(KERN_WARNING "aac_read: fib allocation failed\n");
>  		return -1;
>  	}
> @@ -2051,7 +2047,8 @@ static int aac_write(struct scsi_cmnd * scsicmd=
)
>  	/*
>  	 *	Allocate and initialize a Fib then setup a BlockWrite command
>  	 */
> -	if (!(cmd_fibcontext =3D aac_fib_alloc(dev))) {
> +	cmd_fibcontext =3D aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext) {
>  		/* FIB temporarily unavailable,not catastrophic failure */
> =20
>  		/* scsicmd->result =3D DID_ERROR << 16;
> @@ -2285,7 +2282,7 @@ static int aac_start_stop(struct scsi_cmnd *scs=
icmd)
>  	/*
>  	 *	Allocate and initialize a Fib
>  	 */
> -	cmd_fibcontext =3D aac_fib_alloc(aac);
> +	cmd_fibcontext =3D aac_fib_alloc_tag(aac, scsicmd);
>  	if (!cmd_fibcontext)
>  		return SCSI_MLQUEUE_HOST_BUSY;
> =20
> @@ -3157,7 +3154,6 @@ static void aac_srb_callback(void *context, str=
uct fib * fibptr)
>  	scsicmd->result |=3D le32_to_cpu(srbreply->scsi_status);
> =20
>  	aac_fib_complete(fibptr);
> -	aac_fib_free(fibptr);
>  	scsicmd->scsi_done(scsicmd);
>  }
> =20
> @@ -3187,9 +3183,10 @@ static int aac_send_srb_fib(struct scsi_cmnd* =
scsicmd)
>  	/*
>  	 *	Allocate and initialize a Fib then setup a BlockWrite command
>  	 */
> -	if (!(cmd_fibcontext =3D aac_fib_alloc(dev))) {
> +	cmd_fibcontext =3D aac_fib_alloc_tag(dev, scsicmd);
> +	if (!cmd_fibcontext)
>  		return -1;
> -	}
> +
>  	status =3D aac_adapter_scsi(cmd_fibcontext, scsicmd);
> =20
>  	/*
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index 074878b..f51f0a0 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -2114,6 +2114,7 @@ int aac_acquire_irq(struct aac_dev *dev);
>  void aac_free_irq(struct aac_dev *dev);
>  const char *aac_driverinfo(struct Scsi_Host *);
>  struct fib *aac_fib_alloc(struct aac_dev *dev);
> +struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd =
*scmd);
>  int aac_fib_setup(struct aac_dev *dev);
>  void aac_fib_map_free(struct aac_dev *dev);
>  void aac_fib_free(struct fib * context);
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/co=
mmsup.c
> index a1f90fe..6b286b3 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -137,6 +137,7 @@ int aac_fib_setup(struct aac_dev * dev)
>  		i++, fibptr++)
>  	{
>  		fibptr->flags =3D 0;
> +		fibptr->size =3D sizeof(struct fib);
>  		fibptr->dev =3D dev;
>  		fibptr->hw_fib_va =3D hw_fib;
>  		fibptr->data =3D (void *) fibptr->hw_fib_va->data;
> @@ -156,13 +157,38 @@ int aac_fib_setup(struct aac_dev * dev)
>  	 */
>  	dev->fibs[dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB - 1].next=
 =3D NULL;
>  	/*
> -	 *	Enable this to debug out of queue space
> -	 */
> -	dev->free_fib =3D &dev->fibs[0];
> +	*	Set 8 fibs aside for management tools
> +	*/
> +	dev->free_fib =3D &dev->fibs[dev->scsi_host_ptr->can_queue];
>  	return 0;
>  }
> =20
>  /**
> + *	aac_fib_alloc_tag	-	allocate a fib
> + *	@dev: Adapter to allocate the fib for
> + *
> + *	Allocate a fib from the adapter fib pool using tags
> + *	from the blk layer.
> + */
> +
> +struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd =
*scmd)
> +{
> +	struct fib *fibptr;
> +
> +	fibptr =3D &dev->fibs[scmd->request->tag];
> +	/*
> +	 *	Null out fields that depend on being zero at the start of
> +	 *	each I/O
> +	 */
> +	fibptr->hw_fib_va->header.XferState =3D 0;
> +	fibptr->type =3D FSAFS_NTC_FIB_CONTEXT;
> +	fibptr->callback_data =3D NULL;
> +	fibptr->callback =3D NULL;
> +
> +	return fibptr;
> +}
> +
> +/**
>   *	aac_fib_alloc	-	allocate a fib
>   *	@dev: Adapter to allocate the fib for
>   *
> diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpc=
sup.c
> index da9d993..d677b52 100644
> --- a/drivers/scsi/aacraid/dpcsup.c
> +++ b/drivers/scsi/aacraid/dpcsup.c
> @@ -394,7 +394,6 @@ unsigned int aac_intr_normal(struct aac_dev *dev,=
 u32 index,
>  				fib->callback(fib->callback_data, fib);
>  			} else {
>  				aac_fib_complete(fib);
> -				aac_fib_free(fib);
>  			}
>  		} else {
>  			unsigned long flagv;
> @@ -416,7 +415,6 @@ unsigned int aac_intr_normal(struct aac_dev *dev,=
 u32 index,
>  				fib->done =3D 0;
>  				spin_unlock_irqrestore(&fib->event_lock, flagv);
>  				aac_fib_complete(fib);
> -				aac_fib_free(fib);
>  			}
> =20
>  		}
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index 76eaa38..129a515 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -454,6 +454,8 @@ static int aac_slave_configure(struct scsi_device=
 *sdev)
>  	} else
>  		scsi_change_queue_depth(sdev, 1);
> =20
> +		sdev->tagged_supported =3D 1;
> +
>  	return 0;
>  }
> =20
> --=20
> 1.9.1
>=20

Looks good,
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
