Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A697C4743C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 17:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E0BB6108E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Jun 2021 17:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhFURX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Jun 2021 13:23:59 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:46845 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhFURX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2021 13:23:59 -0400
Received: by mail-pg1-f173.google.com with SMTP id n12so5977140pgs.13;
        Mon, 21 Jun 2021 10:21:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jdM7XKHOAQLxQFfPPiLniwIfN+StnwxERiS4QoPrq5I=;
        b=O4bmeDR+T4+/07eJU0ghCqpJ/3klvIM+CcthtzJ8ARlwdRmeFHprLdY/wOsGSAS7Rz
         kiyS9Q2gH6lQJEMolplA3FKq1z9qPAR5AqkgweE4x5/+0Mvq1IRnKACP2/m2EdHMcHXC
         JrOyDG9noyw7dGrUKr9ymRH6Wgn3xTW4Lh76Qbfb3FmuQGCZoJpbno3REZ3K564JXwZD
         qHV6NrtP7RK5hK8iO83M6VoBZ1CkHbyudH55Lpujjh80ElstT5urW0eR/wTshA1JCmpI
         aFMM5Fx/pEq5nKowhimC2xQS0+/q1Xav+OXDs279/weNmOMVdtRdu8sPC+A6j0Tt5b/O
         QNPw==
X-Gm-Message-State: AOAM533V8FlmbPGUnxfFHR9G1kK2Ro5IoKkqaIZANJzymmh6nw89TnLG
        lmYfViqke7P/+h3WDFHIoz8FyqYps54=
X-Google-Smtp-Source: ABdhPJxRWaolPFUW4jKi81xnDrMwu27FZyWeWiXE2ub6czWwgfHEs1avOBWp2xQieZ6fjEhslj8RXQ==
X-Received: by 2002:a65:438c:: with SMTP id m12mr25154756pgp.425.1624296104130;
        Mon, 21 Jun 2021 10:21:44 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n23sm16457401pff.93.2021.06.21.10.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 10:21:43 -0700 (PDT)
Subject: Re: [PATCH] scsi: remove reduntant assignment when alloc sdev
To:     Ed Tsai <ed.tsai@mediatek.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210621034555.4039-1-ed.tsai@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9e1d5f1f-b51e-8f1a-d052-d6debed116e6@acm.org>
Date:   Mon, 21 Jun 2021 10:21:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210621034555.4039-1-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/20/21 8:45 PM, Ed Tsai wrote:
> sdev->reqeust_queue and its queuedata have been set up in
> scsi_mq_alloc_queue(). No need to do that again.
> 
> Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
> ---
>  drivers/scsi/scsi_scan.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 12f54571b83e..82c1792f1de2 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -266,8 +266,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  	 */
>  	sdev->borken = 1;
>  
> -	sdev->request_queue = scsi_mq_alloc_queue(sdev);
> -	if (!sdev->request_queue) {
> +	if (!scsi_mq_alloc_queue(sdev)) {
>  		/* release fn is set up in scsi_sysfs_device_initialise, so
>  		 * have to free and put manually here */
>  		put_device(&starget->dev);
> @@ -275,7 +274,6 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  		goto out;
>  	}
>  	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
> -	sdev->request_queue->queuedata = sdev;
>  
>  	depth = sdev->host->cmd_per_lun ?: 1;

Since scsi_mq_alloc_queue() only has one caller, please inline
scsi_mq_alloc_queue() instead of making this change. See also
https://lore.kernel.org/linux-scsi/20201123031749.14912-5-bvanassche@acm.org/

Thanks,

Bart.
