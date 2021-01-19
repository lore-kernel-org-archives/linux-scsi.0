Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8400C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 23:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D63522DD3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 23:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbhASXei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 18:34:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:58372 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395297AbhASONc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 09:13:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611065564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/fmwjCE7PKfVMK4jAVDbqI8JqCx2zIE0oHsnCHO+Zsc=;
        b=oilN6tMTXOvyF9Dl/uELpsnNLCnU3H975oSFm9Ye7TeJYfWgBuCJ+TlayTI/mqFJ8XTh76
        OOvWvFsXV5izz8GmTyqo5uPKG8Qx6ZO6/scbuIrrM30k4gaEi36xN9pUOTFZl+SXbPOP3K
        suz8ze2BHTHvv0Cp2K1uY1C2UnItoyA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 77BCDAB9F;
        Tue, 19 Jan 2021 14:12:44 +0000 (UTC)
Message-ID: <4555695d649afada5d4358485f0a146aa0848f65.camel@suse.com>
Subject: Re: [PATCH V3 15/25] smartpqi: fix host qdepth limit
From:   Martin Wilck <mwilck@suse.com>
To:     John Garry <john.garry@huawei.com>, Don.Brace@microchip.com,
        pmenzel@molgen.mpg.de, Kevin.Barnett@microchip.com,
        Scott.Teel@microchip.com, Justin.Lindley@microchip.com,
        Scott.Benesh@microchip.com, Gerry.Morong@microchip.com,
        Mahesh.Rajashekhara@microchip.com, hch@infradead.org,
        joseph.szczypek@hpe.com, POSWALD@suse.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Paul Menzel <pmenzel@molgen.mpg.de>,
        Ming Lei <ming.lei@redhat.com>
Cc:     linux-scsi@vger.kernel.org, it+linux-scsi@molgen.mpg.de,
        buczek@molgen.mpg.de, gregkh@linuxfoundation.org
Date:   Tue, 19 Jan 2021 15:12:43 +0100
In-Reply-To: <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763254769.26927.9249430312259308888.stgit@brunhilda>
         <ddd8bca4-2ae7-a2dc-cca6-0a2ff85a7d35@molgen.mpg.de>
         <SN6PR11MB28487527276CEBC75D36A732E1C60@SN6PR11MB2848.namprd11.prod.outlook.com>
         <85c6e1705c55fb930ac13bc939279f0d1faa526f.camel@suse.com>
         <SN6PR11MB2848C1195C65F87C910E979BE1A70@SN6PR11MB2848.namprd11.prod.outlook.com>
         <b3e4e597-779b-7c1e-0d3c-07bc3dab1bb5@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-19 at 10:33 +0000, John Garry wrote:
> > > 
> > > Am 10.12.20 um 21:35 schrieb Don Brace:
> > > > From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> > > > 
> > > > * Correct scsi-mid-layer sending more requests than
> > > >     exposed host Q depth causing firmware ASSERT issue.
> > > >     * Add host Qdepth counter.
> > > 
> > > This supposedly fixes the regression between Linux 5.4 and 5.9,
> > > which
> > > we reported in [1].
> > > 
> > >       kernel: smartpqi 0000:89:00.0: controller is offline:
> > > status code
> > > 0x6100c
> > >       kernel: smartpqi 0000:89:00.0: controller offline
> > > 
> > > Thank you for looking into this issue and fixing it. We are going
> > > to
> > > test this.
> > > 
> > > For easily finding these things in the git history or the WWW, it
> > > would be great if these log messages could be included (in the
> > > future).
> > > DON> Thanks for your suggestion. Well add them in the next time.
> > > 
> > > Also, that means, that the regression is still present in Linux
> > > 5.10,
> > > released yesterday, and this commit does not apply to these
> > > versions.
> > > 
> > > DON> They have started 5.10-RC7 now. So possibly 5.11 or 5.12
> > > depending when all of the patches are applied. The patch in
> > > question
> > > is among 28 other patches.
> > > 
> > > Mahesh, do you have any idea, what commit caused the regression
> > > and
> > > why the issue started to show up?
> > > DON> The smartpqi driver sets two scsi_host_template member
> > > fields:
> > > .can_queue and .nr_hw_queues. But we have not yet converted to
> > > host_tagset. So the queue_depth becomes nr_hw_queues * can_queue,
> > > which is more than the hw can support. That can be verified by
> > > looking
> > > at scsi_host.h.
> > >          /*
> > >           * In scsi-mq mode, the number of hardware queues
> > > supported by
> > > the LLD.
> > >           *
> > >           * Note: it is assumed that each hardware queue has a
> > > queue
> > > depth of
> > >           * can_queue. In other words, the total queue depth per
> > > host
> > >           * is nr_hw_queues * can_queue. However, for when
> > > host_tagset
> > > is set,
> > >           * the total queue depth is can_queue.
> > >           */
> > > 
> > > So, until we make this change, the queue_depth change prevents
> > > the
> > > above issue from happening.
> > 
> > can_queue and nr_hw_queues have been set like this as long as the
> > driver existed. Why did Paul observe a regression with 5.9?
> > 
> > And why can't you simply set can_queue to (ctrl_info-
> > >scsi_ml_can_queue / nr_hw_queues)?
> > 
> > Don: I did this in an internal patch, but this patch seemed to work
> > the best for our driver. HBA performance remained steady when
> > running benchmarks.

That was a stupid suggestion on my part. Sorry.

> I guess that this is a fallout from commit 6eb045e092ef ("scsi:
>   core: avoid host-wide host_busy counter for scsi_mq"). But that
> commit 
> is correct.

It would be good if someone (Paul?) could verify whether that commit
actually caused the regression they saw.

Looking at that 6eb045e092ef, I notice this hunk:

 
-       busy = atomic_inc_return(&shost->host_busy) - 1;
        if (atomic_read(&shost->host_blocked) > 0) {
-               if (busy)
+               if (scsi_host_busy(shost) > 0)
                        goto starved;

Before 6eb045e092ef, the busy count was incremented with membarrier
before looking at "host_blocked". The new code does this instead:

@ -1403,6 +1400,8 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
                spin_unlock_irq(shost->host_lock);
        }
 
+       __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
+

but it happens *after* the "host_blocked" check. Could that perhaps
have caused the regression?

Thanks
Martin

