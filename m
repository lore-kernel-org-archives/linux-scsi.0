Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B63C00140
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Aug 2022 02:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiHVCwk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 22:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiHVCwi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 22:52:38 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE45205C4
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 19:52:35 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id x19so6294606pfq.1
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 19:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=FTEOiwgWMdix2URGXZZQ75XtAoxJRZ5ekO3qACmfxok=;
        b=lmGvh/7wqbx1M0ENc/b9YzjQ+LXA/pG+jewLLeGOV9jIu7nuDd/zSYc8MG7nqqickO
         YLAJC7xe5pE8rBER2b8y1nshCEsqwMWhilBcl7hdqUSAVut6PC2t7+akyKTOvY6ogp7m
         15sy4ASJ8GDZa6lyYi0RjjFBbkXCPtmB2SUtPiH1p0R+BLVux4aM6mDGrhXTXCstZdhP
         dbTVYx+cfOuR9KntR594j3u8KJuRRem13RFTXAXVfXiQGNqfoYWQZnCLOpDcutd3soJc
         UJBsn6WSGu3SRScXhwkBCeI3qd2o9BGAw6XvGiygBGcVUI/aLaUTQz8wiICo0hm5T2gY
         DyEQ==
X-Gm-Message-State: ACgBeo00f7Byixru8FMMHKmln5ujxL9znjWtkTFc+UkJyqGQWeyyWX5w
        UyYRhDa6H21OgJ7+3pfAjpk=
X-Google-Smtp-Source: AA6agR4EfJJDbmJkNnm/iGhVkY2Kmf9fQ9+XIwwSIN/V6riZle6D7lkBHFkAQBXuD4xgsvplGVUdHA==
X-Received: by 2002:a63:8c47:0:b0:40d:2d4:e3a2 with SMTP id q7-20020a638c47000000b0040d02d4e3a2mr15724044pgn.2.1661136754592;
        Sun, 21 Aug 2022 19:52:34 -0700 (PDT)
Received: from [192.168.3.217] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id m11-20020a170902db0b00b001637529493esm7157390plx.66.2022.08.21.19.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Aug 2022 19:52:33 -0700 (PDT)
Message-ID: <ecf878dc-905b-f714-4c44-6c90e81f8391@acm.org>
Date:   Sun, 21 Aug 2022 19:52:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Hans de Goede <hdegoede@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>, gzhqyz@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220816172638.538734-1-bvanassche@acm.org>
 <decc1ef4-ec85-d947-ec81-ebeaa982f53f@redhat.com>
 <CAMuHMdVDWrLs_KusG8vXA_1z8ORdPnpfxzNqw4jCG_G0D-fn+A@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAMuHMdVDWrLs_KusG8vXA_1z8ORdPnpfxzNqw4jCG_G0D-fn+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/21/22 02:16, Geert Uytterhoeven wrote:
> It looks like there is a (different) regression in v6.1-rc1 related
> to s2idle and s2ram, which is not fixed by this patch.  In fact it
> also happens on boards where SATA is not used, it is just less likely
> to happen on the non-SATA boards.
> I still have to bisect it, which may take some time, as the issue is
> not 100% reproducible.

Hi Geert,

What kind of regression are you encountering? A crash, a hang or 
something else? Are any call traces available?

I posted another revert earlier today but that revert is for code paths 
not related to suspend/resume functionality. See also 
https://lore.kernel.org/linux-scsi/20220821220502.13685-1-bvanassche@acm.org/

Thanks,

Bart.
