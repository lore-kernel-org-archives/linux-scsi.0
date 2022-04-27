Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA720C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 14:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiD0OcO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 10:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237877AbiD0OcN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 10:32:13 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1CF15833;
        Wed, 27 Apr 2022 07:29:01 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d6so2151011ede.8;
        Wed, 27 Apr 2022 07:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=su+S40qJAZBfxSVeOdjWZtJfUAwd/TBUd34BOhXChlA=;
        b=EgsSkp4KEkcR+2OCaAJw+XTmptgLB+M5SPxXRTyIj2cFFBX5AkRTwbnD7wwX202qZ6
         TIOuFJu0D3+uviL4jTZMwYfeZPtPXyEL+kNF+G7x78MOH3GGvyzAKMnicdEvvK+dFGg7
         dtkUgVyKSjElwsa3+LlRj7Otzk1iKIT7C12cQrs7b9CYOk3kdSVQrkpHinkKxEUalji1
         uRyu17JzMOFAP72zGDjFv/OZdWn0DAQQQV/uWbgTE6dljZ6Zknqyf4sT32G38YQJWUwg
         phia9v5nk4wOQcM9WqGM5y6zvpj3kDwxZwOkM4XEXfYqkRHrfs9onsicwL/sOtFzo0s8
         yE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=su+S40qJAZBfxSVeOdjWZtJfUAwd/TBUd34BOhXChlA=;
        b=yjDvSzJLxM9HTOnobFaF7BAMvvxhu+uE+iliV1aEXl9A7dDxkO5YDc3XYxov66Bzhe
         5NB+aT2Frs6Bm0nGMU0jxxCxDKEbaPxRga20ImQKAtJ2HFYw7p1vV5wiazjFSaO4by2k
         acqiicn+LEvjxAsgT9TTUiqrKm9CBfcWTUAZu6IRkwuEBY9TxDaSUsrilXapDN9nL87d
         97wJkg1Dvq76+cGYz8Sh7i68Xxmx2BKl3sq1cRWsSxZ+W5wL/EjZFERT0JXrNUiFQlTM
         gFssGhovn1lD0MNZuAIyKCSyorTOzMDFRj6+bOXh9I5u89klVYT2OKpQJx1aOhwNxLCc
         0mAw==
X-Gm-Message-State: AOAM530bj45nck6qVyj+TYYdUFEm31sp3h3lEBi2SlWxBhpRizwnLFgU
        bgz5BAM5MbhjPPL+o2zaoK0=
X-Google-Smtp-Source: ABdhPJyu74sKIRMGh4xs2yGGlcLJRYPP/1WkaIwXZjA2aDIG1D+FXmp5h+5d9js+TpSHOT0+LQgX1A==
X-Received: by 2002:a05:6402:1a42:b0:424:20bb:3e37 with SMTP id bf2-20020a0564021a4200b0042420bb3e37mr30770788edb.29.1651069739636;
        Wed, 27 Apr 2022 07:28:59 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id n14-20020a50934e000000b0042053e79386sm8545803eda.91.2022.04.27.07.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 07:28:58 -0700 (PDT)
Message-ID: <1c5d7e25-474c-e5bb-bd07-5cba3f49fcfa@gmail.com>
Date:   Wed, 27 Apr 2022 16:28:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v5] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20220421023735.9018-1-xiaoguang.wang@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20220421023735.9018-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Wang,

Thank you for fixing this!

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>

