Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728ADC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 19:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D9A52065E
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 19:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C0ZHKh7E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgG1TuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 15:50:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55487 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728186AbgG1TuM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Jul 2020 15:50:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595965811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kbgGomFHxjZgbNS24Gw2xKMPEOyUJPdeQIXs70rDXp4=;
        b=C0ZHKh7ExXtM31J013G+JCLdyo+mwCi3kmRkLchl6i1nVTH5tLKJWSTFRBo+OaVCz8hNzS
        ZMyY3Ir7Ub+63IvF5iAWkn3ppPO6lABzytEvPUdWwMNlZ3C1P/gokwDivOL2rjJllhUzge
        RCJJoMEhyC8Yqal6JZwzJr3MwK41ZlM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-is0feVWEMDq5ZdM1p0nj2Q-1; Tue, 28 Jul 2020 15:50:06 -0400
X-MC-Unique: is0feVWEMDq5ZdM1p0nj2Q-1
Received: by mail-qk1-f200.google.com with SMTP id q3so14700005qkj.10
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2020 12:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kbgGomFHxjZgbNS24Gw2xKMPEOyUJPdeQIXs70rDXp4=;
        b=nykVBk9b/QXfAigVMrfzGSdXmjjr/PQkfjl+DpweomrLFEMeb8J/ll5uzglgLyEFX8
         0U5I0U282jEXtbqr+Vbvy+m4x9vN9w0tFjfFTj4YbgFY0HVsAWMccTt7+oEY2P9Q3e9I
         wBy94zUTtR2HHBFn0w6XczkfENkF+ZFgVTzhn5sJD6GGP1v9U/Bnr8UTMjcsQCHUzXq+
         wtZgi6Q2A4CPdrQOiqi1jZ8e+8zFnAIrKyz2MtTU1J6dR/xMxr7tqBUCulRfSco/s/Jr
         pa9e0P0yG4LmbQGxMwlR1by6uxfCeEJ2wNKriCktJyx2ru6mrcmgLg9AcjwEZG29hG/i
         c01Q==
X-Gm-Message-State: AOAM530VK5nNRTeDicCezEm649HBEicQkH/51bCPq3zUxpAy0CNR3bTC
        9DcmvydEoVy4+EBGvpZD20XZBfCO6mGLQhAuBaMaJvh0EP4VWz1Y9jExrkeETiLGtgQ72SK6E+b
        ApAJOnFTvJRnuUx7hV3GSMg==
X-Received: by 2002:ae9:f504:: with SMTP id o4mr15203161qkg.40.1595965806348;
        Tue, 28 Jul 2020 12:50:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNFI0LEmYOqux93hpNb8djnAEsReuoiPgyOZ+FPCYtmrNQS6rUzsbrZ0aP7Ds2jWhbWdFCpQ==
X-Received: by 2002:ae9:f504:: with SMTP id o4mr15203130qkg.40.1595965805968;
        Tue, 28 Jul 2020 12:50:05 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id h15sm19009586qtr.2.2020.07.28.12.50.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 12:50:05 -0700 (PDT)
Message-ID: <da14033928b356c5691187f819f8e6101901dafd.camel@redhat.com>
Subject: Re: [PATCH] scsi_transport_srp: sanitize scsi_target_block/unblock
 sequences
From:   Laurence Oberman <loberman@redhat.com>
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Date:   Tue, 28 Jul 2020 15:50:04 -0400
In-Reply-To: <d8c4f8e27ff77b85588ee237b2b3e408c91839c7.camel@redhat.com>
References: <20200728134833.42547-1-hare@suse.de>
         <d8c4f8e27ff77b85588ee237b2b3e408c91839c7.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-07-28 at 14:43 -0400, Laurence Oberman wrote:
> On Tue, 2020-07-28 at 15:48 +0200, Hannes Reinecke wrote:
> > The SCSI midlayer does not allow state transitions from SDEV_BLOCK
> > to SDEV_BLOCK, so calling scsi_target_block() from
> > __rport_fast_io_fail()
> > is wrong as the port is already blocked.
> > Similarly we don't need to call scsi_target_unblock() afterwards as
> > the
> > function has already done this.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/scsi/scsi_transport_srp.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_transport_srp.c
> > b/drivers/scsi/scsi_transport_srp.c
> > index d4d1104fac99..cba1cf6a1c12 100644
> > --- a/drivers/scsi/scsi_transport_srp.c
> > +++ b/drivers/scsi/scsi_transport_srp.c
> > @@ -395,6 +395,10 @@ static void srp_reconnect_work(struct
> > work_struct *work)
> >  	}
> >  }
> >  
> > +/*
> > + * scsi_target_block() must have been called before this function
> > is
> > + * called to guarantee that no .queuecommand() calls are in
> > progress.
> > + */
> >  static void __rport_fail_io_fast(struct srp_rport *rport)
> >  {
> >  	struct Scsi_Host *shost = rport_to_shost(rport);
> > @@ -404,11 +408,7 @@ static void __rport_fail_io_fast(struct
> > srp_rport *rport)
> >  
> >  	if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
> >  		return;
> > -	/*
> > -	 * Call scsi_target_block() to wait for ongoing shost-
> > > queuecommand()
> > 
> > -	 * calls before invoking i->f->terminate_rport_io().
> > -	 */
> > -	scsi_target_block(rport->dev.parent);
> > +
> >  	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
> >  
> >  	/* Involve the LLD if possible to terminate all I/O on the
> > rport. */
> > @@ -570,8 +570,6 @@ int srp_reconnect_rport(struct srp_rport
> > *rport)
> >  		 * failure timers if these had not yet been started.
> >  		 */
> >  		__rport_fail_io_fast(rport);
> > -		scsi_target_unblock(&shost->shost_gendev,
> > -				    SDEV_TRANSPORT_OFFLINE);
> >  		__srp_start_tl_fail_timers(rport);
> >  	} else if (rport->state != SRP_RPORT_BLOCKED) {
> >  		scsi_target_unblock(&shost->shost_gendev,
> 
> This looks OK to me but I guess its alwasy worked by just ignoring it
> being called or IU would have seenm issues.
> I etest that stuff pretty heavily.
> Reviewed-by: Laurence Oberman <loberman@redhat.com>
> 

Ouch, my last message saw my bad touch typing creep in. Let me try
again.

This looks OK to me but I guess its always worked by just ignoring it
being called or I would have seen issues already.
I test that stuff pretty heavily and regularly.

Reviewed-by: Laurence Oberman <loberman@redhat.com>


