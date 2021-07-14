Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9913C12002
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 21:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C91F613DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 21:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhGNVRM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 17:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhGNVRL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 17:17:11 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145FBC06175F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 14:14:19 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l8-20020a05600c1d08b02902333d79327aso1671444wms.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 14:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=UPJunKOgPHsJ/CHlq53QSEClQ7DnKLFljv2qi50he3I=;
        b=bC3ZsxSq0xFq7hN4god6PpcUsn95NPfk+D7k6BfrD+EMT+ccmJFCbHa4ha1Mk6Vzvy
         6KmahKqFgWHXiyfczQthu89+x9KWWz0I182MXq82mLdWVSdl4MffNJcrXo6o4iGpEalK
         SOTEbSixqVq3wdUtVu4v5Kjnr/auwrzm1FT+ikcBU/KTNHr1LYRnVMuEJxJkg1M6KdcY
         a1WOYZ/fIVKnkKnSV62IanXvi8Q1dfmNW2b6IGObfIgR1CIqJDWej76TmcW74BvEg1ZV
         nS0T8ki2hOBxG6Dk+Lu8zOjICRSwOlh5bwaY+bUzhXa/ttqag25wSStNNxyp5JEmmbrH
         z0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UPJunKOgPHsJ/CHlq53QSEClQ7DnKLFljv2qi50he3I=;
        b=D44Ot+7Tfb8zlLWqmg/vJUxJG9Dk1Yc8fbxVm45kd+gpj0TaPE/+gCU4qmO3a/8LKV
         asValcQ1E/zG0Ysg1m4C4Pe7BuAzYmqIA/4su+npb66LFBOtcyjB0omamDJT7qK7CHNt
         QZJ7LL1F12N0lG5mmwmshtU6240aLIWmGkj0ypDoHwTdjukPppVbgdNMWz2UqmSZepBt
         2+x9AFZpEw6eWfjttLcdLR0hbUhq9/86GqLb0f9vfRsRkfgK8+XXXfyK6H9weIln6JLx
         ZxAGJxpdKyp3kf4+//L0yqO28oS2/EeCvvPX2b0nIvR4Gvf049uXS13sFBNRQhMvcszq
         uXBw==
X-Gm-Message-State: AOAM531asH8JTJ8btQPpCbgD58weEVQBUoiENYsBdSxarRJl0rnh/Hjq
        k4dNlw8xQshE9Y4rV+3Bt44=
X-Google-Smtp-Source: ABdhPJzsVplLyRQFtrs9CBlaky4MT376lHNajH2TK9ZrdNtHGL7WVU8ccIgIl/mniN00FPmGEa+1Yg==
X-Received: by 2002:a1c:1dd4:: with SMTP id d203mr6100882wmd.28.1626297257758;
        Wed, 14 Jul 2021 14:14:17 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec65.dynamic.kabel-deutschland.de. [95.91.236.101])
        by smtp.googlemail.com with ESMTPSA id p5sm4233335wrd.25.2021.07.14.14.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 14:14:17 -0700 (PDT)
Message-ID: <0bc4dd13ad4831e9d0869200dad45818b705024e.camel@gmail.com>
Subject: Re: [PATCH v2 07/19] scsi: ufs: Verify UIC locking requirements at
 runtime
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Date:   Wed, 14 Jul 2021 23:14:16 +0200
In-Reply-To: <20210709202638.9480-9-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
         <20210709202638.9480-9-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-07-09 at 13:26 -0700, Bart Van Assche wrote:
> Instead of documenting the locking requirements of the UIC code as
> comments,
> 
> use lockdep_assert_held() such that lockdep verifies the lockdep
> 
> requirements at runtime if lockdep is enabled.
> 
> 
> 
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> 
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> 
> Cc: Can Guo <cang@codeaurora.org>
> 
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

