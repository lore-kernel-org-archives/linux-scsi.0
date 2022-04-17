Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16209C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Apr 2022 23:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiDQXJw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Apr 2022 19:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbiDQXJt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Apr 2022 19:09:49 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268FBB7DC
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650236832; x=1681772832;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dGIaAeBDouCnF5PzYe90ISUS8BUeisehyGJOfQOplME=;
  b=SwPC6Vj10pwUbTfZ08FqOmCfN/5rkqCYzVZ+1BMaSr4IKy2/G+7vDa5V
   3UoJva6kThJgmBCJfZqpoZxjzbfQOu5PbrGJNwUoGcNzbu5n2OghF55Kr
   PFadecinw/odPbLgcH2Mf2n8RNg8Gn/SG8SY0SbQxWa66827O0z0dPItW
   vegNLMRYeMqjdGgSvj6VOQh5PsO035ndxbcYdTS++njxMAlQKcXQwhGrK
   lOoEdwNtbaWUkkeiCUt1aNBuP5Y+cWwVRoBPUdBvOeg/57PUzB8WvjDQM
   XTe/qxmD58EU0vguGJsf1HzzUXUuTPpUzoLD3iFGAzo2w7X98XewSs9W+
   g==;
X-IronPort-AV: E=Sophos;i="5.90,267,1643644800"; 
   d="scan'208";a="302307276"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 07:07:11 +0800
IronPort-SDR: gpv1novK566C52aifAOZy9bqEdUZF9DMs4O4a5BhpHNkTvRyJU1QCVrx8NeCH6iCdY9IBEpOHN
 NM0nnYbO+fXWB5wDlwhH0EfnK03Lx8RKEezUOnfMxBrIeHyIqbRR6IqGQ078cB53cx6014B783
 P840+GwJxHQM1wCprUQVtoVvOkVYl4wg376wf25dNyJWfOzB/OB5KDMhdyjP/t72u6+MWncX9W
 2akOaR16lSmWGEs05siy5HxSFTmmodo/mbBQ6LEdJCl8chOgyMUsStuWxAUXFN/2XgRisW604H
 UR3VhXF07NmawxGkO5/Iqpws
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 15:37:32 -0700
IronPort-SDR: M4AJClzrF29FTlNgJ80sImMr55lawXV8/Ft8LKH1VzUUd1nFXCtP5KwZx1pXJ+U1ZPwJ6bfkQX
 ihodnYGuPv4ikgHhDYZjykH2fcLx39JZ9YzZDZpYpr+iiY64BbSn+f7sKUNQvt6+3JpGrveRnf
 MaxMLYInNZwQtCfBErSJDhElm5o+DkUCBp/nsoGbSXn6WG/olxr/BpfzqDI7uBileH/HP5vUJZ
 BgBSCr1UowPXUDPSWNuQOJKAFw0DxCrlDfAUQwVzGrVs+cS9SCCI51GSVKwdGSewIEpjpUsK4w
 +xk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 16:07:11 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhQgg0Q0hz1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:07:11 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650236830; x=1652828831; bh=dGIaAeBDouCnF5PzYe90ISUS8BUeisehyGJ
        OfQOplME=; b=mla2uOSe5xitmDyI/+InxXTGhrB6Eaev9HBvgymjkAKJTLDxL9n
        QxAcTdz8lyzarcwf68WR5P32mxQFJXfknST181B3UOh8nj0nEGM/zYHum4N6vq6w
        PZi48CTdBa1IIysy/FkJ4ajThSfJQ3yMARxXexQ02/qLR4VUlkHiHR3D3t7tW/i4
        Tw+g+olBDmGFweiRut1RIA40TAfRimC9STxFGAe3k7+pZkvO14Sp+8LKLfwFNoLt
        rR5hT7UKU1WNESKcF6+TulExjuq0QUOVdgxipKH5KE9Onj1vdzSkFqlpeZtqFhUq
        jhSe5UYc8REKlmhjUgbHUV2DBQN9y1hKeJA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id A0IepsUxcMe1 for <linux-scsi@vger.kernel.org>;
        Sun, 17 Apr 2022 16:07:10 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhQgd10ntz1Rvlx;
        Sun, 17 Apr 2022 16:07:08 -0700 (PDT)
Message-ID: <9f3d2ba9-06d7-8c60-a044-526be277676d@opensource.wdc.com>
Date:   Mon, 18 Apr 2022 08:07:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/8] scsi: sd_zbc: Improve source code documentation
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220415201752.2793700-1-bvanassche@acm.org>
 <20220415201752.2793700-2-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220415201752.2793700-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/22 05:17, Bart Van Assche wrote:
