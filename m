Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E54C07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 15:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiI0PEH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 11:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiI0PEC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 11:04:02 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A46ECCC7
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664291039; x=1695827039;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=4qZNvu+T78MhU/NzC4P+SlHcnUg2BTTDHBKrGCMfkw0=;
  b=H6YrddwGqysTqFOwEwDFuqwD38RF0VJocbxfQqxc0+PTCwLckiJ/DMdE
   Rr2CtL2PCm7QLRL6CuBlJAPWJEmcc+B4ePVVrSErxg7G+lXt5n92lWAut
   nwJsIPmAZAcKW/fKMisxJtZoY5MMYNPFAMt17hydPLl0jqAfgz0grVCyy
   7Hm2UIjkdGmHbSkpC/XsEBUGKx1pCcRdpWsHZLecAO67Dd29eaBM8Awb+
   NDQRuvxnZ9MNw92bdJzN1+8yUJpCCv9nDwCQ9/6jQFqx0CRv8sX3lM69/
   hbBqVPkUMlqbyNHBQSRTPrbxEZJ/Z/UXOa179XjUAI6bhuEJsSpjf0H0t
   w==;
X-IronPort-AV: E=Sophos;i="5.93,349,1654531200"; 
   d="scan'208";a="212390463"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 23:03:56 +0800
IronPort-SDR: Gze5nr65A/iCEkBot2L1dksE1Spi4pHFUkiVI3GNWZlW2voU6OgkhyiTnlCyb8LPBnf3+v7Dra
 d19NqHwU/qEH/ihi0PsF8CSjt3lWXh8m0FkfaC3MnNztXP9aX0YlLXDxQul9fnakX7x7gO637s
 sbJawn92kUj19W5SmXwQbaBh0Z4cMKH/GkkxhK3g/aU3TRebJcMZUpTJBuOwPlF8jICwnryJ5N
 wOrRNCxrJFbGa/X7JlBp8pnCIa2P2PLZvznOOtFCz/CkraUD0SFyLwQvQ7MrrQLe6GDni/eDYD
 FS+m7HKnPArtfzcNVd3ffm9l
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 07:23:53 -0700
IronPort-SDR: dl8y6eaaTizPTEn4t7T2shyW4Ubud2wlCfoLxjiY9t1tSm8vqSBZ9AAsHtJnypo6ZOUOw/9PXI
 Q1B0IknMW9xZ/HLGlzGXyxGQJ0bT6di2XnU5ywtMvVsAs8nIqMsUEBinmdwLlHsBZoiIVa595O
 eUok+ypMWk+SQKyaiOnnq+Afv8+1rLTez7uIHhA2FZy1MzIOrcoNv/Hwbc1PCS4/Km008E3HB9
 nEEifYdC9jZNGbXMXge21MCkpHLJOleG2eZlqBzrjvzv4pzOCJ2g9WNCMLsBPH/AA4VhxYkAuy
 U5k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 08:03:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4McNDr2KC9z1Rwt8
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 08:03:56 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664291035; x=1666883036; bh=4qZNvu+T78MhU/NzC4P+SlHcnUg2BTTDHBK
        rGCMfkw0=; b=okrOZ2Q3JP7MiBBE7nYGVWVPfjMKiq6ARf+lpPfWfKzQCI2jZqE
        DBGO7H1p/UW5RUaTpI9r/yKHSAuPTTokLV9rMuw5c5hVdXe82XjIywsexxItHQQs
        fk6kUBpl6M/exhSADR99bdAjQtlMRu++h3i5UVAoga8xtVUu4axv6KFGSNONggln
        KzSSYUGNr5n3HRBwLEVg1UPyoWpVYbiVI/88EoYTfr3Zl5wDaeaHkkRkOMDZaEMV
        rlRUZDH7Hl770GL9VM0BbHcym6tEq/CpViexHw/CSnM6j0fuplzOuOED/S7Zh8Z0
        5cmuzxVhx+IUb5LuXniNMl4JRc5b/exn9Pw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pmTFyIx1hyo3 for <linux-scsi@vger.kernel.org>;
        Tue, 27 Sep 2022 08:03:55 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4McNDp6RQ1z1RvLy;
        Tue, 27 Sep 2022 08:03:54 -0700 (PDT)
Message-ID: <ed504bcc-a880-12c5-0dea-4b22a8cce087@opensource.wdc.com>
Date:   Wed, 28 Sep 2022 00:03:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 2/2] ata: libata-sata: Fix device queue depth control
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220925230817.91542-1-damien.lemoal@opensource.wdc.com>
 <20220925230817.91542-3-damien.lemoal@opensource.wdc.com>
 <db84e61a-1069-982a-5659-297fcffc14f4@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <db84e61a-1069-982a-5659-297fcffc14f4@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 20:51, John Garry wrote:
> On 26/09/2022 00:08, Damien Le Moal wrote:
>> The function __ata_change_queue_depth() uses the helper
>> ata_scsi_find_dev() to get the ata_device structure of a scsi device and
>> set that device maximum queue depth. However, when the ata device is
>> managed by libsas, ata_scsi_find_dev() returns NULL, turning
>> __ata_change_queue_depth() into a nop, which prevents the user from
>> setting the maximum queue depth of ATA devices used with libsas based
>> HBAs.
>>
>> Fix this by renaming __ata_change_queue_depth() to
>> ata_change_queue_depth() and adding a pointer to the ata_device
>> structure of the target device as argument. This pointer is provided by
>> ata_scsi_change_queue_depth() using ata_scsi_find_dev() in the case of
>> a libata managed device and by sas_change_queue_depth() using
>> sas_to_ata_dev() in the case of a libsas managed ata device.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> Tested-by: John Garry <john.garry@huawei.com>
> 
> However - a big however - I will note that this following behaviour is 
> strange for a SATA device for libsas:
> 
> root@(none)$ echo 33 > 0:0:2:0/device/queue_depth
> root@(none)$ echo 33 > 0:0:2:0/device/queue_depth
> sh: echo: write error: Invalid argument
> root@(none)$

