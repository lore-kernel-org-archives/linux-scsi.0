Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C60C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Apr 2022 23:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiDQXY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Apr 2022 19:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiDQXY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Apr 2022 19:24:56 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EC265B6
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650237739; x=1681773739;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pM6Be5Ow4UZ5GVBELWBzU3H0og1xc68egLDSSJ5CMPg=;
  b=icQLVpchNYm2Z0gBwxoI3Bl+xc+sBZGCzV47o4O6mR2PdvPqHUiaK5Jj
   y5tgZKToBPOKWTP7DDSZKhK85nLFUtwjFGlPTGEYOC8porPMDF363A4K6
   RoygKgapmtvswsSNM/CrltSlq0W4LYqVPEPIqchm8VOCKjzhEghyUkDnY
   pNiZs3RUcOZrMiiSKNISzf3TCG3HBldQQ1wnWOOEfVY/b9uGObDOVtyhy
   2o9dR8qjdvkDGXVDX7sxxZ0NMq531TFhlZ1t6ZSUgpIVnQ1voU7NnX8cK
   ynb/cnKAWgxPY2ju20EzxevlovjwDhZch/j7//bKpn/cGD3jKp0SoOHyP
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,267,1643644800"; 
   d="scan'208";a="202980489"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 07:22:18 +0800
IronPort-SDR: eVRk0twkFCBNazp/s8WQvE1Jig3Oxe9OdonTgGm9GLEp0ijp8W5NAaasMTJ5X2r+TXdnFNBinX
 YM35cNA0htXcNCyHDYCNlKvOGlDeoE58Rqr04B72pFarpY3AXQhNqKvL1dlm3ZoXdaSSDRVd8b
 idR1UVYoj+E0jVMOM9I1G+XFwcdVkGv8WVWfASC410/mEv8NSUh39vqGM0EhH/gnADsau4yc0X
 Vcwa3FjmpQzQTIYvJStUJXaeTuGP9HBTTBXx/xEBp9SUUTOEqJFPyLCyJT50wfbGnrzxoMojSy
 4zf3LqN4S8RU0GwuAAji4a8z
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 15:53:26 -0700
IronPort-SDR: tYtSMnJ3eX0Ed0LAZFgp12YTiv0+9BV86GaHO5SNVVCp0LAYj9w0LpGx4CDIgPQWOT1MuxwOcF
 qkvNkT3yx73IqW6LOJJTygv2OwXslV5HXTeFKnZur/ctB/47RkKWgL0+aXCtaO751Izcs9y0lK
 kbjWDTAaQ+z3GXRKIJFMh1q8STJl+QiYk3R9gStMIow1LQTNTVJM0ja5mVGfX+Z9/V3Pem0VpG
 j2//nEeTP3SpOX9CsXlIpOR893k9SDf1fUEFH+AEKp0Fcm0DvSS6h0VTWVumraZII6OsJkuhu6
 jzk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 16:22:19 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhR163Rxbz1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:22:18 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650237737; x=1652829738; bh=pM6Be5Ow4UZ5GVBELWBzU3H0og1xc68egLD
        SSJ5CMPg=; b=C+JudyHkZ1YOY4rPkLpMCBy5xZTSUO7v1+5UFO5FinGT+0omgRG
        Csy6HimmYK9/Vr1Nkcl4OLKyvXGP4ZggGIrvaEY+oFS/dc1PB6UHI6HJw/YSISTW
        2HEqEpdxZX2OIR5ogAJug5NFuve2JrprKK4INfMlyUktTg6lDVqJRqaz4E98lqeG
        LAYg5GNotwo0RabivG6IjvSHX0ngXNwkVpzMbgjJ4fcokO82qkrvVsLa1Gw8Do5G
        4/sj9oWP2xfxLUnd84PjEBF+ISYI/PK6JmMCWFLuCt3L5T2xiL6yqHjvpSZ2SdwG
        /SIVZJWaEcSQQMf8th4zTnFZYADVimrDidQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5Qgwi2Fhv0Lu for <linux-scsi@vger.kernel.org>;
        Sun, 17 Apr 2022 16:22:17 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhR1428bzz1Rvlx;
        Sun, 17 Apr 2022 16:22:16 -0700 (PDT)
Message-ID: <db12ff0f-9b30-afd4-8fdb-f0514b2a02c6@opensource.wdc.com>
Date:   Mon, 18 Apr 2022 08:22:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5/8] scsi: sd_zbc: Hide gap zones
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220415201752.2793700-1-bvanassche@acm.org>
 <20220415201752.2793700-6-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220415201752.2793700-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/22 05:17, Bart Van Assche wrote:
