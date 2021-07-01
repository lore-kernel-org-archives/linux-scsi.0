Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF58C11F64
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 17:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A73EB61402
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 17:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhGARDK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 13:03:10 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:46910 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhGARDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 13:03:10 -0400
Received: by mail-pf1-f182.google.com with SMTP id x16so6406836pfa.13;
        Thu, 01 Jul 2021 10:00:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i0PDBSR6J+2RCMkE4AvoNnDfJPZgImJwdk+FEOtcmFc=;
        b=Dxfgi3KyTQvxKP/W8uhy2jtoj3ywUIeg7gkhqYshLcLEMH2wgVq4qNbX+zKGPhNUXG
         RQflcsJdNgaLpPlEfKJBOZrHWJvly6iDaK0ScJ3sc9MuloOB9qprzu3ayvyeRajhxD6i
         56L/zs5U049SBip+rq0+GkypUyme09pSvIPT871WcXagft29sqiUGQf4a6f0gKwqF2tU
         DPG6sfxPWRlTQ/+xJLhbcXND8uAXdLLcZOJId7rd4jJfH9JgxQVt1R6maILj6fl6OeIZ
         WhBGAnTWrShQxGxT/FjXGgmrtCs0vOkWwLYdwsreztERWCT/fdUtm9iC0PUlBvhUayAk
         Sb6Q==
X-Gm-Message-State: AOAM532F2m6TgjL6ImS8PXYtX9vVkxeMLTuYczniK/Qr+KMKlW6VOQ4a
        WnoxIv4Sn5In9Dyy1J6Mvnk=
X-Google-Smtp-Source: ABdhPJzACyIK5ziWpfBZqzlcFRlMCUHgkzZmSfSboD4QULXsBs+4ZTP0hooQ9UNFPCkEnQDzyoUjTw==
X-Received: by 2002:a63:ae01:: with SMTP id q1mr558225pgf.216.1625158838371;
        Thu, 01 Jul 2021 10:00:38 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6a75:b07:a0d:8bd5? ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id y9sm528707pfa.197.2021.07.01.10.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 10:00:37 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: add missing host_lock in setup_xfer_req
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210701005117.3846179-1-jaegeuk@kernel.org>
 <cb928bc9-0124-f082-8b5a-584afd9f1d66@acm.org>
Message-ID: <5349dca5-b8a4-d668-9370-c722da7c9ead@acm.org>
Date:   Thu, 1 Jul 2021 10:00:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cb928bc9-0124-f082-8b5a-584afd9f1d66@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/1/21 8:23 AM, Bart Van Assche wrote:
> On 6/30/21 5:51 PM, Jaegeuk Kim wrote:
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index c98d540ac044..194755c9ddfe 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -1229,8 +1229,13 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
>>  static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
>>  					bool is_scsi_cmd)
>>  {
>> -	if (hba->vops && hba->vops->setup_xfer_req)
>> -		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
>> +	if (hba->vops && hba->vops->setup_xfer_req) {
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(hba->host->host_lock, flags);
>> +		hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
>> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
>> +	}
>>  }
> 
> Since this function has only one caller, how about moving it into ufshcd.c?

(replying to my own email)

Since I just noticed that there are many other similar function
definitions in ufshcd.h, let's postpone moving these definitions until a
later time.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
