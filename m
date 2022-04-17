Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA9BC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Apr 2022 23:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiDQXSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Apr 2022 19:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiDQXSn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Apr 2022 19:18:43 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8610DBF4E
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650237366; x=1681773366;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZdABvLZyspJgaFcGlQj5Jb/1Xov1rJLhkyENekOWRo8=;
  b=TWQrianVXCK/5IyapBnIzQWgObormNUXjz8xlyXLcdaTXu7Kcu7Inmz1
   nbVWcQFdYWj2B12e5mz8RbkyTADj/oFMG2geiYYi+PEQk2f+g8kenGZgo
   FiZ5g0uLe8zM5vj6y9zjVhy/wEDqIWfELaoZpuQ7HeN1ngsfrjwc1JZBu
   A5bwSzV0gSmskanRWsQ/B4RqtCwvWRk+1j0Jx9oe7dRgyjVRrCnBlaGM+
   deBBwwSFRdAe03CQglkPf2LExgEddGoz7/kg4Iw4blNNShfJWpcSD88+s
   Dp33hokpR0E5nYsre5prGhPnlUKfmxAiMaMXJBriG6fpjUNCfpyiR3WJs
   A==;
X-IronPort-AV: E=Sophos;i="5.90,267,1643644800"; 
   d="scan'208";a="310085206"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 07:16:06 +0800
IronPort-SDR: KDaWE/vH8++eGBdJVQss5hBf1ZxV8M3GSEMoqXtbJ6eYEFs87OkrGOyH4k0bDbBMqBkvhwf57Q
 W8rx+1Ezub6JHRCn3Yx7rCWh+VpNzHfDFRkXcVGtVABbP+IKSJTnOvP+v5rIw667vyQSeV8qOk
 +j/FsU91jX+E5K+Juy+HVLjwIxy2CKYGYFgvIBIcDyFagDMqJXZpqcno4P5N9tM55K2BcVVbbD
 4iIqUSNclr5/PX/oNDKiBqV5bnZk5sAfpY3/nFtwQozCVoa+DYCyJmzoN6B1d9uZlYxP8+zTT3
 e8X2d/XmycXU3TlPmDkv2Hdh
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 15:47:13 -0700
IronPort-SDR: wKWUQQ3+WkfSw9k3472dPPwTzHm56opsFB3Zo5A8zMq7M/hd3s0Q9TJsLrla3QFZ1Sj2bRqHvO
 k2vJH4sfXpIQ6vp+8twDrQw12jz29/s3M48GQzNUCiopXuI+vGi4hDxZ9BtxENka+j1Y8XIPWm
 s+kjhxihMG/zp26QkNJ+Jo6iYhMh9tl6XoaY9zpg+hitf9pYoGLcWGa3u/AzVo/OEdQLY1ZgVg
 xiqE1XexIHxywQXgYZpCvBJgSPVK/R5DqHWf/Gt0IduQ7DMn53omyBwHFroI/UMo/6iA3mxZS+
 uMs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 16:16:06 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhQsx5vsdz1SVp0
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:16:05 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650237364; x=1652829365; bh=ZdABvLZyspJgaFcGlQj5Jb/1Xov1rJLhkyE
        NekOWRo8=; b=tr4CYedkg+bEdbHvSb13sxb1p9JKtvXMpy+2Ief+jiF9YDudQ4t
        +sFdR7Ac7VRJLoozuqILnZHWH6e0QlS1PIEyJ/jNRfzs1OaU8chhCcvn7EKyWTJy
        Re7WnKIA+NNzwSBEOk3zEdIg1EuBfrCxQJZu+E81Bn1xZ7mQM20kWsOT2IWMU6nP
        GW4eY8K8r0kED79/yX7ui46tNv9F26/E+pNPLL7tRMkdTPuBLN7sFMioyn7ZJXzR
        iI3aJ1d30gQTXkspHcSrmFOn08WFuanQxV8xYlfJ8vEK5li8NdQwidaB/3Y9u9Xn
        jVUwYVW5eglVvKu6SGW17pmLLScuPrImyVA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 85DOEVwKsmsW for <linux-scsi@vger.kernel.org>;
        Sun, 17 Apr 2022 16:16:04 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhQsv4n0nz1Rvlx;
        Sun, 17 Apr 2022 16:16:03 -0700 (PDT)
