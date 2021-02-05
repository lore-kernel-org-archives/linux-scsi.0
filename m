Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F10C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D759B64FD8
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhBEL5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 06:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhBELoH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 06:44:07 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDEAC0613D6;
        Fri,  5 Feb 2021 03:43:26 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id g10so8514895eds.2;
        Fri, 05 Feb 2021 03:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7J7vBIegnlV9sASm56pPp++fG0Zc79ZZJaLOUVeal/M=;
        b=rdfZPg3TfknpHei5fhpixTQWc1e6ZhPckXcxJ+UqDrr+ZR9wEJZtA1zxDEYU2xjN4j
         V8rH3KR4vHJuPgi8OFh9xFsT07ygRetdqgyirT8NSpB29EZwszjly7O/dS71w9SnTdoP
         UyhKz+xMblpo1JElidTLleIILjCi/Fxf1Knrbm1tgJ0UgvU8ZOKjDuX5x8kTOa3T7tUS
         G2ac9WfKbbXbWGod2L8MutAN2+I1CQVQ09VzLPnNkjLwqv0alaTRqwKFmSlIbDBovJF+
         ImerFYpPgc5W+4fyR6qM8WV0n/ktUJ6xdbGfD+HAXrKXYpXwOhw0CvkIXFgb1hKIEBvz
         axtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7J7vBIegnlV9sASm56pPp++fG0Zc79ZZJaLOUVeal/M=;
        b=uAE8NP/ddLHoe+tQD5ZBK6vlvW9U2dwiFjUuhBzuqBvQP9vmdN+VizlHcsTJA5dwTW
         idpYrl2SvxJPNtSnXWNvTyvHxnJW2kXMf0cUzzIR7HoF1/JH1EGy0lmh/P2dEj0ibMHG
         M6VF2v6LqOV5Cs+Pg9iduHs8km/TddUouZ5iTtVx0c1CbObUM+rburtWiVACN2zmGHBo
         DGJUuqnNszS8wKYaFBcVjTLOkABGGvJU5zuGbIaW8EAegLJf+TN0IugR07SEAM7WIY1z
         xi5/OcmbA5bjxzI1KgoaF6TaeQS0StKK57ojEDJkydPmrmwzMs8IvN+9qYr3ULaxnsEv
         DvYQ==
X-Gm-Message-State: AOAM531951nah1QrNgTueb1BmLSk5Zst2KIAPvDxGvO0gekGt7RM1mqe
        y7GxN+xdk34tWomrOe9Ah8Q=
X-Google-Smtp-Source: ABdhPJxK8FT+l7xFbpTIP35J7EgkShl4Hckg9G/OCk/AeNHX+v5Vm7wdbhqGPvonahHJRdW7NPtFkw==
X-Received: by 2002:aa7:ce96:: with SMTP id y22mr3103098edv.369.1612525405339;
        Fri, 05 Feb 2021 03:43:25 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id sb6sm3532201ejb.54.2021.02.05.03.43.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Feb 2021 03:43:24 -0800 (PST)
Message-ID: <304cb44c67dc1d5fe081ea4450823c1c3b456284.camel@gmail.com>
Subject: Re: [PATCH v2 0/9] Add Host control mode to HPB
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com
Date:   Fri, 05 Feb 2021 12:43:23 +0100
In-Reply-To: <ec32248a3e56eef83744cd4844210d347add27d3.camel@gmail.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
         <ec32248a3e56eef83744cd4844210d347add27d3.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-02-05 at 12:36 +0100, Bean Huo wrote:
> > to whatever recommendation received from the device - In host
> > control
> > mode, the host uses its own algorithms to decide which regions
> > should
> > be activated or inactivated.
> > 
> > We kept the host managed heuristic simple and concise.
> > 
> > Aside from adding a by-spec functionality, host control mode
> > entails
> > some further potential benefits: makes the hpb logic transparent
> > and
> > readable, while allow tuning / scaling its various parameters, and
> > utilize system-wide info to optimize HPB potential.
> 
> Hi Avri
> In addition to the above advantage of HPB device mode, would you
> please
> share the performance comparison data with host mode? that will draw
> more attention, since you mentioned "you tested on Galaxy S20, and
> Xiaomi Mi10 pro", I think you have this kind of data.
> 
> Your HPB host driver sits in the ufs driver. Since my HPB host mode
> driver is also implemented in the UFS driver layer, I did test my HPB
> driver between device mode and host mode. Saw there is an
> improvement,
> but not significant. If you can share your HPB drviver data, that
> will
> be awesome.
> 
> Kind regards,
> Bean

So sorry, there are several typos, easily confused you. correct them as
below:

Hi Avri

In addition to the above advantage of HPB "host control mode", would
you please share the performance comparison data with "device control
mode"? that will draw more attention, since you mentioned "you tested
on Galaxy S20, and Xiaomi Mi10 pro", I think you have this kind of
data.

Your HPB "host control mode" driver sits in the ufs driver. Since my
HPB "host control mode" driver is also implemented in the UFS driver
layer, I did test my HPB driver between device mode and host mode. Saw
UFS HPB "host control mode" driver has performance gain comparing to
HPB "device control mode" driver, but not significant. If you can share
your HPB host control mode drviver data, that will be awesome.

Kind regards,
Bean

