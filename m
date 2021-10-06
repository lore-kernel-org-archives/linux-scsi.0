Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8EBC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 04:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A68D361175
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 04:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhJFEEX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 00:04:23 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:33620 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhJFEEW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 00:04:22 -0400
Received: by mail-pj1-f49.google.com with SMTP id cs11-20020a17090af50b00b0019fe3df3dddso3023717pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 Oct 2021 21:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3NfoG0nr7eSD+yHE0ezo9tSXYQJCxUvQ/OrkDl2bbRk=;
        b=l8hFsQZk5I984CWFZFvdpFGHp5ur423uJPj1Uh/pJsTuG0onBLuRJAuxcJCn974T+z
         wW+6pcONImtafm2rLRZVTZU0XvLzougg7nltuBfHgfHnaxYNdoAKYKjdtg4fPRBj8d2r
         kSZCXxaWuNUKiGTjQ/aCeZQ+iAAqnH+c2g2e9OUt0Dfap1R7tmrbGgIbwIBz5wfaL6rp
         1ux5WnYytkhu/9VmpUVOLU1JjxGfyXbMhknX4Vyu2e0JCuMi7B6+zDpugEWAtQKoq7pf
         UUR7CH8VuHVjLIEaQTbi+4Gy8tJLCwQOTtjARMGuWZphCVBQDmwNQzIbofb9ngX7MVbz
         I1YA==
X-Gm-Message-State: AOAM530fc1nVpJfP+WOXv6VcxHgUuR5vMVRToKE4DfUun08MU2ac8nT/
        WvrTaquB7ujz3TMQwzHv5Jw=
X-Google-Smtp-Source: ABdhPJzyRpXeaLEkfzzWcQs7Lcw2V0Vjjs09M6WjoMo9OaBPP1q/IvZEI06q+C0CR3zMT69a9lgwAw==
X-Received: by 2002:a17:903:208b:b0:13e:d2b9:f2e8 with SMTP id d11-20020a170903208b00b0013ed2b9f2e8mr8780482plc.66.1633492950494;
        Tue, 05 Oct 2021 21:02:30 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:4a11:5a1c:6c65:8b55? ([2601:647:4000:d7:4a11:5a1c:6c65:8b55])
        by smtp.gmail.com with ESMTPSA id i125sm18993666pfc.36.2021.10.05.21.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 21:02:29 -0700 (PDT)
Message-ID: <fda69919-44d3-1150-7141-a71e5900bb20@acm.org>
Date:   Tue, 5 Oct 2021 21:02:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v3 0/2] scsi: ufs: support vops pre suspend for mediatek
 to disable auto-hibern8
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        jonathan.hsu@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com, mikebi@micron.com
References: <20211006030959.20533-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211006030959.20533-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/21 20:09, peter.wang@mediatek.com wrote:
> Mediatek UFS design need disable auto-hibern8 before suspend.
> This patch introduce an solution to do pre suspned before SSU
> (sleep) command.
> 
> Peter Wang (2):
>    scsi: ufs: support vops pre suspend
>    scsi: ufs: ufs-mediatek: disable auto-hibern8 before suspend

Please always include a changelog when posting a new version of a patch
series.

I have the same comment about v3 as for v2: I don't think that this
series is bisectable so please combine the two patches into one patch
or add "if (status == PRE_CHANGE) return" in ufshcd_vops_suspend() in
patch 1/2 and remove this again in patch 2/2.

Thanks,

Bart.
