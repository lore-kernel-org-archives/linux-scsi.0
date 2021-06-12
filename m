Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81EE3C48BCF
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 06:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59ED561374
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 06:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFLGtD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Jun 2021 02:49:03 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:16119 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230517AbhFLGtB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 12 Jun 2021 02:49:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623480422; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=EFpndBjKGME2h4jUc1ykg57p30KYeOPOaDRAy8qnMwA=;
 b=c7iou9nWLNcDDxpI0tJtAdQqqlMYPoqa3zOgmDG6i9A7UYR0m62EUYQPiac3YL6+0tXvX/M3
 LGika5iLlU62QAwWpGi1j+pDCO5eyNXZMOQgjyECqUS4TZUQWzSEKNNZjaAxYamLupm7HCCe
 QMuZhTdvuidqSMTuB/WQ+FO2FSY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60c4585ded59bf69cc68fca3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 12 Jun 2021 06:46:53
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4907DC4323A; Sat, 12 Jun 2021 06:46:53 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A06C7C433F1;
        Sat, 12 Jun 2021 06:46:52 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 12 Jun 2021 14:46:52 +0800
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 7/9] scsi: ufs: Let host_sem cover the entire system
 suspend/resume
In-Reply-To: <b480d5a9-463d-9c51-8fd6-a2cff3396dc7@acm.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-8-git-send-email-cang@codeaurora.org>
 <b480d5a9-463d-9c51-8fd6-a2cff3396dc7@acm.org>
Message-ID: <51f136db226e56a38b8cc1664a2b578f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-12 05:00, Bart Van Assche wrote:
> On 6/9/21 9:43 PM, Can Guo wrote:
>> UFS error handling now is doing more than just re-probing, but also 
>> sending
>> scsi cmds, e.g., for clearing UACs, and recovering runtime PM error, 
>> which
>> may change runtime status of scsi devices. To protect system 
>> suspend/resume
>> from being disturbed by error handling, move the host_sem from wl pm 
>> ops
>> to ufshcd_suspend_prepare() and ufshcd_resume_complete().
> 
> If lock_system_sleep() and unlock_system_sleep() would be used in the
> error handler, would that allow to remove host_sem?

Please kindly check my reply in patch #5.

Thanks,

Can Guo.

> 
> Thanks,
> 
> Bart.
