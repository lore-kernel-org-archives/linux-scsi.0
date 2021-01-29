Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE4BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 03:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC2EB64DE9
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 03:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhA2DQl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 22:16:41 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:43346 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhA2DQk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 22:16:40 -0500
Received: by mail-pl1-f181.google.com with SMTP id 31so4483905plb.10;
        Thu, 28 Jan 2021 19:16:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gDBgruowPbxD5gxpyUbLRP7J45dUpLZjOstK4g+zCw0=;
        b=ekwQH4B2/K+z2xApZsRioz+QytwXe/NZWAiIr2eycdmuJE2I9JDRkSMLwcIa3J0hZp
         iJ3VF2HluyWuMPGy+vxI7hk3uALGCjfJPbYhNwXBg1jYyAP3Ur5qX3xYDGgS1S6ARzH1
         7JqllhisAdZHaaHWEdvAxO9byVwNVEul07ejPEOvOUTaAK/L5ZIwRhzmSk+SgskCAetN
         GlhYi/JxSzaQM+jRkgYntS1FIbg5EQKwB8c4d6SHBY2oNsETbQjpvhDBdFUVYCIBO5AC
         D7BBYffH53VxMdoNZK4Xnb28ExyHLcIZpFL1EEBucE1zuGfR+jY3uolPIZenmsvzYB8u
         X04g==
X-Gm-Message-State: AOAM5322qE1jYRZHW0PRn4juePx/jL1ffwpKJ1UEaV3+0YSHYfrHVtb0
        +5vvCUdR4nDgH1zkeP3u5eA3Cdr7aCw=
X-Google-Smtp-Source: ABdhPJx+KritiAwb0V42iVvyAmgk2Pxfn44xi8+9b2LOvWv+kygqhrOlr73s/6D6BrjJ1wYncrQYWg==
X-Received: by 2002:a17:90a:fc6:: with SMTP id 64mr2443280pjz.79.1611890159253;
        Thu, 28 Jan 2021 19:15:59 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:fd12:a590:9797:4acb? ([2601:647:4000:d7:fd12:a590:9797:4acb])
        by smtp.gmail.com with ESMTPSA id a31sm6899616pgb.93.2021.01.28.19.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 19:15:58 -0800 (PST)
Subject: Re: [PATCH v3 3/3] scsi: ufs: Fix wrong Task Tag used in task
 management request UPIUs
To:     Can Guo <cang@codeaurora.org>, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-4-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8351747f-0ec9-3c66-1bdf-b4b73fcee698@acm.org>
Date:   Thu, 28 Jan 2021 19:15:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1611807365-35513-4-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/21 8:16 PM, Can Guo wrote:
> In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs + req->tag as
> the Task Tag in one TMR UPIU. Directly use req->tag as the Task Tag.

Why is the current code wrong and why is this patch the proper fix?
Please explain this in the patch description.

> +	 * blk_get_request() used here is only to get a free tag.

Please fix the word order in this comment ("blk_get_request() is used
here only to get a free tag").

> +	ufshcd_release(hba);
>  	blk_put_request(req);
>  
> -	ufshcd_release(hba);

An explanation for this change is missing from the patch description.

Thanks,

Bart.
