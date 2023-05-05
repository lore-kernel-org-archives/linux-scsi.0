Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4042C77B7C
	for <linux-scsi@archiver.kernel.org>; Fri,  5 May 2023 20:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjEEUgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 May 2023 16:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjEEUgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2023 16:36:08 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9725349D2
        for <linux-scsi@vger.kernel.org>; Fri,  5 May 2023 13:36:03 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-24e4e23f378so1637736a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 05 May 2023 13:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683318963; x=1685910963;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7GAG14JDBz5OS3xBcFkRIfMhJwMwOZg74Hsq79gcl8A=;
        b=fTOpw0SDOWggy/iHZSG5icIZxiQ71ypZZtD108L+/IgHeINoBf2eqicDLMfBCABmN1
         d8ja1+8Ge8dWX3eIjRUYlgaeV4pgHk8aCFxtGhyku17NhDRdP5XVc9/t1T+2njnqCLaa
         SXdt9lrD2l7RiqBp3Y64vWC880hoSWEs1BA/MYgJ4E5YLr8TlGJSgT1qIq48h2RkoSOL
         VCMO5rTBtC+lkdXxdMWEneA0HFRXKJSE5zocSOD4T51Dw7AZKw03fcR0UAWHY8nhrrub
         NTWZqcBScUI6Uu5D33EGWn5ChPWKmuhM9QY/J/1+Mr0ZgcRp1C1IiqJcp9ik8WTncSCj
         HJKQ==
X-Gm-Message-State: AC+VfDyXMXKTNII7rtXvCaWGaofyREGBiR3cULS0gRa0oXUY+HnW3D+3
        ZR1aB4gaae8BnFSP8m/9idU=
X-Google-Smtp-Source: ACHHUZ5Mviic0liFhqeQ8HyeO2pQzPilPWRpMhyTvdO5+URXPmNX+GqzB5vJqH7G+HvYXmAVX0KbmA==
X-Received: by 2002:a17:90a:ca08:b0:24e:bb9:e4e6 with SMTP id x8-20020a17090aca0800b0024e0bb9e4e6mr2773218pjt.28.1683318962944;
        Fri, 05 May 2023 13:36:02 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:127d:5561:7469:3abc? ([2620:15c:211:201:127d:5561:7469:3abc])
        by smtp.gmail.com with ESMTPSA id o3-20020a17090ad24300b00246be20e216sm5415829pjw.34.2023.05.05.13.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 May 2023 13:36:02 -0700 (PDT)
Message-ID: <3e19851c-34c1-88fd-119a-e5a4da3f2dbf@acm.org>
Date:   Fri, 5 May 2023 13:36:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v2 1/2] scsi: core: Introduce the BLIST_BROKEN_FUA flag
Content-Language: en-US
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
References: <20230202220041.560919-1-bvanassche@acm.org>
 <20230202220041.560919-2-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230202220041.560919-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/2/23 14:00, Bart Van Assche wrote:
> UFS devices perform better when using SYNCHRONIZE CACHE command instead of
> the FUA flag. Introduce the BLIST_BROKEN_FUA flag for using SYNCHRONIZE
> CACHE instead of FUA.
> 
> The BLIST_BROKEN_FUA flag can be set by using one of the following
> approaches:
> * From user space, by writing into /proc/scsi/device_info.
> * From the kernel, by setting sdev_bflags from the slave_alloc callback.
> 
> For a prior version of this patch, see also
> https://lore.kernel.org/lkml/YpecaXfIxZBHIcfj@google.com/T/
> 
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: Asutosh Das <quic_asutoshd@quicinc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_scan.c    | 3 +++
>   include/scsi/scsi_devinfo.h | 4 +++-
>   2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index a62925355c2c..c1eb6bfe7ed2 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1020,6 +1020,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	if (*bflags & BLIST_NO_RSOC)
>   		sdev->no_report_opcodes = 1;
>   
> +	if (*bflags & BLIST_BROKEN_FUA)
> +		sdev->broken_fua = 1;
> +
>   	/* set the device running here so that slave configure
>   	 * may do I/O */
>   	mutex_lock(&sdev->state_mutex);
> diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
> index 5d14adae21c7..783451dfa46e 100644
> --- a/include/scsi/scsi_devinfo.h
> +++ b/include/scsi/scsi_devinfo.h
> @@ -68,8 +68,10 @@
>   #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
>   /* Always retry ABORTED_COMMAND with ASC 0xc1 */
>   #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
> +/* Use SYNCHRONIZE CACHE instead of FUA */
> +#define BLIST_BROKEN_FUA	((__force blist_flags_t)(1ULL << 34))
>   
> -#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
> +#define __BLIST_LAST_USED BLIST_BROKEN_FUA
>   
>   #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
>   			       (__force blist_flags_t) \

(replying to an email from two months ago)

I plan to repost the above patch because this patch will allow us to set the
broken_fua flag from user space. Please let me know if there are any objections
or concerns.

Thanks,

Bart.
