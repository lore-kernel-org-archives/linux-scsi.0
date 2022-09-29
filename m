Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957B1C04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 08:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbiI2IDM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 04:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235418AbiI2ICt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 04:02:49 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744291570F
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 01:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664438547; x=1695974547;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YshxXDMKEqJOIsgscRPPwus5X09Feg6t1SyxNOe9VoM=;
  b=lVfQlq5RopI6jGeK08VNorSYbIyKvOFaAXv0T5tM+wtAgeY07Tz9ZVVz
   tWXgauEpHUqxfWdCQNFNKW3bFzaPUgNSrXMMKbCjiBtiOC6mLRkiLaKYL
   kXhQu868BEsFdqFN3lhrPrHFMTnaemSA3DokU6OcpX78+duChRi6587+Y
   IBBIdRSWmz+X5ziut++S9tn+jdTiMQ9ycDpVDtshUf+yqsFZopMdh6/AV
   b7fLLEDhZx4NNBPvc8cc6Tem8Tav7FFMVCeSxFZAMIf8VSxAiegnXAZvH
   SPnpH25kU2MA9XE/ARgpQmAc8YH6iNW8umOUPQXDgMLBbXqMtpzj9abd8
   A==;
X-IronPort-AV: E=Sophos;i="5.93,354,1654531200"; 
   d="scan'208";a="324662857"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2022 16:02:26 +0800
IronPort-SDR: EddMqhsMCtPK9u4FLnWnbg8JgL+o3NB5v0OvQxU9Wdsexcl4l2qYRV/xQ6oe70XoGMer2PUNaT
 4KJ6bjnsQV3vAZSTSyLf1onqGmCmXqvulpfg3aASDt5CBVvgGyWwPdm0xe0rDHguFo65xvyQVC
 o87a2GxDCaKLPJjyFSJ2NkKmu7r1fOqm70oAciqWxGOBjd17uyFz9jXMiCBgIqoMisc3dmAXUS
 r6QG6hzaUyb3kcb9+wCpp3/QlQvYZfFchfxl9l2mkGZnOQu7AVelrnKYOjNsCfCYMZp5Gf2qML
 TJrPX7q1oAbHTg3NukU4Rihk
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Sep 2022 00:16:49 -0700
IronPort-SDR: GDjjMxaPz5vKTrRfRe5QPsPcUfdJ4ZVhJ2q+4li1oL23y90PbwI98LTtbig3tZsoAaL4wRQFlH
 G+3xsq/cm1ZHWsSl69i5o/xGZe9rS4MmygC26ZDuTRK+AUVrDGWo6DzUq+TuEgGZuGuaAGmIzm
 Gt8SXxhoLoTV5PcMO5Dt03SS+NzDqzX0lRksD4eadxCHxI8jFY+uAPkjYhJAhjngx5DvhZg2jb
 PxTKlJEgvzbHzU2H1AfN+nCzunLkkg+jlWRDWRpc+WXlXD9hJ95Ifh5PBATYHBinA1LFCrfi2+
 p70=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Sep 2022 01:02:26 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MdQnZ0CgJz1RwtC
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 01:02:25 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664438545; x=1667030546; bh=YshxXDMKEqJOIsgscRPPwus5X09Feg6t1Sy
        xNOe9VoM=; b=X+WGGr+UjsiYMFJegjoEUMdtZhxiqPoCJmmvjzOf+xfkLdu4Vad
        58Z4S365gtjJHvftn16Lg21Q1arzXtTPYtZu3p/eLBgtDTp0aX/IyiKZfT5sfVp1
        NOKdFa2rDONRcEOeOPeVHRs34zSxG0mPbZiuTeE5glW7cpQYyYE2dbJ++PH/iAWF
        uKJGqrY3TaEYyqFccnKobQO/Rsk4/QZDSwSF4aWFiP0Go8NOWHfKmjuCOs2hJzZZ
        U4454obB+3Ijvv/h1R6X7xXkANFCw0kyDwdIAwangAuI2LEAnP4t+Ml5ditXx/pG
        kJyRFGF8c4wEg0QK2q1dkLiwx9XXJ5vup5Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id iv7X4097t5rU for <linux-scsi@vger.kernel.org>;
        Thu, 29 Sep 2022 01:02:25 -0700 (PDT)
Received: from [10.225.163.96] (unknown [10.225.163.96])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MdQnV6W2Vz1RvLy;
        Thu, 29 Sep 2022 01:02:22 -0700 (PDT)
