Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53741C6FA82
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Sep 2022 23:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiIYXA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Sep 2022 19:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIYXAY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2022 19:00:24 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BF71A3AE
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 16:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664146823; x=1695682823;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=q5ndYG7MZM8fplI0Sb0WNEkoAhj3lIM1QuGfdBfeGOk=;
  b=OleJSQOg/XjEavwtwPa57KTBS/i5x5nqnscWoWlhXSuHw1HA77JrWQKk
   mQ+gFRk6xziAAXjhJgnTkrJszYeLaiiPmYqWXuiXi1UDPATS+mVqtONeA
   P8M8QbK3UifalkDjqpazXpZQv5JLDuLLbnCdF+4By/J12lCaby8iLMxTw
   Z5CvIH9iQgoQrN0t2jPqt54R64EkWAf+sZjTaSBCJ5g5IiYuLHyqToDOO
   lawZBjDN01Sibcg1bs/1F4lP5ZQKRtW8wWHqcDOkqg5QBOjhuXC3WIFh1
   9vDMcKJjCJHLq16xs7L88gO5qzg+zbb/Q22RBK59NAEt01PLM5eslEBXe
   w==;
X-IronPort-AV: E=Sophos;i="5.93,345,1654531200"; 
   d="scan'208";a="210603481"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Sep 2022 07:00:23 +0800
IronPort-SDR: Bv8npLXCBFkYSK8AwFcHoQZbZpc8TuHceQjYIXvHWlUgUUwvHQyWuQiTrrrlzCIu7QT2PH9dkx
 fHXCXv3QcBItFSpQkwLoG5oXD0mwW2yrDtVuo8EdsLLMnEkDdh+gqruqhQhZxaIOWG2FyM1ghp
 /F2P4A/sjWLmAdzwJGcRgw7La8GoWssgxFqbu1mg6r5zW9o3sRl5kGDNW8ovz0SEA+EcKXYZmp
 rB9Fwem6jzYKq/P98YFcgjc1sH09B8ngw/LIuyCTXntQVlsp2HFy9gDUtnox/bMikbqOG+ssjP
 uk1yPm5YpLGkT1wRUF5JOsTK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Sep 2022 15:14:51 -0700
IronPort-SDR: E4EDQgB/5+foIQGymo+eJr9ZkSkphtXByg0yf0JSFVfBdT7Ks/JGM//MNA8rcaVwiA+T06tiVa
 AnenYOTqvpbvT11aQkAiaSZ41o1l//JSNisaREpiMKUNNDvnJQdSnLfEiqWDC28CTXrtrHrEac
 Hh8/aA/JSffV5jGEXxSk3A5y+5vDiiur+RgXTFw8CPhcOd/+9UtVFPFgeNckxUVT/zvvgFbdvy
 K1brCOEVHbXBgxK0esdn7FG6lYxfmopVGYxOg94O3GWbRVufMigJ6QRUVw/e6M6PY7kvBswY3j
 h+U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Sep 2022 16:00:24 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MbLvW1jbLz1RvTp
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 16:00:23 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664146822; x=1666738823; bh=q5ndYG7MZM8fplI0Sb0WNEkoAhj3lIM1QuG
        fdBfeGOk=; b=lsNeTbULWgKw1J5oWILOI0VmdMUIpWUfaLGZdPXS+73vFh6ghwD
        qzhdb7fyqatLAqdrZQhtSXTt3cj1NTXNk8P7WYoVGr/+eb5qoSwaFNikln25puCz
        LV76ejvbSWTWyRMxsP3ReUczQ4EIUTR8WP8iIW151m2KUjJ8TM0rb4u8hYKiaXYs
        WRBSBNZADa9cbNIO/p1dUX+v2KRP2dc/2qsKd5rbWx5LbtSXFRREbAXFuAiAv93q
        dsA0fpV/fROB3DyeVVY+CjR6mepnYO6pXhmPDBqlZ3yhTdejVo87M/bXDv4rry0I
        EXaMXuO+hRn/7O6KT1LOCAgfvOZJA2nOP1A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2-q8weGYbLwt for <linux-scsi@vger.kernel.org>;
        Sun, 25 Sep 2022 16:00:22 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MbLvV06yvz1RvLy;
        Sun, 25 Sep 2022 16:00:21 -0700 (PDT)
Message-ID: <0e2ff01a-d972-1765-ee50-3b04476fa696@opensource.wdc.com>
Date:   Mon, 26 Sep 2022 08:00:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 2/2] ata: libata-sata: Fix device queue depth control
Content-Language: en-US
To:     Sergey Shtylyov <s.shtylyov@omp.ru>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
References: <20220924062907.959856-1-damien.lemoal@opensource.wdc.com>
 <20220924062907.959856-3-damien.lemoal@opensource.wdc.com>
 <b1595afb-49cd-2e19-1b5f-bfbe9836784e@omp.ru>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <b1595afb-49cd-2e19-1b5f-bfbe9836784e@omp.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/22 18:49, Sergey Shtylyov wrote:
> Hello!
> 
> On 9/24/22 9:29 AM, Damien Le Moal wrote:
> 
>> The function __ata_change_queue_depth() uses the helper
>> ata_scsi_find_dev() to get the ata_device structure of a scsi device and
>> set that device maximum queue depth. However, when the ata device is
>> managed by libsas, ata_scsi_find_dev() return NULL, turning
> 
>    Returns?
> 
>> __ata_change_queue_depth() into a nop, which prevents the user from
>> setting the maximum queue depth of ATA devices used with libsas based
>> HBAs.
>>
>> Fix this by renaming __ata_change_queue_depth() to
>> ata_change_queue_depth() and adding a pointer to the ata_device
>> structure of the target device as argument. This pointer is provided by
>> ata_scsi_change_queue_depth() using ata_scsi_find_dev() in the case ofi
> 
>    Of?
> 
>> a libata managed device and by sas_change_queue_depth() using
>> sas_to_ata_dev() in the case of a libsas managed ata device.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> [...]
> 
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index ff9602a0e54e..c63bb50323c1 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -1101,6 +1101,11 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>>  	if (dev->flags & ATA_DFLAG_AN)
>>  		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
>>  
>> +	pr_info("#### can queue %d, ata qd %d, scsi qd %d\n",
> 
>     Hm... isn't this a debugging pr_info() call you forgot to remove?

Oops. Yes. Sending an update. Thanks for the review.

> 
>> +		sdev->host->can_queue,
>> +		ata_id_queue_depth(dev->id),
>> +		sdev->queue_depth);
>> +
>>  	if (dev->flags & ATA_DFLAG_NCQ)
>>  		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
>>  	depth = min(ATA_MAX_QUEUE, depth);
> [...]
> 
> MBR, Sergey

-- 
Damien Le Moal
Western Digital Research

