Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFF7C4708D
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Dec 2022 23:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiLGXgq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 18:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiLGXgi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 18:36:38 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A9F8AAE5;
        Wed,  7 Dec 2022 15:36:38 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id b11so3988pjp.2;
        Wed, 07 Dec 2022 15:36:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=28j9Rm4k0JPlYGD++Tk9QsIQ3Lzb/Vnp+mpd/Qgtdik=;
        b=ivw5H2WF+ZPQJPqelUtIagF017Dj7WcOcJOj3sH+tIV6R2gTw0TkJhUfiEyA1H7Kcy
         kCb0+OynL+4V2B3XAQmUXeHFuuVlqIqeeBrywyT0trJa3MRsyZm/rYl0pf4VzHr5FyDU
         3ExDRLWJYb8zk5Y+mkiejWvvH89ykG+GCqoTGgl6hH+ibGSb6ErvQDzX93zy9tuWAsgI
         Ld7MQxQgl+qqFAAefK1iiK0lTYk3VkDXiReYBtiY9JSYaWUfLX10Y93PrYZpmZFBp5/p
         NlqVdloSWApRSY8xFcc73WQZ8HBO6FVm0vb7siTjq7wpPTCiGMIKNzwXmZkziQjvpcw4
         OCUg==
X-Gm-Message-State: ANoB5plCL+gJIKsThotGQnJNrnqvGj0I/S5Nraslgb/A1fF92G8olfWV
        6NsBcZkuoc2pq+0E3lepigc=
X-Google-Smtp-Source: AA0mqf6KLxkPVpHRY1K6gFdYuMgrL8YNpUQ8XPtzPz/k6OIcTjfnvQkwjMiMw2gxWXyiA5s/0s52zA==
X-Received: by 2002:a17:90b:2642:b0:219:55d5:f30a with SMTP id pa2-20020a17090b264200b0021955d5f30amr43860335pjb.23.1670456197478;
        Wed, 07 Dec 2022 15:36:37 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id p4-20020a654bc4000000b004774b5dc24dsm11717705pgr.12.2022.12.07.15.36.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 15:36:36 -0800 (PST)
Message-ID: <e99e929b-c26e-36eb-3254-d0ec58599e6a@acm.org>
Date:   Wed, 7 Dec 2022 15:36:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 2/4] ufs: core: Remove redundant desc_size variable
 from hba
Content-Language: en-US
To:     Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        martin.petersen@oracle.com
Cc:     beanhuo@micron.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1669550910-9672-1-git-send-email-Arthur.Simchaev@wdc.com>
 <1669550910-9672-3-git-send-email-Arthur.Simchaev@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1669550910-9672-3-git-send-email-Arthur.Simchaev@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/27/22 04:08, Arthur Simchaev wrote:
> Always read the descriptor with QUERY_DESC_MAX_SIZE.
> According to the spec, the device returns the actual size
> 
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Signed-off-by: Arthur Simchaev <Arthur.Simchaev@wdc.com>
> ---
>   drivers/ufs/core/ufshcd.c | 53 +++++++++++++----------------------------------
>   include/ufs/ufs.h         |  1 -
>   include/ufs/ufshcd.h      |  1 -
>   3 files changed, 14 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 2e47c69..70e96b6 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -3377,28 +3377,11 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
>   void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
>   				  int *desc_len)
>   {
> -	if (desc_id >= QUERY_DESC_IDN_MAX || desc_id == QUERY_DESC_IDN_RFU_0 ||
> -	    desc_id == QUERY_DESC_IDN_RFU_1)
> -		*desc_len = 0;
> -	else
> -		*desc_len = hba->desc_size[desc_id];
> +	/*Always returns QUERY_DESC_MAX_SIZE*/
> +	*desc_len = QUERY_DESC_MAX_SIZE;
>   }
>   EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);

Comments should explain something that is nontrivial instead of duplicating the
code. Additionally, this change makes ufshcd_map_desc_id_to_length() too short
too keep it as a function. Please remove this function entirely and insert the
following code into the callers of this function:

desc_len = QUERY_DESC_MAX_SIZE

Thanks,

Bart.

