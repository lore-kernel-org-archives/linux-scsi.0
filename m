From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/11] scsi: don't set tagging state from scsi_adjust_queue_depth
Date: Tue, 04 Nov 2014 10:26:57 +0100
Message-ID: <54589BE1.6070106@suse.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbaKDJ1A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 04:27:00 -0500
In-Reply-To: <1415087656-9491-10-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/2014 08:54 AM, Christoph Hellwig wrote:
> Remove the tagged argument from scsi_adjust_queue_depth, and just let=
 it
> handle the queue depth.  For most drivers those two are fairly separa=
te,
> given that most modern drivers don't care about the SCSI "tagged" sta=
tus
> of a command at all, and many old drivers allow queuing of multiple
> untagged commands in the driver.
>=20
> Instead we start out with the ->simple_tags flag set before calling
> ->slave_configure, which is how all drivers actually looking at
> ->simple_tags except for one worke anyway.  The one other case looks
> broken, but I've kept the behavior as-is for now.
>=20
> Except for that we only change ->simple_tags from the ->change_queue_=
type,
> and when rejecting a tag message in a single driver, so keeping this
> churn out of scsi_adjust_queue_depth is a clear win.
>=20
> Now that the usage of scsi_adjust_queue_depth is more obvious we can
> also remove all the trivial instances in ->slave_alloc or ->slave_con=
figure
> that just set it to the cmd_per_lun default.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/scsi/scsi_mid_low_api.txt   | 12 ++++------
>  drivers/ata/libata-scsi.c                 |  4 ++--
>  drivers/infiniband/ulp/srp/ib_srp.c       |  2 +-
>  drivers/message/fusion/mptscsih.c         |  2 +-
>  drivers/s390/scsi/zfcp_scsi.c             |  8 +++----
>  drivers/scsi/3w-9xxx.c                    |  2 +-
>  drivers/scsi/3w-sas.c                     |  2 +-
>  drivers/scsi/3w-xxxx.c                    |  2 +-
>  drivers/scsi/53c700.c                     | 17 ++++++-------
>  drivers/scsi/BusLogic.c                   |  4 ++--
>  drivers/scsi/aacraid/linit.c              |  9 ++++---
>  drivers/scsi/advansys.c                   |  7 ++----
>  drivers/scsi/aic7xxx/aic79xx_osm.c        |  7 ++----
>  drivers/scsi/aic7xxx/aic7xxx_osm.c        |  8 ++-----
>  drivers/scsi/arcmsr/arcmsr_hba.c          |  2 +-
>  drivers/scsi/bfa/bfad_im.c                |  3 +--
>  drivers/scsi/csiostor/csio_scsi.c         |  2 +-
>  drivers/scsi/dpt_i2o.c                    |  4 +---
>  drivers/scsi/eata.c                       |  8 +++----
>  drivers/scsi/esas2r/esas2r.h              |  3 ---
>  drivers/scsi/esas2r/esas2r_main.c         | 29 +--------------------=
-
>  drivers/scsi/esp_scsi.c                   | 17 ++-----------
>  drivers/scsi/fnic/fnic_main.c             |  2 +-
>  drivers/scsi/gdth.c                       |  1 -
>  drivers/scsi/hpsa.c                       |  2 +-
>  drivers/scsi/hptiop.c                     |  2 +-
>  drivers/scsi/ibmvscsi/ibmvfc.c            |  8 +------
>  drivers/scsi/ibmvscsi/ibmvscsi.c          |  3 +--
>  drivers/scsi/ipr.c                        |  8 +++----
>  drivers/scsi/ips.c                        |  2 +-
>  drivers/scsi/libfc/fc_fcp.c               |  6 ++---
>  drivers/scsi/libiscsi.c                   |  4 ++--
>  drivers/scsi/libsas/sas_scsi_host.c       | 20 +++++-----------
>  drivers/scsi/lpfc/lpfc_scsi.c             |  4 ++--
>  drivers/scsi/megaraid/megaraid_mbox.c     |  2 +-
>  drivers/scsi/megaraid/megaraid_sas_base.c |  3 +--
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c      |  2 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  2 +-
>  drivers/scsi/ncr53c8xx.c                  |  5 +---
>  drivers/scsi/pmcraid.c                    | 40 ++++++---------------=
----------
>  drivers/scsi/qla1280.c                    |  5 ++--
>  drivers/scsi/qla2xxx/qla_os.c             |  6 ++---
>  drivers/scsi/qla4xxx/ql4_os.c             |  2 +-
>  drivers/scsi/scsi.c                       | 25 ++++---------------
>  drivers/scsi/scsi_debug.c                 |  7 ++----
>  drivers/scsi/scsi_scan.c                  |  6 +++--
>  drivers/scsi/stex.c                       |  2 --
>  drivers/scsi/storvsc_drv.c                |  3 +--
>  drivers/scsi/sym53c8xx_2/sym_glue.c       |  4 +---
>  drivers/scsi/tmscsim.c                    |  9 ++++++-
>  drivers/scsi/u14-34f.c                    | 10 ++++----
>  drivers/scsi/ufs/ufshcd.c                 |  4 ++--
>  drivers/scsi/virtio_scsi.c                |  4 +---
>  drivers/scsi/vmw_pvscsi.c                 |  2 +-
>  drivers/target/loopback/tcm_loop.c        | 18 ++------------
>  drivers/usb/storage/uas.c                 |  2 +-
>  include/scsi/scsi_device.h                |  2 +-
>  57 files changed, 120 insertions(+), 261 deletions(-)
>=20
> diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/=
scsi/scsi_mid_low_api.txt
> index a671942..bee7d86 100644
> --- a/Documentation/scsi/scsi_mid_low_api.txt
> +++ b/Documentation/scsi/scsi_mid_low_api.txt
> @@ -271,9 +271,9 @@ init_this_scsi_driver() ----+
>                        slave_destroy() ***
>  ------------------------------------------------------------
> =20
> -The mid level invokes scsi_adjust_queue_depth() with tagged queuing =
off and
> -"cmd_per_lun" for that host as the queue length. These settings can =
be
> -overridden by a slave_configure() supplied by the LLD.
> +The mid level invokes scsi_adjust_queue_depth() with "cmd_per_lun" f=
or that
> +host as the queue length. These settings can be overridden by a
> +slave_configure() supplied by the LLD.
> =20
>  *** For scsi devices that the mid level tries to scan but do not
>      respond, a slave_alloc(), slave_destroy() pair is called.
> @@ -438,9 +438,6 @@ int scsi_add_host(struct Scsi_Host *shost, struct=
 device * dev)
