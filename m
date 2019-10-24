Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8969CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 18:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD19F21929
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 18:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="HG8N+ROI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410264AbfJXSOp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 14:14:45 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35971 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404839AbfJXSOo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 14:14:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id c22so3532533wmd.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Oct 2019 11:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=6pv6yVJxjSqE+XGDw69AG9mgT/MsqGxKR3hOZjY1Ub0=;
        b=HG8N+ROILLBfBx8GyXXl/sg3z+2bLorpdsjBgCKIgfLd/uz/CzoMvrXr2imC6ixz/r
         LBPzjzYbKZPVIQG3WsAHBqxsDpIZdI6CkhBfdVdi/PUTHG6ACAboOQmYNVra7VQ7gcNd
         EcH/2o2IYxAU8fR8nLEuMgoBkZp3RYC+DdEh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6pv6yVJxjSqE+XGDw69AG9mgT/MsqGxKR3hOZjY1Ub0=;
        b=BWofR9Xe4sn5Kke/bvkRpw4Rzi65aTRi5eoitHAHklabRGeFNnoYYLczjXxk8CzlTF
         PKAEtFHFAJ706oLtUJ/gasHQ497m0oKb1DPQHTHE0XkJsmmj3PqgOgPwVLTOA9HFd29P
         2qGMrfY10sawJ5yaPtZNqw3AX4koDULiO/n/IVScmupBR9V486zOQ9YtZF+E+BuzdErF
         zc3SDCJ4XfGhMRcgrwZOQvpiaxNYZQY2+zXJaYcJUFvBbdRtV2KadU8vnwC6uPLW7JPW
         SItkyuvUEO5SwkKs5LX0miEY8AA0W6OvDXrChG3/k3GRnP3ohUOaYdiQQ6/apWoMi3TK
         VvMA==
X-Gm-Message-State: APjAAAVajOUzHToSjshgXqWW7OpnfOuhelF4ioWddolV5PjoE682mLRi
        EMj4SqLKHssPbzgJZZAT/EYKPw==
X-Google-Smtp-Source: APXvYqye5zyY+tKlF6HHX3kxHOfX6xt/1KjD8QojNykF/+mKn2uYxR0H0ACnpSonbJdsqhZ/OQ/I/w==
X-Received: by 2002:a05:600c:21d7:: with SMTP id x23mr6027389wmj.6.1571940881004;
        Thu, 24 Oct 2019 11:14:41 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm4636995wme.6.2019.10.24.11.14.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 11:14:40 -0700 (PDT)
Subject: Re: [PATCH] scsi: lpfc: lpfc_attr.c: Fix Use plain integer as NULL
 pointer
To:     Saurav Girepunje <saurav.girepunje@gmail.com>,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com,
        Dick Kennedy <dick.kennedy@broadcom.com>
References: <20191024025726.GA31421@saurav>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <643cce28-6b64-0bfc-254a-52cc3efa0830@broadcom.com>
Date:   Thu, 24 Oct 2019 11:14:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024025726.GA31421@saurav>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/2019 7:57 PM, Saurav Girepunje wrote:
> Replace assignment of 0 to pointer with NULL assignment.
>
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_attr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index ea62322ffe2b..f7df95963a63 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -1641,7 +1641,7 @@ lpfc_set_trunking(struct lpfc_hba *phba, char *buff_out)
>   {
>   	LPFC_MBOXQ_t *mbox = NULL;
>   	unsigned long val = 0;
> -	char *pval = 0;
> +	char *pval = NULL;
>   	int rc = 0;
>   
>   	if (!strncmp("enable", buff_out,

thanks

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james

