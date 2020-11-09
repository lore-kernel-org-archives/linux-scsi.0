Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AAF5C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 08:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0D1D206ED
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 08:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgKIIt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 03:49:58 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2074 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgKIIt5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 03:49:57 -0500
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CV4Qc5N4kz67Jp4;
        Mon,  9 Nov 2020 16:48:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 9 Nov 2020 09:49:55 +0100
Received: from [10.210.172.102] (10.210.172.102) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 9 Nov 2020 08:49:53 +0000
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
To:     Qian Cai <cai@redhat.com>, Sumit Saxena <sumit.saxena@broadcom.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <don.brace@microsemi.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        <dgilbert@interlog.com>, <paolo.valente@linaro.org>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        <linux-block@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Linux SCSI List" <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        Hannes Reinecke <hare@suse.com>
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <1597850436-116171-18-git-send-email-john.garry@huawei.com>
 <fe3dff7dae4494e5a88caffbb4d877bbf472dceb.camel@redhat.com>
 <385d5408-6ba2-6bb6-52d3-b59c9aa9c5e5@huawei.com>
 <193a0440eed447209c48bda042f0e4db102355e7.camel@redhat.com>
 <519e0d58-e73e-22ce-0ddb-1be71487ba6d@huawei.com>
 <d8fd51b11d5d54e6ec7e4e9a4f7dcc83f1215cd3.camel@redhat.com>
 <d4f86cccccc3bffccc4eda39500ce1e1fee2109a.camel@redhat.com>
 <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com>
 <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
 <CAL2rwxoAAGQDud1djb3_LNvBw95YoYUGhe22FwE=hYhy7XOLSw@mail.gmail.com>
 <aaf849d38ca3cdd45151ffae9b6a99fe6f6ea280.camel@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com>
Date:   Mon, 9 Nov 2020 08:49:47 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <aaf849d38ca3cdd45151ffae9b6a99fe6f6ea280.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.172.102]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/11/2020 00:17, Qian Cai wrote:
> On Sat, 2020-11-07 at 00:55 +0530, Sumit Saxena wrote:
>> I am able to hit the boot hang and similar kind of stack traces as
>> reported by Qian with shared .config on x86 machine.
>> In my case the system boots after a hang of 40-45 mins. Qian, is it
>> true for you as well ?
> I don't know. I had never waited for that long.
> 
> .
> 

Hi Qian,

By chance do have an equivalent arm64 .config, enabling the same RH 
config options?

I suppose I could try do this myself also, but an authentic version 
would be nicer.

Thanks,
John
