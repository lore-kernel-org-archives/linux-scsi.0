Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A835EC48BCF
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 16:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F5EF6120E
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Jun 2021 16:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhFLQxN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Jun 2021 12:53:13 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:35359 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhFLQxM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jun 2021 12:53:12 -0400
Received: by mail-pf1-f180.google.com with SMTP id h12so7100094pfe.2;
        Sat, 12 Jun 2021 09:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JdcjtmqL1ch2nmFbckHGJtJUs97DirKkuMcWSJqmreY=;
        b=loBPBC5n5r109pa6b6VWAYZUfs9UdWGp0luzRkKP10F2U64YWTdSRah+Cn75/4jA3W
         kVNTXA6uH4tcAHu9ZJFOkgzFB3zATTgG5HDROr1ckQysXndQc9Yhln9AaVGY2QEYGU6+
         Qx3hLO5FU3aLr0u3XZ0uqxpgNXkeuJ6ZL6C89Q/skAWjM0fh5z48yySJu1gDl/1uOBmH
         Av959+Xc4rY1Q/kEPg9adRUasGBXbgFo6QhOIwgMCKm76det7tjEJW3Rft8ISKVqpyoO
         56nl/BGkkrcm0bpOema4ORxACF5CZL4Jypet5H+WoOftpx1jFzjWcTWAbDxWggLaEgDr
         mVOw==
X-Gm-Message-State: AOAM531SuHRRBzxOck418YZDEA1weiKxUI5FnSGlqpWB1lTHRGCTP6FA
        QuTwaWn6PGGMj1pFl7a7fWah2S0LcjRL0A==
X-Google-Smtp-Source: ABdhPJxQEyLk1MOcqdztThxP/TpgNALyHdDiTphHnf0xVMWCLVgel8HnXqsPdjrHMZIipNYrxVgPGw==
X-Received: by 2002:aa7:96e3:0:b029:2ec:e8a1:3d66 with SMTP id i3-20020aa796e30000b02902ece8a13d66mr13751530pfq.79.1623516654172;
        Sat, 12 Jun 2021 09:50:54 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j3sm8123472pfe.98.2021.06.12.09.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jun 2021 09:50:53 -0700 (PDT)
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <926d8c4a-0fbf-a973-188a-b10c9acaa444@acm.org>
Date:   Sat, 12 Jun 2021 09:50:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <16f5bd448c7ae1a45fcb23133391aa3f@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/21 12:07 AM, Can Guo wrote:
> Sigh... I also want my life and work to be easier...

How about reducing the number of states and state transitions in the UFS
driver?

One source of complexity is that ufshcd_err_handler() is scheduled
independently of the SCSI error handler and hence may run concurrently
with the SCSI error handler. Has the following already been considered?
- Call ufshcd_err_handler() synchronously from ufshcd_abort() and
ufshcd_eh_host_reset_handler() instead of asynchronously.
- Call scsi_schedule_eh() from ufshcd_uic_pwr_ctrl() and
ufshcd_check_errors() instead of ufshcd_schedule_eh_work().

These changes will guarantee that all commands have completed or timed
out before ufshcd_err_handler() is called. I think that would allow to
remove e.g. the following code from the error handler:

	ufshcd_scsi_block_requests(hba);
	/* Drain ufshcd_queuecommand() */
	down_write(&hba->clk_scaling_lock);
	up_write(&hba->clk_scaling_lock);

Thanks,

Bart.
