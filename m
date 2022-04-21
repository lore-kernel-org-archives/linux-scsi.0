Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C446C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 02:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiDUCoF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 22:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiDUCoD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 22:44:03 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552A8B3E;
        Wed, 20 Apr 2022 19:41:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VAcKenE_1650508871;
Received: from 30.225.28.170(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VAcKenE_1650508871)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Apr 2022 10:41:12 +0800
Message-ID: <1c0ffbd6-7ab5-e598-b4f2-fd6e9b932204@linux.alibaba.com>
Date:   Thu, 21 Apr 2022 10:41:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH v4] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220417052604.120942-1-xiaoguang.wang@linux.alibaba.com>
 <5015edcc-0b62-4c1f-d4f4-ec0d7a1470d7@gmail.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <5015edcc-0b62-4c1f-d4f4-ec0d7a1470d7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi,

> Hi,
>
> just some remarks regarding the new comment.
>
> Bodo
>
> On 17.04.22 07:26, Xiaoguang Wang wrote:
>
> ... snip ...
>
>>   static const struct vm_operations_struct tcmu_vm_ops = {
>> @@ -3205,12 +3228,19 @@ static void find_free_blocks(void)
>>               udev->dbi_max = block;
>>           }
>>   +        /*
>> +         * Release the block pages.
>> +         * Also note that since tcmu_vma_fault() gets one extra page
>> +         * refcount, tcmu_blocks_release() won't free pages if pages
>> +         * are in page fault procedure, which means it's safe to
>
> s/in page fault procedure/mapped/
>
>> +         * call tcmu_blocks_release() before unmap_mapping_range().
>
> "... before unmap_mapping_range(), which drops the refcount of pages it
> unmaps and thus releases those pages."
>
> Please feel free to find an even better wording.
Yours seems better, just apply your suggestions.
I'm not a native english speaker :)

Regards,
Xiaoguang Wang
>
>> +         */
>> +        pages_freed = tcmu_blocks_release(udev, start, end - 1);
>> +
>>           /* Here will truncate the data area from off */
>>           off = udev->data_off + (loff_t)start * udev->data_blk_size;
>>           unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>>   -        /* Release the block pages */
>> -        pages_freed = tcmu_blocks_release(udev, start, end - 1);
>>           mutex_unlock(&udev->cmdr_lock);
>>             total_pages_freed += pages_freed;

