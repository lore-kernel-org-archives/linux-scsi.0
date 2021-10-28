Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5876C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 835E060E8B
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhJ1Uqm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:46:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231221AbhJ1Uql (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 16:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635453854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUgXJSIh8EFoSAMumEnxtmiGI4n5OomF7wYpw8hip98=;
        b=EjXeqqfMQk0cKAI6wiiBeXlZ9099NuhMwxrmuxjWy5gOMybMMx5EYajepGQ+6e5bIaQSkV
        iqdxDvxQFK/4FujKYyE7ZXHzsHgaFE7fbuYXlLHkUE+Ys2BjNg7//1eYyeuVMVMAanOv/f
        XcEYKX7dk94vJavcm5/UzKMn9DR4KM0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-t9wpZyQJM0SHMlp0F9ivvw-1; Thu, 28 Oct 2021 16:44:12 -0400
X-MC-Unique: t9wpZyQJM0SHMlp0F9ivvw-1
Received: by mail-qt1-f198.google.com with SMTP id 100-20020aed30ed000000b002a6b3dc6465so5276438qtf.13
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 13:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=SUgXJSIh8EFoSAMumEnxtmiGI4n5OomF7wYpw8hip98=;
        b=da08+283jhvUYVWS05EttB/txBDC8tABpgWk/ZOxFn7Q3Hkk7FEa6KAN31N7inH0DD
         vkCjPAAA9DEavfhjP9yEF6u8dVFCqWPPCXiN78vH8+nZYH5qOPpKJ7MIwKUQGlGCX0II
         +jofdEtVWFUmm36GXLuIhNLndzts2a/EEJ6fc1FETlXnFuuV/gkzt+U0IV/UV3QuakKn
         FPmVyaYjDWmh0MgqqWVWOyuJ4h2dy0Az1rsw3vGW9vTLKa8EE7jw5ZFkF0l0bLb58E5X
         V36ICHgxxRAFfxYdRLIEpvVO8QkA5KIK0wWRXjw127p5svKSMeOth0UNmzx90V8wB+bV
         +/AQ==
X-Gm-Message-State: AOAM532wKRdZ2OQczqhR7aB5nxbBFa+eo28JDVUKi49RCr3TDTepiPi+
        Ot35uL1/lDZgo/MzQeC4DHWnn7YIQNP5oPxePnh/4oEPMFshDZpRAQbWif+7GLT4ljwjr0h53E0
        jFOZFGRH9Pd43Z1tSnojS6g==
X-Received: by 2002:a05:622a:1305:: with SMTP id v5mr7336192qtk.62.1635453852367;
        Thu, 28 Oct 2021 13:44:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxW/pZCx3BUmMoOnbwLyJXXWjlVZfGY0QV8draJxhGBGHnbSdRJ0s3LzZ0AFGYy/3OheLLGBQ==
X-Received: by 2002:a05:622a:1305:: with SMTP id v5mr7336173qtk.62.1635453852141;
        Thu, 28 Oct 2021 13:44:12 -0700 (PDT)
Received: from emilne (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s7sm1480148qta.3.2021.10.28.13.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 13:44:11 -0700 (PDT)
Message-ID: <59d97121fb10961b0d6df291f983c9a578bc86e6.camel@redhat.com>
Subject: Re: [PATCH 1/2] scsi: core: avoid leaving shost->last_reset with
 stale value if EH does not run
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Date:   Thu, 28 Oct 2021 16:44:10 -0400
In-Reply-To: <yq1sfwlygts.fsf@ca-mkp.ca.oracle.com>
References: <20211025143952.17128-1-emilne@redhat.com>
         <20211025143952.17128-2-emilne@redhat.com>
         <yq1sfwlygts.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-10-27 at 23:29 -0400, Martin K. Petersen wrote:
> Ewan,
> 
> No particular objections to the functional change, although I would
> appreciate if Hannes would have a look.

Absolutely.

> 
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index b6c86cc..9f4001e 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -151,9 +151,11 @@ scmd_eh_abort_handler(struct work_struct *work)
> >  	struct scsi_cmnd *scmd =
> >  		container_of(work, struct scsi_cmnd, abort_work.work);
> >  	struct scsi_device *sdev = scmd->device;
> > +	struct Scsi_Host *shost = sdev->host;
> >  	enum scsi_disposition rtn;
> > +	unsigned long flags;
> >  
> > -	if (scsi_host_eh_past_deadline(sdev->host)) {
> > +	if (scsi_host_eh_past_deadline(shost)) {
> >  		SCSI_LOG_ERROR_RECOVERY(3,
> >  			scmd_printk(KERN_INFO, scmd,
> >  				    "eh timeout, not aborting\n"));
> 
> Changing sdev->host to shost makes this patch harder to review and
> creates unnecessary churn for a stable fix. Maybe postpone that
> particular cleanup?

Sure.  I added shost because the later code I added would have used
sdev->shost a lot, seemed like I should have changed all uses.
But I can it the other way, it will end up being the same after the
subsequent patch.

> 
> > @@ -175,12 +177,42 @@ scmd_eh_abort_handler(struct work_struct *work)
> >  				SCSI_LOG_ERROR_RECOVERY(3,
> >  					scmd_printk(KERN_WARNING, scmd,
> >  						    "retry aborted command\n"));
> > +
> > +				spin_lock_irqsave(shost->host_lock, flags);
> > +				list_del_init(&scmd->eh_entry);
> > +
> > +				/*
> > +				 * If the abort succeeds, and there is no further
> > +				 * EH action, clear the ->last_reset time.
> > +				 */
> > +				if (list_empty(&shost->eh_abort_list) &&
> > +				    list_empty(&shost->eh_cmd_q))
> > +					if (shost->eh_deadline != -1)
> > +						shost->last_reset = 0;
> > +
> > +				spin_unlock_irqrestore(shost->host_lock, flags);
> > +
> 
> Perhaps you could introduce a scsi_host_clear_last_reset() helper to
> avoid duplicating this code?

I removed the duplication in the subsequent patch, the reason it is duplicated
here is to keep the control flow the same and avoid taking the ->host_lock twice.

-Ewan

> 

