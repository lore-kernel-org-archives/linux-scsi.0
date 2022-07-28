Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67817C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 21:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiG1VJU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 17:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiG1VJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 17:09:18 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23CF6E2C4
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 14:09:17 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id f11-20020a17090a4a8b00b001f2f7e32d03so5890729pjh.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 14:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Lyi8U+Ii4fVfb5gf7+2FrD8JGQrjhTiU6yH1xtTTg/w=;
        b=SbE/oaIHU9gS7BHyNcbnGImiICssnpRt5U24jQaHS7c5WSTUI1f8g7NNv1HvqqYAe6
         TeECu9nSzQdFKOamEXTs0pOsKcrBOwwSg4u/lW/ki2geVllxES/Q41qkkCePgZKle91m
         rXyQ/fLPl9QWtb+uolAPHmlFlBzZAxOAJH2LeAIsbr3wFJIG4Tu4h6BAiblnbHarr6of
         dUN5DTTR99Rtm9jLq+iA/L0MylYRnJja6rhVdPutKB0JA1Pmjs6f5tnqvuRW1wdgPHuM
         aCsJTBVqEyLQ2vwbiJsEklelt2YtBVtR0O/9rdo78RrvJT8mz7JSyU5FQN76pQxabNYs
         K8Dw==
X-Gm-Message-State: ACgBeo0mfBtY2kDHIc/+TYBrnuSYhjRO0RLbe79l9gzThPxWUblZyqNh
        8Xkb+j2ZM6oMz+IBeKoY2Vc=
X-Google-Smtp-Source: AA6agR64abIOX2ysY7VcL3JkGNB0p5eUsBWTITWET/AvauG63Mt114Tw/uFvUHgzRplDX9SS0QSR3g==
X-Received: by 2002:a17:902:a382:b0:16d:9b15:83d5 with SMTP id x2-20020a170902a38200b0016d9b1583d5mr669128pla.101.1659042557265;
        Thu, 28 Jul 2022 14:09:17 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9520:2952:8318:8e3e? ([2620:15c:211:201:9520:2952:8318:8e3e])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903120d00b0016b8746132esm1889851plh.105.2022.07.28.14.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 14:09:16 -0700 (PDT)
Message-ID: <968f5255-f7b9-e011-2bd3-aa711bdd142a@acm.org>
Date:   Thu, 28 Jul 2022 14:09:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 0/2] ufs: allow vendor disable wb toggle in clock
 scaling
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220728071637.22364-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220728071637.22364-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/28/22 00:16, peter.wang@mediatek.com wrote:
> Mediatek ufs do not want to toggle write booster when clock scaling.
> This patch set allow vendor disable wb toggle in clock scaling.

I don't like this approach. Whether or not to toggle the write booster 
when scaling the clock is not dependent on the host controller and hence 
should not depend on the host controller driver.

Has it been considered to add a sysfs attribute in the UFS driver core 
to control this behavior?

Thanks,

Bart.
