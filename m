Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D020C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 20:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3864A60F91
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 20:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbhHTU3f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 16:29:35 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:37430 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhHTU3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 16:29:34 -0400
Received: by mail-pf1-f175.google.com with SMTP id j187so9586993pfg.4;
        Fri, 20 Aug 2021 13:28:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ogitIb/6mweMXCH2NlhTgwt8WsoH/tHiqFYkiIn9jj0=;
        b=FWqhTubwrNHfp+Plo/AFyo7p7Nm0vMOwJbn9MckkOi0UHz8+a9b3Nf00z0GCSSUoFO
         YTCBxHTwwmLETpT34idkNB+cthmh38prpe52kZ2OPEVYTiPw36n7OEKj803BGDRjXJKw
         /el2aayV60MHN3k/R7Q9iF/WCDKVTHFu4PxjjbpVyfvD5Nrd97vem51CIYMuxKjkPiqK
         qMKgYmFl360CNkTKAPIR9U+gsZIv9K+zirED4fEhLj7yFM/i2nCtbdC+Y3KzFQTzzA2u
         /ViJgRfhr0EYIrYFjd2e7hqYp/Et30QzuQYz74PX93+Th0+1f2Kf8jBbjFcWIJHXibSK
         7BqQ==
X-Gm-Message-State: AOAM530viHt/taoZoH/AiCCayJEJTMhhNNVS+zXlMyQgD51wpvCzmlGf
        ZNbX/ARqk7oLnt/RjSofxh7xmRFRFLg=
X-Google-Smtp-Source: ABdhPJwS2FQDqWW4NPPxJrKP8DpI3pbaKAXquX1izGBmO3VN135FKNtVD8hOomVWII56mn+tarsWIg==
X-Received: by 2002:a65:644e:: with SMTP id s14mr20364529pgv.410.1629491335750;
        Fri, 20 Aug 2021 13:28:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ddfe:8579:6783:9ed8])
        by smtp.gmail.com with ESMTPSA id p18sm8964394pgk.28.2021.08.20.13.28.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 13:28:55 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: ufshpb: Fix possible memory leak
To:     keosung.park@samsung.com, ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20210820014624epcms2p6724e146ca1f93ba6eac5e7cf95d4cfd2@epcms2p6>
 <1891546521.01629427801384.JavaMail.epsvc@epcpadp3>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ca6e8507-743b-005a-faec-375d88d8aaf6@acm.org>
Date:   Fri, 20 Aug 2021 13:28:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1891546521.01629427801384.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/19/21 6:46 PM, Keoseong Park wrote:
> When HPB pinned region exists and mctx allocation for this region fails,
> memory leak is possible because memory is not released for the subregion
> table of the current region.
> 
> So, change to free memory for the subregion table of the current region.
> 
> Signed-off-by: Keoseong Park <keosung.park@samsung.com>
> ---
>   drivers/scsi/ufs/ufshpb.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 9acce92a356b..052f584c789a 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -1933,7 +1933,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
>   		if (ufshpb_is_pinned_region(hpb, rgn_idx)) {
>   			ret = ufshpb_init_pinned_active_region(hba, hpb, rgn);
>   			if (ret)
> -				goto release_srgn_table;
> +				goto release_current_srgn_table;
>   		} else {
>   			rgn->rgn_state = HPB_RGN_INACTIVE;
>   		}
> @@ -1944,6 +1944,9 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
>   
>   	return 0;
>   
> +release_current_srgn_table:
> +	kvfree(rgn_table[rgn_idx].srgn_tbl);
> +
>   release_srgn_table:
>   	for (i = 0; i < rgn_idx; i++)
>   		kvfree(rgn_table[i].srgn_tbl);

'rgn_table' is allocated with kvcalloc() so please merge the new kvfree() statement
with the for-loop below it.

There is another improvement that can be made in this function: hpb->rgn_tbl
is not cleared in the error path. I propose to move the "hpb->rgn_tbl = rgn_table"
assignment from the start of the function to just above the "return 0" statement.

Thanks,

Bart.


