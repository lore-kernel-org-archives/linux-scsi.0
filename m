Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F10C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 02:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E41E60462
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 02:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241740AbhIAC44 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Aug 2021 22:56:56 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:36723 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241725AbhIAC44 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2021 22:56:56 -0400
Received: by mail-pg1-f171.google.com with SMTP id t1so1310039pgv.3
        for <linux-scsi@vger.kernel.org>; Tue, 31 Aug 2021 19:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sLupmFKaKQRcnyvHnmavhP0aDh9A0FzUOsF+oM0jF48=;
        b=SRS5K/7TInZSDkjaViDXwHnY9FDc27q+/zfgqcXGGIw/yd9nYWIYH98EHyBPNOkNfo
         V5jJxFm74JgvuHu3FAEol2smkwAraCV5EeGdKFF/QP4Bnk9wjbsCuK2mPKZkikZhJu+J
         3ZxW1w2B4JaQIfLT8cr48qWA9N68LTwcHd+F+aNR90QHqtGFCtoFwrhg7fK0LJ/KHZyw
         Em+Hw39DYz+7wOhpQiBCLM39Rdn63JZ2IIMWpR/lBglHPQ91t9Lp9E6owe2eOyp/kKnh
         GkLd3/RPEPHEb3wCLPQL3IAYwQB3CSGq3X4WQflqX0PoV7X8eT8t74wSnVy6VFuvUZJr
         Fcpg==
X-Gm-Message-State: AOAM53370SBmvgVBEgeY+86c3qNPR54eT9SfzpDWfMLgPGndEC79bR9u
        lyGHe+ADhjQ4UMOUlw7DGRg=
X-Google-Smtp-Source: ABdhPJxsukK2NE3tWjLoXT6l1cxl2cAiJBiAB+eEP3Uc4ngLpvYhkRLdnt3WRtf5yl+etkaVik8Xag==
X-Received: by 2002:a65:648b:: with SMTP id e11mr29592431pgv.138.1630464959659;
        Tue, 31 Aug 2021 19:55:59 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:2f84:a3f9:160a:bc19? ([2601:647:4000:d7:2f84:a3f9:160a:bc19])
        by smtp.gmail.com with UTF8SMTPSA id b5sm14717250pfr.26.2021.08.31.19.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 19:55:58 -0700 (PDT)
Message-ID: <e3f14336-2cc6-3985-fd52-ead795737417@acm.org>
Date:   Tue, 31 Aug 2021 19:55:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH v1] scsi: ufs: ufs-mediatek: Change dbg select by check hw
 version
Content-Language: en-US
To:     Peter Wang <peter.wang@mediatek.com>, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        jonathan.hsu@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com
References: <1630325486-11741-1-git-send-email-peter.wang@mediatek.com>
 <dda8eb67-fe56-8bc0-5ce8-a62bd4e6b995@acm.org>
 <da0ebaf6bb6e556eeb2f6fe4037d891bafc79ecd.camel@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <da0ebaf6bb6e556eeb2f6fe4037d891bafc79ecd.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/31/21 19:29, Peter Wang wrote:
> REG_UFS_MTK_HW_VER is a read only mediatek dedicated register.
> So, hw_ver will get a const value for mediatek to decide how to use
> debug select. It only need read once, no need multi-threads protected.

Hi Peter,

The above can be concluded easily by a human but not by software. If 
this code is analyzed with KCSAN then KCSAN will probably complain. See 
also Documentation/dev-tools/kcsan.rst.

Anyway, I'm fine with this patch.

Thanks,

Bart.
