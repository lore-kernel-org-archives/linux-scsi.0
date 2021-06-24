Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206AAC49EA5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 16:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDDCB613EE
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 16:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhFXRAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 13:00:02 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:41604 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbhFXRAC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 13:00:02 -0400
Received: by mail-pl1-f172.google.com with SMTP id y13so3266335plc.8;
        Thu, 24 Jun 2021 09:57:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TfRjZvIBnPtJhX/lgcvHWYZI8ch0mIRl4NSCn+C67WM=;
        b=Ys+Iyin2PUlvbC8bgxiZog9SBj3J3DPNJ1UnXwwtOIa005SPcB+Gz0JGfhs5svRPQu
         n+Faaq7PuV+VluOAv5IQBAg8u4Y8ZfslG6Pz6FYHqCGmCxuhA9W0v8ZijQaF8awKfc+n
         WpSaoCHeKKcXwG4t5RLsqFJUI4eNE7yPcs6ZDmPbUgcNfO4++fWhNtBKm0pwo8NXxvo6
         NXNUQjdf/lmtWEzZseKuC0BitD5KE/tG5OzwRJTtN5DPbpLN7Et+MmSuFN9ssMHAElF8
         LHReSqHO4/kWbPnTIOU3aQlZWBasS+kGtNGguwEKhxcf95uwQz/6BNGlGEPEUo8jR1iN
         WQhw==
X-Gm-Message-State: AOAM533u8iqnDc9WACfj3OP+r7uR5+sMyRlEySoxyEfrQEzdKGFLn3Vo
        l96YwUDYInTTlaBD350YTPRUvB/24IU=
X-Google-Smtp-Source: ABdhPJyva/tfDQP/x1AkV7nS3quqJUIsvyAIEb59eMLgNPdJFSnNBOYNQt62WwGAPlhnQmy8KAfMEw==
X-Received: by 2002:a17:90a:6be6:: with SMTP id w93mr6321800pjj.171.1624553862063;
        Thu, 24 Jun 2021 09:57:42 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k20sm8937899pji.3.2021.06.24.09.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 09:57:41 -0700 (PDT)
Subject: Re: [PATCH v4 09/10] scsi: ufs: Update the fast abort path in
 ufshcd_abort() for PM requests
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-11-git-send-email-cang@codeaurora.org>
 <b28d71a7-3839-2c07-2630-6196ea10951f@acm.org>
 <5ff72cfab707b571ef395d52931edd0f@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <da7f134c-3a2a-e3b9-72a1-56a19f720c70@acm.org>
Date:   Thu, 24 Jun 2021 09:57:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5ff72cfab707b571ef395d52931edd0f@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 9:16 PM, Can Guo wrote:
> On 2021-06-24 05:33, Bart Van Assche wrote:
>> On 6/23/21 12:35 AM, Can Guo wrote:
>>> @@ -2737,7 +2737,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
>>> *host, struct scsi_cmnd *cmd)
>>>           * err handler blocked for too long. So, just fail the scsi cmd
>>>           * sent from PM ops, err handler can recover PM error anyways.
>>>           */
>>> -        if (hba->wlu_pm_op_in_progress) {
>>> +        if (cmd->request->rq_flags & RQF_PM) {
>>>              hba->force_reset = true;
>>>              set_host_byte(cmd, DID_BAD_TARGET);
>>>              cmd->scsi_done(cmd);
>>
>> I'm still concerned that the above code may trigger data corruption. I
>> prefer that the above code is removed instead of being modified.
> 
> Removing the change will lead to deadlock when error handling prepare
> calls pm_runtime_get_sync().
> 
> RQF_PM is only given to requests sent from power management operations,
> during which the specific device/LU is suspending/resuming, meaning no
> data transaction is ongoing. How can fast failing a PM request trigger
> data corruption?

Right, the above code only affects power management requests so there is
no risk for data corruption.

Thanks,

Bart.
