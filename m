Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CD3C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 02:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5ABA6140D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 02:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhDUCR3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 22:17:29 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:37051 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234007AbhDUCR2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 22:17:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UWFcK-N_1618971414;
Received: from 30.13.161.100(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UWFcK-N_1618971414)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 21 Apr 2021 10:16:54 +0800
Subject: Re: [PATCH] scsi: a100u2w: remove useless variable
To:     Julian Calaby <julian.calaby@gmail.com>
References: <1618197759-128087-1-git-send-email-jiapeng.chong@linux.alibaba.com>
 <CAGRGNgVucQWcGiUnWtsC=oRDXrWkQ13CFojOcM7xU+4TukUoOA@mail.gmail.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
From:   =?UTF-8?B?56eN5ZiJ6bmP?= <jiapeng.chong@linux.alibaba.com>
Message-ID: <aebf4084-9e41-1e8b-35ca-ae57f934fca5@linux.alibaba.com>
Date:   Wed, 21 Apr 2021 10:16:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAGRGNgVucQWcGiUnWtsC=oRDXrWkQ13CFojOcM7xU+4TukUoOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/4/17 14:34, Julian Calaby wrote:
> Hi Jiapeng,
> 
> On Mon, Apr 12, 2021 at 1:23 PM Jiapeng Chong
> <jiapeng.chong@linux.alibaba.com> wrote:
>>
>> Fix the following gcc warning:
>>
>> drivers/scsi/a100u2w.c:1092:8: warning: variable ‘bios_phys’ set but not
>> used [-Wunused-but-set-variable].
>>
>> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
>> ---
>>   drivers/scsi/a100u2w.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
>> index 66c5143..855a3fe 100644
>> --- a/drivers/scsi/a100u2w.c
>> +++ b/drivers/scsi/a100u2w.c
>> @@ -1089,7 +1089,6 @@ static int inia100_probe_one(struct pci_dev *pdev,
>>          int error = -ENODEV;
>>          u32 sz;
>>          unsigned long biosaddr;
>> -       char *bios_phys;
>>
>>          if (pci_enable_device(pdev))
>>                  goto out;
>> @@ -1141,7 +1140,7 @@ static int inia100_probe_one(struct pci_dev *pdev,
>>
>>          biosaddr = host->BIOScfg;
>>          biosaddr = (biosaddr << 4);
>> -       bios_phys = phys_to_virt(biosaddr);
>> +       phys_to_virt(biosaddr);
> 
> Does phys_to_virt() have side effects? If it doesn't, there's a lot
> more stuff that can get deleted here.
> 
> Thanks,
> 
OK, I'll delete phys_to_virt() and send V2.
