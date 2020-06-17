Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58953C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 18:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37811217A0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 18:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLJfDoTN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgFQSYi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 14:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgFQSYf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 14:24:35 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C781C06174E;
        Wed, 17 Jun 2020 11:24:34 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dr13so3546780ejc.3;
        Wed, 17 Jun 2020 11:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j4LtBP0fxQmoKYyM4aJqiDdfJzw3PknGwyZ6hajQswg=;
        b=GLJfDoTNRo7p5CZV7Xhw2JsFxvzMFmXqTNqRfNbQwgRm5wrJmbWKiyPALGC7z96Slh
         kZBXvDkazfy+RMomrzztHMcaNtGCnhf5QiYUQQB24w3GU+xJCdx/iOgN/IQhopY2ukue
         ZhwLbFzjFWeypMxBfXqRqrFlqI+Ocb41ZIZun7GeTTZuIcIACtK1XztmKr2ixCOgNJPx
         V7NVQ2GVcc5A4zzLONKyQZJdonAIXJjFDYnmWzEqeEd4xxLeh0uuUIio0+IJ8DNvh4DG
         ybGjVGtMPO9OEWmitIqxrwowc7ZgB3AZcvR4Pb0cuU0nqDiyTDiZ4cmBaSvwDwK31dFh
         5nUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j4LtBP0fxQmoKYyM4aJqiDdfJzw3PknGwyZ6hajQswg=;
        b=lgaB6ketQs+cqe0PTdiTP/jnBdysVH0pX9EtEm0Ml9iTnZ82YPcmbJwE3Q3oUd6I+1
         y2CSNl6GWEXbKxeQL80xIc77STTZh87EssiNih9UJFWKW+S2sJ6yJq6AduklB8lHvbgF
         eP5Kswx3aRWBX/ZIidi4CiwH6przkOqN1ZUAbbsx4OzUyRQlmAQAes8qSqcr766gIJx9
         bnrtr0pLCLrrdIOLyHncXIwJWUFLAx6eWZRbi6fvPzXOoJ3mZmHMtWxxJQHCuzCkiuxG
         RTE7DiPYLsvjhFdI/RSmjr6paUPkSQ0J4/x2UZadeoEMQteFtbTmkmzpezVdsaCF36yI
         l74A==
X-Gm-Message-State: AOAM532qry4rUFb1CiCDQiCxIGOK9P2eAkBj0EF1iV6jZOWDwWZAxJ/O
        AAM7AfVse/gHqLpLov7h1VA=
X-Google-Smtp-Source: ABdhPJwu+29N47SWaovTqJG0CwrI+HDlalsmvqqUvokJw9accwzYiNKbC2FwNnooKlKfAp+SIH/rgQ==
X-Received: by 2002:a17:906:3b44:: with SMTP id h4mr401730ejf.463.1592418273392;
        Wed, 17 Jun 2020 11:24:33 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b90f:903c:e489:2676:2097:fdba])
        by smtp.googlemail.com with ESMTPSA id me8sm504598ejb.28.2020.06.17.11.24.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2020 11:24:32 -0700 (PDT)
Message-ID: <3d5748ce4481c789000979f9831a5ae681cd9d34.camel@gmail.com>
Subject: Re: [RFC PATCH v2 3/5] scsi: ufs: Introduce HPB module
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Avri Altman <Avri.Altman@wdc.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Wed, 17 Jun 2020 20:24:18 +0200
In-Reply-To: <231786897.01592395081831.JavaMail.epsvc@epcpadp2>
References: <SN6PR04MB46405EC52240E00F5D634E2AFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
         <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
         <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
         <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
         <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p5>
         <231786897.01592395081831.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-06-17 at 19:30 +0900, Daejun Park wrote:
> > > implemented
> > > as a module parameter, so that it can be configurable by the
> > > user.
> > > 
> > > To gurantee a minimum memory pool size of 4MB:
> > > $ insmod ufshpb.ko ufshpb_host_map_kbytes=4096
> > 
> > You are going through a lot of troubles to make it a loadable
> > module.
> > What are, in your opinion, the pros and cons of this design
> > decision?
> 
> In my opinion...
> 
> pros:
> 1. A user can unload an unnecessary module when there is an
> insufficient
> memory situation (HPB case).
> 2. Since each UFS vendor has a different way of implementing UFS
> features,
> it can be supported as a separate module. Otherwise, many quirks must
> be attached to module, which is not desirable way.
> 3. It is possible to distinguish parts that are not necessary for
> essential
> ufs operation.
> 4. It is advantageous to implement the latest functions according to
> the
> development speed of UFS.
> 
> cons:
> 1. It is difficult work to be implemented as a module.
> 2. Modifying "ufsfeature.c" is required to implement the feature that
> can
> not supported by the exsiting "ufsf_operation".
> 
> Thanks,
> Daejun

Dear Avri, Daejun, Bart

It is true that it is very difficult to make everyone happy.
We now have three HPB drivers in the patchwork, but I still didn't see
a final agreement. Please tell me which one do you want to focus on?

Bean

