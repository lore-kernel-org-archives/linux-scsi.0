From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] scsi: move the writeable from struct scsi_device
 to struct scsi_cd
Date: Mon, 21 Jul 2014 08:00:07 +0200
Message-ID: <53CCAC67.2070502@suse.de>
References: <1405696638-23770-1-git-send-email-hch@lst.de> <1405696638-23770-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaGUGAJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jul 2014 02:00:09 -0400
In-Reply-To: <1405696638-23770-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 07/18/2014 05:17 PM, Christoph Hellwig wrote:
> We currently set the field in common code based on the device type,
> but then only use it in the cdrom driver which also overrides the
> value previously set in the generic code.
>
> Just leave this entirely to the CDROM driver to make everyones life
> simpler.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_scan.c   | 24 ------------------------
>   drivers/scsi/sd.c          |  3 ---
>   drivers/scsi/sr.c          |  4 ++--
>   drivers/scsi/sr.h          |  1 +
>   include/scsi/scsi_device.h |  1 -
>   5 files changed, 3 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index b91cfaf..a5a0bde 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -807,30 +807,6 @@ static int scsi_add_lun(struct scsi_device *sdev=
, unsigned char *inq_result,
>   		sdev->removable =3D (inq_result[1] & 0x80) >> 7;
>   	}
>
> -	switch (sdev->type) {
> -	case TYPE_RBC:
> -	case TYPE_TAPE:
> -	case TYPE_DISK:
> -	case TYPE_PRINTER:
> -	case TYPE_MOD:
> -	case TYPE_PROCESSOR:
> -	case TYPE_SCANNER:
> -	case TYPE_MEDIUM_CHANGER:
> -	case TYPE_ENCLOSURE:
> -	case TYPE_COMM:
> -	case TYPE_RAID:
> -	case TYPE_OSD:
> -		sdev->writeable =3D 1;
> -		break;
> -	case TYPE_ROM:
> -	case TYPE_WORM:
> -		sdev->writeable =3D 0;
> -		break;
> -	default:
> -		sdev_printk(KERN_INFO, sdev, "unknown device type %d\n",
> -			    sdev->type);
> -	}
> -
>   	if (sdev->type =3D=3D TYPE_RBC || sdev->type =3D=3D TYPE_ROM) {
>   		/* RBC and MMC devices can return SCSI-3 compliance and yet
>   		 * still not support REPORT LUNS, so make them act as
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3663e38..377a520 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -992,9 +992,6 @@ static int sd_setup_read_write_cmnd(struct scsi_c=
mnd *SCpnt)
>   		}
>   	}
>   	if (rq_data_dir(rq) =3D=3D WRITE) {
> -		if (!sdp->writeable) {
> -			goto out;
> -		}
>   		SCpnt->cmnd[0] =3D WRITE_6;
>
>   		if (blk_integrity_rq(rq))
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index cce4771..7eeb936 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -435,7 +435,7 @@ static int sr_init_command(struct scsi_cmnd *SCpn=
t)
>   	}
>
>   	if (rq_data_dir(rq) =3D=3D WRITE) {
> -		if (!cd->device->writeable)
> +		if (!cd->writeable)
>   			goto out;
>   		SCpnt->cmnd[0] =3D WRITE_10;
>   		cd->cdi.media_written =3D 1;
> @@ -927,7 +927,7 @@ static void get_capabilities(struct scsi_cd *cd)
>   	 */
>   	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW=
)) !=3D
>   			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) {
> -		cd->device->writeable =3D 1;
> +		cd->writeable =3D 1;
>   	}
>
>   	kfree(buffer);
> diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
> index 5334e98..1d1f6f4 100644
> --- a/drivers/scsi/sr.h
> +++ b/drivers/scsi/sr.h
> @@ -36,6 +36,7 @@ typedef struct scsi_cd {
>   	struct scsi_device *device;
>   	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
>   	unsigned long ms_offset;	/* for reading multisession-CD's        *=
/
> +	unsigned writeable : 1;
>   	unsigned use:1;		/* is this device still supportable     */
>   	unsigned xa_flag:1;	/* CD has XA sectors ? */
>   	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 0f853f2..b895784 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -127,7 +127,6 @@ struct scsi_device {
>   				 * pass settings from slave_alloc to scsi
>   				 * core. */
>   	unsigned int eh_timeout; /* Error handling timeout */
> -	unsigned writeable:1;
>   	unsigned removable:1;
>   	unsigned changed:1;	/* Data invalid due to media change */
>   	unsigned busy:1;	/* Used to prevent races */
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
