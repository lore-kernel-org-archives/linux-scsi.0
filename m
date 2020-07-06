Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758F7C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D1CF20724
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 09:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgGFJ15 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 05:27:57 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2427 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728381AbgGFJ15 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Jul 2020 05:27:57 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id B9B9B6DFF9351258C0FA;
        Mon,  6 Jul 2020 10:27:55 +0100 (IST)
Received: from [127.0.0.1] (10.47.1.142) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 6 Jul 2020
 10:27:53 +0100
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Hannes Reinecke <hare@suse.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com>
 <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <b63d200f-9221-ceff-f32c-342fdbd21555@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <fd06b790-8f3d-50d0-f9e8-563f4650e90f@huawei.com>
Date:   Mon, 6 Jul 2020 10:26:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <b63d200f-9221-ceff-f32c-342fdbd21555@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.1.142]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/07/2020 09:45, Hannes Reinecke wrote:
> Originally I thought it would help for CPU hotplug, too, but typically
> the internal commands are not bound to any specific CPU, 

When we alloc the request in scsi_get_internal_cmd() - > 
blk_mq_alloc_request() -> __blk_mq_alloc_request(), the request will 
have an associated hctx.

As such, I would expect the LLDD to honor this, in that it should use 
the hwq associated with the hctx to send/receive the command.

And from that, the hwq managed interrupt should not be shut down until 
the queue is drained, including internal commands.

Is there something wrong with this idea?

Thanks,
John

> so they
> typically will not accounted for when looking at the CPU-related resources.
> But that depends on the driver etc, so it's hard to give a guideline.

