Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355BAC433E8
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 10:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DCEF22200
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 10:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgGNKym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:54:42 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2475 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726766AbgGNKym (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 06:54:42 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 1DDF1E633BEEA8E59113;
        Tue, 14 Jul 2020 11:54:40 +0100 (IST)
Received: from [127.0.0.1] (10.47.10.169) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 14 Jul
 2020 11:54:38 +0100
Subject: Re: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
To:     Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
CC:     <don.brace@microsemi.com>, <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>, <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
 <20200714080631.GA600766@T590>
 <3584bcc3-830a-d50d-bb55-8ac0b686cdc0@huawei.com>
 <799af415-cb02-278e-1af2-c6179a94a8a8@suse.de> <20200714104437.GB602708@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2da0e06c-f6b5-ee5a-1806-e5356ccf8841@huawei.com>
Date:   Tue, 14 Jul 2020 11:52:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200714104437.GB602708@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.10.169]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> In my machine, there are 32 queues(32 cpu cores), each queue has 1013
> tags, so there can be 32*1013 requests coming from block layer, meantime
> smartpqi can only handles 1013 requests. I guess it isn't hard to
> trigger softlock by running heavy/concurrent smartpqi IO.

Since pqi_alloc_io_request() does not use spinlock, disable preemption, 
etc., so I guess that there is more of a chance of simply IO timeout.

But I see in pqi_get_physical_disk_info() that there is some 
intelligence to set the queue depth, which may reduce chance of timeout 
(by reducing disk queue depth). Not sure.

> 
>>
>> And the point of this patchset is exactly that the block layer will only
>> send up to 'can_queue' requests, irrespective on how many hardware
>> queues are present.
> 
> That is only true for shared tags.
> 

Thanks,
John

