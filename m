From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix a use-after-free triggered by device removal
Date: Thu, 13 Sep 2012 12:25:10 -0700
Message-ID: <20120913192510.GJ7677@google.com>
References: <5048E80B.5010101@cs.wisc.edu>
 <5048F0D9.6080403@acm.org>
 <20120906232031.GU29092@google.com>
 <50499AC6.1050008@acm.org>
 <20120910233843.GI7677@google.com>
 <504EDD54.9000408@acm.org>
 <20120912205338.GV7677@google.com>
 <50518AC3.2070009@acm.org>
 <20120913165340.GX7677@google.com>
 <50522591.5000900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49890 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2IMTZP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2012 15:25:15 -0400
Received: by pbbrr13 with SMTP id rr13so4450256pbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 13 Sep 2012 12:25:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <50522591.5000900@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello,

On Thu, Sep 13, 2012 at 08:27:29PM +0200, Bart Van Assche wrote:
> If I do not receive further feedback I'll start testing the patch below
> (on top of the patch at the start of this thread):

Yeah, it generally seems fine to me.  This makes Chanho's patch
unnecessary, right?  Just some minor points.

> @@ -456,6 +456,7 @@ struct request_queue {
>  #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
>  #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
>  #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
> +#define QUEUE_FLAG_DRAINED     19	/* queue tear-down finished */

This is rather confusing to me.  Maybe we can have QUEUE_FLAG_DYING
and QUEUE_FLAG_DEAD?  Or at least explain the involve state changes in
detail.

Thanks.

-- 
tejun
