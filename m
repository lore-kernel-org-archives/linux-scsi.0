From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: Fix maximum I/O size for BLOCK_PC requests
Date: Thu, 16 Jul 2015 13:12:44 +0200
Message-ID: <55A791AC.8010700@suse.de>
References: <5581759A.4080009@linux.vnet.ibm.com> <1437009226-599-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1437009226-599-1-git-send-email-martin.petersen@oracle.com>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/16/2015 03:13 AM, Martin K. Petersen wrote:
> Commit bcdb247c6b6a ("sd: Limit transfer length") clamped the maximum
> size of an I/O request to the MAXIMUM TRANSFER LENGTH field in the BL=
OCK
> LIMITS VPD. This had the unfortunate effect of also limiting the maxi=
mum
> size of non-filesystem requests sent to the device through sg/bsg.
>=20
> Avoid using blk_queue_max_hw_sectors() and set the max_sectors queue
> limit directly.
>=20
> Also update the comment in blk_limits_max_hw_sectors() to clarify tha=
t
> max_hw_sectors defines the limit for the I/O controller only.
>=20
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Brian King <brking@linux.vnet.ibm.com>
> Tested-by: Brian King <brking@linux.vnet.ibm.com>
> Cc: <stable@vger.kernel.org> # 3.17+
> ---
>  block/blk-settings.c | 4 ++--
>  drivers/scsi/sd.c    | 6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 12600bfffca9..e0057d035200 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -241,8 +241,8 @@ EXPORT_SYMBOL(blk_queue_bounce_limit);
>   * Description:
>   *    Enables a low level driver to set a hard upper limit,
>   *    max_hw_sectors, on the size of requests.  max_hw_sectors is se=
t by
> - *    the device driver based upon the combined capabilities of I/O
> - *    controller and storage device.
> + *    the device driver based upon the capabilities of the I/O
> + *    controller.
>   *
>   *    max_sectors is a soft limit imposed by the block layer for
>   *    filesystem type requests.  This value can be overridden on a
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3b2fcb4fada0..a20da8c25b4f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2770,9 +2770,9 @@ static int sd_revalidate_disk(struct gendisk *d=
isk)
>  	max_xfer =3D sdkp->max_xfer_blocks;
>  	max_xfer <<=3D ilog2(sdp->sector_size) - 9;
> =20
> -	max_xfer =3D min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
> -				max_xfer);
> -	blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
> +	sdkp->disk->queue->limits.max_sectors =3D
> +		min_not_zero(queue_max_hw_sectors(sdkp->disk->queue), max_xfer);
> +
>  	set_capacity(disk, sdkp->capacity);
>  	sd_config_write_same(sdkp);
>  	kfree(buffer);
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
