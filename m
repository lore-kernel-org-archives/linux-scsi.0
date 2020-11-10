Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63757C56201
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 17:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107D4207D3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 17:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgKJRm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 12:42:57 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2080 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgKJRm5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 12:42:57 -0500
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CVwCC0WCXz67KVN;
        Wed, 11 Nov 2020 01:41:27 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 10 Nov 2020 18:42:49 +0100
Received: from [10.47.88.91] (10.47.88.91) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 10 Nov
 2020 17:42:48 +0000
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
From:   John Garry <john.garry@huawei.com>
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
 <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com>
 <06a1a6bde51a66461d7b3135349641856315401d.camel@redhat.com>
 <db92d37c-28fd-4f81-7b59-8f19e9178543@huawei.com>
Message-ID: <8043d516-c041-c94b-a7d9-61bdbfef0d7e@huawei.com>
Date:   Tue, 10 Nov 2020 17:42:40 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <db92d37c-28fd-4f81-7b59-8f19e9178543@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.91]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/11/2020 14:05, John Garry wrote:
> On 09/11/2020 13:39, Qian Cai wrote:
>>> I suppose I could try do this myself also, but an authentic version
>>> would be nicer.
>> The closest one I have here is:
>> https://cailca.coding.net/public/linux/mm/git/files/master/arm64.config
>>
>> but it only selects the Thunder X2 platform and needs to manually select
>> CONFIG_MEGARAID_SAS=m to start with, but none of arm64 systems here have
>> megaraid_sas.
> 
> Thanks, I'm confident I can fix it up to get it going on my Huawei arm64 
> D06CS.
> 
> So that board has a megaraid sas card. In addition, it also has hisi_sas 
> HW, which is another storage controller which we enabled this same 
> feature which is causing the problem.
> 
> I'll report back when I can.

So I had to hack that arm64 config a bit to get it booting:
https://github.com/hisilicon/kernel-dev/commits/private-topic-sas-5.10-megaraid-hang

Boot is ok on my board without the megaraid sas card, but includes 
hisi_sas HW (which enables the equivalent option which is exposing the 
problem).

But the board with the megaraid sas boots very slowly, specifically 
around the megaraid sas probe:

: ttyS0 at MMIO 0x3f00002f8 (irq = 17, base_baud = 115200) is a 16550A
[   50.023726][    T1] printk: console [ttyS0] enabled
[   50.412597][    T1] megasas: 07.714.04.00-rc1
[   50.436614][    T5] megaraid_sas 0000:08:00.0: FW now in Ready state
[   50.450079][    T5] megaraid_sas 0000:08:00.0: 63 bit DMA mask and 63 
bit consistent mask
[   50.467811][    T5] megaraid_sas 0000:08:00.0: firmware supports msix 
        : (128)
[   50.845995][    T5] megaraid_sas 0000:08:00.0: requested/available 
msix 128/128
[   50.861476][    T5] megaraid_sas 0000:08:00.0: current msix/online 
cpus      : (128/128)
[   50.877616][    T5] megaraid_sas 0000:08:00.0: RDPQ mode     : (enabled)
[   50.891018][    T5] megaraid_sas 0000:08:00.0: Current firmware 
supports maximum commands: 4077       LDIO threshold: 0
[   51.262942][    T5] megaraid_sas 0000:08:00.0: Performance mode 
:Latency (latency index = 1)
[   51.280749][    T5] megaraid_sas 0000:08:00.0: FW supports sync cache 
        : Yes
[   51.295451][    T5] megaraid_sas 0000:08:00.0: 
megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
[   51.387474][    T5] megaraid_sas 0000:08:00.0: FW provided 
supportMaxExtLDs: 1       max_lds: 64
[   51.404931][    T5] megaraid_sas 0000:08:00.0: controller type 
: MR(2048MB)
[   51.419616][    T5] megaraid_sas 0000:08:00.0: Online Controller 
Reset(OCR)  : Enabled
[   51.436132][    T5] megaraid_sas 0000:08:00.0: Secure JBOD support 
: Yes
[   51.450265][    T5] megaraid_sas 0000:08:00.0: NVMe passthru support 
: Yes
[   51.464757][    T5] megaraid_sas 0000:08:00.0: FW provided TM 
TaskAbort/Reset timeout        : 6 secs/60 secs
[   51.484379][    T5] megaraid_sas 0000:08:00.0: JBOD sequence map 
support     : Yes
[   51.499607][    T5] megaraid_sas 0000:08:00.0: PCI Lane Margining 
support    : No
[   51.547610][    T5] megaraid_sas 0000:08:00.0: NVME page size 
: (4096)
[   51.608635][    T5] megaraid_sas 0000:08:00.0: 
megasas_enable_intr_fusion is called outbound_intr_mask:0x40000000
[   51.630285][    T5] megaraid_sas 0000:08:00.0: INIT adapter done
[   51.649854][    T5] megaraid_sas 0000:08:00.0: pci id 
: (0x1000)/(0x0016)/(0x19e5)/(0xd215)
[   51.667873][    T5] megaraid_sas 0000:08:00.0: unevenspan support    : no
[   51.681646][    T5] megaraid_sas 0000:08:00.0: firmware crash dump   : no
[   51.695596][    T5] megaraid_sas 0000:08:00.0: JBOD sequence map 
: enabled
[   51.711521][    T5] megaraid_sas 0000:08:00.0: Max firmware commands: 
4076 shared with nr_hw_queues = 127
[   51.733056][    T5] scsi host0: Avago SAS based MegaRAID driver
[   65.304363][    T5] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG 
MZ7KH1T9 404Q PQ: 0 ANSI: 6
[   65.392401][    T5] scsi 0:0:1:0: Direct-Access     ATA      SAMSUNG 
MZ7KH1T9 404Q PQ: 0 ANSI: 6
[   79.508307][    T5] scsi 0:0:65:0: Enclosure         HUAWEI 
Expander 12Gx16  131  PQ: 0 ANSI: 6
[  183.965109][   C14] random: fast init done

Notice the 14 and 104 second delays.

But does boot fully to get to the console. I'll wait for further issues, 
which you guys seem to experience after a while.

Thanks,
John