>  /**
>   * scsi_adjust_queue_depth - allow LLD to change queue depth on a SC=
SI device
>   * @sdev:       pointer to SCSI device to change queue depth on
> - * @tagged:     0 - no tagged queuing
> - *              MSG_SIMPLE_TAG - simple tagged queuing
> - *              MSG_ORDERED_TAG - ordered tagged queuing
>   * @tags        Number of tags allowed if tagged queuing enabled,
>   *              or number of commands the LLD can queue up
>   *              in non-tagged mode (as per cmd_per_lun).
> @@ -456,8 +453,7 @@ int scsi_add_host(struct Scsi_Host *shost, struct=
 device * dev)
>   *      Defined in: drivers/scsi/scsi.c [see source code for more no=
tes]
>   *
>   **/
> -void scsi_adjust_queue_depth(struct scsi_device * sdev, int tagged,=20
> -                             int tags)
> +void scsi_adjust_queue_depth(struct scsi_device *sdev, int tags)
> =20
> =20
>  /**
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 0586f66..c8bb6ab 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1164,7 +1164,7 @@ static int ata_scsi_dev_config(struct scsi_devi=
ce *sdev,
> =20
>  		depth =3D min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
>  		depth =3D min(ATA_MAX_QUEUE - 1, depth);
> -		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  	}
> =20
>  	blk_queue_flush_queueable(q, false);
> @@ -1282,7 +1282,7 @@ int __ata_change_queue_depth(struct ata_port *a=
p, struct scsi_device *sdev,
>  	if (sdev->queue_depth =3D=3D queue_depth)
>  		return -EINVAL;
> =20
> -	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
> +	scsi_adjust_queue_depth(sdev, queue_depth);
>  	return queue_depth;
>  }
> =20
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
> index 51670d7..023a66f 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2278,7 +2278,7 @@ srp_change_queue_depth(struct scsi_device *sdev=
, int qdepth, int reason)
>  			max_depth =3D 1;
>  		if (qdepth > max_depth)
>  			qdepth =3D max_depth;
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +		scsi_adjust_queue_depth(sdev, qdepth);
>  	} else if (reason =3D=3D SCSI_QDEPTH_QFULL)
>  		scsi_track_queue_full(sdev, qdepth);
>  	else
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusi=
on/mptscsih.c
> index c0d84a0..dee06d6 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -2347,7 +2347,7 @@ mptscsih_change_queue_depth(struct scsi_device =
*sdev, int qdepth, int reason)
>  	if (qdepth > max_depth)
>  		qdepth =3D max_depth;
> =20
> -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
>  	return sdev->queue_depth;
>  }
> =20
> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_s=
csi.c
> index 7b35364..b5dfa51 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -37,13 +37,13 @@ static int zfcp_scsi_change_queue_depth(struct sc=
si_device *sdev, int depth,
>  {
>  	switch (reason) {
>  	case SCSI_QDEPTH_DEFAULT:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  		break;
>  	case SCSI_QDEPTH_QFULL:
>  		scsi_track_queue_full(sdev, depth);
>  		break;
>  	case SCSI_QDEPTH_RAMP_UP:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> @@ -66,9 +66,7 @@ static void zfcp_scsi_slave_destroy(struct scsi_dev=
ice *sdev)
>  static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
>  {
>  	if (sdp->tagged_supported)
> -		scsi_adjust_queue_depth(sdp, MSG_SIMPLE_TAG, default_depth);
> -	else
> -		scsi_adjust_queue_depth(sdp, 0, 1);
> +		scsi_adjust_queue_depth(sdp, default_depth);
>  	return 0;
>  }
> =20
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 0a73253..02021f5 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -198,7 +198,7 @@ static int twa_change_queue_depth(struct scsi_dev=
ice *sdev, int queue_depth,
> =20
>  	if (queue_depth > TW_Q_LENGTH-2)
>  		queue_depth =3D TW_Q_LENGTH-2;
> -	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
> +	scsi_adjust_queue_depth(sdev, queue_depth);
>  	return queue_depth;
>  } /* End twa_change_queue_depth() */
> =20
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index 6da6cec..ac0c254 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -200,7 +200,7 @@ static int twl_change_queue_depth(struct scsi_dev=
ice *sdev, int queue_depth,
> =20
>  	if (queue_depth > TW_Q_LENGTH-2)
>  		queue_depth =3D TW_Q_LENGTH-2;
> -	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
> +	scsi_adjust_queue_depth(sdev, queue_depth);
>  	return queue_depth;
>  } /* End twl_change_queue_depth() */
> =20
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index 752624e..1ec9ad9 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -532,7 +532,7 @@ static int tw_change_queue_depth(struct scsi_devi=
ce *sdev, int queue_depth,
> =20
>  	if (queue_depth > TW_Q_LENGTH-2)
>  		queue_depth =3D TW_Q_LENGTH-2;
> -	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
> +	scsi_adjust_queue_depth(sdev, queue_depth);
>  	return queue_depth;
>  } /* End tw_change_queue_depth() */
> =20
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index 497cbb1..d7557b9 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -902,8 +902,10 @@ process_message(struct Scsi_Host *host,	struct N=
CR_700_Host_Parameters *hostdata
>  			/* we're done negotiating */
>  			NCR_700_set_tag_neg_state(SCp->device, NCR_700_FINISHED_TAG_NEGOT=
IATION);
>  			hostdata->tag_negotiated &=3D ~(1<<scmd_id(SCp));
> +
>  			SCp->device->tagged_supported =3D 0;
> -			scsi_adjust_queue_depth(SCp->device, 0, host->cmd_per_lun);
> +			scsi_adjust_queue_depth(SCp->device, host->cmd_per_lun);
> +			scsi_set_tag_type(SCp->device, 0);
>  		} else {
>  			shost_printk(KERN_WARNING, host,
>  				"(%d:%d) Unexpected REJECT Message %s\n",
> @@ -2050,12 +2052,10 @@ NCR_700_slave_configure(struct scsi_device *S=
Dp)
> =20
>  	/* to do here: allocate memory; build a queue_full list */
>  	if(SDp->tagged_supported) {
> -		scsi_adjust_queue_depth(SDp, MSG_ORDERED_TAG, NCR_700_DEFAULT_TAGS=
);
> +		scsi_adjust_queue_depth(SDp, NCR_700_DEFAULT_TAGS);
>  		NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
> -	} else {
> -		/* initialise to default depth */
> -		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
>  	}
> +
>  	if(hostdata->fast) {
>  		/* Find the correct offset and period via domain validation */
>  		if (!spi_initial_dv(SDp->sdev_target))
> @@ -2083,7 +2083,7 @@ NCR_700_change_queue_depth(struct scsi_device *=
SDp, int depth, int reason)
>  	if (depth > NCR_700_MAX_TAGS)
>  		depth =3D NCR_700_MAX_TAGS;
> =20
> -	scsi_adjust_queue_depth(SDp, scsi_get_tag_type(SDp), depth);
> +	scsi_adjust_queue_depth(SDp, depth);
>  	return depth;
>  }
> =20
> @@ -2101,15 +2101,16 @@ static int NCR_700_change_queue_type(struct s=
csi_device *SDp, int tag_type)
>  	if (change_tag)
>  		scsi_target_quiesce(SDp->sdev_target);
> =20
> +	scsi_set_tag_type(SDp, tag_type);
>  	if (!tag_type) {
>  		/* shift back to the default unqueued number of commands
>  		 * (the user can still raise this) */
> -		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
> +		scsi_adjust_queue_depth(SDp, SDp->host->cmd_per_lun);
>  		hostdata->tag_negotiated &=3D ~(1 << sdev_id(SDp));
>  	} else {
>  		/* Here, we cleared the negotiation flag above, so this
>  		 * will force the driver to renegotiate */
> -		scsi_adjust_queue_depth(SDp, tag_type, SDp->queue_depth);
> +		scsi_adjust_queue_depth(SDp, SDp->queue_depth);
>  		if (change_tag)
>  			NCR_700_set_tag_neg_state(SDp, NCR_700_START_TAG_NEGOTIATION);
>  	}
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 64c7514..5aa476b 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2327,12 +2327,12 @@ static int blogic_slaveconfig(struct scsi_dev=
ice *dev)
>  		if (qdepth =3D=3D 0)
>  			qdepth =3D BLOGIC_MAX_AUTO_TAG_DEPTH;
>  		adapter->qdepth[tgt_id] =3D qdepth;
> -		scsi_adjust_queue_depth(dev, MSG_SIMPLE_TAG, qdepth);
> +		scsi_adjust_queue_depth(dev, qdepth);
>  	} else {
>  		adapter->tagq_ok &=3D ~(1 << tgt_id);
>  		qdepth =3D adapter->untag_qdepth;
>  		adapter->qdepth[tgt_id] =3D qdepth;
> -		scsi_adjust_queue_depth(dev, 0, qdepth);
> +		scsi_adjust_queue_depth(dev, qdepth);
>  	}
>  	qdepth =3D 0;
>  	for (tgt_id =3D 0; tgt_id < adapter->maxdev; tgt_id++)
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/lini=
t.c
> index a759cb2..596c2f4 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -462,9 +462,8 @@ static int aac_slave_configure(struct scsi_device=
 *sdev)
>  			depth =3D 256;
>  		else if (depth < 2)
>  			depth =3D 2;
> -		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
> -	} else
> -		scsi_adjust_queue_depth(sdev, 0, 1);
> +		scsi_adjust_queue_depth(sdev, depth);
> +	}
> =20
>  	return 0;
>  }
Why did you omit the 'else' branch?
cmd_per_lun is set to 256 for aacraid AFAICS ...

