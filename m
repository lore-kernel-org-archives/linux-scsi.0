Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335D6C4167B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 18:53:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047C322D08
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 18:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgLFSxS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 13:53:18 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40793 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgLFSxS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 13:53:18 -0500
Received: by mail-pj1-f67.google.com with SMTP id m5so6154430pjv.5;
        Sun, 06 Dec 2020 10:53:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kGZCtvl0XaNikvAbCuKKM1R8Hnkj5Xl9CBbjMiN+opw=;
        b=Ilhs9IKYS/hiUOpYbxEY0kZmfwK4pgUGmeYUyokoDjBzuj71uR6ATafWf0FGtaWH6J
         vTxgBmZ4ogtXedmGhTK1NRGcPzfLGD+F0GW5fbx1QtCoaEAQ+47x+QWNoj6VgZm+sv4z
         jmZsCwclyLMnZeyH/YXFUa9B5MUGiwSIEkeYCxviWFXGqvvWwUBu2B6OGt8XIRRUatys
         CFlcoEn7uPwwUllRQoNVnYDMoeLyhrenaWLZTNpmDGQ9a2uAOIgC5YXv4zgzvWcdsnWT
         c4016GWW5Pr2/zcUPqlhG0N/zYx0Wo1TYy74fqLlrOBmPq1k7hMlZ9NDduBYkSzyfq+c
         yp4g==
X-Gm-Message-State: AOAM533/0Ur4vm1Io53ljXdOHfG3Kkr4wS2P8Pj38RJX1QJWi4z2wDoZ
        yJ/gJL0ns7at/cZEuzijb+Y=
X-Google-Smtp-Source: ABdhPJxqiVSH3jiNulRYuBf+uyO5xgXhLBfCuRnRIErZRsqSt5FE/r6rRiA9lSsdhLsxJocHP/JJFg==
X-Received: by 2002:a17:90b:3594:: with SMTP id mm20mr13389370pjb.121.1607280757514;
        Sun, 06 Dec 2020 10:52:37 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w70sm2320999pfd.65.2020.12.06.10.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 10:52:36 -0800 (PST)
Subject: Re: [PATCH v1 2/3] scsi: ufs: Distinguish between TM request UPIU and
 response UPIU in TM UPIU trace
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
References: <20201206164226.6595-1-huobean@gmail.com>
 <20201206164226.6595-3-huobean@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1508c318-8cbe-0abc-48f0-463a96a53477@acm.org>
Date:   Sun, 6 Dec 2020 10:52:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201206164226.6595-3-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/6/20 8:42 AM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Distinguish between TM request UPIU and response UPIU in TM UPIU trace,
> for the TM response, let TM UPIU trace print its TM response UPIU.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e10de94adb3f..29d7240a61bf 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -338,8 +338,12 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
>  	int off = (int)tag - hba->nutrs;
>  	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[off];
>  
> -	trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->req_header,
> -			&descp->input_param1);
> +	if (!strcmp("tm_send", str))
> +		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->req_header,
> +				  &descp->input_param1);
> +	else
> +		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->rsp_header,
> +				  &descp->output_param1);
>  }

Same comment here: please change the type of the 'str' argument in an
enum such that the strcmp() call can be changed into an integer comparison.

Thanks,

Bart.
