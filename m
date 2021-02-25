Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359FAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 02:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3D9A64ED1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 02:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbhBYCiM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 21:38:12 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12646 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbhBYCiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 21:38:11 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DmH2v6nBLz16CR4;
        Thu, 25 Feb 2021 10:35:51 +0800 (CST)
Received: from [127.0.0.1] (10.40.192.162) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Feb 2021
 10:37:26 +0800
Subject: Re: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <CAMuHMdXwmjq_MPr=R9twkYRoun2buuSrPDbLo6zdkGFb7XQHoQ@mail.gmail.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        scsi <linux-scsi@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
From:   Xiaofei Tan <tanxiaofei@huawei.com>
Message-ID: <58053d07-ca58-2b78-36ff-40ecf162ed49@huawei.com>
Date:   Thu, 25 Feb 2021 10:37:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXwmjq_MPr=R9twkYRoun2buuSrPDbLo6zdkGFb7XQHoQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.192.162]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Geert,

On 2021/2/24 17:41, Geert Uytterhoeven wrote:
> Hi Xiaofei,
>
> On Sun, Feb 7, 2021 at 12:46 PM Xiaofei Tan <tanxiaofei@huawei.com> wrote:
>> Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI drivers.
>> There are no function changes, but may speed up if interrupt happen
>> too often.
>
> I'll bite: how much does this speed up interrupt processing?
> What's the typical cost of saving/disabling, and restoring interrupt
> state?

It could only take a few CPU cycles. So there is little benefit for 
speeding up interrupt processing.You could take them as cleanup.

Is removing this cost worth the risk of introducing subtle
> regressions on platforms you cannot test yourself?
>

Currently, only found M68K platform support that high-priority interrupt 
preempts low-priority. No other platform has such services. Therefore, 
these changes do not affect non-M68K platforms.

For M68K platform, no one report such interrupt preemption case in these 
SCSI drivers.

> BTW, how many of these legacy SCSI controllers do you have access to?
>

Actually, no.

> Thanks for your answers!
>
> Gr{oetje,eeting}s,
>
>                         Geert
>

