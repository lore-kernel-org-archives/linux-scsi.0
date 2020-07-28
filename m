Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF73C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 21:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63D862074F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 21:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORkJTdfq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgG1Von (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 17:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgG1Vom (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 17:44:42 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481FFC061794
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2020 14:44:42 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l23so2214493edv.11
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2020 14:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BR6Ze/5+eBwTCt+N0kULtRuv6gAZxZYJl3Ehf7RJVLQ=;
        b=ORkJTdfqhXTxaOJTxZZwow/Y6/Q9XXHG9OadPN6dzuhshGxvK/fvSoIbDBsBV5V/q+
         aZJAH1RAJs3beb6eG50Iw360H8ny2p3WtGVnXBeuWspD2Gvq97QIWX5AcYvSTAHyuyDA
         umzQS63qt9sh9QiK/WR/hIqMJoMbPemaobYbh3y03xGw7Kv6s2VKisPCMWKJ8F8MaRez
         UjLJHonuKSdYv6vQ40I+yL05q3L7TFPTwNM4xJWA/XxxKh3cMgLPMgmdD0ZAL89VRpqL
         6PRXfep0SfeIQdh5fzyGAmRMuahmUqcyziwxU++PtYWLIYYtxT2eTwRiB4Ms1SldZ7Yq
         zinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BR6Ze/5+eBwTCt+N0kULtRuv6gAZxZYJl3Ehf7RJVLQ=;
        b=aFkoxwgiOxTO0tFo0Zr7KB1aZrGNdeSh5FdlMjdQNN/XULZgepyfEQ5Jm51f+MUTLr
         ZlUbYYwWzQ1pg8wdEWEhOflSPpxzS/QKVfteASFv/jk+z0jQqj83g7XEoLqMoxi3mT/a
         Jsa2VhpjaTlFagAlyjW0N+naLbf82KYK2m8MsTAXqTnzRXet0o3KfGjBeydO9aUlGI2x
         rqfsuxIOkJBpV5piVALDnrKGRHkNkl/zRk4hHFoXR8sdIWLo5Q3alqxrS6Em9vU5TO20
         SAes/IbbeYbQI4Meqr/WSovG+CsUOHGQaNQ2O6etRMQ8eylZfPeQlrEOqucLoKAuELTV
         tFMA==
X-Gm-Message-State: AOAM531f38ETPSHjmrdUNu07g4zqhTlPm8ShDMGX1pzoi95sq88D0Emn
        fMCwEZbJEeGmgUJpi52lAS4=
X-Google-Smtp-Source: ABdhPJxeAUGhvy8cN2q9Yq9rIdSUVu2igFFcPF3UxueUFzh4XxDOJ9t3UeBZKxuuHCM2tFPo09pWbA==
X-Received: by 2002:a05:6402:1605:: with SMTP id f5mr29523566edv.8.1595972680863;
        Tue, 28 Jul 2020 14:44:40 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfce7.dynamic.kabel-deutschland.de. [95.91.252.231])
        by smtp.googlemail.com with ESMTPSA id y7sm9768527ejd.73.2020.07.28.14.44.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jul 2020 14:44:40 -0700 (PDT)
Message-ID: <d48e32fa95a0cfb5d2f2d25e7a36ce2bdfe650fc.camel@gmail.com>
Subject: Re: [PATCH v7 0/8] Fix up and simplify error recovery mechanism
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, sh425.lee@samsung.com,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Date:   Tue, 28 Jul 2020 23:44:36 +0200
In-Reply-To: <1595912460-8860-1-git-send-email-cang@codeaurora.org>
References: <1595912460-8860-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-07-27 at 22:00 -0700, Can Guo wrote:
> The changes have been tested with error injections of multiple error
> types (and
> all kinds of mixture of them) during runtime, e.g. hibern8 enter/
> exit error,
> power mode change error and fatal/non-fatal error from IRQ context.
> During the
> test, error injections happen randomly across all contexts, e.g. clk
> scaling,
> clk gate/ungate, runtime suspend/resume and IRQ.
> 
> There are a few more fixes to resolve other minor problems based on
> the main
> change, such as LINERESET handling and racing btw error handler and
> system
> suspend/resume/shutdown, but they will be pushed after this series is
> taken,
> due to there are already too many lines in these changes.
> 
> Change since v6:
> - Modified change "scsi: ufs-qcom: Fix schedule while atomic error in
> ufs_qcom_dump_dbg_regs" to "scsi: ufs-qcom: Remove testbus dump in
> ufs_qcom_dump_dbg_regs"
> 
> Change since v5:
> - Dropped change "scsi: ufs: Fix imbalanced scsi_block_reqs_cnt
> caused by ufshcd_hold()" as it is not quite related with this series
> - Refined func ufshcd_err_handling_prepare in change "scsi: ufs:
> Recover hba runtime PM error in error handler"
> 
> Change since v4:
> - Split the original change "ufs: ufs-qcom: Fix a few BUGs in func
> ufs_qcom_dump_dbg_regs()" to 2 small changes
> 
> Change since v3:
> - Split the original change "scsi: ufs: Fix up and simplify error
> recovery mechanism" into 5 changes
> 
> Change since v2:
> - Incorporate Bart's comment to change "scsi: ufs: Add checks before
> setting clk-gating states"
> - Revised the commit msg of change "scsi: ufs: Fix up and simplify
> error recovery mechanism"
> 
> Change since v1:
> - Fixed a compilation error in case that CONFIG_PM is N
> 
> Can Guo (8):
>   scsi: ufs: Add checks before setting clk-gating states
>   ufs: ufs-qcom: Fix race conditions caused by func
>     ufs_qcom_testbus_config
>   scsi: ufs-qcom: Remove testbus dump in ufs_qcom_dump_dbg_regs
>   scsi: ufs: Add some debug infos to ufshcd_print_host_state
>   scsi: ufs: Fix concurrency of error handler and other error
> recovery
>     paths
>   scsi: ufs: Recover hba runtime PM error in error handler
>   scsi: ufs: Move dumps in IRQ handler to error handler
>   scsi: ufs: Fix a racing problem btw error handler and runtime PM
> ops
> 
>  drivers/scsi/ufs/ufs-qcom.c  |  37 ----
>  drivers/scsi/ufs/ufs-sysfs.c |   1 +
>  drivers/scsi/ufs/ufshcd.c    | 494 +++++++++++++++++++++++++++----
> ------------
>  drivers/scsi/ufs/ufshcd.h    |  15 ++
>  4 files changed, 324 insertions(+), 223 deletions(-)
> 
This series looks good to me.
Reviewed-by: Bean Huo <beanhuo@micron.com>

Thanks,
Bean


