Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7477C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 11:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 869CE20726
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 11:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfLILCe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 06:02:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:41948 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbfLILCd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Dec 2019 06:02:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E703DB17D;
        Mon,  9 Dec 2019 11:02:30 +0000 (UTC)
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <efe9c1e7-fa10-3bae-eacd-58d43295d6da@suse.de>
Date:   Mon, 9 Dec 2019 12:02:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/19 11:10 AM, Sumit Saxena wrote:
> On Mon, Dec 2, 2019 at 9:09 PM Hannes Reinecke <hare@suse.de> wrote:
>>
>> Fusion adapters can steer completions to individual queues, and
>> we now have support for shared host-wide tags.
>> So we can enable multiqueue support for fusion adapters and
>> drop the hand-crafted interrupt affinity settings.
> 
> Hi Hannes,
> 
> Ming Lei also proposed similar changes in megaraid_sas driver some
> time back and it had resulted in performance drop-
> https://patchwork.kernel.org/patch/10969511/
> 
> So, we will do some performance tests with this patch and update you.
> Thank you.

I'm aware of the results of Ming Leis work, but I do hope this patchset 
performs better.

And when you do performance measurements, can you please run with both, 
'none' I/O scheduler and 'mq-deadline' I/O scheduler?
I've measured quite a performance improvements when using mq-deadline, 
up to the point where I've gotten on-par performance with the original, 
non-mq, implementation.
(As a data point, on my setup I've measured about 270k IOPS and 1092 
MB/s througput, running on just 2 SSDs).

But thanks for doing a performance test here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
