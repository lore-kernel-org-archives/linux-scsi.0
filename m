Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93CFC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 11:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89EED2084C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 11:47:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qy8qqzgN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgE0LrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 07:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgE0LrE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 07:47:04 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493F6C061A0F;
        Wed, 27 May 2020 04:47:03 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r7so7005819wro.1;
        Wed, 27 May 2020 04:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u2lbC0Ijmdruyqd2SA/aXY87rbQYP49AyUlpYmPRW0g=;
        b=Qy8qqzgNSH8jTk5eXzO8IP5ZW2yyYjtbysyfeJrM+4tkmtFz/tJVIoEAC26pTujHd/
         VKx4b9pqXMbTS095uMH1jz5I5P9lH+cINiiSmXEs6E9DQ3dkzP1JATJwBe7bGdMXHJRq
         rAaNMiRwK2sfgpsmgLjKIP6ByocOLsr64yw51oFwPCH2kO+uD1AZjE+1pAMqJMxHMm09
         D9qodl77KXfdl1xCu7Aw86wC4RnEybjpDCIGmnNjfCWB6sEwk+/6KaKZesg+wjcqnDja
         iOrXeKr+OYDQq36TJjRBxhkHqVEyI2704c5ec7Qg1c0KwRagaPCvWHfjxLNWwX6Ux2P4
         00Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u2lbC0Ijmdruyqd2SA/aXY87rbQYP49AyUlpYmPRW0g=;
        b=dN/mXYVmW06PYxo2V3Brw0onEMH9rD5P89kebCdq4wH343mF2C2NHBjceaOQhrULbY
         sSv1iGdgX2+evxSFdgaZ6WRGhh7WTxWaJPCuiYUN+zwcsoswYmmgorqpj1PXhwBU5rVb
         izYCNJ9XTRFUEHC7YUpBcIlZaPVa3hj1PtIk/JOfhGHMunBdX9imZV0POEiB02O4W9B2
         oYpxA8yVkfk5EuR1AkRhMtVyQ7kWyv6QTPiezMyvef8ohjNnFRPfgmQN+eRpeaUUKQ4V
         JcqGk4M8Bj+PbUV/0HSnh6YDka/DG2PVOFMhcImg7CsSzhoscs305CIfk1PP83HXj8GN
         2m4A==
X-Gm-Message-State: AOAM532vtVIS2iN5dNozgxORgyZUlPb0R55/lHxr65sW8iJ6fZO0zdRz
        idu8yx6qNEdt4rk2m4ThMpGHa+IcBXw=
X-Google-Smtp-Source: ABdhPJw6XBEwqutSscWKd6KkQ3NXjkzIUkSyMz1EhZKkvVsPhYnHUInLiGfEkgT0Tqrin0HPz1R13Q==
X-Received: by 2002:a5d:4d89:: with SMTP id b9mr26288714wru.210.1590580021897;
        Wed, 27 May 2020 04:47:01 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.googlemail.com with ESMTPSA id y25sm3323024wmi.2.2020.05.27.04.46.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 May 2020 04:47:01 -0700 (PDT)
Message-ID: <f6e600794bd80d9bcbf91863f91170183723cc75.camel@gmail.com>
Subject: Re: Another approach of UFSHPB
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>
Date:   Wed, 27 May 2020 13:46:50 +0200
In-Reply-To: <231786897.01590570902533.JavaMail.epsvc@epcpadp1>
References: <fd8c4336-8528-19d9-b1fe-1f74baf6b483@acm.org>
         <aaf130c2-27bd-977b-55df-e97859f4c097@acm.org>
         <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
         <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
         <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
         <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
         <231786897.01590385382061.JavaMail.epsvc@epcpadp2>
         <6eec7c64-d4c1-c76e-5c14-7904a8792275@acm.org>
         <SN6PR04MB46400AED930A3DC5B94AED25FCB00@SN6PR04MB4640.namprd04.prod.outlook.com>
         <CGME20200516171420epcas2p108c570904c5117c3654d71e0a2842faa@epcms2p3>
         <231786897.01590570902533.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-05-27 at 18:11 +0900, Daejun Park wrote:
> > > > I do not agree that the bus model is the best choice for
> > > > freeing cache
> > > > memory if it is no longer needed. A shrinker is probably a much
> > > > better
> > > > choice because the callback functions in a shrinker get invoked
> > > > when a
> > > > system is under memory pressure. See also register_shrinker(),
> > > > unregister_shrinker() and struct shrinker in
> > > > include/linux/shrinker.h.
> > > 
> > > Since this discussion is closely related to cache allocation,
> > > What is your opinion about allocating the pages dynamically as
> > > the regions
> > > Are being activated/deactivated, in oppose of how it is done
> > > today - 
> > > Statically on init for the entire max-active-subregions?
> > Memory that is statically allocated cannot be used for any other
> > purpose
> > (e.g. page cache) without triggering the associated shrinker. As
> > far as
> > I know shrinkers are only triggered when (close to) out of memory.
> > So
> > dynamically allocating memory as needed is probably a better
> > strategy
> > than statically allocating the entire region at initialization
> > time.
> 
> To improve UFS device performance using the HPB driver, 
> the number of active-subregions above a certain threshold is
> essential.
> If the number of active-subregions is lower than the threshold, 
> the performance improvement by using HPB will be reduced.

Right, but for the embedded system, it is different to mobile usage
case, there should be a maximum limit in the HPB driver, exactly
how much MB of HPB cache, should let the user choose.


> Also, due to frequent and active/inactive protocol overhead, 
> performance may be worse than when the HPB feature is not used.
> 
> Therefore, it is better to unbind/unload HPB driver than 
> to reduce the number of active subregions below the threshold. 
> We designed the HPB driver to make the UFS device work 
> even when the module is unloaded.
>

Actually, along with the HPB running, from point of the HPB cache
consumption, no big difference between dynamical HPB page allocation
and statical allocation. on the contrary, dynamically HPB page
allocation will increase the latency in the HPB entries loading path.

//Bean

