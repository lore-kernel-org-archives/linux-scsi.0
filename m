Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E95C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 23:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F3721A49
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 23:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AmXF4ltE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbfKEXhP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 18:37:15 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45290 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbfKEXhP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 18:37:15 -0500
Received: by mail-wr1-f66.google.com with SMTP id q13so23560533wrs.12
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 15:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=MSS+88k1JSwLBpqhNJjcWRtl4iuzzI1ntwWqqNm+MzE=;
        b=AmXF4ltEw/QYanJ2I0W1S8wm8VdLrAg2rVEDBnuKfbHkenBoAe6dr09yyD3Svw3Lq4
         eCaOhV9aopc+slhkBSrZBENr3SDZYNiJxOZaWy3FcOMZOY+P2FrBNiF1ENBQUVC9Hl3O
         LVGHtOn3Y3pQKB7/DaOfEjACVMyrNZ+521bxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MSS+88k1JSwLBpqhNJjcWRtl4iuzzI1ntwWqqNm+MzE=;
        b=I3vi9enHL2k3WK9ugriRXzRFqb7/+dpnWB/0MWtfkA39LlWMmsOYBCHly6xl3iNMAP
         /+SoMTc+WaqWB2woCCddlDBHMryoyJyPFCDE09UFNSoADkT8EvZs3nsCX7EZd69c78I4
         JKtkT4SrRqrrwrVzVhU9fg7OO2CCE10TE8161T47e21d+4kJcIlG4maaYAJ4td0UTwJL
         mkiJIzWT4ZQUBJYOTPtoXWws2irbW/QQ1mmo3lyiwlr3DuYYdTO/W01dtccurhclu5+O
         u4W+wb50lfPamvytTXVdJHBmTifWLsGSxSV+XzzZoI/IC40mEVsN09ukQ5fgjG6Tx2cQ
         oK8Q==
X-Gm-Message-State: APjAAAX5CPlBSaTzMxUbrJ016+hVD8axPm8LX9n2Hee/QElvF7FOnTuc
        uZtMd5Q6d6UUgPsw6FvLeX/Y4g==
X-Google-Smtp-Source: APXvYqxU0L2iDtjzr5Q2TUCwgyVNOwh81CM4hx0jvN9J6rt0viT04GIFSweHkXJL9+awyBMfDLYivw==
X-Received: by 2002:a5d:4688:: with SMTP id u8mr13183228wrq.40.1572997032818;
        Tue, 05 Nov 2019 15:37:12 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x8sm15640827wrm.7.2019.11.05.15.37.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 15:37:11 -0800 (PST)
Subject: Re: scsi: lpfc: Fix crash in the function lpfc_sli4_queue_free when
 reboot
To:     Zhangguanghui <zhang.guanghui@h3c.com>,
        James Smart <jsmart2021@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <dce8e80b96114a63a85417c04219235c@h3c.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <1da91323-8b37-55c8-f8fa-1d0810a0db86@broadcom.com>
Date:   Tue, 5 Nov 2019 15:37:08 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <dce8e80b96114a63a85417c04219235c@h3c.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/2019 2:20 AM, Zhangguanghui wrote:
> Hi everyone
> There is a crash in the function lpfc_sli4_queue_free while rebooting the host.
> potential crash arising from ' wq_list list_delete' ordering problems.
> I thinks it’s the correct order.
> can you help me review and commit this patch, Best regards
>
> diff --git a/drivers/scsi/lpfc /lpfc_sli.c b/drivers/scsi/lpfc /lpfc_sli.c
> index 50f13ab..0cd5a96 100644
> --- a/drivers/scsi/lpfc /lpfc_sli.c
> +++ b/drivers/scsi/lpfc /lpfc_sli.c
> @@ -14438,9 +14438,6 @@ lpfc_sli4_queue_free(struct lpfc_queue *queue)
>          if (!queue)
>                  return;
>
> -       if (!list_empty(&queue->wq_list))
> -               list_del(&queue->wq_list);
> -
>          while (!list_empty(&queue->page_list)) {
>                  list_remove_head(&queue->page_list, dmabuf, struct lpfc_dmabuf,
>                                   list);
> @@ -14453,6 +14450,9 @@ lpfc_sli4_queue_free(struct lpfc_queue *queue)
>                  kfree(queue->rqbp);
>          }
>
> +       if (!list_empty(&queue->wq_list))
> +               list_del(&queue->wq_list);
> +
>          if (!list_empty(&queue->cpu_list))
>                  list_del(&queue->cpu_list);
>

Hi,

Thank you for the patch. It's not clear what the patch is actually 
fixing.  The change in order simply puts a longer delay in before the 
list freeing is done.

Can you send a stack trace or more information about the problem ?
What driver rev (see lpfc_version.h, also printed in dmesg at driver 
load/1st attach) was your crash ?

-- james

