Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F17AC4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Dec 2022 21:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbiLTVBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Dec 2022 16:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiLTVA7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2022 16:00:59 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2711DF18
        for <linux-scsi@vger.kernel.org>; Tue, 20 Dec 2022 13:00:57 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id m19so19281451edj.8
        for <linux-scsi@vger.kernel.org>; Tue, 20 Dec 2022 13:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=88yRQkH8x/8fi3zx+xak9LdLlIZZTX7XIR+oFyhPiJU=;
        b=ikVGT9c7jlXGiAFQm/eF+ljkcJz0xH53jGjqSJQ1ajIIdtYfc4fc9uKpjQNwfNhecR
         eA7UTfijcug1LXEFvL1mgLlq+tZwAmOmN+yKewwD3SOIvwlaLX9tDOqZUdupCtj/4H/c
         jug5yeGyniAbp7KxvhH8WsQeFxPHU3HJV9rz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=88yRQkH8x/8fi3zx+xak9LdLlIZZTX7XIR+oFyhPiJU=;
        b=0REIR8o54+RrSEj0M1RTdao4kN+3IB+uwf30b+hcGkgx29PP35xeszMgGthtFRDC//
         lEhbPEvOu1yIvnwfbRGsIJcPOgruPl8fMcP+7qmh28TF08wP0G5DxwnrpWgzjmo1GIqJ
         IG54QGcrP44rdAwLA0Kn0scCdLNJElj5f7N4o9y5pRXs6B1rZ3nP3J2fS1+nJ4ToE9AG
         IwWgyuZma27C7dWaxkHysRuNauN1InfuO1/xn24xXnieTO7fvFc8FgqVMKYYKiRY0/X0
         exK+m4yoY+Q+hVCaXEBuEEvPTx4zo2RDDeeVK6r5sBLo3CJDloCfcxj54qBlvD1MWGM2
         hSjQ==
X-Gm-Message-State: ANoB5pmd6HyhCJxqMTE6R4kvyOtRJLyHPB47ZvW/Dmft+pMJvBQcAoi9
        LiezZHWgNb0qj/F+SK3SsJY8pqWpLxS0M5FM93kTnw==
X-Google-Smtp-Source: AA0mqf540Ch/JyuFpiiDKWPOAX59KoM461AXv5sAa0B7Q2e4Vyjz9hcXS6IiMrETD1/aDN3GVzZMwHYxSRcJwIai+dA=
X-Received: by 2002:a05:6402:f1c:b0:46a:b1a9:c34e with SMTP id
 i28-20020a0564020f1c00b0046ab1a9c34emr33491776eda.212.1671570055865; Tue, 20
 Dec 2022 13:00:55 -0800 (PST)
MIME-Version: 1.0
References: <20221208072520.26210-1-peter.wang@mediatek.com> <yq14jtyekv2.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq14jtyekv2.fsf@ca-mkp.ca.oracle.com>
From:   Daniil Lunev <dlunev@chromium.org>
Date:   Wed, 21 Dec 2022 08:00:44 +1100
Message-ID: <CAONX=-d-LZSV9-R=oLDFKsBG8Zd90wXOcGR44kPaorDH-Y7MnQ@mail.gmail.com>
Subject: Re: [PATCH v6] ufs: core: wlun suspend SSU/enter hibern8 fail recovery
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Applied to 6.2/scsi-staging, thanks!

There is an interesting side effect of the patch in this iteration
(which I am not sure was present in the past iteration I tried):
If the device auto suspends while running purge - controller is
seemingly recent and thus the purge is aborted (with no patch at all
it hangs).
That might be ok behaviour though - it will just make it an explicit
requirement to disable runtime suspend during the management
operation.

localhost ~ # ufs-utils fl -t 6 -e -p /dev/bsg/ufs-bsg0
localhost ~ # ufs-utils attr -a -p /dev/bsg/ufs-bsg0 | grep bPurgeStatus
bPurgeStatus               := 0x00

[   25.801980] ufs_device_wlun 0:0:0:49488: START_STOP failed for
power mode: 2, result 2
[   25.802002] ufs_device_wlun 0:0:0:49488: Sense Key : Not Ready [current]
[   25.802009] ufs_device_wlun 0:0:0:49488: Add. Sense: No additional
sense information
[   25.802020] ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_suspend
failed: -16