Message-ID: <0366876d-3bd2-d505-6564-2aac772d1815@opensource.wdc.com>
Date:   Mon, 18 Apr 2022 08:16:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 4/8] scsi: sd_zbc: Introduce struct zoned_disk_info
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220415201752.2793700-1-bvanassche@acm.org>
 <20220415201752.2793700-5-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220415201752.2793700-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/22 05:17, Bart Van Assche wrote:
> Deriving the meaning of the nr_zones, rev_nr_zones, zone_blocks and
> rev_zone_blocks member variables requires careful analysis of the source
> code. Make the meaning of these member variables easier to understand by
> introducing struct zoned_disk_info.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/sd.h     | 18 +++++++++++++----
>  drivers/scsi/sd_zbc.c | 47 ++++++++++++++++++++-----------------------
>  2 files changed, 36 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 4849cbe771a7..2e983578a699 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -67,6 +67,16 @@ enum {
>  	SD_ZERO_WS10_UNMAP,	/* Use WRITE SAME(10) with UNMAP */
>  };
>  
> +/**
> + * struct zoned_disk_info - Properties of a zoned SCSI disk.

Nit: you could say "ZBC SCSI device" to be more inline with standards
vocabulary here instead of "zoned SCSI disk".

> + * @nr_zones: number of zones.
> + * @zone_blocks: number of logical blocks per zone.
> + */
> +struct zoned_disk_info {
> +	u32		nr_zones;
> +	u32		zone_blocks;
> +};
> +
>  struct scsi_disk {
>  	struct scsi_device *device;
>  
> @@ -78,10 +88,10 @@ struct scsi_disk {
>  	struct gendisk	*disk;
>  	struct opal_dev *opal_dev;
>  #ifdef CONFIG_BLK_DEV_ZONED
> -	u32		nr_zones;
> -	u32		rev_nr_zones;
> -	u32		zone_blocks;
> -	u32		rev_zone_blocks;
> +	/* Updated during revalidation before the gendisk capacity is known. */
> +	struct zoned_disk_info	early_zone_info;
> +	/* Updated during revalidation after the gendisk capacity is known. */
> +	struct zoned_disk_info	zone_info;
>  	u32		zones_optimal_open;
>  	u32		zones_optimal_nonseq;
>  	u32		zones_max_open;

Nit: It would be nice to pack everything under the #ifdef into the same
structure...

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index c1f295859b27..fe46b4b9913a 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -180,7 +180,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
>  	 * sure that the allocated buffer can always be mapped by limiting the
>  	 * number of pages allocated to the HBA max segments limit.
>  	 */
> -	nr_zones = min(nr_zones, sdkp->nr_zones);
> +	nr_zones = min(nr_zones, sdkp->zone_info.nr_zones);
>  	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
>  	bufsize = min_t(size_t, bufsize,
>  			queue_max_hw_sectors(q) << SECTOR_SHIFT);
> @@ -205,7 +205,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
>   */
>  static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
>  {
> -	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
> +	return logical_to_sectors(sdkp->device, sdkp->zone_info.zone_blocks);
>  }
>  
>  /**
> @@ -321,14 +321,14 @@ static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
>  	sdkp = container_of(work, struct scsi_disk, zone_wp_offset_work);
>  
>  	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
> -	for (zno = 0; zno < sdkp->nr_zones; zno++) {
> +	for (zno = 0; zno < sdkp->zone_info.nr_zones; zno++) {
>  		if (sdkp->zones_wp_offset[zno] != SD_ZBC_UPDATING_WP_OFST)
>  			continue;
>  
>  		spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
>  		ret = sd_zbc_do_report_zones(sdkp, sdkp->zone_wp_update_buf,
>  					     SD_BUF_SIZE,
> -					     zno * sdkp->zone_blocks, true);
> +					     zno * sdkp->zone_info.zone_blocks, true);
>  		spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
>  		if (!ret)
>  			sd_zbc_parse_report(sdkp, sdkp->zone_wp_update_buf + 64,
> @@ -395,7 +395,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
>  		break;
>  	default:
>  		wp_offset = sectors_to_logical(sdkp->device, wp_offset);
> -		if (wp_offset + nr_blocks > sdkp->zone_blocks) {
> +		if (wp_offset + nr_blocks > sdkp->zone_info.zone_blocks) {
>  			ret = BLK_STS_IOERR;
>  			break;
>  		}
> @@ -524,7 +524,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
>  		break;
>  	case REQ_OP_ZONE_RESET_ALL:
>  		memset(sdkp->zones_wp_offset, 0,
> -		       sdkp->nr_zones * sizeof(unsigned int));
> +		       sdkp->zone_info.nr_zones * sizeof(unsigned int));
>  		break;
>  	default:
>  		break;
> @@ -681,16 +681,16 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
>  	if (!sd_is_zoned(sdkp) || !sdkp->capacity)
>  		return;
>  
> -	if (sdkp->capacity & (sdkp->zone_blocks - 1))
> +	if (sdkp->capacity & (sdkp->zone_info.zone_blocks - 1))
>  		sd_printk(KERN_NOTICE, sdkp,
>  			  "%u zones of %u logical blocks + 1 runt zone\n",
> -			  sdkp->nr_zones - 1,
> -			  sdkp->zone_blocks);
> +			  sdkp->zone_info.nr_zones - 1,
> +			  sdkp->zone_info.zone_blocks);
>  	else
>  		sd_printk(KERN_NOTICE, sdkp,
>  			  "%u zones of %u logical blocks\n",
> -			  sdkp->nr_zones,
> -			  sdkp->zone_blocks);
> +			  sdkp->zone_info.nr_zones,
> +			  sdkp->zone_info.zone_blocks);
>  }
>  
>  static int sd_zbc_init_disk(struct scsi_disk *sdkp)
> @@ -717,10 +717,8 @@ static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)
>  	kfree(sdkp->zone_wp_update_buf);
>  	sdkp->zone_wp_update_buf = NULL;
>  
> -	sdkp->nr_zones = 0;
> -	sdkp->rev_nr_zones = 0;
> -	sdkp->zone_blocks = 0;
> -	sdkp->rev_zone_blocks = 0;
> +	sdkp->early_zone_info = (struct zoned_disk_info){ };
> +	sdkp->zone_info = (struct zoned_disk_info){ };
>  
>  	mutex_unlock(&sdkp->rev_mutex);
>  }
> @@ -747,8 +745,8 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
>  {
>  	struct gendisk *disk = sdkp->disk;
>  	struct request_queue *q = disk->queue;
> -	u32 zone_blocks = sdkp->rev_zone_blocks;
> -	unsigned int nr_zones = sdkp->rev_nr_zones;
> +	u32 zone_blocks = sdkp->early_zone_info.zone_blocks;
> +	unsigned int nr_zones = sdkp->early_zone_info.nr_zones;
>  	u32 max_append;
>  	int ret = 0;
>  	unsigned int flags;
> @@ -779,14 +777,14 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
>  	 */
>  	mutex_lock(&sdkp->rev_mutex);
>  
> -	if (sdkp->zone_blocks == zone_blocks &&
> -	    sdkp->nr_zones == nr_zones &&
> +	if (sdkp->zone_info.zone_blocks == zone_blocks &&
> +	    sdkp->zone_info.nr_zones == nr_zones &&
>  	    disk->queue->nr_zones == nr_zones)
>  		goto unlock;
>  
>  	flags = memalloc_noio_save();
> -	sdkp->zone_blocks = zone_blocks;
> -	sdkp->nr_zones = nr_zones;
> +	sdkp->zone_info.zone_blocks = zone_blocks;
> +	sdkp->zone_info.nr_zones = nr_zones;
>  	sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_KERNEL);
>  	if (!sdkp->rev_wp_offset) {
>  		ret = -ENOMEM;
> @@ -801,8 +799,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
>  	sdkp->rev_wp_offset = NULL;
>  
>  	if (ret) {
> -		sdkp->zone_blocks = 0;
> -		sdkp->nr_zones = 0;
> +		sdkp->zone_info = (struct zoned_disk_info){ };
>  		sdkp->capacity = 0;
>  		goto unlock;
>  	}
> @@ -888,8 +885,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
>  		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
>  
> -	sdkp->rev_nr_zones = nr_zones;
> -	sdkp->rev_zone_blocks = zone_blocks;
> +	sdkp->early_zone_info.nr_zones = nr_zones;
> +	sdkp->early_zone_info.zone_blocks = zone_blocks;
>  
>  	return 0;
>  

With or without the nit addressed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research
