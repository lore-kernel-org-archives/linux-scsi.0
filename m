Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4628DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 18:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 193A160F45
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 18:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhKASiZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 14:38:25 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:44748 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhKASiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 14:38:23 -0400
Received: by mail-pf1-f177.google.com with SMTP id k2so2601450pff.11
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2021 11:35:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CfaLn2MN/o/lNBkxX7ma+E9DsCc8bL5Q3Y8WjzpNOY4=;
        b=d8oydwH41ySoDjHtqLjHQKSW3HXhETqsY1gq47TiNICILKCz1otKBGHZMlZCKPbRcA
         Xiud6IT9K7utWEXvI/MKaVYNqHvjnP0gSQq3Kerwx3RQ89vO9LOmrtAWNoulY78UPW9B
         HNhsdFfXaQaj9YhYwpUS7lNFXvoZJmsvOmeq65sW9OyV6NrZn+Y4OX6QgJs9cE4xU+xW
         bonOlOuDEudx/Rmn7gII3rbXdcx8L/SCQLiBuWds8ECNrKleDjZuxmTLtfFM233RWENP
         nD9XPB9YvkZ/i03Rcic0kBIdLJkU/0BJRcQZH57hgzzciytlcNk9VBDMEV3s9w84h2vr
         W2bw==
X-Gm-Message-State: AOAM530BXcjaM/ma2QgGSGttrVU9/KyrJLbV2RH60C8wVpiJWppUNmLt
        mXNhjn8axtA1kdHlMDR7BmqqAZ2mJJW3NQ==
X-Google-Smtp-Source: ABdhPJxWiliCQ+R4vaWO0w8nU053jZ0zOneVSdw6Mmv58DwkH2uOQW8qvFMsqdYogHOas5oaBaVezw==
X-Received: by 2002:a63:788d:: with SMTP id t135mr23086806pgc.2.1635791749386;
        Mon, 01 Nov 2021 11:35:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:45ec:8a15:a0bc:b1ed])
        by smtp.gmail.com with ESMTPSA id z22sm15369624pfa.214.2021.11.01.11.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 11:35:48 -0700 (PDT)
Subject: Re: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in
 ufshcd_queuecommand()
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org
References: <20211029133751.420015-1-adrian.hunter@intel.com>
 <24e21ff3-c992-c71e-70e3-e0c3926fbcda@acm.org>
 <c2d76154-b2ef-2e66-0a56-cd22ac8c652f@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d3d70c8e-f260-ca2d-f4c1-2c9dd1a08c5d@acm.org>
Date:   Mon, 1 Nov 2021 11:35:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c2d76154-b2ef-2e66-0a56-cd22ac8c652f@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/1/21 2:16 AM, Adrian Hunter wrote:
> On 29/10/2021 19:31, Bart Van Assche wrote:
>> @@ -5985,9 +5920,12 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>>           ufshcd_clk_scaling_allow(hba, false);
>>       }
>>       ufshcd_scsi_block_requests(hba);
>> -    /* Drain ufshcd_queuecommand() */
>> -    down_write(&hba->clk_scaling_lock);
>> -    up_write(&hba->clk_scaling_lock);
>> +    /*
>> +     * Drain ufshcd_queuecommand(). Since ufshcd_queuecommand() does not
>> +     * sleep, calling synchronize_rcu() is sufficient to wait for ongoing
>> +     * ufshcd_queuecommand calls.
>> +     */
>> +    synchronize_rcu();
> 
> This depends upon block layer internals, so it must be called via a block
> layer function i.e. the block layer must guarantee this will always work. > Also, scsi_unjam_host() does not look like it uses RCU when issuing
> requests.

I will add an rcu_read_lock() / rcu_read_unlock() pair in ufshcd_queuecommand().
I think that addresses both points mentioned above.

>>       cancel_work_sync(&hba->eeh_work);
>>   }
>>
>> @@ -6212,11 +6150,8 @@ static void ufshcd_err_handler(struct work_struct *work)
>>        */
>>       if (needs_restore) {
>>           spin_unlock_irqrestore(hba->host->host_lock, flags);
>> -        /*
>> -         * Hold the scaling lock just in case dev cmds
>> -         * are sent via bsg and/or sysfs.
>> -         */
>> -        down_write(&hba->clk_scaling_lock);
>> +        /* Block TMF submission, e.g. through BSG or sysfs. */
> 
> What about dev cmds?

ufshcd_exec_dev_cmd() and ufshcd_issue_devman_upiu_cmd() both allocate a
request from hba->cmd_queue. blk_get_request() indirectly increments
q->q_usage_counter and blk_mq_freeze_queue() waits until that counter drops
to zero. Hence, hba->cmd_queue freezing only finishes after all pending dev
cmds have finished. Additionally, if hba->cmd_queue is frozen,
blk_get_request() blocks until it is unfrozen. So dev cmds are covered.

> Also, there is the outstanding question of synchronization for the call to
> ufshcd_reset_and_restore() further down.

Please clarify this comment further. I assume that you are referring to the
ufshcd_reset_and_restore() call guarded by if (needs_reset)? It is not clear
to me what the outstanding question is?

Thanks,

Bart.