> ZBC-2 allows host-managed disks to report gap zones. Another new feature
> in ZBC-2 is support for constant zone starting LBA offsets. These two
> features allow zoned disks to report a starting LBA offset that is a
> power of two even if the number of logical blocks with data per zone is
> not a power of two.

I think this last sentence would be clearer phrased like this:

These two features allow zoned disks to report zone start LBAs that are a
power of two even if the number of logical blocks with data per zone is
not a power of two.


> 
> For zoned disks that report a constant zone starting LBA offset, hide
> the gap zones from the block layer. Report the starting LBA offset as
> zone size and report the number of logical blocks with data per zone as
> the zone capacity.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> [ bvanassche: Reworked this patch ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/sd.h         |  5 +++
>  drivers/scsi/sd_zbc.c     | 84 +++++++++++++++++++++++++++++++++++----
>  include/scsi/scsi_proto.h |  8 +++-
>  3 files changed, 88 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 2e983578a699..e0793e789fdc 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -95,6 +95,11 @@ struct scsi_disk {
>  	u32		zones_optimal_open;
>  	u32		zones_optimal_nonseq;
>  	u32		zones_max_open;
> +	/*
> +	 * Either zero or a power of two. If not zero it means that the offset
> +	 * between zone starting LBAs is constant.
> +	 */
> +	u32		zone_starting_lba_gran;
>  	u32		*zones_wp_offset;
>  	spinlock_t	zones_wp_offset_lock;
>  	u32		*rev_wp_offset;
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index fe46b4b9913a..92eace611364 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -37,7 +37,7 @@ static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
>  	case BLK_ZONE_COND_CLOSED:
>  		return zone->wp - zone->start;
>  	case BLK_ZONE_COND_FULL:
> -		return zone->len;
> +		return zone->capacity;
>  	case BLK_ZONE_COND_EMPTY:
>  	case BLK_ZONE_COND_OFFLINE:
>  	case BLK_ZONE_COND_READONLY:
> @@ -50,6 +50,12 @@ static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
>  	}
>  }
>  
> +/* Whether or not a SCSI zone descriptor describes a gap zone. */
> +static bool sd_zbc_is_gap_zone(const u8 buf[64])
> +{
> +	return (buf[0] & 0xf) == ZBC_ZONE_TYPE_GAP;
> +}
> +
>  /**
>   * sd_zbc_parse_report - Parse a SCSI zone descriptor
>   * @sdkp: SCSI disk pointer.
> @@ -68,8 +74,12 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
>  {
>  	struct scsi_device *sdp = sdkp->device;
>  	struct blk_zone zone = { 0 };
> +	sector_t gran;
> +	u64 start_lba;
>  	int ret;
>  
> +	if (WARN_ON_ONCE(sd_zbc_is_gap_zone(buf)))
> +		return -EINVAL;
>  	zone.type = buf[0] & 0x0f;
>  	zone.cond = (buf[1] >> 4) & 0xf;
>  	if (buf[1] & 0x01)
> @@ -79,9 +89,25 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
>  
>  	zone.len = logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
>  	zone.capacity = zone.len;
> -	zone.start = logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
> +	start_lba = get_unaligned_be64(&buf[16]);
> +	zone.start = logical_to_sectors(sdp, start_lba);
> +	if (sdkp->zone_starting_lba_gran) {
> +		idx = start_lba >> ilog2(sdkp->zone_starting_lba_gran);
> +		gran = logical_to_sectors(sdp, sdkp->zone_starting_lba_gran);
> +		if (zone.capacity > zone.len || zone.len > gran) {
> +			sd_printk(KERN_ERR, sdkp,
> +				  "Invalid zone for LBA %llu: zone capacity %llu; zone length %llu; granularity %llu\n",
> +				  start_lba, zone.capacity, zone.len, gran);
> +			return -EINVAL;
> +		}
> +		/*
> +		 * Change the zone length obtained from REPORT ZONES into the
> +		 * zone starting LBA granularity.
> +		 */
> +		zone.len = gran;
> +	}
>  	if (zone.cond == ZBC_ZONE_COND_FULL)
> -		zone.wp = zone.start + zone.len;
> +		zone.wp = zone.start + zone.capacity;
>  	else
>  		zone.wp = logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
>  
> @@ -227,6 +253,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
>  						      sdkp->capacity);
>  	unsigned int nr, i;
>  	unsigned char *buf;
> +	u64 zone_length, start_lba;
>  	size_t offset, buflen = 0;
>  	int zone_idx = 0;
>  	int ret;
> @@ -254,16 +281,33 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
>  		if (!nr)
>  			break;
>  
> -		for (i = 0; i < nr && zone_idx < nr_zones; i++) {
> +		for (i = 0; i < nr && zone_idx < nr_zones; i++, zone_idx++) {
>  			offset += 64;
> +			zone_length = get_unaligned_be64(&buf[offset + 8]);
> +			start_lba = get_unaligned_be64(&buf[offset + 16]);
> +			if (start_lba < sectors_to_logical(sdkp->device, sector)
> +			    || start_lba + zone_length < start_lba) {
> +				sd_printk(KERN_ERR, sdkp,
> +					  "Zone %d is invalid: %llu + %llu\n",
> +					  zone_idx, start_lba, zone_length);
> +				ret = -EINVAL;
> +				goto out;
> +			}
> +			sector = logical_to_sectors(sdkp->device, start_lba +
> +						    zone_length);
> +			if (sd_zbc_is_gap_zone(&buf[offset])) {
> +				if (sdkp->zone_starting_lba_gran)
> +					continue;
> +				sd_printk(KERN_ERR, sdkp,
> +					  "Gap zone without constant LBA offsets\n");
> +				ret = -EINVAL;
> +				goto out;
> +			}
>  			ret = sd_zbc_parse_report(sdkp, buf + offset, zone_idx,
>  						  cb, data);
>  			if (ret)
>  				goto out;
> -			zone_idx++;
>  		}
> -
> -		sector += sd_zbc_zone_sectors(sdkp) * i;
>  	}
>  
>  	ret = zone_idx;
> @@ -580,6 +624,8 @@ unsigned int sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
>  static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
>  					      unsigned char *buf)
>  {
> +	u64 zone_starting_lba_gran;
> +	u8 zone_alignment_method;
>  
>  	if (scsi_get_vpd_page(sdkp->device, 0xb6, buf, 64)) {
>  		sd_printk(KERN_NOTICE, sdkp,
> @@ -599,6 +645,28 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
>  		sdkp->zones_optimal_open = 0;
>  		sdkp->zones_optimal_nonseq = 0;
>  		sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
> +		zone_alignment_method = buf[23] & 0xf;
> +		if (zone_alignment_method ==
> +		    ZBC_CONSTANT_ZONE_STARTING_LBA_OFFSETS) {
> +			zone_starting_lba_gran =
> +				get_unaligned_be64(&buf[24]);
> +			if (zone_starting_lba_gran == 0) {
> +				sd_printk(KERN_ERR, sdkp,
> +					  "Inconsistent: zone starting LBA granularity is zero\n");
> +			}
> +			if (!is_power_of_2(zone_starting_lba_gran) ||
> +			    logical_to_sectors(sdkp->device,
> +					       zone_starting_lba_gran) >
> +			    UINT_MAX) {
> +				sd_printk(KERN_ERR, sdkp,
> +					  "Invalid zone starting LBA granularity %llu\n",
> +					  zone_starting_lba_gran);
> +				return -EINVAL;
> +			}
> +			sdkp->zone_starting_lba_gran = zone_starting_lba_gran;
> +			WARN_ON_ONCE(sdkp->zone_starting_lba_gran !=
> +				     zone_starting_lba_gran);
> +		}
>  	}
>  
>  	/*
> @@ -664,7 +732,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
>  		return -EFBIG;
>  	}
>  
> -	*zblocks = zone_blocks;
> +	*zblocks = sdkp->zone_starting_lba_gran ? : zone_blocks;
>  
>  	if (!is_power_of_2(*zblocks)) {
>  		sd_printk(KERN_ERR, sdkp,
> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
> index f017843a8124..521f9feac778 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -307,7 +307,9 @@ enum zbc_zone_type {
>  	ZBC_ZONE_TYPE_CONV		= 0x1,
>  	ZBC_ZONE_TYPE_SEQWRITE_REQ	= 0x2,
>  	ZBC_ZONE_TYPE_SEQWRITE_PREF	= 0x3,
> -	/* 0x4 to 0xf are reserved */
> +	ZBC_ZONE_TYPE_SEQ_OR_BEFORE_REQ	= 0x4,
> +	ZBC_ZONE_TYPE_GAP		= 0x5,
> +	/* 0x6 to 0xf are reserved */
>  };
>  
>  /* Zone conditions of REPORT ZONES zone descriptors */
> @@ -323,6 +325,10 @@ enum zbc_zone_cond {
>  	ZBC_ZONE_COND_OFFLINE		= 0xf,
>  };
>  
> +enum zbc_zone_alignment_method {
> +	ZBC_CONSTANT_ZONE_STARTING_LBA_OFFSETS = 8,
> +};
> +
>  /* Version descriptor values for INQUIRY */
>  enum scsi_version_descriptor {
>  	SCSI_VERSION_DESCRIPTOR_FCP4	= 0x0a40,


-- 
Damien Le Moal
Western Digital Research
