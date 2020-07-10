Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D45C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 08:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBF212078B
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 08:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgGJIMJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 04:12:09 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2451 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726496AbgGJIMI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Jul 2020 04:12:08 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 05DA8F45D4E6DACBDC9E;
        Fri, 10 Jul 2020 09:12:07 +0100 (IST)
Received: from [127.0.0.1] (10.47.5.154) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 10 Jul
 2020 09:12:05 +0100
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>, <axboe@kernel.dk>,
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
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com>
 <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com>
 <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
 <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
Date:   Fri, 10 Jul 2020 09:10:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.5.154]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>
>> https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-
>> shared-tags-rfc-v8
> I tested this repo + megaraid_sas shared hosttag driver. This repo (5.8-rc)
> has CPU hotplug patch.
> " bf0beec0607d blk-mq: drain I/O when all CPUs in a hctx are offline"
> 
> Looking at description of above patch and changes, it looks like
> megaraid_sas driver can still work without shared host tag for this feature.
> 
> I observe CPU hotplug works irrespective of shared host tag

Can you be clear exactly what you mean by "irrespective of shared host tag"?

Do you mean that for your test Scsi_Host.nr_hw_queues is set to expose 
hw queues and scsi_host_template.map_queues = blk_mq_pci_map_queues(), 
but you just don't set the host_tagset flag?

  in megaraid_sas
> on 5.8-rc.
> 
> Without shared host tag, megaraid driver will expose single hctx and all the
> CPU will be mapped to hctx0.

right

> Any CPU offline event will have " blk_mq_hctx_notify_offline" callback in
> blk-mq module. If we do not have this callback/patch, we will see IO
> timeout.
> blk_mq_hctx_notify_offline callback will make sure all the outstanding on
> hctx0 is cleared and only after it is cleared, CPU will go offline.

But that is only for when the last CPU for the hctx is going offline. If 
nr_hw_queues == 1, then hctx0 would cover all CPUs, so that would never 
occur during normal operation. See initial check in 
blk_mq_hctx_notify_offline():

static int blk_mq_hctx_notify_offline(unsigned int cpu, struct 
hlist_node *node)
{
	if (!cpumask_test_cpu(cpu, hctx->cpumask) ||
	    !blk_mq_last_cpu_in_hctx(cpu, hctx))
		return 0;

> 
> megaraid_sas driver has  internal reply_queue mapping which helps to get IO
> completion on same cpu.  Driver get msix index from that table based on "
> raw_smp_processor_id".
> If table is mapped correctly at probe time,  It is not possible to pick
> entry of offline CPU.
> 
> Am I missing anything ?

Not sure, I think I need to be clear exactly what you're doing.

> 
> If you can help me to understand why we need shared host tag for CPU
> hotplug, I can try to frame some test case for possible reproduction.

I think it's best explained in cover letter for "blk-mq: Facilitate a 
shared sbitmap per tagset".

See points "HBA HW queues are required to be mapped to that of the 
blk-mq hctx", "HBA LLDD would have to generate this tag internally", and 
"blk-mq assumes the host may accept (Scsi_host.can_queue * #hw queue) 
commands".
> 
>> I just updated to include the change to have Scsi_Host.host_tagset in
>> 4291f617a02b commit ("scsi: Add host and host template flag
>> 'host_tagset'")
>>
>> megaraid sas support is not on the branch yet, but I think everything else
>> required is. And it is mutable, so I'd clone it now if I were you - or
>> just replace
>> the required patch onto your v7 branch.
> I am working on this.
> 

Great, thanks

