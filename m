Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F185CC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC8B4207D0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388788AbgF2UGM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:06:12 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2408 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388556AbgF2UGK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 16:06:10 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id E79B67DFD74948BB7481;
        Mon, 29 Jun 2020 17:19:59 +0100 (IST)
Received: from [127.0.0.1] (10.210.170.8) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 29 Jun
 2020 17:19:58 +0100
Subject: Re: [PATCH RFC v7 02/12] blk-mq: rename blk_mq_update_tag_set_depth()
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>, <bvanassche@acm.org>,
        <hare@suse.com>, <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-3-git-send-email-john.garry@huawei.com>
 <20200611025759.GA453671@T590>
 <6ef76cdf-2fb3-0ce8-5b5a-0d7af0145901@huawei.com>
 <8ef58912-d480-a7e1-f04c-da9bd85ea0ae@huawei.com>
 <eaf188d5-dac0-da44-1c83-31ff2860d8fa@suse.de>
 <e42da0e714c808c80e9a055f3f065e44@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <634f1564-6404-a5b9-0b27-b96b7df8df12@huawei.com>
Date:   Mon, 29 Jun 2020 17:18:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <e42da0e714c808c80e9a055f3f065e44@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.170.8]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/06/2020 09:13, Kashyap Desai wrote:
>>> Hi Hannes,
>>>
>>> Do you have any issue with splitting the undocumented changes into
>>> another patch as so:
>>>
>> No, that's perfectly fine.
>>
>> Kashyap, I've also attached an updated patch for the elevator_count patch;
>> if
>> you agree John can include it in the next version.

ok, but I need to check it myself.

> Hannes - Patch looks good.   Header does not include problem statement. How
> about adding below in header ?
> 
> High CPU utilization on "native_queued_spin_lock_slowpath" due to lock
> contention is possible in mq-deadline and bfq io scheduler when nr_hw_queues
> is more than one.
> It is because kblockd work queue can submit IO from all online CPUs (through
> blk_mq_run_hw_queues) even though only one hctx has pending commands.
> Elevator callback "has_work" for mq-deadline and bfq scheduler consider
> pending work if there are any IOs on request queue and it does not account
> hctx context.
> 
> I have not seen performance drop after this patch, but I will continue
> further testing.
> 
> John - One more thing, I am working on megaraid_sas driver to provide both
> host_tagset = 1 and 0 option through module parameter.

I was hoping that we wouldn't have this, and have host_tagset = 1 
always. Or maybe host_tagset = 1 by default, and allow module param to 
set = 0. Your choice, though.

Thanks,
John

