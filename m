Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68392C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 20:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 311D222573
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 20:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgLVU54 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgLVU5z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 15:57:55 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B75C0613D3;
        Tue, 22 Dec 2020 12:57:15 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qw4so19981127ejb.12;
        Tue, 22 Dec 2020 12:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zUWKl7dvt8OlTSLdq8E8E3SrHTkmLLGK9+sNIq8RkLU=;
        b=G/FjNgjV8WDYYnE5GWldP59qbvJszG4VYfMK20v/u9megbPD7nOLcjQyWiPaligPzN
         DtOaaWNWN1nRYPMo9JGu2Fu+REwrF/DlQsmodGPFdfg3FglxIbMUHEj2rRQX5zSYnCiw
         KYBPUFsVO8DGeKKKmWiIwUMKp2EcOskGT0nk69/YloGvFJ349SrKi+qiUozwipdUxkZb
         IHo5DpAlcw5aNuOs+fP2NG13ZjkPY9YzrEWNAUg8i5NMA9toRI2/rsQJd+me9Butbjih
         R7Ho1B2x2w0l2mJUGDgbm4j+XqqYxNzPs3AZOBTFY0qO6uP1fZm2UEUUj3KPLsu33GFy
         fr4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zUWKl7dvt8OlTSLdq8E8E3SrHTkmLLGK9+sNIq8RkLU=;
        b=lWet8imSZk5I+Og7BUnvmk8nOpb0WcJ0pqJT06Okl9HxGC0q3LvJBv+3AIC6M20yrW
         W9dt8M97GsQ2Hqi8B8MzzMKDs201o4rQqneoP1Xk7N67OgYKpBz1KgtqwWJDu+3sUtZ+
         reYggEz0871aoIOEMKruc3tQ1ea0rsKlGhuTFWs9vEsg5I5iRHesEg4o9XX/oHZO99lk
         lHFfJXUh3l0h0ZZCQGMj3RXj7mdZOro/0pP8ukfo5uc8Fp3r7K8+LlmRd6JPRWHFPPw8
         EJGaTXFTi6H/jdlxBmI44Y+uk4pavkZHvN/lhHCrpAmhH3IFVFxstQu9JOBLAHb3Rfay
         7h4g==
X-Gm-Message-State: AOAM531AIYk/lfpAdP9SUMbfL7X7s5Q7tdPfqb/PTVAqggOGQnNZJP2a
        cUnMUxdI1ni14YD1ITpuhESITD1KteZgtw==
X-Google-Smtp-Source: ABdhPJzLLuq/35dh7eBlVk7/nQ+Hd+ys73cY/rwHx3B80440wYfIF18YAVH/nzGL0oRGnjLv/bbW3g==
X-Received: by 2002:a17:907:a8a:: with SMTP id by10mr21163548ejc.423.1608670633938;
        Tue, 22 Dec 2020 12:57:13 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id v18sm10669550ejw.18.2020.12.22.12.57.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Dec 2020 12:57:13 -0800 (PST)
Message-ID: <eb4cd8f151c43e5754bb7725bce3e8ee34a49b51.camel@gmail.com>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Dec 2020 21:57:12 +0100
In-Reply-To: <a01cdd4ff6afd2a9166741caed3c2b3d@codeaurora.org>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-2-huobean@gmail.com>
         <1608617307.14045.3.camel@mtkswgap22>
         <a01cdd4ff6afd2a9166741caed3c2b3d@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-12-22 at 14:12 +0800, Can Guo wrote:
> > > +            return -EOPNOTSUPP;
> > > +
> > > +    if (kstrtouint(buf, 0, &wb_enable))
> > > +            return -EINVAL;
> > > +
> > > +    if (wb_enable != 0 && wb_enable != 1)
> > > +            return -EINVAL;
> > > +
> > > +    pm_runtime_get_sync(hba->dev);
> > > +    res = ufshcd_wb_ctrl(hba, wb_enable);
> > 
> > May this operation race with UFS shutdown flow?
> > 
> > To be more clear, ufshcd_wb_ctrl() here may be executed after host 
> > clock
> > is disabled by shutdown flow?
> > 
> > If yes, we need to avoid it.
> 
> I have the same doubt - can user still access sysfs nodes after
> system
> starts to run shutdown routines? If yes, then we need to remove all
> UFS
> sysfs nodes in ufshcd_shutdown().
> 

No, we shouldn't do in this way, user space complains this. I think
the nodes in the sysfs can be shileded write, but the nodes shouldn't
be flash of its presence frequently.

Thanks,
Bean 


> Thanks,
> 
> Can Guo.

