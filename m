Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA89C3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 07:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLHH0d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 02:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiLHH0b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 02:26:31 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36EF4732E
        for <linux-scsi@vger.kernel.org>; Wed,  7 Dec 2022 23:26:29 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NSQbh2RXgzJpCN;
        Thu,  8 Dec 2022 15:22:56 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 15:26:27 +0800
Subject: Re: [PATCH 5/6] scsi: libsas: factor out sas_ata_add_dev()
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-6-yanaijie@huawei.com>
 <9eeaad19-c1e6-f401-3bdf-a7c3d0b3ab77@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <a05a403d-b663-8255-c9b0-9882ebe05032@huawei.com>
Date:   Thu, 8 Dec 2022 15:26:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <9eeaad19-c1e6-f401-3bdf-a7c3d0b3ab77@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/5 17:24, John Garry wrote:
> On 04/12/2022 08:16, Jason Yan wrote:
>> +static inline int sas_ata_add_dev(struct domain_device *parent, 
>> struct ex_phy *phy,
>> +                  struct domain_device *child, int phy_id)
>> +{
>> +    pr_notice("ATA is not enabled, target proto 0x%x at %016llx:0x%x\n",
> 
> nit: how about add "SCSI_SAS_ATA is not enabled ..." or use similar to 
> the log in sas_discover_domain()?

Yes, make sense. Will update.

Thanks,
Jason

> 
>> +          phy->attached_tproto, SAS_ADDR(parent->sas_addr), phy_id);
>> +    return -ENODEV;
> 
> .
