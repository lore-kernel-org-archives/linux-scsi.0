Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA047C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 08:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CCF20663
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 08:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbfHMIbV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 04:31:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727784AbfHMIbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 04:31:20 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1687FFF1F082E568E156;
        Tue, 13 Aug 2019 16:31:15 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.238) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 13 Aug 2019
 16:31:03 +0800
Subject: Re: [PATCH 0/9] blk-mq/scsi: convert private reply queue into blk_mq
 hw queue
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20190531022801.10003-1-ming.lei@redhat.com>
 <d1c786d8-d3a9-551b-52fb-fe6f7805e50e@huawei.com>
CC:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Don Brace <don.brace@microsemi.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Sathya Prakash" <sathya.prakash@broadcom.com>,
        Christoph Hellwig <hch@lst.de>,
        chenxiang <chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b862dfc7-dfcf-1986-8f18-75ae7f02510c@huawei.com>
Date:   Tue, 13 Aug 2019 09:30:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <d1c786d8-d3a9-551b-52fb-fe6f7805e50e@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.238]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/06/2019 09:49, John Garry wrote:
> On 31/05/2019 03:27, Ming Lei wrote:
>> Hi,


Hi Ming,

I'm raising the hostwide tags issue again, which I brought up in 
https://www.spinics.net/lists/linux-block/msg43754.html

Here's that discussion:

 >> I don't mean to hijack this thread, but JFYI we're getting around to 
test
 >> https://github.com/ming1/linux/commits/v5.2-rc-host-tags-V2 - 
unfortunately
 >> we're still seeing a performance regression. I can't see where it's 
coming
 >> from. We're double-checking the test though.
 >
 > host-tag patchset is only for several particular drivers which use
 > private reply queue as completion queue.
 >
 > This patchset is for handling generic blk-mq CPU hotplug issue, and
 > the several particular scsi drivers(hisi_sas_v3, hpsa, megaraid_sas and
 > mp3sas) won't be covered so far.
 >
 > I'd suggest to move on for generic blk-mq devices first given now blk-mq
 > is the only request IO path now.
 >
 > There are at least two choices for us to handle drivers/devices with
 > private completion queue:
 >
 > 1) host-tags
 > - performance issue shouldn't be hard to solve, given it is same with
 > with single tags in theory, and just corner cases is there.
 >
 > What I am not glad with this approach is that blk-mq-tag code becomes 
mess.

Right, not so neat. And we see a 3M vs 2.4M IOPS drop with this 
patchset. That's without any optimisation like discussed in 
https://lkml.org/lkml/2019/8/10/124

And I don't know about any impact of performance of hosts which already 
exposed multiple queues.

Note that it's still much better than the 700K IOPS we see without 
managed interrupts at all.

 >
 > 2) private callback
 > - we could define private callback to drain each completion queue in
 >   driver simply.

Yeah, but then we raise the question of why the LLDD can't just register 
for hotplug handler itself.

Personally I prefer #1. I'll have a look at the issues when I get a chance.

Much appreciated,
John



