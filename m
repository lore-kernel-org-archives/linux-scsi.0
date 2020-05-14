Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AA7C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 17:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC9A20671
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 17:03:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Qp/j+Vhk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgENRDq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 13:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgENRDp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 13:03:45 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A298C061A0C
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 10:03:45 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h17so5199811wrc.8
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 10:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=md6Q3mRbTQ1WmLDfzP4CL8pYGQVjx67A8SJwik18qaQ=;
        b=Qp/j+VhkQBLwdy6pZLOdjD1KkK4SB6fdULcil1Bb/ApzRWGdZFxAc9p7F6UbNIQKCI
         CyZb//esyNNS8dxg9kMCgpNGmvdUrjXk0nPRN/j9JMX8vlYLYIb6TdNc+L2HnSLasb2C
         2wckG7U/dN5L6jeYO7chclIEByFxQfyw/dd/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=md6Q3mRbTQ1WmLDfzP4CL8pYGQVjx67A8SJwik18qaQ=;
        b=UCzmtOUwPavNHhABNjoWssX+D9MQesHHYoFoxCURa5FtxEFfzpS1Kn3zsMl7VLh0LN
         rlD+ZQsr+AU7avZluP/istf919kSY+0/TM2Sf6h2eI69j/LJ+Dn3HzC6jzqZs1fmsH2Z
         38xVGw4YlO+VosNPeTueCnoqh8iIFwAU9JzEUKoAxmMghLPBvrdeoLYkSYwk9X+XhGF0
         7dZAe0OYyGJ6bOTX2vljcfnq/GaW7vqIVBtRchoHZLud8m3Y6AwS0L4xmkS3meWSoHGS
         bdtLS/f5156WYj3bIXzOyYgDpHmQ3L1ZDu37bgZLct7pFmpQHcCRPAcRD55nBeMQkk5M
         Ef4w==
X-Gm-Message-State: AOAM531GkQ77aM+h2PZ/b3r44TVcYbPis1iTGauMJJPLDEQnPXhVejqM
        zlXJFzY+VB6ok0xs5QPzNNMH7g==
X-Google-Smtp-Source: ABdhPJy6ZDXeup/5XjzV2A/FK2RNwAx28chynbVnxv+3+oi/KkFUEHyq19N8uVacZ7JTDJdhCQWCMQ==
X-Received: by 2002:a5d:4dc9:: with SMTP id f9mr6406995wru.407.1589475824199;
        Thu, 14 May 2020 10:03:44 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n7sm4786435wro.94.2020.05.14.10.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 10:03:42 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: Fix a use after free in
 lpfc_nvme_unsol_ls_handler()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Paul Ely <paul.ely@broadcom.com>, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200512181909.GA299091@mwanda>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <4c0aa874-35db-65b5-e541-d513e7906254@broadcom.com>
Date:   Thu, 14 May 2020 10:03:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512181909.GA299091@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 5/12/2020 11:19 AM, Dan Carpenter wrote:
> The "axchg" pointer is dereferenced when we call the
> lpfc_nvme_unsol_ls_issue_abort() function.  It can't be either freed or
> NULL.
>
> Fixes: 3a8070c567aa ("lpfc: Refactor NVME LS receive handling")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 38889cb6e1996..fcf51b4192d66 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -2895,14 +2895,14 @@ lpfc_nvme_unsol_ls_handler(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
>   			(phba->nvmet_support) ? "T" : "I", ret);
>   
>   out_fail:
> -	kfree(axchg);
> -
>   	/* recycle receive buffer */
>   	lpfc_in_buf_free(phba, &nvmebuf->dbuf);
>   
>   	/* If start of new exchange, abort it */
> -	if (fctl & FC_FC_FIRST_SEQ && !(fctl & FC_FC_EX_CTX))
> +	if (axchg && (fctl & FC_FC_FIRST_SEQ) && !(fctl & FC_FC_EX_CTX))
>   		lpfc_nvme_unsol_ls_issue_abort(phba, axchg, sid, oxid);
> +
> +	kfree(axchg);
>   }
>   
>   /**

Reviewed-by: James Smart <james.smart@broadcom.com>

Thank You

-- james

