Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61C7C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 15:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C747E6101B
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 15:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbhEQPIi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 11:08:38 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:46952 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242295AbhEQPGi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 11:06:38 -0400
Received: by mail-pg1-f173.google.com with SMTP id m124so4817907pgm.13;
        Mon, 17 May 2021 08:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3r35L0qNENJHIBlJuhpmCbhxw+UQzhph/PXwpvUMIxo=;
        b=Tp+Nall+Jk5041wXioENH5diARN3Ksvf/pwQ01FzI9CW/f8xjOAFMxVSUaYUcccaOP
         hwecM7JN5B3N5M1jEjQynxtTfbs0EynObb7pFQ/GqEqw56k5ruWfTx1H55l2AyK/JNen
         uEW/98hYJ//Szz7xv7b4zGaAxGGPqGnam5NoJbZrtpLeP2Uf5dbVAo1LdZ+xJsSGnk5u
         mjxG0W4aLsGA3xZA9KzXkluMKYQDGFAR8iw2DI7E8De+Vy2Wf46umhvZp2zyRux9q0FF
         vpFOdCvVVCSZsoYPLsDjodEm5CLXE5n/3WtE/KKyo/D+kox6MKvtEMRO5ruzsWmBcdUz
         eP7g==
X-Gm-Message-State: AOAM532dFby3kJB03EtrKWTR5TC/GupxiSfjYfGLuUgTmxj9zhCbkcVJ
        UBGlNe+8G8yIHHJgiRiS7BJX7FukA8U=
X-Google-Smtp-Source: ABdhPJwWop1b09JK5L3WA+EljJ/aR6GpcRyko4Y+tVvGFb4B/9O6jGgQaI3GFoO2J05h2+0dLJWclA==
X-Received: by 2002:a63:784c:: with SMTP id t73mr74045pgc.62.1621263920351;
        Mon, 17 May 2021 08:05:20 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8224:c0d6:d9dd:57b3? ([2601:647:4000:d7:8224:c0d6:d9dd:57b3])
        by smtp.gmail.com with ESMTPSA id z62sm10030427pfb.110.2021.05.17.08.05.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 08:05:19 -0700 (PDT)
Subject: Re: [PATCH v1 5/6] scsi: ufs: Let host_sem cover the entire system
 suspend/resume
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
References: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
 <1620885319-15151-7-git-send-email-cang@codeaurora.org>
 <b59e0cd4-d560-6724-3f30-a5232dd41a8f@acm.org>
 <98a7135ef1ce34e23e84817cf6167e1a@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <31858ed5-dffe-82f8-aca6-94744f147059@acm.org>
Date:   Mon, 17 May 2021 08:05:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <98a7135ef1ce34e23e84817cf6167e1a@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/16/21 8:22 PM, Can Guo wrote:
> Hi Bart,
> 
> On 2021-05-14 11:55, Bart Van Assche wrote:
>> On 5/12/21 10:55 PM, Can Guo wrote:
>>> UFS error handling now is doing more than just re-probing, but also
>>> sending
>>> scsi cmds, e.g., for clearing UACs, and recovering runtime PM error,
>>> which
>>> may change runtime status of scsi devices. To protect system
>>> suspend/resume
>>> from being disturbed by error handling, move the host_sem from wl pm ops
>>> to ufshcd_suspend_prepare() and ufshcd_resume_complete().
>>
>> In ufshcd.h I found the following:
>>
>>  * @host_sem: semaphore used to serialize concurrent contexts
>>
>> That's the wrong way to use a synchronization object. A synchronization
>> object must protect data instead of code. Does host_sem perhaps need to
>> be split into multiple synchronization objects?
> 
> Thanks for the comments. These contexts are changing critical data and
> registers, so the sem is used to protect data actually, just like the
> scaling_lock protecting scaling and cmd transations.

But where is the documentation that explains which data members are
protected by hba->host_sem and which data members are protected by
hba->host->host_lock? Was the host_lock protection perhaps introduced
before scsi-mq was introduced? Before scsi-mq acquiring the host_lock
was sufficient to serialize against ufshcd_queuecommand() but that is
not sufficient when using scsi-mq.

I want to verify whether locking is used correctly in the UFS driver but
without documentation of which synchronization object protects which
data members that is not possible.

Thanks,

Bart.
