Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EC8C43216
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 14:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E9356054E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 14:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239007AbhG2OKD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 10:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239363AbhG2OIi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 10:08:38 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71707C028C1C
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 07:05:25 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id e25-20020a05600c4b99b0290253418ba0fbso4141123wmp.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 07:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nn0vSkKITJFWWyAKU1ShyC3VLLnkv+o8jJgTsgM51/c=;
        b=vSsu6zJDwszT/m104QxueVnZr/HBGi5PAk4+xM4Jjd5hYzjLy/ENRsIOIoEw4xlxgg
         sQV4zJrQqOimymtyypX80V4YkOtGT5DJGN50ZDgwBaZgpYSeXgUqdUNMjmvLpVI51Gn3
         G0TyYvT9HlrQN1wzlOS/A8YyZd3BCWokI3BvcEWOd5nCWZVi+x2peeIrSTdRyfljVNgk
         6iGAYDm/DevzCbKrnpR06MTg6pFxUkQTKpKUWi0wyKRCRPR3J1c1rIs1p/L9cr0gon8a
         a8z8tEFkzk4ZZTwV7c8X9GXUWtx7tUkQB9acYVCsg5LIy1FfDmqm2KqX0SHJ7xv6auPZ
         B0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nn0vSkKITJFWWyAKU1ShyC3VLLnkv+o8jJgTsgM51/c=;
        b=F8QpzLw2jpUMDb5U+TtBZ75S/8+xOdJ9zV9JFhWxL2eeGDyPKhZVbjGc9rmgeltIDv
         3MBchLnCItmFZWwz4V5kFR6ERTJUmOd7T5Ur4d/bdkilVh8i1m/MzHeUwK1Q0G9vCkAx
         1d5OOaNX5vfP3vMRbc4dDLWXyVBHGj1F3EilYe37Oobf5ll363hYDlLpJTWNjwsqWXIe
         jBk2cee/fTQ7s+Q425E7oWMuMXUCED6OwlJKGNZNWdZmM8/++QL4x4wRYptO8+/VSXWE
         W/D4xjYoGwPaOO6znUUegip5pi2dgIVmZdksnyGtcgfh713Tyuv7eNuIdvVB+X89h1bU
         hsBg==
X-Gm-Message-State: AOAM533mPTmhbhgfZwMKaosL5nFvbfxwI9hYPNz5CVvI4LHJK3z6dCHd
        k8JKFfS/xeCblxF+fvqF4dY=
X-Google-Smtp-Source: ABdhPJxlVxURGTnYy50p8i9A9KN5MYktHkof124CmKhdMRiik24/K7MKuW5cNsWVaSN0KUknROwarQ==
X-Received: by 2002:a05:600c:4f48:: with SMTP id m8mr5008840wmq.22.1627567524005;
        Thu, 29 Jul 2021 07:05:24 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id e3sm3903307wrv.65.2021.07.29.07.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 07:05:23 -0700 (PDT)
Message-ID: <36eeace45248316f4c674bff0ae1d0b598e669aa.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Fix memory corruption by
 ufshcd_read_desc_param()
From:   Bean Huo <huobean@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Date:   Thu, 29 Jul 2021 16:05:21 +0200
In-Reply-To: <162752979291.3014.727185988515749106.b4-ty@oracle.com>
References: <20210719231127.869088-1-bvanassche@acm.org>
         <162752979291.3014.727185988515749106.b4-ty@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-28 at 23:37 -0400, Martin K. Petersen wrote:
> On Mon, 19 Jul 2021 16:11:22 -0700, Bart Van Assche wrote:
> 
> 
> 
> > If param_offset > buff_len then the memcpy() statement in
> > ufshcd_read_desc_param() corrupts memory since it copies
> > 256 + buff_len - param_offset bytes into a buffer with size
> > buff_len.
> > Since param_offset < 256 this results in writing past the bound of
> > the
> > output buffer.
> 
> 
> Applied to 5.14/scsi-fixes, thanks!
> 
> 
> 
> [1/1] scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()
> 
>       https://git.kernel.org/mkp/scsi/c/b1d5de8c6ea2

Hi Martin,
This patch has a problem, we should revert it.

and the correct fix patch is in Bart's another series of patch:
https://patchwork.kernel.org/project/linux-scsi/patch/20210722033439.26550-2-bvanassche@acm.org/

Bean

