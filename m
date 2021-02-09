Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A263FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D2AE64E45
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhBICBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 21:01:14 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12872 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhBICBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 21:01:09 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DZQzr14rSz7j5y;
        Tue,  9 Feb 2021 09:59:04 +0800 (CST)
Received: from [127.0.0.1] (10.40.192.162) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Tue, 9 Feb 2021
 10:00:22 +0800
Subject: Re: [PATCH for-next 00/32] spin lock usage optimization for SCSI
 drivers
To:     Finn Thain <fthain@telegraphics.com.au>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
 <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
From:   tanxiaofei <tanxiaofei@huawei.com>
Message-ID: <a555f4b2-4df9-7bf4-e76c-3556d5ccb4ff@huawei.com>
Date:   Tue, 9 Feb 2021 10:00:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <31cd807d-3d0-ed64-60d-fde32cb3833c@telegraphics.com.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.192.162]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,
Thanks for reviewing the patch set.

On 2021/2/8 15:57, Finn Thain wrote:
> On Sun, 7 Feb 2021, Xiaofei Tan wrote:
>
>> Replace spin_lock_irqsave with spin_lock in hard IRQ of SCSI drivers.
>> There are no function changes, but may speed up if interrupt happen too
>> often.
>
> This change doesn't necessarily work on platforms that support nested
> interrupts.
>

Linux doesn't support nested interrupts anymore after the following 
patch, so please don't worry this.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e58aa3d2d0cc

> Were you able to measure any benefit from this change on some other
> platform?
>

It's hard to measure the benefit of this change. Hmm, you could take 
this patch set as cleanup. thanks.

> Please see also,
> https://lore.kernel.org/linux-scsi/89c5cb05cb844939ae684db0077f675f@h3c.com/
>
> .
>

