Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C61C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 09:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbiBQJXe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 04:23:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237832AbiBQJXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 04:23:32 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D716409
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 01:23:18 -0800 (PST)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jzq991hL9z67nPb;
        Thu, 17 Feb 2022 17:22:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 10:23:15 +0100
Received: from [10.47.81.42] (10.47.81.42) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Feb
 2022 09:23:14 +0000
Message-ID: <712a4702-8534-fad2-2679-cc5cf62e4a9e@huawei.com>
Date:   Thu, 17 Feb 2022 09:23:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-28-damien.lemoal@opensource.wdc.com>
 <51d7c127-f975-14e9-a036-c37416ed8679@huawei.com>
 <32efd519-3485-ee34-84e2-34a0d8c27e17@opensource.wdc.com>
 <38090771-ad24-1b20-9b79-f7f89d42ea66@huawei.com>
 <37df3c92-c28e-72d4-76d8-33356829af5a@opensource.wdc.com>
 <5a5481af-e975-c6fb-2d48-961769eae551@huawei.com>
 <9c22abeb-1b22-4613-66bc-276aaa4a639c@opensource.wdc.com>
 <e7b5c48b-4217-7247-8bc9-e5f8ae9411ce@huawei.com>
 <e9b40eaf-7aa5-798b-1bde-1a2ce8d83433@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <e9b40eaf-7aa5-798b-1bde-1a2ce8d83433@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.42]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/02/2022 00:12, Damien Le Moal wrote:
>>>> I'll have a look at it. And that is on mainline or mkp-scsi staging, and
>>>> not your patchset.
>>> Are you saying that my patches suppresses the above ? This is submission
>>> path and the dma code seems to complain about alignment... So bad buffer
>>> addresses ?
>> Your series does not suppress it. It doesn't occur often, so I need to
>> check more.
>>
>> I think the issue is that we call dma_map_sg() twice, i.e. ccb never
>> unmapped.
> That would be a big issue indeed. We could add a flag to CCBs to track
> the buf_prd DMA mapping state and BUG_ON() when ccb free function is
> called with the buffer still mapped. That should allow catching this
> infrequent problem ?
> 

I figured out what is happening here and it does not help solve the 
mystery of my hang.

Here's the steps:
a. scsi_cmnd times out
b. scsi error handling kicks in
c. libsas attempts to abort the task, which fails
d. libsas then tries IT nexus reset, which passes
  - libsas assumes the scsi_cmnd has completed with failure
e. error handling concludes
f. scsi midlayer then retries the same scsi_cmnd
g. since we did not "free" associated ccb earlier or dma unmap at d., 
the dma unmap on the same scsi_cmnd causes the warn

So the LLD should really free resources and dma unmap at point IT nexus 
reset completes, but it doesn't. I think in certain conditions dma map 
should not be done twice.

Anyway, that can be fixed, but I still have the hang :(

Thanks,
John
