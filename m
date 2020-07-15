Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E156C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 06:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E61BC20663
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 06:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uYCgmJ/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgGOG3s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 02:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgGOG3s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 02:29:48 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E6DC061794
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 23:29:48 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so4293593wml.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 23:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=XltbK9J78KHesM1F1OCc3vXGyhRc9/MBn/JKRUdD08w=;
        b=uYCgmJ/s1xgjsepLdk/ioryRZvNZTY9AYC2MrIsI8SZN0drSwGjzm65Qzb1lmJCZQn
         jZ5mzb/8LnYUgU8tbkx3BE+kHu4Vq86l1wujZX/beam+LCPilqImWdE5Q4Ook+e5flkr
         pu8wSO5mDqhRpIigaGDEVRQGvWzD7RRddOf9LGeficCslERoHuEZo/77MrUusm62rBWu
         kmw+7srmhY17wTzW7og5M/7p4IjFGdAreXLOg5y9nLgySfUeRlhWnGgq5JDh3NRIELJg
         fYNhwEvTm79YoOsBhW2uUXKHs1HdunEJMuFka2UAj/3yk22TTzLpfdtxJ2YLWou+vSls
         SE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XltbK9J78KHesM1F1OCc3vXGyhRc9/MBn/JKRUdD08w=;
        b=CDLIz+nChvjhvRJhwha/x8/iJQCtrGEY54QySj7seD2b6HrXfSv6XS1NS/GOywYGv0
         cqVVeSCSZczJVOyJCzcQO7HGBMBMjJRXBq4SaGtIIlbNiW2x0FVxqMNs2q4VKiEDgBo9
         +7632Bdw5f50KnLjjxCqLDfTDd/A0jHBJSJsHZ5N3JCL5YEZrR6e94A8x4r7F+s1FMIT
         AaoJAcwWh090FsAMPKlCF42nDB84fz0VxQ4vJLk+heyF90YIYcesilscjrLtj1uU5C23
         Rmpy0En69SNNkS15EQwnyzX4UAu48PyPRwoRRpJrBpM+1VsA8qfNeImdl4IFEHECC6vm
         E2Fw==
X-Gm-Message-State: AOAM530mpB0YygENPsM2op37O+60SDzrsxbutzVWKUCA/yT4lejuC53T
        ALbxubDWalsbzCZPdmKnIkn7rw==
X-Google-Smtp-Source: ABdhPJzAl8wp8SOyF7+a3BMR8dQtrygD0Ye0y62SlYWAUlg+gwXSM/gszkn9DgKVUPlCgkhl4whmTg==
X-Received: by 2002:a1c:3546:: with SMTP id c67mr7205866wma.102.1594794586771;
        Tue, 14 Jul 2020 23:29:46 -0700 (PDT)
Received: from dell ([2.31.163.61])
        by smtp.gmail.com with ESMTPSA id p4sm1787729wrx.63.2020.07.14.23.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 23:29:46 -0700 (PDT)
Date:   Wed, 15 Jul 2020 07:29:44 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v2 24/24] scsi: aic7xxx: aic79xx_osm: Remove set but
 unused variabes 'saved_scsiid' and 'saved_modes'
Message-ID: <20200715062944.GM1398296@dell>
References: <20200713080001.128044-1-lee.jones@linaro.org>
 <20200713080001.128044-25-lee.jones@linaro.org>
 <559e47de-fa26-9ae5-a3c5-4adeae606309@suse.de>
 <1594741430.4545.15.camel@linux.ibm.com>
 <20200714213951.GL1398296@dell>
 <1594767794.14804.21.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1594767794.14804.21.camel@linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Jul 2020, James Bottomley wrote:

