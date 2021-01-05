Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218DEC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 18:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99C722D5B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 18:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbhAESjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 13:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAESjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 13:39:10 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362DAC061574;
        Tue,  5 Jan 2021 10:38:30 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id qw4so1586096ejb.12;
        Tue, 05 Jan 2021 10:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Znleg9VGt6QZ0JjH5cskVlw+eEGA5ZO1yajbXFcTWkE=;
        b=uWbTkknUiYAiVb5NG4EQYjWmJzQtldTmwU9jzVoRU8tDK/LZvpZuT+bng8ZIIE/CZx
         /lTxy9nhAbVX+4OYb8djLWZY394MHbn6L98lG+5mVeYRXxd8YZ5rKmnAyexhY9ZP4pmz
         BwPFT8WNzH2JMQ8Mu6AvuEIk2A+X7XoXEeQ6VBc26Gugz/AFWruae/UwIYB/eOZBazhx
         vS0/0LoMim43kCYRxf0usSOJtGR29MCZsCBL0YwITbETk+dkSL/c2iOFl43yL9cbzzEU
         Gma3NwJBHliy0/kPPfcHwlWnZE/+kflHK/TvYep/Jesup8/Mv46j6HWKZIM1v130dLON
         TdGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Znleg9VGt6QZ0JjH5cskVlw+eEGA5ZO1yajbXFcTWkE=;
        b=CVPIvzK02F0vc1cBDDqqvr5YQaChRTUsB3kaYk2gkU9r9SQyMtyM1TMa7aLuIHkGGf
         s5cgST9wiWofP8mFUuplkGKz6yzlSDD9hkxv8TB49ZQzLuAoJoLYWbFMGZBPYL+yLiD0
         wZu1/SJD5au5G2B7qxCbe3BlMTjnx+uOCTSnGlXsC9R4P091+McPQT7vD5laLgILuTTC
         UX5//5aeYmj/QFP10rs8+Ukq4PUOd1d2Kjl30VuA5Dhx2MNVQl9QUki4wPyrLh9Kwr8I
         ooMo7OHt0+yWyne9LQpciqyTZHvpDoD4zaoqVWSQuM+LtkQtln48jAb59DpczIHIyB0X
         vKNg==
X-Gm-Message-State: AOAM531ttfy7TgVZ+ClNaUWLe4gtBWL3TGoDdTglAbgbJGAPrMBUCFnj
        hxBnfkTanh1QRWGIyOaooR+WJdDyWEe3wQ==
X-Google-Smtp-Source: ABdhPJxCbTLWbVDU0aYZhxVsX8Z+9WTb0jl2h37deIcI5Bks/IQ4I/R7a4S50TXCgi66UKUkaIpzrQ==
X-Received: by 2002:a17:906:660b:: with SMTP id b11mr441776ejp.458.1609871908938;
        Tue, 05 Jan 2021 10:38:28 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id m7sm18316ejr.119.2021.01.05.10.38.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 10:38:28 -0800 (PST)
Message-ID: <1514403adf486ac8069253c09f45b021bad32e00.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        rjw@rjwysocki.net, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 05 Jan 2021 19:38:26 +0100
In-Reply-To: <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
         <1609595975-12219-3-git-send-email-cang@codeaurora.org>
         <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
         <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-05 at 09:07 +0800, Can Guo wrote:
> On 2021-01-05 04:05, Bean Huo wrote:
> > On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
> > > + * @shutting_down: flag to check if shutdown has been invoked
> > 
> > I am not much sure if this flag is need, since once PM going in
> > shutdown path, what will be returnded by pm_runtime_get_sync()?
> > 
> > If pm_runtime_get_sync() will fail, just check its return.
> > 
> 
> That depends. During/after shutdown, for UFS's case only,
> pm_runtime_get_sync(hba->dev) will most likely return 0,
> because it is already RUNTIME_ACTIVE, pm_runtime_get_sync()
> will directly return 0... meaning you cannot count on it.
> 
> Check Stanley's change -
> https://lore.kernel.org/patchwork/patch/1341389/
> 
> Can Guo.

Can,

Thanks for pointing out that.

Based on my understanding, that patch is redundent. maybe I
misundestood Linux shutdown sequence.

I checked the shutdown flow:
 
1. Set the "system_state" variable
2. Disable usermod to ensure that no user from userspace can start a
request
3. device_shutdown()
So, userspace thread can not start a request to trigger runtime
resume(pm_runtime_get_sync) after step 2.

also,  no need to add that flag to checkup if shutdwon is running,
maybe it is better to check variable system_state:

if (system_state == SYSTEM_POWER_OFF || system_state == SYSTEM_HALT
|| system_state == SYSTEM_RESTART) 
	//shutdown start


I still hope Rafael or someone else can confirm that if
pm_runtime_get_sync() will really return ok in shutdown flow.


thanks,
Bean

> 
> > Hi Rafael
> > would you please help us confirm this?
> > 
> > thanks,
> > Bean