> Add several kernel-doc headers. Declare input arrays const. Specify the
> array size in function declarations.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/sd.h     |  5 ++--
>  drivers/scsi/sd_zbc.c | 54 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 53 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 0a33a4b68ffb..4849cbe771a7 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -222,7 +222,7 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
>  #ifdef CONFIG_BLK_DEV_ZONED
>  
>  void sd_zbc_release_disk(struct scsi_disk *sdkp);
> -int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
> +int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE]);
>  int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
>  blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
>  					 unsigned char op, bool all);
> @@ -238,8 +238,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
>  
>  static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
>  
> -static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
> -				    unsigned char *buf)
> +static inline int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  {
>  	return 0;
>  }
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 7f466280993b..925976ac5113 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -20,6 +20,12 @@
>  
>  #include "sd.h"
>  
> +/**
> + * sd_zbc_get_zone_wp_offset - Get zone write pointer offset.
> + * @zone: Zone for which to return the write pointer offset.
> + *
> + * Return: offset of the write pointer from the start of the zone.
> + */
>  static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
>  {
>  	if (zone->type == ZBC_ZONE_TYPE_CONV)
> @@ -44,7 +50,20 @@ static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
>  	}
>  }
>  
> -static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
> +/**
> + * sd_zbc_parse_report - Parse a SCSI zone descriptor
> + * @sdkp: SCSI disk pointer.
> + * @buf: SCSI zone descriptor.
> + * @idx: Index of the zone in the output of the REPORT ZONES command.
> + * @cb: Callback function pointer.
> + * @data: Second argument passed to @cb.
> + *
> + * Return: Value returned by @cb.
> + *
> + * Convert a SCSI zone descriptor into struct blk_zone format. Additionally,
> + * call @cb(blk_zone, @data).
> + */
> +static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
>  			       unsigned int idx, report_zones_cb cb, void *data)
>  {
>  	struct scsi_device *sdp = sdkp->device;
> @@ -189,6 +208,17 @@ static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
>  	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
>  }
>  
> +/**
> + * sd_zbc_report_zones - SCSI .report_zones() callback.
> + * @disk: Disk to report zones for.
> + * @sector: Start sector.
> + * @nr_zones: Maximum number of zones to report.
> + * @cb: Callback function called to report zone information.
> + * @data: Second argument passed to @cb.
> + *
> + * Called by the block layer to iterate over zone information. See also the
> + * disk->fops->report_zones() calls in block/blk-zoned.c.
> + */
>  int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
>  			unsigned int nr_zones, report_zones_cb cb, void *data)
>  {
> @@ -276,6 +306,10 @@ static int sd_zbc_update_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
>  	return 0;
>  }
>  
> +/*
> + * An attempt to append a zone triggered an invalid write pointer error.
> + * Reread the write pointer of the zone(s) in which the append failed.
> + */
>  static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
>  {
>  	struct scsi_disk *sdkp;
> @@ -585,7 +619,7 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
>   * sd_zbc_check_capacity - Check the device capacity
>   * @sdkp: Target disk
>   * @buf: command buffer
> - * @zblocks: zone size in number of blocks
> + * @zblocks: zone size in logical blocks
>   *
>   * Get the device zone size and check that the device capacity as reported
>   * by READ CAPACITY matches the max_lba value (plus one) of the report zones
> @@ -696,6 +730,11 @@ static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
>  	swap(sdkp->zones_wp_offset, sdkp->rev_wp_offset);
>  }
>  
> +/*
> + * Call blk_revalidate_disk_zones() if any of the zoned disk properties have
> + * changed that make it necessary to call that function. Called by
> + * sd_revalidate_disk() after the gendisk capacity has been set.
> + */
>  int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
>  {
>  	struct gendisk *disk = sdkp->disk;
> @@ -774,7 +813,16 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
>  	return ret;
>  }
>  
> -int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
> +/**
> + * sd_zbc_read_zones - Read zone information and update the request queue
> + * @sdkp: SCSI disk pointer.
> + * @buf: 512 byte buffer used for storing SCSI command output.
> + *
> + * Read zone information and update the request queue zone characteristics and
> + * also the zoned device information in *sdkp. Called by sd_revalidate_disk()
> + * before the gendisk capacity has been set.
> + */
> +int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  {
>  	struct gendisk *disk = sdkp->disk;
>  	struct request_queue *q = disk->queue;


-- 
Damien Le Moal
Western Digital Research