> @@ -504,9 +503,9 @@ static int aac_change_queue_depth(struct scsi_dev=
ice *sdev, int depth,
>  			depth =3D 256;
>  		else if (depth < 2)
>  			depth =3D 2;
> -		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  	} else
> -		scsi_adjust_queue_depth(sdev, 0, 1);
> +		scsi_adjust_queue_depth(sdev, 1);
>  	return sdev->queue_depth;
>  }
> =20
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 43761c1..ae4840e 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -7706,7 +7706,7 @@ advansys_narrow_slave_configure(struct scsi_dev=
ice *sdev, ASC_DVC_VAR *asc_dvc)
>  				asc_dvc->cfg->can_tagged_qng |=3D tid_bit;
>  				asc_dvc->use_tagged_qng |=3D tid_bit;
>  			}
> -			scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
> +			scsi_adjust_queue_depth(sdev,=20
>  						asc_dvc->max_dvc_qng[sdev->id]);
>  		}
>  	} else {
> @@ -7714,7 +7714,6 @@ advansys_narrow_slave_configure(struct scsi_dev=
ice *sdev, ASC_DVC_VAR *asc_dvc)
>  			asc_dvc->cfg->can_tagged_qng &=3D ~tid_bit;
>  			asc_dvc->use_tagged_qng &=3D ~tid_bit;
>  		}
> -		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
>  	}
> =20
>  	if ((sdev->lun =3D=3D 0) &&
> @@ -7849,10 +7848,8 @@ advansys_wide_slave_configure(struct scsi_devi=
ce *sdev, ADV_DVC_VAR *adv_dvc)
>  	}
> =20
>  	if ((adv_dvc->tagqng_able & tidmask) && sdev->tagged_supported) {
> -		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
> +		scsi_adjust_queue_depth(sdev,
>  					adv_dvc->max_dvc_qng);
> -	} else {
> -		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
>  	}
>  }
> =20
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xx=
x/aic79xx_osm.c
> index 9fd6b56..80cb4fd 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1469,11 +1469,8 @@ ahd_platform_set_tags(struct ahd_softc *ahd, s=
truct scsi_device *sdev,
> =20
>  	switch ((dev->flags & (AHD_DEV_Q_BASIC|AHD_DEV_Q_TAGGED))) {
>  	case AHD_DEV_Q_BASIC:
> -		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TASK,
> -				dev->openings + dev->active);
> -		break;
>  	case AHD_DEV_Q_TAGGED:
> -		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TASK,
> +		scsi_adjust_queue_depth(sdev,
>  				dev->openings + dev->active);
>  		break;
>  	default:
> @@ -1483,7 +1480,7 @@ ahd_platform_set_tags(struct ahd_softc *ahd, st=
ruct scsi_device *sdev,
>  		 * serially on the controller/device.  This should
>  		 * remove some latency.
>  		 */
> -		scsi_adjust_queue_depth(sdev, 0, 1);
> +		scsi_adjust_queue_depth(sdev, 1);
>  		break;
>  	}
>  }
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xx=
x/aic7xxx_osm.c
> index f18b6d6..a6a27d5 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1335,13 +1335,9 @@ ahc_platform_set_tags(struct ahc_softc *ahc, s=
truct scsi_device *sdev,
>  	}
>  	switch ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED))) {
>  	case AHC_DEV_Q_BASIC:
> -		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TASK,
> -				dev->openings + dev->active);
> -		break;
>  	case AHC_DEV_Q_TAGGED:
> -		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TASK,
> +		scsi_adjust_queue_depth(sdev,
>  				dev->openings + dev->active);
> -		break;
>  	default:
>  		/*
>  		 * We allow the OS to queue 2 untagged transactions to
> @@ -1349,7 +1345,7 @@ ahc_platform_set_tags(struct ahc_softc *ahc, st=
ruct scsi_device *sdev,
>  		 * serially on the controller/device.  This should
>  		 * remove some latency.
>  		 */
> -		scsi_adjust_queue_depth(sdev, 0, 2);
> +		scsi_adjust_queue_depth(sdev, 2);
>  		break;
>  	}
>  }
Hmm. This is actually wrong; it should be set to '1'.
'2' is a left-over from the (long since removed) internal queueing
within the aic7xxx driver.

> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/a=
rcmsr_hba.c
> index 0b44fb5..209f771 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -122,7 +122,7 @@ static int arcmsr_adjust_disk_queue_depth(struct =
scsi_device *sdev,
> =20
>  	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
>  		queue_depth =3D ARCMSR_MAX_CMD_PERLUN;
> -	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
> +	scsi_adjust_queue_depth(sdev, queue_depth);
>  	return queue_depth;
>  }
> =20
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index d8e43c8..87b09cd2 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -776,7 +776,7 @@ bfad_thread_workq(struct bfad_s *bfad)
>  static int
>  bfad_im_slave_configure(struct scsi_device *sdev)
>  {
> -	scsi_adjust_queue_depth(sdev, 0, bfa_lun_queue_depth);
> +	scsi_adjust_queue_depth(sdev, bfa_lun_queue_depth);
>  	return 0;
>  }
> =20
> @@ -867,7 +867,6 @@ bfad_ramp_up_qdepth(struct bfad_itnim_s *itnim, s=
truct scsi_device *sdev)
>  				if (tmp_sdev->id !=3D sdev->id)
>  					continue;
>  				scsi_adjust_queue_depth(tmp_sdev,
> -					MSG_SIMPLE_TAG,
>  					tmp_sdev->queue_depth + 1);
> =20
>  				itnim->last_ramp_up_time =3D jiffies;
> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiosto=
r/csio_scsi.c
> index f73155d..44a8cc5 100644
> --- a/drivers/scsi/csiostor/csio_scsi.c
> +++ b/drivers/scsi/csiostor/csio_scsi.c
> @@ -2241,7 +2241,7 @@ csio_slave_alloc(struct scsi_device *sdev)
>  static int
>  csio_slave_configure(struct scsi_device *sdev)
>  {
> -	scsi_adjust_queue_depth(sdev, 0, csio_lun_qdepth);
> +	scsi_adjust_queue_depth(sdev, csio_lun_qdepth);
>  	return 0;
>  }
> =20
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index 072f0ec..1af8d54 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -415,10 +415,8 @@ static int adpt_slave_configure(struct scsi_devi=
ce * device)
>  	pHba =3D (adpt_hba *) host->hostdata[0];
> =20
>  	if (host->can_queue && device->tagged_supported) {
> -		scsi_adjust_queue_depth(device, MSG_SIMPLE_TAG,
> +		scsi_adjust_queue_depth(device,
>  				host->can_queue - 1);
> -	} else {
> -		scsi_adjust_queue_depth(device, 0, 1);
>  	}
>  	return 0;
>  }
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index 943ad3a..bc0f918 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -946,20 +946,18 @@ static int eata2x_slave_configure(struct scsi_d=
evice *dev)
> =20
>  	if (TLDEV(dev->type) && dev->tagged_supported) {
>  		if (tag_mode =3D=3D TAG_SIMPLE) {
> -			scsi_adjust_queue_depth(dev, MSG_SIMPLE_TAG, tqd);
>  			tag_suffix =3D ", simple tags";
>  		} else if (tag_mode =3D=3D TAG_ORDERED) {
> -			scsi_adjust_queue_depth(dev, MSG_ORDERED_TAG, tqd);
>  			tag_suffix =3D ", ordered tags";
>  		} else {
> -			scsi_adjust_queue_depth(dev, 0, tqd);
>  			tag_suffix =3D ", no tags";
>  		}
> +		scsi_adjust_queue_depth(dev, tqd);
>  	} else if (TLDEV(dev->type) && linked_comm) {
> -		scsi_adjust_queue_depth(dev, 0, tqd);
> +		scsi_adjust_queue_depth(dev, tqd);
>  		tag_suffix =3D ", untagged";
>  	} else {
> -		scsi_adjust_queue_depth(dev, 0, utqd);
> +		scsi_adjust_queue_depth(dev, utqd);
>  		tag_suffix =3D "";
>  	}
> =20
> diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2=
r.h
> index 20ab211..1941d83 100644
> --- a/drivers/scsi/esas2r/esas2r.h
> +++ b/drivers/scsi/esas2r/esas2r.h
> @@ -972,9 +972,6 @@ u8 handle_hba_ioctl(struct esas2r_adapter *a,
>  		    struct atto_ioctl *ioctl_hba);
>  int esas2r_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cm=
d);
>  int esas2r_show_info(struct seq_file *m, struct Scsi_Host *sh);
> -int esas2r_slave_alloc(struct scsi_device *dev);
> -int esas2r_slave_configure(struct scsi_device *dev);
> -void esas2r_slave_destroy(struct scsi_device *dev);
>  int esas2r_change_queue_depth(struct scsi_device *dev, int depth, in=
t reason);
>  long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned l=
ong arg);
> =20
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/=
esas2r_main.c
> index a020b09..30fce64 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -254,9 +254,6 @@ static struct scsi_host_template driver_template =
=3D {
>  	.use_clustering			=3D ENABLE_CLUSTERING,
>  	.emulated			=3D 0,
>  	.proc_name			=3D ESAS2R_DRVR_NAME,
> -	.slave_configure		=3D esas2r_slave_configure,
> -	.slave_alloc			=3D esas2r_slave_alloc,
> -	.slave_destroy			=3D esas2r_slave_destroy,
>  	.change_queue_depth		=3D esas2r_change_queue_depth,
>  	.change_queue_type		=3D scsi_change_queue_type,
>  	.max_sectors			=3D 0xFFFF,
> @@ -1264,35 +1261,11 @@ int esas2r_change_queue_depth(struct scsi_dev=
ice *dev, int depth, int reason)
>  {
>  	esas2r_log(ESAS2R_LOG_INFO, "change_queue_depth %p, %d", dev, depth=
);
> =20
> -	scsi_adjust_queue_depth(dev, scsi_get_tag_type(dev), depth);
> +	scsi_adjust_queue_depth(dev, depth);
> =20
>  	return dev->queue_depth;
>  }
> =20
> -int esas2r_slave_alloc(struct scsi_device *dev)
> -{
> -	return 0;
> -}
> -
> -int esas2r_slave_configure(struct scsi_device *dev)
> -{
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(dev->sdev_gendev),
> -		       "esas2r_slave_configure()");
> -
> -	if (dev->tagged_supported)
> -		scsi_adjust_queue_depth(dev, MSG_SIMPLE_TAG, cmd_per_lun);
> -	else
> -		scsi_adjust_queue_depth(dev, 0, cmd_per_lun);
> -
> -	return 0;
> -}
> -
> -void esas2r_slave_destroy(struct scsi_device *dev)
> -{
> -	esas2r_log_dev(ESAS2R_LOG_INFO, &(dev->sdev_gendev),
> -		       "esas2r_slave_destroy()");
> -}
> -
>  void esas2r_log_request_failure(struct esas2r_adapter *a,
>  				struct esas2r_request *rq)
>  {
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 66b6ce1..38c23e0 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2402,27 +2402,14 @@ static int esp_slave_configure(struct scsi_de=
vice *dev)
>  {
>  	struct esp *esp =3D shost_priv(dev->host);
>  	struct esp_target_data *tp =3D &esp->target[dev->id];
> -	int goal_tags, queue_depth;
> -
> -	goal_tags =3D 0;
> =20
>  	if (dev->tagged_supported) {
>  		/* XXX make this configurable somehow XXX */
> -		goal_tags =3D ESP_DEFAULT_TAGS;
> +		int goal_tags =3D min(ESP_DEFAULT_TAGS, ESP_MAX_TAG);
> =20
> -		if (goal_tags > ESP_MAX_TAG)
> -			goal_tags =3D ESP_MAX_TAG;
> +		scsi_adjust_queue_depth(dev, goal_tags);
>  	}
> =20
> -	queue_depth =3D goal_tags;
> -	if (queue_depth < dev->host->cmd_per_lun)
> -		queue_depth =3D dev->host->cmd_per_lun;
> -
> -	if (goal_tags) {
> -		scsi_adjust_queue_depth(dev, MSG_ORDERED_TAG, queue_depth);
> -	} else {
> -		scsi_adjust_queue_depth(dev, 0, queue_depth);
> -	}
>  	tp->flags |=3D ESP_TGT_DISCONNECT;
> =20
>  	if (!spi_initial_dv(dev->sdev_target))
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_m=
ain.c
> index 2a6c98b..0f29e3f 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -100,7 +100,7 @@ static int fnic_slave_alloc(struct scsi_device *s=
dev)
>  	if (!rport || fc_remote_port_chkready(rport))
>  		return -ENXIO;
> =20
> -	scsi_adjust_queue_depth(sdev, 0, fnic_max_qdepth);
> +	scsi_adjust_queue_depth(sdev, fnic_max_qdepth);
>  	return 0;
>  }
> =20
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 0f1ae13..4ebbeae 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -4661,7 +4661,6 @@ static void gdth_flush(gdth_ha_str *ha)
>  /* configure lun */
>  static int gdth_slave_configure(struct scsi_device *sdev)
>  {
> -    scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
>      sdev->skip_ms_page_3f =3D 1;
>      sdev->skip_ms_page_8 =3D 1;
>      return 0;
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index cef5d49..18ea2e1 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -4165,7 +4165,7 @@ static int hpsa_change_queue_depth(struct scsi_=
device *sdev,
>  	else
>  		if (qdepth > h->nr_cmds)
>  			qdepth =3D h->nr_cmds;
> -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
>  	return sdev->queue_depth;
>  }
> =20
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index dedb62c..1518931 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -1127,7 +1127,7 @@ static int hptiop_adjust_disk_queue_depth(struc=
t scsi_device *sdev,
> =20
>  	if (queue_depth > hba->max_requests)
>  		queue_depth =3D hba->max_requests;
> -	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
> +	scsi_adjust_queue_depth(sdev, queue_depth);
>  	return queue_depth;
>  }
> =20
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/i=
bmvfc.c
> index 4723d89..147b80e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -2887,12 +2887,6 @@ static int ibmvfc_slave_configure(struct scsi_=
device *sdev)
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	if (sdev->type =3D=3D TYPE_DISK)
>  		sdev->allow_restart =3D 1;
> -
> -	if (sdev->tagged_supported)
> -		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG,
> -				sdev->queue_depth);
> -	else
> -		scsi_adjust_queue_depth(sdev, 0, sdev->queue_depth);
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  	return 0;
>  }
> @@ -2915,7 +2909,7 @@ static int ibmvfc_change_queue_depth(struct scs=
i_device *sdev, int qdepth,
>  	if (qdepth > IBMVFC_MAX_CMDS_PER_LUN)
>  		qdepth =3D IBMVFC_MAX_CMDS_PER_LUN;
> =20
> -	scsi_adjust_queue_depth(sdev, 0, qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
>  	return sdev->queue_depth;
>  }
> =20
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi=
/ibmvscsi.c
> index 7b23f21..e8c3cdf 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -1929,7 +1929,6 @@ static int ibmvscsi_slave_configure(struct scsi=
_device *sdev)
>  		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
>  	}
>  	spin_unlock_irqrestore(shost->host_lock, lock_flags);
> -	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
>  	return 0;
>  }
> =20
> @@ -1951,7 +1950,7 @@ static int ibmvscsi_change_queue_depth(struct s=
csi_device *sdev, int qdepth,
>  	if (qdepth > IBMVSCSI_MAX_CMDS_PER_LUN)
>  		qdepth =3D IBMVSCSI_MAX_CMDS_PER_LUN;
> =20
> -	scsi_adjust_queue_depth(sdev, 0, qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
>  	return sdev->queue_depth;
>  }
> =20
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index aa7359e..50285782 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -4348,7 +4348,7 @@ static int ipr_change_queue_depth(struct scsi_d=
evice *sdev, int qdepth,
>  		qdepth =3D IPR_MAX_CMD_PER_ATA_LUN;
>  	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> =20
> -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
>  	return sdev->queue_depth;
>  }
> =20
> @@ -4755,10 +4755,10 @@ static int ipr_slave_configure(struct scsi_de=
vice *sdev)
>  		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
> =20
>  		if (ap) {
> -			scsi_adjust_queue_depth(sdev, 0, IPR_MAX_CMD_PER_ATA_LUN);
> +			scsi_adjust_queue_depth(sdev, IPR_MAX_CMD_PER_ATA_LUN);
>  			ata_sas_slave_configure(sdev, ap);
> -		} else
> -			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
> +		}
> +
>  		if (ioa_cfg->sis64)
>  			sdev_printk(KERN_INFO, sdev, "Resource path: %s\n",
>  				    ipr_format_res_path(ioa_cfg,
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index e5afc38..454741a 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -1210,7 +1210,7 @@ ips_slave_configure(struct scsi_device * SDptr)
>  		min =3D ha->max_cmds / 2;
>  		if (ha->enq->ucLogDriveCount <=3D 2)
>  			min =3D ha->max_cmds - 1;
> -		scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, min);
> +		scsi_adjust_queue_depth(SDptr, min);
>  	}
> =20
>  	SDptr->skip_ms_page_8 =3D 1;
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.=
c
> index d4bb642..bf954ee 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -2160,7 +2160,7 @@ int fc_slave_alloc(struct scsi_device *sdev)
>  	if (!rport || fc_remote_port_chkready(rport))
>  		return -ENXIO;
> =20
> -	scsi_adjust_queue_depth(sdev, 0, FC_FCP_DFLT_QUEUE_DEPTH);
> +	scsi_adjust_queue_depth(sdev, FC_FCP_DFLT_QUEUE_DEPTH);
>  	return 0;
>  }
>  EXPORT_SYMBOL(fc_slave_alloc);
> @@ -2175,13 +2175,13 @@ int fc_change_queue_depth(struct scsi_device =
*sdev, int qdepth, int reason)
>  {
>  	switch (reason) {
>  	case SCSI_QDEPTH_DEFAULT:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +		scsi_adjust_queue_depth(sdev, qdepth);
>  		break;
>  	case SCSI_QDEPTH_QFULL:
>  		scsi_track_queue_full(sdev, qdepth);
>  		break;
>  	case SCSI_QDEPTH_RAMP_UP:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +		scsi_adjust_queue_depth(sdev, qdepth);
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 0d8bc6c..d521624 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1775,13 +1775,13 @@ int iscsi_change_queue_depth(struct scsi_devi=
ce *sdev, int depth, int reason)
>  {
>  	switch (reason) {
>  	case SCSI_QDEPTH_DEFAULT:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  		break;
>  	case SCSI_QDEPTH_QFULL:
>  		scsi_track_queue_full(sdev, depth);
>  		break;
>  	case SCSI_QDEPTH_RAMP_UP:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsa=
s/sas_scsi_host.c
> index eee21a0..56d698a 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -940,13 +940,13 @@ int sas_slave_configure(struct scsi_device *scs=
i_dev)
>  	sas_read_port_mode_page(scsi_dev);
> =20
>  	if (scsi_dev->tagged_supported) {
> -		scsi_adjust_queue_depth(scsi_dev, MSG_SIMPLE_TAG, SAS_DEF_QD);
> +		scsi_adjust_queue_depth(scsi_dev, SAS_DEF_QD);
>  	} else {
>  		SAS_DPRINTK("device %llx, LUN %llx doesn't support "
>  			    "TCQ\n", SAS_ADDR(dev->sas_addr),
>  			    scsi_dev->lun);
>  		scsi_dev->tagged_supported =3D 0;
> -		scsi_adjust_queue_depth(scsi_dev, 0, 1);
> +		scsi_adjust_queue_depth(scsi_dev, 1);
>  	}
> =20
>  	scsi_dev->allow_restart =3D 1;
> @@ -967,7 +967,7 @@ int sas_change_queue_depth(struct scsi_device *sd=
ev, int depth, int reason)
>  	case SCSI_QDEPTH_RAMP_UP:
>  		if (!sdev->tagged_supported)
>  			depth =3D 1;
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  		break;
>  	case SCSI_QDEPTH_QFULL:
>  		scsi_track_queue_full(sdev, depth);
> @@ -979,19 +979,11 @@ int sas_change_queue_depth(struct scsi_device *=
sdev, int depth, int reason)
>  	return depth;
>  }
> =20
> -int sas_change_queue_type(struct scsi_device *scsi_dev, int qt)
> +int sas_change_queue_type(struct scsi_device *scsi_dev, int type)
>  {
> -	struct domain_device *dev =3D sdev_to_domain_dev(scsi_dev);
> -
> -	if (dev_is_sata(dev))
> +	if (dev_is_sata(sdev_to_domain_dev(scsi_dev)))
>  		return -EINVAL;
> -
> -	if (!scsi_dev->tagged_supported)
> -		return 0;
> -
> -	scsi_adjust_queue_depth(scsi_dev, qt, scsi_dev->queue_depth);
> -
> -	return qt;
> +	return scsi_change_queue_type(scsi_dev, type);
>  }
> =20
>  int sas_bios_param(struct scsi_device *scsi_dev,
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_s=
csi.c
> index a24106a..8533ee9 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -320,7 +320,7 @@ lpfc_change_queue_depth(struct scsi_device *sdev,=
 int qdepth, int reason)
>  	case SCSI_QDEPTH_DEFAULT:
>  		/* change request from sysfs, fall through */
>  	case SCSI_QDEPTH_RAMP_UP:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +		scsi_adjust_queue_depth(sdev, qdepth);
>  		break;
>  	case SCSI_QDEPTH_QFULL:
>  		if (scsi_track_queue_full(sdev, qdepth) =3D=3D 0)
> @@ -5598,7 +5598,7 @@ lpfc_slave_configure(struct scsi_device *sdev)
>  	struct lpfc_vport *vport =3D (struct lpfc_vport *) sdev->host->host=
data;
>  	struct lpfc_hba   *phba =3D vport->phba;
> =20
> -	scsi_adjust_queue_depth(sdev, 0, vport->cfg_lun_queue_depth);
> +	scsi_adjust_queue_depth(sdev, vport->cfg_lun_queue_depth);
> =20
>  	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
>  		lpfc_sli_handle_fast_ring_event(phba,
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/meg=
araid/megaraid_mbox.c
> index 531dce4..6b077d8 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -349,7 +349,7 @@ static int megaraid_change_queue_depth(struct scs=
i_device *sdev, int qdepth,
> =20
>  	if (qdepth > MBOX_MAX_SCSI_CMDS)
>  		qdepth =3D MBOX_MAX_SCSI_CMDS;
> -	scsi_adjust_queue_depth(sdev, 0, qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
>  	return sdev->queue_depth;
>  }
> =20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index f6a69a3..d95fc74 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -2594,8 +2594,7 @@ static int megasas_change_queue_depth(struct sc=
si_device *sdev,
> =20
>  	if (queue_depth > sdev->host->can_queue)
>  		queue_depth =3D sdev->host->can_queue;
> -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
> -				queue_depth);
> +	scsi_adjust_queue_depth(sdev, queue_depth);
> =20
>  	return queue_depth;
>  }
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2=
sas/mpt2sas_scsih.c
> index 69dc166..42fef91 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -1222,7 +1222,7 @@ _scsih_adjust_queue_depth(struct scsi_device *s=
dev, int qdepth)
>  		max_depth =3D 1;
>  	if (qdepth > max_depth)
>  		qdepth =3D max_depth;
> -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
>  }
> =20
>  /**
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3=
sas/mpt3sas_scsih.c
> index d3abf25..b23c2e7 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -1090,7 +1090,7 @@ _scsih_adjust_queue_depth(struct scsi_device *s=
dev, int qdepth)
>  		max_depth =3D 1;
>  	if (qdepth > max_depth)
>  		qdepth =3D max_depth;
> -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
>  }
> =20
>  /**
> diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
> index a7305ff..9c331b7 100644
> --- a/drivers/scsi/ncr53c8xx.c
> +++ b/drivers/scsi/ncr53c8xx.c
> @@ -7997,10 +7997,7 @@ static int ncr53c8xx_slave_configure(struct sc=
si_device *device)
>  	if (depth_to_use > MAX_TAGS)
>  		depth_to_use =3D MAX_TAGS;
> =20
> -	scsi_adjust_queue_depth(device,
> -				(device->tagged_supported ?
> -				 MSG_SIMPLE_TAG : 0),
> -				depth_to_use);
> +	scsi_adjust_queue_depth(device, depth_to_use);
> =20
>  	/*
>  	**	Since the queue depth is not tunable under Linux,
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 71f9f59..d8b9ba2 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -249,14 +249,11 @@ static int pmcraid_slave_configure(struct scsi_=
device *scsi_dev)
>  				      PMCRAID_VSET_MAX_SECTORS);
>  	}
> =20
> -	if (scsi_dev->tagged_supported &&
> -	    (RES_IS_GSCSI(res->cfg_entry) || RES_IS_VSET(res->cfg_entry))) =
{
> -		scsi_adjust_queue_depth(scsi_dev, MSG_SIMPLE_TAG,
> -					scsi_dev->host->cmd_per_lun);
> -	} else {
> -		scsi_adjust_queue_depth(scsi_dev, 0,
> -					scsi_dev->host->cmd_per_lun);
> -	}
> +	/*
> +	 * We never want to report TCQ support for these types of devices.
> +	 */
> +	if (!RES_IS_GSCSI(res->cfg_entry) && !RES_IS_VSET(res->cfg_entry))
> +		scsi_dev->tagged_supported =3D 0;
> =20
>  	return 0;
>  }
> @@ -302,35 +299,12 @@ static int pmcraid_change_queue_depth(struct sc=
si_device *scsi_dev, int depth,
>  	if (depth > PMCRAID_MAX_CMD_PER_LUN)
>  		depth =3D PMCRAID_MAX_CMD_PER_LUN;
> =20
> -	scsi_adjust_queue_depth(scsi_dev, scsi_get_tag_type(scsi_dev), dept=
h);
> +	scsi_adjust_queue_depth(scsi_dev, depth);
> =20
>  	return scsi_dev->queue_depth;
>  }
> =20
>  /**
> - * pmcraid_change_queue_type - Change the device's queue type
> - * @scsi_dev: scsi device struct
> - * @tag: type of tags to use
> - *
> - * Return value:
> - *	actual queue type set
> - */
> -static int pmcraid_change_queue_type(struct scsi_device *scsi_dev, i=
nt tag)
> -{
> -	struct pmcraid_resource_entry *res;
> -
> -	res =3D (struct pmcraid_resource_entry *)scsi_dev->hostdata;
> -	if (res && scsi_dev->tagged_supported &&
> -	    (RES_IS_GSCSI(res->cfg_entry) || RES_IS_VSET(res->cfg_entry)))
> -	    	tag =3D scsi_change_queue_type(scsi_dev, tag);
> -	else
> -		tag =3D 0;
> -
> -	return tag;
> -}
> -
> -
> -/**
>   * pmcraid_init_cmdblk - initializes a command block
>   *
>   * @cmd: pointer to struct pmcraid_cmd to be initialized
> @@ -4285,7 +4259,7 @@ static struct scsi_host_template pmcraid_host_t=
emplate =3D {
>  	.slave_configure =3D pmcraid_slave_configure,
>  	.slave_destroy =3D pmcraid_slave_destroy,
>  	.change_queue_depth =3D pmcraid_change_queue_depth,
> -	.change_queue_type  =3D pmcraid_change_queue_type,
> +	.change_queue_type  =3D scsi_change_queue_type,
>  	.can_queue =3D PMCRAID_MAX_IO_CMD,
>  	.this_id =3D -1,
>  	.sg_tablesize =3D PMCRAID_MAX_IOADLS,
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 1580205..adedb6e 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -1224,10 +1224,9 @@ qla1280_slave_configure(struct scsi_device *de=
vice)
> =20
>  	if (device->tagged_supported &&
>  	    (ha->bus_settings[bus].qtag_enables & (BIT_0 << target))) {
> -		scsi_adjust_queue_depth(device, MSG_ORDERED_TAG,
> -					ha->bus_settings[bus].hiwat);
> +		scsi_adjust_queue_depth(device, ha->bus_settings[bus].hiwat);
>  	} else {
> -		scsi_adjust_queue_depth(device, 0, default_depth);
> +		scsi_adjust_queue_depth(device, default_depth);
>  	}
> =20
>  	nv->bus[bus].target[target].parameter.enable_sync =3D device->sdtr;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla=
_os.c
> index eb04653..33166eb 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1405,7 +1405,7 @@ qla2xxx_slave_configure(struct scsi_device *sde=
v)
>  	if (IS_T10_PI_CAPABLE(vha->hw))
>  		blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
> =20
> -	scsi_adjust_queue_depth(sdev, 0, req->max_q_depth);
> +	scsi_adjust_queue_depth(sdev, req->max_q_depth);
>  	return 0;
>  }
> =20
> @@ -1440,7 +1440,7 @@ static void qla2x00_adjust_sdev_qdepth_up(struc=
t scsi_device *sdev, int qdepth)
>  	if (req->max_q_depth <=3D sdev->queue_depth || req->max_q_depth < q=
depth)
>  		return;
> =20
> -	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
> =20
>  	ql_dbg(ql_dbg_io, vha, 0x302a,
>  	    "Queue depth adjusted-up to %d for nexus=3D%ld:%d:%llu.\n",
> @@ -1452,7 +1452,7 @@ qla2x00_change_queue_depth(struct scsi_device *=
sdev, int qdepth, int reason)
>  {
>  	switch (reason) {
>  	case SCSI_QDEPTH_DEFAULT:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +		scsi_adjust_queue_depth(sdev, qdepth);
>  		break;
>  	case SCSI_QDEPTH_QFULL:
>  		qla2x00_handle_queue_full(sdev, qdepth);
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4=
_os.c
> index f3119c1..784f59e 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -9064,7 +9064,7 @@ static int qla4xxx_slave_alloc(struct scsi_devi=
ce *sdev)
>  	if (ql4xmaxqdepth !=3D 0 && ql4xmaxqdepth <=3D 0xffffU)
>  		queue_depth =3D ql4xmaxqdepth;
> =20
> -	scsi_adjust_queue_depth(sdev, 0, queue_depth);
> +	scsi_adjust_queue_depth(sdev, queue_depth);
>  	return 0;
>  }
> =20
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a3426f1..106fa2f 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -744,8 +744,6 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>  /**
>   * scsi_adjust_queue_depth - Let low level drivers change a device's=
 queue depth
>   * @sdev: SCSI Device in question
> - * @tagged: Do we use tagged queueing (non-0) or do we treat
> - *          this device as an untagged device (0)
>   * @tags: Number of tags allowed if tagged queueing enabled,
>   *        or number of commands the low level driver can
>   *        queue up in non-tagged mode (as per cmd_per_lun).
> @@ -759,7 +757,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>   * 		currently active and whether or not it even has the
>   * 		command blocks built yet.
>   */
> -void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, i=
nt tags)
> +void scsi_adjust_queue_depth(struct scsi_device *sdev, int tags)
>  {
>  	unsigned long flags;
> =20
> @@ -787,20 +785,6 @@ void scsi_adjust_queue_depth(struct scsi_device =
*sdev, int tagged, int tags)
>  	}
> =20
>  	sdev->queue_depth =3D tags;
> -	switch (tagged) {
> -		case 0:
> -			sdev->simple_tags =3D 0;
> -			break;
> -		case MSG_ORDERED_TAG:
> -		case MSG_SIMPLE_TAG:
> -			sdev->simple_tags =3D 1;
> -			break;
> -		default:
> -			sdev->simple_tags =3D 0;
> -			sdev_printk(KERN_WARNING, sdev,
> -				    "scsi_adjust_queue_depth, bad queue type, "
> -				    "disabled\n");
> -	}
>   out:
>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>  }
> @@ -848,11 +832,12 @@ int scsi_track_queue_full(struct scsi_device *s=
dev, int depth)
>  		return 0;
>  	if (sdev->last_queue_full_depth < 8) {
>  		/* Drop back to untagged */
> -		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
> +		scsi_set_tag_type(sdev, 0);
> +		scsi_adjust_queue_depth(sdev, sdev->host->cmd_per_lun);
>  		return -1;
>  	}
> =20
> -	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, depth);
> +	scsi_adjust_queue_depth(sdev, depth);
>  	return depth;
>  }
>  EXPORT_SYMBOL(scsi_track_queue_full);
> @@ -867,7 +852,7 @@ int scsi_change_queue_type(struct scsi_device *sd=
ev, int tag_type)
>  	if (!sdev->tagged_supported)
>  		return 0;
> =20
> -	scsi_adjust_queue_depth(sdev, tag_type, sdev->queue_depth);
> +	scsi_set_tag_type(sdev, tag_type);
>  	return tag_type;
> =20
>  }
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 8ca4e71..b44d9ca 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2700,11 +2700,8 @@ static int scsi_debug_slave_configure(struct s=
csi_device *sdp)
>  	devip =3D devInfoReg(sdp);
>  	if (NULL =3D=3D devip)
>  		return 1;	/* no resources, will be marked offline */
> -	sdp->hostdata =3D devip;
>  	sdp->tagged_supported =3D 1;
> -	if (sdp->host->cmd_per_lun)
> -		scsi_adjust_queue_depth(sdp, DEF_TAGGED_QUEUING,
> -					DEF_CMD_PER_LUN);
> +	sdp->hostdata =3D devip;
>  	blk_queue_max_segment_size(sdp->request_queue, -1U);
>  	if (scsi_debug_no_uld)
>  		sdp->no_uld_attach =3D 1;
> @@ -4494,7 +4491,7 @@ sdebug_change_qdepth(struct scsi_device *sdev, =
int qdepth, int reason)
>  		/* allow to exceed max host queued_arr elements for testing */
>  		if (qdepth > SCSI_DEBUG_CANQUEUE + 10)
>  			qdepth =3D SCSI_DEBUG_CANQUEUE + 10;
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +		scsi_adjust_queue_depth(sdev, qdepth);
>  	} else if (reason =3D=3D SCSI_QDEPTH_QFULL)
>  		scsi_track_queue_full(sdev, qdepth);
>  	else
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 408891c..d97597e 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -292,7 +292,7 @@ static struct scsi_device *scsi_alloc_sdev(struct=
 scsi_target *starget,
>  		blk_queue_init_tags(sdev->request_queue,
>  				    sdev->host->cmd_per_lun, shost->bqt);
>  	}
> -	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
> +	scsi_adjust_queue_depth(sdev, sdev->host->cmd_per_lun);
> =20
>  	scsi_sysfs_device_initialize(sdev);
> =20
> @@ -880,8 +880,10 @@ static int scsi_add_lun(struct scsi_device *sdev=
, unsigned char *inq_result,
>  			(inq_result[3] & 0x0f) =3D=3D 1 ? " CCS" : "");
> =20
>  	if ((sdev->scsi_level >=3D SCSI_2) && (inq_result[7] & 2) &&
> -	    !(*bflags & BLIST_NOTQ))
> +	    !(*bflags & BLIST_NOTQ)) {
>  		sdev->tagged_supported =3D 1;
> +		sdev->simple_tags =3D 1;
> +	}
> =20
>  	/*
>  	 * Some devices (Texel CD ROM drives) have handshaking problems
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index b5eae4f..2bb8a9e 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -549,8 +549,6 @@ stex_slave_alloc(struct scsi_device *sdev)
>  	/* Cheat: usually extracted from Inquiry data */
>  	sdev->tagged_supported =3D 1;
> =20
> -	scsi_adjust_queue_depth(sdev, 0, sdev->host->can_queue);
> -
>  	return 0;
>  }
> =20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 37f5fd8..ff8befb 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1429,8 +1429,7 @@ static void storvsc_device_destroy(struct scsi_=
device *sdevice)
> =20
>  static int storvsc_device_configure(struct scsi_device *sdevice)
>  {
> -	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
> -				STORVSC_MAX_IO_REQUESTS);
> +	scsi_adjust_queue_depth(sdevice, STORVSC_MAX_IO_REQUESTS);
> =20
>  	blk_queue_max_segment_size(sdevice->request_queue, PAGE_SIZE);
> =20
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53=
c8xx_2/sym_glue.c
> index e59e6f9..3557b38 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -820,9 +820,7 @@ static int sym53c8xx_slave_configure(struct scsi_=
device *sdev)
>  	if (reqtags > SYM_CONF_MAX_TAG)
>  		reqtags =3D SYM_CONF_MAX_TAG;
>  	depth_to_use =3D reqtags ? reqtags : 1;
> -	scsi_adjust_queue_depth(sdev,
> -				sdev->tagged_supported ? MSG_SIMPLE_TAG : 0,
> -				depth_to_use);
> +	scsi_adjust_queue_depth(sdev, depth_to_use);
>  	lp->s.scdev_depth =3D depth_to_use;
>  	sym_tune_dev_queuing(tp, sdev->lun, reqtags);
> =20
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index 6369f9a..844c9a0 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -2185,9 +2185,16 @@ static int dc390_slave_configure(struct scsi_d=
evice *sdev)
>  	struct dc390_dcb *dcb =3D (struct dc390_dcb *)sdev->hostdata;
> =20
>  	acb->scan_devices =3D 0;
> +
> +	/*
> +	 * XXX: Note that while this driver used to called scsi_activate_tc=
q,
> +	 * it never actually set a tag type, so emulate the old behavior.
> +	 */
> +	scsi_set_tag_type(sdev, 0);
> +
>  	if (sdev->tagged_supported && (dcb->DevMode & TAG_QUEUEING_)) {
>  		dcb->SyncMode |=3D EN_TAG_QUEUEING;
> -		scsi_adjust_queue_depth(sdev, 0, acb->TagMaxNum);
> +		scsi_adjust_queue_depth(sdev, acb->TagMaxNum);
>  	}
> =20
>  	return 0;
> diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
> index d8dcf36..aa0f403 100644
> --- a/drivers/scsi/u14-34f.c
> +++ b/drivers/scsi/u14-34f.c
> @@ -696,25 +696,25 @@ static int u14_34f_slave_configure(struct scsi_=
device *dev) {
>     if (TLDEV(dev->type) && dev->tagged_supported)
> =20
>        if (tag_mode =3D=3D TAG_SIMPLE) {
> -         scsi_adjust_queue_depth(dev, MSG_SIMPLE_TAG, tqd);
> +         scsi_adjust_queue_depth(dev, tqd);
>           tag_suffix =3D ", simple tags";
>           }
>        else if (tag_mode =3D=3D TAG_ORDERED) {
> -         scsi_adjust_queue_depth(dev, MSG_ORDERED_TAG, tqd);
> +         scsi_adjust_queue_depth(dev, tqd);
>           tag_suffix =3D ", ordered tags";
>           }
>        else {
> -         scsi_adjust_queue_depth(dev, 0, tqd);
> +         scsi_adjust_queue_depth(dev, tqd);
>           tag_suffix =3D ", no tags";
>           }
> =20
>     else if (TLDEV(dev->type) && linked_comm) {
> -      scsi_adjust_queue_depth(dev, 0, tqd);
> +      scsi_adjust_queue_depth(dev, tqd);
>        tag_suffix =3D ", untagged";
>        }
> =20
>     else {
> -      scsi_adjust_queue_depth(dev, 0, utqd);
> +      scsi_adjust_queue_depth(dev, utqd);
>        tag_suffix =3D "";
>        }
> =20
See my comment on the previous patches. As we're not using
ordered tags that branch is never used.

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 48c7f9e..5eb4931 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2696,7 +2696,7 @@ static void ufshcd_set_queue_depth(struct scsi_=
device *sdev)
>  	dev_dbg(hba->dev, "%s: activate tcq with queue depth %d\n",
>  			__func__, lun_qdepth);
>  	if (sdev->tagged_supported)
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), lun_qdepth)=
;
> +		scsi_adjust_queue_depth(sdev, lun_qdepth);
>  }
> =20
>  /*
> @@ -2808,7 +2808,7 @@ static int ufshcd_change_queue_depth(struct scs=
i_device *sdev,
>  	case SCSI_QDEPTH_RAMP_UP:
>  		if (!sdev->tagged_supported)
>  			depth =3D 1;
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  		break;
>  	case SCSI_QDEPTH_QFULL:
>  		scsi_track_queue_full(sdev, depth);
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index b83846f..355afbc 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -683,9 +683,7 @@ static int virtscsi_change_queue_depth(struct scs=
i_device *sdev,
>  		break;
>  	case SCSI_QDEPTH_RAMP_UP: /* Raise qdepth after BUSY state resolved=
 */
