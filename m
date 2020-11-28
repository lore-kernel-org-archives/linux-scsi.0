Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E94C83012
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Nov 2020 22:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3966A221FD
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Nov 2020 22:12:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UFjt4iSn";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="5+aGSO4R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389543AbgK1VuC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Nov 2020 16:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731792AbgK1SzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Nov 2020 13:55:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02504C094262
        for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2020 23:28:55 -0800 (PST)
Date:   Sat, 28 Nov 2020 08:28:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606548533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UCYyshmIXHdX0GWRyNmP/18Sr0aiVcjdwJ7YGHsDMLc=;
        b=UFjt4iSnkcU84D5WV6lmz0tEyLr3Slnf4i1eAazveTqrsL+wHklrS3deJ+1Cf+fIz8CBMx
        aJdN6pch1OaR05u0dKOYp6xserWOCrbS884kL3EWaO3GvIEtPYosNHmNivwKjkQMBNMpY4
        co3D8ArpuHigDdpSG4e0J6k2dr9P09VmBqP1g0LKvMkV71zJdQok/IjhA0HaH66mBwvEzz
        o+pxwnPkMJ0WY2v5u1y4PROkQKwISHMiUloOTsGCes8N8r8nBxyeQ2WK/GI1HeMyZNzJD/
        V4rWRjJvDPN53YRZdcSJiJ8sYOKCAIaxOIB6VSdCyVDUJrvB7QhQCUWBRKMf4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606548533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UCYyshmIXHdX0GWRyNmP/18Sr0aiVcjdwJ7YGHsDMLc=;
        b=5+aGSO4RfxGCfzmPYqGAFrlMGFlvaXZcxWsAouMGOgOEcxhZLqqexoTggldcH4aT/ozWOH
        iCxoPEa9UXvOAuBQ==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 12/14] scsi: NCR5380: Remove in_interrupt().
Message-ID: <X8H8M2AM0hfMX7aj@lx-t490>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <20201126132952.2287996-13-bigeasy@linutronix.de>
 <alpine.LNX.2.23.453.2011271524140.15@nippy.intranet>
 <alpine.LNX.2.23.453.2011280802170.6@nippy.intranet>
 <alpine.LNX.2.23.453.2011280827270.14@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.23.453.2011280827270.14@nippy.intranet>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 28, 2020 at 08:48:00AM +1100, Finn Thain wrote:
>
> On Sat, 28 Nov 2020, Finn Thain wrote:
>
> >
> > diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> > index d654a6cc4162..739def70cffb 100644
> > --- a/drivers/scsi/NCR5380.c
> > +++ b/drivers/scsi/NCR5380.c
> > @@ -223,7 +223,10 @@ static int NCR5380_poll_politely2(struct NCR5380_hostdata *hostdata,
> >  		cpu_relax();
> >  	} while (n--);
> >
> > -	if (irqs_disabled() || in_interrupt())
> > +	/* We can't sleep when local irqs are disabled and callers ensure
> > +	 * that local irqs are disabled whenever we can't sleep.
> > +	 */
> > +	if (irqs_disabled())
> >  		return -ETIMEDOUT;
> >
> >  	/* Repeatedly sleep for 1 ms until deadline */
> >
>
> Michael, Andreas, would you please confirm that this is workable on Atari?
> The driver could sleep when IPL == 2 because arch_irqs_disabled_flags()
> would return false (on Atari). I'm wondering whether that would deadlock.

Please re-check the commit log:

  "Linus clearly requested that code which changes behaviour depending
   on context should either be separated, or the context be explicitly
   conveyed in an argument passed by the caller."

So, sorry, drivers shouldn't do context-dependent dances anymore.

For more context (no pun intended), please check the thread mentioned in
the cover letter, and also below message:

  https://lkml.kernel.org/r/CAKMK7uHAk9-Vy2cof0ws=DrcD52GHiCDiyHbjLd19CgpBU2rKQ@mail.gmail.com

Kind regards,

--
Ahmed S. Darwish
Linutronix GmbH
