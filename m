Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94153C04A95
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 07:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiI1HBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 03:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiI1HAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 03:00:45 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1212665651
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 00:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664348438; x=1695884438;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=6JoL1tKwkfS7OPgDlZpX2SGlHNeZf2fiupPWHLEtE8c=;
  b=Evr9qeNSY0wXdv9SsyqAS1xwKSdIpxjmZVOaRaiATJBVtHpgYRKPhT7h
   UL/2VssErhrVoEvgb+zbPkZEGS3CPMEIwFaFN5sY+sz21N03hvb+9WB9O
   rnbRwqkC+x/LB9BIlVI2cqJKNodx1DAWCPTiejZgyEQ1xK+WGW8vr7KIe
   hjHW2eHKIRsal7G6q2ZEMI0Y3sQb0wUotbbJ9zDK/op2golwWS2zlIvj1
   QkF6eSlzKm9Pi6zvX1xyXOS1Sk+Q395+puDEB5WDpDmYTYeha4hEnTwmY
   xnp/o0utJQpbeaVvaaLB+IEbABbiqDTvav8LR65hvRcYQjz1J6RIVxhaE
   w==;
X-IronPort-AV: E=Sophos;i="5.93,351,1654531200"; 
   d="scan'208";a="324569356"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2022 15:00:28 +0800
IronPort-SDR: 1Z2MnBDBpT64L7jOaxDe3rAOFHb0LoRdJ7y/UVUt6BwTRlfy8w8xXp+lat/A5TVVbdEEJaXxyj
 +v0DG9LGJB+ugWqfY29+ojXpTcIlKJlY2IJ0QJwYxWaWTUUIAGSL7XzGL1mY5VEd+o3BJUyR0K
 n0X059m/MyruOvhVKYFXCkZDd0CYtuwgIoJMop7txj5VkIs1e4F2e8G6XWYd5R5O2wu/l/vkUD
 /bDY5AfjGC30uHs4Gj7PqYi7vLuL2IhhXthuTKAQuO4uGIvN/TWUkgnnhcdGSCOE+IZ8ZDbr7f
 dgFXmnkeuM6acaVqRSK9jqJV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 23:20:24 -0700
IronPort-SDR: 7Phcaw0RBA8qC3TZXzsFpLe7SH++XQCWtX5O1O71grR48IXaIOKvRo81X8ntvCIYejic212JYu
 CB/BqbB9vcOlh//T9VwmyVAne4Jommumd0vGXYO8oiA2fctjF8oJqvMqBUowLEVq+61+t8SIBW
 cDwGSpaN/3UXPeIs4MgvFMh973ppC1bYVZQdnwtF+Ihu7laz9UoOlorgLF2IGhL2Fp3HQlUFef
 5ZXti6V3oiZp5w4on9+LE/tjg49wBJp7S/WIAxJfKRWsc4lSxgPMmI4y3de+vT9FKEGDtUS3v0
 5u0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Sep 2022 00:00:29 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4McnSW68M4z1RwqL
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 00:00:27 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664348427; x=1666940428; bh=6JoL1tKwkfS7OPgDlZpX2SGlHNeZf2fiupP
        WHLEtE8c=; b=VgCUHFPYHD2oxvTfCEBJtd2SmE3tNyAnc1CJtr/MjiJpdkmAri1
        vkMSXXU/J2VL8u3nBriB4z0nA+Kw9o7ShHW8uFSlFxrbUP4jt0puuSu1Itv/Gf51
        xHMhTxjaIkIlZEJLY8fxoacwk8cL1G11yaQYeZRcMYMsA8GBGCJ4vARNhTiZ0PJn
        vcMyY9Lf5cjfY+0N4Gi5iFMW62CLvCNAB/DqJxpGD+JXgmssc/O0eJSQSVOcblLv
        YnYDDNa1PhEpSrCJXgIuVpGpW1fZEBK6AlZmWuv3K67kB9es+we5iSoxeLmOJSgG
        n0eUba8b/PHiN6u+J1YoSy0AvDQsUsxdfxw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IwqSiONYNt0p for <linux-scsi@vger.kernel.org>;
        Wed, 28 Sep 2022 00:00:27 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4McnSV448vz1RvLy;
        Wed, 28 Sep 2022 00:00:26 -0700 (PDT)
Message-ID: <6f08d6b9-63ba-10f6-2900-020db60a94be@opensource.wdc.com>
Date:   Wed, 28 Sep 2022 16:00:25 +0900
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
 <ed504bcc-a880-12c5-0dea-4b22a8cce087@opensource.wdc.com>
 <66dbb3da-595e-c673-320d-00f139435192@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <66dbb3da-595e-c673-320d-00f139435192@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 01:09, John Garry wrote:
