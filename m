Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38C1C7619A
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 03:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjDCDNW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Apr 2023 23:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDCDNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2023 23:13:18 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C028F30E2
        for <linux-scsi@vger.kernel.org>; Sun,  2 Apr 2023 20:13:15 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PqbV66hKVznZsC;
        Mon,  3 Apr 2023 11:09:50 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 3 Apr 2023 11:13:13 +0800
Subject: Re: [PATCH 3/3] scsi: libsas: Simplify sas_check_parent_topology()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <john.g.garry@oracle.com>
References: <20230401081526.1655279-1-yanaijie@huawei.com>
 <20230401081526.1655279-4-yanaijie@huawei.com>
 <48d385f7-92b5-4e99-7e32-119db6a74f3f@opensource.wdc.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <64897a78-19ff-d064-1edb-7cc7e928b309@huawei.com>
Date:   Mon, 3 Apr 2023 11:13:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <48d385f7-92b5-4e99-7e32-119db6a74f3f@opensource.wdc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/4/2 13:00, Damien Le Moal wrote:
> On 4/1/23 17:15, Jason Yan wrote:
>> Factor out a new helper sas_check_phy_topology() to simplify
>> sas_check_parent_topology(). And centralize the calling of
>> sas_print_parent_topology_bug().
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 95 +++++++++++++++++-------------
>>   1 file changed, 55 insertions(+), 40 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index c0841652f0e0..bffcccdbda6b 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -1238,11 +1238,59 @@ static int sas_check_eeds(struct domain_device *child,
>>   	return res;
>>   }
>>   
>> -/* Here we spill over 80 columns.  It is intentional.
>> - */
>> -static int sas_check_parent_topology(struct domain_device *child)
>> +
>> +static int sas_check_phy_topology(struct domain_device *child, struct ex_phy *parent_phy)
> 
> Long line. Break after the first argument.

And also some lines exceed 80 columns, I wonder if you want me to break 
them or something else to shorten them too.

> 
>>   {
>>   	struct expander_device *child_ex = &child->ex_dev;
>> +	struct ex_phy *child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];

This line is slightly longer than 80, but I prefer to keep them as is.

>> +	struct expander_device *parent_ex = &child->parent->ex_dev;
>> +	bool print_topology_bug = false;
>> +	int res = 0;
>> +
>> +	switch (child->parent->dev_type) {
>> +	case SAS_EDGE_EXPANDER_DEVICE:
>> +		if (child->dev_type == SAS_FANOUT_EXPANDER_DEVICE) {
>> +			if (parent_phy->routing_attr != SUBTRACTIVE_ROUTING ||
>> +				child_phy->routing_attr != TABLE_ROUTING) {
>> +				res = -ENODEV;
>> +				print_topology_bug = true;
>> +			}
>> +		} else if (parent_phy->routing_attr == SUBTRACTIVE_ROUTING) {
>> +			if (child_phy->routing_attr == SUBTRACTIVE_ROUTING) {
>> +				res = sas_check_eeds(child, parent_phy, child_phy);

And this line too. If someone insist to keep it in 80 columns, it may be 
written like:

+				res = sas_check_eeds(child, parent_phy,
+						     child_phy);

Which I do not like either.
