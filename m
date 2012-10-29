From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/7] block: Avoid that blk_drain_queue() finishes early
Date: Sun, 28 Oct 2012 18:47:22 -0700
Message-ID: <20121029014722.GC5171@htj.dyndns.org>
References: <508A7B63.60608@acm.org>
 <508A7B93.4090409@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62197 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2J2Br0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Oct 2012 21:47:26 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3903648pbb.19
        for <linux-scsi@vger.kernel.org>; Sun, 28 Oct 2012 18:47:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <508A7B93.4090409@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello,

On Fri, Oct 26, 2012 at 02:01:23PM +0200, Bart Van Assche wrote:
> Code like "drain |= q->nr_rqs[i]" might result in blk_drain_queue()
> to finish early if the expression at the RHS is a multiple of 256
> since the drain variable is only eight bits wide. Avoid this by
> changing the type of the drain variable from bool into unsigned.

No, it doesn't happen that way.  One of the reasons we have bool at
all is to avoid this type of problems caused by implicit type-casting.

Why do you keep pushing this?  It's WRONG.  Please drop it.

Thanks.

-- 
tejun
