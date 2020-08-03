Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63127C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 03:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5101920775
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 03:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgHCDIX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Aug 2020 23:08:23 -0400
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:55046
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1725820AbgHCDIW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2020 23:08:22 -0400
Received: from [166.111.139.118] (unknown [166.111.139.118])
        by app-1 (Coremail) with SMTP id DwQGZQDn76OMfydfEpXxAw--.14644S2;
        Mon, 03 Aug 2020 11:07:58 +0800 (CST)
Subject: Re: [PATCH] scsi: esas2r: fix possible buffer overflow caused by bad
 DMA value in esas2r_process_fs_ioctl()
To:     jejb@linux.ibm.com, linuxdrivers@attotech.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200802152145.4387-1-baijiaju@tsinghua.edu.cn>
 <1596383240.4087.8.camel@linux.ibm.com>
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Message-ID: <81351eab-69c0-89dc-4e58-146a005b5929@tsinghua.edu.cn>
Date:   Mon, 3 Aug 2020 11:07:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1596383240.4087.8.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: DwQGZQDn76OMfydfEpXxAw--.14644S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AF4DWw1xWF15Cr1DuryDWrg_yoW8Jw1kpr
        WF93yrKr1qyr1Iqasavw1xXa4rtFZ5tF98GF15XFyv9wn8Cr1fAryrKFs8A34UW3s7Jw45
        WaykXr97ta9FyFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvIb7Iv0xC_tr1lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY
        02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r12
        6r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
        9x07jc6pPUUUUU=
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020/8/2 23:47, James Bottomley wrote:
> On Sun, 2020-08-02 at 23:21 +0800, Jia-Ju Bai wrote:
>> Because "fs" is mapped to DMA, its data can be modified at anytime by
>> malicious or malfunctioning hardware. In this case, the check
>> "if (fsc->command >= cmdcnt)" can be passed, and then "fsc->command"
>> can be modified by hardware to cause buffer overflow.
> This threat model seems to be completely bogus.  If the device were
> malicious it would have given the mailbox incorrect values a priori ...
> it wouldn't give the correct value then update it.  For most systems we
> do assume correct operation of the device but if there's a worry about
> incorrect operation, the usual approach is to guard the device with an
> IOMMU which, again, would make this sort of fix unnecessary because the
> IOMMU will have removed access to the buffer after the command
> completed.

Thanks for the reply :)

In my opinion, IOMMU is used to prevent the hardware from accessing 
arbitrary memory addresses, but it cannot prevent the hardware from 
writing a bad value into a valid memory address.
For this reason, I think that the hardware can normally access 
"fsc->command" and modify it into arbitrary value at any time, because 
IOMMU considers the address of "fsc->command" is valid for the hardware.


Best wishes,
Jia-Ju Bai

