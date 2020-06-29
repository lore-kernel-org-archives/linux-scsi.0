Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53BB9C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B0020720
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ia0B667J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388218AbgF2VCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731160AbgF2TMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:12:49 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B7AC0076FA;
        Mon, 29 Jun 2020 04:25:07 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id i14so16179619ejr.9;
        Mon, 29 Jun 2020 04:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=twf//RldOgxncn/3LQYhKedjeWngP2CVDq9dznPpIUk=;
        b=ia0B667JCeMfjKiPdQMBP0fMuEfSykAiIMFO+nrs7Pmddd/ia1zR2kPh+1UFtZc0rG
         N6qrMQw1C7z1U6hvpQaipSEvu86uiL+36eRWfxGqQNZeJgJJ92Rv55XSP2NtBiOvVcef
         uo9yG9cSC9lvt8rQTjwqoV2Dx0tpdCRombUjjZ9IwJDIYcs8oA2Z2i5Re/djcpSbDjwj
         3DFzET9jfqVRkKOFa5V553mJt3Eagb6xNbJ1enwHaq/Qk84wZx50eIZrNXU3eMIf2Thl
         QxKpZrS4EAgUMrGNA/tvphCPLrJE+EcUpIqagaDBatXoSNPNJH/KwoVpwBbF7Vf+v3hD
         tkAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=twf//RldOgxncn/3LQYhKedjeWngP2CVDq9dznPpIUk=;
        b=U89Fg3P9o4gNQZTrPSTXrIaNWx7J5TPQZ3qcWfwngTZCy/kg5Gtf4YZkwhsrOKf2wK
         APcGIdZmcmSfBN2l1zVFWR33/P5xWTdJb5Pb0MCMeFuBtbDQ5FqfElGor5R45r0XCn8f
         BhBmvEDEIWNObATW+owurgS8H/Y4qzrb6lKYGUgIx2kUaJsPrqffUsLjIa6wdDmtdLvS
         tJlb4OXONH8aDiRb0gKI3qa6+Za8WUxzdy4p14EeLqUtRxekhGEy1NCbRsYavL6txmFC
         WN/dNVSVR1shiUvk8z+xSf5Gc9Tt75qZV4WveOTiilRMbn2Aw/nlXsL+M7W4ZxKkx/vB
         KXmA==
X-Gm-Message-State: AOAM533YVANxZrkkIIpFvZZytSV3yx0p6VM7LLkYnTjZPZQQvuOKeGQP
        ztEjGw+hBkff7IiDhAe6Dvs=
X-Google-Smtp-Source: ABdhPJxfzBjp+rimy0f7Lsn2I1LIphbpq0jKdNkGT5Lrev5SL2F7eby0iO+T+MDFBcn6vVKMgBzuLg==
X-Received: by 2002:a17:906:f2c1:: with SMTP id gz1mr14020443ejb.88.1593429906122;
        Mon, 29 Jun 2020 04:25:06 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b88e:dd15:40fc:c0bc:1cfd:2755])
        by smtp.googlemail.com with ESMTPSA id f17sm12039192ejr.71.2020.06.29.04.25.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jun 2020 04:25:05 -0700 (PDT)
Message-ID: <60647cf00d9db6818488a714b48b9b6e2a1eb728.camel@gmail.com>
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
Date:   Mon, 29 Jun 2020 13:25:03 +0200
In-Reply-To: <336371513.41593411482259.JavaMail.epsvc@epcpadp2>
References: <948f573d136b39410f7d610e5019aafc9c04fe62.camel@gmail.com>
         <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
         <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p3>
         <336371513.41593411482259.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daejun

On Mon, 2020-06-29 at 15:15 +0900, Daejun Park wrote:
> > Seems you intentionally ignored to give you comments on my
> > suggestion.
> > let me provide the reason.
> 
> Sorry! I replied to your comment (
> https://lkml.org/lkml/2020/6/15/1492),
> but you didn't reply on that. I thought you agreed because you didn't
> send
> any more comments.
> 
> 
> > Before submitting your next version patch, please check your L2P
> > mapping HPB reqeust submission logical algorithem. I have did
> 
> We are also reviewing the code that you submitted before.
> It seems to be a performance improvement as it sends a map request
> directly.
> 
> > performance comparison testing on 4KB, there are about 13%
> > performance
> > drop. Also the hit count is lower. I don't know if this is related
> > to
> 
> It is interesting that there is actually a performance improvement. 
> Could you share the test environment, please? However, I think
> stability is
> important to HPB driver. We have tested our method with the real
> products and
> the HPB 1.0 driver is based on that.

I just run fio benchmark tool with --rw=randread, --bs=4kb, --
size=8G/10G/64G/100G. and see what performance diff with the direct
submission approach.

> After this patch, your approach can be done as an incremental patch?
> I would
> like to test the patch that you submitted and verify it.
> 
> > your current work queue scheduling, since you didn't add the timer
> > for
> > each HPB request.
> 

Taking into consideration of the HPB 2.0, can we submit the HPB write
request to the SCSI layer? if not, it will be a direct submission way.
why not directly use direct way? or maybe you have a more advisable
approach to work around this. would you please share with us.
appreciate.


> There was Bart's comment that it was not good add an arbitrary
> timeout value
> to the request. (please refer to: 
> https://lkml.org/lkml/2020/6/11/1043)
> When no timer is added to the request, the SD timout will be set as
> default
> timeout at the block layer.
> 

I saw that, so I should add a timer in order to optimise HPB reqeust
scheduling/completition. this is ok so far.

> Thanks,
> Daejun

Thanks,
Bean


