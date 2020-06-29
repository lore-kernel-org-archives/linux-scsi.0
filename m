Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B34C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9AF820663
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KuLONa1c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389364AbgF2UtR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731490AbgF2TNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:13:41 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7AFC006975;
        Mon, 29 Jun 2020 04:39:48 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id z17so12532243edr.9;
        Mon, 29 Jun 2020 04:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WTfHJ+utCfQx7YKFHmm/ny5jRigzHEJ9WNfHacuDI3w=;
        b=KuLONa1cg6xDZijoZAyKxcyxwV+Po09umfjENbkXy2SQ1ewe6l3vR65CViCuqAVg+f
         Am7bl4E2iF3CCZvx1CIttp2rMlDSmvSk+RY7EdB/B19nwOBe6+mlctraRZFqOmJIfVi4
         UFzUnbVSgsdWZracchkgfWTVXaFQw3t3/V6kOT5q3uq8shEWN9q1UDn/O6/vWOb7TG1Y
         TgEa6MmvuDR8ODrzEm4zulGE770MCHN6/biEOF+Vp44E2o7fRnJzSYRjG/I2aJn1CqjF
         QftT1p4ra4ncA53JqbwkheY0KEDQoeBpjiOY5opm9kR4EATiBtvpCaOr1Lc28LRO9BDj
         8MJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WTfHJ+utCfQx7YKFHmm/ny5jRigzHEJ9WNfHacuDI3w=;
        b=cficyTtPBLWT4lqOUIAtsUychOycaNrOovhp0y/X82PH8NCR/qXsdGoObTZ704/uu1
         GllgX2EfLtpW8rhfP6uxvZ6sYcQCOjoDqUUUQG4g+KI2FDMGktz10vUmwV3jWiuaPsqY
         OmfXv+F6CiSs+pudbkJBtacEq5SsIqmr02AYEYQ1a+JHqeuJiBvEJeuLmYH9AkrmsbtC
         ulaQxT18tbWGD5aWS57P09XERDpGpFSqHOSno5DAlEz/oDaADOmC8wmcZ545yUglAJKF
         3PzybN1qi58uvycUfqV1D/NMGQTXzGN56TcgxMmraLNjRtqT+1JAZcmiW+XAYl4KtguG
         LZRA==
X-Gm-Message-State: AOAM5303keVJjvYwFfM7PRtteBMhv24MPpwjV+G53a5GePfwTBI0gDhR
        zTLqduZ02tktHoVL8PTx3fc=
X-Google-Smtp-Source: ABdhPJybHrHYkEkw00NMQsOah2B9BMMVMgmwZOJeI47p5PFFY4rTp6n10j1aNmdl2oyLDSTMwZE+mg==
X-Received: by 2002:a50:d0cc:: with SMTP id g12mr17402310edf.57.1593430786919;
        Mon, 29 Jun 2020 04:39:46 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b88e:dd15:40fc:c0bc:1cfd:2755])
        by smtp.googlemail.com with ESMTPSA id v23sm27507658edr.94.2020.06.29.04.39.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jun 2020 04:39:46 -0700 (PDT)
Message-ID: <c9b71fcb1f072dcf55f3e13da6dd8ccc145d7c74.camel@gmail.com>
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
Date:   Mon, 29 Jun 2020 13:39:42 +0200
In-Reply-To: <SN6PR04MB46402436A9E1FFE70967C444FC6E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
         <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
         <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
         <SN6PR04MB464004B3DC7FB046A1E38F43FC6E0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <94775ad5c35b68d457fdca5a6c89908e227d14af.camel@gmail.com>
         <SN6PR04MB46402436A9E1FFE70967C444FC6E0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-06-29 at 11:06 +0000, Avri Altman wrote:
> > 
> > Hi Avri
> > 
> > On Mon, 2020-06-29 at 05:24 +0000, Avri Altman wrote:
> > > Hi Bean,
> > > > 
> > > > Hi Daejun
> > > > 
> > > > Seems you intentionally ignored to give you comments on my
> > > > suggestion.
> > > > let me provide the reason.
> > > > 
> > > > Before submitting your next version patch, please check your
> > > > L2P
> > > > mapping HPB reqeust submission logical algorithem. I have did
> > > > performance comparison testing on 4KB, there are about 13%
> > > > performance
> > > > drop. Also the hit count is lower. I don't know if this is
> > > > related
> > > > to
> > > > your current work queue scheduling, since you didn't add the
> > > > timer
> > > > for
> > > > each HPB request.
> > > 
> > > In device control mode, the various decisions,
> > > and specifically those that are causing repetitive evictions,
> > > are made by the device.
> > > Is this the issue that you are referring to?
> > > 
> > 
> > For this device mode, if HPB mapping table of the active region
> > becomes
> > dirty in the UFS device side, there is repetitive inactive rsp, but
> > it
> > is not the reason for the condition I mentioned here.
> > 
> > > As for the driver, do you see any issue that is causing
> > > unnecessary
> > > latency?
> > > 
> > 
> > In Daejun's patch, it now uses work_queue, and as long there is new
> > RSP of
> > thesubregion to be activated, the driver will queue "work" to this
> > work
> > queue, actually, this is deferred work. we don't know when it will
> > be
> > scheduled/finished. we need to optimize it.
> 
> But those "to-do" lists are checked on every completion interrupt and
> on every resume.
> Do you see any scenario in which the "to-be-activated" or "to-be-
> inactivate" work is getting starved?
> 

let me run more testing cases, will back to you if there is new
updates.

Thanks,
Bean


