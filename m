Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0254C11F64
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 15:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3FFE6141A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 15:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhGAQAc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 12:00:32 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:35373 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhGAQAb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 12:00:31 -0400
Received: by mail-pl1-f169.google.com with SMTP id b5so3909465plg.2;
        Thu, 01 Jul 2021 08:58:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y8RJ7NHLUH0UkXZQbqLTPlcYrodTSF7e3TMEWx7woGM=;
        b=hBSumFy8zhnstzAI41g+4dnLsD7YB10bmQ6//o5vOf9uKmAa5TIAFe0wA35h/ZVGK2
         o569HGniyobCgsoHJPAVimX3544vYQSUk6WUjQmIdylortz51v1TI+RLzqttyE9bUNEY
         xdni7lv+pP6YqJ9ZM8Sm0loYXUhCjkvwx7g2qzZ+zBqsFFU7p08f2VAmZ0ioyJH1cwtQ
         S2+V0kxtfg8TFdtn3y+tJPcNvttqBk4VoUn3ETGwBFsQk+J004UFyg1zqCE7YePjIVKN
         10I49Qb42I0zsaYzUFnoo4PnReyfiID/3vlkE9niBT5X3MkzsRCgSbQwRV44I/4xMqF/
         9PXg==
X-Gm-Message-State: AOAM530FbZsA/rTSKDa1uaPeArcStsXawlASQWMTyS0bA737jd1RJaRe
        ifjAlrAG7lS3ZRM4NkFGloM=
X-Google-Smtp-Source: ABdhPJzVG+t6KRlrq32BvCj+MdsP5nTMwJW2oiZ8u2tKUXjf6dvTOkgsc5cIk2jTuqU8K/ihKx43kg==
X-Received: by 2002:a17:90b:1944:: with SMTP id nk4mr420440pjb.66.1625155080441;
        Thu, 01 Jul 2021 08:58:00 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6a75:b07:a0d:8bd5? ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id t6sm9984750pjo.4.2021.07.01.08.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 08:57:59 -0700 (PDT)
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
 <1621845419-14194-3-git-send-email-cang@codeaurora.org>
 <c31185f5-e816-937d-25ac-1657b6111ff8@acm.org>
 <464097469b09752ce4ebb38c08f1a94a@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8971042b-e300-a1b4-7585-be9e0cf43030@acm.org>
Date:   Thu, 1 Jul 2021 08:57:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <464097469b09752ce4ebb38c08f1a94a@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/21 10:41 PM, Can Guo wrote:
> I am waiting for more infos/logs/dumps on Buganizor to look into it.
> With above calltrace snippet, it is hard to figure out what is happening.
> Besides, we've tested this series before go upstream and we didn't
> see such problem.

Hi Can,

Jaegeuk has posted a fix as you may have noticed.

Thanks,

Bart.
