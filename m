Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304EBC2BA2B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 15:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11C352074F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 15:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgDGPUB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 11:20:01 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2638 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728917AbgDGPUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Apr 2020 11:20:01 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 5EA12238EC4E6DA72243;
        Tue,  7 Apr 2020 16:19:59 +0100 (IST)
Received: from [127.0.0.1] (10.210.168.238) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 7 Apr 2020
 16:19:57 +0100
Subject: Re: [PATCH RFC v2 02/24] scsi: allocate separate queue for reserved
 commands
To:     Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@infradead.org>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-3-git-send-email-john.garry@huawei.com>
 <20200310183243.GA14549@infradead.org>
 <79cf4341-f2a2-dcc9-be0d-2efc6e83028a@huawei.com>
 <20200311062228.GA13522@infradead.org>
 <b5a63725-722b-8ccd-3867-6db192a248a4@suse.de>
 <9c6ced82-b3f1-9724-b85e-d58827f1a4a4@huawei.com>
 <39bc2d82-2676-e329-5d32-8acb99b0a204@suse.de>
 <20ebe296-9e57-b3e3-21b3-63a09ce86036@huawei.com>
 <dcfba0ea-4ba5-4e4f-150d-24bd4fe11cdd@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <38c1592d-c90a-d6ca-1e7e-e8cc665aaf22@huawei.com>
Date:   Tue, 7 Apr 2020 16:19:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <dcfba0ea-4ba5-4e4f-150d-24bd4fe11cdd@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.238]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>>>
>>
>> FWIW, the only other driver (gdth) which I see uses this API has 
>> this_id = -1 in the scsi host template.
>>
>>> But alright, I'll give it a go; let's see what I'll end up with.
>>
>> note: If we want a fixed scsi_device per host, calling 
>> scsi_mq_setup_tags() -> scsi_get_host_dev() will fail as shost state 
>> is not running. Maybe we need to juggle some things there to provide a 
>> generic solution.
>>
> It might even get worse, as during device setup things like 
> 'slave_alloc' etc is getting called, which has a fair chance of getting 
> confused for non-existing devices.
> Cf qla2xxx:qla2xx_slave_alloc() is calling starget_to_rport(), which 
> will get us a nice oops when accessing a target which is _not_ the child 
> of a fc remote port.

Yes, something similar happens for libsas [hence my hack], where 
sas_alloc_target()->sas_find_dev_by_rphy() fails as it cannot handle 
rphy for scsi host as parent properly.

> And this is why I'm not utterly keen on this approach; auditing all 
> these callbacks is _not_ fun.
> 

Understood. And if you can't test them, then a change like this is too 
risky for those drivers.

Cheers,
John
