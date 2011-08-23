From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41552] Performance of writing and reading from multiple drives
 decreases by 40% when going from Linux Kernel 2.6.36.4 to 2.6.37 (and beyond)
Date: Tue, 23 Aug 2011 14:38:55 GMT
Message-ID: <201108231438.p7NEctlj014043@demeter1.kernel.org>
References: <bug-41552-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:47100 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1HWOiz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2011 10:38:55 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p7NEct0J014044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2011 14:38:55 GMT
In-Reply-To: <bug-41552-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=41552





--- Comment #10 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2011-08-23 14:38:52 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Mon, 2011-08-22 at 21:07 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> We were using the default CFQ scheduler.  I will change it to deadline and see
> what happens.  Also, we are not using a file system to perform the writes,
> rather we are sending SCSI commands directly to the devices, nor are we doing
> anything special to the disks with a device mapper.  We simply write to each
> one on a different thread one sector at a time.
> 
> I will attempt to get the trace and will add it if I can.

If you're just using a SG_IO type scsi command, then virtually nothing
we've done in block/scsi should affect this; certainly not the elevators
since we don't do merging on SG_IO, we just use them for queueing.
Since you say "write to each one on a different thread", it's possible
that some scheduler change may have impacted this.

James

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
