Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1DAC10F25
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 07:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02932206B7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 07:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgCKHvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 03:51:24 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2548 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726472AbgCKHvY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 03:51:24 -0400
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 918DD3A2C4A2B82EA899;
        Wed, 11 Mar 2020 07:51:21 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 11 Mar 2020 07:51:21 +0000
Received: from [127.0.0.1] (10.210.172.48) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5; Wed, 11 Mar
 2020 07:51:19 +0000
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
 <7bc94a9f-ec86-b343-0951-eba548c71b67@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <f9cd5ffc-4246-3815-d6ab-9d4f7535bcb8@huawei.com>
Date:   Wed, 11 Mar 2020 07:51:18 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <7bc94a9f-ec86-b343-0951-eba548c71b67@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.172.48]
X-ClientProxiedBy: lhreml707-chm.china.huawei.com (10.201.108.56) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/03/2020 06:58, Hannes Reinecke wrote:
> On 3/11/20 7:22 AM, Christoph Hellwig wrote:
>> On Tue, Mar 10, 2020 at 09:08:56PM +0000, John Garry wrote:
>>> On 10/03/2020 18:32, Christoph Hellwig wrote:
>>>> On Wed, Mar 11, 2020 at 12:25:28AM +0800, John Garry wrote:
>>>>> From: Hannes Reinecke <hare@suse.com>
>>>>>
>>>>> Allocate a separate 'reserved_cmd_q' for sending reserved commands.
>>>>
>>>> Why?  Reserved command specifically are not in any way tied to queues.
>>>> .
>>>>
>>>
>>> So the v1 series used a combination of the sdev queue and the per-host
>>> reserved_cmd_q. Back then you questioned using the sdev queue for virtio
>>> scsi, and the unconfirmed conclusion was to use a common per-host q. This is
>>> the best link I can find now:
>>>
>>> https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg83177.html
>>
>> That was just a question on why virtio uses the per-device tags, which
>> didn't look like it made any sense.  What I'm worried about here is
>> mixing up the concept of reserved tags in the tagset, and queues to use
>> them.  Note that we already have the scsi_get_host_dev to allocate
>> a scsi_device and thus a request_queue for the host itself.  That seems
>> like the better interface to use a tag for a host wide command vs
>> introducing a parallel path.
>>
> Ah. Right.
> Will be looking into that, and convert the patchset over to it.
> 

Hannes,

I assume that you will take back over this series now. Let me know. The 
patches are here, if not in patchwork:
https://github.com/hisilicon/kernel-dev/tree/private-topic-sas-5.6-resv-commands-v2

> And the problem of the separate queue is the fact that I'll need a queue
> to reserve tags from; trying to allocate a tag directly from the bitmap
> turns out to be major surgery in the blocklayer with no immediate gain.
> And I can't use per-device queues as for some drivers the reserved
> commands are used to query the HBA itself to figure out how many devices
> are present.

Right, we still need to be able to allocate somewhere apart from sdev queue

> 


Thanks
