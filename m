Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893B0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 19:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351399AbiDAUAF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344680AbiDAUAE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 16:00:04 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F95D208247;
        Fri,  1 Apr 2022 12:58:14 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id dr20so8009051ejc.6;
        Fri, 01 Apr 2022 12:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WRx3gxfAOSc7mMmq0ocwCJ3iE/vWYvf0MtXC/w5ZLdw=;
        b=lxlQbe8ON1pI9Lol/MiprmeqFqfGFj1RS2RxwlsVbfIunEsapzRucqxh8vU3HiDFzQ
         MApdI4DADhmW9OmEa7aVQruMnN0/9GCiYMmCWF9v+CTQBLQ58pemHOIJEZL+jxNPoEX7
         eYE5hm/k25/rs9o8Yl/XYeuJK4SEtc/ua0MsY78lhoDd1Y/w7oUcgnw/Std4tu5FQOmk
         iiaCqXzoNcxG9/rWVzYHnw4yuzhgMDZTrPDXbfAu8pRi9waRZuAXeaFeC7bkKMdcusHD
         PcgWO4aXBsZKxr7QAwAa7FJ011OnP7phz0OLEXq+n3LJNcxzKkDCE5sHgQK40O6vt4us
         lQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WRx3gxfAOSc7mMmq0ocwCJ3iE/vWYvf0MtXC/w5ZLdw=;
        b=76nIIGPDC3IbHvTVTThx3/JNlCAFU9tFG1auy2+Y6qwslgDb6RkRaozcYf0SezNdvR
         GL2fc1R9obhKtIDUN2aF4CHtDAZN3KjvqKs5+miAO5iDPLJV0jOC4FkAxTZTpk9Ikot0
         2FnPb3stOd5AthJxJh6OQ5YhoXmbr7jHVTbYxuO9uM/oejPhEc7gNgeixo4rUXtnNUxr
         nYMST1CGQvMOrPEnVeRzRyeNv4hueQsAqBT4iMpbBJ1NaKfi6YDbigxjUvN6oQwUt2hi
         w/gQVfLnNgTzrMrTh1NpDKwugMjnkKSMDd4D0pVv8ic7itBYXmyDudeRgLqW99p6co/X
         OlKw==
X-Gm-Message-State: AOAM533kAcKE1l8Z6BkzypDGc9pYCXtORigopPQzYVe48c3ovAqOhe7F
        jJJxflZCXufZn1GTJXAwqA+d0XR3sqI=
X-Google-Smtp-Source: ABdhPJwNtDOKVIv30XenStCCa5yvnACQvvQzfwO7QtFVbS3mQIpInYsHpkRH6uyzpS+M/F2LwjqqRA==
X-Received: by 2002:a17:907:1c9d:b0:6e4:a223:1af2 with SMTP id nb29-20020a1709071c9d00b006e4a2231af2mr1304871ejc.102.1648843092510;
        Fri, 01 Apr 2022 12:58:12 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id hp12-20020a1709073e0c00b006e02924bf20sm1319405ejc.117.2022.04.01.12.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 12:58:11 -0700 (PDT)
Message-ID: <5226b4ae-33fe-2bee-b88a-240994231d1c@gmail.com>
Date:   Fri, 1 Apr 2022 21:58:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 3/3] scsi: target: tcmu: Use
 address_space->invalidate_lock
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220323134940.31463-1-xiaoguang.wang@linux.alibaba.com>
 <20220323134940.31463-4-xiaoguang.wang@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20220323134940.31463-4-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23.03.22 14:49, Xiaoguang Wang wrote:
> Currently tcmu_vma_fault() uses udev->cmdr_lock to avoid concurrent
> find_free_blocks(), which unmaps idle pages and truncates them. This
> work is really like many filesystem's truncate operations, but they
> use address_space->invalidate_lock to protect race.
> 
> This patch replaces cmdr_lock with address_space->invalidate_lock in
> tcmu fault procedure, which will also make page-fault have concurrency.
> 

Page fault happens only once for each allocated data page. After the
page fault was processed, the page is re-used for many cmds without
further page faults.

Of course, if find_free_blocks released a page and tcmu after that
allocates a new one, another page fault will occur. But that is a
very rare case.

So, what is the advantage of concurrency here?

OTOH, I don't like the switch from tcmu's cmdr_lock to
filemap_invalidate_* without a real technical reason.


> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   drivers/target/target_core_user.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 9196188504ec..81bfa553cc67 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1820,13 +1820,14 @@ static int tcmu_find_mem_index(struct vm_area_struct *vma)
>   
>   static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>   {
> +	struct address_space *mapping = udev->inode->i_mapping;
>   	struct page *page;
>   
> -	mutex_lock(&udev->cmdr_lock);
> +	filemap_invalidate_lock_shared(mapping);
>   	page = xa_load(&udev->data_pages, dpi);
>   	if (likely(page)) {
>   		get_page(page);
> -		mutex_unlock(&udev->cmdr_lock);
> +		filemap_invalidate_unlock_shared(mapping);
>   		return page;
>   	}
>   
> @@ -1836,7 +1837,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>   	 */
>   	pr_err("Invalid addr to data page mapping (dpi %u) on device %s\n",
>   	       dpi, udev->name);
> -	mutex_unlock(&udev->cmdr_lock);
> +	filemap_invalidate_unlock_shared(mapping);
>   
>   	return NULL;
>   }
> @@ -3116,6 +3117,7 @@ static void find_free_blocks(void)
>   	loff_t off;
>   	u32 pages_freed, total_pages_freed = 0;
>   	u32 start, end, block, total_blocks_freed = 0;
> +	struct address_space *mapping;
>   
>   	if (atomic_read(&global_page_count) <= tcmu_global_max_pages)
>   		return;
> @@ -3139,6 +3141,8 @@ static void find_free_blocks(void)
>   			continue;
>   		}
>   
> +		mapping = udev->inode->i_mapping;
> +		filemap_invalidate_lock(mapping);
>   		end = udev->dbi_max + 1;
>   		block = find_last_bit(udev->data_bitmap, end);
>   		if (block == udev->dbi_max) {
> @@ -3146,6 +3150,7 @@ static void find_free_blocks(void)
>   			 * The last bit is dbi_max, so it is not possible
>   			 * reclaim any blocks.
>   			 */
> +			filemap_invalidate_unlock(mapping);
>   			mutex_unlock(&udev->cmdr_lock);
>   			continue;
>   		} else if (block == end) {
> @@ -3159,10 +3164,11 @@ static void find_free_blocks(void)
>   
>   		/* Here will truncate the data area from off */
>   		off = udev->data_off + (loff_t)start * udev->data_blk_size;
> -		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
> +		unmap_mapping_range(mapping, off, 0, 1);
>   
>   		/* Release the block pages */
>   		pages_freed = tcmu_blocks_release(udev, start, end - 1);
> +		filemap_invalidate_unlock(mapping);
>   		mutex_unlock(&udev->cmdr_lock);
>   
>   		total_pages_freed += pages_freed;
