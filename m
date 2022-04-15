Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5928DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 18:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345121AbiDOSHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 14:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243676AbiDOSHL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 14:07:11 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D689062C3;
        Fri, 15 Apr 2022 11:04:40 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id s18so16605543ejr.0;
        Fri, 15 Apr 2022 11:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yxpD8id/DNdAqhCjqBzFUlzmC8A5Rh43tHQNPpqkJVQ=;
        b=B9r2EPKCyDzWdrWKr8lkwVIxSA57oVX9YRiV9O/eajSQyYen7dHklX65A/gBMJhaS9
         nLB2QKdU/hoKP9ta1zZUznyfqTSnsFDYRddDj+p1XS43d/L6+KkECsu+K9mNG/5HUJMH
         JMxe+s/kv2RSg1LgyPx9iuU1tYhRAboZNRo2SwokvkclScJLWGFv0srjZvdGrCLjXBNR
         0V5VUu+ZRLX6ELRkHyZgV508blkVDoLYx7UL95JlEqrazu+O0Y0F/V37g/uDVGmeCJGl
         JwBAfP3LggSFwXbAGpoeG4HfEmHdxaaMGF7gFmxRDpUgZaBOOxu9Xf89+Fd421HvvlXm
         oheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yxpD8id/DNdAqhCjqBzFUlzmC8A5Rh43tHQNPpqkJVQ=;
        b=kmM9lMkWDLZopMmIXHXDKv1DO6dNLKN/6NRnrcFiefnSPbGR4ITybk/JER/QgbfNiF
         dERB/zOk++vhtE2PrR17Qh+i6CLuGfLJ9aYZZxGdYvAitWHjbR5SKy6lqDm4eTcCS+mo
         z4rKYyel28wLYtvAv9JqO9t4bBiPXTV5zPse2F2jTaPLfTgPxckMsptiHvGPeshbRkxm
         9Zwc01EcEVyC1ivA2Me7OQ+IXFnKqyxGIBwTvoo1IUggL+D2bP/E533j2QkVTrEyJrYc
         FizlXGy75xgZaOB+jGpcOhGWN+sQ7yyEDahUgaxKy0/+82BJqznfx/DuSvK5V8CGuaRw
         zYIA==
X-Gm-Message-State: AOAM530LRdOZRCB40q+T0GF8KhxZvnDba4ZQW5+Pafhet9oZTdjm9DGT
        37sP1THwxjRLW3mZmXS084DqqHBJAtM=
X-Google-Smtp-Source: ABdhPJzjxw6CmBFRbJiDFSZym+nULVUS3ojdb7q2YpIYu1JVNPjO9npYzrZFncBKG8B//4d09/EqAA==
X-Received: by 2002:a17:906:1692:b0:6e8:d245:44a9 with SMTP id s18-20020a170906169200b006e8d24544a9mr199532ejd.639.1650045879343;
        Fri, 15 Apr 2022 11:04:39 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id o14-20020a170906774e00b006d5b915f27dsm1898107ejn.169.2022.04.15.11.04.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 11:04:38 -0700 (PDT)
Message-ID: <b3df81ad-c0a8-4758-2d24-103ed39acfeb@gmail.com>
Date:   Fri, 15 Apr 2022 20:04:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220415153450.15184-1-xiaoguang.wang@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20220415153450.15184-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Thank you again for the patch!

You might call me a nitpicker, but ...

Wouldn't it be good to add a comment in find_free_blocks explaining
why it is safe to first call tcmu_blocks_release and then
unmap_mapping_range?

Regards,
Bodo

On 15.04.22 17:34, Xiaoguang Wang wrote:
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
> filesystem. For pages that are to be freed, find_free_blocks() locks
> and unlocks these pages, and make tcmu_vma_fault() also lock found page
> under cmdr_lock. With this action, for above race, find_free_blocks()
> will wait all page faults to be completed before calling
> unmap_mapping_range(), and later if unmap_mapping_range() is called,
> it will ensure stale mappings to be removed cleanly.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
> V3:
>   Just lock/unlock_page in tcmu_blocks_release(), and call
> tcmu_blocks_release() before unmap_mapping_range().
> 
> V2:
>    Wait all possible inflight page faults to be completed in
> find_free_blocks() to fix possible stale map.
> ---
>   drivers/target/target_core_user.c | 30 +++++++++++++++++++++++++++---
>   1 file changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index fd7267baa707..ff4a575a14d2 100644
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
> @@ -3205,12 +3228,13 @@ static void find_free_blocks(void)
>   			udev->dbi_max = block;
>   		}
>   
> +		/* Release the block pages */
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
