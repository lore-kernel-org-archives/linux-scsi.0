Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C565C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 03:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5246061A10
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 03:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhCZDP1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 23:15:27 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:35807 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhCZDPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 23:15:12 -0400
Received: by mail-pj1-f53.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so3597759pjb.0;
        Thu, 25 Mar 2021 20:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k7xKdTqEOKvltFe7bcmwKO2vxx2QM8xUcV2m4JVl8Vw=;
        b=c/yBz1NQnHyU8ZX6yKuBEbr7qScLTY63ba5D49cZKwHXbanOqN0BSY9xD+KZ45ZA61
         WZ3uesnSQWZz2+xkT9cR/ZawyDiPs0hxlAmx4zXJNJ4Yi3KGpwwQYSARglscCmxFj/Tb
         zL1ekifl+lHrnHYESdtYoVym8qL3omaFRq726Tam3FLJxdzeH2/gU7R0dA9AteLybS/3
         UXwy8OelqpdiFjiJ7Vq1qMHzdvnJzWiP71/Y7VRkGFe0PnhAvOIjUi2zKjBSmfT8RYs5
         qAKxHOhlb60VTlfIjY5JN7+XpSUxuckmP4hzdbhL12mgV8KP9EIaFCaGms2cS0ZTqGP9
         DGLA==
X-Gm-Message-State: AOAM531/YMMXiJ87kcyfMsF7DZJwryAXBES477o/gUwDQJwHPfFdEty7
        r1UkNVw7LE3hGV8eAzfROsg=
X-Google-Smtp-Source: ABdhPJyh+FATGWHkKf/6jeyUvgjNV3lk43VAsPZYBV3RWBNreLN5Waj7OBmbvkCvs35mvgZ0rxQ/Dw==
X-Received: by 2002:a17:90a:e2ca:: with SMTP id fr10mr11511698pjb.154.1616728511945;
        Thu, 25 Mar 2021 20:15:11 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c5af:7b7c:edac:ee67? ([2601:647:4000:d7:c5af:7b7c:edac:ee67])
        by smtp.gmail.com with ESMTPSA id u12sm6997071pfn.123.2021.03.25.20.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 20:15:11 -0700 (PDT)
Subject: Re: [PATCH v31 4/4] scsi: ufs: Add HPB 2.0 support
To:     daejun7.park@samsung.com, Can Guo <cang@codeaurora.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
References: <b3a524b1c720007b295e3c3b888a42f9@codeaurora.org>
 <d7f98f965e724e708e85535bdcc53075@codeaurora.org>
 <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
 <20210322065504epcms2p698791fed570484f8de2688d238dff4c6@epcms2p6>
 <20210325004732epcms2p2f8990a22df33f9cfdb303e8da62e8fa7@epcms2p2>
 <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p8>
 <20210326025559epcms2p801247571065a1aa568c234d77e635745@epcms2p8>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f018a0cd-de0c-f7ca-7b88-146c9ebd8430@acm.org>
Date:   Thu, 25 Mar 2021 20:15:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210326025559epcms2p801247571065a1aa568c234d77e635745@epcms2p8>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/25/21 7:55 PM, Daejun Park wrote:
>> Please address it in next version. After that, I will give my 
>> reviewed-by tag.
> 
> OK, I will do.
Hi,

Please trim emails when replying. Otherwise it is very hard to follow a
conversation. It took me plenty of scrolling to find the above reply.

Thanks,

Bart.
