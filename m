Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B65FC77B73
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Apr 2023 01:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjDUBzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Apr 2023 21:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjDUBzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2023 21:55:13 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BBB1A8
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2023 18:55:12 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q2cxt3yPzzsRMn;
        Fri, 21 Apr 2023 09:53:38 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 09:55:10 +0800
Subject: Re: [PATCH v2 1/3] scsi: libsas: Simplify sas_check_eeds()
To:     Christoph Hellwig <hch@lst.de>
CC:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <hare@suse.com>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>
References: <20230420143339.2769414-1-yanaijie@huawei.com>
 <20230420143339.2769414-2-yanaijie@huawei.com>
 <20230420150031.GA11103@lst.de>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <577883da-30ac-7863-f4ef-7c4f79033b72@huawei.com>
Date:   Fri, 21 Apr 2023 09:55:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230420150031.GA11103@lst.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/4/20 23:00, Christoph Hellwig wrote:
> On Thu, Apr 20, 2023 at 10:33:37PM +0800, Jason Yan wrote:
>> In sas_check_eeds() there is an empty branch. We can reverse the
>> test expression and then remove the empty branch. Also the the test
>> expression is a little bit complex so it deserves an individual
>> function. And make the continuing prototype lines indented after
>> the opening parenthesis to follow the standard coding style.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 39 +++++++++++++++---------------
>>   1 file changed, 19 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index dc670304f181..70fd4f439664 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -1198,37 +1198,36 @@ static void sas_print_parent_topology_bug(struct domain_device *child,
>>   		  sas_route_char(child, child_phy));
>>   }
>>   
>> +static bool sas_eeds_valid(struct domain_device *parent, struct domain_device *child)
> 
> Please avoid the overly long line.

OK.
