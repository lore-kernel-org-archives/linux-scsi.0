Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292A4C4338F
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 16:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 052DD60C41
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 16:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhHFQPP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 12:15:15 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:43888 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhHFQPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 12:15:14 -0400
Received: by mail-pj1-f41.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so18541939pjb.2;
        Fri, 06 Aug 2021 09:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wNsM+1YyZZNK7a41MjfUZ5VFBCb8HrCjmrdsKigdGMk=;
        b=cX0R9AwVC1HzEBYPef6haQXt4Yb3tOo5kULahws4ExhkxwbMlUk1fohSUFDY+2Qcpf
         d3Ltoy4mFV4yDtfx92qsCiLfFK//QIJtbO56KN+7sHYleVMxhzqlkz/wPY3NSkwMkytL
         oTF+cX+LF+V4kGkkfv+5kd3dt1FiminDdQ9FL0YN2ZViBAjZtfYTa8Ya+xjo7AP022pI
         kU/3TPnJSybu7i6+N2f8L8wpVLa+RkrzZ4TB5Fin/jwrWiOFmtOilgU8gu5GjjcAtFEv
         CLojx8aKL9mdHDPPRUmFrw9yPg8CqEVQobMFaVhxN2jUOjhwj8G8lXbtuqq1DQstsvl7
         OOFg==
X-Gm-Message-State: AOAM533mwisqZ6FdhQNusj0VURxi8G0RYM80Qfsj7x7lbLorHf1cW+93
        +ZZzEXOuwjrDxGtpHFN9VC8=
X-Google-Smtp-Source: ABdhPJyMKhWpBM1g9nnOnSt+UrSAwKUKkRUQPOpAvC6hNX54KZVhztU6vq3KWUTX0zZoOp5McgRPJw==
X-Received: by 2002:a62:b414:0:b029:317:52d:7fd5 with SMTP id h20-20020a62b4140000b0290317052d7fd5mr11593972pfn.30.1628266497444;
        Fri, 06 Aug 2021 09:14:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:1:1655:15af:599e:3de1])
        by smtp.gmail.com with ESMTPSA id x4sm7172564pff.126.2021.08.06.09.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 09:14:56 -0700 (PDT)
Subject: Re: [RFC PATCH v1 0/2] scsi: ufs: introduce vendor isr
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
References: <CGME20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229@epcas2p1.samsung.com>
 <cover.1628231581.git.kwmad.kim@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b3c18b34-2108-abfa-54ca-096a3eb31318@acm.org>
Date:   Fri, 6 Aug 2021 09:14:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <cover.1628231581.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/21 11:34 PM, Kiwoong Kim wrote:
> This patch is to activate some interrupt sources
> that aren't defined in UFSHCI specifications. Those
> purpose could be error handling, workaround or whatever.

How about extending the UFS spec instead of adding a non-standard 
mechanism in a driver that is otherwise based on a standard?

Thanks,

Bart.
