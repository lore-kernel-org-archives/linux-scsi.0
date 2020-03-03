Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753D2C3F2C6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 11:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5519E2086A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 11:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgCCLxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Mar 2020 06:53:34 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2503 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729032AbgCCLxe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Mar 2020 06:53:34 -0500
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 307A0BC06ED2D4470BDE;
        Tue,  3 Mar 2020 11:53:33 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML712-CAH.china.huawei.com (10.201.108.35) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 3 Mar 2020 11:53:32 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 3 Mar 2020
 11:53:32 +0000
Subject: Re: [PATCH v2 10/11] megaraid_sas: Use Block layer API to check SCSI
 device in-flight IO requests
To:     Sumit Saxena <sumit.saxena@broadcom.com>
CC:     Hannes Reinecke <hare@suse.de>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Bart Van Assche" <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
 <1579000882-20246-11-git-send-email-anand.lodnoor@broadcom.com>
 <7ca1562c-7a7a-17c5-2429-9725d465a4a8@suse.de>
 <b5ab348d98b790578325140226f741c8@mail.gmail.com>
 <d7119a15-8be8-9fb2-3c50-8b0a6605982d@huawei.com>
 <CAAO+jF-P3MkB2mo6pmYH1ihjRGpfjkkgXZg9dAZ29nYmU6T2=A@mail.gmail.com>
 <93deab34-53a3-afcf-4862-6b168a9f60cc@huawei.com>
 <79fe7843-9d71-bdde-957c-32dde22437d9@suse.de>
 <5ac6fd4f-eef8-700b-89d2-c8b3cd6e12ca@huawei.com>
 <CAL2rwxqfo1_Wnea=4xb1K+OQTQ4aMd0GjOQG9tkc+E7V-5toqw@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <aa0d2c4c-b54b-8d68-1a18-d7449f46962b@huawei.com>
Date:   Tue, 3 Mar 2020 11:53:31 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAL2rwxqfo1_Wnea=4xb1K+OQTQ4aMd0GjOQG9tkc+E7V-5toqw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> And for these low-latency queues, I figure that the issue is not just
>> polling vs interrupt, but indeed how fast the HW queue can consume SQEs.
>> A HW queue may only be able to consume at a limited rate - that's why we
>> segregate.
> Yes, there is no polling in any of HW queues. High IOPs queues have
> interrupt coalescing enabled whereas
> low latency queues does not have interrupt coalescing. megaraid_sas
> driver would choose which set of queues	
> among these two has to be used depending on workload. For latency
> oriented workload, driver would use low
> latency queues and for IOPs profile, driver would use High IOPs queues.
>>
>> As an aside, that is actually an issue for blk-mq. For 1 to many HW
>> queue-to-CPU mapping, limiting many CPUs a single queue can limit IOPs
>> since HW queues can only consume at a limited rate.
> We were able to achieve performance target for MegaRAID latest gen
> controller with this model of few set
>   of HW queues mapped to local numa CPUs and low latency queues has one
> to one mapping to CPUs.
> This is default behavior of queues segregation in megaraid_sas driver
> to satisfy our IOPs and latency requirements altogether.
> However we have given module parameter- "perf_mode" to tune queues
> behavior. i.e turning on/off interrupt
> coalescing on all HW queues where this one to many queues to CPU
> mapping would not happen.

Hi Sumit,

OK, I have a rough idea of the concept. And again I'd say megaraid sas 
may not be a good candidate to expose > 1 HW queues, as we hide HW 
queues and don't maintain the symmetry with blk-mq layer.

Indeed, I do not even expect a performance increase in exposing > 1 HW 
queues since the driver already uses the reply map + managed interrupts.

The main reason for that change in some drivers - apart from losing the 
duplicated ugliness of the reply map - is to leverage the blk-mq feature 
to drain a hctx for CPU hotplug [0] - is this something which megaraid 
sas is vulnerable to and would benefit from?

Thanks,
John

[0] 
https://lore.kernel.org/linux-block/20200115114409.28895-1-ming.lei@redhat.com/
