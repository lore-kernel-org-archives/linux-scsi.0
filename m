Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24837C636D7
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 20:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjBBU0F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 15:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjBBUZl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 15:25:41 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6C870D4C
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 12:25:33 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m11so3028988pji.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 12:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9J0utFsWgEaSXGaB/NZTOm15TJEdUPOpYGgYNlrsQN4=;
        b=eDI5P5tugBKMrVegwsr2+7uvCpX4p9i3SavPHUAKx7lXKtETXaw17Kzuo33t7GMpGq
         NhnT51qm255vuT3fdqx5JBuM60LOzgH/V+LEFakR4BbsmQn1kVWaDZgbthKV4NYKIIX3
         yByan+osXsca5alhgjK9L6C7nhpx5V4z0fXIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9J0utFsWgEaSXGaB/NZTOm15TJEdUPOpYGgYNlrsQN4=;
        b=i/hfR94ZK5AxEP3RXD2rl7pF8M+uMu6xxOqR3kXfvLrGlJcUwyBZ7pNFzm81mrTDBL
         Eg2zvboDXUQZ8zDEckCdMmAcnfAjJe6qOStFkM+Jn97Nh2iyO4RGji8lrXzhdvkQ/FLM
         KrBMe/LpqBmgKLpllIQwf2HQ9Z9hS+hRmpdH08UT4XcJckvcwNG7XvNLt6s+mhcSI/Px
         6uvTp05nb0WEhcsDSqYDjxYSYP+nLlg/6cLtPqpQwHPkScNsiWV30AgY3KxbuZjsyAOP
         EBW4TTnXWSh9Hg2C1p3ZdgpoKWSpBq/Ik2rUmFR/xYc4jJaVid/Dv2btjQn2bMz89ijn
         kE7Q==
X-Gm-Message-State: AO0yUKWaV0ZmmkBSdqzR4sO9GpTJ02HuYzEekNFjJAHhk8wiO27A6Ydn
        KlS8/I+l68DcCh3OvGBHvVK7tA3PocnTxX8q
X-Google-Smtp-Source: AK7set/Gj9diS4RbvFVs4BCq0lJ2WvfL0Ul+WLETpp9VqPI9Gp4edNqjocLLzOay2r1rGI0AADRnBg==
X-Received: by 2002:a17:903:24f:b0:196:3db5:c08b with SMTP id j15-20020a170903024f00b001963db5c08bmr8867242plh.69.1675369532929;
        Thu, 02 Feb 2023 12:25:32 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ix19-20020a170902f81300b00186c5e8a8d7sm74599plb.171.2023.02.02.12.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 12:25:32 -0800 (PST)
Message-ID: <63dc1c3c.170a0220.9d837.03a1@mx.google.com>
X-Google-Original-Message-ID: <202302022024.@keescook>
Date:   Thu, 2 Feb 2023 20:25:31 +0000
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Kevin Barnett <kevin.barnett@microsemi.com>,
        Don Brace <don.brace@microchip.com>, storagedev@microchip.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/3][next] scsi: smartpqi: Replace one-element array with
 flexible-array member
References: <cover.1663816572.git.gustavoars@kernel.org>
 <c80c0979933e0c05e80d95792ef167a28640a14b.1663816572.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c80c0979933e0c05e80d95792ef167a28640a14b.1663816572.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 21, 2022 at 11:28:35PM -0500, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct MR_DRV_RAID_MAP and refactor the the rest of the code
> accordingly.
> 
> It seems that the addition of sizeof(struct report_log_lun) in all the
> places that are modified by this patch is due to the fact that
> the one-element array struct report_log_lun lun_entries[1]; always
> contributes to the size of the containing structure struct
> report_log_lun_list.
> 
> Notice that at line 1267 while allocating memory for an instance of
> struct report_log_lun_list, some _extra_ space seems to be allocated
> for one element of type struct report_log_lun, which is the type of
> the elements in array lun_entries:
> 
>  1267         internal_logdev_list = kmalloc(logdev_data_length +
>  1268                 sizeof(struct report_log_lun), GFP_KERNEL);
> 
> However, at line 1275 just logdev_data_length bytes are copied into
> internal_logdev_list (remember that we allocated space for logdev_data_length +
> sizeof(struct report_log_lun) bytes at line 1267), and then exactly
> sizeof(struct report_log_lun) bytes are being zeroing out at line 1276.
> 
>  1275         memcpy(internal_logdev_list, logdev_data, logdev_data_length);
>  1276         memset((u8 *)internal_logdev_list + logdev_data_length, 0,
>  1277                 sizeof(struct report_log_lun));
> 
> All the above makes think that it's just fine if we transform array
> lun_entries into a flexible-array member and just don't allocate
> that extra sizeof(struct report_log_lun) bytes of space. With this
> we can remove that memset() call and we also need to modify the code
> that updates the total length (internal_logdev_list->header.list_length)
> of array lun_entries at line 1278:
> 
>  1278         put_unaligned_be32(logdev_list_length +
>  1279                 sizeof(struct report_log_lun),
>  1280                 &internal_logdev_list->header.list_length);
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE routines
> on memcpy().
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/204
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> And of course, it'd be great if maintainers can confirm what I described
> in the changelog text. :)
> 
>  drivers/scsi/smartpqi/smartpqi.h      |  2 +-
>  drivers/scsi/smartpqi/smartpqi_init.c | 10 +++-------
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
> index e550b12e525a..d1756c9d1112 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -954,7 +954,7 @@ struct report_log_lun {
>  
>  struct report_log_lun_list {
>  	struct report_lun_header header;
> -	struct report_log_lun lun_entries[1];
> +	struct report_log_lun lun_entries[];
>  };
>  
>  struct report_phys_lun_8byte_wwid {
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index b971fbe3b3a1..544cd18a90d7 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -1264,8 +1264,7 @@ static int pqi_get_device_lists(struct pqi_ctrl_info *ctrl_info,
>  	logdev_data_length = sizeof(struct report_lun_header) +
>  		logdev_list_length;
>  
> -	internal_logdev_list = kmalloc(logdev_data_length +
> -		sizeof(struct report_log_lun), GFP_KERNEL);
> +	internal_logdev_list = kmalloc(logdev_data_length, GFP_KERNEL);
>  	if (!internal_logdev_list) {
>  		kfree(*logdev_list);
>  		*logdev_list = NULL;
> @@ -1273,11 +1272,8 @@ static int pqi_get_device_lists(struct pqi_ctrl_info *ctrl_info,
>  	}
>  
>  	memcpy(internal_logdev_list, logdev_data, logdev_data_length);
> -	memset((u8 *)internal_logdev_list + logdev_data_length, 0,
> -		sizeof(struct report_log_lun));
> -	put_unaligned_be32(logdev_list_length +
> -		sizeof(struct report_log_lun),
> -		&internal_logdev_list->header.list_length);
> +	put_unaligned_be32(logdev_list_length,
> +			   &internal_logdev_list->header.list_length);

This is a bit of a twisty maze to read through, but at the end, I agree
with your assessment: it was needlessly added the extra member to the
allocation. I don't see it used anywhere in later code -- it's always
bounded by logdev_list_length.

Reviewed-by: Kees Cook <keescook@chromium.org>

>  
>  	kfree(*logdev_list);
>  	*logdev_list = internal_logdev_list;
> -- 
> 2.34.1
> 

-- 
Kees Cook
