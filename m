From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] Fix race between starved list processing and
 device removal
Date: Tue, 16 Oct 2012 16:59:14 -0700
Message-ID: <20121016235914.GM16166@google.com>
References: <50758EBE.7050202@acm.org>
 <50758FEB.9090602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64514 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab2JPX7S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2012 19:59:18 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so6491575pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 16 Oct 2012 16:59:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <50758FEB.9090602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello,

On Wed, Oct 10, 2012 at 05:10:35PM +0200, Bart Van Assche wrote:
> Avoid that the sdev reference count can drop to zero before
> the queue is run by scsi_run_queue(). Also avoid that the sdev
> reference count can drop to zero in the same function by invoking
> __blk_run_queue().

I think this is correct but again had to scratch my head quite a bit.
It would be nice to start with brief explanation of starved_list,
especially the way it's processed per-host instead of per-device.  And
then explain how it's broken(how nothing guarantees a device to be
alive while on starved_list) and the fix.

Thanks.

-- 
tejun
