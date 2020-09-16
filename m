Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD16C2BB84
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 09:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3345621655
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 09:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o9ixh8Av"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgIPJMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 05:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbgIPJL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2020 05:11:57 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC81CC06174A;
        Wed, 16 Sep 2020 02:11:56 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id n22so5525231edt.4;
        Wed, 16 Sep 2020 02:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vRGqC0/V84LZYTfLxwgn7Qve1rELNBgUuUlpYdZKAWE=;
        b=o9ixh8AvdyUOTsZDfIaf6ZzeUXpWRoZqG8AG/4gEVt8z+GlYcSbYIHFKMAzrwwbZM6
         B8wo9tjmpWVhmbkv0VQ0dK2J2PN2j/0DMmyAoJnTQuCwzvvo/ESJ3Dt7INs7XO/N5dPu
         N46LspG5lsnNP4akUxZDRvVqeDVR98fKpTCbLryonrsPsn/bITj3ew13T5+mC1w9MB03
         hKE22m9mTrmp7ckJtC71lBmDxusxVvoINGKDr8ys1gLoM2QYmHFO9HM5oN83QlHzh4YS
         yBAmt0ldfYau5X+r/d56INc2mYQpwEDxjwXFjQaRpDDoMBnBLLlZnPVH68QaoPRTCVa0
         90HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vRGqC0/V84LZYTfLxwgn7Qve1rELNBgUuUlpYdZKAWE=;
        b=D/we9z3uOACTXsb0j99ZBw0+8ZKCbHHq98B61+5u+xIuExlkTWpwC5/WB40TJLOU6p
         8r0f6UGmEcnO0/YR5FyDXQl1+JIcO/bUyR93xdNvfP+0LT+8q+mRCLVLQCMfJitK8mOA
         nJ2Jb/Gy4ccTQttzZ8iO6XjaLAbIWpO3U7NB2MBtU1WIuyJYJ1k1sOffyLGcDDoyKyUq
         MIMByimDZUWzeMI2xU3ehMfgUY8hw8ZjC2GUyP4E0RbvVHJEk4akDERyxfOH7hOw7sj7
         VQq8nXf2fMkCBZ93gVjW9US5p58CCRy4tFXoF603WcOBWLv4BTTd6PMHp3I7JFDBQDDd
         1evA==
X-Gm-Message-State: AOAM531X7BdqAd7GYPmJQaeBsjZ7Lbptu+EGTuHCguHPVqZsTUKIzuXL
        BWHju+mO3vNtVBG00AaWLXQJek3jTF8=
X-Google-Smtp-Source: ABdhPJzjsjyu06sWFECq8VcCrOSxTe9Ap1LxBH4gYhNaT8Q8n0KUDrH249O/Gtcph6T4cUTFiJowTA==
X-Received: by 2002:a05:6402:1717:: with SMTP id y23mr27693103edu.112.1600247515548;
        Wed, 16 Sep 2020 02:11:55 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b890:270b:75d6:3bdd:1167:483e])
        by smtp.googlemail.com with ESMTPSA id ly16sm12271951ejb.58.2020.09.16.02.11.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Sep 2020 02:11:55 -0700 (PDT)
Message-ID: <60d6963e0ff9df8ba535fcbba766a168c659546e.camel@gmail.com>
Subject: Re: [PATCH 1/2] scsi: ufs-mediatek: use
 devm_platform_ioremap_resource_byname()
From:   Bean Huo <huobean@gmail.com>
To:     Stanley Chu <chu.stanley@gapp.nthu.edu.tw>
Cc:     alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        avri.altman@wdc.com, beanhuo@micron.com, bvanassche@acm.org,
        cang@codeaurora.org, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        tomas.winkler@intel.com
Date:   Wed, 16 Sep 2020 11:11:44 +0200
In-Reply-To: <CAOBeenZX-E5ZxUtR9iDDjTxMUBKtsU529TaPz4x=u2UWWfB1pg@mail.gmail.com>
References: <20200915180708.12311-1-huobean@gmail.com>
         <20200915180708.12311-2-huobean@gmail.com>
         <CAOBeenZX-E5ZxUtR9iDDjTxMUBKtsU529TaPz4x=u2UWWfB1pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-09-16 at 08:06 +0800, Stanley Chu wrote:
> Hi Bean,
> 
> Maybe the title should be “ufs-exynos”?

Hi Stanley
Thanks, I have pushed a new version for this patch and the subject of
the patch has been changed.

Thanks,
Bean

> 
> Thanks,
> Stanley Chu

