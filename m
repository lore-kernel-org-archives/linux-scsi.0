Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347BAC2BBCD
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAFD722D02
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 13:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgLPNbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgLPNbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 08:31:48 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92742C061794;
        Wed, 16 Dec 2020 05:31:07 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b73so24773966edf.13;
        Wed, 16 Dec 2020 05:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d+w8p1hzrw/ls07i5nfaa8a3bNY5NFoTiVu/ZKJ+PtA=;
        b=nQ95Txz7ziGayxFVNJEhc1V2iOc1O3J/EYnFTs+bUbQeHTQzPm4ziqFsKlpeju95+U
         99tMR4wq2AsiV1WTOqdsRnKNsL6GZl/y9W7ZVc4pVSiOx2RJnDkapS1g5vnci48XAaR1
         GWWnSSd1i6LFymrJSCrfLzmvjBvgbF/XZfK4H1Uon11n3ZUEx9i+/pREF7B7+APzk7VL
         C+5ECm5NYv17JK3k4VXpRgwZO91fRNRBu9VLC4vxMcQlXjeRIIgBWEEm6mQpS1ZN74nO
         akeUSXmRTEq6H9AOXXatsHwPfCp3k13GpHzl8iOCaUtBlAbH/0mMdcJTkFUyiIbmY88f
         fPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d+w8p1hzrw/ls07i5nfaa8a3bNY5NFoTiVu/ZKJ+PtA=;
        b=ksG8rl4Lyx8o2WClEHe7V6A2aOpSNsrZiML6IdJw+Pg9hCszlDqqssn6n9QshPZCZB
         khWk03G/OMfJpWWjYrjHxkSjL3IBGDXS7uIc3YVId/2lhwyyrJel0yO29nICRPwvkJCp
         6TJuHXsjmRDKqc8Y12ijvOHpjEWXH6A4B7lup25PRnu37jGJ0Q9/HXXofvgFkDJ8x9e8
         /7gtDC24eenjQPisp3kBSvoLvzl4PvUTacl2IScsytDjXhfPUqyNGUIHGgN1yoodW9gy
         2KM55DtXjUBuj1He5KAEKdujLS3mAWGops/uWqA5myPCQZ1k5a21F1MK7Nl/wuMUV/As
         9eNg==
X-Gm-Message-State: AOAM533Ma67kp3JMpeImpvsLh4FyStyVb0Suv+0sS2k2oCoK4QzQ6BVJ
        UVtXs661/AeEmuNt4rbMGdFUoX1yuBYe2A==
X-Google-Smtp-Source: ABdhPJwk2MeyR+kZNhWlaHUVyaOmxIxb9tzpi3eF28ZsPJ6qdmvsioYvqf/okh+sZhL4+et3QHAl3Q==
X-Received: by 2002:a50:ed04:: with SMTP id j4mr6873304eds.84.1608125466334;
        Wed, 16 Dec 2020 05:31:06 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id l14sm21088598edq.35.2020.12.16.05.31.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Dec 2020 05:31:05 -0800 (PST)
Message-ID: <7f91342a001ef00f3b311952515dfb17747b7148.camel@gmail.com>
Subject: Re: [PATCH v4 1/3] scsi: ufs: Protect some contexts from unexpected
 clock scaling
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 16 Dec 2020 14:31:04 +0100
In-Reply-To: <1607877104-8916-2-git-send-email-cang@codeaurora.org>
References: <1607877104-8916-1-git-send-email-cang@codeaurora.org>
         <1607877104-8916-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2020-12-13 at 08:31 -0800, Can Guo wrote:
> In contexts like suspend, shutdown and error handling, we need to
> suspend
> devfreq to make sure these contexts won't be disturbed by clock
> scaling.
> However, suspending devfreq is not enough since users can still
> trigger a
> clock scaling by manipulating the sysfs node clkscale_enable and
> devfreq
> sysfs nodes like min/max_freq and governor. Add one more flag in
> struct
> clk_scaling such that these contexts can prevent clock scaling from
> being
> invoked through above sysfs nodes.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
looks good to me.

Reviewed-by: Bean Huo <beanhuo@micron.com>

