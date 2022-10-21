Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA39C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Oct 2022 15:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiJUPW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 11:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiJUPW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 11:22:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FA4278163
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 08:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666365773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rNUtD0qOkGMlGUgfA5NfPqgJZTck3/7w6b9qm8JJosE=;
        b=h6Cj26yqODbDboJvSBgqdbjaaJFLv8gblB+y6gBg7mHjRIelId0smLkEzS8aSpIKenodxx
        3DRbfYjzI3hfexZhVhtjHta3tCR+Aj7Gfgv+WB2Dbl8dMas95eUzBPzvYwAxcRyvBGUjze
        J3cj/WiHdqKq0ycpW1xTQIvDtO3shas=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-1BqXFHcOPbm4uh747QbAzg-1; Fri, 21 Oct 2022 11:22:47 -0400
X-MC-Unique: 1BqXFHcOPbm4uh747QbAzg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E03D92823821;
        Fri, 21 Oct 2022 15:22:45 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27AEE401E5C;
        Fri, 21 Oct 2022 15:22:39 +0000 (UTC)
Date:   Fri, 21 Oct 2022 23:22:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>, djeffery@redhat.com,
        stefanha@redhat.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Bug] double ->queue_rq() because of timeout in ->queue_rq()
Message-ID: <Y1K5Oo7bIRlVTDnb@T590>
References: <Y1EQdafQlKNAsutk@T590>
 <Y1Ktf2jRTlPMQwJR@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1Ktf2jRTlPMQwJR@kbusch-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 21, 2022 at 08:32:31AM -0600, Keith Busch wrote:
> On Thu, Oct 20, 2022 at 05:10:13PM +0800, Ming Lei wrote:
> > @@ -1593,10 +1598,17 @@ static void blk_mq_timeout_work(struct work_struct *work)
> >  	if (!percpu_ref_tryget(&q->q_usage_counter))
> >  		return;
> >  
> > -	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &next);
> > +	/* Before walking tags, we must ensure any submit started before the
> > +	 * current time has finished. Since the submit uses srcu or rcu, wait
> > +	 * for a synchronization point to ensure all running submits have
> > +	 * finished
> > +	 */
> > +	blk_mq_wait_quiesce_done(q);
> > +
> > +	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &expired);
> 
> The blk_mq_wait_quiesce_done() will only wait for tasks that entered
> just before calling that function. It will not wait for tasks that
> entered immediately after.

Yeah, but the patch records the jiffies before calling
blk_mq_wait_quiesce_done, and only time out requests which are timed out
before the recorded time, so it is fine to use blk_mq_wait_quiesce_done
in this way.

> 
> If I correctly understand the problem you're describing, the hypervisor
> may prevent any guest process from running. If so, the timeout work may
> be stalled after the quiesce, and if a queue_rq() process also stalled
> after starting quiesce_done(), then we're in the same situation you're
> trying to prevent, right?

No, the stall just happens on one vCPU, and other vCPUs may run smoothly.

1) vmexit, which only stalls one vCPU, some vmexit could come anytime,
such as external interrupt

2) vCPU is emulated by pthread usually, and the pthread is just one
normal host userspace pthread, which can be preempted anytime, and
the preempt latency could be long enough when the system load is
heavy.

And it is like random stall added when running any instruction of
VM kernel code.

> 
> I agree with your idea that this is a lower level driver responsibility:
> it should reclaim all started requests before allowing new queuing.
> Perhaps the block layer should also raise a clear warning if it's
> queueing a request that's already started.

The thing is that it is one generic issue, lots of VM drivers could be
affected, and it may not be easy for drivers to handle the race too.



Thanks,
Ming

