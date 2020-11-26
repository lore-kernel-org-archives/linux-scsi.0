Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B7EFC56202
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 16:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AC7D221EB
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 16:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391564AbgKZQwt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 11:52:49 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2167 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390599AbgKZQws (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 11:52:48 -0500
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ChkKB3rfbz67J6L;
        Fri, 27 Nov 2020 00:50:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 26 Nov 2020 17:52:47 +0100
Received: from [10.210.172.213] (10.210.172.213) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.1913.5; Thu, 26 Nov 2020 16:52:45 +0000
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
From:   John Garry <john.garry@huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <rafael@kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>, <linuxarm@huawei.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <87ft57r7v3.fsf@nanos.tec.linutronix.de>
 <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com>
 <874klmqu2r.fsf@nanos.tec.linutronix.de>
 <b86af904-2288-8b53-7e99-e763b73987d0@huawei.com>
 <87lfexp6am.fsf@nanos.tec.linutronix.de>
 <3acb7fde-eae2-a223-9cfd-f409cc2abba6@huawei.com>
 <873615oy8a.fsf@nanos.tec.linutronix.de>
 <4aab9d3b-6ca6-01c5-f840-459f945c7577@huawei.com>
 <87sg91ik9e.wl-maz@kernel.org>
 <0edc9a11-0b92-537f-1790-6b4b6de4900d@huawei.com>
 <afd97dd4b1e102ac9ad49800821231a4@kernel.org>
 <5a314713-c1ee-2d34-bee1-60beae274742@huawei.com>
 <0525a4bcf17a355cd141632d4f3714be@kernel.org>
 <702e1729-9a4b-b16f-6a58-33172b1a3220@huawei.com>
 <5a588f5d86010602ff9a90e8f057743c@kernel.org>
 <80e0a19b-3291-1304-1a5b-0445c49efe31@huawei.com>
 <d696d314514a4bd53c85f2da73a23eed@kernel.org>
 <e96dd9b0-c3a7-f7fb-0317-2fc2107f405a@huawei.com>
Message-ID: <696c04a9-8c13-0fec-08c4-068d4dd5ba67@huawei.com>
Date:   Thu, 26 Nov 2020 16:52:22 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <e96dd9b0-c3a7-f7fb-0317-2fc2107f405a@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.172.213]
X-ClientProxiedBy: lhreml707-chm.china.huawei.com (10.201.108.56) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Marc,

>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=irq/hacks 
> 
> 
> ok, I'll have a look

I tried that and it doesn't look to work.

I find that for the its_msi_prepare() call, its_dev->shared does not get 
set, as MSI_ALLOC_FLAGS_SHARED_DEVICE is not set in info->flags.

If I understand the code correctly, MSI_ALLOC_FLAGS_SHARED_DEVICE is 
supposed to be set in info->flags in platform_msi_set_desc(), but this 
is called per-msi after its_msi_prepare(), so we don't the flags set at 
the right time. That's how it looks to me...

Cheers,
John
