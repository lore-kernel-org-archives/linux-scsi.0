From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12020] scsi_times_out NULL pointer dereference
Date: Thu, 20 Nov 2008 11:36:44 -0800 (PST)
Message-ID: <20081120193644.A4F4B108043@picon.linux-foundation.org>
References: <bug-12020-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185AbYKTTgq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2008 14:36:46 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAKJaimk005856
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2008 11:36:45 -0800
In-Reply-To: <bug-12020-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12020





------- Comment #7 from anonymous@kernel-bugs.osdl.org  2008-11-20 11:36 -------
Reply-To: andmike@linux.vnet.ibm.com

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


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
