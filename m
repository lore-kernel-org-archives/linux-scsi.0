Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387CBC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 08:11:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DC8C207DE
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 08:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgHKIL4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 04:11:56 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2591 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728000AbgHKIL4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Aug 2020 04:11:56 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id C21AA217929DB03DA386;
        Tue, 11 Aug 2020 09:11:54 +0100 (IST)
Received: from [127.0.0.1] (10.210.168.126) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 11 Aug
 2020 09:11:53 +0100
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>, <bvanassche@acm.org>,
        <hare@suse.com>, <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
References: <20200729153648.GA1698748@T590>
 <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
 <20200804083625.GA1958244@T590>
 <afe5eb1be7f416a48d7b5d473f3053d0@mail.gmail.com>
 <20200805084031.GA1995289@T590>
 <5adffdf805179428bdd0dd6c293a4f7d@mail.gmail.com>
 <20200806133819.GA2046861@T590>
 <f1ac35dfca34193e6c9bcedbc11911d2@mail.gmail.com>
 <20200806152939.GA2062348@T590>
 <3f35b0f67c73c8c4996fdad80eb6d963@mail.gmail.com>
 <20200809021633.GA2134904@T590>
 <6f8790811e7a3238f2b0fa35fbb816bc@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2e6e63f0-2a05-c29a-e534-3ecf06eff688@huawei.com>
Date:   Tue, 11 Aug 2020 09:09:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <6f8790811e7a3238f2b0fa35fbb816bc@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.126]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/08/2020 17:38, Kashyap Desai wrote:
> 
> Functional Test -
> 
> I cover overnight IO testing using <fio> script which sends 4K rand read,
> read, rand write and write IOs to the 24 SAS JBOD drives.
> Some of the JBOD has ioscheduler=none and some of the JBOD has
> ioscheduler=mq-deadline
> I used additional script which change sdev->queue_depth of each device
> from 2 to 16 range at the interval of 5 seconds.
> I used additional script which toggle "rq_affinity=1" and "rq_affinity=2"
> at the interval of 5 seconds.
> 
> I did not noticed any IO hang.
> 
> Thanks, Kashyap
> 

Nice work. I think v8 series can now be prepared, since this final 
performance issue reported looks resolved. But I still don't know what's 
going on for "[PATCHv6 00/21] scsi: enable reserved commands for LLDDs", 
which current hpsa patch relies on for basic functionality :(

>>
>>  From 06993ddf5c5dbe0e772cc38342919eb61a57bc50 Mon Sep 17 00:00:00
>> 2001
>> From: Ming Lei<ming.lei@redhat.com>
>> Date: Wed, 5 Aug 2020 16:35:53 +0800
>> Subject: [PATCH] scsi: core: only re-run queue in scsi_end_request() if
> device
>> queue is busy

Ming, I assume that you will send this directly to SCSI maintainers when 
the merge window closes.

>>
>> Now the request queue is run in scsi_end_request() unconditionally if
> both
>> target queue and host queue is ready. We should have re-run request
> queue
>> only after this device queue becomes busy for restarting this LUN only.
>>
>> Recently Long Li reported that cost of run queue may be very heavy in
> case of
>> high queue depth. So improve this situation by only running the request
> queue
>> when this LUN is busy.

