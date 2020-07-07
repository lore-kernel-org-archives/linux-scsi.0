Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86372C433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 17:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60B462065F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 17:00:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BHX0Pfz5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgGGRAW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 13:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgGGRAV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 13:00:21 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9577C061755
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 10:00:20 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z2so23704886wrp.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=RUaEwyKvFjoxearYOG6fMQLvpfWQmIWguMJ3lRmxBVw=;
        b=BHX0Pfz5ri1Yh4Zy3V9YuC2N1RtNm45e9Ar7i578AOR1KRiV5jYkft9+A766/PAQ2c
         BXsRdtubnvJ4IEC5r++wfb7GHwWVhOEbTT17AFkiRPQhCD+yCI38G7MKFPZZWxzqkW1X
         LLwTYDap24JWG+LLnP6MJSaTo0jt968sPzeiw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RUaEwyKvFjoxearYOG6fMQLvpfWQmIWguMJ3lRmxBVw=;
        b=KDphiV2VyIE/IzooXRjsNHi96hG+LGPL8dqBrEqtaQ2bn5CJGtyBRcRjIAY6M0NWov
         6Y/RmUJAc84RsMK1bqTyucBWksmC7CI4G3a0g4SyiG0FB5cTO+faYBPbobj0RXLsDLYq
         Ex5zQchZc6uSQXWS1NYE7I/OMRRCvjeA99WNZhOWeUT91REu5lgupwORY9HmrgznW3lV
         pi8d9qAEnqT31SUlTQAIQVkeonIGOGXuM1D3qZd9f+gjZRueixWHTG2SalcYsOi8sFyk
         EL2YIDUc9dY2hzwKf7IRDXqWZ9czs5yqd/KCdQNnmenl7YxNu1S8EJtt5TN5hvdZiDYL
         nqng==
X-Gm-Message-State: AOAM530QvVvSXY1c6dOpr+Sw1VrhumYVYIbWjqysPCGl6QjrPy8bwP++
        F8oRPETDd8tvdsp60qXiekYDfw==
X-Google-Smtp-Source: ABdhPJwLbfD6yQlRb8xFVABJpE3v8ufetL+QEFMMaNpg6b6pRNGIoB3Ta6t6OvScYlvpaZ5fGrzoWw==
X-Received: by 2002:adf:f54b:: with SMTP id j11mr55222080wrp.206.1594141219553;
        Tue, 07 Jul 2020 10:00:19 -0700 (PDT)
Received: from [192.168.1.237] (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id w2sm1669608wrs.77.2020.07.07.10.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 10:00:18 -0700 (PDT)
Subject: Re: [PATCH][next] scsi: lpfc: fix inconsistent indenting
To:     Colin King <colin.king@canonical.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200707150018.823350-1-colin.king@canonical.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <e4686e05-e06e-93d1-e332-f6403b7eab9b@broadcom.com>
Date:   Tue, 7 Jul 2020 10:00:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707150018.823350-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/7/2020 8:00 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Fix smatch warning:
> drivers/scsi/lpfc/lpfc_sli.c:15156 lpfc_cq_poll_hdler() warn: inconsistent
> indenting
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index e17675381cb8..92fc6527e7ee 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -15153,7 +15153,7 @@ static int lpfc_cq_poll_hdler(struct irq_poll *iop, int budget)
>   {
>   	struct lpfc_queue *cq = container_of(iop, struct lpfc_queue, iop);
>   
> -	 __lpfc_sli4_hba_process_cq(cq, LPFC_IRQ_POLL);
> +	__lpfc_sli4_hba_process_cq(cq, LPFC_IRQ_POLL);
>   
>   	return 1;
>   }

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james

