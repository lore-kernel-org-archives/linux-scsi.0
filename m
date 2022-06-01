Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D416EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 08:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350555AbiFAIMV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 04:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350562AbiFAIML (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 04:12:11 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991966545
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2022 01:12:09 -0700 (PDT)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LChcF26lXz67N5b;
        Wed,  1 Jun 2022 16:08:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 1 Jun 2022 10:12:07 +0200
Received: from [10.47.88.115] (10.47.88.115) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 1 Jun
 2022 09:12:06 +0100
Message-ID: <89016395-635f-fb09-24bc-94fa3908a729@huawei.com>
Date:   Wed, 1 Jun 2022 09:12:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 01/10] scsi/mvsas: Kill CONFIG_SCSI_MVSAS_TASKLET
To:     Davidlohr Bueso <dave@stgolabs.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <ejb@linux.ibm.com>, <tglx@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-2-dave@stgolabs.net>
 <17747966-ea44-ebe5-3d79-df7c33b6a16e@huawei.com>
 <20220531145231.opypdzrlrg23ihil@offworld>
 <5d28e848-0b9d-2aaa-e00e-7888342d25a7@huawei.com>
 <YpYxfSYDbCJEh9PG@linutronix.de> <20220601010407.kar45dc75pqcuhhl@offworld>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220601010407.kar45dc75pqcuhhl@offworld>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.115]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/06/2022 02:04, Davidlohr Bueso wrote:
> On Tue, 31 May 2022, Sebastian Andrzej Siewior wrote:
> 
>> On 2022-05-31 16:12:05 [+0100], John Garry wrote:
>>> Sorry, maybe I was not clear, but I was just asking if there was a good
>>> reason to disable interrupts at source while handling the interrupt, 
>>> and not
>>> the change to stop using a tasklet.
>>
>> Without reading the patch first: You need to disable the interrupt
>> source while the tasklet/ threaded interrupt is handled. Otherwise the
>> interrupt will keep coming and the tasklet/ threaded interrupt will have
>> no chance to make progress. So the box will lock up. This is often
>> overseen on fast machines because the interrupt needs a few usecs to
>> trigger and so the CPU is able to make a little bit of progress between
>> each trigger.
> 
> In addition it keeps current semantics wrt ksoftirqd, so no guarantees
> this runs in irq context in the first place.

ok, Fine.

So is it actually documented anywhere what any low-level driver should 
do in terms of masking interrupts at source for interrupt handling, i.e. 
when and where we should ever do this? I see pci.rst does mention how we 
may need this at driver removal time in "Stop IRQs on the device" 
section, but not totally related.

Thanks,
John
