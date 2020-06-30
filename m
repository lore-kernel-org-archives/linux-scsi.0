Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B8BC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 22:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E2B0206A1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 22:05:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1pPr+lF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgF3WFE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 18:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgF3WFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 18:05:03 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957A5C061755;
        Tue, 30 Jun 2020 15:05:03 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id rk21so22264243ejb.2;
        Tue, 30 Jun 2020 15:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=egQ4BGWJwteRFV/3C15qu/VRsp09Uh379he2OhRxJJ8=;
        b=V1pPr+lFhTYqoW/4omk3CaH3Hf+C4ij4nQON94pVIYsWtSgRFLcwm8nft6SEbzhzx2
         zMCtzuoT74tgtD0bODXapszHHhjYKQmEDpHmV+WhKstXK/4LxrBajJkmmXxww5QUcZAd
         PhyEtvfOiCtXFQ1YtdI9mhLJavjVT1YEJEtoaKIP89SpsbmHibnkHxQZA+3+d3lS6/7f
         gPqVwm5dTmB0ZI8eyUiKmusm3lhyfeG7aZ534CT27RvAWfsjIrmZoZ1WAHJhCmN9GYhZ
         lE20YVysD4eeC3gdry/OpzFduLt29M9ujf0cy2Dk61qCOV6SmhN6x5mZfDcsfATCGr1o
         UJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=egQ4BGWJwteRFV/3C15qu/VRsp09Uh379he2OhRxJJ8=;
        b=NBhqr9ALgZni5Dt8YLwB56/vQEZp7zJW1DGpzeK9EWzUR+SrYSM1Nx15eXwxrv5Lz8
         PV+ayQp41GcnbhOharXbCSDp9n2oHTZmlXrjqpmJ5xso7VEge5rEjw2lsDjFXhzgv76k
         n6ZnUjPjuqFnaV+vQQmIPoPHzG4eUxY7it8H/paA6cNkcAnjCDDVnNjLC8w/sraHOe4/
         9+XL8JtQk22cB/Mo1UwvpBWlNaPeB2H2Jzs8b90eC3sFkmi98y3wdoGF4RfnoQJX+qQt
         0Rn+WQhoFZaelRBJFy4z7UAGPHDaz9tkSNk7qdI1EveBfU5zu55WmxS23IsLxQ4VCyc/
         urjw==
X-Gm-Message-State: AOAM532n7Ph2QXbEPAQG2fTYHapzkbx9+7Zxf1Prvd6CZ+PZPOiLgjYN
        74llwAkyFke2EFTbVgW/bPk=
X-Google-Smtp-Source: ABdhPJxpEuRlMZt7mHPtT9izVdh8n98vXpyGSKNTHsCn7YZ7BR8/f9ldhCEaS1UqOUyzZHOUZpxnrg==
X-Received: by 2002:a17:906:7802:: with SMTP id u2mr20688743ejm.478.1593554702359;
        Tue, 30 Jun 2020 15:05:02 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfcc0.dynamic.kabel-deutschland.de. [95.91.252.192])
        by smtp.googlemail.com with ESMTPSA id z1sm3054870ejb.41.2020.06.30.15.05.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 30 Jun 2020 15:05:01 -0700 (PDT)
Message-ID: <fd205a23c433aea43f846c37cf1f521c114cdd68.camel@gmail.com>
Subject: Re: [RFC PATCH v3 0/5] scsi: ufs: Add Host Performance Booster
 Support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
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
Date:   Wed, 01 Jul 2020 00:05:00 +0200
In-Reply-To: <231786897.01593479281798.JavaMail.epsvc@epcpadp2>
References: <60647cf00d9db6818488a714b48b9b6e2a1eb728.camel@gmail.com>
         <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
         <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
         <336371513.41593411482259.JavaMail.epsvc@epcpadp2>
         <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p1>
         <231786897.01593479281798.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-06-30 at 10:05 +0900, Daejun Park wrote:
> Hi Bean,
> > On Mon, 2020-06-29 at 15:15 +0900, Daejun Park wrote:
> > > > Seems you intentionally ignored to give you comments on my
> > > > suggestion.
> > > > let me provide the reason.
> > > 
> > > Sorry! I replied to your comment (
> > > 
https://protect2.fireeye.com/url?k=be575021-e3854728-be56db6e-0cc47a31cdf8-6c7d0e1e42762b92&q=1&u=https%3A%2F%2Flkml.org%2Flkml%2F2020%2F6%2F15%2F1492
> > > ),
> > > but you didn't reply on that. I thought you agreed because you
> > > didn't
> > > send
> > > any more comments.
> > > 
> > > 
> > > > Before submitting your next version patch, please check your
> > > > L2P
> > > > mapping HPB reqeust submission logical algorithem. I have did
> > > 
> > > We are also reviewing the code that you submitted before.
> > > It seems to be a performance improvement as it sends a map
> > > request
> > > directly.
> > > 
> > > > performance comparison testing on 4KB, there are about 13%
> > > > performance
> > > > drop. Also the hit count is lower. I don't know if this is
> > > > related
> > > > to
> > > 
> > > It is interesting that there is actually a performance
> > > improvement. 
> > > Could you share the test environment, please? However, I think
> > > stability is
> > > important to HPB driver. We have tested our method with the real
> > > products and
> > > the HPB 1.0 driver is based on that.
> > 
> > I just run fio benchmark tool with --rw=randread, --bs=4kb, --
> > size=8G/10G/64G/100G. and see what performance diff with the direct
> > submission approach.
> 
> Thanks!
> 
> > > After this patch, your approach can be done as an incremental
> > > patch?
> > > I would
> > > like to test the patch that you submitted and verify it.
> > > 
> > > > your current work queue scheduling, since you didn't add the
> > > > timer
> > > > for
> > > > each HPB request.
> > 
> > Taking into consideration of the HPB 2.0, can we submit the HPB
> > write
> > request to the SCSI layer? if not, it will be a direct submission
> > way.
> > why not directly use direct way? or maybe you have a more advisable
> > approach to work around this. would you please share with us.
> > appreciate.
> 
> I am considering a direct submission way for the next version.
> We will implement the write buffer command of HPB 2.0, after patching
> HPB 1.0.
> 
> As for the direct submission of HPB releated command including HPB
> write
> buffer, I think we'd better discuss the right approach in depth
> before
> moving on to the next step.
> 

Hi Daejun
If you need reference code, you can freely copy my code from my RFC v3
patchset. or if you need my side testing support, just let me, I can
help you test your code.

Thanks,
Bean


