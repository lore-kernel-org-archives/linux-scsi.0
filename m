Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926E4C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 16:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70F2A21872
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 16:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfKLQko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 11:40:44 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45384 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLQko (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 11:40:44 -0500
Received: by mail-pf1-f194.google.com with SMTP id z4so13718801pfn.12;
        Tue, 12 Nov 2019 08:40:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L0FjQQzu2rXiQBSIOHMOrm1WNakvA9TKz6IaI1d2z6Y=;
        b=RqPBSkZjLUtdlm5zJoLG4y972rrjlY857a95+wDDfDSfC7M61UntGX3f0wno1Yyzyg
         /I+hjT2mixAMVHhB8pGQaO/BuPUPd7GjBycfmH860isrGiW7NnEpuEhOXyGoFR1zxNWy
         Y8Aq45pjwidF+oPFxkSJp0i1A2cvPGma2Cysqa7HUAX0GZeaZfY5/sWc6SnDjmeYxVKv
         11FEwMvbq++AjJDmZWk3C5rl1W1bCRhXlcnxSEMdoDknvrJ9sQ06a78/orjiiYOEDmgR
         ygO6GjYZLM5WbYv/2xcsCZ0h1oi4/fBrwEshaTBt1hcrkVuMO8dIIUjZlNWy7Dy6wXFe
         T66Q==
X-Gm-Message-State: APjAAAV8PV1lKYpIcdUtzl2c2XSARoRIu1+KQBPuzBByr/St8vcL+2mv
        ylDFDfF5dF2H5RXQYjuORRDoN9tX
X-Google-Smtp-Source: APXvYqyseVPU/myey9ogxm6PsycIABBJHFJspM3pii7yukMs+V9DYgtA3BcVknVAg7UPqOdJLjvANg==
X-Received: by 2002:aa7:8b47:: with SMTP id i7mr14112477pfd.226.1573576842690;
        Tue, 12 Nov 2019 08:40:42 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id v10sm11106124pgr.37.2019.11.12.08.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2019 08:40:40 -0800 (PST)
Subject: Re: [RESEND PATCH v1 1/2] scsi: ufs: print helpful hint when response
 size exceed buffer size
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <BN7PR08MB5684BF6841527EB11A207F56DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <df3c0dc2-4ee6-1927-27b6-723d4e721ac5@acm.org>
Date:   Tue, 12 Nov 2019 08:40:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB5684BF6841527EB11A207F56DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/19 4:21 PM, Bean Huo (beanhuo) wrote:
> 
> Bean Huo <beanhuo@micron.com>
> 
> Reset since ver.kernel.org rejected outlook.com.
> Print out returned response size and buffer size, while the front one
> is bigger than the back one.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 11a87f51c442..fdb4f5b7f4bd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1935,8 +1935,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>   			memcpy(hba->dev_cmd.query.descriptor, descp, resp_len);
>   		} else {
>   			dev_warn(hba->dev,
> -				"%s: Response size is bigger than buffer",
> -				__func__);
> +				 "%s: rsp size %d is bigger than buffer size %d",
> +				 __func__, resp_len, buf_len);
>   			return -EINVAL;
>   		}
>   	}
> @@ -5856,7 +5856,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>   			memcpy(desc_buff, descp, resp_len);
>   			*buff_len = resp_len;
>   		} else {
> -			dev_warn(hba->dev, "rsp size is bigger than buffer");
> +			dev_warn(hba->dev,
> +				 "%s: rsp size %d is bigger than buffer size %d",
> +				 __func__, resp_len, *buff_len);
>   			*buff_len = 0;
>   			err = -EINVAL;
>   		}

Hi Bean,

Please use git format-patch and/or git send-email to publish patches 
such that the standard format is used ("From: " is missing from the 
first line). Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


