Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0667C6FA8E
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 11:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiI0LwA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 07:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiI0Lvf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 07:51:35 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D73A221D;
        Tue, 27 Sep 2022 04:51:31 -0700 (PDT)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4McHxN2xl7z688Yy;
        Tue, 27 Sep 2022 19:50:16 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 13:51:29 +0200
Received: from [10.48.156.245] (10.48.156.245) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 12:51:28 +0100
Message-ID: <db84e61a-1069-982a-5659-297fcffc14f4@huawei.com>
Date:   Tue, 27 Sep 2022 12:51:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2 2/2] ata: libata-sata: Fix device queue depth control
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220925230817.91542-1-damien.lemoal@opensource.wdc.com>
 <20220925230817.91542-3-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220925230817.91542-3-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.156.245]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/09/2022 00:08, Damien Le Moal wrote:
> The function __ata_change_queue_depth() uses the helper
> ata_scsi_find_dev() to get the ata_device structure of a scsi device and
> set that device maximum queue depth. However, when the ata device is
> managed by libsas, ata_scsi_find_dev() returns NULL, turning
> __ata_change_queue_depth() into a nop, which prevents the user from
> setting the maximum queue depth of ATA devices used with libsas based
> HBAs.
> 
> Fix this by renaming __ata_change_queue_depth() to
> ata_change_queue_depth() and adding a pointer to the ata_device
> structure of the target device as argument. This pointer is provided by
> ata_scsi_change_queue_depth() using ata_scsi_find_dev() in the case of
> a libata managed device and by sas_change_queue_depth() using
> sas_to_ata_dev() in the case of a libsas managed ata device.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Tested-by: John Garry <john.garry@huawei.com>

However - a big however - I will note that this following behaviour is 
strange for a SATA device for libsas:

root@(none)$ echo 33 > 0:0:2:0/device/queue_depth
root@(none)$ echo 33 > 0:0:2:0/device/queue_depth
sh: echo: write error: Invalid argument
root@(none)$

I also note that setting a value out of range is just rejected for a SAS 
device, and not capped to the max range (like it is for SATA).

AHCI rejects out of range values it as it exceeds the shost can_queue in 
sdev_store_queue_depth().

Thanks,
John

> ---
>   drivers/ata/libata-sata.c           | 24 ++++++++++++------------
>   drivers/scsi/libsas/sas_scsi_host.c |  3 ++-
>   include/linux/libata.h              |  4 ++--
>   3 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 7a5fe41aa5ae..13b9d0fdd42c 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1018,26 +1018,25 @@ DEVICE_ATTR(sw_activity, S_IWUSR | S_IRUGO, ata_scsi_activity_show,
>   EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
>   
>   /**
> - *	__ata_change_queue_depth - helper for ata_scsi_change_queue_depth
> - *	@ap: ATA port to which the device change the queue depth
> + *	ata_change_queue_depth - Set a device maximum queue depth
> + *	@ap: ATA port of the target device
> + *	@dev: target ATA device
>    *	@sdev: SCSI device to configure queue depth for
>    *	@queue_depth: new queue depth
>    *
> - *	libsas and libata have different approaches for associating a sdev to
> - *	its ata_port.
> + *	Helper to set a device maximum queue depth, usable with both libsas
> + *	and libata.
>    *
>    */
> -int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
> -			     int queue_depth)
> +int ata_change_queue_depth(struct ata_port *ap, struct ata_device *dev,
> +			   struct scsi_device *sdev, int queue_depth)
>   {
> -	struct ata_device *dev;
>   	unsigned long flags;
>   
> -	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
> +	if (!dev || !ata_dev_enabled(dev))
>   		return sdev->queue_depth;
>   
> -	dev = ata_scsi_find_dev(ap, sdev);
> -	if (!dev || !ata_dev_enabled(dev))
> +	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
>   		return sdev->queue_depth;
>   
>   	/* NCQ enabled? */
> @@ -1059,7 +1058,7 @@ int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
>   
>   	return scsi_change_queue_depth(sdev, queue_depth);
>   }
> -EXPORT_SYMBOL_GPL(__ata_change_queue_depth);
> +EXPORT_SYMBOL_GPL(ata_change_queue_depth);
>   
>   /**
>    *	ata_scsi_change_queue_depth - SCSI callback for queue depth config
> @@ -1080,7 +1079,8 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
>   {
>   	struct ata_port *ap = ata_shost_to_port(sdev->host);
>   
> -	return __ata_change_queue_depth(ap, sdev, queue_depth);
> +	return ata_change_queue_depth(ap, ata_scsi_find_dev(ap, sdev),
> +				      sdev, queue_depth);
>   }
>   EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
>   
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index 9c82e5dc4fcc..a36fa1c128a8 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -872,7 +872,8 @@ int sas_change_queue_depth(struct scsi_device *sdev, int depth)
>   	struct domain_device *dev = sdev_to_domain_dev(sdev);
>   
>   	if (dev_is_sata(dev))
> -		return __ata_change_queue_depth(dev->sata_dev.ap, sdev, depth);
> +		return ata_change_queue_depth(dev->sata_dev.ap,
> +					      sas_to_ata_dev(dev), sdev, depth);
>   
>   	if (!sdev->tagged_supported)
>   		depth = 1;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 698032e5ef2d..20765d1c5f80 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1136,8 +1136,8 @@ extern int ata_scsi_slave_config(struct scsi_device *sdev);
>   extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
>   extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
>   				       int queue_depth);
> -extern int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
> -				    int queue_depth);
> +extern int ata_change_queue_depth(struct ata_port *ap, struct ata_device *dev,
> +				  struct scsi_device *sdev, int queue_depth);
>   extern struct ata_device *ata_dev_pair(struct ata_device *adev);
>   extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
>   extern void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap);

