Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5BFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 11:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiBILvI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiBILvG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 06:51:06 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA4FE056C3A
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 02:42:23 -0800 (PST)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jtv5k1zhTz67ySG;
        Wed,  9 Feb 2022 17:02:18 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 10:06:25 +0100
Received: from [10.47.89.1] (10.47.89.1) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Feb
 2022 09:06:21 +0000
Message-ID: <059a7c88-d419-b4d7-ee10-be5782f30553@huawei.com>
Date:   Wed, 9 Feb 2022 09:06:16 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 01/44] ips: Use true and false instead of TRUE and
 FALSE
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-2-bvanassche@acm.org>
 <deb3fd22-2352-097f-7fa0-20d2e338aac8@huawei.com>
 <483bf415-8a13-0d2c-8737-9322c19ba537@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <483bf415-8a13-0d2c-8737-9322c19ba537@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.89.1]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/02/2022 00:04, Bart Van Assche wrote:
>>> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
>>> index 498bf04499ce..b3532d290848 100644
>>> --- a/drivers/scsi/ips.c
>>> +++ b/drivers/scsi/ips.c
>>> @@ -655,13 +655,13 @@ ips_release(struct Scsi_Host *sh)
>>
>> This function and other places return an int, and not a bool, so that 
>> could be changed as well. Prob not worth the churn, though.
> 
> Because of this comment I took a closer look at the ips_release() 
> function. It seems to me that that function only has one caller and that 
> caller ignores the value returned by ips_release(). So how about 
> changing the return type into 'void'?

You could do that. But then there are other places where FALSE is 
checked against at uint8_t - see ips_ha.waitflag, so by the same reason 
could be changed.

However, as I said, changes like this are prob not worth it...

thanks,
John
