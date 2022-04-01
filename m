Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCAEAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 19:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348109AbiDATrG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 15:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiDATrF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 15:47:05 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7551C7E8D;
        Fri,  1 Apr 2022 12:45:15 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id lr4so7915459ejb.11;
        Fri, 01 Apr 2022 12:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=za9KUI6E0h0+iOOZ9YZUkuiVDxEd/EYNTQaCrCuHlIk=;
        b=jOjahhhPgR8LkWqehT0LCsfQfqHEaSJ+ZbKaU+XBBvUMqaFji5INp1QQtFnBhEIwLc
         V6bVlTbRTw3sXiw7rvfcAYbdWgnbm6ZlJbkYGcYO2BQLdv6mqteVkH6VOA/iVJP6oxSw
         oqeSPRcrGgXWlV+X508p7OTyUzB/SMRNMdg2SACqA9CxsLWavEUEBjg1jTDuyI1n1gnx
         UMp+opoEpK1tvF3Mt/6mezx9B24Urrh7ZmnrKN02rC1ijTIJqDJdToP5wl2vy4/zTWMJ
         +pQ5VPEcqCVkVW9xXuOP5xbLb5vbr8v0guIZOxsoRVZ0d/bvWmOqj2QepoooxjGN/6rX
         /vmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=za9KUI6E0h0+iOOZ9YZUkuiVDxEd/EYNTQaCrCuHlIk=;
        b=tfkrY4Zq1qctgpsWQCFpZC1HAOaIgd4iPE79ia9920HGLKtKV1Ne5xQB++ZLIm4csK
         nvzjLBP4tCv5uqkHRH3HUZGBHrAJm56xMcFEDqcGaOmNvpy+4Gv0tVINx3/XwN806VGK
         xsb4rbuZPzU/P+nvxqPj525jWfKG0YQNFJkeJrTuTbUuQO5rh3vlKUq5zo1ZVEJn3acc
         ntSvbEdXi8Y9cZNwFdrMvQtCHh1zEP/LC7Z9Zz39R13Q+EBKdwaBCd8diJUVNRn+TT8J
         XaYsptOD2bHeM6znLa2UyhpyuM9sBgIevaMabYgWGS6QwgXWpHIyZQ/9bqZZmd+U7wnP
         Ps3A==
X-Gm-Message-State: AOAM532VBHT3d8jRw1ZQi35V3OzaWnJmcqPRQa0vehLRmIiv0OMqC7Qn
        zsypascOoYj6e7zfBtzFS7bq+omijZM=
X-Google-Smtp-Source: ABdhPJwl58lY10kC+WzdWhQzFSi9B1p/xdoatn4AW1ENO1ORUomY6mvGAv1pviKqfNxA4RSC3gEH0Q==
X-Received: by 2002:a17:906:58cb:b0:6df:f696:9b32 with SMTP id e11-20020a17090658cb00b006dff6969b32mr1240717ejs.384.1648842313593;
        Fri, 01 Apr 2022 12:45:13 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc1cfad.dynamic.kabel-deutschland.de. [188.193.207.173])
        by smtp.gmail.com with ESMTPSA id o5-20020a170906974500b006dfc781498dsm1357626ejy.37.2022.04.01.12.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 12:45:12 -0700 (PDT)
Message-ID: <b6280955-d3f5-f11b-5f62-07ab83cff4ac@gmail.com>
Date:   Fri, 1 Apr 2022 21:45:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/3] scsi: target: tcmu: Fix possible data corruption
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20220323134940.31463-1-xiaoguang.wang@linux.alibaba.com>
 <20220323134940.31463-3-xiaoguang.wang@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <20220323134940.31463-3-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23.03.22 14:49, Xiaoguang Wang wrote:
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
> reuse the corresponding slot to previous page in data_bitmap, then thouth
> we'll allocate new page for this slot in data_area, but no page fault will
> happen again, because we have a valid map, real request's data will lose.

I don't think, this is a safe fix. It is possible that not only
find_free_blocks runs before page fault procedure completes, but also
allocation for next cmd happens. In that case the new call to
unmap_mapping_range would also happen before page fault completes ->
data corruption.

AFAIK, no one ever has seen this this bug in real life, as
find_free_blocks only runs seldomly and userspace would have to access
a data page the very first time while the cmd that owned this page
already has been completed by userspace. Therefore I think we should
apply a perfect fix only.

I'm wondering whether there really is such a race. If so, couldn't the
same race happen in other drivers or even when truncating mapped files?


> 
> To fix this issue, when extending dbi_thresh, we'll need to call
> unmap_mapping_range() to unmap use space data area which may exist,
> which I think it's a simple method.
> 
> Filesystem implementations will also run into this issue, but they
> ususally lock page when vm_operations_struct->fault gets one page, and
> unlock page after finish_fault() completes. In truncate sides, they
> lock pages in truncate_inode_pages() to protect race with page fault.
> We can also have similar codes like filesystem to fix this issue.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   drivers/target/target_core_user.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 06a5c4086551..9196188504ec 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -862,6 +862,7 @@ static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>   	if (space < cmd->dbi_cnt) {
>   		unsigned long blocks_left =
>   				(udev->max_blocks - udev->dbi_thresh) + space;
> +		loff_t off, len;
>   
>   		if (blocks_left < cmd->dbi_cnt) {
>   			pr_debug("no data space: only %lu available, but ask for %u\n",
> @@ -870,6 +871,10 @@ static int tcmu_alloc_data_space(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>   			return -1;
>   		}
>   
> +		off = udev->data_off + (loff_t)udev->dbi_thresh * udev->data_blk_size;
> +		len = cmd->dbi_cnt * udev->data_blk_size;
> +		unmap_mapping_range(udev->inode->i_mapping, off, len, 1);
> +
>   		udev->dbi_thresh += cmd->dbi_cnt;
>   		if (udev->dbi_thresh > udev->max_blocks)
>   			udev->dbi_thresh = udev->max_blocks;
