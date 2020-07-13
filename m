Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EE8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D22B20758
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgGMIo2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:44:28 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2453 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725830AbgGMIo1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 04:44:27 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id BC0F5B83E6F9ECA54EDD;
        Mon, 13 Jul 2020 09:44:26 +0100 (IST)
Received: from [127.0.0.1] (10.47.2.10) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 13 Jul
 2020 09:44:25 +0100
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
 <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
Date:   Mon, 13 Jul 2020 09:42:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <34a832717fef4702b143ea21aa12b79e@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.2.10]
X-ClientProxiedBy: lhreml739-chm.china.huawei.com (10.201.108.189) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/07/2020 08:55, Kashyap Desai wrote:
>> ring normal operation. See initial check in
>> blk_mq_hctx_notify_offline():
>>
>> static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node
>> *node) {
>> 	if (!cpumask_test_cpu(cpu, hctx->cpumask) ||
>> 	    !blk_mq_last_cpu_in_hctx(cpu, hctx))
>> 		return 0;
>>
> Thanks John for this pointer. I missed this part and now I understood what
> was happening in my testing.

JFYI, I always have this as a sanity check for my testing:

void irq_shutdown(struct irq_desc *desc)
{
+	pr_err("%s irq%d\n", __func__, desc->irq_data.irq);
+
	if (irqd_is_started(&desc->irq_data)) {
		desc->depth = 1;
		if (desc->irq_data.chip->irq_shutdown) {

> There were more than one CPU mapped to one msix index in my earlier testing
> and because of that I could see Interrupt migration happens on available CPU
> from affinity mask. So my earlier testing was incorrect.
> 
> Now I am consistently able to reproduce issue - Best setup is have 1:1
> mapping of CPU to MSIX vector mapping. I used 128 logical CPU and 128 msix
> vectors and I noticed IO timeout without this RFC (without host_tagset).
> I did not noticed IO timeout with RFC (with host_tagset.) I will update this
> data in Driver's commit message.

ok, great. That's what we want. I'm not sure exactly what your test 
consists of, though.

> 
> Just for my understanding -
> What if we have below code in blk_mq_hctx_notify_offline, CPU hotplug should
> work for megaraid_sas driver without this RFC (without shared host tagset).
> Right ?

> If answer is yes, will there be any side effect of having below code in
> block layer ?
> 

Sorry, I'm sure sure what you're getting at with this change, below.

It seems that you're trying to drain hctx0 (which is your only hctx, as 
nr_hw_queues = 0 without this patchset) and set it inactive whenever any 
CPU is offlined. If so, that's not right.

> static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node
>   *node) {
>   	if (hctx->queue->nr_hw_queues > 1
> 	    && (!cpumask_test_cpu(cpu, hctx->cpumask) ||
>   	    !blk_mq_last_cpu_in_hctx(cpu, hctx)))
>   		return 0;
> 
> I also noticed nr_hw_queues are now exposed in sysfs -
> 
> /sys/devices/pci0000:85/0000:85:00.0/0000:86:00.0/0000:87:04.0/0000:8b:00.0/0000:8c:00.0/0000:8d:00.0/host14/scsi_host/host14/nr_hw_queues:128
> .

That's on my v8 wip branch, so I guess you're picking it up from there.

Thanks,
John
