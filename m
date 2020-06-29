Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFE9C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5A620775
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MU7Kdc7O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgF2VBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731189AbgF2TM4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:12:56 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA82C008628;
        Mon, 29 Jun 2020 03:53:39 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id dg28so12426584edb.3;
        Mon, 29 Jun 2020 03:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FsOFBl0QB6zx23xfzrS8aK4P4neU3RbWXHogsiEZatw=;
        b=MU7Kdc7Ob8B8dy9hUmI+Fx+V7qhiDei7qidjsUhk5ObQFvrAweOE1oAePMdMe12OIw
         RHJItSD3Kx+9vbz7YpvR0/MDzAAwuTXYYcvFc+M/v/PKUkAuqwfj8qgMVegagkpSMMip
         l6Sg6Ho7t8QRcKtJkCVMFfMYd7qiw37ncToFKkG9j/68/RnjDRHTPhpWXNsdf/agthRQ
         LZ6aJjc2e+l14TJ2JgQZ4SPmVBYhZtPUo3etA8wMfl/L4L9SVsU7ujAKkdi0fhDB8yTX
         b3lL9V3RHy39yB6/Ak8Dr0rae09gSb2ka7ZmExRBBlpQOiwkB61vlq6jvRP5rxhiVfMf
         pOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FsOFBl0QB6zx23xfzrS8aK4P4neU3RbWXHogsiEZatw=;
        b=cHy7h7fqk0Og7/Yp1xU4KpKcQfAT9NesMkk9eCGb9edIo++emGvKTmxA+LUm2+mcsF
         nTzTwd7kEs4sgmSiPEJX5FsOXyhTt/CIFM6gAI7jIro4KPgFiuOkU++f3ckcBZcufN2I
         Hrf7t7tVQw7uSMp3LG9ukOb1709xmsP7ai/qnC+L1o95hzhUpDcMIw2ijHSSN5VltaKz
         gGIrvIsjd0ed4pvM14MtQXnC07uBrYg7865FpuEnuA9YAwUqoK8he8TCCy3GxoUOFdsC
         CsToRvHziQqLubI/GNUKUO+MwCgmLEd1l03J0rIjB3vLoSJXgQQSUqq2ox0mynuRAN53
         eKCw==
X-Gm-Message-State: AOAM533h/d9StauF+ZVq96B0b39xb9gg74kIkaWQ0t3Xoz36N5SxRzJe
        T+nFWjigwiJwwdwMOZh8LH0=
X-Google-Smtp-Source: ABdhPJykV01EDeGyuxaYjCr9exivEEGHsAzKyojNyhR+3xCf/yQo4ub3oUQ2mdLgaywyAFHSaa47+Q==
X-Received: by 2002:aa7:c545:: with SMTP id s5mr4897369edr.19.1593428018276;
        Mon, 29 Jun 2020 03:53:38 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b88e:dd15:40fc:c0bc:1cfd:2755])
        by smtp.googlemail.com with ESMTPSA id z20sm9708065edq.97.2020.06.29.03.53.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jun 2020 03:53:37 -0700 (PDT)
Message-ID: <94775ad5c35b68d457fdca5a6c89908e227d14af.camel@gmail.com>
Subject: Re: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Mon, 29 Jun 2020 12:53:29 +0200
In-Reply-To: <SN6PR04MB464004B3DC7FB046A1E38F43FC6E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
                 <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
         <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
         <SN6PR04MB464004B3DC7FB046A1E38F43FC6E0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri

On Mon, 2020-06-29 at 05:24 +0000, Avri Altman wrote:
> Hi Bean,
> > 
> > Hi Daejun
> > 
> > Seems you intentionally ignored to give you comments on my
> > suggestion.
> > let me provide the reason.
> > 
> > Before submitting your next version patch, please check your L2P
> > mapping HPB reqeust submission logical algorithem. I have did
> > performance comparison testing on 4KB, there are about 13%
> > performance
> > drop. Also the hit count is lower. I don't know if this is related
> > to
> > your current work queue scheduling, since you didn't add the timer
> > for
> > each HPB request.
> 
> In device control mode, the various decisions,
> and specifically those that are causing repetitive evictions,
> are made by the device.
> Is this the issue that you are referring to? 
> 

For this device mode, if HPB mapping table of the active region becomes
dirty in the UFS device side, there is repetitive inactive rsp, but it
is not the reason for the condition I mentioned here.  

> As for the driver, do you see any issue that is causing unnecessary
> latency? 
> 

In Daejun's patch, it now uses work_queue, and as long there is new RSP of thesubregion to be activated, the driver will queue "work" to this work
queue, actually, this is deferred work. we don't know when it will be
scheduled/finished. we need to optimize it.


Thanks,
Bean



