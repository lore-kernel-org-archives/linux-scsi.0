Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1226C38A2D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 21:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiJXVFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 17:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiJXVFX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 17:05:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3CF8FD6F
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 12:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666638606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Hq3UaVSrca8KQT+b+jODzI9hrrxpDiMplEibSWBJ8Y=;
        b=gEp4fINKxgY5dI4Wv7v6m1XQh6znBeIpqE3qfWyZgb5amrQargGLZV1bIsGCEQtL9skpVi
        y60AgN58e/jwu+8ulf1jiJmqEM+tUrQnCvrmggVwzuXalPHPEE8fNR9W3UtVtNWCKFkIKx
        PfrrOnQACXPgt/bb+9W3hhaT404e70U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-ywcSqWJDM5CgVcrATHXbBQ-1; Mon, 24 Oct 2022 11:41:16 -0400
X-MC-Unique: ywcSqWJDM5CgVcrATHXbBQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F27ED86F123;
        Mon, 24 Oct 2022 15:41:15 +0000 (UTC)
Received: from T590 (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E8B7C40C2064;
        Mon, 24 Oct 2022 15:41:10 +0000 (UTC)
Date:   Mon, 24 Oct 2022 23:41:02 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>, djeffery@redhat.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Bug] double ->queue_rq() because of timeout in ->queue_rq()
Message-ID: <Y1ayDrL5Z1JTT5OA@T590>
References: <Y1EQdafQlKNAsutk@T590>
 <Y1GpB6Gpm7GglwO3@fedora>
 <Y1ICvUwglbxkqE+v@T590>
 <Y1avnzv01gevnmXz@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1avnzv01gevnmXz@fedora>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 24, 2022 at 11:30:39AM -0400, Stefan Hajnoczi wrote:
> On Fri, Oct 21, 2022 at 10:23:57AM +0800, Ming Lei wrote:
> > On Thu, Oct 20, 2022 at 04:01:11PM -0400, Stefan Hajnoczi wrote:
> > > On Thu, Oct 20, 2022 at 05:10:13PM +0800, Ming Lei wrote:
> > > > Hi,
> > > > 
> > > > David Jeffery found one double ->queue_rq() issue, so far it can
> > > > be triggered in the following two cases:
> > > > 
> > > > 1) scsi driver in guest kernel
> > > > 
> > > > - the story could be long vmexit latency or long preempt latency of
> > > > vCPU pthread, then IO req is timed out before queuing the request
> > > > to hardware but after calling blk_mq_start_request() during ->queue_rq(),
> > > > then timeout handler handles it by requeue, then double ->queue_rq() is
> > > > caused, and kernel panic
> > > > 
> > > > 2) burst of kernel messages from irq handler 
> > > > 
> > > > For 1), I think it is one reasonable case, given latency from host side
> > > > can come anytime in theory because vCPU is emulated by one normal host
> > > > pthread which can be preempted anywhere. For 2), I guess kernel message is
> > > > supposed to be rate limited.
> > > > 
> > > > Firstly, is this kind of so long(30sec) random latency when running kernel
> > > > code something normal? Or do we need to take care of it? IMO, it looks
> > > > reasonable in case of VM, but our VM experts may have better idea about this
> > > > situation. Also the default 30sec timeout could be reduced via sysfs or
> > > > drivers.
> > > 
> > > 30 seconds is a long latency that does not occur during normal
> > > operation, but unfortunately does happen on occasion.
> > 
> > Thanks for the confirmation!
> > 
> > > 
> > > I think there's an interest in understanding the root cause and solving
> > > long latencies (if possible) in the QEMU/KVM communities. We can
> > > investigate specific cases on kvm@vger.kernel.org and/or
> > > qemu-devel@nongnu.org.
> > 
> > The issue was original reported on VMware VM, but maybe David can figure
> > out how to trigger it on QEMU/KVM.
> 
> A very basic question:
> 
> The virtio_blk driver has no q->mq_ops->timeout() callback. Why does the
> block layer still enable the timeout mechanism when the driver doesn't
> implement ->timeout()?

No matter if ->timeout() is implemented or not, request still may
be timed out, and it is better for block layer to find such issue
and simply reset timer in case of no ->timeout().

> 
> I saw there was some "idle" hctx logic and I guess the requests are

timeout timer is reused for idle hctx detection.

> resubmitted (although it wasn't obvious to me how that happens in the
> code)? Maybe that's why the timer is still used if the driver doesn't
> care about timeouts...

Timeout handling is totally decided by driver's ->timeout() callback.
If driver doesn't implement ->timeout(), the request's timer is
reset.



Thanks
Ming

