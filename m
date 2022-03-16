Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B553C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 13:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356011AbiCPNGj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 09:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241627AbiCPNGh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 09:06:37 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED2F2CCAB;
        Wed, 16 Mar 2022 06:05:22 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a8so4016895ejc.8;
        Wed, 16 Mar 2022 06:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=JiViA8ea0Lp5AfKvhVY7UNjzM5vAkCU18t7GAQzHry0=;
        b=amcSflbpUj6+Rdy5lcquadfSVu2yV37f2D/ICwbGfzBua4z+BHzfuDSw24Ye8csOsv
         Kcbspd1PJNsx/VGkQvm1gpVLwWDDaRz4Spa9EwMi1fy+8RZC9UDDFikia/5V22okBc2Z
         hC2sLNRrdDDjVrkvtdn4fQ6/XQJ6rg/CCbCi6QS81z8o5WRjYucLs04gN/ywp4W3dkPL
         shuzDQLfjK5ybiZBlxHCihoH5nmAW1z3IR9ldJYZ9HXhb8K6dy3m/ZKvvQUcrZLIbh7+
         vB/fEuiUD0IFchyJvEoZ5pCPnLLA45xaCoX1c0BBR8Fa0Ha+ijMK09msccM+a2GOIsVj
         tsEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JiViA8ea0Lp5AfKvhVY7UNjzM5vAkCU18t7GAQzHry0=;
        b=hHiMfRE067MliPVn4rakYXYDK9SetROhC/KqXjBo5kqk2OXaCYugKOlB1mCDjokPqq
         sL9Vva/3SvhoST7b1IrDEsewU8pld5ZE58pZretFH4UFWJz5CZt+0g944ErAijDDWRSJ
         3NIoBk/YbFoM7FJhedr69lL0RTYiJj2kRQaaLJ9E2v7doDIOPmAC3WaITq4gMpiFYDVr
         mvdLrhBRsfn5PERLMmLtcsgxo9FpfqIy2b3dL8GwAQC4/Z38L00Pr0FZV3m9zK0TfjRz
         XPZrQ3YNE8T/YpudcJCAq2BMhJxHC9haSOd+CEvNCE3zcd9Gj/aDR/grQACMFJalQPyH
         4oEA==
X-Gm-Message-State: AOAM530R14fBKtoTK4B4gFSryDbvMpP2HHZIvfREJDasRfiOX3O+LojW
        TfMffR8wO/PfHCo88DHXrLc=
X-Google-Smtp-Source: ABdhPJylKku27tk1rhgys1nlVcgWqe9xQy+7R+ESkLqPS47Miu7i69U0m90taHNzAlREnUdQ+5a8Xw==
X-Received: by 2002:a17:906:544d:b0:6db:3816:c513 with SMTP id d13-20020a170906544d00b006db3816c513mr27543911ejp.664.1647435921377;
        Wed, 16 Mar 2022 06:05:21 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1fa42.dynamic.kabel-deutschland.de. [188.193.250.66])
        by smtp.gmail.com with ESMTPSA id js23-20020a170906ca9700b006daaa3acc36sm887161ejb.52.2022.03.16.06.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 06:05:21 -0700 (PDT)
Message-ID: <b04319b3-2214-8d9e-46b4-1772dd003240@gmail.com>
Date:   Wed, 16 Mar 2022 14:05:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/2] scsi: target: tcmu: Use
 address_space->invalidate_lock
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220311132206.24515-1-xiaoguang.wang@linux.alibaba.com>
 <20220311132206.24515-2-xiaoguang.wang@linux.alibaba.com>
 <c6a25258-6937-6cdf-0fab-081312c4dee6@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <c6a25258-6937-6cdf-0fab-081312c4dee6@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry for the late response. Currently I'm quite busy.

In your earlier mail you described a possible dead lock.
With this patch applied, are you sure a similar deadlock cannot
happen?

Additionally, let's assume tcmu_vma_fault/tcmu_try_get_data_page
- after having found a valid page to map - is interrupted after
releasing the invalidate_lock. Are there any locks held to prevent
find_free_blocks from jumping in and possibly remove that page from 
xarray and try to remove it from the mmapped area?
If not, we might end up mapping a no longer valid page.

Of course, this would be a long standing problem not caused by your
change. But if there would be a problem, we should try to fix it
when touching this code, I think.
Unfortunately I didn't manage yet to check which locks are involved
during page fault handling and unmap_mapping_range.

Bodo

On 16.03.22 11:43, Xiaoguang Wang wrote:
> hello,
> 
> Gentle ping.
> 
> Regards,
> Xiaoguang Wang
> 
>> Currently tcmu_vma_fault() uses udev->cmdr_lock to avoid concurrent
>> find_free_blocks(), which unmaps idle pages and truncates them. This
>> work is really like many filesystem's truncate operations, but they
>> use address_space->invalidate_lock to protect race.
>>
>> This patch replaces cmdr_lock with address_space->invalidate_lock in
>> tcmu fault procedure, which will also make page-fault have concurrency.
>>
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>> ---
>>   drivers/target/target_core_user.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/target/target_core_user.c 
>> b/drivers/target/target_core_user.c
>> index 06a5c4086551..e0a62623ccd7 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -1815,13 +1815,14 @@ static int tcmu_find_mem_index(struct 
>> vm_area_struct *vma)
>>   static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, 
>> uint32_t dpi)
>>   {
>> +    struct address_space *mapping = udev->inode->i_mapping;
>>       struct page *page;
>> -    mutex_lock(&udev->cmdr_lock);
>> +    filemap_invalidate_lock_shared(mapping);
>>       page = xa_load(&udev->data_pages, dpi);
>>       if (likely(page)) {
>>           get_page(page);
>> -        mutex_unlock(&udev->cmdr_lock);
>> +        filemap_invalidate_unlock_shared(mapping);
>>           return page;
>>       }
>> @@ -1831,7 +1832,7 @@ static struct page 
>> *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>>        */
>>       pr_err("Invalid addr to data page mapping (dpi %u) on device %s\n",
>>              dpi, udev->name);
>> -    mutex_unlock(&udev->cmdr_lock);
>> +    filemap_invalidate_unlock_shared(mapping);
>>       return NULL;
>>   }
>> @@ -3111,6 +3112,7 @@ static void find_free_blocks(void)
>>       loff_t off;
>>       u32 pages_freed, total_pages_freed = 0;
>>       u32 start, end, block, total_blocks_freed = 0;
>> +    struct address_space *mapping;
>>       if (atomic_read(&global_page_count) <= tcmu_global_max_pages)
>>           return;
>> @@ -3134,6 +3136,7 @@ static void find_free_blocks(void)
>>               continue;
>>           }
>> +        mapping = udev->inode->i_mapping;
>>           end = udev->dbi_max + 1;
>>           block = find_last_bit(udev->data_bitmap, end);
>>           if (block == udev->dbi_max) {
>> @@ -3152,12 +3155,14 @@ static void find_free_blocks(void)
>>               udev->dbi_max = block;
>>           }
>> +        filemap_invalidate_lock(mapping);
>>           /* Here will truncate the data area from off */
>>           off = udev->data_off + (loff_t)start * udev->data_blk_size;
>> -        unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>> +        unmap_mapping_range(mapping, off, 0, 1);
>>           /* Release the block pages */
>>           pages_freed = tcmu_blocks_release(udev, start, end - 1);
>> +        filemap_invalidate_unlock(mapping);
>>           mutex_unlock(&udev->cmdr_lock);
>>           total_pages_freed += pages_freed;
> 
