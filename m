Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CD7C2D0A3
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 13:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2977620759
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 13:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y9YSOygG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgKDNTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 08:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgKDNTg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 08:19:36 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807C2C0613D3;
        Wed,  4 Nov 2020 05:19:35 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id s25so15769161ejy.6;
        Wed, 04 Nov 2020 05:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pQuDrPDpkXICjQLGLj4jW7nuDdbbPaafP75DDUmO7O0=;
        b=Y9YSOygGU0T3SqgIKExGHuwe3Q0u1K80lfkaZiw5yOXSw8qkgYKs9BiF/KNVXC5AcB
         7EQwAP2NnGOKW0Ly2lOCy4F/kgnbzE4wBy0ZhERW04+Vnqy121cMVpppy0S5zqK8GinA
         TXpk6RnciM2ONBculkAjKskG4mFg/vAE4nCjbYkID7fej1yNVf7ZIE84sQoHyUvf3GQ0
         604YUypcLE5YA2pzvQXIWe8f/9hlVjyUs6+oM7hgtR72t188ZaFbLPHl4wnDZ8DDPiql
         pSikq0/5c+F4Ap9k8WrBXKkBlSevjCkcHpJwqSqxtkH8YXDBGuJ5nLe5+YJX4GU1r6EF
         0v4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pQuDrPDpkXICjQLGLj4jW7nuDdbbPaafP75DDUmO7O0=;
        b=ZEbk+3/PKcOiPQaxhyDoZsJnCL4FMa9Cfe+/XQln7lNu9YCMLYHz+3a1xeRvV1RZvo
         GCT8lte/MNU+bVN7EOg1gGCrhu2POt+gv8rilY56VYHkMJQMWswyqRGkMnLfGLku2zVM
         FLsxvlVLvjYd6XnDKxlKz5HWESvAIhA/dKNLc46e8BP7b2nBj/OluXtF++9RgGw6sq9W
         XtOjXC0hvN77nMLbGwyTBaDP60kB7p/nGWQbiqO/TNyRbpHPXNqk4LrkbTTdKpNbiekL
         rrAb5rr3Rgch8b0Z0NJtf9rBjalQwJ+sxBQ6fbrL4P+MMdnpb2+nCMo5zQALlZfSkB09
         9z2g==
X-Gm-Message-State: AOAM530FLZxFYjaJD6wuW1A4mvMKr7XKfL4Y1DozFTwIZGHgNk0Jcl6F
        Q5TVdRAWC3nbz3gyhh6s0r+BRUcbvD0=
X-Google-Smtp-Source: ABdhPJw8dR84xC+WnoGjROOafVVC9jTaTChC7mTVyaWIHOMW+3ZE1Fi8fYq1RfAB7nVgHviZcZRUnQ==
X-Received: by 2002:a17:906:6c93:: with SMTP id s19mr20120829ejr.544.1604495974038;
        Wed, 04 Nov 2020 05:19:34 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee22.dynamic.kabel-deutschland.de. [95.91.238.34])
        by smtp.googlemail.com with ESMTPSA id rp28sm977774ejb.77.2020.11.04.05.19.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 05:19:33 -0800 (PST)
Message-ID: <61e4b8d93512fb7be051c004f8bbf98f8c5306c3.camel@gmail.com>
Subject: Re: [PATCH V4 1/2] scsi: ufs: Add DeepSleep feature
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Wed, 04 Nov 2020 14:19:32 +0100
In-Reply-To: <b4178f30-f956-5f33-fd3e-f38b2d99dc1e@intel.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
         <20201103141403.2142-2-adrian.hunter@intel.com>
         <d00acd2cef07c50de3e19e1b8517c996d67795b2.camel@gmail.com>
         <b4178f30-f956-5f33-fd3e-f38b2d99dc1e@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-11-04 at 13:55 +0200, Adrian Hunter wrote:
> > > states:
> > >   
> > >               == 
> > > ===================================================
> > > =
> > 
> > Hi Adrian
> > There doesn't have these equal sign lines in the sysfs-driver-ufs.
> > maybe you should remove these. or add + prefix.
> 
> The "=" are from the patch below which is in v5.10-rc2
> 
> commit 54a19b4d3fe0fa0a31b46cd60951e8177cac25fa
> Author: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Date:   Fri Oct 30 08:40:50 2020 +0100
thanks for pointing out this.

Reviewed-by: Bean Huo <beanhuo@micron.com>

