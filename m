Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486DCC64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 16:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D441B21D7A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 16:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgLBQVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 11:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbgLBQV3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 11:21:29 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB08C0613CF;
        Wed,  2 Dec 2020 08:20:49 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id cm17so4580252edb.4;
        Wed, 02 Dec 2020 08:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dI1RHkvQaSBX5qOFtycNYJvfRIgKHUtPrAqe3IZTHWw=;
        b=WpFymUi0ht5lCIIzD6xuOVgJYxIYPpqQQsEronvp6Jz9hUpv9g6LytJQgbeEsIHgf4
         5V+jFwJYqtEIy2ovI/MPbRoau23uqQACRPOSTBDnOws0ic5v1W2hwImKI0FIEx0cGwoH
         DiKXLjGpkQcEIhDVouMhNssvqEjwjflgCo7ok31MeidWpcPDkFOkK9F/1QDUVGm9LajT
         sCuyC/hk2CfbJalr1dUDBDHn1ykkJ0hYbbcQupwP4hbQluCk/vAY7M0D1X0evHHWxWyv
         wqG3sqswtTX5ViWbbh/z8VIoVEg7I7BUo+KwaJPubZhXIHYtuUNtwPLBU7KC2hnZTNxO
         3Y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dI1RHkvQaSBX5qOFtycNYJvfRIgKHUtPrAqe3IZTHWw=;
        b=p1osqig1JL85OxItrpqY2J+8IOffYRs/9zfevh8Nuu91Y1vNX4+SFxUBXF2eK5AaGO
         ChMynoIRDyF08nIkHDH/7XJhFa9wESA44eTYmlIXp1yCNjxiPVSwlvDbb7DNtP+O5xB8
         8edBQEz6UNU1+MBY8rsYXK1q6ljRtUAUMNTRiN64JY3qrIQ5iYnyb8ndLGxQbWkb9RRy
         rzoPFOPLVV8xg483X/T2LlTrq9sSKpseoYDb7fCsez6wk/hQGJ8UrQ5MKLhfjqhH3ogJ
         quPM8ZV8coSD1cIF98mvO+vHbKcGVl/5wQPpPZOVyD0Tp6MEzJwTjBka3V7t6ejp5JaN
         VmPQ==
X-Gm-Message-State: AOAM530wKcdy1p0vD+Hm6jTzAWQkuMpo5emMqtz/ZBdqSW9NFO28MZkJ
        18kCk4KkR7o7ptHpjlMAg1g=
X-Google-Smtp-Source: ABdhPJyWE++cqGiYmP227BjM8rqHPVpC27I4ZglCjwfBwKTWhW7p1wo4qfDLoa9r7bk416QqMSsK3g==
X-Received: by 2002:a05:6402:1c04:: with SMTP id ck4mr669937edb.320.1606926048004;
        Wed, 02 Dec 2020 08:20:48 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id b15sm284729edv.85.2020.12.02.08.20.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Dec 2020 08:20:47 -0800 (PST)
Message-ID: <30767ee7973670b86bff61d1d7b2044f17640b75.camel@gmail.com>
Subject: Re: [PATCH 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 02 Dec 2020 17:20:45 +0100
In-Reply-To: <2a380908-3eb4-2cdc-4156-03e8946ffd88@codeaurora.org>
References: <20201130181143.5739-1-huobean@gmail.com>
         <20201130181143.5739-2-huobean@gmail.com>
         <2a380908-3eb4-2cdc-4156-03e8946ffd88@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-11-30 at 15:19 -0800, Asutosh Das (asd) wrote:
> > +             return -EINVAL;
> > +
> > +     pm_runtime_get_sync(hba->dev);
> > +     res = ufshcd_wb_ctrl(hba, wb_enable);
> 
> Say, a platform supports clock-scaling and this bit is toggled.
> The control goes into ufshcd_wb_ctrl for both this sysfs and 
> clock-scaling contexts. The clock-scaling context passes all checks
> and 
> blocks on waiting for this wb control to be disabled and then tries
> to 
> enable wb when it's already disabled. Perhaps that's a race there?

Hi Asutosh
Appreciate your review.
There is only inconsistent problem between clock-scaling and sysfs,
since hba->dev_cmd.lock can garantee there is only one can change
fWriteBoosterEn. But this is only happening on user willfully wants to
control WB through sysfs even they know the platform supports clock-
scaling.

Since this is for the platform which doesn't support clock-scaling, I
think based on your comments, it should be acceptable for you like
this: 


+static ssize_t wb_on_store(struct device *dev, struct device_attribute
*attr,
+                          const char *buf, size_t count)
+{
+       struct ufs_hba *hba = dev_get_drvdata(dev);
+       unsigned int wb_enable;
+       ssize_t res;
+
+       if (ufshcd_is_clkscaling_supported(hba)) {
+          dev_err(dev, "supports dynamic clk scaling, control WB
+                       through sysfs is not allowed!");
+          return -EOPNOTSUPP;
+       } 
+       if (!ufshcd_is_wb_allowed(hba))
+               return -EOPNOTSUPP;
+
+       if (kstrtouint(buf, 0, &wb_enable))
+               return -EINVAL;
+
+       if (wb_enable != 0 && wb_enable != 1)
+               return -EINVAL;
+
+       pm_runtime_get_sync(hba->dev);
+       res = ufshcd_wb_ctrl(hba, wb_enable);
+       pm_runtime_put_sync(hba->dev);
+
+       return res < 0 ? res : count;
+}

thanks,
Bean


