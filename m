Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA05C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 14:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FC77613B0
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 14:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbhD3OaE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 10:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbhD3OaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2021 10:30:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34619C06174A;
        Fri, 30 Apr 2021 07:29:14 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y26so3242619eds.4;
        Fri, 30 Apr 2021 07:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lkzMRDz3EKi3qa9HUgoov0nFfmSvHU5WWdnRd2PhEfY=;
        b=Djek82IazPreK1nAfG7GyGE8CUKxRqOVvi0sX6P9Hki4Sdbox5lbWVWM8phK/zx8/E
         OA0mdloRD+8T6tARQ3cAieaThw7Ww2/vBYoUiwuyt24htWijgxFoNJ9QK3qbgb/hjKa8
         UkQJwAeJg9OlkvxpbIesRVHN5nIIZmgguDgTmHJY/FBp/8l3++32riFNcFlQJW/YFfTF
         ATBKorPWiOWguRvbKrojZZHwLg8rhCD2GcrgdLNm2ovwlOqL+pgRNgMf0ZqQWkaZupZQ
         n87N/3/5iPBXynK/k988PtaN9lViIq2DW3AGQn0ZrIeYiUkqHj6S/y2BYxmzitOjj/+X
         CKNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lkzMRDz3EKi3qa9HUgoov0nFfmSvHU5WWdnRd2PhEfY=;
        b=QbJclMcxfXWCn+mH/BXqM607nMlr5xaTealB/qqVRbWZXT552nW48bnbtPSH42lW8v
         Wi6JfyTQyDfmtuGcvE/JSgi+M2iWlLtdVs0cFBLiRiWvq7xdg/LdfETD2C39FQQDYeIg
         MheVG5Jf+Z585suy78VMy1HZHw9+Fw6y7QE6xhnv3dzkTTWLF8YaItRlGtLBFhIsnJpM
         CeWDUjgkEryH8NEKjEH2+0pgsAQ2dBjwq26S7APmj1Hzkd7PCGim8IWhcSUq6GmJw+fI
         HxIH9+FAPIIBle/iQ2bzHzRpXN7254mcgGmivavbb+xw6swZDJftZ0ZJZqlMpX0yNh6X
         7OSQ==
X-Gm-Message-State: AOAM531l4rPjClF8qejmf/vFBKL7N/3zRIyK7Oosc+G3VJMh6zqKo1Xk
        VTv+Mpu2fz4ATqnPwhUvF8jFSxObRsQ=
X-Google-Smtp-Source: ABdhPJyK6nisePrI1zhyReqfVdYYFwPRp5NNscbrAQ2ojGDNZdbHyjLPoxaXyaLnj7FAJt/MdPRmkg==
X-Received: by 2002:a05:6402:4d1:: with SMTP id n17mr6231689edw.118.1619792952913;
        Fri, 30 Apr 2021 07:29:12 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id p4sm2064792ejr.81.2021.04.30.07.29.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 07:29:12 -0700 (PDT)
Subject: Re: [PATCH] scsi: target: configfs: Remove redundant assignment to
 ret
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1619774627-118766-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <69ef77bd-4ef8-6446-8192-6d8569516f33@gmail.com>
Date:   Fri, 30 Apr 2021 16:29:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1619774627-118766-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30.04.21 11:23, Jiapeng Chong wrote:
> Variable ret is set to '-EINVAL' but this value is never read as it is
> overwritten later on, hence it is a redundant assignment and can be
> removed.
> 
> Clean up the following clang-analyzer warning:
> 
> drivers/target/target_core_configfs.c:2037:5: warning: Value stored to
> 'ret' is never read [clang-analyzer-deadcode.DeadStores].
> 
> drivers/target/target_core_configfs.c:1973:5: warning: Value stored to
> 'ret' is never read [clang-analyzer-deadcode.DeadStores].
> 
> drivers/target/target_core_configfs.c:1959:5: warning: Value stored to
> 'ret' is never read [clang-analyzer-deadcode.DeadStores].
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   drivers/target/target_core_configfs.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 4b2e493..bda05c3 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1956,7 +1956,6 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
>   				pr_err("APTPL metadata initiator_node="
>   					" exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
>   					PR_APTPL_MAX_IPORT_LEN);
> -				ret = -EINVAL;
>   				break;
>   			}
>   			break;
> @@ -1970,7 +1969,6 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
>   				pr_err("APTPL metadata initiator_isid"
>   					"= exceeds PR_REG_ISID_LEN: %d\n",
>   					PR_REG_ISID_LEN);
> -				ret = -EINVAL;
>   				break;
>   			}
>   			break;
> @@ -2034,7 +2032,6 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
>   				pr_err("APTPL metadata target_node="
>   					" exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
>   					PR_APTPL_MAX_TPORT_LEN);
> -				ret = -EINVAL;
>   				break;
>   			}
>   			break;
> 

I don't think storing -EINVAL in ret is wrong. But maybe the "break" in
the next line should better be "goto out"?

AFAICS, the "break" finally leads to calling
core_scsi3_alloc_aptpl_registration () despite a too long string in
i_port, isid or t_port. Is this behaviour intentional?

BTW: why is "initiator_sid" input handled as string?
core_scsi3_alloc_aptpl_registration later calls get_unaligned_be64 for
that string. I don't think this makes sense.

Finally, I think there is a possible memory leak. If the input written
to res_aptpl_metadata for example contains "initiator_sid=xxxxx" more
than once, a previously created string isid ("isid = match_strdup(args)")
is not freed before it is overwritten in the loop. The same is true for
all tokens handled with match_strdup.
