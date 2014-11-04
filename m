From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/11] scsi: always assign block layer tags if enabled
Date: Tue, 04 Nov 2014 10:01:20 +0100
Message-ID: <545895E0.1000902@suse.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaKDJBX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 04:01:23 -0500
In-Reply-To: <1415087656-9491-9-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/2014 08:54 AM, Christoph Hellwig wrote:
> Allow a driver to ask for block layer tags by setting .use_blk_tags i=
n the
> host template, in which case it will always see a valid value in
> request->tag, similar to the behavior when using blk-mq.  This means =
even
> SCSI "untagged" commands will now have a tag, which is especially use=
ful
> when using a host-wide tag map.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/scsi/scsi_mid_low_api.txt | 38 +----------------------=
----------
>  drivers/message/fusion/mptsas.c         |  1 +
>  drivers/scsi/53c700.c                   | 12 +++++------
>  drivers/scsi/aic7xxx/aic79xx_osm.c      | 11 +++++-----
>  drivers/scsi/aic7xxx/aic7xxx_osm.c      | 11 +++++-----
>  drivers/scsi/aic94xx/aic94xx_init.c     |  1 +
>  drivers/scsi/bfa/bfad_im.c              |  8 +++----
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c       |  1 +
>  drivers/scsi/csiostor/csio_scsi.c       |  8 +++----
>  drivers/scsi/esas2r/esas2r_main.c       | 12 +++++------
>  drivers/scsi/esp_scsi.c                 |  6 +++---
>  drivers/scsi/fcoe/fcoe.c                |  1 +
>  drivers/scsi/fnic/fnic_main.c           |  3 ++-
>  drivers/scsi/ibmvscsi/ibmvfc.c          | 11 +++++-----
>  drivers/scsi/ipr.c                      |  1 +
>  drivers/scsi/isci/init.c                |  1 +
>  drivers/scsi/libfc/fc_fcp.c             |  7 +-----
>  drivers/scsi/libsas/sas_scsi_host.c     | 11 +++-------
>  drivers/scsi/lpfc/lpfc_scsi.c           |  7 +++---
>  drivers/scsi/mvsas/mv_init.c            |  1 +
>  drivers/scsi/pm8001/pm8001_init.c       |  1 +
>  drivers/scsi/pmcraid.c                  |  4 ++--
>  drivers/scsi/qla2xxx/qla_os.c           |  6 ++----
>  drivers/scsi/qla4xxx/ql4_os.c           | 10 ++-------
>  drivers/scsi/scsi.c                     | 12 ++++-------
>  drivers/scsi/scsi_scan.c                |  6 ++++++
>  drivers/scsi/stex.c                     | 10 ++-------
>  drivers/scsi/tmscsim.c                  |  3 ++-
>  drivers/scsi/ufs/ufshcd.c               |  5 +++--
>  drivers/target/loopback/tcm_loop.c      |  2 +-
>  drivers/usb/storage/uas.c               |  4 ++--
>  include/scsi/scsi_host.h                |  5 +++++
>  include/scsi/scsi_tcq.h                 | 34 -----------------------=
------
>  33 files changed, 86 insertions(+), 168 deletions(-)
>=20
> diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/=
scsi/scsi_mid_low_api.txt
> index d6a9bde..a671942 100644
> --- a/Documentation/scsi/scsi_mid_low_api.txt
> +++ b/Documentation/scsi/scsi_mid_low_api.txt
> @@ -366,13 +366,11 @@ is initialized. The functions below are listed =
alphabetically and their
>  names all start with "scsi_".
> =20
>  Summary:
> -   scsi_activate_tcq - turn on tag command queueing
>     scsi_add_device - creates new scsi device (lu) instance
>     scsi_add_host - perform sysfs registration and set up transport c=
lass
>     scsi_adjust_queue_depth - change the queue depth on a SCSI device
>     scsi_bios_ptable - return copy of block device's partition table
>     scsi_block_requests - prevent further commands being queued to gi=
ven host
> -   scsi_deactivate_tcq - turn off tag command queueing
>     scsi_host_alloc - return a new scsi_host instance whose refcount=3D=
=3D1
>     scsi_host_get - increments Scsi_Host instance's refcount
>     scsi_host_put - decrements Scsi_Host instance's refcount (free if=
 0)
