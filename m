Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E17C5518C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 16:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A1921582
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 16:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgDVQq1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 12:46:27 -0400
Received: from smtp.infotech.no ([82.134.31.41]:45932 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgDVQq0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 12:46:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1D3B5204170;
        Wed, 22 Apr 2020 18:46:22 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id f2GKXh4kV17a; Wed, 22 Apr 2020 18:46:19 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id BBDCC204155;
        Wed, 22 Apr 2020 18:46:18 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 7/7] scsi_debug: implement zbc host-aware emulation
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20200422104221.378203-1-damien.lemoal@wdc.com>
 <20200422104221.378203-8-damien.lemoal@wdc.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Cc:     Hannes Reinecke <hare@suse.de>
Message-ID: <7a673425-195a-bd5f-bcf9-66e2c6cdb3fc@interlog.com>
Date:   Wed, 22 Apr 2020 12:46:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422104221.378203-8-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-22 6:42 a.m., Damien Le Moal wrote:
> Implement ZBC host-aware device model emulation. The main changes from
> the host-managed emulation are the device type (TYPE_DISK is used),
> relaxation of access checks for read and write operations and different
> handling of a sequential write preferred zone write pointer as mandated
> by the ZBC r05 specifications.
> 
> To facilitate the implementation and avoid a lot of "if" statement, the
> zmodel field is added to the device information and the z_type field to
> the zone state data structure.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

This is an unexpected surprise and a chance to exercise previously untested
parts of my user space packages (sg3_utils and sdparm).

A small nit: draft ZBC-2 has added the Zoned Block Device Extension field
which should be set to 1 for host-aware (and 0 for host-managed). It is 0
in both cases at the moment which is strictly speaking correct as 0 is
defined as "not reported". IMO it is more correct to set it to 1 in the
host-aware case :-)

Ralph Weber failed in his attempt to get version strings thrown out at T10.
So we might consider adding a ZBC version descriptor in the host-aware and
host-managed case. [Version descriptors are in the standard INQUIRY
response.]

Wish list: it would be good if lsscsi could indicate in its one line per
device mode that a disk was actually a ZBC host-aware disk. lsscsi is
restricted to datamining in sysfs and some other locations that don't
need root permissions. So it does not issue any SCSI commands. To see a
disk is ZBC host-aware it needs access to the Block Device Characteristics
VPD page, but as far as I can see that is not loaded into sysfs at this
time. Hannes?