On 21.04.22 04:37, Xiaoguang Wang wrote:
> When tcmu_vma_fault() gets one page successfully, before the current
> context completes page fault procedure, find_free_blocks() may run in
> and call unmap_mapping_range() to unmap this page. Assume when
> find_free_blocks() completes its job firstly, previous page fault
> procedure starts to run again and completes, then one truncated page has
> beed mapped to use space, but note that tcmu_vma_fault() has gotten one
> refcount for this page, so any other subsystem won't use this page,
> unless later the use space addr is unmapped.
> 
> If another command runs in later and needs to extends dbi_thresh, it may
> reuse the corresponding slot to previous page in data_bitmap, then though
> we'll allocate new page for this slot in data_area, but no page fault will
> happen again, because we have a valid map, real request's data will lose.
> 
> Filesystem implementations will also run into this issue, but they
> usually lock page when vm_operations_struct->fault gets one page, and
> unlock page after finish_fault() completes. In truncate sides, they
> lock pages in truncate_inode_pages() to protect race with page fault.
> We can also have similar codes like filesystem to fix this issue.
> 
> To fix this possible data corruption, we can apply similar method like
> filesystem. For pages that are to be freed, tcmu_blocks_release() locks
> and unlocks these pages, and make tcmu_vma_fault() also lock found page
> under cmdr_lock. At the same time, since tcmu_vma_fault() gets one extra
> page refcount, tcmu_blocks_release() won't free pages if pages are in
> page fault procedure, which means it's safe to call tcmu_blocks_release()
> before unmap_mapping_range().
> 
> With above action, for above race, tcmu_blocks_release()
> will wait all page faults to be completed before calling
> unmap_mapping_range(), and later if unmap_mapping_range() is called,
> it will ensure stale mappings to be removed cleanly.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
> V5:
>   Improve code comments.
> 
> V4:
>   Add comments to explain why it's safe to call tcmu_blocks_release()
> before unmap_mapping_range().
> 
> V3:
>   Just lock/unlock_page in tcmu_blocks_release(), and call
> tcmu_blocks_release() before unmap_mapping_range().
> 
> V2:
>    Wait all possible inflight page faults to be completed in
> find_free_blocks() to fix possible stale map.
> ---
>   drivers/target/target_core_user.c | 38 +++++++++++++++++++++++++++++++++++---
>   1 file changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index fd7267baa707..f0d4cc693e9e 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -20,6 +20,7 @@
>   #include <linux/configfs.h>
>   #include <linux/mutex.h>
>   #include <linux/workqueue.h>
> +#include <linux/pagemap.h>
>   #include <net/genetlink.h>
>   #include <scsi/scsi_common.h>
>   #include <scsi/scsi_proto.h>
> @@ -1667,6 +1668,25 @@ static u32 tcmu_blocks_release(struct tcmu_dev *udev, unsigned long first,
>   	xas_lock(&xas);
>   	xas_for_each(&xas, page, (last + 1) * udev->data_pages_per_blk - 1) {
>   		xas_store(&xas, NULL);
> +		/*
> +		 * While reaching here, there maybe page faults occurring on
> +		 * these to be released pages, and there maybe one race that
> +		 * unmap_mapping_range() is called before page fault on these
> +		 * pages are finished, then valid but stale map is created.
> +		 *
> +		 * If another command runs in later and needs to extends
> +		 * dbi_thresh, it may reuse the corresponding slot to previous
> +		 * page in data_bitmap, then though we'll allocate new page for
> +		 * this slot in data_area, but no page fault will happen again,
> +		 * because we have a valid map, command's data will lose.
> +		 *
> +		 * So here we lock and unlock pages that are to be released to
> +		 * ensure all page faults to be completed, then following
> +		 * unmap_mapping_range() can ensure stale maps to be removed
> +		 * cleanly.
> +		 */
> +		lock_page(page);
> +		unlock_page(page);
>   		__free_page(page);
>   		pages_freed++;
>   	}
> @@ -1822,6 +1842,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>   	page = xa_load(&udev->data_pages, dpi);
>   	if (likely(page)) {
>   		get_page(page);
> +		lock_page(page);
>   		mutex_unlock(&udev->cmdr_lock);
>   		return page;
>   	}
> @@ -1863,6 +1884,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
>   	struct page *page;
>   	unsigned long offset;
>   	void *addr;
> +	vm_fault_t ret = 0;
>   
>   	int mi = tcmu_find_mem_index(vmf->vma);
>   	if (mi < 0)
> @@ -1887,10 +1909,11 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
>   		page = tcmu_try_get_data_page(udev, dpi);
>   		if (!page)
>   			return VM_FAULT_SIGBUS;
> +		ret = VM_FAULT_LOCKED;
>   	}
>   
>   	vmf->page = page;
> -	return 0;
> +	return ret;
>   }
>   
>   static const struct vm_operations_struct tcmu_vm_ops = {
> @@ -3205,12 +3228,21 @@ static void find_free_blocks(void)
>   			udev->dbi_max = block;
>   		}
>   
> +		/*
> +		 * Release the block pages.
> +		 * Also note that since tcmu_vma_fault() gets one extra page
> +		 * refcount, tcmu_blocks_release() won't free pages if pages
> +		 * are in mapped, that means it's safe to call
> +		 * tcmu_blocks_release() before unmap_mapping_range(), which
> +		 * drops the refcount of pages it unmaps and thus releases
> +		 * those pages.
> +		 */
> +		pages_freed = tcmu_blocks_release(udev, start, end - 1);
> +
>   		/* Here will truncate the data area from off */
>   		off = udev->data_off + (loff_t)start * udev->data_blk_size;
>   		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
>   
> -		/* Release the block pages */
> -		pages_freed = tcmu_blocks_release(udev, start, end - 1);
>   		mutex_unlock(&udev->cmdr_lock);
>   
>   		total_pages_freed += pages_freed;
