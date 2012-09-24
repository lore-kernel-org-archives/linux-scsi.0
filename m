From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] Make blk_cleanup_queue() wait until request_fn
 finished
Date: Mon, 24 Sep 2012 12:32:57 -0700
Message-ID: <20120924193257.GB29689@google.com>
References: <505F35C9.6070509@acm.org>
 <505F36BD.9020006@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab2IXTdC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2012 15:33:02 -0400
Received: by pbbrr4 with SMTP id rr4so7710332pbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2012 12:33:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <505F36BD.9020006@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Chanho Min <chanho.min@lge.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, James Bottomley <jbottomley@parallels.com>

Hello, Bart.

On Sun, Sep 23, 2012 at 06:20:13PM +0200, Bart Van Assche wrote:
> Some request_fn implementations, e.g. scsi_request_fn(), unlock
> the queue lock. Make sure that blk_cleanup_queue() waits until all
> active request_fn invocations have finished. This fixes a potential
> use-after-free at the end of scsi_request_fn(). Also, make sure that
> the block layer doesn't invoke request_fn after blk_cleanup_queue()
> finished.

I think the patch is correct but would prefer if the two changes -
request_fn_active and QUEUE_DEAD - are put into separate patches with
more detailed explanation what they're protecting how.

Thanks.

-- 
tejun
