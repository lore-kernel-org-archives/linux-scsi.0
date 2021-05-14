Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3441C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 03:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84A2A61442
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 03:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhEND5G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 23:57:06 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:38748 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhEND5F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 23:57:05 -0400
Received: by mail-pf1-f169.google.com with SMTP id k19so23768293pfu.5;
        Thu, 13 May 2021 20:55:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xjo3J9XFTcJBV0LLmSCwLfORzUW5E0W1YVzABtBpe3Y=;
        b=PCuKm8i04jic+raOYCV4OTk0n6oyZM6Leq5JSo+9g1BAbVzL8ft6e1lq67TWWmQVks
         hx2IFy4JD8TrRbMxDNudJD3sEPVCJmxIzrFGTRajeu9U71gGFHVIXtMonAbwRBLBmMUt
         23R8rbmVpldaFiDOXx9O8sB1C2WM3916n7dqbU5foRTIdnEK8gPNVTjdctQRhlNsEj+g
         csypXcuiwHJisyyzZIfsuWaLYNfNX2ORlzm/eLGHH4pcP6YshT52b86CW3nLWa9mi5mE
         d4An1sHiWz/zBmWgycLHmpzk51+5WJPIrSfXCKlxlpyxcturShKs1jV6EYM8RXoYymve
         kMlw==
X-Gm-Message-State: AOAM5305aa+ANu/+pHaVGIDTwgiMinEjUv5HcCiX9Kt3eNxDv+n5HOJo
        MFqiJDsv7GlnRcN/0V0AEjK2bOC8KVnt+A==
X-Google-Smtp-Source: ABdhPJw7GVhggzrLzqyjpOx7PGZZSEGlIu9TUDJEkDT20k8ap9LrerkFoTytDVfCFlUZhSD2gs1u6g==
X-Received: by 2002:aa7:9907:0:b029:28e:ab99:2a75 with SMTP id z7-20020aa799070000b029028eab992a75mr42407346pff.36.1620964553900;
        Thu, 13 May 2021 20:55:53 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:53a7:2faa:e07b:6134? ([2601:647:4000:d7:53a7:2faa:e07b:6134])
        by smtp.gmail.com with ESMTPSA id y17sm3080180pfr.119.2021.05.13.20.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 20:55:53 -0700 (PDT)
Subject: Re: [PATCH v1 5/6] scsi: ufs: Let host_sem cover the entire system
 suspend/resume
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
        open list <linux-kernel@vger.kernel.org>
References: <1620885319-15151-1-git-send-email-cang@codeaurora.org>
 <1620885319-15151-7-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b59e0cd4-d560-6724-3f30-a5232dd41a8f@acm.org>
Date:   Thu, 13 May 2021 20:55:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1620885319-15151-7-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/21 10:55 PM, Can Guo wrote:
> UFS error handling now is doing more than just re-probing, but also sending
> scsi cmds, e.g., for clearing UACs, and recovering runtime PM error, which
> may change runtime status of scsi devices. To protect system suspend/resume
> from being disturbed by error handling, move the host_sem from wl pm ops
> to ufshcd_suspend_prepare() and ufshcd_resume_complete().

In ufshcd.h I found the following:

 * @host_sem: semaphore used to serialize concurrent contexts

That's the wrong way to use a synchronization object. A synchronization
object must protect data instead of code. Does host_sem perhaps need to
be split into multiple synchronization objects?

Thanks,

Bart.
