Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBE6C48BE5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 21:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0E2361285
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 21:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFKVU6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 17:20:58 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:33755 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhFKVU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 17:20:58 -0400
Received: by mail-pf1-f182.google.com with SMTP id p13so5487644pfw.0;
        Fri, 11 Jun 2021 14:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1f+rAIFWuXQC60Z4MJLpUOHXAysawucJQzzXOQQ+vvk=;
        b=KOi5fICf/Y/0aD+R/wdYOEkQZ/nvajQkAlUIDKuDwKbg8YvEzOe1k/b7WtWdDLid6y
         KMrV8qZXS6yqZpGvVzFK8Xj5SBxaCOQ0hqFq7y5DsmZ+TO2dcIaNxIzyoLLEc8NUeXXb
         BUsfzPz0Y8Do7GsMdpeaWlh+HvMw1ZixlGb2crD94dDTLxKyrukDYEH9j6JqPsLPsSjF
         RNldR4HEZu71cjN7a7PnJTWsYDMFczX4dJohFPyKjVvJgboFiIYf6eWwG79PJDDqxtmU
         eXgXCxZU3dlmN52dagC8zpXLodtyGTC7UAm302Q4swGJl+DVcdtclNAmTZMk0y35Bh/a
         1Lfg==
X-Gm-Message-State: AOAM533nO/7IyA4yzvAWO7tHjuafxlsivfWV4YeK3vHOieUUjCILbDA4
        uMHMpKyoVwkE289d/TrpGBsYCBWhQgOveA==
X-Google-Smtp-Source: ABdhPJzP79R71FfpIhy3T67G4pnx1TqEVnQZJw0M0TvAIZy+0gb+2OrKFCMxp35EOZUTrRF0F7Bv2w==
X-Received: by 2002:a05:6a00:189e:b029:2f0:94d6:78c5 with SMTP id x30-20020a056a00189eb02902f094d678c5mr10193537pfh.46.1623446323016;
        Fri, 11 Jun 2021 14:18:43 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w23sm5817998pfi.220.2021.06.11.14.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 14:18:42 -0700 (PDT)
Subject: Re: [PATCH v37 0/4] scsi: ufs: Add Host Performance Booster Support
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
References: <CGME20210611022142epcms2p374ea5b82cfe122de69a7fefe27edf856@epcms2p3>
 <20210611022142epcms2p374ea5b82cfe122de69a7fefe27edf856@epcms2p3>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a5b89372-fdb6-efe0-919f-59041d643071@acm.org>
Date:   Fri, 11 Jun 2021 14:18:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210611022142epcms2p374ea5b82cfe122de69a7fefe27edf856@epcms2p3>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/10/21 7:21 PM, Daejun Park wrote:
> Changelog:

Does this patch series perhaps need to be rebased? This is what git am
reports against Martin's 5.14/scsi-staging branch:

$ git am ~/20210610-\[PATCH\ v37\ *
Applying: scsi: ufs: Introduce HPB feature
error: patch failed: drivers/scsi/ufs/ufshcd.c:24
error: drivers/scsi/ufs/ufshcd.c: patch does not apply
Patch failed at 0001 scsi: ufs: Introduce HPB feature
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

$ patch -p1 < ~/20210610-\[PATCH\ v37\ 1_4\]\ scsi_\ ufs_\ Introduce\
HPB\ feature-10889.eml
patching file Documentation/ABI/testing/sysfs-driver-ufs
patching file drivers/scsi/ufs/Kconfig
patching file drivers/scsi/ufs/Makefile
patching file drivers/scsi/ufs/ufs-sysfs.c
patching file drivers/scsi/ufs/ufs.h
patching file drivers/scsi/ufs/ufshcd.c
Hunk #1 succeeded at 24 with fuzz 2.
Hunk #2 succeeded at 4985 (offset 20 lines).
Hunk #3 succeeded at 5013 (offset 20 lines).
Hunk #4 succeeded at 5041 (offset 20 lines).
Hunk #5 succeeded at 7123 with fuzz 2 (offset 15 lines).
Hunk #6 succeeded at 7523 (offset 12 lines).
Hunk #7 succeeded at 7551 (offset 12 lines).
Hunk #8 succeeded at 7792 (offset 12 lines).
Hunk #9 succeeded at 7938 (offset 12 lines).
Hunk #10 succeeded at 8087 (offset 12 lines).
Hunk #11 succeeded at 8135 (offset 12 lines).
Hunk #12 succeeded at 8839 (offset 12 lines).
Hunk #13 succeeded at 8964 (offset 12 lines).
Hunk #14 succeeded at 9042 (offset 12 lines).
patching file drivers/scsi/ufs/ufshcd.h
Hunk #1 succeeded at 641 (offset -2 lines).
Hunk #2 succeeded at 870 (offset -2 lines).
patching file drivers/scsi/ufs/ufshpb.c
patching file drivers/scsi/ufs/ufshpb.h

Thanks,

Bart.
