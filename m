Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7861C63777
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 17:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8175722226
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Nov 2020 17:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgKURAI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Nov 2020 12:00:08 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42106 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgKURAH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Nov 2020 12:00:07 -0500
Received: by mail-pg1-f193.google.com with SMTP id i13so10208211pgm.9;
        Sat, 21 Nov 2020 09:00:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8+FwoGnhkNqC4D+I1tikeB1jkqsjc5JXnvVvcizyflo=;
        b=t0mE4TbiBb3qtzGqivHSG74zKeSadhoaHhCk9EAukxMaynS8iDKXZNxdmeWHU96boA
         EYDVXsG33xfN8TSh4jwiseKfV2sY7TzHgoK47JZsgwKMPLYSwPN+D0NaTqM388uT2LRP
         8iyiQMbUtpz6dI1isNZ5Cbs32ZpE1pbQVVNcfgLv5CxVSh+eNj/SmnLhzbQQfv0lcUvD
         CaNo9Vq08RuWwd0er3t5ZDiGkys5WnngyK357Ea33DYDZOYhefA0oCvqU8mgW8ea7jWl
         xegmMx/z8AopMgmLHafMQ/d4VPWsF9ifWFGAzZVeDFKdy96kx0sjdc/Akwqu4M+zOxoq
         55Uw==
X-Gm-Message-State: AOAM533qEIEJctiX/chYEcC+rk/HDIkzWLxaVeVAokQjhgL3PNxFN30F
        DjFhv+gehpwDm/zdlkOUxFM=
X-Google-Smtp-Source: ABdhPJyxy/H6u8Ho9oBYVJFC/Mik+O7+fdULAu0DjEGX6d/fYNIjNqNNQEXrSeYivEP2OFdi38NeaA==
X-Received: by 2002:a17:90b:11cf:: with SMTP id gv15mr16712251pjb.11.1605978006074;
        Sat, 21 Nov 2020 09:00:06 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id a8sm7263973pfa.132.2020.11.21.09.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Nov 2020 09:00:04 -0800 (PST)
Subject: Re: [PATCH RFC v2 1/1] scsi: pm: Leave runtime PM status alone during
 system resume/thaw/restore
To:     Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1605861443-11459-1-git-send-email-cang@codeaurora.org>
 <20201120163524.GB619708@rowland.harvard.edu>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9df460a7-c7fc-4999-bfaa-076229b8a752@acm.org>
Date:   Sat, 21 Nov 2020 09:00:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201120163524.GB619708@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/20/20 8:35 AM, Alan Stern wrote:
> On Fri, Nov 20, 2020 at 12:37:22AM -0800, Can Guo wrote:
>> Runtime resume is handled by runtime PM framework, no need to forcibly
>> set runtime PM status to RPM_ACTIVE during system resume/thaw/restore.
> 
> Sorry, I don't understand this explanation at all.
> 
> Sure, runtime resume is handled by the runtime PM framework.  But this 
> patch changes the code for system resume, which is completely different.
> 
> Following a system resume, the hardware will be at full power.  We don't 
> want the kernel to think that the device is still in runtime suspend; 
> otherwise is would never put the device back into low-power mode.

Hi Alan,

Does this mean that every driver needs similar code for handling runtime
suspended devices upon system resume? If so, would it be possible to
move that code into the power management core (drivers/base/power)?

Thanks,

Bart.
