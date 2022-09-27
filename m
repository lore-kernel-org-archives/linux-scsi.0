Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAA5C07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 23:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiI0XpQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 19:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiI0XpN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 19:45:13 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4245610044
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 16:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664322310; x=1695858310;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=w2L6cdVn+U0fnhVsr1zHVAf4O3jrCn+FDD7RoZyhMzU=;
  b=gqlAo0TyCFbGyXrees73lfW3pZTeOIdMMpfcdF4xd2FL/qK3UNSXjIjZ
   kKzDwNAmRwo3sBMjlAyRwA5Enz0xDsf1SLgKHUwxWso0aUr0evoo6+DPp
   Z1KKKOJ1Xf6r1DYvnFQPJ/+/lD5qC8VVBcps000Avxy7QmKwDnHD3zi9C
   +bYg91wBKVdXwnPIQtxZUlbEMUv8U0JCGeZH0+SaQQX9BjwmUMmi4dw1K
   W/6ZZu4c7D1Po24OzMQcZksRilaVQG5v4ns9SCREz1EX0tD76Y9GFp6yo
   e/BoQuNPfGavzuLwX5SPqynwR6+LapuxGd3uIH44uoDXp9Gq5rVb6/JQP
   w==;
X-IronPort-AV: E=Sophos;i="5.93,350,1654531200"; 
   d="scan'208";a="212840703"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2022 07:45:06 +0800
IronPort-SDR: y4h+9VrV7q7qQrVwEUPM6ObCYboquMyKyIRillhq68Lfwrh45ESodNzbp+wQUXtKTXJ0VF/fKu
 kEqj3Qs+tT6bEcpWKVywL7mujENKG7rGalaCsk6EgHenOzOcr3hDrQYl7NSZnjLxH0o99peMPH
 fy8AGtk/XivWsbPIx+ydRNF6jRJx/Es3wSE/i+PuENer4vUOqSvGM0mVBRr2ASUEBYcCkecOqQ
 O4+BxpR+18EnytXMzXoe5ok5FABUAPLpIAIM84sy/J8yWQ6Cc9RGZOUBmZPTwMhqLl6A2Jd9Av
 U3cjntHg0DVr1pjoZzraMB33
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 16:05:02 -0700
IronPort-SDR: 4zMW2cC3Ik/3vVgasWwDUPgJuLN2g8n3O4p/147jkbvrdcl57S7Bgt4t/bO4bMTZ9PLmTeeDV4
 7LIqpI5AEUqh+tqLnj6fU6s0MOdT1r7lkZ4/ECFLWEKKW18g7D/kIPAoOPoHDNAGk4AAuhVZPN
 /hxUyxuDeRafSxJAa7PNtCmfLvQ63n1p/uyjWbvDy6AVdeo7Z88ce7pBAA//tnUo5k12cPIqB6
 wX6ZsehJgmBt2dj7Bii8iVSKC4yuvjiL4ICPOur0vPeKajyZKK97FymesIDFy/X7bLcNrTCH2q
 3yI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Sep 2022 16:39:06 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4McbgF5TLmz1Rwrq
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 16:39:05 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664321945; x=1666913946; bh=w2L6cdVn+U0fnhVsr1zHVAf4O3jrCn+FDD7
        RoZyhMzU=; b=nQz68xjU7D6tOaMcZLpzHVsG1yfpfRWsEfcPZWEIgYSPqUuWKAH
        avcdnalv9dIcyIkNsuDgvoFEsPf1HwPehWKDhZggv1Jjo+Rn5Bt9RG62gZXHE1Sp
        WJ4NpJb0Ncj85UQchXDWwPa2TsIN7i3Qg03+eMmCYOqH3Q3x1dLH9SKkJ3y92PXD
        PxWHgsMgawkrti2YYy9S26KSU7DabYNuLy5IK+Iy344mY3Zvr1W06vZKg7A5/6rw
        Px5fE9Yk9AMFp+O0EW5UKG+ExH0/jxrAky1jfzoC3wZAOEXmRXWKw5UsHxVnhAdD
        Bu0P5HYUOehpTpAvjLZkIbyEFqBCmuQf6XQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9p52hHhtUyBd for <linux-scsi@vger.kernel.org>;
        Tue, 27 Sep 2022 16:39:05 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4McbgD3SyQz1RvLy;
        Tue, 27 Sep 2022 16:39:04 -0700 (PDT)
Message-ID: <46240962-bfd3-8ff9-03a3-d15db7a67df7@opensource.wdc.com>
Date:   Wed, 28 Sep 2022 08:39:03 +0900
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

Gotcha. This needs to be changed to:

if (sdev->queue_depth == queue_depth)
	return queue_depth;

And the non-sensical error will go away.

Will send another patch for that.

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

