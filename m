Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C34AC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 21:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52D6C60F4B
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 21:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhG2VOW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 17:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbhG2VOV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 17:14:21 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF460C061765
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 14:14:16 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id g15so8536086wrd.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=wgrYtHlxaNYPpK9IuCf7UXhKT/9uCjfNEytSk66CxbI=;
        b=gld+YSHrGqUI/D7gQVrwcGIwnwtErda2zt6Z2vuebY6htESOt5XhbrvlwT5WPpRaH2
         IbbX7BgyShaJcbD9/nvEoq8YvmV4RcsAFmnNQhl+aetsXqwbAqfEa1tSzmis7pkBUvCC
         msIV/gS65hTrBlbZLvb6zvV1uRpcSjJ9aRfKbyIEVvDrBqeU10F+fa0ep06/mDKiFng1
         mgPTyvtJn6MjMtaV+GkTBDCu+VlRCk9NWoy/Vv8qKiXpM3R07HM2Vd9OAcvPldwL7bGG
         h3tRn+Pk6sz7ILq26qDedza2K+RCO87pByFknifcjIqYHaH+/N7ijiIFlwGMVJjj4eRK
         AJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=wgrYtHlxaNYPpK9IuCf7UXhKT/9uCjfNEytSk66CxbI=;
        b=KUQEuokOHR4m9TmiFDiq4RcAF54MqZ9EA0imtEEAx5iI+WMFW02MnzOB791Two8rez
         jH57vr5b/hFcDo5elens7PfmQPlVS4t0lHVPndWJM/gt+vAXYAVKoVd3HLw8vJ6GH0Kx
         /+aYTsMterhNzl+NNyix8fIX3uaLxItEAhe8FBEnC4zhhHaTF6IHzA+mvynHWoN9tbMY
         OzPu7gESbISUB7o344boE9cj+C37mdFJy4ZF5m8VEBlTKZxIejLZ6Dr5NI/8eC2HspaA
         SUxgnndcpux9g+QSXoJnZ/rMuZkXnSVNiiVt8TVrqThRidPHrmKi9zUm+KrBsK3oKaWd
         +kVQ==
X-Gm-Message-State: AOAM532qSQgqpcrQch3WXPWZXfONb7/egxiVN4Uc4k+bjfEY2kClZQz4
        mojkaTduv/G2zPqYMHx8fTg=
X-Google-Smtp-Source: ABdhPJyVZYxjnKoJsTU4JL5Eit6jAOJGBkajnB/dQqltrc2fGu/W44y7czKtzTlC7Cm1MXmBaS2yfQ==
X-Received: by 2002:a5d:434e:: with SMTP id u14mr6710088wrr.378.1627593255591;
        Thu, 29 Jul 2021 14:14:15 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id s13sm10573247wmc.47.2021.07.29.14.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 14:14:15 -0700 (PDT)
Message-ID: <d5c7586f5a738e6999d8d8e8656d97aeeaa3b819.camel@gmail.com>
Subject: Re: [PATCH v3 11/18] scsi: ufs: Revert "Utilize Transfer Request
 List Completion Notification Register"
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date:   Thu, 29 Jul 2021 23:14:14 +0200
In-Reply-To: <46e6aa0e-8845-317a-026e-86423969c2b6@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-12-bvanassche@acm.org>
         <d15377870057a6ff956a18910b2d0695b145d889.camel@gmail.com>
         <cd22192c-fd45-5c7e-d70d-0d787ba02ddf@acm.org>
         <46e6aa0e-8845-317a-026e-86423969c2b6@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-07-29 at 09:13 -0700, Bart Van Assche wrote:
> > I measured the performance impact of patches 11 and 12 combined. In
> > a 4 
> > KB read IOPS test I see that these two patches combined improve 
> > performance by 1%. This illustrates that the two MMIO accesses of
> > the 
> > UTRLCNR register are slower than the single MMIO access of the
> > doorbell 
> > register.
> 
> 
> A correction: I wanted to refer to the combination of patches 11 and
> 13 
> 
> instead of 11 and 12.
> 
> 
> 
> Bart.

Bart,
thanks for your explanation. 

I tested this commit before, indeed there is performance improvement.
Based on your comments, I will verify your statement.

Bean

