Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0442C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 10:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9133C23AA9
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 10:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgLHKzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 05:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgLHKzb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 05:55:31 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A929BC061749;
        Tue,  8 Dec 2020 02:54:50 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id g20so24008258ejb.1;
        Tue, 08 Dec 2020 02:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sbxOpygJbgIXUI5JDKWBMnCfwcl2KWEvLK9nI1pOWbQ=;
        b=Liel3rbuNDPCinOZPnk6p1vBnf4lxgwARFwSXntxEDDy4F3Xr13urkUflhvMgC5h+F
         S8tHs5W9Z9fLLrGUFeYLysTpDWRD8GMuU9whHagZOeuMV11aKslx2NL17ypxebjEFaqj
         sGhsNWZOp1bDZwm3purPzUyxKhQgUYCOqhl2KtsMi5evP68oMKcLAblG/VBmfK5BoRGv
         wEEC/QBpgglmvIRXNt/zGKTSW65oZXYEUlEJIaGvSYzni3RRk2mfkfMe3v5/P9GqxXrc
         S+UxcwpcNBB36bmswXieAZZEEVv1LaP32kEz9Krk79P1aKMRkQL0lOnM+iZD7/koQ+Z0
         V8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sbxOpygJbgIXUI5JDKWBMnCfwcl2KWEvLK9nI1pOWbQ=;
        b=NTNtD42DuHY3Zrjiq7hBHEZW3/P3+PmEh2H8lR/rwmqvAbf3cQnCtwO927yd0IVNSu
         vf8g8BZfefYzT2oyfNR4FyXE6tPL5U1ry4WGftt/cm50gFoR0cjcsBiav9WDvzsK7+jV
         AU2StIJMHNL71FSHWQa76ngJLFVpzD7i6OiJ3ePFqpL+7duXADCWJXIYb+lWImroOa1F
         CNtiIJV+NYxj1sDDY8oHBiIkdXxUgnb6IV2pTz407cMHiNyFPUuxgl7+grYSGymuaf8p
         7wsz9GpZt2OeA1vs7+hyD7ihHVRmha753hr09rfEaawz4hlfrI8TYn/JEph2iJkuVl5K
         gfXg==
X-Gm-Message-State: AOAM5328AXGKCtlaJT5xAR/NfU7uajJI4K2KWZmRS3ePSkqQtVMK9+F5
        Ho/h4NZ+ZHll4lXQnWyzWMM=
X-Google-Smtp-Source: ABdhPJxmkOQEJEw28QJ0tusRC9mWhlZN1AGaMVCe7hcDwfrN7fU6dL9wKGAo1wAUfWz0ZqMCPcnu0Q==
X-Received: by 2002:a17:906:168f:: with SMTP id s15mr22194845ejd.180.1607424889468;
        Tue, 08 Dec 2020 02:54:49 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id dd12sm16522112edb.6.2020.12.08.02.54.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Dec 2020 02:54:48 -0800 (PST)
Message-ID: <f125f121840044c6d9c21a7e334eff0fac69e51d.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 08 Dec 2020 11:54:48 +0100
In-Reply-To: <1d99b564f593f91cc13ca682655def29@codeaurora.org>
References: <20201206101335.3418-1-huobean@gmail.com>
         <20201206101335.3418-2-huobean@gmail.com>
         <1d99b564f593f91cc13ca682655def29@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-08 at 15:13 +0800, Can Guo wrote:
> > +     if (ufshcd_is_clkscaling_supported(hba)) {
> > +             /* If the platform supports
> > UFSHCD_CAP_AUTO_BKOPS_SUSPEND, turn
> > +              * WB on/off will be done while clock scaling
> > up/down.
> > +              */
> 
> Double check comment line format?

Can,
I will change it to the preferred comment style.

thanks,
Bean

