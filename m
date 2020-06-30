Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91B7C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 22:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A027206B6
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 22:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uM7mB6nS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgF3WAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 18:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgF3WAG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 18:00:06 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC87C061755;
        Tue, 30 Jun 2020 15:00:05 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id i14so22246340ejr.9;
        Tue, 30 Jun 2020 15:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YFQlDTghlkbpqPTlqYX4IEPkU3DdZpQuqq3tMuWnogA=;
        b=uM7mB6nSzZ9YKykxHJrlBz8Z48Udfh8xpMtjW6EtSz6JnH/LaAQ0/9HsBTTUEMNU0d
         eu7LL0JmSrnIS3HoIDQtiSCrtcF0ff0DqKarMfomM7JVF316RCKaGnvaQRQBWn9Mxgd2
         RfxoY22uujR2ef6RXQqZK952Nv9LpVxT+UQ0Or8tYHaKqOLLabyoYpXieNA0HSL2QiwI
         q9bib5a8rcz8YVIVN0l+zmop/AO9dZUfF+JAaTXGId2dq7HJtQ7doJf8um/O2XgQR9/o
         sZPpC6UHcc2+IsGMU/IGlEyDDIT/lnKeystZ0bM2NFLFRIQbZUID6mS+JcG0QlJqPUPP
         ENVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YFQlDTghlkbpqPTlqYX4IEPkU3DdZpQuqq3tMuWnogA=;
        b=jd0IPQYdymLyEwmmbcm9RpPi+6n/6p5ndcYucjpdjgfAzT1Axp5RI2haSf+ZsW3HZt
         srLAPbHFJlRo/wULXvJ3lW/0aCjffJro9PSyRj/pRGSPGhKoVeyuEJYefRg1yGJKuRAX
         ckWay5rBAHHCkRiBgVrAaNbQ8A9MdVqePueHDkn9nvu+Hk5hblJ1h17KycdE60fvuoMk
         OxCdnXNtyLtLqGytJMSa1mv5nsqQlJti4UQLSrzEEzQqPlHjNOQWOBlvd/To9Hv+7FuC
         dzVaY8lz8GLX+hupoeSmE0Jrr9ybhmWNfomw4PBIbTQQJQElhOFqKth2YxyIwHU3mc8A
         jkgQ==
X-Gm-Message-State: AOAM533xJseVXeAUHlAx7+40Uow6ZPuaO8z1ukS+VrsKZsUmPBc5176U
        RlRvZKgQDVynf0Zw3qVrgaE=
X-Google-Smtp-Source: ABdhPJwb21fJPOORLVvALB66TC9K+b0XWQvEKPRO8p5hquCLfTsC2G7WYqHBhsIQtyBKN9dh4OUmkw==
X-Received: by 2002:a17:906:694d:: with SMTP id c13mr19281327ejs.337.1593554400137;
        Tue, 30 Jun 2020 15:00:00 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfcc0.dynamic.kabel-deutschland.de. [95.91.252.192])
        by smtp.googlemail.com with ESMTPSA id d5sm4316826eds.40.2020.06.30.14.59.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jun 2020 14:59:59 -0700 (PDT)
Message-ID: <e6747623cd82152a7175d5fb1e1fd1a1cbd1d5f6.camel@gmail.com>
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
Date:   Tue, 30 Jun 2020 23:59:58 +0200
In-Reply-To: <SN6PR04MB46409E7CE538F158387615A6FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <60647cf00d9db6818488a714b48b9b6e2a1eb728.camel@gmail.com>
         <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
         <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
         <336371513.41593411482259.JavaMail.epsvc@epcpadp2>
         <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
         <231786897.01593479281798.JavaMail.epsvc@epcpadp2>
         <SN6PR04MB46409E7CE538F158387615A6FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-06-30 at 06:39 +0000, Avri Altman wrote:
