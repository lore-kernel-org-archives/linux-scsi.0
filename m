From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Mon,  3 Nov 2008 23:37:01 -0800 (PST)
Message-ID: <20081104073701.628FB108047@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbYKDHhl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 02:37:41 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA47b1u1002672
	for <linux-scsi@vger.kernel.org>; Mon, 3 Nov 2008 23:37:02 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #6 from yanmin_zhang@linux.intel.com  2008-11-03 23:37 -------
The hang palce is spin_lock_irq(q->queue_lock) in function scsi_request_fn:

 not_ready:
        spin_unlock_irq(shost->host_lock);

        /*
         * lock q, handle tag, requeue req, and decrement device_busy. We
         * must return with queue_lock held.
         *
         * Decrementing device_busy without checking it is OK, as all such
         * cases (host limits or settings) should run the queue at some
         * later time.
         */
======>        spin_lock_irq(q->queue_lock);
        blk_requeue_request(q, req);
        sdev->device_busy--;
        if(sdev->device_busy == 0)
                blk_plug_device(q);


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
