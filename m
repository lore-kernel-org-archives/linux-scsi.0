Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9F9C48BDF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 18:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA0A8613D0
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 18:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhFOS1o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 14:27:44 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:35698 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhFOS1o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 14:27:44 -0400
Received: by mail-pf1-f169.google.com with SMTP id h12so111258pfe.2;
        Tue, 15 Jun 2021 11:25:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t75Eshf3FtAd9dxRc0GBGh60Gm8DFewQEc7KQ6oYmIA=;
        b=QOSBKLSwG2Qy/wdwE977/nkGvih6E+zlzRL/SpF9Vtn+qM8nqxDwreKfqUyxJC09ha
         Bo+N+1SlEWDCHTkTt1wFHDhC8rpeM4lJFGWkxEeq3UdvryBZxEtJh5jX7HYInJ3yv3q0
         s+wHtH/+7+Hwdx9c5kHUTrHJJ5iTDP0YqXksP74gC0kQZ64ykJhkkDxVOhG8M0XBkr/E
         64EJhRu3/H3TttxFKMYoOPVlBEvU9Rw+NjZG5U+J1s6XxSWQTTSAzVRUkdkgheRF3XB/
         okMp6j7mIgmsaXRgMWcu09bMzgtnsuLUX9CJHYklt/VgWspAfvfRLnV7uvNQuS8FWLHL
         E6Ng==
X-Gm-Message-State: AOAM532BTP+UihbbkAfKt7TVeumaLS8mWsfsxchGMq1c6kqCBr/T8y3h
        PC7lRCJaTZYPAEP1T7Re9qkFAYsF97Y=
X-Google-Smtp-Source: ABdhPJzbIqqApABK6kJsbgY1wlf09wbEJRIegcgc/CHe0hvJu33GcwyzEMSz1TZ/JYp0ErfNd3vEug==
X-Received: by 2002:a63:1004:: with SMTP id f4mr804224pgl.115.1623781537577;
        Tue, 15 Jun 2021 11:25:37 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h4sm3515370pjv.55.2021.06.15.11.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 11:25:36 -0700 (PDT)
Subject: Re: [PATCH v3 8/9] scsi: ufs: Update the fast abort path in
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
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-9-git-send-email-cang@codeaurora.org>
 <fa37645b-3c1e-2272-d492-0c2b563131b1@acm.org>
 <16f5bd448c7ae1a45fcb23133391aa3f@codeaurora.org>
 <926d8c4a-0fbf-a973-188a-b10c9acaa444@acm.org>
 <75527f0ba5d315d6edbf800a2ddcf8c7@codeaurora.org>
 <8b27b0cc-ae16-173a-bd6f-0321a6aba01c@acm.org>
 <3fce15502c2742a4388817538eb4db97@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fabc70f8-6bb8-4b62-3311-f6e0ce9eb2c3@acm.org>
Date:   Tue, 15 Jun 2021 11:25:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3fce15502c2742a4388817538eb4db97@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/14/21 7:36 PM, Can Guo wrote:
> I've considered the similar way (leverage hba->host->eh_noresume) last
> year,
> but I didn't take this way due to below reasons:
> 
> 1. UFS error handler basically does one thing - reset and restore, which
> stops hba [1], resets device [2] and re-probes the device [3]. Stopping
> hba [1]
> shall complete any pending requests in the doorbell (with error or no
> error).
> After [1], suspend/resume contexts, blocked by SSU cmd, shall be unblocked
> right away to do whatever it needs to handle the SSU cmd failure (completed
> in [1], so scsi_execute() returns an error), e.g., put link back to the old
> state. call ufshcd_vops_suspend(), turn off irq/clocks/powers and etc...
> However, reset and restore ([2] and [3]) is still running, and it can
> (most likely)
> be disturbed by suspend/resume. So passing a parameter or using
> hba->host->eh_noresume
> to skip lock_system_sleep() and unlock_system_sleep() can break the cycle,
> but error handling may run concurrently with suspend/resume. Of course
> we can
> modify suspend/resume to avoid it, but I was pursuing a minimal change
> to get this fixed.
> 
> 2. Whatever way we take to break the cycle, suspend/resume shall fail and
> RPM framework shall save the error to dev.power.runtime_error, leaving
> the device in runtime suspended or active mode permanently. If it is left
> runtime suspended, UFS driver won't accept cmd anymore, while if it is left
> runtime active, powers of UFS device and host will be left ON, leading
> to power
> penalty. So my main idea is to let suspend/resume contexts, blocked by
> PM cmds,
> fail fast first and then error handler recover everything back to work.

Hi Can,

Has it been considered to make the UFS error handler fail pending
commands with an error code that causes the SCSI core to resubmit the
SCSI command, e.g. DID_IMM_RETRY or DID_TRANSPORT_DISRUPTED? I want to
prevent that power management or suspend/resume callbacks fail if the
error handler succeeds with recovering the UFS transport.

Thanks,

Bart.