>  	case SCSI_QDEPTH_DEFAULT: /* Manual change via sysfs */
> -		scsi_adjust_queue_depth(sdev,
> -					scsi_get_tag_type(sdev),
> -					min(max_depth, qdepth));
> +		scsi_adjust_queue_depth(sdev, min(max_depth, qdepth));
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index 39f082b..4a01c05 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -522,7 +522,7 @@ static int pvscsi_change_queue_depth(struct scsi_=
device *sdev,
>  		max_depth =3D 1;
>  	if (qdepth > max_depth)
>  		qdepth =3D max_depth;
> -	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
> +	scsi_adjust_queue_depth(sdev, qdepth);
> =20
>  	if (sdev->inquiry_len > 7)
>  		sdev_printk(KERN_INFO, sdev,
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loop=
back/tcm_loop.c
> index 120a851..0ed9664 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -121,13 +121,13 @@ static int tcm_loop_change_queue_depth(
>  {
>  	switch (reason) {
>  	case SCSI_QDEPTH_DEFAULT:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  		break;
>  	case SCSI_QDEPTH_QFULL:
>  		scsi_track_queue_full(sdev, depth);
>  		break;
>  	case SCSI_QDEPTH_RAMP_UP:
> -		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
> +		scsi_adjust_queue_depth(sdev, depth);
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> @@ -404,19 +404,6 @@ static int tcm_loop_slave_alloc(struct scsi_devi=
ce *sd)
>  	return 0;
>  }
> =20
> -static int tcm_loop_slave_configure(struct scsi_device *sd)
> -{
> -	if (sd->tagged_supported) {
> -		scsi_adjust_queue_depth(sd, MSG_SIMPLE_TAG,
> -					sd->host->cmd_per_lun);
> -	} else {
> -		scsi_adjust_queue_depth(sd, 0,
> -					sd->host->cmd_per_lun);
> -	}
> -
> -	return 0;
> -}
> -
>  static struct scsi_host_template tcm_loop_driver_template =3D {
>  	.show_info		=3D tcm_loop_show_info,
>  	.proc_name		=3D "tcm_loopback",
> @@ -434,7 +421,6 @@ static struct scsi_host_template tcm_loop_driver_=
template =3D {
>  	.max_sectors		=3D 0xFFFF,
>  	.use_clustering		=3D DISABLE_CLUSTERING,
>  	.slave_alloc		=3D tcm_loop_slave_alloc,
> -	.slave_configure	=3D tcm_loop_slave_configure,
>  	.module			=3D THIS_MODULE,
>  	.use_blk_tags		=3D 1,
>  };
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index ee69b82..33f211b 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -799,7 +799,7 @@ static int uas_slave_configure(struct scsi_device=
 *sdev)
>  	if (devinfo->flags & US_FL_NO_REPORT_OPCODES)
>  		sdev->no_report_opcodes =3D 1;
> =20
> -	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, devinfo->qdepth - 2)=
;
> +	scsi_adjust_queue_depth(sdev, devinfo->qdepth - 2);
>  	return 0;
>  }
> =20
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f56175d..74c2a5b 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -387,7 +387,7 @@ extern struct scsi_device *__scsi_iterate_devices=
(struct Scsi_Host *,
>  #define __shost_for_each_device(sdev, shost) \
>  	list_for_each_entry((sdev), &((shost)->__devices), siblings)
> =20
> -extern void scsi_adjust_queue_depth(struct scsi_device *, int, int);
> +extern void scsi_adjust_queue_depth(struct scsi_device *, int);
>  extern int scsi_track_queue_full(struct scsi_device *, int);
> =20
>  extern int scsi_set_medium_removal(struct scsi_device *, char);
>=20
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
