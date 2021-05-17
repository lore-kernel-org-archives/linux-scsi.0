Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2919C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 03:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73CCF610A1
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 03:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhEQDXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 May 2021 23:23:48 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:39647 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231744AbhEQDXr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 16 May 2021 23:23:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621221751; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=BnqGq1pzoqqb3qyX2lCRDxOTjJMep8szFP0fRb15D7M=;
 b=tAPikW7xB0qPhZ5hxMOBprwlniXtIQM/lHH5es+YHrYJz2/j4PPm4FtdA2mQXWGnW2VWZmne
 xeLzktebolzHHxupZ5XGyZRiC7YVfvj1OAcuylzgYlLfqazP//S0RM+jt6rzMtDR9PU7W8tH
 QtEYBUT8XkpUbrPFAg7hdwCoBlU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60a1e1745f788b52a59218c3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 17 May 2021 03:22:28
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 98CB5C43217; Mon, 17 May 2021 03:22:28 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 04DEAC433F1;
        Mon, 17 May 2021 03:22:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 17 May 2021 11:22:27 +0800
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
Subject: Re: [PATCH v1 5/6] scsi: ufs: Let host_sem cover the entire system
 suspend/resume
In-Reply-To: <b59e0cd4-d560-6724-3f30-a5232dd41a8f@acm.org>
References: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
 <1620885319-15151-7-git-send-email-cang@codeaurora.org>
 <b59e0cd4-d560-6724-3f30-a5232dd41a8f@acm.org>
Message-ID: <98a7135ef1ce34e23e84817cf6167e1a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-05-14 11:55, Bart Van Assche wrote:
> On 5/12/21 10:55 PM, Can Guo wrote:
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
> In ufshcd.h I found the following:
> 
>  * @host_sem: semaphore used to serialize concurrent contexts
> 
> That's the wrong way to use a synchronization object. A synchronization
> object must protect data instead of code. Does host_sem perhaps need to
> be split into multiple synchronization objects?

Thanks for the comments. These contexts are changing critical data and
registers, so the sem is used to protect data actually, just like the
scaling_lock protecting scaling and cmd transations.

Thanks,

Can Guo.

> 
> Thanks,
> 
> Bart.
