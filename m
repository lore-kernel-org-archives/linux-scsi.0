Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D33C4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF53C613B4
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhFANUp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 09:20:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233064AbhFANUp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 09:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622553543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BwxOizDuWjbnVoxEZcCwNn7NNhf0enkN5rI0mAmfk9Q=;
        b=C8FQh3DZljGVZn9ybe2a/mpoyqacRlTJBzgQf2Dhn1L0SVkCaUyYEPAny0hPS8HRfg7Q1a
        61EizmCNG3haNu7sedcqgFIHG/8c2jaxO8mz5JH454IGMgM1SUHbMhyg5G8BOZ/DeVvxxl
        R74IkF1pigBKd6Buw5MEqHHmHM+QNV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-HhV_8vsqNKmJsa8fSf2AaA-1; Tue, 01 Jun 2021 09:19:02 -0400
X-MC-Unique: HhV_8vsqNKmJsa8fSf2AaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02F368C8882;
        Tue,  1 Jun 2021 13:19:01 +0000 (UTC)
Received: from T590 (ovpn-12-120.pek2.redhat.com [10.72.12.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B64B810074FC;
        Tue,  1 Jun 2021 13:18:54 +0000 (UTC)
Date:   Tue, 1 Jun 2021 21:18:50 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     dgilbert@interlog.com, linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: REQ_HIPRI and SCSI mid-level
Message-ID: <YLYzunA0PPShKxJd@T590>
References: <8c490b4a-aac0-7451-8755-e05bb3ee3d32@interlog.com>
 <7cd246bd-646c-6833-b3a6-a25222bed647@interlog.com>
 <f27b9759-571a-d9d1-ef88-c76fe45dcce4@suse.de>
 <YLBINJeuoDDRrN4Q@T590>
 <fb50a05f-11f5-adb5-308e-769923d8d3ff@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb50a05f-11f5-adb5-308e-769923d8d3ff@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 01, 2021 at 02:19:10PM +0200, Hannes Reinecke wrote:
> On 5/28/21 3:32 AM, Ming Lei wrote:
> > On Thu, May 27, 2021 at 05:43:07PM +0200, Hannes Reinecke wrote:
> >> On 5/25/21 6:03 PM, Douglas Gilbert wrote:
> >>> On 2021-05-21 5:56 p.m., Douglas Gilbert wrote:
> >>>> The REQ_HIPRI flag on requests is associated with blk_poll() (aka iopoll)
> >>>> and assumes the user space (or some higher level) will be calling
> >>>> blk_poll() on requests marked with REQ_HIPRI and that will lead to their
> >>>> completion.
> >>>>
> >>>> In lk 5.13-rc1 the megaraid and scsi_debug LLDs support blk_poll() [seen
> >>>> by searching for 'mq_poll'] with more to follow, I assume. I have tested
> >>>> blk_poll() on the scsi_debug driver using both fio and the new sg driver.
> >>>> It works well with one caveat: as long as there isn't an error.
> >>>> After fighting with that error processing from the ULD side (i.e. the
> >>>> new sg driver) and the LLD side I am concluding that the glue that
> >>>> holds them together, that is, the mid-level is not as REQ_HIPRI aware
> >>>> as it should be.
> >>>>
> >>>> Yes REQ_HIPRI is there in scsi_lib.c but it is missing from scsi_error.c
> >>>> How can scsi_error.c re-issue requests _without_ taking into account
> >>>> that the original was issued with REQ_HIPRI ? Well I don't know but I'm
> >>>> pretty sure that is close to the area that I see causing problems
> >>>> (mainly lockups).
> >>>>
> >>>> As an example the scsi_debug driver has an in-use bitmap that when a new
> >>>> request arrives the code looks for an empty slot. Due to (incorrect)
> >>>> parameter setup that may fail. If the driver returns:
> >>>>      device_qfull_result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
> >>>> then I see lock-ups if the request in question has REQ_HIPRI set.
> >>>>
> >>>> If that is changed to:
> >>>>      device_qfull_result = (DID_ABORT << 16) | SAM_STAT_TASK_SET_FULL;
> >>>> then my user space test program sees that error and aborts showing the
> >>>> TASK SET FULL SCSI status. That is much better than a lockup ...
> >>>>
> >> That's because with the first result the command is requeued (due to
> >> DID_OK), whereas in the latter result the command is aborted (due to
> >> DID_ABORT).
> >>
> >> So the question really is whether we should retry the commands which have
> >> REQ_HIPRI set, or whether we shouldn't rather complete them with appropriate
> >> error code.
> >> A bit like enhanced BLOCK_PC requests, if you will.
> >>
> >>>> Having played around with variants of the above for a few weeks, I'd
> >>>> like to throw this problem into the open :-)
> >>>>
> >>>>
> >>>> Suggestion: perhaps the eh could give up immediately on any request
> >>>> with REQ_HIPRI set (i.e. make it a higher level layer's problem).
> >>
> >> Like I said above: it's not only scsi EH which would need to be modified,
> >> but possibly also the result evaluation in scsi_decide_disposition(); it's
> >> questionable whether a HIPRI command should be requeued at all.
> > 
> > Why can't HIPRI req be requeued?
> > 
> Oh, it can.
> As I said: it's questionable; HIPRI / polled completions are just that,
> polling for completions. And a completion indicating a requeue is
> _still_ a completion.
> So one could argue that we should return here (as it's a completion, and
> we're polling for completion).

No, blk_poll() actually poll for bio's completion instead of request's
completion. If the submitted HIPRI bio isn't completed, the polling won't be
stopped.

> 
> >>
> >> But this might even affect the NVMe folks; they do return commands with
> >> BLK_STS_RESOURCE, too.
> > 
> > Block layer will be responsible for re-queueing BLK_STS_RESOURCE requests,
> > so still not understand why it is one issue for HIPRI req. Also
> > rq->mq_hctx won't be changed since its allocation, blk_poll()
> > will keep polling on the correct hw queue for reaping the IO.
> > 
> As mentioned above, I was talking about completions indicating a requeue.
> Requeues due to resource shortage on the initiator side would of course
> be requeued.

blk_poll() doesn't care request requeue, what matters is that if the HIPRI
bio is completed or not.

So either timeout or EH codes needn't to handle HIPRI IO specially.

Thanks,
Ming

