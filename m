Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D3DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Mar 2022 12:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355682AbiCPMjz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 08:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355616AbiCPMjx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 08:39:53 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625675AEE5;
        Wed, 16 Mar 2022 05:38:38 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id pv16so3982118ejb.0;
        Wed, 16 Mar 2022 05:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=V/xuXZMvLzEz+kUXcEWQkJk+rkGlo0UTSV1jaYeStr0=;
        b=Hwl5ANWAhdTyv72tH7Kohng22ZlLzZ4EZUOHtak39urNrIZBj37QSl4vWB0VjD/R7i
         4wvQ6Z+7Dj42WJULFcy2Nt8S/6aU8czP71IIOcNxKPR0hIRCdds9msYBswqSKKE7pjky
         zeVxcgW2NPc7Ks0Ka8hrrqgKYN7QQGrK8WW3AJoz29o+XrDEFAKmKsKhRMeI7RoixTaK
         m2+y4QF2s3v9H+NQf4I7lCvMzBb0kHpY8Q3wseYbrFQ3Sof+UV/l2tIz0wiGV90hucy2
         ua19tVY/480Zu9vOEauODlF9rMsfECeiBs9Y+0JkAq6rxYErv7nhEjO0ybsG+PQ/3Wjq
         IQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V/xuXZMvLzEz+kUXcEWQkJk+rkGlo0UTSV1jaYeStr0=;
        b=XLW3aU4KgvMDJ1XzyBs2XFoi6J+s/Ht7NsXUjb8lfOluGhv1c5bBVzZl/ObGIPmVZd
         syMclZUgLTSQUu7Orn6m67P9vJbEN97ipNFdoxaPiiiKPwM7xJv/uX+w2C4LQy9GMtiw
         QN3HlZ8ydZnDoEczVsboWDhLbTMrMemcv9nR2znX321rvOBYY6grH7ths9V+UPpuxGti
         vW5bi7LzIfRH7XX6dAPTwnH+tiddaZ2imR3/hR0feAxvzSdqkMUZZnKfLEAzUcxfaLVM
         SPO6m2A00Fc0s0hWWPTeItqWwS2R2Snho4bECkDwq0ACKqH9vTE//rPYmNXGlNFe13UJ
         3Rfw==
X-Gm-Message-State: AOAM530eC8pszmHUFxeNGk3z/oRYPV9JEkapLTanU7+XX7h1+rsjjZWt
        2s7Xfb1OlCulcEksIhji/R1jGbxad6A=
X-Google-Smtp-Source: ABdhPJwjKgDhUALqnrGCbR3lmF0V4a7bQ2yKzdMDKKeqEDEC1zN4hH3mwnuB0cM8/6zU/HHa6B/wMA==
X-Received: by 2002:a17:907:a089:b0:6db:ef38:1a29 with SMTP id hu9-20020a170907a08900b006dbef381a29mr7875248ejc.269.1647434316361;
        Wed, 16 Mar 2022 05:38:36 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1fa42.dynamic.kabel-deutschland.de. [188.193.250.66])
        by smtp.gmail.com with ESMTPSA id r14-20020a05640251ce00b004186b7c1268sm889812edd.50.2022.03.16.05.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 05:38:36 -0700 (PDT)
Message-ID: <75409cc9-1e51-77d6-cbf2-6eccdbc53f1a@gmail.com>
Date:   Wed, 16 Mar 2022 13:38:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] scsi: target: tcmu: Fix possible page UAF
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220311132206.24515-1-xiaoguang.wang@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20220311132206.24515-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This one looks good. Thank you.

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>


On 11.03.22 14:22, Xiaoguang Wang wrote:
> tcmu_try_get_data_page() looks up pages under cmdr_lock, but it don't
> take refcount properly and just return page pointer.
> 
> When tcmu_try_get_data_page() returns, the returned page may have been
> freed by tcmu_blocks_release(), need to get_page() under cmdr_lock to
> avoid concurrent tcmu_blocks_release().
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   drivers/target/target_core_user.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 7b2a89a67cdb..06a5c4086551 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1820,6 +1820,7 @@ static struct page *tcmu_try_get_data_page(struct tcmu_dev *udev, uint32_t dpi)
>   	mutex_lock(&udev->cmdr_lock);
>   	page = xa_load(&udev->data_pages, dpi);
>   	if (likely(page)) {
> +		get_page(page);
>   		mutex_unlock(&udev->cmdr_lock);
>   		return page;
>   	}
> @@ -1876,6 +1877,7 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
>   		/* For the vmalloc()ed cmd area pages */
>   		addr = (void *)(unsigned long)info->mem[mi].addr + offset;
>   		page = vmalloc_to_page(addr);
> +		get_page(page);
>   	} else {
>   		uint32_t dpi;
>   
> @@ -1886,7 +1888,6 @@ static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
>   			return VM_FAULT_SIGBUS;
>   	}
>   
> -	get_page(page);
>   	vmf->page = page;
>   	return 0;
>   }
