Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E739EC2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 18:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCDE761241
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 18:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhFNSvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 14:51:17 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:39473 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbhFNSvQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 14:51:16 -0400
Received: by mail-pl1-f178.google.com with SMTP id v11so7078770ply.6;
        Mon, 14 Jun 2021 11:49:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WGsIbLf37DnRyEZ62qVe83dSenYbF1V6Z+MZPlTkNjc=;
        b=j1blMPrVomNk+S3KJzqDFd0q3WNowz2gPl/F6vGxrAo+P8D2pxGJKNdl8KX5XzfhAo
         jfM4DBJw7moK6AlRxDAUhuQkb4WfGkZM3uPNvtvzkEZmcb4Btzex89va/UzJkNU4CiKZ
         J4sUEoX95D/e04zs4XeZlngaOq9IODjrKY+qO5yKAbxpT5q1wx0ELy2rdW2zRsRZWUEr
         fxXGKUJxwwAgXbsfxGgzyQn4cDTIdPxA5bSOfBu7AIKCPLldvnQTEJvMZ5+ZtCLDyt0j
         eVmZQGEMfFiOC82PENCeaU1mUyxn4qZVqAYukhwRwuQwnnWf6+wRUTmJjrU1Gg5ZRdbI
         N8wg==
X-Gm-Message-State: AOAM532piqup+4bUJZwJaqNjvu6BNSaek1eRGhvtNcHDipYzMWi/tM5M
        f6U7a8tvaTYz76oQtOJylvuqqjt5t/M=
X-Google-Smtp-Source: ABdhPJw3PAj0C0NyJEieSZvBnBAlbxp8xjtBUV/fxhJ942XIWnwYSRNbdtVNa1Cv9+fiHT8PBM5YXg==
X-Received: by 2002:a17:90a:f58e:: with SMTP id ct14mr11056921pjb.223.1623696552723;
        Mon, 14 Jun 2021 11:49:12 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id e6sm199754pjl.3.2021.06.14.11.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 11:49:11 -0700 (PDT)
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8b27b0cc-ae16-173a-bd6f-0321a6aba01c@acm.org>
Date:   Mon, 14 Jun 2021 11:49:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <75527f0ba5d315d6edbf800a2ddcf8c7@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/13/21 7:42 AM, Can Guo wrote:
> 2. ufshcd_abort() invokes ufshcd_err_handler() synchronously can have a
> live lock issue, which is why I chose the asynchronous way (from the first
> day I started to fix error handling). The live lock happens when abort
> happens
> to a PM request, e.g., a SSU cmd sent from suspend/resume. Because UFS
> error
> handler is synchronized with suspend/resume (by calling
> pm_runtime_get_sync()
> and lock_system_sleep()), the sequence is like:
> [1] ufshcd_wl_resume() sends SSU cmd
> [2] ufshcd_abort() calls UFS error handler
> [3] UFS error handler calls lock_system_sleep() and pm_runtime_get_sync()
> 
> In above sequence, either lock_system_sleep() or pm_runtime_get_sync()
> shall
> be blocked - [3] is blocked by [1], [2] is blocked by [3], while [1] is
> blocked by [2].
> 
> For PM requests, I chose to abort them fast to unblock suspend/resume,
> suspend/resume shall fail of course, but UFS error handler recovers
> PM errors anyways.

In the above sequence, does [2] perhaps refer to aborting the SSU
command submitted in step [1] (this is not clear to me)? If so, how
about breaking the circular waiting cycle as follows:
- If it can happen that SSU succeeds after more than scsi_timeout
  seconds, define a custom timeout handler. From inside the timeout
  handler, schedule a link check and return BLK_EH_RESET_TIMER. If the
  link is no longer operational, run the error handler. If the link
  cannot be recovered by the error handler, fail all pending commands.
  This will prevent that ufshcd_abort() is called if a SSU command takes
  longer than expected. See also commit 0dd0dec1677e.
- Modify the UFS error handler such that it accepts a context argument.
  The context argument specifies whether or not the UFS error handler is
  called from inside a system suspend or system resume handler. If the
  UFS error handler is called from inside a system suspend or resume
  callback, skip the lock_system_sleep() and unlock_system_sleep()
  calls.

Thanks,

Bart.
