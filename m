Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C93C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 03:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 508D323A05
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 03:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbhAPDZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 22:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbhAPDZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 22:25:04 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D502C061757;
        Fri, 15 Jan 2021 19:24:23 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id x23so12475165lji.7;
        Fri, 15 Jan 2021 19:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IJPOmtQhVPGEUpfevD8HtoDjB96wI/BiV9evfx0RRvY=;
        b=s7jcc1vJZvvHka58mZIoIhOHDscmkIgb9rkvcgzZNlYVYf8kDByRcLJBHuEtBazfB4
         UKgt3ABgDOVrCgEKZWdkSGD0VzWsFAZdRySle+YTYfICrI61tVOk996E6eQyFa7dKqNB
         u+0NyNRouf0DaMDE0CUwsH5EceQJNzEF+R/mz8GoGfmDWv4BJ4sVGJSLBG6dOle0x96C
         9p1j9Y2fCdx4flpcLTx0H774VRHR1Iad8F51OVab65Yrra/81alJm6648leSWd3xzf9Q
         6rfSNCEHabP0VEJKo7LKvUPpxejiaIXNcjozOkJqp7ty6KeEY/lZLolmM7NvVYGv+WP7
         v8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IJPOmtQhVPGEUpfevD8HtoDjB96wI/BiV9evfx0RRvY=;
        b=e4GpFiP8T1p1UNG7Hq+jbfvGZG+NCknI0J1gvR8NiKvDqXe22hEr0lH/jGQwXiW3Qq
         eYejV3Cz7nA1L92tfpz5sO2geP02iKOx9lL0MYe1Gelole6wn7qgtrI7c9xPxq0McdY5
         mAfQz4lv1srA3emPiiTLFBoAGRi2EGfFCWqCbJwCH1ZV3exbp9vU5tOmHPnSwbuyzCq5
         9SW/EkvwZXuFMrDhOwDGQI+LEZoqayPMApQOJmRvMgJqlejIDBY3SigeooOY/c/0Yjh0
         7REx3sm+VG1/gfHqf2b+Z9GfnIm+Zau9dw8u1k4N2B28hcVHJIKHboxKo1c0WCJmX7gG
         F90g==
X-Gm-Message-State: AOAM530anLsrwfKDj0O3mnfw3SpiLDiHs9T4S1JpiL1vESt6uHy2maf7
        RcI7Hi4FTEKE2gNvWP3XpqSQkLU0cP1fAE8pAzJH2E+N4ZaVsBEV
X-Google-Smtp-Source: ABdhPJwSnxr+Y87pJhpF16d2ZEOYBNFHkDGFlw52LlF66YgQda+uu57SykNHses0R63Zr+OYl2rqH/tKFpa8xI3o/wI=
X-Received: by 2002:a05:651c:316:: with SMTP id a22mr6404201ljp.473.1610767461368;
 Fri, 15 Jan 2021 19:24:21 -0800 (PST)
MIME-Version: 1.0
From:   Michael Katzmann <vk2bea@gmail.com>
Date:   Fri, 15 Jan 2021 22:24:10 -0500
Message-ID: <CAMyt5OQooVq=pbovCcVobvEZC-Af1Wu8Ry0sE=4EsagoLNNQ2w@mail.gmail.com>
Subject: Re: Changing sd device from read only to read/write fails in 5.10 (BLKROSET)
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry, that test in the end was inverted of course.. it should read

if( (DeviceFD = open( /dev/sdb, O_RDWR )) != ERROR ) {
   printf("success\n"); // <== use to work (open R/W)
} else {
   printf("failure");   // <== now fails under kernel 5.10
}
