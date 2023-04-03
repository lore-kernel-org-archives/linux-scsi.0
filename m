Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65E7C7619A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 01:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjDCBhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 21:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjDCBhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 21:37:50 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14DC65BE
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 18:37:48 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PqYRD5zVfzKqsZ;
        Mon,  3 Apr 2023 09:37:12 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 3 Apr 2023 09:37:46 +0800
Subject: Re: [PATCH 1/3] scsi: libsas: Simplify sas_check_eeds()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <john.g.garry@oracle.com>
References: <20230401081526.1655279-1-yanaijie@huawei.com>
 <20230401081526.1655279-2-yanaijie@huawei.com>
 <739e2d17-f1c6-fc33-adc4-41cb97b5950d@opensource.wdc.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <e9729d4e-e6d1-7bf6-25a6-5de92214b019@huawei.com>
Date:   Mon, 3 Apr 2023 09:37:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <739e2d17-f1c6-fc33-adc4-41cb97b5950d@opensource.wdc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Damien,

On 2023/4/2 12:58, Damien Le Moal wrote:
> On 4/1/23 17:15, Jason Yan wrote:
>> In sas_check_eeds() there is an empty branch. We can reverse the
>> test expression and then remove the empty branch. Also the the test
>> expression is a little bit complex so it deserves an individual
>> function. And make the continuing prototype lines indented after
>> the opening parenthesis to follow the standard coding style.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 38 ++++++++++++++----------------
>>   1 file changed, 18 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index dc670304f181..048a931d856a 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -1198,37 +1198,35 @@ static void sas_print_parent_topology_bug(struct domain_device *child,
>>   		  sas_route_char(child, child_phy));
>>   }
>>   
>> +static bool sas_eeds_valid(struct domain_device *parent, struct domain_device *child)
>> +{
>> +	struct sas_discovery *disc = &parent->port->disc;
> 
> Missing blank line after declaration.

OK.

> 
>> +	return (((SAS_ADDR(disc->eeds_a) == SAS_ADDR(parent->sas_addr)) ||
>> +		 (SAS_ADDR(disc->eeds_a) == SAS_ADDR(child->sas_addr))) &&
>> +		((SAS_ADDR(disc->eeds_b) == SAS_ADDR(parent->sas_addr)) ||
>> +		 (SAS_ADDR(disc->eeds_b) == SAS_ADDR(child->sas_addr))));
> 
> Drop the inner-most and outter-most parenthesis.

No problem.

Thanks,
Jason
