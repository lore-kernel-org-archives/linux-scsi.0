Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E3DC2B9F7
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 02:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E2A6141B
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 02:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhEYCGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 22:06:02 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:36028 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhEYCGB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 22:06:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1621908273; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=KBM7kBuRBC+qyoViVJY/iIDapiWA7HFCDog78oJunKs=;
 b=vqrfy6pvJ7opIjA4q17wC0v1r6fZLPewj8XMXMQX4oOhY6fYaF29F+QGyt1i5l92mk7dvAJm
 MqR/Rbr5Sh8LtcSKmsOAUZFJoV3Qe71gEqvvPvT5167jL6cars9eEeM3/jVbyaQRYpswaBWs
 5s7zlQEYqTBe4vzB8M370vzPCY0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60ac5b285f788b52a56016c0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 25 May 2021 02:04:24
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 54854C4360C; Tue, 25 May 2021 02:04:24 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9E04CC4338A;
        Tue, 25 May 2021 02:04:23 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 25 May 2021 10:04:23 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] scsi: ufs: Let host_sem cover the entire system
 suspend/resume
In-Reply-To: <19b44731-1a4f-c88c-58fd-05eca5df2c2e@acm.org>
References: <1621846046-22204-1-git-send-email-cang@codeaurora.org>
 <1621846046-22204-6-git-send-email-cang@codeaurora.org>
 <19b44731-1a4f-c88c-58fd-05eca5df2c2e@acm.org>
Message-ID: <423285a089b7dc3fcfcb169e0a553e8a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-05-25 00:56, Bart Van Assche wrote:
> On 5/24/21 1:47 AM, Can Guo wrote:
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
> Other SCSI LLDs can perform error handling while system suspend/resume
> is in progress. Why can't the UFS driver do this?

I don't know about other SCSI LLDs, but UFS error handling is basically
doing a re-probe/re-initialization to UFS device. Having UFS error 
handling
running in parallel with system suspend/resume, neither of them will end
up well.

I didn't design all this, it is just happening, I am trying to fix it 
and
semaphore works well for me. I am really glad to see someone cares about
error handling and fix it with better ideas (maybe using WQ_FREEZABLE) 
later.

> 
> Additionally, please document what the purpose of host_sem is before
> making any changes to how host_sem is used. The only documentation I
> have found of host_sem is the following: "* @host_sem: semaphore used 
> to
> serialize concurrent contexts". To me that text is less than useful
> since semaphores are almost always used to serialize concurrent code.
> 

Sure, host_sem is actually preventing cocurrency happens among any of
contexts, such as sysfs access, shutdown, error handling, system
suspend/resume and async probe, I will update its message in next 
version.

Thanks,

Can Guo.

> Thanks,
> 
> Bart.
