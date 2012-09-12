From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Wed, 12 Sep 2012 13:53:38 -0700
Message-ID: <20120912205338.GV7677@google.com>
References: <5044BAD2.7060901@acm.org>
 <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu>
 <5048E45E.1070302@acm.org>
 <5048E80B.5010101@cs.wisc.edu>
 <5048F0D9.6080403@acm.org>
 <20120906232031.GU29092@google.com>
 <50499AC6.1050008@acm.org>
 <20120910233843.GI7677@google.com>
 <504EDD54.9000408@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44097 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab2ILUxn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Sep 2012 16:53:43 -0400
Received: by dady13 with SMTP id y13so1220987dad.19
        for <linux-scsi@vger.kernel.org>; Wed, 12 Sep 2012 13:53:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <504EDD54.9000408@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello,

On Tue, Sep 11, 2012 at 08:42:28AM +0200, Bart Van Assche wrote:
> Good question. As far as I can see calling request_queue.request_fn() is
> fine as long as the caller holds a reference on the queue. If e.g.
> scsi_request_fn() would get invoked after blk_drain_queue() finished it
> will return immediately because it was invoked with an empty request
> queue. So we should be fine as long as all blk_run_queue() callers
> either hold a reference on the request queue itself or on the sdev that
> owns the request queue. As far as I can see if patch
> http://marc.info/?l=linux-scsi&m=134453905402413 gets accepted then all
> callers in the SCSI core of blk_run_queue() will hold a (direct or
> indirect) reference on the request_queue before invoking blk_run_queue()
> or __blk_run_queue().

It's been quite a while since I really looked through the code and I'm
feeling a bit dense but what you describe seems like a two-pronged
approach where the drain stalling, when properly done, should be
enough.

The problem at hand IIUC is ->request_fn() being invoked when
request_queue itself is alive but the underlying driver is gone.  We
already make sure that a new request is not queued once drain is
complete but there's no guarantee about calling into ->request_fn()
and this is what you want to fix, right?

I think this is something which the block layer proper should handle
correctly and expose sane interface.  ie. if the caller has
request_queue reference, it should be safe to call __blk_run_queue()
no matter what.  As long as SCSI follows proper shutdown procedure, it
shouldn't need to worry about this.

Am I hopelessly confused somewhere?

Thanks.

-- 
tejun
