Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FFDC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 02:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbiLNCrD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 21:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiLNCq6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 21:46:58 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7107E6415
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 18:46:57 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NX05V4TykzqT6T;
        Wed, 14 Dec 2022 10:42:38 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 14 Dec 2022 10:46:55 +0800
Subject: Re: [PATCH v2 4/5] scsi: libsas: factor out sas_ata_add_dev()
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
References: <20221213150942.988371-1-yanaijie@huawei.com>
 <20221213150942.988371-5-yanaijie@huawei.com>
 <76747055-4b60-a5d0-2b40-8140efcb29ae@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <6b022246-f3de-bf99-cb07-c408a356c2d6@huawei.com>
Date:   Wed, 14 Dec 2022 10:46:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <76747055-4b60-a5d0-2b40-8140efcb29ae@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/14 0:22, John Garry wrote:
> On 13/12/2022 15:09, Jason Yan wrote:
>> Factor out sas_ata_add_dev() and put it in sas_ata.c since it is a sata
>> related interface. Also follow the standard coding style to define an
>> inline empty function when CONFIG_SCSI_SAS_ATA is not enabled.
>>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> 
> Apart from comment, below:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
>> ---
>>   drivers/scsi/libsas/sas_ata.c      | 62 ++++++++++++++++++++++++++++++
>>   drivers/scsi/libsas/sas_expander.c | 54 +-------------------------
>>   include/scsi/sas_ata.h             |  9 +++++
>>   3 files changed, 73 insertions(+), 52 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_ata.c 
>> b/drivers/scsi/libsas/sas_ata.c
> 
>> @@ -109,6 +111,13 @@ static inline int sas_discover_sata(struct 
>> domain_device *dev)
>>       pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot 
>> attach\n");
>>       return -ENXIO;
>>   }
>> +static inline int sas_ata_add_dev(struct domain_device *parent, 
>> struct ex_phy *phy,
>> +                  struct domain_device *child, int phy_id)
>> +{
>> +    pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot 
>> add device, target proto 0x%x at %016llx:0x%x\n",
>> +          phy->attached_tproto, SAS_ADDR(parent->sas_addr), phy_id);
> 
> Do you really think that we need to add all this info, like 
> parent->sas_addr?
> 

I did not want to change the functionality at the first time so I kept 
these info printing.

> Indeed, I think that we could make all these prints for 
> CONFIG_SCSI_SAS_ATA=N into a single global pr_notice_once(). That's just 
> my thoughts.
> 

Yeah, makes sense. Let me have a try.

Thanks

>> +    return -ENODEV;
>> +}
>>   #endif
>>   #endif /* _SAS_ATA_H_ */
> 
> .
