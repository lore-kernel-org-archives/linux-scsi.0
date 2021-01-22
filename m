Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1775CC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 14:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBB4723A9B
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 14:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbhAVOH7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 09:07:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:59268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbhAVOGv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Jan 2021 09:06:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611324349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R7XfhqoDIEz7jpyYcnyXSRn7M6sZjaUSj8gmZGlpoEI=;
        b=orssuMpeo9fLsIltSqpnmrNRPbgvk2KyrZszmESAbNp4wfHwZbnWj2JQSguYUHAhgWz00X
        jJMSIx/eeMYuwIxZFeb302/UknMp0xZ6YaNUFvTp3RqVoFJ++2ARFJe8eP4nyxnXGeIiFP
        g3PkVH4iBsEAe866v5BSelX1m62hShQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8B289AB92;
        Fri, 22 Jan 2021 14:05:49 +0000 (UTC)
Message-ID: <185aeeb200023f2f38f6c4faa333955719b8b00f.camel@suse.com>
Subject: Re: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
From:   Martin Wilck <mwilck@suse.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Don Brace <Don.Brace@microchip.com>,
        Kevin Barnett <Kevin.Barnett@microchip.com>,
        John Garry <john.garry@huawei.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Date:   Fri, 22 Jan 2021 15:05:48 +0100
In-Reply-To: <20210122032340.GB509982@T590>
References: <20210120184548.20219-1-mwilck@suse.com>
         <20210122032340.GB509982@T590>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-01-22 at 11:23 +0800, Ming Lei wrote:
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 2f162603876f..1c452a1c18fd 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -564,6 +564,8 @@ static bool scsi_host_check_in_flight(struct
> > request *rq, void *data,
> >         int *count = data;
> >         struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
> >  
> > +       /* This pairs with set_bit() in scsi_host_queue_ready() */
> > +       smp_mb__before_atomic();
> 
> So the above barrier orders atomic_read(&shost->host_blocked) and
> test_bit()?

Yes, I believe the change to SCMD_STATE_INFLIGHT should be visible
before host_blocked is tested. For that, I would need to insert a full
smb_mb() instead of smp_mb_after_atomic() below, though ...
right? Which means that the smp_mb__before_atomic() above could be
removed. The important thing is that if two threads execute
scsi_host_queue_ready() simultaneously, one of them must see the
SCMD_STATE_INFLIGHT bit of the other.

Btw, I realized that calling scsi_host_busy() in
scsi_host_queue_ready() is inefficient, because all we need to know
there is whether the value is > 1; we don't need to iterate through the
entire tag space.

Thanks,
Martin

> 
> >         if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
> >                 (*count)++;
> >  
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index b3f14f05340a..0a9a36c349ee 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1353,8 +1353,12 @@ static inline int
> > scsi_host_queue_ready(struct request_queue *q,
> >         if (scsi_host_in_recovery(shost))
> >                 return 0;
> >  
> > +       set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> > +       /* This pairs with test_bit() in
> > scsi_host_check_in_flight() */
> > +       smp_mb__after_atomic();
> > +
> >         if (atomic_read(&shost->host_blocked) > 0) {
> > -               if (scsi_host_busy(shost) > 0)
> > +               if (scsi_host_busy(shost) > 1)
> >                         goto starved;
> >  
> >                 /*
> > @@ -1379,8 +1383,6 @@ static inline int
> > scsi_host_queue_ready(struct request_queue *q,
> >                 spin_unlock_irq(shost->host_lock);
> >         }
> >  
> > -       __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> > -
> 
> Looks this patch fine.
> 
> However, I'd suggest to confirm smartpqi's .can_queue usage first,
> which
> looks one big issue.



> 


