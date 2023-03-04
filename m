Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3247BC64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 09:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjCDJQd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Mar 2023 04:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCDJQb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2023 04:16:31 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2360F1423F
        for <linux-scsi@vger.kernel.org>; Sat,  4 Mar 2023 01:16:29 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id p26so2889032wmc.4
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2023 01:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677921387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u7rxpvEXxMl98nbZc+87/nzrWnz91WbmS8yFASWPUHs=;
        b=TN8ZJywX3LymTOxeVmLugSsFYOPpiIELhM3L/ArlWRrBI10bV+TFLVR8C0U79d4CgJ
         oi+MkZEAK/JOa8gmSkRS5798vHuMQK05ls7wvE6ZkBnMUwdZdjaN7Ln7Jv5THwYI8qz7
         FDXCPqvnNfTEwaPP7m+bEw9BxZFXEob5Ans9nfjv7QHhfKmu1DJErUKqWD+gjl72QLoK
         W1Jt3L8I9AUmcAVLFS5zNjzbiQbjw76eUdFmH4u2kBOG7cvOcHxjOE8FtA+zdBwjNoz1
         DS0AroXUucGqK3h621Ce1wJWAfB8kHny8MGc8lPvtVIQhXxILNfhong43cB+4cDZCOqS
         MNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677921387;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u7rxpvEXxMl98nbZc+87/nzrWnz91WbmS8yFASWPUHs=;
        b=difqB6stT1/pMEQTsNMKEj4ma0D55Op2N1CmupFFavARjssOjVkDH0dkmTgkG5Yvv1
         7plq924BxjoLnM+wCrOTifErcSwDC7tifsjWwNwWNX4VNGs+3eGMzH5JJXjWkLnt5Uka
         IgPKOj9mnt+09y4+GBbiJuDfboF0PDNa4C1bVA0Ec2mW/alIiFtSDxB5bSWoVVHOKkEX
         OaBFvofJrNgN2Y/sB1ntm9n6mXK074UIUljk/c8yvxrQso9NSFTqQolsXSD8gO+yqnSO
         kutz2nXlM1k6L9MU7DPiPtbTNEdHdMGYeMvZhanWctEmAw7IZJit7jgzhOd1BSnPiYEs
         sU+Q==
X-Gm-Message-State: AO0yUKXlCoZgzpAD8rGcuq+zqhLtQ0pFbKSP8Aa4O3TOLJRTZ28YXsyZ
        gJ+Bn91CTKbuos5wbGDZ6mUTIE1IAETQxA==
X-Google-Smtp-Source: AK7set8fI3WvLbOHT2f8qsxFThGOZJTIpCKa9SKWW+mxh86Iub6eGN/rF2Urg59uB2BlMDbFuy4Dcg==
X-Received: by 2002:a05:600c:3153:b0:3ea:f73e:9d8c with SMTP id h19-20020a05600c315300b003eaf73e9d8cmr4107437wmo.16.1677921387469;
        Sat, 04 Mar 2023 01:16:27 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id c21-20020a7bc015000000b003e214803343sm8254413wmb.46.2023.03.04.01.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 01:16:26 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
        id 1335BBE2DE0; Sat,  4 Mar 2023 10:16:26 +0100 (CET)
Date:   Sat, 4 Mar 2023 10:16:26 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] mpt3sas: Remove usage of dma_get_required_mask api
Message-ID: <ZAMMarCPzUSpvrQ1@eldamar.lan>
References: <20221028091655.17741-1-sreekanth.reddy@broadcom.com>
 <20221028091655.17741-2-sreekanth.reddy@broadcom.com>
 <Y15lk+CPsjJ801iY@infradead.org>
 <181536c494aa39ca78b190396a97072448739411.camel@suse.com>
 <yq1tu192iur.fsf@ca-mkp.ca.oracle.com>
 <Y8+m0w4Og2CLFImY@lorien.valinor.li>
 <Y/ZGe8c1XyqSuCSk@eldamar.lan>
 <9aa5e89f-6579-15e5-cc51-d226b5d4bea3@leemhuis.info>
 <754b030c-ba14-167c-e2d0-2f4f5bf55e99@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <754b030c-ba14-167c-e2d0-2f4f5bf55e99@leemhuis.info>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thorsten, thanks for you time!

On Fri, Mar 03, 2023 at 10:39:32AM +0100, Linux regression tracking (Thorsten Leemhuis) wrote:
> On 27.02.23 15:07, Thorsten Leemhuis wrote:
> > On 22.02.23 17:44, Salvatore Bonaccorso wrote:
> >> On Tue, Jan 24, 2023 at 10:37:23AM +0100, Salvatore Bonaccorso wrote:
> >>> On Mon, Jan 02, 2023 at 08:06:41AM -0500, Martin K. Petersen wrote:
> >>>>> is anything blocking mainline inclusion of this patch?
> >>>> I app
> 
> [removing a footer from the quoting here, that accidentally was added
> here in my previous mail; sorry!]
> 
> >>>> lied these to 6.2/scsi-fixes last week. The patches have been
> >>>> sitting in a topic branch for a bit due to the three-way conflict
> >>>> between fixes, queue, and upstream.
> >>>
> >>> It landed in 6.2-rc4 recently in fact. Thank you!
> >>>
> >>> Would it be posssible to backport the fix as well back to the stable
> >>> series affected? 
> >>>
> >>> In Debian we have the reports as per https://bugs.debian.org/1022126
> >>> where the issue was introduced back in 5.10.y. Context in
> >>> https://lore.kernel.org/linux-scsi/CAK=zhgr=MYn=-mrz3gKUFoXG_+EQ796bHEWSdK88o1Aqamby7g@mail.gmail.com/
> >>
> >> Friendly ping on this, can this change be backported as well to the
> >> relevant stable series? It would apply already cleanly to 6.1.y, but
> >> due to 9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while
> >> reallocating pools") it might need some additional review for the
> >> older stable series (in particular of interest due to the above for
> >> 5.10.y).
> > 
> > This afaics is a reasonable request for 6.1, as this seems to be
> > (Salvatore, please correct me if I'm wrong) a regression caused by
> > 0e0747de0ea3 ("scsi: mpt3sas: Fix return value check of
> > dma_get_required_mask()"), which was merged for 6.0-rc7. Hence allow me
> > to ask:
> > 
> > Sreekanth and Martin, is there a reason why this request (and the
> > earlier one a month ago) was apparently met with silence? Or was
> > progress made in between and I just missed it?
> 
> Salvatore, seems my inquiry didn't help. I'd suggest you ask the stable
> maintainers yourself to pick this up for 6.1.y. See "Option 2" in
> 
> 
> https://docs.kernel.org/process/stable-kernel-rules.html

Yes as a start this will help to get it in 6.1 where it should apply
cleanly, thank you. I will do that next.

> 
> > Salvatore, for 5.10 things are a bit more complicated, as someone would
> > need to do the work. Sometimes that work is done by the driver
> > developers and maintainers as well, but strictly speaking it's the duty
> > of those that backported the change to 5.10.y. Didn't check who did that
> > this case (the stable team?); but well, maybe let's sort this out for
> > 6.1.y first.
> 
> Option 3 mentioned on above page might work for you here.

That might be an option yes. And the fix really neeeds to go back to
5.10.y at least as people are experiencing regressions from it (see
the Debian bugs). Help and confirmation from the affected people would
be welcome, but did not happened so far.

Thorsten, thanks for your work on the regression trackings!

Regards,
Salvatore
