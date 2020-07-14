Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5807C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C52320656
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:16:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qRr2B3VH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgGNVQS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgGNVQR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 17:16:17 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7151CC061755
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 14:16:17 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q15so620977wmj.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 14:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JUEg0KE2LQNXUnQ1n5BTApkaeDmfdKi09730MDrCtg0=;
        b=qRr2B3VHmkvr9FzAb3TPPTTqg5epYJaKAyo+kjk19u5o8YsrGM5dkE+b4m+vt5vaUn
         WEadUCo2DCD3ihT+hjhAZ/keb6lH8+Mrb3cc5ha/3M8RgcylQ9+aF6RLvSiSojj2Wmlb
         1hpN7rZzGO5b2WpeiXfgfDTrAsJRazU6v2C2wgQCxUuT0h31EQU97VXxMVzWbE+KN2gN
         S+nCngBk7af0akuxHtqWzE7q2ttmbFrZ+lsOWmVEMNz8ARkMf8bGeeWg6rjlAfPFQj+Y
         h97fnhnLQqxNgCHKMocfPN22r/uYjTwtq2KN9GSB0SoN5SkPf3mHaSEmOyGXm9lqSNsu
         9dVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JUEg0KE2LQNXUnQ1n5BTApkaeDmfdKi09730MDrCtg0=;
        b=AVBSKY8BkPlXvBECqkRlJssk3JLOAa21/afIkwIFDfbfdXVtBVOXZJiGHKO8NQgj7W
         mNszY69GdkzzV1RGlGJcIQwViwo07DvQlqamrXtMKQ1llWPdJ0DodS6eWD7D9Cef2y4z
         ZeFAREx9tE7b8dXltjjrtbD2OLoEae8WblZ28RQYy/EBNEtDrVoFgsvSOt2uJDofJnZq
         0E+r+dWGDMXIlHsOUmGTGxjbhym2ftRoaPSbdeP17K6uDEDxNwhtXRPXj/NUmEq1Qluo
         BIIHEjqp9HdKk+V6bJCtXC6M+3YyK6veGYkLm6pBuLo4ZEZDuL1+GGDYNEYxLNCBH101
         c45w==
X-Gm-Message-State: AOAM533MCPWcPPCh+uPNSuxx1UEa+cXO3DY0H9p2yXnpmVMx46nev+rD
        iHs2AHOJhc0aUYLxQ9kEF6OPWjxGZ1X5SQ==
X-Google-Smtp-Source: ABdhPJytELNObhA895rBmJRA6pjcTMN68Hpoeai8c9X/kohg1+XkGLZ++8WCuOYx+YzJWvcCVsWgZg==
X-Received: by 2002:a05:600c:2182:: with SMTP id e2mr5513024wme.186.1594760923346;
        Tue, 14 Jul 2020 14:08:43 -0700 (PDT)
Received: from dell ([2.31.163.61])
        by smtp.gmail.com with ESMTPSA id a123sm30765wmd.28.2020.07.14.14.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 14:08:42 -0700 (PDT)
Date:   Tue, 14 Jul 2020 22:08:41 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Doug Ledford <dledford@redhat.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v2 18/29] scsi: aic7xxx: aic7xxx_osm: Remove unused
 variable 'tinfo'
Message-ID: <20200714210841.GK1398296@dell>
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-19-lee.jones@linaro.org>
 <95350d0a60d1e305e2053388ada2cbd3310684e3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95350d0a60d1e305e2053388ada2cbd3310684e3.camel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Jul 2020, Doug Ledford wrote:

> On Mon, 2020-07-13 at 08:46 +0100, Lee Jones wrote:
> > Looks like none of the artifact from  ahc_fetch_transinfo() are used
> > anymore.
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/scsi/aic7xxx/aic7xxx_osm.c: In function
> > ‘ahc_linux_target_alloc’:
> >  drivers/scsi/aic7xxx/aic7xxx_osm.c:567:30: warning: variable ‘tinfo’
> > set but not used [-Wunused-but-set-variable]
> >  567 | struct ahc_initiator_tinfo *tinfo;
> >  | ^~~~~
> > 
> > Cc: Hannes Reinecke <hare@suse.com>
> > Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
> > Cc: Doug Ledford <dledford@redhat.com>
> 
> FWIW, I can't seem to figure out how you got mine or Dan's email
> addresses as related to this driver.  The MAINTAINERS file only lists
> Hannes.  The driver Dan and I worked on was a different driver.  It was
> named aic7xxx, but that was back in the 1990s.  It was renamed to
> aic7xxx_old so that Adaptec could contribute this driver you are
> currently patching back around 2001 or so.  And then maybe around 2010
> or something like that, the aic7xxx_old driver that Dan and I worked on
> was removed from the upstream source tree entirely.  So, just out of
> curiosity, how did you get mine and Dan's email addresses to put on the
> Cc: list for these patches?

 $ ./scripts/get_maintainer.pl --file-emails --git-min-percent 75 -f drivers/scsi/aic7xxx/aic7xxx_osm.c
  Hannes Reinecke <hare@suse.com> (maintainer:AIC7XXX / AIC79XX SCSI DRIVER,in file)
  "James E.J. Bottomley" <jejb@linux.ibm.com> (maintainer:SCSI SUBSYSTEM)
  "Martin K. Petersen" <martin.petersen@oracle.com> (maintainer:SCSI SUBSYSTEM)
  "Daniel M. Eischen" <deischen@iworks.InterWorks.org> (in file)
  Doug Ledford <dledford@redhat.com> (in file)
  linux-scsi@vger.kernel.org (open list:AIC7XXX / AIC79XX SCSI DRIVER)
  linux-kernel@vger.kernel.org (open list)

Looks like get_maintainer.pl pulled it from the file header.

> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/scsi/aic7xxx/aic7xxx_osm.c | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > index 2edfa0594f183..32bfe20d79cc1 100644
> > --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> > @@ -564,8 +564,6 @@ ahc_linux_target_alloc(struct scsi_target
> > *starget)
> >  	struct scsi_target **ahc_targp =
> > ahc_linux_target_in_softc(starget);
> >  	unsigned short scsirate;
> >  	struct ahc_devinfo devinfo;
> > -	struct ahc_initiator_tinfo *tinfo;
> > -	struct ahc_tmode_tstate *tstate;
> >  	char channel = starget->channel + 'A';
> >  	unsigned int our_id = ahc->our_id;
> >  	unsigned int target_offset;
> > @@ -612,9 +610,6 @@ ahc_linux_target_alloc(struct scsi_target
> > *starget)
> >  			spi_max_offset(starget) = 0;
> >  		spi_min_period(starget) = 
> >  			ahc_find_period(ahc, scsirate, maxsync);
> > -
> > -		tinfo = ahc_fetch_transinfo(ahc, channel, ahc->our_id,
> > -					    starget->id, &tstate);
> >  	}
> >  	ahc_compile_devinfo(&devinfo, our_id, starget->id,
> >  			    CAM_LUN_WILDCARD, channel,
> 



-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
