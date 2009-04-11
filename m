From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Sat, 11 Apr 2009 14:26:01 GMT
Message-ID: <200904111426.n3BEQ1bl032734@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37057 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbZDKO0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2009 10:26:06 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3BEQ1No032735
	for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2009 14:26:01 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





--- Comment #32 from Alan Stern <stern@rowland.harvard.edu>  2009-04-11 14:26:00 ---
> Yes, SCSI uses the (Linux) block layer and the attributes do exist within 
> the kernel. They just are not visible in sysfs for character devices. Last 
> night I read the code to find out why. Your analysis is correct but it 
> only shows that the kobject exists. The kobject is added to sysfs using 
> kobject_add() in blk_register_queue() called by add_disk(), which is only 
> called by disk drivers.

You are right.

And this makes me feel better -- I had thought that usb-storage's 
max_sectors attribute was redundant.  Now I know that for some 
SCSI-over-USB devices, the information is not accessible anywhere else.

> Whether character devices should add the kobject somewhere in sysfs is 
> getting beyond the original topic in this bugzilla entry. This is a more 
> general problem because there is no /sys/char directory. My current 
> opinion is that it would be nice to see these attributes somewhere, but 
> probably not worth the trouble.

Until somebody asks for them, we're okay.  However it shouldn't be very
hard to write a function like blk_register_queue() that accepts a
non-disk device as parent.  (And likewise for blk_unregister_queue, of
course.)

Alan Stern

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
