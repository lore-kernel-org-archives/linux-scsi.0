Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C82C3F2D1
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 09:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FFB72073D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 09:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgCDJjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:39:21 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2507 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728953AbgCDJjU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Mar 2020 04:39:20 -0500
Received: from lhreml701-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 1DA68866E4B2B3F597A6;
        Wed,  4 Mar 2020 09:39:19 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml701-cah.china.huawei.com (10.201.108.42) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 4 Mar 2020 09:39:18 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 4 Mar 2020
 09:39:15 +0000
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
 <aa0d2c4c-b54b-8d68-1a18-d7449f46962b@huawei.com>
 <CAL2rwxrS8Ebud0ZYwC6vcGi0Pv-PA12s-mHdJfkGaEmkqRDVDA@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <46c35a02-2223-dd1b-2acc-6deeab478886@huawei.com>
Date:   Wed, 4 Mar 2020 09:39:13 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAL2rwxrS8Ebud0ZYwC6vcGi0Pv-PA12s-mHdJfkGaEmkqRDVDA@mail.gmail.com>
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

>>
>> OK, I have a rough idea of the concept. And again I'd say megaraid sas
>> may not be a good candidate to expose > 1 HW queues, as we hide HW
>> queues and don't maintain the symmetry with blk-mq layer.
> Sorry, my last response was not very clear. I was referring to reply
> queues as HW queues
> not submission queues. I agree with you, since megaraid_sas HW has
> single submission
> queue so >1 HW queue would not help to improve performance. Testing
> done by us on shared
> tagset patches worked by you/Hannes was to ensure no performance drop
> from single HW
> submission queue based driver.

OK, but I still have concern with this. That's your choice.

>>
>> Indeed, I do not even expect a performance increase in exposing > 1 HW
>> queues since the driver already uses the reply map + managed interrupts.
>>
>> The main reason for that change in some drivers - apart from losing the
>> duplicated ugliness of the reply map - is to leverage the blk-mq feature
>> to drain a hctx for CPU hotplug [0] - is this something which megaraid
>> sas is vulnerable to and would benefit from?
> "megaraid_sas" driver would be benefited with draining of IO
> completions directed to
> hotplugged(offlined) CPU. With current driver IO completion would
> hang, if CPU on which IO is to be
> completed goes offline.

But that feature will only work for the queues which you expose. For the 
low-latency queues, there would be no draining*. However, the 
low-latency interrupts are not managed; as such, I think that their 
interrupts would migrate when their cpumask goes offline, rather than 
being shutdown, so not vulnerable to this problem.

* In principle, since you can submit the scsi request on different hw 
queue than expected from blk-mq perspective, when we offline the cpu 
which blk-mq set to submit on, blk-mq may actually wait for requests to 
complete on these low-latency queues and addition to the HW queue which 
blk-mq thought that the request would be submitted on - again, not 
ideal, and may cause problems.

Thanks,
John
