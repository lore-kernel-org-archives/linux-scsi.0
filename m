Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8B3C33CA2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 18:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFD8A2077B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 18:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388440AbgAISRL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:17:11 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2247 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388436AbgAISRK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 13:17:10 -0500
Received: from lhreml706-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 04CBC5B1AC3C133F9644;
        Thu,  9 Jan 2020 18:17:09 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml706-cah.china.huawei.com (10.201.108.47) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 9 Jan 2020 18:17:08 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 9 Jan 2020
 18:17:08 +0000
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
To:     Hannes Reinecke <hare@suse.de>,
        Sumit Saxena <sumit.saxena@broadcom.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
 <339f089f-26aa-1cbe-416b-67809ea6791f@huawei.com>
 <0a39f7ec-88ec-f00c-6256-858b40efce64@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b6e34eab-175d-a965-bc18-de5ef9fae736@huawei.com>
Date:   Thu, 9 Jan 2020 18:17:07 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <0a39f7ec-88ec-f00c-6256-858b40efce64@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/01/2020 15:19, Hannes Reinecke wrote:
> On 1/9/20 12:55 PM, John Garry wrote:
>> On 09/12/2019 10:10, Sumit Saxena wrote:
>>> On Mon, Dec 2, 2019 at 9:09 PM Hannes Reinecke <hare@suse.de> wrote:
>>>>
>>>> Fusion adapters can steer completions to individual queues, and
>>>> we now have support for shared host-wide tags.
>>>> So we can enable multiqueue support for fusion adapters and
>>>> drop the hand-crafted interrupt affinity settings.
>>>
>>> Hi Hannes,
>>>
>>> Ming Lei also proposed similar changes in megaraid_sas driver some
>>> time back and it had resulted in performance drop-
>>> https://patchwork.kernel.org/patch/10969511/
>>>
>>> So, we will do some performance tests with this patch and update you.
>>>
>>
>> Hi Sumit,
>>
>> I was wondering if you had a chance to do this test yet?
>>
>> It would be good to know, so we can try to progress this work.
>>
>> @Hannes, This shared sbitmap work now seems to conflict with Jens work
>> on tag caching
>> https://lore.kernel.org/linux-block/20200107163037.31745-1-axboe@kernel.dk/T/#t,
>> but should be resolvable AFAICS (v1, anyway, which I checked). Anway, we
>> seem to have stalled, which I feared...
>>
> Thanks for the reminder.
> That was a topic I was wanting to discuss at LSF; will be sending a
> topic then.

Alright, but I am not really sure what else we need to wait months to 
discuss, unless this shared sbitmap approach is rejected and/or testing 
on other HBAs shows unsatisfactory performance.

To summarize, as I see, we have 3 topics to tackle:

- shared tags

- block hotplug improvement
	- Ming Lei had said that he will post another version of 
https://lore.kernel.org/linux-block/20191128020205.GB3277@ming.t460p/

- https://patchwork.kernel.org/cover/10967071/
	- I'm not sure what's happening on that, but thought that it was 
somewhat straightforward.

If there's something else I've missed, then let me know.

Cheers,
John
