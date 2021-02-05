Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751EEC43381
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 22:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C85964FDC
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 22:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbhBEWZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 17:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbhBEOWu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 09:22:50 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDFBC06121D;
        Fri,  5 Feb 2021 07:59:55 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id r23so6438334ljh.1;
        Fri, 05 Feb 2021 07:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zd+c4ooltVhxeT02OwlGyOjUnE2GSWiTDPcIAPn3MYU=;
        b=f+TJ3QX7m2SC6ZcxPUEQuDp7gpWX8I1nwRTbb7DIxswh6QjKWXMw9kp3enzvUMNxCg
         CJSSs72MqVDOe0yVAYjIfwbVYTp5eQF5tpthO+qQSoVcKwXGSq4p4iJQ8DhDLi6w6Mdj
         aGPQadAu1eo6e77bOFH923cMdfIrqkcCW3teZIgiugtr99d3ODgKDh323ZPmj03jiNoc
         1LcCPVjjRFy66QJn6exOGkqhcHvIehLsF3dWTdz0xQnQBnucIstsSq3Y5LKhzGI7Gno3
         xuouxbKrsDiKECNo5olldx9hr6MXoPPMlIeJhQZoGjEy3je98EYxL9Zuo+GJCj51jgYU
         7AIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zd+c4ooltVhxeT02OwlGyOjUnE2GSWiTDPcIAPn3MYU=;
        b=XPNy7tWxM0nF5cBgtQeF63MkvL0hsfHlTsATtfN2/Yt2co0lXe3izzO8Y4q/b1iDzk
         MzX1mVOloaMw4kyGFFHW9qnob95d+ASRyXqqdR8zH7wXuNztF4aLSk7z+DSh2GnLNNgO
         sfHwN0yr2Vqq0aJCnwGTXViGc4xMGS/SW+sS7Q6BG2B1ddH1gB8+UV7wdfjdpXryh3jO
         8l705mlxTvlZHHxMNxtIdu5NQvNOFWkA978L2Ov5AveP4+VkjcsSLyJIsdIxtRP1xf8o
         L6jZnndM7JCgKiIKtUV6i20kDBSJWFFIEQ+ofU4QFxTHGq5X6w9dmf/0UZRIxVIL+iu/
         mRkQ==
X-Gm-Message-State: AOAM532OfqzHJkqnYrv46FETiDdLqvslwODizNdmP/xhpVt9c/NFpa/F
        frsgO5/qKj2gtrVyzSg7EWTbz0RDmVg=
X-Google-Smtp-Source: ABdhPJwrL5Zjc4u4TQJo0V9hVIq8fGvpnCC64MSTWzWFflLgGHJx9AMxShyGN3O/7tuZCuDtjX+xvg==
X-Received: by 2002:a50:bacb:: with SMTP id x69mr3908359ede.39.1612537715856;
        Fri, 05 Feb 2021 07:08:35 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id g3sm4219086edk.75.2021.02.05.07.08.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Feb 2021 07:08:34 -0800 (PST)
Message-ID: <12a011cd895dc9be5ec6c4f964b6011af492f06d.camel@gmail.com>
Subject: Re: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached
 sub-region
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Fri, 05 Feb 2021 16:08:31 +0100
In-Reply-To: <DM6PR04MB657522B94AB436CF096460F6FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
         <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
         <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
         <b6a8652c00411e3f71d33e7a6322f49eb5701039.camel@gmail.com>
         <DM6PR04MB657522B94AB436CF096460F6FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-02-05 at 14:06 +0000, Avri Altman wrote:
> > > > +     put_unaligned_be64(ppn, &cdb[6]);
> > > 
> > > You are assuming the HPB entries read out by "HPB Read Buffer"
> > > cmd
> > > are
> > > in Little
> > > Endian, which is why you are using put_unaligned_be64 here.
> > > However,
> > > this assumption
> > > is not right for all the other flash vendors - HPB entries read
> > > out
> > > by
> > > "HPB Read Buffer"
> > > cmd may come in Big Endian, if so, their random read performance
> > > are
> > > screwed.
> > 
> > For this question, it is very hard to make a correct format since
> > the
> > Spec doesn't give a clear definition. Should we have a default
> > format,
> > if there is conflict, and then add quirk or add a vendor-specific
> > table?
> > 
> > Hi Avri
> > Do you have a good idea?
> 
> I don't know.  Better let Daejun answer this.
> This was working for me for both Galaxy S20 (Exynos) as well as
> Xiaomi Mi10 (8250).
> 

Thanks, I tested Daejun's patchset before, it is also ok (I don't know
which version patchset). maybe we can keep current implementation as
default, then if there is conflict, and submit the quirk.

Thanks,
Bean

> Thanks,
> Avri