Tested-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 148 ++++++++++++++++++++++++++------------
>   1 file changed, 103 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 9279ac9bb98d..46cd4e64bb9c 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -262,6 +262,13 @@ static const char *sdebug_version_date = "20200421";
>   
>   #define SDEB_XA_NOT_IN_USE XA_MARK_1
>   
> +/* Zone types (zbcr05 table 25) */
> +enum sdebug_z_type {
> +	ZBC_ZONE_TYPE_CNV	= 0x1,
> +	ZBC_ZONE_TYPE_SWR	= 0x2,
> +	ZBC_ZONE_TYPE_SWP	= 0x3,
> +};
> +
>   /* enumeration names taken from table 26, zbcr05 */
>   enum sdebug_z_cond {
>   	ZBC_NOT_WRITE_POINTER	= 0x0,
> @@ -275,7 +282,9 @@ enum sdebug_z_cond {
>   };
>   
>   struct sdeb_zone_state {	/* ZBC: per zone state */
> +	enum sdebug_z_type z_type;
>   	enum sdebug_z_cond z_cond;
> +	bool z_non_seq_resource;
>   	unsigned int z_size;
>   	sector_t z_start;
>   	sector_t z_wp;
> @@ -294,6 +303,7 @@ struct sdebug_dev_info {
>   	bool used;
>   
>   	/* For ZBC devices */
> +	enum blk_zoned_model zmodel;
>   	unsigned int zsize;
>   	unsigned int zsize_shift;
>   	unsigned int nr_zones;
> @@ -822,7 +832,7 @@ static int dix_reads;
>   static int dif_errors;
>   
>   /* ZBC global data */
> -static bool sdeb_zbc_in_use;		/* true when ptype=TYPE_ZBC [0x14] */
> +static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed disks */
>   static int sdeb_zbc_zone_size_mb;
>   static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
>   static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
> @@ -1500,13 +1510,15 @@ static int inquiry_vpd_b0(unsigned char *arr)
>   }
>   
>   /* Block device characteristics VPD page (SBC-3) */
> -static int inquiry_vpd_b1(unsigned char *arr)
> +static int inquiry_vpd_b1(struct sdebug_dev_info *devip, unsigned char *arr)
>   {
>   	memset(arr, 0, 0x3c);
>   	arr[0] = 0;
>   	arr[1] = 1;	/* non rotating medium (e.g. solid state) */
>   	arr[2] = 0;
>   	arr[3] = 5;	/* less than 1.8" */
> +	if (devip->zmodel == BLK_ZONED_HA)
> +		arr[4] = 1 << 4;	/* zoned field = 01b */
>   
>   	return 0x3c;
>   }
> @@ -1543,7 +1555,7 @@ static int inquiry_vpd_b6(struct sdebug_dev_info *devip, unsigned char *arr)
>   	 */
>   	put_unaligned_be32(0xffffffff, &arr[4]);
>   	put_unaligned_be32(0xffffffff, &arr[8]);
> -	if (devip->max_open)
> +	if (sdeb_zbc_model == BLK_ZONED_HM && devip->max_open)
>   		put_unaligned_be32(devip->max_open, &arr[12]);
>   	else
>   		put_unaligned_be32(0xffffffff, &arr[12]);
> @@ -1566,7 +1578,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	if (! arr)
>   		return DID_REQUEUE << 16;
>   	is_disk = (sdebug_ptype == TYPE_DISK);
> -	is_zbc = (sdebug_ptype == TYPE_ZBC);
> +	is_zbc = (devip->zmodel != BLK_ZONED_NONE);
>   	is_disk_zbc = (is_disk || is_zbc);
>   	have_wlun = scsi_is_wlun(scp->device->lun);
>   	if (have_wlun)
> @@ -1611,7 +1623,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   				arr[n++] = 0xb1;  /* Block characteristics */
>   				if (is_disk)
>   					arr[n++] = 0xb2;  /* LB Provisioning */
> -				else if (is_zbc)
> +				if (is_zbc)
>   					arr[n++] = 0xb6;  /* ZB dev. char. */
>   			}
>   			arr[3] = n - 4;	  /* number of supported VPD pages */
> @@ -1660,7 +1672,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   			arr[3] = inquiry_vpd_b0(&arr[4]);
>   		} else if (is_disk_zbc && 0xb1 == cmd[2]) { /* Block char. */
>   			arr[1] = cmd[2];        /*sanity */
> -			arr[3] = inquiry_vpd_b1(&arr[4]);
> +			arr[3] = inquiry_vpd_b1(devip, &arr[4]);
>   		} else if (is_disk && 0xb2 == cmd[2]) { /* LB Prov. */
>   			arr[1] = cmd[2];        /*sanity */
>   			arr[3] = inquiry_vpd_b2(&arr[4]);
> @@ -2305,7 +2317,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   	msense_6 = (MODE_SENSE == cmd[0]);
>   	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
>   	is_disk = (sdebug_ptype == TYPE_DISK);
> -	is_zbc = (sdebug_ptype == TYPE_ZBC);
> +	is_zbc = (devip->zmodel != BLK_ZONED_NONE);
>   	if ((is_disk || is_zbc) && !dbd)
>   		bd_len = llbaa ? 16 : 8;
>   	else
> @@ -2656,7 +2668,7 @@ static struct sdeb_zone_state *zbc_zone(struct sdebug_dev_info *devip,
>   
>   static inline bool zbc_zone_is_conv(struct sdeb_zone_state *zsp)
>   {
> -	return zsp->z_cond == ZBC_NOT_WRITE_POINTER;
> +	return zsp->z_type == ZBC_ZONE_TYPE_CNV;
>   }
>   
>   static void zbc_close_zone(struct sdebug_dev_info *devip,
> @@ -2732,13 +2744,42 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
>   		       unsigned long long lba, unsigned int num)
>   {
>   	struct sdeb_zone_state *zsp = zbc_zone(devip, lba);
> +	unsigned long long n, end, zend = zsp->z_start + zsp->z_size;
>   
>   	if (zbc_zone_is_conv(zsp))
>   		return;
>   
> -	zsp->z_wp += num;
> -	if (zsp->z_wp >= zsp->z_start + zsp->z_size)
> -		zsp->z_cond = ZC5_FULL;
> +	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
> +		zsp->z_wp += num;
> +		if (zsp->z_wp >= zend)
> +			zsp->z_cond = ZC5_FULL;
> +		return;
> +	}
> +
> +	while (num) {
> +		if (lba != zsp->z_wp)
> +			zsp->z_non_seq_resource = true;
> +
> +		end = lba + num;
> +		if (end >= zend) {
> +			n = zend - lba;
> +			zsp->z_wp = zend;
> +		} else if (end > zsp->z_wp) {
> +			n = num;
> +			zsp->z_wp = end;
> +		} else {
> +			n = num;
> +		}
> +		if (zsp->z_wp >= zend)
> +			zsp->z_cond = ZC5_FULL;
> +
> +		num -= n;
> +		lba += n;
> +		if (num) {
> +			zsp++;
> +			zend = zsp->z_start + zsp->z_size;
> +		}
> +	}
>   }
>   
>   static int check_zbc_access_params(struct scsi_cmnd *scp,
> @@ -2750,7 +2791,9 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
>   	struct sdeb_zone_state *zsp_end = zbc_zone(devip, lba + num - 1);
>   
>   	if (!write) {
> -		/* Reads cannot cross zone types boundaries */
> +		if (devip->zmodel == BLK_ZONED_HA)
> +			return 0;
> +		/* For host-managed, reads cannot cross zone types boundaries */
>   		if (zsp_end != zsp &&
>   		    zbc_zone_is_conv(zsp) &&
>   		    !zbc_zone_is_conv(zsp_end)) {
> @@ -2773,25 +2816,27 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
>   		return 0;
>   	}
>   
> -	/* Writes cannot cross sequential zone boundaries */
> -	if (zsp_end != zsp) {
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST,
> -				LBA_OUT_OF_RANGE,
> -				WRITE_BOUNDARY_ASCQ);
> -		return check_condition_result;
> -	}
> -	/* Cannot write full zones */
> -	if (zsp->z_cond == ZC5_FULL) {
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST,
> -				INVALID_FIELD_IN_CDB, 0);
> -		return check_condition_result;
> -	}
> -	/* Writes must be aligned to the zone WP */
> -	if (lba != zsp->z_wp) {
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST,
> -				LBA_OUT_OF_RANGE,
> -				UNALIGNED_WRITE_ASCQ);
> -		return check_condition_result;
> +	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
> +		/* Writes cannot cross sequential zone boundaries */
> +		if (zsp_end != zsp) {
> +			mk_sense_buffer(scp, ILLEGAL_REQUEST,
> +					LBA_OUT_OF_RANGE,
> +					WRITE_BOUNDARY_ASCQ);
> +			return check_condition_result;
> +		}
> +		/* Cannot write full zones */
> +		if (zsp->z_cond == ZC5_FULL) {
> +			mk_sense_buffer(scp, ILLEGAL_REQUEST,
> +					INVALID_FIELD_IN_CDB, 0);
> +			return check_condition_result;
> +		}
> +		/* Writes must be aligned to the zone WP */
> +		if (lba != zsp->z_wp) {
> +			mk_sense_buffer(scp, ILLEGAL_REQUEST,
> +					LBA_OUT_OF_RANGE,
> +					UNALIGNED_WRITE_ASCQ);
> +			return check_condition_result;
> +		}
>   	}
>   
>   	/* Handle implicit open of closed and empty zones */
> @@ -4312,13 +4357,16 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>   		case 0x06:
>   		case 0x07:
>   		case 0x10:
> -		case 0x11:
>   			/*
> -			 * Read-only, offline, reset WP recommended and
> -			 * non-seq-resource-used are not emulated: no zones
> -			 * to report;
> +			 * Read-only, offline, reset WP recommended are
> +			 * not emulated: no zones to report;
>   			 */
>   			continue;
> +		case 0x11:
> +			/* non-seq-resource set */
> +			if (!zsp->z_non_seq_resource)
> +				continue;
> +			break;
>   		case 0x3f:
>   			/* Not write pointer (conventional) zones */
>   			if (!zbc_zone_is_conv(zsp))
> @@ -4333,11 +4381,10 @@ static int resp_report_zones(struct scsi_cmnd *scp,
>   
>   		if (nrz < rep_max_zones) {
>   			/* Fill zone descriptor */
> -			if (zbc_zone_is_conv(zsp))
> -				desc[0] = 0x1;
> -			else
> -				desc[0] = 0x2;
> +			desc[0] = zsp->z_type;
>   			desc[1] = zsp->z_cond << 4;
> +			if (zsp->z_non_seq_resource)
> +				desc[1] |= 1 << 1;
>   			put_unaligned_be64((u64)zsp->z_size, desc + 8);
>   			put_unaligned_be64((u64)zsp->z_start, desc + 16);
>   			put_unaligned_be64((u64)zsp->z_wp, desc + 24);
> @@ -4591,6 +4638,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
>   	if (zsp->z_cond == ZC4_CLOSED)
>   		devip->nr_closed--;
>   
> +	zsp->z_non_seq_resource = false;
>   	zsp->z_wp = zsp->z_start;
>   	zsp->z_cond = ZC1_EMPTY;
>   }
> @@ -4796,11 +4844,13 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
>   	}
>   	devip->nr_conv_zones = sdeb_zbc_nr_conv;
>   
> -	/* zbc_max_open_zones can be 0, meaning "not reported" (no limit) */
> -	if (sdeb_zbc_max_open >= devip->nr_zones - 1)
> -		devip->max_open = (devip->nr_zones - 1) / 2;
> -	else
> -		devip->max_open = sdeb_zbc_max_open;
> +	if (devip->zmodel == BLK_ZONED_HM) {
> +		/* zbc_max_open_zones can be 0, meaning "not reported" */
> +		if (sdeb_zbc_max_open >= devip->nr_zones - 1)
> +			devip->max_open = (devip->nr_zones - 1) / 2;
> +		else
> +			devip->max_open = sdeb_zbc_max_open;
> +	}
>   
>   	devip->zstate = kcalloc(devip->nr_zones,
>   				sizeof(struct sdeb_zone_state), GFP_KERNEL);
> @@ -4813,9 +4863,14 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
>   		zsp->z_start = zstart;
>   
>   		if (i < devip->nr_conv_zones) {
> +			zsp->z_type = ZBC_ZONE_TYPE_CNV;
>   			zsp->z_cond = ZBC_NOT_WRITE_POINTER;
>   			zsp->z_wp = (sector_t)-1;
>   		} else {
> +			if (devip->zmodel == BLK_ZONED_HM)
> +				zsp->z_type = ZBC_ZONE_TYPE_SWR;
> +			else
> +				zsp->z_type = ZBC_ZONE_TYPE_SWP;
>   			zsp->z_cond = ZC1_EMPTY;
>   			zsp->z_wp = zsp->z_start;
>   		}
> @@ -4851,10 +4906,13 @@ static struct sdebug_dev_info *sdebug_device_create(
>   		}
>   		devip->sdbg_host = sdbg_host;
>   		if (sdeb_zbc_in_use) {
> +			devip->zmodel = sdeb_zbc_model;
>   			if (sdebug_device_create_zones(devip)) {
>   				kfree(devip);
>   				return NULL;
>   			}
> +		} else {
> +			devip->zmodel = BLK_ZONED_NONE;
>   		}
>   		devip->sdbg_host = sdbg_host;
>   		list_add_tail(&devip->dev_list, &sdbg_host->dev_info_list);
> @@ -6566,12 +6624,12 @@ static int __init scsi_debug_init(void)
>   		sdeb_zbc_model = k;
>   		switch (sdeb_zbc_model) {
>   		case BLK_ZONED_NONE:
> +		case BLK_ZONED_HA:
>   			sdebug_ptype = TYPE_DISK;
>   			break;
>   		case BLK_ZONED_HM:
>   			sdebug_ptype = TYPE_ZBC;
>   			break;
> -		case BLK_ZONED_HA:
>   		default:
>   			pr_err("Invalid ZBC model\n");
>   			return -EINVAL;
> 

