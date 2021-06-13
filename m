Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C184CC48BCF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 13:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87DE6610A0
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 13:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhFMNcl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 09:32:41 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:20743 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231688AbhFMNcl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 13 Jun 2021 09:32:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623591040; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=v8jXqJ5ky/IEKt0B6ubAeEGws7ANAZpKE8P/QO1P2dQ=;
 b=wN0XDKrp+CtFRBZMLRTP0cqVmX3mzJyN0e9pZjWQ0O/9whhsbz7vWXdWeWloVHwcMy3Th4SZ
 7VGn9NW4qTE6acQaB/PYy3jhK2Nk0rPvuuN9sNYLnhEJfVHjU9U/0bZ3zn3McV0UHt7Zvbcw
 2rnKdu6fY2+fWZUBTbjLQ4MJj6k=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60c608748491191eb301e442 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 13 Jun 2021 13:30:28
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3F5E6C4323A; Sun, 13 Jun 2021 13:30:28 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68092C433F1;
        Sun, 13 Jun 2021 13:30:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sun, 13 Jun 2021 21:30:27 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
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
Subject: Re: [PATCH v3 4/9] scsi: ufs: Complete the cmd before returning in
 queuecommand
In-Reply-To: <5df201d5-ab7f-a9fc-36aa-6dd174e9cee2@acm.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-5-git-send-email-cang@codeaurora.org>
 <d017548a-16fb-8ad0-2363-09dad00c9642@acm.org>
 <80926df7e3e41088e59ce5e0dbdec28a@codeaurora.org>
 <5df201d5-ab7f-a9fc-36aa-6dd174e9cee2@acm.org>
Message-ID: <3f39da79b40b53240636e848cd65feac@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-12 23:50, Bart Van Assche wrote:
> On 6/12/21 12:38 AM, Can Guo wrote:
>> On 2021-06-12 04:52, Bart Van Assche wrote:
>>> On 6/9/21 9:43 PM, Can Guo wrote:
>>>> @@ -2768,15 +2778,6 @@ static int ufshcd_queuecommand(struct
>>>> Scsi_Host *host, struct scsi_cmnd *cmd)
>>>>      WARN_ON(ufshcd_is_clkgating_allowed(hba) &&
>>>>          (hba->clk_gating.state != CLKS_ON));
>>>> 
>>>> -    if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
>>>> -        if (hba->wl_pm_op_in_progress)
>>>> -            set_host_byte(cmd, DID_BAD_TARGET);
>>>> -        else
>>>> -            err = SCSI_MLQUEUE_HOST_BUSY;
>>>> -        ufshcd_release(hba);
>>>> -        goto out;
>>>> -    }
>>>> -
>>>>      lrbp = &hba->lrb[tag];
>>>>      WARN_ON(lrbp->cmd);
>>>>      lrbp->cmd = cmd;
>>> 
>>> Can the code under "if (unlikely(test_bit(tag,
>>> &hba->outstanding_reqs)))" be deleted instead of moving it? I don't
>>> think that it is useful to verify whether the block layer tag 
>>> allocator
>>> works correctly. Additionally, I'm not aware of any similar code in 
>>> any
>>> other SCSI LLD.
>> 
>> ufshcd_abort() aborts PM requests differently from other requests -
>> it simply evicts the cmd from lrbp [1], schedules error handler and
>> returns SUCCESS (the reason why I am doing it this way is in patch 
>> #8).
>> 
>> After ufshcd_abort() returns, the tag shall be released, the logic
>> here is to prevent subsequent cmds re-use the lrbp [1] before error
>> handler recovers the device and host.
> 
> Thanks for the background information. However, this approach sounds
> cumbersome to me. For PM requests, please change the UFS driver such
> that calling scsi_done() for aborted requests is postponed until error
> handling has finished and delete the code shown above from
> ufshcd_queuecommand().

I will delete the code in next version, since I believe the hba_state
checks before the code is enough to achieve the same purpose, so this
code becomes redundant.

Thanks,

Can Guo.

> 
> Thanks,
> 
> Bart.
