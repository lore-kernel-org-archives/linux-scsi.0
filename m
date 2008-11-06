From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Wed,  5 Nov 2008 18:06:28 -0800 (PST)
Message-ID: <20081106020628.0E2D711D10A@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbYKFCGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 21:06:51 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA626S41029304
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 18:06:29 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #24 from yanmin_zhang@linux.intel.com  2008-11-05 18:06 -------
(In reply to comment #18)
> (In reply to comment #16)
> > Alex,
> > 
> > Your patch is not optimized.
> 
> What do you mean exactly?
> 
Scenario: starved_list consists of 5 sdev. The 1st/2nd/3rd/4th sdev make
"if (blk_queue_tagged(q) && !blk_rq_tagged(req))" true, so they are added back,
but the 5th sdev is ok to be processes and deleted from starved_list. With
Alex's patch, scsi_run_queue will check all the 4 sdev again.

I don't how possible the scenario happens. If it happens very rarely, Alex's
patch is ok. I just speak theoretically.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
