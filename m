Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A77AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 20:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F059861216
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 20:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbhIPUXb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 16:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234492AbhIPUXa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2021 16:23:30 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD75C061574;
        Thu, 16 Sep 2021 13:22:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n2so2053480plk.12;
        Thu, 16 Sep 2021 13:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PhrGdrpLsLT9AXXnYBVmm+LcoVUJ2JmcxlPGEaMeZVc=;
        b=Lpke6qMkSdPGJXHkgBTdw1WLsA1jZw5KVfMLX3gX4BlizXL9IVzduQOIvKJg3sN4eu
         rpIhUyOpUpBsIlHR2oyXWXjvlZaLNszlHTIN+RmA9FPY7enH3k4HslmJr/8rmRKtBGo2
         2kwjwSXh55P4wp/86pc0yIgbOt07FckI5zVAhPUuULDhbhNiaddrmxg/OaLihcWRwpcd
         ov++tgIhFIid7Zk9kvtsyhccj76bpOJ1AksMhXKYlMkFKm8/ut3azd/yo14Td0NWeUry
         D6xwL4uutsZqCVa77SRrbuM4+DokOq1iRsPK2JOdlPPrTeM+whhMOXhIfmQX4Gin73gl
         x5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PhrGdrpLsLT9AXXnYBVmm+LcoVUJ2JmcxlPGEaMeZVc=;
        b=Q+ibTbVIelVo5OYhZRkQLIu45kHsxhQDgniY3Vo2L+kchpb8HVWbt0p/TkeF+PhSz7
         IqAmRDsT9pIzdcCu6xVQtonsmjH3MQzvpw3U32P1qpu3RVeaEI6asE0V3jUCWAMa1Q5L
         kQbrVmZQDIHqaI+iNESahfcaabS5ArYs/a9nOYyW3fXYhltt0M/eRN/vPzIu871sg90d
         b+n80zg8AMNCgbO/BfwUtDbNpB4QhXVpNwL0IHPG/q+3CwkOa6kTYAiIqj8k5SAOtjJU
         2tGOEynHBrXt+C5+J2nGLuGdy3JzK2Vh9J5xqK4oKlLTxA7ChNe3uZK2D9PtUhK4Aqrx
         scOw==
X-Gm-Message-State: AOAM530YyMSPERB+0ls9bR4XvUpi3AhuB6L0W98kfq0qjnIGn0KQcUg2
        ep7+WBlYurXduqnNdtsxQXc=
X-Google-Smtp-Source: ABdhPJxItCN7UEel0JwBGebZPZhTyAyewvQBVD2B+4kxG3Nwd6qyBNDAZV98A6IlrrSkiqqr80/oOg==
X-Received: by 2002:a17:90b:4b8a:: with SMTP id lr10mr16790451pjb.186.1631823729606;
        Thu, 16 Sep 2021 13:22:09 -0700 (PDT)
Received: from [10.69.44.239] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z6sm3537281pjn.27.2021.09.16.13.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 13:22:09 -0700 (PDT)
Message-ID: <5487889d-c103-8b68-0021-1c138da8f6da@gmail.com>
Date:   Thu, 16 Sep 2021 13:22:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] scsi: lpfc: fix sprintf() overflow in
 lpfc_display_fpin_wwpn()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Justin Tee <justin.tee@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20210916132251.GD25094@kili>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20210916132251.GD25094@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/16/2021 6:22 AM, Dan Carpenter wrote:
> This scnprintf() uses the wrong limit.  It should be
> "LPFC_FPIN_WWPN_LINE_SZ - len" instead of LPFC_FPIN_WWPN_LINE_SZ.
> 
> Fixes: 428569e66fa7 ("scsi: lpfc: Expand FPIN and RDF receive logging")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

looks good. Thank you

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

