Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A907C54FD0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 12:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB7A2075E
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 12:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgDUMgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 08:36:25 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2074 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbgDUMgY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 08:36:24 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id DF542E28DE2A9FBAF320;
        Tue, 21 Apr 2020 13:36:22 +0100 (IST)
Received: from [127.0.0.1] (10.210.168.25) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 21 Apr
 2020 13:36:21 +0100
Subject: Re: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to MQ
To:     Kashyap Desai <kashyap.desai@broadcom.com>, <axboe@kernel.dk>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.de>,
        <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>, <hch@infradead.org>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <chenxiang66@hisilicon.com>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        Hannes Reinecke <hare@suse.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-9-git-send-email-john.garry@huawei.com>
 <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com>
 <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
 <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com>
 <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
 <7b8c79b0453722023c6c7d53cd24441d@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b759a8ed-09ba-bfe8-8916-c05ab9671cbf@huawei.com>
Date:   Tue, 21 Apr 2020 13:35:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <7b8c79b0453722023c6c7d53cd24441d@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.25]
X-ClientProxiedBy: lhreml719-chm.china.huawei.com (10.201.108.70) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/04/2020 18:47, Kashyap Desai wrote:
>> ther info, like IRQ-CPU affinity dump and controller PCI
>> vendor+device ID? Also /proc/interrupts info would be good after a run,
>> like supplied by Sumit here:
>>
>> https://lore.kernel.org/linux-
>> scsi/CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-
>> L=g@mail.gmail.com/
> Controller performance mode is = IOPs which will create 8 extra reply
> queues.
> In this case it is 72 online CPU + 8 = 80 reply queue (MSIx) driver will
> create.
> 
> First 8 vectors are non-managed and they are mapped to local numa node -1.
> 
> Here is IRQ-CPU affinity -
> 
> irq 256, cpu list 18-35,54-71
> irq 257, cpu list 18-35,54-71
> irq 258, cpu list 18-35,54-71
> irq 259, cpu list 18-35,54-71
> irq 260, cpu list 18-35,54-71
> irq 261, cpu list 18-35,54-71
> irq 262, cpu list 18-35,54-71
> irq 263, cpu list 18-35,54-71
> irq 264, cpu list 18
> irq 265, cpu list 19
> irq 266, cpu list 20
> irq 267, cpu list 21
> irq 268, cpu list 22
> irq 269, cpu list 23
> irq 270, cpu list 24
> irq 271, cpu list 25
> irq 272, cpu list 26
> irq 273, cpu list 27
> irq 274, cpu list 28
> irq 275, cpu list 29
> irq 276, cpu list 30
> irq 277, cpu list 31
> irq 278, cpu list 32
> irq 279, cpu list 33
> irq 280, cpu list 34
> irq 281, cpu list 35
> irq 282, cpu list 54
> irq 283, cpu list 55
> irq 284, cpu list 56
> irq 285, cpu list 57
> irq 286, cpu list 58
> irq 287, cpu list 59
> irq 288, cpu list 60
> irq 289, cpu list 61
> irq 290, cpu list 62
> irq 291, cpu list 63
> irq 292, cpu list 64
> irq 293, cpu list 65
> irq 294, cpu list 66
> irq 295, cpu list 67
> irq 296, cpu list 68
> irq 297, cpu list 69
> irq 298, cpu list 70
> irq 299, cpu list 71
> irq 300, cpu list 0
> irq 301, cpu list 1
> irq 302, cpu list 2
> irq 303, cpu list 3
> irq 304, cpu list 4
> irq 305, cpu list 5
> irq 306, cpu list 6
> irq 307, cpu list 7
> irq 308, cpu list 8
> irq 309, cpu list 9
> irq 310, cpu list 10
> irq 311, cpu list 11
> irq 312, cpu list 12
> irq 313, cpu list 13
> irq 314, cpu list 14
> irq 315, cpu list 15
> irq 316, cpu list 16
> irq 317, cpu list 17
> irq 318, cpu list 36
> irq 319, cpu list 37
> irq 320, cpu list 38
> irq 321, cpu list 39
> irq 322, cpu list 40
> irq 323, cpu list 41
> irq 324, cpu list 42
> irq 325, cpu list 43
> irq 326, cpu list 44
> irq 327, cpu list 45
> irq 328, cpu list 46
> irq 329, cpu list 47
> irq 330, cpu list 48
> irq 331, cpu list 49
> irq 332, cpu list 50
> irq 333, cpu list 51
> irq 334, cpu list 52
> irq 335, cpu list 53
> 
>> Are you enabling some special driver perf mode?
>>

ok, thanks.

So I tested this on hisi_sas with x12 SAS SSDs, and performance with 
"mq-deadline" is comparable with "none" @ ~ 2M IOPs. But after a while 
performance drops alot, to maybe 700K IOPS. Do you have a similar 
experience?

Anyway, I'll have a look.

Thanks,
John
