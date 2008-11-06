From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Wed,  5 Nov 2008 17:59:12 -0800 (PST)
Message-ID: <20081106015912.1FCA111D10A@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbYKFB7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 20:59:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA61xCUQ028562
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 17:59:13 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #23 from yanmin_zhang@linux.intel.com  2008-11-05 17:59 -------
Let me clarify the scenario again why my machine hangs with pure
2.6.28-rc[123].

In function scsi_run_queue, before enter the while loop, there are 2 sdev on
shost->starved_list.
1) When scsi_run_queue checks the first sdev, scsi_run_queue is set to point to
the first sdev.
2) scsi_run_queue => __blk_run_queue ... =>scsi_request_fn to succeed in
processing the first sdev.
3) scsi_run_queue goes to next loop in while to pick up the second sdev. the
2nd sdev is deleted from starved_list;
4) scsi_run_queue => __blk_run_queue ... =>scsi_request_fn to succeed in
processing the 2nd sdev. Unfortunately, in function scsi_request_fn,
"if (blk_queue_tagged(q) && !blk_rq_tagged(req))" is true this time, so the 2nd
sdev is added back to starved_list. See below codes:

                if (blk_queue_tagged(q) && !blk_rq_tagged(req)) {
                        if (list_empty(&sdev->starved_entry))
========>                      list_add_tail(&sdev->starved_entry,
                                              &shost->starved_list);
                        goto not_ready;
                }

5) scsi_run_queue goes to next loop in while to repeat step from 3) to 5). So
it enters a dead loop.

James' patch doesn't break the dead loop, and even couldn't break it when
starved_list just has a sdev initially.

So the checking should be in the tail of the while loop.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
