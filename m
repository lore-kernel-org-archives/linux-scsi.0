Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B45C48BD1
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 20:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38C2D613CD
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 20:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhFKUmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 16:42:32 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:52000 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhFKUmb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 16:42:31 -0400
Received: by mail-pj1-f54.google.com with SMTP id k5so6340578pjj.1;
        Fri, 11 Jun 2021 13:40:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VBC7+WT0Vk4vkpbLajR4Eb1p+InWGXtxLVxgmGQcfQY=;
        b=dKwj5qp218qjxz6YDHOdFjPBVDQSUh83kyre8PfX9J2G9e5oUs5kI/Wey01jl1AAen
         IJF9OyW8H8rzaVimXq3nAPABzzerE/6yxZWQCa1EEKp1RH4KJrCapKFE3SnpiwxbjGYm
         V/dce9GCT0QCLnX1dH+DlVt++6bKeFzn8rUVYP4rGkYAGryyn5RloDBDwtbueX1f1Tcz
         eKVqCmJoKxsMh87zpT0l7LGTrMJMtl2giNcAW1cAwUg7Gfwnyh4iMZUC1lEPzLveCzaw
         YYfRbcJXEISeJO3jtPd7jh2EOVphxzDiK/fYHGmmNl0TUFsO/G8ntrd+U+11eSYUM6uq
         dLjg==
X-Gm-Message-State: AOAM5331Cz7RPQrspGIICjSmAqCD/LZ7aJIEpRA5LafMxWQ98mFznyWn
        xObpU7r0RDI02PWoUrgA2xgnaGaAYWQ=
X-Google-Smtp-Source: ABdhPJzMIaF7TmDhI7kc8Lyf+X6Tg3BFkml8lj/07PPSqp1xUmOLzlYNzACBPoLCSejFAj8+qB694w==
X-Received: by 2002:a17:90b:234d:: with SMTP id ms13mr6121414pjb.135.1623444021938;
        Fri, 11 Jun 2021 13:40:21 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v11sm11477420pju.27.2021.06.11.13.40.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 13:40:21 -0700 (PDT)
Subject: Re: [PATCH v3 1/9] scsi: ufs: Differentiate status between hba pm ops
 and wl pm ops
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
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
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-2-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1b581673-a5f7-f2a8-787c-f055082dc9d2@acm.org>
Date:   Fri, 11 Jun 2021 13:40:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1623300218-9454-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/21 9:43 PM, Can Guo wrote:
> Put pm_op_in_progress and is_sys_suspend flags back to ufshcd hba pm ops,
> add two new flags, namely wl_pm_op_in_progress and is_wl_sys_suspended, to
> track the UFS device W-LU pm ops. This helps us differentiate the status of
> hba and wl pm ops when we need to do troubleshooting.

Since "WL" is an uncommon abbreviation, please add a comment above the
definition of struct ufs_hba that explains the meaning of the new member
variables.

Thanks,

Bart.
