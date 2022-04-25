Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99034C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 08:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiDYIbO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 04:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiDYIbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 04:31:01 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABA6186F3;
        Mon, 25 Apr 2022 01:27:56 -0700 (PDT)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KmykX5Mhzz67y8F;
        Mon, 25 Apr 2022 16:25:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Apr 2022 10:27:54 +0200
Received: from [10.47.92.213] (10.47.92.213) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.24; Mon, 25 Apr
 2022 09:27:53 +0100
Message-ID: <83328d95-5d5e-f311-952c-ce627cb035ea@huawei.com>
Date:   Mon, 25 Apr 2022 09:27:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 1/4] scsi: libsas: Add sas_execute_internal_abort_single()
To:     Hannes Reinecke <hare@suse.de>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Ajish.Koshy@microchip.com>, <linuxarm@huawei.com>,
        <Viswas.G@microchip.com>, <hch@lst.de>, <liuqi115@huawei.com>,
        <chenxiang66@hisilicon.com>
References: <1646309930-138960-1-git-send-email-john.garry@huawei.com>
 <1646309930-138960-2-git-send-email-john.garry@huawei.com>
 <929aede0-9e58-9c3d-5951-6151a3281edd@suse.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <929aede0-9e58-9c3d-5951-6151a3281edd@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.92.213]
X-ClientProxiedBy: lhreml702-chm.china.huawei.com (10.201.108.51) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/04/2022 13:21, Hannes Reinecke wrote:
>>   int sas_execute_tmf(struct domain_device *device, void *parameter,
>>               int para_len, int force_phy_id,
>>               struct sas_tmf_task *tmf)
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index df2c8fc43429..2d30d57916e5 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -557,6 +557,16 @@ struct sas_ata_task {
>>       int    force_phy_id;
>>   };
>> +/* LLDDs rely on these values */
>> +enum sas_internal_abort {
>> +    SAS_INTERNAL_ABORT_SINGLE    = 0,
>> +};
>> +
> 
> Why don't you use the existing TMF_XXX values here?
> Your 'single' method pretty much _is_ a TMF_ABORT_TASK, and the 'device' 
> method _is_ a TMF_ABORT_TASK_SET, no?

Sure, they are doing the same as TMFs and there is equivalence in the 
'single' and 'device' methods, as you say.

However, as mentioned in the comment, the LLDDs rely on the values in 
enum sas_internal_abort, which do not match the values in 
TMF_ABORT{_TASK, _TASK_SET}.

Thanks,
John
