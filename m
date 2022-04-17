Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCA5C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Apr 2022 23:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiDQXKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Apr 2022 19:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiDQXKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Apr 2022 19:10:50 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E2CBCAC
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650236892; x=1681772892;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UN2danTHQZJcS3qh79FHSCDTDwAdYvPOvRC021mLTt8=;
  b=p0kPGGzbTNWBjWoG5Nr444iezZxTo7Ubc1TBeWQgikwC3SQ9s5+IoBNX
   JBZtG9vhWuVZF9OWX/wEml7uHfiGKKdCDyvRCFQ27t3Yx4PV6koQj3Wgz
   H3P3FUO6YwGxhif/q6xBQLWp/tYX10qRh+TwOgxbjSG7aKOezKjK6dK6F
   hZpUA3XELLGhMupn/MQ73sQ2OOJjmzS1qqXKcHor2LxL22/pjR1srxpDA
   wv1GyT9Hy08TeP+JQBxSI9LJ/+Wp76NAvoisGgsFKP7V5ObvuDCXGfH/9
   W7wPvR4y2s/J+pPLSdIrd2TcKkm3yB1vBxlXV0Uikkcf2g6m7f/LEReEG
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,267,1643644800"; 
   d="scan'208";a="196976110"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 07:08:11 +0800
IronPort-SDR: UvBWXc/0kggK80Lcesq2sC/9LbGsfGXwxv03HTJAAbGLfFs1gp1qN0VbHsEQMiUHVAi64Cub6T
 k0Z+zx3zf6yxcVj8rOx42OEbX2Il6ujWbR+ctBfNPgdiLK/ILXJZQ7jvzZ7cGpUCB01/hoeGgb
 2nKdRtNgema8L5gWnEw+EVxFSdTkFQQGDITSZVRXh38Xzv35YKAykXkbZIRz9GKcDV3R4IMCPs
 d6RW0OsjrMhk/TPNOt1uKm0WZug3SwlMXah7A81ZuZ/UZ9Lu0pdj9Z+iQr5ezGxwk1V+B36f6c
 kTeMZU+kg+hWTwWqcoJCGtAl
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 15:38:33 -0700
IronPort-SDR: 9WZ4BPyk9QVm2xuX/bwofiEi+8fMQO4VTC8/bbkiId2v0bart+RaYSfdj/YdPeRXZmivQBQNK0
 gxhZHPLzW9sYlThv+OzTO9oSxfF0+VJk9xpY4p5zcxAek03d43QRDZRNmOsdIEkEC24wwJCYNJ
 YXBA3/zBp/bdPOvR/pJhSMojQMcV69+h+eEsGkKyOZFed7Qp5Sibhdkkj1dUpx2zLrN1q7tO5T
 yaX7RTKZB+GuOZvgITbF15vGo4f0dr0IBVODbIS7g2XbNQjAgt10wpMoASEzeHv9MhIeMOHdKm
 CiM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 16:08:11 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhQhq2wpRz1Rwrw
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:08:11 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650236890; x=1652828891; bh=UN2danTHQZJcS3qh79FHSCDTDwAdYvPOvRC
        021mLTt8=; b=YfTtaW6ZazndFbWP/oCidxs1pkGDnjMoLxr6nxj5xaS4JCn07zb
        3H69igGLYLFNVpibsCUrDJM1OK6Neab4BD2HNKQmFKJVDkbwEVBoiGZLG0FaFlwi
        7LjGO2HcdSNAGvdGwBmzgAZ93ANS+aDm60uH744ELI9zDrdLwlrGOrqYD7GE4J7p
        3wQ5bYi02zq7DG6Q4HbmRUiYlI3O0BRs1yYJuSvE1fO0n3xTu793evyMn7Po2PmX
        NAQR/8MBInR0ISH1UM5ODzYZPATAdRlaIDcnE9eL9+5dFQ3dk5+oQ8t8bwsqW1Cm
        vpLMrm9cYExQNyVjpLuDzb8m6HFYrZC2l5g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8CbbIIx0N01y for <linux-scsi@vger.kernel.org>;
        Sun, 17 Apr 2022 16:08:10 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhQhn6bS4z1Rvlx;
        Sun, 17 Apr 2022 16:08:09 -0700 (PDT)
Message-ID: <92e4937c-34b9-11e7-4810-9d02fa90310f@opensource.wdc.com>
Date:   Mon, 18 Apr 2022 08:08:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/8] scsi: sd_zbc: Rename a local variable
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220415201752.2793700-1-bvanassche@acm.org>
 <20220415201752.2793700-3-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220415201752.2793700-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/22 05:17, Bart Van Assche wrote:
> For zoned storage the word 'capacity' can either refer to the device
> capacity or to the zone capacity. Prevent confusion between these two
> concepts by renaming 'capacity' into 'device_capacity'.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/sd_zbc.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 925976ac5113..d0275855b16c 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -223,7 +223,8 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
>  			unsigned int nr_zones, report_zones_cb cb, void *data)
>  {
>  	struct scsi_disk *sdkp = scsi_disk(disk);
> -	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
> +	sector_t device_capacity = logical_to_sectors(sdkp->device,
> +						      sdkp->capacity);
>  	unsigned int nr, i;
>  	unsigned char *buf;
>  	size_t offset, buflen = 0;
> @@ -234,7 +235,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
>  		/* Not a zoned device */
>  		return -EOPNOTSUPP;
>  
> -	if (!capacity)
> +	if (!device_capacity)
>  		/* Device gone or invalid */
>  		return -ENODEV;
>  
> @@ -242,7 +243,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	while (zone_idx < nr_zones && sector < capacity) {
> +	while (zone_idx < nr_zones && sector < device_capacity) {
>  		ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
>  				sectors_to_logical(sdkp->device, sector), true);
>  		if (ret)


-- 
Damien Le Moal
Western Digital Research
