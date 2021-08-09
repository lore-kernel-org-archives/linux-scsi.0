Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65F8C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 21:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0D9B60F55
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 21:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhHIVzR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 17:55:17 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:44732 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbhHIVzO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 17:55:14 -0400
Received: by mail-pj1-f54.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so2150440pjb.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 14:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RsbH6hNJKgrN0N0H489rvY2vgVNtuUkgFX4Yks4y0ec=;
        b=l6rn0FxFYswWsA8AhtoUOgg3peTGaDoARZ05gBS+x2t/H4b8WKtWpv39IA7DdH4Y2t
         S1uanTr+Lq+IiEyQiRsNV19kBZ7TVG9xu+wrQaaf29dSHPVoWZSwLLwNgU5FKAOQhzvY
         guNA/MK9RJJ47NehG6gAbw02QQ+oxFbPNDfLJtZfMtZzEZhTYMqk+VaxkUeiMkfy563+
         IMLz9rcljoHrOM+whu503jUb5e9W2GUtjLIanqJKnMFyAqj8ugmDX8VTry7mg1Nb6DhK
         5vjEng63Wi5DdUS1p+Ydo1ywBAU3vlJNpmp9Lq5qrMCHJ3hIYFPn2zsT8fVRlBhymol7
         rqIA==
X-Gm-Message-State: AOAM530jSDcraZtqTWHIEPY4s2IZoDeyGif/Z3rBSX3+1+M6M7k/RDS2
        dMIJT8D3DyI0wBJzCl/m/036368YfFs=
X-Google-Smtp-Source: ABdhPJzRxAbq63zM9Xb1dD//m1j8xT6MpruinhnnsXUQNJ8OTmZatN/3HXlKws5Cu+JbLq72thYSWA==
X-Received: by 2002:a62:dd57:0:b029:3cd:c96e:625e with SMTP id w84-20020a62dd570000b02903cdc96e625emr830394pff.45.1628546093206;
        Mon, 09 Aug 2021 14:54:53 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:7dd4:e46e:368b:7454? ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id w186sm9957955pfw.78.2021.08.09.14.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 14:54:52 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] scsi: core: Add helper to return number of logical
 blocks in a request
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210806040023.5355-1-martin.petersen@oracle.com>
 <20210806040023.5355-2-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <88c5ecd4-7020-5eaa-65cc-b105b850a1e5@acm.org>
Date:   Mon, 9 Aug 2021 14:54:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210806040023.5355-2-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/21 9:00 PM, Martin K. Petersen wrote:
> Cc: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  include/scsi/scsi_cmnd.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 90da9617d28a..804b2b33da4a 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -232,6 +232,13 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
>  	return blk_rq_pos(scmd->request) >> shift;
>  }
>  
> +static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
> +{
> +	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
> +
> +	return blk_rq_bytes(scmd->request) >> shift;
> +}

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
