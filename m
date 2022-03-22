Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B843CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 13:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbiCVNEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 09:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbiCVNEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 09:04:08 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7094285BC7;
        Tue, 22 Mar 2022 06:02:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V7wHIq1_1647954157;
Received: from 30.225.28.195(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0V7wHIq1_1647954157)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Mar 2022 21:02:37 +0800
Message-ID: <37d6b269-dd9d-dbd1-74b1-4191cc3d4bf9@linux.alibaba.com>
Date:   Tue, 22 Mar 2022 21:02:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFC 2/3] mm: export zap_page_range()
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, xuyu@linux.alibaba.com,
        bostroesser@gmail.com
References: <20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com>
 <20220318095531.15479-3-xiaoguang.wang@linux.alibaba.com>
 <a37e9ba2-354b-0b75-cb05-bc730cb30151@redhat.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <a37e9ba2-354b-0b75-cb05-bc730cb30151@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

> On 18.03.22 10:55, Xiaoguang Wang wrote:
>> Module target_core_user will use it to implement zero copy feature.
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   mm/memory.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 1f745e4d11c2..9974d0406dad 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -1664,6 +1664,7 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
>>   	mmu_notifier_invalidate_range_end(&range);
>>   	tlb_finish_mmu(&tlb);
>>   }
>> +EXPORT_SYMBOL_GPL(zap_page_range);
>>   
>>   /**
>>    * zap_page_range_single - remove user pages in a given range
> To which VMAs will you be applying zap_page_range? I assume only to some
> special ones where you previously vm_insert_page(s)_mkspecial'ed pages,
> not to some otherwise random VMAs, correct?
Yes, you're right :)

Regards,
Xiaoguang Wang
>

