Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426ACC282DD
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 18:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 183CE2146E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 18:22:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="K7AU7/n5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgAGSWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 13:22:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52407 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgAGSWc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2020 13:22:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so570737wmc.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2020 10:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=WVCuuhbpIvW4AupYDvTbsRpjCbqFr6QbBg3JWUP7xik=;
        b=K7AU7/n5223YDYE2iaWkl1blioVVg9SLao6fF7DsweNWA6JGCSiKkx0N8e0tf9uWQr
         4Ihbf2gb+hGW+csWVXpI9VInkHgYU77v/ajfY2MsXmm9Yp05YgYOUjEnke8/MWH+85fQ
         mapthOJ1m8xt95YSDjqG3HF5j87nFlsZ1uVQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WVCuuhbpIvW4AupYDvTbsRpjCbqFr6QbBg3JWUP7xik=;
        b=SuDY1bsgC2zK1i7vbDGBVS0Q5kMCJfw7T0sM4vriZUQ3AsIT5pzzrMVUluB3Ts/jos
         nTvMzetlQxJ4Ab4y665KfuXcTyC0O+ngU52sLuw/x5Lgrixx/Iqag0MFS6JnobV1IzTL
         0koknVF0eK5Tsx9I/5FK4cUx9u05yLonUm+o0H9Qm50GKIqRAiR9xwsjiPm2fuRBzozC
         2KdBed0nJcJ0gOJgT0uKoOE15gjBkyn5VuNICdKZH4kmse/TrUWoyA9tdTNrAIurff7b
         5b+D1HM0HbRQk9tYWgm20wUyC9J3lZiJg5zD8xMeonKr3P/4uwUPjYQbWaPwGqMsFhfO
         YkWA==
X-Gm-Message-State: APjAAAU9XbQFf2Jks5AR8YaSD7K6M50b0oa+ulY7/jw5KQat33HAX31G
        5HO04eHey2x40mYI5m7tZtofJ8kkEL8=
X-Google-Smtp-Source: APXvYqyM26q6BufeUMyTP8sXY9m5zfj9JZqZtrSOU/J40+gNvNd+xwDVvj4/Eas53jGm5Op/26Bkzw==
X-Received: by 2002:a7b:cf39:: with SMTP id m25mr371888wmg.146.1578421350648;
        Tue, 07 Jan 2020 10:22:30 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k11sm532495wmc.20.2020.01.07.10.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 10:22:30 -0800 (PST)
Subject: Re: [PATCH -next] scsi: lpfc: Make lpfc_defer_acc_rsp static
To:     YueHaibing <yuehaibing@huawei.com>, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200107014956.41748-1-yuehaibing@huawei.com>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <591891cb-81fd-777a-3a21-3fd24c8f7cc2@broadcom.com>
Date:   Tue, 7 Jan 2020 10:22:26 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200107014956.41748-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 1/6/2020 5:49 PM, YueHaibing wrote:
> Fix sparse warning:
>
> drivers/scsi/lpfc/lpfc_nportdisc.c:344:1: warning:
>   symbol 'lpfc_defer_acc_rsp' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
> index 1c46e3a..a024e5a 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -340,7 +340,7 @@ lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
>    * This routine is only called if we are SLI4, acting in target
>    * mode and the remote NPort issues the PLOGI after link up.
>    **/
> -void
> +static void
>   lpfc_defer_acc_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
>   {
>   	struct lpfc_vport *vport = pmb->vport;

Yep. Looks good.  Thank You

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james

