Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C045C48BCF
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 15:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF74D6138C
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 15:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhFLPwa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Jun 2021 11:52:30 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:33656 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhFLPw3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jun 2021 11:52:29 -0400
Received: by mail-pj1-f45.google.com with SMTP id k22-20020a17090aef16b0290163512accedso8671628pjz.0;
        Sat, 12 Jun 2021 08:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jYWQ4IpIFoKpqkBqG4Rq5tI1Pt9rQIq1/vzDb2TcU+A=;
        b=GAM6pUZBDI1eZl+J9GOjlz5wSf8wPdVvlopWhcki/Xi5ijjF3LZAA0HOaxAAAsHZ0h
         ruxmo4L5hlQydalgYJVIg5XGMz3mUXg7RmBrRDCB7mOzhcYZJT/j+/I7OLwGv8WaQ8U4
         5sMtTGjmBLwEerUPqKEg7To/v+uvd7joM1XJLHfnmNSMFwWNCVmjK1ZUSajX/JHF41aV
         ITC+9AfsbTHQ2j0Y75XyOat99G0o/TxVfNIjmyr41Ot6j223tChMBOEC61WyAG3wKtb+
         FbN+6GaAp1tNVAeTE/ZXGJ5mcN3VXmaPhChjiRmtrVp2c+bH+FdB5Wv8X/c4Y+gJaOjD
         In1Q==
X-Gm-Message-State: AOAM530gFq72B4Bav6ZUyknABGliSWGnwKblrsAcJIWbdxb0smOHRpsg
        ffqC5plkJouB7tU/HuPTUACkS0jX9uNDzw==
X-Google-Smtp-Source: ABdhPJx5WKKc7tjw+9JZuQ6kPsbL3GuLOqTHoUnFGIfWVxLM17eY478PtcHk2e673XLWRvGuvdhkCg==
X-Received: by 2002:a17:90a:ca8e:: with SMTP id y14mr9690200pjt.186.1623513015228;
        Sat, 12 Jun 2021 08:50:15 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u7sm8489632pgl.39.2021.06.12.08.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jun 2021 08:50:14 -0700 (PDT)
Subject: Re: [PATCH v3 4/9] scsi: ufs: Complete the cmd before returning in
 queuecommand
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
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-5-git-send-email-cang@codeaurora.org>
 <d017548a-16fb-8ad0-2363-09dad00c9642@acm.org>
 <80926df7e3e41088e59ce5e0dbdec28a@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5df201d5-ab7f-a9fc-36aa-6dd174e9cee2@acm.org>
Date:   Sat, 12 Jun 2021 08:50:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <80926df7e3e41088e59ce5e0dbdec28a@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/21 12:38 AM, Can Guo wrote:
> On 2021-06-12 04:52, Bart Van Assche wrote:
>> On 6/9/21 9:43 PM, Can Guo wrote:
>>> @@ -2768,15 +2778,6 @@ static int ufshcd_queuecommand(struct
>>> Scsi_Host *host, struct scsi_cmnd *cmd)
>>>      WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
>>>          (hba->clk_gating.state != CLKS_ON));
>>>
>>> -    if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
>>> -        if (hba->wl_pm_op_in_progress)
>>> -            set_host_byte(cmd, DID_BAD_TARGET);
>>> -        else
>>> -            err = SCSI_MLQUEUE_HOST_BUSY;
>>> -        ufshcd_release(hba);
>>> -        goto out;
>>> -    }
>>> -
>>>      lrbp = &hba->lrb[tag];
>>>      WARN_ON(lrbp->cmd);
>>>      lrbp->cmd = cmd;
>>
>> Can the code under "if (unlikely(test_bit(tag,
>> &hba->outstanding_reqs)))" be deleted instead of moving it? I don't
>> think that it is useful to verify whether the block layer tag allocator
>> works correctly. Additionally, I'm not aware of any similar code in any
>> other SCSI LLD.
> 
> ufshcd_abort() aborts PM requests differently from other requests -
> it simply evicts the cmd from lrbp [1], schedules error handler and
> returns SUCCESS (the reason why I am doing it this way is in patch #8).
> 
> After ufshcd_abort() returns, the tag shall be released, the logic
> here is to prevent subsequent cmds re-use the lrbp [1] before error
> handler recovers the device and host.

Thanks for the background information. However, this approach sounds
cumbersome to me. For PM requests, please change the UFS driver such
that calling scsi_done() for aborted requests is postponed until error
handling has finished and delete the code shown above from
ufshcd_queuecommand().

Thanks,

Bart.
