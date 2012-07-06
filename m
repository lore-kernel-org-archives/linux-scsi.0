From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v5 3/4] block: implement runtime pm strategy
Date: Fri, 6 Jul 2012 01:27:52 -0600
Message-ID: <20120706072752.GD17681@parisc-linux.org>
References: <1341547472-6863-1-git-send-email-ming.m.lin@intel.com> <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55245 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab2GFHfy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jul 2012 03:35:54 -0400
Content-Disposition: inline
In-Reply-To: <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Jul 06, 2012 at 12:04:31PM +0800, Lin Ming wrote:
> When a request is added:
>     If device is suspended or is suspending and the request is not a
>     PM request, resume the device.
> 
> When a request finishes:
>     Call pm_runtime_mark_last_busy().
> 
> When pick a request:
>     If device is resuming/suspending, then only PM request is allowed to go.
>     Return NULL for other cases.

This only works for drivers which are struct request based.  For those
that handle struct bio directly, nr_pending will always be 0.

I think the right place to increment nr_pending is in generic_make_request.
But I'm not sure where to decrement it.  I think we need a blk_bio_endio()
which does some housekeeping and then calls bio_endio().

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
