Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14118C07E95
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jul 2021 18:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D738F613DA
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Jul 2021 18:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhGDStH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jul 2021 14:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhGDStH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jul 2021 14:49:07 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798A3C061574
        for <linux-scsi@vger.kernel.org>; Sun,  4 Jul 2021 11:46:31 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id k21so21498994ljh.2
        for <linux-scsi@vger.kernel.org>; Sun, 04 Jul 2021 11:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9r8KyJj/Y2oMU9xdFEQPdGHCfMa6MG+FCVul0Dt9TRA=;
        b=F2WSjothrzUCk1/iEOVVGWSUqCw34m3mxZaRj10EJiS0ZpjJhRGG3fAYkZZZoTaMi+
         qR/OvzNvRJhbFk+fVXl5rdyoC9zJtJlWG5QtilAZfzjMXZFv5cngUXU3nKmZq16bWnP3
         Pb5wHWWSz5T/2Khbys7NRyXtUb8fPCmJldxPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9r8KyJj/Y2oMU9xdFEQPdGHCfMa6MG+FCVul0Dt9TRA=;
        b=m3xm7TqtNjz//cH6/BEjGSrqrDZ5+H+SG/Z3+bh3xt6gX4Ewc81MGM7B1VXmGo7QxD
         i+jw8YU3doyUsjaVvQQguPrZJh12FJdr/4I9i8+gTY43chI3Yh6jVljWLY8qPYBX3aO0
         Fmxlo/ZlRvrZfOLErC09/LCwVvV6b9NVv5kFbzFCggP1OZ8exWCoPWkKDDme8OtifYTv
         x7SxKF/h3neN7JjdTY4Za/iNKJH3LTUPFEdkpZI4aSx8OngWq+X1QS1jM9aN/2BRTYkm
         u9AG+bxKzSMteepjkIrkanSGulzmLCcXC8WIwtb9IL4hLI0wYWSZQV4P5bgsm2u2Ht20
         4f2w==
X-Gm-Message-State: AOAM530qtqwzW8QG4djOiAPu4iWuBVhd7Po+d7o/plHCW5HoCS81jnRC
        rm1YaqfqiVyitHxvIvMw9kzhLq+SkxSb47WmNGw=
X-Google-Smtp-Source: ABdhPJyBWY6F+QtcQ3xpDdvnbLC3qSJ6zhDH6ghPu1BITeP17F7P2Xtl4XGDB1ZQ/vRvulyfavHM3w==
X-Received: by 2002:a2e:bf21:: with SMTP id c33mr8205097ljr.28.1625424389526;
        Sun, 04 Jul 2021 11:46:29 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id a24sm78749ljq.95.2021.07.04.11.46.28
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jul 2021 11:46:28 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id d25so21456264lji.7
        for <linux-scsi@vger.kernel.org>; Sun, 04 Jul 2021 11:46:28 -0700 (PDT)
X-Received: by 2002:a2e:2201:: with SMTP id i1mr8015354lji.61.1625424388681;
 Sun, 04 Jul 2021 11:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210703155833.3267-1-martin.petersen@oracle.com> <YOF1FBdMd65S6L57@infradead.org>
In-Reply-To: <YOF1FBdMd65S6L57@infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 4 Jul 2021 11:46:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wji=H2W2+yrH_ydBNRZ4fVfxBu898ivmV6DCN0rWvBOaA@mail.gmail.com>
Message-ID: <CAHk-=wji=H2W2+yrH_ydBNRZ4fVfxBu898ivmV6DCN0rWvBOaA@mail.gmail.com>
Subject: Re: [PATCH] scsi: blkcg: Fix application ID config options
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Muneendra Kumar <muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jul 4, 2021 at 1:46 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> BLK_CGROUP is a bool, so I think this can simply be:
>
>         depends on BLK_CGROUP && NVME_FC

Yeah, applied with that cleanup, and now it no longer annoys me with
any spurious questions at all, since I didn't have NVME_FC enabled.

Much better. Thanks,

             Linus
