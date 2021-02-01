Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99027C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 02:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B25A64E10
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 02:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhBAC2f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:28:35 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:33854 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhBAC21 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 21:28:27 -0500
Received: by mail-pg1-f175.google.com with SMTP id o7so11046294pgl.1;
        Sun, 31 Jan 2021 18:28:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ARGvhnM43cJPff0XjargiMIzKCXDBX6OR95+IhVDQ+w=;
        b=CNTF5K9YuSv6GUgCLNv0dWWe6kV4Jsi0i1Ajr7I88kcGFu4GQaEidQh7+D90hvP3+v
         /w1XrfqODWxjxLgMU75grzq+DIfwOnxxXWdSXc0npjXPHiCriDEJiC+L/GW1Aaxz/dKd
         AOG0OXYXMpLjW47/Qtxs1I+bNrelvmAex6rd3b+56pejngRL0fUtwiuPIPK8N1b8iUQw
         f8Lku4v2hvI8pEmMJR34bcw5E/LWTQ8gqSJVZPN1cMgDM/94SZ3U+apIr5mRoGprfYXo
         xMp78rztMwHwDthmt+t40qZM+Ff+ZfoFDBkFpalLZT6YYcmSBViwc4v8OBxVnR/pZL/L
         tjBw==
X-Gm-Message-State: AOAM530A1huanHDTbkz6tZIrDWGfxnn1MjWmONRFJnvu6CnTzIR9UyED
        D1PLderIdf+feKW+8kRlbez5wwu+EwQ=
X-Google-Smtp-Source: ABdhPJyKK4eKW9eYtRPds+vHvAOxv3JfScWepWr8H+XKACzLjnzaOEBvFsgvVWDOKkYfD4SvgkZy2g==
X-Received: by 2002:a63:9811:: with SMTP id q17mr15077930pgd.238.1612146465273;
        Sun, 31 Jan 2021 18:27:45 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:50bb:dc2d:705:e8e2? ([2601:647:4000:d7:50bb:dc2d:705:e8e2])
        by smtp.gmail.com with ESMTPSA id hs21sm13450661pjb.6.2021.01.31.18.27.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 18:27:43 -0800 (PST)
Subject: Re: [PATCH v3 2/3] scsi: ufs: Fix a race condition btw task
 management request send and compl
To:     Can Guo <cang@codeaurora.org>
Cc:     jaegeuk@kernel.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-3-git-send-email-cang@codeaurora.org>
 <73362ca9-93be-c38f-a881-4b7cf690fbc1@acm.org>
 <5f77542d66732003f0154a4e8a6ae13b@codeaurora.org>
 <56b26318de92eb88d663bbdc7096edcf@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <687cc78a-cb07-bd4f-e1c7-1ff0aeaef6b5@acm.org>
Date:   Sun, 31 Jan 2021 18:27:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <56b26318de92eb88d663bbdc7096edcf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/21 10:29 PM, Can Guo wrote:
> On second thought, actually the 1st fix alone is enough to eliminate the
> race condition. Because blk_mq_tagset_busy_iter() only iterates over all
> requests which are not in IDLE state, if blk_mq_start_request() is called
> within the protection of host spin lock, ufshcd_compl_tm() shall not run
> into the scenario where req->end_io_data is set but
> REG_UTP_TASK_REQ_DOOR_BELL
> has not been set. What do you think?

That sounds reasonable to me.

Thanks,

Bart.