> Hi,
>  
> > 
> > Hi Bean,
> > > On Mon, 2020-06-29 at 15:15 +0900, Daejun Park wrote:
> > > > > Seems you intentionally ignored to give you comments on my
> > > > > suggestion.
> > > > > let me provide the reason.
> > > > 
> > > > Sorry! I replied to your comment (
> > > > https://protect2.fireeye.com/url?k=be575021-e3854728-be56db6e-
> > 
> > 0cc47a31cdf8-
> > 6c7d0e1e42762b92&q=1&u=https%3A%2F%2Flkml.org%2Flkml%2F2020%2F6%
> > 2F15%2F1492),
> > > > but you didn't reply on that. I thought you agreed because you
> > > > didn't
> > > > send
> > > > any more comments.
> > > > 
> > > > 
> > > > > Before submitting your next version patch, please check your
> > > > > L2P
> > > > > mapping HPB reqeust submission logical algorithem. I have did
> > > > 
> > > > We are also reviewing the code that you submitted before.
> > > > It seems to be a performance improvement as it sends a map
> > > > request
> > > > directly.
> > > > 
> > > > > performance comparison testing on 4KB, there are about 13%
> > > > > performance
> > > > > drop. Also the hit count is lower. I don't know if this is
> > > > > related
> > > > > to
> > > > 
> > > > It is interesting that there is actually a performance
> > > > improvement.
> > > > Could you share the test environment, please? However, I think
> > > > stability is
> > > > important to HPB driver. We have tested our method with the
> > > > real
> > > > products and
> > > > the HPB 1.0 driver is based on that.
> > > 
> > > I just run fio benchmark tool with --rw=randread, --bs=4kb, --
> > > size=8G/10G/64G/100G. and see what performance diff with the
> > > direct
> > > submission approach.
> > 
> > Thanks!
> > 
> > > > After this patch, your approach can be done as an incremental
> > > > patch?
> > > > I would
> > > > like to test the patch that you submitted and verify it.
> > > > 
> > > > > your current work queue scheduling, since you didn't add the
> > > > > timer
> > > > > for
> > > > > each HPB request.
> > > 
> > > Taking into consideration of the HPB 2.0, can we submit the HPB
> > > write
> > > request to the SCSI layer? if not, it will be a direct submission
> > > way.
> > > why not directly use direct way? or maybe you have a more
> > > advisable
> > > approach to work around this. would you please share with us.
> > > appreciate.
> > 
> > I am considering a direct submission way for the next version.
> > We will implement the write buffer command of HPB 2.0, after
> > patching HPB
> > 1.0.
> > 
> > As for the direct submission of HPB releated command including HPB
> > write
> > buffer, I think we'd better discuss the right approach in depth
> > before
> > moving on to the next step.
> 
> I vote to stay with the current implementation because:
> 1) Bean is probably right about 2.0, but it's out of scope for now - 
>     there is a long way to go before we'll need to worry about it
> 2) For now, we should focus on the functional flows. 
>     Performance issues, should such issues indeed exists, can be
> dealt with  later.  And,
> 3) The current code base is running in production for more than 3
> years now.
>      I am not so eager to dump a robust, well debugged code unless it
> absolutely necessary.
> 
> Thanks,
> Avri
> 
> 
Hi Avri
Thanks, appreciate you shared your position on this topic. I don't know
how I can convince you to change your opinion.
Let me try.

1. HPB 2.0 is not out of scope.
HPB 1.0 only supports 4KB read length, which is useless. I don't know
if there will be users who want to use HPB driver only supports 4KB
chunk size. I think, we all know that some smartphone vendors have
already use HPB 2.0, even HPB 2.0 has not been released yet. you
mentioned this in your before emails. HPB 1.0 is just a
transition(limited) version, we need to think about the HPB 2.0 support
when we develop the HPB 1.0 driver.
To say the least, if we don't think about HPB 2.0 support, and just
focus HPB 1.0, in the end, after HPB 2.0 releasing, we need to return
original point, re-do lots thing, why we cannot fix it now and think
one step further.

2. The major goal of the HPB feature is to improve random read
performance, and HPB device mode implementing flow is now already very
clear enough. I don't know what the functional flows you mentioned.
if it is HPB host mode, no, this is another big topic, I think we'd
better not add in current driver until we all have a final approach.

3. Regarding the Daejun's HPB driver used age, I can't easily jump to a
conclusion. But for sure, before he disclosed his HPB driver and
submitted to the community, he did lots of changes and deletions. That
means it still needs lots of tests.


I didn't mean to disrupt Daejun's patch upstreaming. If Daejun can
consider HPB 2.0 support while developing HPB 1.0 patch, that is super.
Thus we can quickly add HPB 2.0 support once HPB 2.0 Spec released.
Think about that who is now using HPB 1.0?

Thanks,
Bean




 





