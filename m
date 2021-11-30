Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357B8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 04:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbhK3EQZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 23:16:25 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:34733 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhK3EQY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 23:16:24 -0500
Received: by mail-pl1-f182.google.com with SMTP id y8so13883323plg.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 20:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8eNph93wZXelBmyXcKcMn8Lxbrpb49OmB4nqd2n92WI=;
        b=0i7dUjlcaHna/T0yvXhch5oFbqJvaxvL8IU9M3oKnUH/mLCtDDI9wV4n0lWxb9Dpvy
         dHiSiWFloUGUQ+ZNVjw4l1LR5U84RNa8FI42h9HSJ5keT8QI264pdcmVf7dVi2cBy4TD
         rsq2/RkloUA1QSBBFQEFzFumtXs75+U7zWTI9FgjLMPwbfHM9of788J686SXyPKzfK+/
         LU1kCbp3vQ7Su0VqSxD9MlDn5X3AjVBvz8WWUWd2NaB6iYDAl9MWdetjhQekPAlZBNJ7
         TJmiShLWqf64K7uVEyu/JJp/S2wGLQHWLQiGcr1Wbjxi/xzySux2d0Kv6/w9jPydGV7X
         lApw==
X-Gm-Message-State: AOAM533Xe0CtvpLOyUasAEXCXx7+5cIAaaBwLy9oLxYVMllBQ15Ia19l
        vOINgXY0NnRonJMMjNPrzdoPp1GXOA8=
X-Google-Smtp-Source: ABdhPJxVQqlV7sd97KGVQOePwfE27vyBRiMchK3HfxA4w/aHHQN6P48n56U3bBXusn43EDmgcscWVw==
X-Received: by 2002:a17:902:8f93:b0:142:8731:1a5d with SMTP id z19-20020a1709028f9300b0014287311a5dmr65150419plo.60.1638245585769;
        Mon, 29 Nov 2021 20:13:05 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j22sm19427885pfj.130.2021.11.29.20.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 20:13:05 -0800 (PST)
Message-ID: <1962aae0-a074-752e-125c-44b10368ee50@acm.org>
Date:   Mon, 29 Nov 2021 20:13:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 15/20] scsi: ufs: Improve SCSI abort handling
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Namjae Jeon <linkinjeon@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-16-bvanassche@acm.org>
 <502c4980-32e3-8c77-76c5-4be814b8fab6@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <502c4980-32e3-8c77-76c5-4be814b8fab6@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/21 04:28, Adrian Hunter wrote:
> On 19/11/2021 21:57, Bart Van Assche wrote:
>> Release resources when aborting a command. Make sure that aborted commands
>> are completed once by clearing the corresponding tag bit from
>> hba->outstanding_reqs.
>>
>> Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++++++--
>>   1 file changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 39dcf997a638..7e27d6436889 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -7042,8 +7042,12 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>>   
>>   	ufshcd_hold(hba, false);
>>   	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>> -	/* If command is already aborted/completed, return FAILED. */
>> -	if (!(test_bit(tag, &hba->outstanding_reqs))) {
>> +	/*
>> +	 * If the command is already aborted/completed, return FAILED. This
>> +	 * should never happen since the SCSI core serializes error handling
>> +	 * and scsi_done() calls.
> 
> I don't think that is correct. ufshcd_transfer_req_compl() gets called directly
> by the interrupt handler.

I will revert this change.

>> +	/*
>> +	 * Clear the corresponding bit from outstanding_reqs since the command
>> +	 * has been aborted successfully.
>> +	 */
>> +	spin_lock_irqsave(&hba->outstanding_lock, flags);
>> +	__clear_bit(tag, &hba->outstanding_reqs);
>> +	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
>> +
>> +	ufshcd_release_scsi_cmd(hba, lrbp);
> 
> ufshcd_release_scsi_cmd() must not be called if the bit was already clear
> i.e.
> 
> 	spin_lock_irqsave(&hba->outstanding_lock, flags);
> 	rel = __test_and_clear_bit(tag, &hba->outstanding_reqs);
> 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> 
> 	if (rel)
> 		ufshcd_release_scsi_cmd(hba, lrbp);

Will look into this.

Thanks,

Bart.
