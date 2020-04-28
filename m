Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8E0C83004
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73A39206D6
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:59:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TywRN+RP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD1L7I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 07:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgD1L7H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2020 07:59:07 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E135AC03C1A9;
        Tue, 28 Apr 2020 04:59:06 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u16so2526715wmc.5;
        Tue, 28 Apr 2020 04:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LeC1uaevuakthMhzvAUTMRfuS/b7b0QfaVq2uJ7LUCY=;
        b=TywRN+RPYjVnFc3yk8OarP1C+B1IVik0/IiTiBpVCbu/drxuCyFSxHpKbE6qhD4Jcj
         f6obmFkhEfRVA9eF1Df2eKHGS29LqySWjKYCGlrjpt383oovyQZVwZCgeqJ6EAZOLyXH
         /o8i9tZVjOkq8+StYYcHrP21YolyzUulY2XBB9V2Z+j12XWzoVtpPNMAfDo0v+OWrDtT
         isX1WyChfEOBeoATaQxMr9OjsQcCYXf+GibJslla0Vm9KjqmVV70XfK4ctbC1rbgmLMw
         mIfP7pA4bPRkKkQqibjqfABomRPQdu9MfAQUkVgXK3f1PTvdmkAd0ozCeENQZK5Q78/f
         ArWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LeC1uaevuakthMhzvAUTMRfuS/b7b0QfaVq2uJ7LUCY=;
        b=MfBPz+WFrAGUKhJJiFfMSma5cSJmMoZNLPYAEtMdAkBH/qJsU1/7IZKXiUHviSqzdc
         kpkU1psOhqM8IkRfyO/6kUBvP6/+hgzhffzRtrAQCP+hi/7715UaxFm8z+6Uh13ZCq6a
         jrIuHYmw/3loAsE0lSLSqOd6y3DhEDsEqYn0tQ96IByKMzib8NIJOoOp3wYMV3aR2gou
         XGuL1NS1lrPVV0VnLwzz9fZ7EOoiK7cvo4w8udKiMzLo8dzOSFEEvF1f2mCi3PBCApyQ
         y5qFebMhc2NZ6nrHu4MDs+kw9XUxrkxbOCXLzBGN8FCbMrPw674/+Uov1BAgbThM3pFj
         5urw==
X-Gm-Message-State: AGi0PuZZDgkLAnytE1jFBGh3momop8bBmTXFEhM7w+RlBNUUzRvph98S
        8V//8M3T1uqJOszAjWyx7YI=
X-Google-Smtp-Source: APiQypIuNZ/GGKsSlrW8gmgiGjhK0HFlX5J2zPAurDYW45POsdWK9tFbo4qZu79K4Uy7KdPQu2lQLQ==
X-Received: by 2002:a7b:c858:: with SMTP id c24mr4419878wml.51.1588075145606;
        Tue, 28 Apr 2020 04:59:05 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id z2sm24510753wrm.77.2020.04.28.04.59.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Apr 2020 04:59:04 -0700 (PDT)
Message-ID: <15eca4dd2ec8a4ba210ce0844e9f5027251fa6f2.camel@gmail.com>
Subject: Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 28 Apr 2020 13:59:03 +0200
In-Reply-To: <SN6PR04MB464009AFAC8F7EFC04184826FCAC0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
         <20200416203126.1210-6-beanhuo@micron.com>
         <8921adc3-0c1e-eb16-4a22-1a2a583fc8b3@acm.org>
         <SN6PR04MB4640851C163648C54EB274C5FCD00@SN6PR04MB4640.namprd04.prod.outlook.com>
         <SN6PR04MB4640ABB2BB5D2CE5AA2C3778FCD10@SN6PR04MB4640.namprd04.prod.outlook.com>
         <12e8ad61-caa4-3d28-c1d7-febe99a488fb@acm.org>
         <SN6PR04MB4640A33BBE0CD58107D7FC69FCAF0@SN6PR04MB4640.namprd04.prod.outlook.com>
         <b2584ba8-3542-1aae-5802-e59d218e1553@acm.org>
         <SN6PR04MB464009AFAC8F7EFC04184826FCAC0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-04-28 at 08:14 +0000, Avri Altman wrote:
