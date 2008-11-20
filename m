From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Thu, 20 Nov 2008 11:36:33 -0800
Message-ID: <20081120193633.GB28370@linux.vnet.ibm.com>
References: <bug-12020-11613@http.bugzilla.kernel.org/> <20081120151224.EB880108042@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50931 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbYKTTgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2008 14:36:35 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAKJZvZN025314
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2008 12:35:57 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAKJaYeW079370
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2008 12:36:34 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAKJaXAj006077
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2008 12:36:34 -0700
Content-Disposition: inline
In-Reply-To: <20081120151224.EB880108042@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>

I have two systems that are hitting similar signatures in scsi_times_out.

Note: that my testing is using a distro kernel, but in this area the code
is very similar. I will work to get a reproduction on mainline.

..but..

I added some debug to scsi_times_out and noticed that the request with no
scmd set in req->special also did not have REQ_STARTED set.

I added a WARN_ON check to blk_add_timer for any requests 
that we where starting a timer for that did not have REQ_STARTED. This is
shown below. This does not look good as the elv_dequeue_request is being
called off elv_next_request for some cases.

Call Trace:
[c00000007b747580] [c00000000027808c] .blk_add_timer+0x74/0x134
(unreliable)
[c00000007b747610] [c00000000026f9b8] .elv_dequeue_request+0x78/0x8c
[c00000007b747680] [c000000000275830] .blk_do_ordered+0x8c/0x31c
[c00000007b747720] [c00000000026fc18] .elv_next_request+0x24c/0x2d4
[c00000007b7477c0] [d000000000368004] .scsi_request_fn+0xc8/0x628
[scsi_mod]
[c00000007b7478a0] [c00000000026fdf4] .elv_insert+0x154/0x38c
[c00000007b747940] [c000000000273ad0] .__make_request+0x4e4/0x568
[c00000007b7479f0] [c000000000271a68] .generic_make_request+0x3f4/0x468
[c00000007b747af0] [c000000000271bd8] .submit_bio+0xfc/0x124
[c00000007b747bb0] [c000000000160a00] .submit_bh+0x14c/0x198
[c00000007b747c40] [c0000000001630a0] .sync_dirty_buffer+0xbc/0x15c
[c00000007b747cd0] [c0000000001fcac0]
.journal_commit_transaction+0x1014/0x158c
[c00000007b747e10] [c00000000020111c] .kjournald+0x104/0x2f4
[c00000007b747f00] [c0000000000a909c] .kthread+0x78/0xc4
[c00000007b747f90] [c00000000002ae2c] .kernel_thread+0x4c/0x68

I changed the previous mentioned WARN_ON to just do a return if the request
does not have REQ_STARTED. This corrected the issue of seeing an oops in
scsi_times_out. But this is just a hack.

Hope this analysis is not flawed because of kernel deltas. It also may not
address this specific issue being seen in this bug, but does appear to
indicate a possible path to get a request on the timeout list with out a
req->special set.

I think we may need to look at some of the paths that are calling
blkdev_dequeue_request and understand how to prevent blk_add_timer from
being called if we are not really starting a SCSI cmd.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