Message-ID: <e8d20a5d-8ca6-b1ff-20be-fb0c782345ca@opensource.wdc.com>
Date:   Thu, 29 Sep 2022 17:02:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 6/6] scsi: mvsas: Use sas_task_find_rq() for tagging
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        damien.lemoal@wdc.com
Cc:     hare@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        ipylypiv@google.com, changyuanl@google.com, hch@lst.de
References: <1664368034-114991-1-git-send-email-john.garry@huawei.com>
 <1664368034-114991-7-git-send-email-john.garry@huawei.com>
 <53e304b4-c025-e884-c8f5-6c2e96cc0052@opensource.wdc.com>
 <e4aa7b2b-3fab-14f9-8af5-8b4c37afb13f@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <e4aa7b2b-3fab-14f9-8af5-8b4c37afb13f@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/22 16:49, John Garry wrote:
> On 29/09/2022 03:22, Damien Le Moal wrote:
>> On 9/28/22 21:27, John Garry wrote:
>>> The request associated with a scsi command coming from the block layer
>>> has a unique tag, so use that when possible for getting a slot.
>>>
>>> Unfortunately we don't support reserved commands in the SCSI midlayer yet.
>>> As such, SMP tasks - as an example - will not have a request associated, so
>>> in the interim continue to manage those tags for that type of sas_task
>>> internally.
>>>
>>> We reserve an arbitrary 4 tags for these internal tags. Indeed, we already
>>> decrement MVS_RSVD_SLOTS by 2 for the shost can_queue when flag
>>> MVF_FLAG_SOC is set. This change was made in commit 20b09c2992fef
>>> ("[PATCH] [SCSI] mvsas: add support for 94xx; layout change; bug fixes"),
>>> but what those 2 slots are used for is not obvious.
>>>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> ---
>>>   drivers/scsi/mvsas/mv_defs.h |  1 +
>>>   drivers/scsi/mvsas/mv_init.c |  4 ++--
>>>   drivers/scsi/mvsas/mv_sas.c  | 22 +++++++++++++++++-----
>>>   drivers/scsi/mvsas/mv_sas.h  |  1 -
>>>   4 files changed, 20 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/scsi/mvsas/mv_defs.h b/drivers/scsi/mvsas/mv_defs.h
>>> index 7123a2efbf58..8ef174cd4d37 100644
>>> --- a/drivers/scsi/mvsas/mv_defs.h
>>> +++ b/drivers/scsi/mvsas/mv_defs.h
>>> @@ -40,6 +40,7 @@ enum driver_configuration {
>>>   	MVS_ATA_CMD_SZ		= 96,	/* SATA command table buffer size */
>>>   	MVS_OAF_SZ		= 64,	/* Open address frame buffer size */
>>>   	MVS_QUEUE_SIZE		= 64,	/* Support Queue depth */
>>> +	MVS_RSVD_SLOTS		= 4,
>>>   	MVS_SOC_CAN_QUEUE	= MVS_SOC_SLOTS - 2,
>>>   };
>>>   
>>> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
>>> index c85fb812ad43..d834ed9e8e4a 100644
>>> --- a/drivers/scsi/mvsas/mv_init.c
>>> +++ b/drivers/scsi/mvsas/mv_init.c
>>> @@ -284,7 +284,7 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
>>>   			printk(KERN_DEBUG "failed to create dma pool %s.\n", pool_name);
>>>   			goto err_out;
>>>   	}
>>> -	mvi->tags_num = slot_nr;
>>> +	mvi->tags_num = MVS_RSVD_SLOTS;
>>
>> Same comment as for pm8001: do you really need this field if the value
>> is always MVS_RSVD_SLOTS ?
> 
> Right, I don't need this struct member. Again I can just use this macro 
> directly.
> 
>>
>>>   
>>>   	return 0;
>>>   err_out:
>>> @@ -367,7 +367,7 @@ static struct mvs_info *mvs_pci_alloc(struct pci_dev *pdev,
>>>   	mvi->sas = sha;
>>>   	mvi->shost = shost;
>>>   
>>> -	mvi->tags = kzalloc(MVS_CHIP_SLOT_SZ>>3, GFP_KERNEL);
>>> +	mvi->tags = kzalloc(MVS_RSVD_SLOTS, GFP_KERNEL);
>>
>> Field name ? reserved_tags ?
>> Also, the alloc seems wrong. This will allocate 4 bytes, but you only
>> need 4 bits. You could make this an unsigned long and not allocate
>> anything. 
> 
> Well spotted. I should have questioned more why they had >>3 previously.
> 
> But I would rather keep as a bitmap, i.e. *unsigned long for simplicity.>
>> Same remark for pm8001 by the way.
> 
> I think it's ok as it uses bitmap_zalloc()

Yes !

> 
>>
>> That would cap MVS_RSVD_SLOTS to BITS_PER_LONG maximum, but that is easy
>> to check at compile time with a #if/#error.
>>
> 
> As above, I'd rather keep as a bitmap. It's a little inefficient, but is 
> a one off in the driver.
> 
> Thanks,
> John
> 
> 

-- 
Damien Le Moal
Western Digital Research

