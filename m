Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603E5C4708F
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 00:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369DF6100A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 00:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhFCAUk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 20:20:40 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:39857 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFCAUj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 20:20:39 -0400
Received: by mail-pj1-f50.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so4418638pjp.4;
        Wed, 02 Jun 2021 17:18:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J5zd1hQ722vpm1HO3eh2WAzXPsJQcOGu8eyeuVd42ws=;
        b=QmxK6DDKOhJp2aHA3nEw3v4VGS3ltE9Sl2ZjZjsUrmDOxIK6X5SGv4ZfnrT3WI8nyj
         4bONG1/FTBSJEzxvxAIAt3K2NI1T/5AJChGxLgyk8LUCA5sW6c18kqUokkk5MUMdv2Yb
         WFUPKX8JaMGfz4tyyFq56EDhG6y+rxZ0Yz1+g9WM+qrFfH53pNGs6mefWPtdgN1n+DOU
         Yu9acYB4qWHLvJV9hZv3uwNM6LjajSZtEoMTqLV4BYrw8AYJdCjPoEXyUyDSS+g3xZiq
         zU3Xe8SjGkqU0DmA+Zfp6tpB3MNJDG3DT4/QfOAzc6q/5Qp/3g1M9cvmsHQrpF98/if/
         0yYg==
X-Gm-Message-State: AOAM533x1ZEqoGuNvedKYPa7OB8pCmD+m4qDbvrpjGSPBgyAM5WCsFTT
        U7cau4UD8sBfdptp+KvxH1U=
X-Google-Smtp-Source: ABdhPJyluBOAMWA/V2/RAthcvrAXnZ9wwZk0KipnaoZNTQWPqtc0SjnM7Pu8HK2uBGzRggYYyo6+0w==
X-Received: by 2002:a17:90a:414d:: with SMTP id m13mr7956152pjg.115.1622679535334;
        Wed, 02 Jun 2021 17:18:55 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id h8sm547606pfv.60.2021.06.02.17.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 17:18:54 -0700 (PDT)
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer requests
 send/compl paths
To:     Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
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
 <6d6d296a84f1e62f65fda4d172a85bb35d9a3684.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <200da9c5-ea20-819e-2b11-7f45e8b05cbb@acm.org>
Date:   Wed, 2 Jun 2021 17:18:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <6d6d296a84f1e62f65fda4d172a85bb35d9a3684.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/21 9:04 AM, Bean Huo wrote:
> I did a UFS queue limitation test before, observed that once the
> queue is full, then the active task number in the queue will get
> down. For the Nvme, the scenario is the same. You can refer to the
> slide 23, and slide 24 in the pdf: 
> https://elinux.org/images/6/6c/Linux_Storage_System_Bottleneck_Exploration_V0.3.pdf
> I don't know if your patch can fix this issue.

Hi Bean,

That's a very interesting presentation. Unfortunately the overhead for
SCSI in that presentation includes the SCSI core + UFS driver. Given the
use of the host lock in the version of the UFS driver that was used to
prepare that presentation, the overhead introduced by the UFS driver may
be significant. Maybe someone should measure the overhead of the
scsi_debug driver and compare it with the NVMe loopback driver to get a
better idea of how the overhead of these two subsystems compare to each
other?

Bart.
