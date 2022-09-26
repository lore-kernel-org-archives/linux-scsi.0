Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0A8C32771
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 14:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbiIZOIe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 10:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbiIZOIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 10:08:07 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506988C467;
        Mon, 26 Sep 2022 05:19:05 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MbhWs67BBz1P74g;
        Mon, 26 Sep 2022 20:14:33 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 20:18:46 +0800
Subject: Re: [PATCH v2 6/8] scsi: libsas: use sas_phy_match_dev_addr() instead
 of open coded
To:     John Garry <john.garry@huawei.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>, <bvanassche@acm.org>,
        <jinpu.wang@cloud.ionos.com>
References: <20220924073455.2186805-1-yanaijie@huawei.com>
 <20220924073455.2186805-7-yanaijie@huawei.com>
 <88299002-3aa1-d208-0451-d5b8601c0edc@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <8b0f76b2-d65f-2faf-a6e0-3623a71c18f5@huawei.com>
Date:   Mon, 26 Sep 2022 20:18:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <88299002-3aa1-d208-0451-d5b8601c0edc@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2022/9/26 19:43, John Garry wrote:
> On 24/09/2022 08:34, Jason Yan wrote:
>> @@ -2115,8 +2109,7 @@ int sas_find_attached_phy(struct expander_device 
>> *ex_dev,
>>       for (phy_id = 0; phy_id < ex_dev->num_phys; phy_id++) {
>>           phy = &ex_dev->ex_phy[phy_id];
>> -        if (SAS_ADDR(phy->attached_sas_addr)
>> -            == SAS_ADDR(dev->sas_addr))
>> +        if (sas_phy_match_dev_addr(dev, phy))
> 
> It would be nice if the series was arranged such that 
> sas_phy_match_dev_addr() is available when you introduce 
> sas_phy_match_dev_addr()


I assume you mean sas_phy_match_dev_addr() should available before 
introducing sas_find_attached_phy().

Yes, I can make that change.

Thanks,
Jason

> 
>>               return phy_id;
>>       }
> 
> Thanks,
> John
> .