> @@ -390,24 +388,6 @@ Summary:
>  Details:
> =20
>  /**
> - * scsi_activate_tcq - turn on tag command queueing ("ordered" task =
attribute)
> - * @sdev:       device to turn on TCQ for
> - * @depth:      queue depth
> - *
> - *      Returns nothing
> - *
> - *      Might block: no
> - *
> - *      Notes: Eventually, it is hoped depth would be the maximum de=
pth
> - *      the device could cope with and the real queue depth
> - *      would be adjustable from 0 to depth.
> - *
> - *      Defined (inline) in: include/scsi/scsi_tcq.h
> - **/
> -void scsi_activate_tcq(struct scsi_device *sdev, int depth)
> -
> -
> -/**
>   * scsi_add_device - creates new scsi device (lu) instance
>   * @shost:   pointer to scsi host instance
>   * @channel: channel number (rarely other than 0)
> @@ -471,9 +451,7 @@ int scsi_add_host(struct Scsi_Host *shost, struct=
 device * dev)
>   *
>   *      Notes: Can be invoked any time on a SCSI device controlled b=
y this
>   *      LLD. [Specifically during and after slave_configure() and pr=
ior to
> - *      slave_destroy().] Can safely be invoked from interrupt code.=
 Actual
> - *      queue depth change may be delayed until the next command is =
being
> - *      processed. See also scsi_activate_tcq() and scsi_deactivate_=
tcq().
> + *      slave_destroy().] Can safely be invoked from interrupt code.
>   *
>   *      Defined in: drivers/scsi/scsi.c [see source code for more no=
tes]
>   *
> @@ -515,20 +493,6 @@ void scsi_block_requests(struct Scsi_Host * shos=
t)
> =20
> =20
>  /**
> - * scsi_deactivate_tcq - turn off tag command queueing
> - * @sdev:       device to turn off TCQ for
> - * @depth:      queue depth (stored in sdev)
> - *
> - *      Returns nothing
> - *
> - *      Might block: no
> - *
> - *      Defined (inline) in: include/scsi/scsi_tcq.h
> - **/
> -void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
> -
> -
> -/**
>   * scsi_host_alloc - create a scsi host adapter instance and perform=
 basic
>   *                   initialization.
>   * @sht:        pointer to scsi host template
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion=
/mptsas.c
> index 0707fa2..5bdaae1 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -1994,6 +1994,7 @@ static struct scsi_host_template mptsas_driver_=
template =3D {
>  	.cmd_per_lun			=3D 7,
>  	.use_clustering			=3D ENABLE_CLUSTERING,
>  	.shost_attrs			=3D mptscsih_host_attrs,
> +	.use_blk_tags			=3D 1,
>  };
> =20
>  static int mptsas_get_linkerrors(struct sas_phy *phy)
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index 1b36fd3..497cbb1 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -327,6 +327,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
>  	tpnt->slave_alloc =3D NCR_700_slave_alloc;
>  	tpnt->change_queue_depth =3D NCR_700_change_queue_depth;
>  	tpnt->change_queue_type =3D NCR_700_change_queue_type;
> +	tpnt->use_blk_tags =3D 1;
> =20
>  	if(tpnt->name =3D=3D NULL)
>  		tpnt->name =3D "53c700";
> @@ -902,7 +903,7 @@ process_message(struct Scsi_Host *host,	struct NC=
R_700_Host_Parameters *hostdata
>  			NCR_700_set_tag_neg_state(SCp->device, NCR_700_FINISHED_TAG_NEGOT=
IATION);
>  			hostdata->tag_negotiated &=3D ~(1<<scmd_id(SCp));
>  			SCp->device->tagged_supported =3D 0;
> -			scsi_deactivate_tcq(SCp->device, host->cmd_per_lun);
> +			scsi_adjust_queue_depth(SCp->device, 0, host->cmd_per_lun);
>  		} else {
>  			shost_printk(KERN_WARNING, host,
>  				"(%d:%d) Unexpected REJECT Message %s\n",
> @@ -2049,8 +2050,7 @@ NCR_700_slave_configure(struct scsi_device *SDp=
)
> =20
>  	/* to do here: allocate memory; build a queue_full list */
>  	if(SDp->tagged_supported) {
> -		scsi_set_tag_type(SDp, MSG_ORDERED_TAG);
> -		scsi_activate_tcq(SDp, NCR_700_DEFAULT_TAGS);
> +		scsi_adjust_queue_depth(SDp, MSG_ORDERED_TAG, NCR_700_DEFAULT_TAGS=
);
>  		NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
>  	} else {
>  		/* initialise to default depth */
> @@ -2094,8 +2094,6 @@ static int NCR_700_change_queue_type(struct scs=
i_device *SDp, int tag_type)
>  	struct NCR_700_Host_Parameters *hostdata =3D=20
>  		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
> =20
> -	scsi_set_tag_type(SDp, tag_type);
> -
>  	/* We have a global (per target) flag to track whether TCQ is
>  	 * enabled, so we'll be turning it off for the entire target here.
>  	 * our tag algorithm will fail if we mix tagged and untagged comman=
ds,
> @@ -2106,12 +2104,12 @@ static int NCR_700_change_queue_type(struct s=
csi_device *SDp, int tag_type)
>  	if (!tag_type) {
>  		/* shift back to the default unqueued number of commands
>  		 * (the user can still raise this) */
> -		scsi_deactivate_tcq(SDp, SDp->host->cmd_per_lun);
> +		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
>  		hostdata->tag_negotiated &=3D ~(1 << sdev_id(SDp));
>  	} else {
>  		/* Here, we cleared the negotiation flag above, so this
>  		 * will force the driver to renegotiate */
> -		scsi_activate_tcq(SDp, SDp->queue_depth);
> +		scsi_adjust_queue_depth(SDp, tag_type, SDp->queue_depth);
>  		if (change_tag)
>  			NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
>  	}
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xx=
x/aic79xx_osm.c
> index d3b6d68..9fd6b56 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -925,6 +925,7 @@ struct scsi_host_template aic79xx_driver_template=
 =3D {
>  	.slave_configure	=3D ahd_linux_slave_configure,
>  	.target_alloc		=3D ahd_linux_target_alloc,
>  	.target_destroy		=3D ahd_linux_target_destroy,
> +	.use_blk_tags		=3D 1,
>  };
> =20
>  /******************************** Bus DMA **************************=
***********/
> @@ -1468,12 +1469,12 @@ ahd_platform_set_tags(struct ahd_softc *ahd, =
struct scsi_device *sdev,
> =20
>  	switch ((dev->flags & (AHD_DEV_Q_BASIC|AHD_DEV_Q_TAGGED))) {
>  	case AHD_DEV_Q_BASIC:
> -		scsi_set_tag_type(sdev, MSG_SIMPLE_TASK);
> -		scsi_activate_tcq(sdev, dev->openings + dev->active);
> +		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TASK,
> +				dev->openings + dev->active);
>  		break;
>  	case AHD_DEV_Q_TAGGED:
> -		scsi_set_tag_type(sdev, MSG_ORDERED_TASK);
> -		scsi_activate_tcq(sdev, dev->openings + dev->active);
> +		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TASK,
> +				dev->openings + dev->active);
>  		break;
>  	default:
>  		/*
> @@ -1482,7 +1483,7 @@ ahd_platform_set_tags(struct ahd_softc *ahd, st=
ruct scsi_device *sdev,
>  		 * serially on the controller/device.  This should
>  		 * remove some latency.
>  		 */
> -		scsi_deactivate_tcq(sdev, 1);
> +		scsi_adjust_queue_depth(sdev, 0, 1);
>  		break;
>  	}
>  }
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xx=
x/aic7xxx_osm.c
> index 33a5f95..f18b6d6 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -812,6 +812,7 @@ struct scsi_host_template aic7xxx_driver_template=
 =3D {
>  	.slave_configure	=3D ahc_linux_slave_configure,
>  	.target_alloc		=3D ahc_linux_target_alloc,
>  	.target_destroy		=3D ahc_linux_target_destroy,
> +	.use_blk_tags		=3D 1,
>  };
> =20
>  /**************************** Tasklet Handler **********************=
***********/
> @@ -1334,12 +1335,12 @@ ahc_platform_set_tags(struct ahc_softc *ahc, =
struct scsi_device *sdev,
>  	}
>  	switch ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED))) {
>  	case AHC_DEV_Q_BASIC:
> -		scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
> -		scsi_activate_tcq(sdev, dev->openings + dev->active);
> +		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TASK,
> +				dev->openings + dev->active);
>  		break;
>  	case AHC_DEV_Q_TAGGED:
> -		scsi_set_tag_type(sdev, MSG_ORDERED_TAG);
> -		scsi_activate_tcq(sdev, dev->openings + dev->active);
> +		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TASK,
> +				dev->openings + dev->active);
>  		break;
>  	default:
>  		/*
> @@ -1348,7 +1349,7 @@ ahc_platform_set_tags(struct ahc_softc *ahc, st=
ruct scsi_device *sdev,
>  		 * serially on the controller/device.  This should
>  		 * remove some latency.
>  		 */
> -		scsi_deactivate_tcq(sdev, 2);
> +		scsi_adjust_queue_depth(sdev, 0, 2);
>  		break;
>  	}
>  }
Hmm. With patch 03/11 and 04/11 you've removed the ordered_tags
fields, on the ground that the block layer never issues ordered tags
nowadays.
Yet these drivers still try to activate ordered tags.
So what's happening here?
Do these drivers switch on ordered tags on their own?
If so, why shouldn't the other drivers (like the various FC HBAs) be
allowed to do it, too?
Shouldn't we rather remove ordered tagging from those drivers, too?

(Although I'm not too happy about removing ordered tags support in
the other drivers. I have the nagging feeling they might become
important if and when ZBC ever gets off the ground ...)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
