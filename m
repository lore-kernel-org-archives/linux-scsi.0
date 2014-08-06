From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 11/14] block: Integrity checksum flag
Date: Wed, 06 Aug 2014 18:43:49 +0300
Message-ID: <53E24D35.8070201@dev.mellanox.co.il>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com> <1406320469-29352-12-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:62931 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaHFPnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 11:43:53 -0400
Received: by mail-we0-f181.google.com with SMTP id k48so2769481wev.26
        for <linux-scsi@vger.kernel.org>; Wed, 06 Aug 2014 08:43:52 -0700 (PDT)
In-Reply-To: <1406320469-29352-12-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 7/25/2014 11:34 PM, Martin K. Petersen wrote:
> Make the choice of checksum a per-I/O property by introducing a flag
> that can be inspected by the SCSI layer. There are several reasons for
> this:
>
>   1. It allows us to switch choice of checksum without unloading and
>      reloading the HBA driver.
>
>   2. During error recovery we need to be able to tell the HBA that
>      checksums read from disk should not be verified and converted to IP
>      checksums.
>
>   3. For error injection purposes we need to be able to write a bad guard
>      tag to storage. Since the storage device only supports T10 CRC we
>      need to be able to disable IP checksum conversion on the HBA.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   block/bio-integrity.c  | 3 +++
>   drivers/scsi/sd_dif.c  | 6 ++++--
>   include/linux/bio.h    | 1 +
>   include/linux/blkdev.h | 1 +
>   4 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index 63460cc34abe..31795b05339e 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -303,6 +303,9 @@ int bio_integrity_prep(struct bio *bio)
>   	bip->bip_iter.bi_size = len;
>   	bip_set_seed(bip, bio->bi_iter.bi_sector);
>
> +	if (bi->flags & BLK_INTEGRITY_IP_CHECKSUM)
> +		bip->bip_flags |= BIP_IP_CHECKSUM;
> +
>   	/* Map it */
>   	offset = offset_in_page(buf);
>   	for (i = 0 ; i < nr_pages ; i++) {
> diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
> index 4ce636fdc15f..2198abee619e 100644
> --- a/drivers/scsi/sd_dif.c
> +++ b/drivers/scsi/sd_dif.c
> @@ -255,12 +255,14 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
>   		return;
>
>   	/* Enable DMA of protection information */
> -	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP)
> +	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP) {
>   		if (type == SD_DIF_TYPE3_PROTECTION)
>   			blk_integrity_register(disk, &dif_type3_integrity_ip);
>   		else
>   			blk_integrity_register(disk, &dif_type1_integrity_ip);
> -	else
> +
> +		disk->integrity->flags |= BLK_INTEGRITY_IP_CHECKSUM;
> +	} else
>   		if (type == SD_DIF_TYPE3_PROTECTION)
>   			blk_integrity_register(disk, &dif_type3_integrity_crc);
>   		else
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 2657425629a8..a60195e07cff 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -327,6 +327,7 @@ enum bip_flags {
>   	BIP_MAPPED_INTEGRITY	= 1 << 1, /* ref tag has been remapped */
>   	BIP_CTRL_NOCHECK	= 1 << 2, /* disable HBA integrity checking */
>   	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
> +	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
>   };
>
>   static inline sector_t bip_get_seed(struct bio_integrity_payload *bip)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 57ac257c6872..68570d6cfec9 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1466,6 +1466,7 @@ enum blk_integrity_flags {
>   	BLK_INTEGRITY_VERIFY		= 1 << 0,
>   	BLK_INTEGRITY_GENERATE		= 1 << 1,
>   	BLK_INTEGRITY_DEVICE_CAPABLE	= 1 << 2,
> +	BLK_INTEGRITY_IP_CHECKSUM	= 1 << 3,
>   };
>
>   struct blk_integrity_iter {
>

Looks good to me,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
