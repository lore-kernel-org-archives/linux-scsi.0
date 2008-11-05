From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue,  4 Nov 2008 20:01:54 -0800 (PST)
Message-ID: <20081105040154.9690A108048@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707AbYKEEB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 23:01:57 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA541sEW011981
	for <linux-scsi@vger.kernel.org>; Tue, 4 Nov 2008 20:01:55 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #15 from alex.shi@intel.com  2008-11-04 20:01 -------
the fix is right. and "sdev == starved_head" does not need according code
context. so the following patch works too.

--- scsi_lib.c.orig     2008-11-04 13:07:16.000000000 -0800
+++ scsi_lib.c  2008-11-04 13:07:38.000000000 -0800
@@ -607,6 +607,8 @@
                spin_unlock(sdev->request_queue->queue_lock);

                spin_lock(shost->host_lock);
+               if (list_empty(&sdev->starved_entry) ) 
+                       starved_head = NULL; 
        }
        spin_unlock_irqrestore(shost->host_lock, flags);



-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