> On 27/09/2022 16:03, Damien Le Moal wrote:
>> On 9/27/22 20:51, John Garry wrote:
>>> On 26/09/2022 00:08, Damien Le Moal wrote:
>>>> The function __ata_change_queue_depth() uses the helper
>>>> ata_scsi_find_dev() to get the ata_device structure of a scsi device and
>>>> set that device maximum queue depth. However, when the ata device is
>>>> managed by libsas, ata_scsi_find_dev() returns NULL, turning
>>>> __ata_change_queue_depth() into a nop, which prevents the user from
>>>> setting the maximum queue depth of ATA devices used with libsas based
>>>> HBAs.
>>>>
>>>> Fix this by renaming __ata_change_queue_depth() to
>>>> ata_change_queue_depth() and adding a pointer to the ata_device
>>>> structure of the target device as argument. This pointer is provided by
>>>> ata_scsi_change_queue_depth() using ata_scsi_find_dev() in the case of
>>>> a libata managed device and by sas_change_queue_depth() using
>>>> sas_to_ata_dev() in the case of a libsas managed ata device.
>>>>
>>>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>>
>>> Tested-by: John Garry <john.garry@huawei.com>
>>>
>>> However - a big however - I will note that this following behaviour is
>>> strange for a SATA device for libsas:
>>>
>>> root@(none)$ echo 33 > 0:0:2:0/device/queue_depth
>>> root@(none)$ echo 33 > 0:0:2:0/device/queue_depth
>>> sh: echo: write error: Invalid argument
>>> root@(none)$
>>
>> Weird. I am not getting any error (pm80xx driver). The qd gets capped at
>> 32 as expected. Is it something that changes per libsas driver ?
> 
> That is with my pm8001 card.
> 
> What happens here is that the first store of 33 gets through to 
> ata_change_queue_depth() as it does not exceed the SAS shost can_queue, 
> which is >> 32, and then we cap this to 32 and store it in 
> sdev->queue_depth. And then the 2nd store of 33 also gets through, but 
> this following expression not evaluate true in ata_change_queue_depth():
> 
> queue_depth < 1 || queue_depth == sdev->queue_depth
> 
> So we don't return. However the following subsequent test does evaluate 
> true in ata_change_queue_depth():
> 
> if (sdev->queue_depth == queue_depth)
> 	return -EINVAL;
> 
> And we error.

I dug further into this. For AHCI, I still get an error when trying to set
33. No capping and defaulting to 32. The reason is I believe that
sdev_store_queue_depth() has the check:

	if (depth < 1 || depth > sdev->host->can_queue)
                return -EINVAL;

as you mentioned. So all good.

So changing that last "if" in ata_change_queue_depth() to

	if (sdev->queue_depth == queue_depth)
		return sdev->queue_depth;

has no effect. The error remains.

Now, for a libsas SATA drive, if I add the above change, I do indeed get a
cap to 32 and the QD changes, no error. That is bothering me as that is
really inconsistent. Instead of suppressing the error, shouldn't we unify
AHCI and libsas behavior and error if the user is attempting to set a
value larger than what the *device* supports (the host can_queue was
checked already). In a nutshell, the difference comes form
sdev->host->can_queue being equal to the device max qd for AHCI but not
necessarily for libsas.

I am tempted to leave things as is for now (not changin gthe current weird
behavior) and cleaning that up during the next round. Thoughts ?

> 
>>
>>> I also note that setting a value out of range is just rejected for a SAS
>>> device, and not capped to the max range (like it is for SATA).
>>
>> Not sure where that come from. A quick look does not reveal anything
>> obvious. Need to dig into that one.
>>>
>>> AHCI rejects out of range values it as it exceeds the shost can_queue in
>>> sdev_store_queue_depth().
>>
>> Indeed:
>>
>> echo 1 > /sys/block/sdk/device/queue_depth
>> echo 33 > /sys/block/sdk/device/queue_depth
> 
> Hmmmm... why no error message? is the printk silenced?
> 
>> cat /sys/block/sdk/device/queue_depth
>> 1
>>
>> But for the libsas SATA device:
>>
>> echo 1 > /sys/block/sdd/device/queue_depth
>> cat /sys/block/sdd/device/queue_depth
>> 1
>> echo 33 > /sys/block/sdd/device/queue_depth
>> cat /sys/block/sdd/device/queue_depth
>> 32
>>
>> As one would expect... > Need to dig into that one.
>>
> 
> thanks,
> John
> 

-- 
Damien Le Moal
Western Digital Research