Weird. I am not getting any error (pm80xx driver). The qd gets capped at
32 as expected. Is it something that changes per libsas driver ?

> I also note that setting a value out of range is just rejected for a SAS 
> device, and not capped to the max range (like it is for SATA).

Not sure where that come from. A quick look does not reveal anything
obvious. Need to dig into that one.
> 
> AHCI rejects out of range values it as it exceeds the shost can_queue in 
> sdev_store_queue_depth().

Indeed:

echo 1 > /sys/block/sdk/device/queue_depth
echo 33 > /sys/block/sdk/device/queue_depth
cat /sys/block/sdk/device/queue_depth
1

But for the libsas SATA device:

echo 1 > /sys/block/sdd/device/queue_depth
cat /sys/block/sdd/device/queue_depth
1
echo 33 > /sys/block/sdd/device/queue_depth
cat /sys/block/sdd/device/queue_depth
32

As one would expect...

Need to dig into that one.

> 
> Thanks,
> John
> 
>> ---
>>   drivers/ata/libata-sata.c           | 24 ++++++++++++------------
>>   drivers/scsi/libsas/sas_scsi_host.c |  3 ++-
>>   include/linux/libata.h              |  4 ++--
>>   3 files changed, 16 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
>> index 7a5fe41aa5ae..13b9d0fdd42c 100644
>> --- a/drivers/ata/libata-sata.c
>> +++ b/drivers/ata/libata-sata.c
>> @@ -1018,26 +1018,25 @@ DEVICE_ATTR(sw_activity, S_IWUSR | S_IRUGO, ata_scsi_activity_show,
>>   EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
>>   
>>   /**
>> - *	__ata_change_queue_depth - helper for ata_scsi_change_queue_depth
>> - *	@ap: ATA port to which the device change the queue depth
>> + *	ata_change_queue_depth - Set a device maximum queue depth
>> + *	@ap: ATA port of the target device
>> + *	@dev: target ATA device
>>    *	@sdev: SCSI device to configure queue depth for
>>    *	@queue_depth: new queue depth
>>    *
>> - *	libsas and libata have different approaches for associating a sdev to
>> - *	its ata_port.
>> + *	Helper to set a device maximum queue depth, usable with both libsas
>> + *	and libata.
>>    *
>>    */
>> -int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
>> -			     int queue_depth)
>> +int ata_change_queue_depth(struct ata_port *ap, struct ata_device *dev,
>> +			   struct scsi_device *sdev, int queue_depth)
>>   {
>> -	struct ata_device *dev;
>>   	unsigned long flags;
>>   
>> -	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
>> +	if (!dev || !ata_dev_enabled(dev))
>>   		return sdev->queue_depth;
>>   
>> -	dev = ata_scsi_find_dev(ap, sdev);
>> -	if (!dev || !ata_dev_enabled(dev))
>> +	if (queue_depth < 1 || queue_depth == sdev->queue_depth)
>>   		return sdev->queue_depth;
>>   
>>   	/* NCQ enabled? */
>> @@ -1059,7 +1058,7 @@ int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
>>   
>>   	return scsi_change_queue_depth(sdev, queue_depth);
>>   }
>> -EXPORT_SYMBOL_GPL(__ata_change_queue_depth);
>> +EXPORT_SYMBOL_GPL(ata_change_queue_depth);
>>   
>>   /**
>>    *	ata_scsi_change_queue_depth - SCSI callback for queue depth config
>> @@ -1080,7 +1079,8 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
>>   {
>>   	struct ata_port *ap = ata_shost_to_port(sdev->host);
>>   
>> -	return __ata_change_queue_depth(ap, sdev, queue_depth);
>> +	return ata_change_queue_depth(ap, ata_scsi_find_dev(ap, sdev),
>> +				      sdev, queue_depth);
>>   }
>>   EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
>>   
>> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
>> index 9c82e5dc4fcc..a36fa1c128a8 100644
>> --- a/drivers/scsi/libsas/sas_scsi_host.c
>> +++ b/drivers/scsi/libsas/sas_scsi_host.c
>> @@ -872,7 +872,8 @@ int sas_change_queue_depth(struct scsi_device *sdev, int depth)
>>   	struct domain_device *dev = sdev_to_domain_dev(sdev);
>>   
>>   	if (dev_is_sata(dev))
>> -		return __ata_change_queue_depth(dev->sata_dev.ap, sdev, depth);
>> +		return ata_change_queue_depth(dev->sata_dev.ap,
>> +					      sas_to_ata_dev(dev), sdev, depth);
>>   
>>   	if (!sdev->tagged_supported)
>>   		depth = 1;
>> diff --git a/include/linux/libata.h b/include/linux/libata.h
>> index 698032e5ef2d..20765d1c5f80 100644
>> --- a/include/linux/libata.h
>> +++ b/include/linux/libata.h
>> @@ -1136,8 +1136,8 @@ extern int ata_scsi_slave_config(struct scsi_device *sdev);
>>   extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
>>   extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
>>   				       int queue_depth);
>> -extern int __ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
>> -				    int queue_depth);
>> +extern int ata_change_queue_depth(struct ata_port *ap, struct ata_device *dev,
>> +				  struct scsi_device *sdev, int queue_depth);
>>   extern struct ata_device *ata_dev_pair(struct ata_device *adev);
>>   extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
>>   extern void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap);
> 

-- 
Damien Le Moal
Western Digital Research

