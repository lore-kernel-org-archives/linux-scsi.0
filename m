Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA862C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 07:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1B864E68
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 07:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhBRHVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 02:21:33 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12553 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhBRHNp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 02:13:45 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dh5T93t3szMYgj;
        Thu, 18 Feb 2021 15:10:37 +0800 (CST)
Received: from [127.0.0.1] (10.40.192.162) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Thu, 18 Feb 2021
 15:12:25 +0800
Subject: Re: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage
 optimization for SCSI drivers
To:     Finn Thain <fthain@telegraphics.com.au>,
        "Song Bao Hua (Barry Song)" <song.bao.hua@hisilicon.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
 <e949a474a9284ac6951813bfc8b34945@hisilicon.com>
 <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        <linux-m68k@vger.kernel.org>
From:   Xiaofei Tan <tanxiaofei@huawei.com>
Message-ID: <7bc39d19-f4cc-8028-11e6-c0e45421a765@huawei.com>
Date:   Thu, 18 Feb 2021 15:12:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <f0a3339d-b1db-6571-fa2f-6765e150eb9d@telegraphics.com.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.192.162]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

On 2021/2/9 13:06, Finn Thain wrote:
> On Tue, 9 Feb 2021, Song Bao Hua (Barry Song) wrote:
>
>>> -----Original Message-----
>>> From: Finn Thain [mailto:fthain@telegraphics.com.au]
>>> Sent: Monday, February 8, 2021 8:57 PM
>>> To: tanxiaofei <tanxiaofei@huawei.com>
>>> Cc: jejb@linux.ibm.com; martin.petersen@oracle.com;
>>> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
>>> linuxarm@openeuler.org
>>> Subject: [Linuxarm] Re: [PATCH for-next 00/32] spin lock usage optimization
>>> for SCSI drivers
>>>
>>> On Sun, 7 Feb 2021, Xiaofei Tan wrote:
>>>
>>>> Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI drivers.
>>>> There are no function changes, but may speed up if interrupt happen too
>>>> often.
>>>
>>> This change doesn't necessarily work on platforms that support nested
>>> interrupts.
>>>
>>> Were you able to measure any benefit from this change on some other
>>> platform?
>>
>> I think the code disabling irq in hardIRQ is simply wrong.
>> Since this commit
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e58aa3d2d0cc
>> genirq: Run irq handlers with interrupts disabled
>>
>> interrupt handlers are definitely running in a irq-disabled context
>> unless irq handlers enable them explicitly in the handler to permit
>> other interrupts.
>>
>
> Repeating the same claim does not somehow make it true. If you put your
> claim to the test, you'll see that that interrupts are not disabled on
> m68k when interrupt handlers execute.
>
> The Interrupt Priority Level (IPL) can prevent any given irq handler from
> being re-entered, but an irq with a higher priority level may be handled
> during execution of a lower priority irq handler.
>
> sonic_interrupt() uses an irq lock within an interrupt handler to avoid
> issues relating to this. This kind of locking may be needed in the drivers
> you are trying to patch. Or it might not. Apparently, no-one has looked.
>

According to your discussion with Barry, it seems that m68k is a little 
different from other architecture, and this kind of modification of this 
patch cannot be applied to m68k. So, could help to point out which 
driver belong to m68k architecture in this patch set of SCSI?
I can remove them.

BTW, sonic_interrupt() is from net driver natsemi, right?  It would be 
appreciative if only discuss SCSI drivers in this patch set. thanks.

> .
>

