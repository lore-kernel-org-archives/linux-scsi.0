From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Thu, 13 Sep 2012 09:26:59 +0200
Message-ID: <50518AC3.2070009@acm.org>
References: <5044BAD2.7060901@acm.org> <91D94272-CA62-4E68-87D7-CE77DE776CC9@cs.wisc.edu> <5048E45E.1070302@acm.org> <5048E80B.5010101@cs.wisc.edu> <5048F0D9.6080403@acm.org> <20120906232031.GU29092@google.com> <50499AC6.1050008@acm.org> <20120910233843.GI7677@google.com> <504EDD54.9000408@acm.org> <20120912205338.GV7677@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [178.239.52.149] ([178.239.52.149]:56951 "EHLO wimaserver10.be"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750980Ab2IMHqX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Sep 2012 03:46:23 -0400
In-Reply-To: <20120912205338.GV7677@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On 09/12/12 22:53, Tejun Heo wrote:
> The problem at hand IIUC is ->request_fn() being invoked when
> request_queue itself is alive but the underlying driver is gone.  We
> already make sure that a new request is not queued once drain is
> complete but there's no guarantee about calling into ->request_fn()
> and this is what you want to fix, right?

Actually it's a slightly different issue that I want to address, namely
that with the current implementation of the block layer and the SCSI
core it's possible that blk_cleanup_queue() finishes after
scsi_request_fn() has unlocked the queue lock and before it obtains the
queue lock again.

The reason I'm proposing to add a counter in the block layer and not in
the SCSI core is because I think it would be useful for other
request-based block drivers too to be able to unlock the queue inside
their ->request_fn(). That would allow to reduce lock contention on the
request_queue lock for low-latency block drivers.

Bart.
