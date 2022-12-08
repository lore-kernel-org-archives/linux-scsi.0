Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79B1C63708
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 06:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiLHGgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 01:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiLHGgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 01:36:43 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF989E45A
        for <linux-scsi@vger.kernel.org>; Wed,  7 Dec 2022 22:36:42 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NSPYK2VklzRps3;
        Thu,  8 Dec 2022 14:35:49 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 14:36:22 +0800
Subject: Re: [PATCH 1/6] scsi: libsas: move sas_get_ata_command_set() up to
 save the declaration
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-2-yanaijie@huawei.com>
 <37743f09-8d30-a41b-10c1-caf34f919f3e@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <6297461a-0908-1c73-383e-6f5f2146c8ea@huawei.com>
Date:   Thu, 8 Dec 2022 14:36:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <37743f09-8d30-a41b-10c1-caf34f919f3e@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/5 16:45, John Garry wrote:
> On 04/12/2022 08:16, Jason Yan wrote:
>> There is a sas_get_ata_command_set() declaration above sas_get_ata_info()
>> to make it compile ok. However this function is defined in the same file
>> below. So move it up to save the declaration.
>>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> 
> Apart from comments, below:
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 

Thank you John.

>> ---
>>   drivers/scsi/libsas/sas_ata.c | 28 +++++++++++++---------------
>>   1 file changed, 13 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_ata.c 
>> b/drivers/scsi/libsas/sas_ata.c
>> index f7439bf9cdc6..34009c330eb2 100644
>> --- a/drivers/scsi/libsas/sas_ata.c
>> +++ b/drivers/scsi/libsas/sas_ata.c
>> @@ -239,7 +239,19 @@ static struct sas_internal 
>> *dev_to_sas_internal(struct domain_device *dev)
>>       return to_sas_internal(dev->port->ha->core.shost->transportt);
>>   }
>> -static int sas_get_ata_command_set(struct domain_device *dev);
>> +static int sas_get_ata_command_set(struct domain_device *dev)
>> +{
>> +    struct dev_to_host_fis *fis =
>> +        (struct dev_to_host_fis *) dev->frame_rcvd;
> 
> nit: I did not think that we add a whitespace before casting. And I 
> think that it would be neater if fis was assigned separately, avoiding 
> overflowing the line in this way.
> 
> Having said that, it does seem odd to cast from u8 [] to struct 
> dev_to_host_fis * and then back to (u8 *) in the ata_tf_from_fis() call, 
> below.

Yeah, odd. I'd prefer remove 'fis' and then do:

ata_tf_from_fis(dev->frame_rcvd, &tf).

Thanks,
Jason




