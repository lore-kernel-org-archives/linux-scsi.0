Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78750C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 16:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241963AbhKXQZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 11:25:51 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4160 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348612AbhKXQZ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2021 11:25:27 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HzmQP1w4kz67Ppd;
        Thu, 25 Nov 2021 00:18:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 17:22:15 +0100
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 16:22:14 +0000
Subject: Re: [issue report] pm8001 driver crashes with IOMMU enabled
To:     Jinpu Wang <jinpu.wang@ionos.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ajish Koshy <Ajish.Koshy@microchip.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
Date:   Wed, 24 Nov 2021 16:22:12 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml721-chm.china.huawei.com (10.201.108.72) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/11/2021 12:43, Jinpu Wang wrote:
>> I notice that the driver is calling virt_to_phys() on a dma_addr_t,
>> which is broken:
> phys_to_virt you meant.

Right

>> static int pm80xx_chip_smp_req(struct pm8001_hba_info *pm8001_ha,
>> struct pm8001_ccb_info *ccb)
>> {
>> char *preq_dma_addr = NULL;
>> __le64 tmp_addr;
>>
>> tmp_addr = cpu_to_le64((u64)sg_dma_address(&task->smp_task.smp_req));
>> preq_dma_addr = (char *)phys_to_virt(tmp_addr);
>>
> The code was there since the initial support in 2013.
> f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware
> functionalities and relevant changes in common files")
> 
>> How is this supposed to work? I assume that someone has enabled the
>> IOMMU on a system with one of these cards before.

One thing to note is that a long time ago I had to fix libsas for broken 
DMA API usage which was exposed when the IOMMU enabled, which also seems 
strange not to be noticed then.

See commit 9702c67c6066 ("scsi: libsas: fix ata xfer length")

> I guess it's due to the unaligned access to memory on ARM? AFAIK most
> of the user are on x86_64.

I doubt it, especially since !IOMMU seems ok.

>> I have encountered some other RAID cards which bypasses the IOMMU to
>> access host memory - is that the case here potentially?
> I don't know, maybe guys from microchip can answer.

Hopefully.

Thanks,
John