> > 
> > On 2020-04-26 23:13, Avri Altman wrote:
> > > > On 2020-04-25 01:59, Avri Altman wrote:
> > > 
> > > HPB support is comprised of 4 main duties:
> > > 1) Read the device HPB configuration
> > > 2) Attend the device's recommendations that are embedded in the
> > > sense
> > 
> > buffer
> > > 3) L2P cache management - This entails sending 2 new scsi
> > > commands
> > 
> > (opcodes were taken from the vendor pool):
> > >       a. HPB-READ-BUFFER - read L2P physical addresses for a
> > > subregion
> > >       b. HPB-WRITE-BUFFER - notify the device that a region is
> > > inactive (in
> > 
> > host-managed mode)
> > > 4) Use HPB-READ: a 3rd new scsi command (again - uses the vendor
> > > pool)
> > 
> > to perform read operation instead of READ10.  HPB-READ carries both
> > the
> > logical and the physical addresses.
> > > 
> > > I will let Bean defend the Samsung approach of using a single LLD
> > > to attend
> > 
> > all 4 duties.
> > > 
> > > Another approach might be to split those duties between 2
> > > modules:
> > >  - A LLD that will perform the first 2 - those can be done only
> > > using ufs
> > 
> > privet stuff, and
> > >  - another module in scsi mid-layer that will be responsible of
> > > L2P cache
> > 
> > management,
> > >   and HPB-READ command setup.
> > > A framework to host the scsi mid-layer module can be the scsi
> > > device
> > 
> > handler.
> > > 
> > > The scsi-device-handler infrastructure was added to the kernel
> > > mainly to
> > 
> > facilitate multiple paths for storage devices.
> > > The HPB framework, although far from the original intention of
> > > the
> > 
> > authors, might as well fit in.
> > > In that sense, using READs and HPB_READs intermittently, can be
> > > perceived
> > 
> > as a multi-path.
> > > 
> > > Scsi device handlers are also attached to a specific scsi_device
> > > (lun).
> > > This can serve as the glue linking between the ufs LLD and the
> > > device
> > 
> > handler which resides in the scsi level.
> > > 
> > > Device handlers comes with a rich and handy set of APIs & ops,
> > > which we
> > 
> > can use to support HPB.
> > > Specifically we can use it to attach & activate the device
> > > handler,
> > > only after the ufs driver verified that HPB is supported by both
> > > the platform
> > 
> > and the device.
> > > 
> > > The 2 modules can communicate using the handler_data opaque
> > > pointer,
> > > and the handler’s set_params op-mode: which is an open protocol
> > 
> > essentially,
> > > and we can use it to pass the sense buffer in its full or just a
> > > parsed version.
> > > 
> > > Being a scsi mid-layer module, it will not break anything while
> > > sending
> > > HPB-READ-BUFFER and HPB-WRITE-BUFFER as part of the L2P cache
> > 
> > management duties.
> > > 
> > > Last but not least, the device handler is already hooked in the
> > > scsi
> > 
> > command setup flow - scsi_setup_fs_cmnd(),
> > > So we get the hook into HPB-READ prep_fn for free.
> > > 
> > > Later on, we might want to export the L2P cache management logic
> > > to
> > 
> > user-space.
> > > Locating the L2P cache management in scsi mid-layer will enable
> > > us to do
> > 
> > so, using the scsi-netlink or some other means.
> > 
> > Hi Avri,
> > 
> > I'm not sure that I agree that HPB can be perceived as multi-path.
> > Anyway, the above approach sounds interesting to me. A few
> > questions
> > though:
> > - The only in-tree caller of scsi_dh_attach() I am aware of exists
> > in
> >   the dm-mpath driver. I think that call is triggered by
> > multipathd.
> >   I don't think that it is acceptable to require that multipathd is
> >   running to use the UFS HPB functionality. What is the plan for
> >   attaching the UFS device handler to UFS devices?
> 
> Right.
> Device handlers are meant to be called as part of the device mapper
> multi-path code.  We can’t do that – we need to attach & activate the
> device handler manually, only after the ufs driver verified that HPB
> is
> supported by both the platform and the device.
> 
> I was thinking to rely on the ufs's 2-phase boot:
> The ufs boot process is essentially comprised of 2 parts: first
> a                                                                    
>                                                                      
>                                                                  
> handshake with the device, and then, scsi scans and assign a scsi
> device                                                               
>                                                                      
>                                                                
> to each lun.  The latter, although running a-synchronically,
> is                                                                   
>                                                                      
>                                                                     
> happening right after reading the device configuration - lun by
> lun.                                                                 
>                                                                      
>                                                                  
>                                                                      
>                                                                      
>                                                                      
>                                                                
> By now we've read the device HPB configuration, and we are ready  to
> attach a scsi device to our HPB luns.  A perfect timing might be
> while
> scsi is performing its .slave_alloc() or .slave_configure().
> 

hi, Avri
That means HPB memory allocation done in .scan_finished() ?
and sd_init_command() needs to change as well, add a new request
type REQ_OP_HPB_READ?


Bean