> On Tue, 2020-07-14 at 22:39 +0100, Lee Jones wrote:
> > On Tue, 14 Jul 2020, James Bottomley wrote:
> > 
> > > On Tue, 2020-07-14 at 09:46 +0200, Hannes Reinecke wrote:
> > > > On 7/13/20 10:00 AM, Lee Jones wrote:
> > > > > Haven't been used since 2006.
> > > > > 
> > > > > Fixes the following W=1 kernel build warning(s):
> > > > > 
> > > > >  drivers/scsi/aic7xxx/aic79xx_osm.c: In function
> > > > > ‘ahd_linux_queue_abort_cmd’:
> > > > >  drivers/scsi/aic7xxx/aic79xx_osm.c:2155:17: warning: variable
> > > > > ‘saved_modes’ set but not used [-Wunused-but-set-variable]
> > > > >  drivers/scsi/aic7xxx/aic79xx_osm.c:2148:9: warning: variable
> > > > > ‘saved_scsiid’ set but not used [-Wunused-but-set-variable]
> > > > > 
> > > > > Cc: Hannes Reinecke <hare@suse.com>
> > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > ---
> > > > >  drivers/scsi/aic7xxx/aic79xx_osm.c | 4 ----
> > > > >  1 file changed, 4 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c
> > > > > b/drivers/scsi/aic7xxx/aic79xx_osm.c
> > > > > index 3782a20d58885..140c4e74ddd7e 100644
> > > > > --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> > > > > +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> > > > > @@ -2141,14 +2141,12 @@ ahd_linux_queue_abort_cmd(struct
> > > > > scsi_cmnd
> > > > > *cmd)
> > > > >  	u_int  saved_scbptr;
> > > > >  	u_int  active_scbptr;
> > > > >  	u_int  last_phase;
> > > > > -	u_int  saved_scsiid;
> > > > >  	u_int  cdb_byte;
> > > > >  	int    retval;
> > > > >  	int    was_paused;
> > > > >  	int    paused;
> > > > >  	int    wait;
> > > > >  	int    disconnected;
> > > > > -	ahd_mode_state saved_modes;
> > > > >  	unsigned long flags;
> > > > >  
> > > > >  	pending_scb = NULL;
> > > > > @@ -2239,7 +2237,6 @@ ahd_linux_queue_abort_cmd(struct
> > > > > scsi_cmnd
> > > > > *cmd)
> > > > >  		goto done;
> > > > >  	}
> > > > >  
> > > > > -	saved_modes = ahd_save_modes(ahd);
> > > > >  	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
> > > > >  	last_phase = ahd_inb(ahd, LASTPHASE);
> > > > >  	saved_scbptr = ahd_get_scbptr(ahd);
> > > > > @@ -2257,7 +2254,6 @@ ahd_linux_queue_abort_cmd(struct
> > > > > scsi_cmnd
> > > > > *cmd)
> > > > >  	 * passed in command.  That command is currently
> > > > > active on
> > > > > the
> > > > >  	 * bus or is in the disconnected state.
> > > > >  	 */
> > > > > -	saved_scsiid = ahd_inb(ahd, SAVED_SCSIID);
> > > > >  	if (last_phase != P_BUSFREE
> > > > >  	    && SCB_GET_TAG(pending_scb) == active_scbptr) {
> > > > >  
> > > > > 
> > > > 
> > > > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > > 
> > > Hey, you don't get to do that ... I asked you to figure out why
> > > we're missing an ahd_restore_modes().  Removing the
> > > ahd_save_modes() is cosmetic: it gets rid of a warning but doesn't
> > > fix the problem.  I'd rather keep the warning until the problem is
> > > fixed and the problem is we need a mode save/restore around the
> > > ahd_set_modes() which is only partially implemented in this
> > > function.
> > 
> > I had a look.  Traced it back to the dawn of time (time == Git), then
> > delved even further back by downloading and trawling through ~10-15
> > tarballs.  It looks as though drivers/scsi/aic7xxx/aic79xx_osm.c was
> > upstreamed in v2.5.60, nearly 20 years ago.  'saved_modes' has been
> > unused since at least then.  If no one has complained in 2 decades,
> > I'd say it probably isn't an issue worth perusing.
> 
> Well, we have what looks like a fix now.  The reason it matters is that
>  if the bus is not in AHD_MODE_SCSI when the routine is called, it ends
> up being in a wrong state when the routine exits, so you abort one
> command and screw up another.  Ultimately I bet escalation to bus reset
> fixes it, so everything appears to work, but it might have worked a lot
> better if the original mode were restored.
> 
> This is error handling code, so most installations run just fine
> without ever invoking it.

Understood.

Obviously a *real* fix is better than this warning suppression one.  I
was just explaining that, try as I might, I couldn't find any
non-broken code to use to use as a reference to author a proper fix
for this.

This being the first mail in my inbox, so I don't know if the proper
fix you reference above was a) sent as a patch and/or b) sent to me,
but it's great news that you have one either way.

Please drop this patch.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
