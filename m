From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 8213] Race: a lock is expected before calling
 BusLogic_WriteOutgoingMailbox, but it is not held in some case and it is held
 in other cases
Date: Sat, 29 Aug 2009 15:53:59 GMT
Message-ID: <200908291553.n7TFrx3E009145@demeter.kernel.org>
References: <bug-8213-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48544 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZH2Px4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Aug 2009 11:53:56 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7TFrxDd009146
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2009 15:53:59 GMT
In-Reply-To: <bug-8213-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=8213


Lin Tan <tammy000@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|2.6.20.1                    |2.6.30.5
         Regression|---                         |No




--- Comment #3 from Lin Tan <tammy000@gmail.com>  2009-08-29 15:53:57 ---
Thanks, Roland.

I checked the latest version (2.6.30.5) on the Linux cross reference, and the
problem still applies. 

Actually, I found that the host_lock is explicitly released before calling
scsi_dispatch_cmd(). See below.

1474 static void scsi_request_fn(struct request_queue *q)
1475 { 
...
1563                 spin_unlock_irq(shost->host_lock);
1564
1565                /*
1566                 * Finally, initialize any error handling parameters, and
set up
1567                 * the timers for timeouts.
1568                 */
1569                scsi_init_cmd_errh(cmd);
1570
1571                /*
1572                 * Dispatch the command to the low-level driver.
1573                 */
1574                rtn = scsi_dispatch_cmd(cmd);
1575           
...

BTW, one clarification, BusLogic_WriteOutgoingMailbox was called twice in
BusLogic_QueueCommand. The first one is what I meant in the original report. It
is NOT called with the host lock held. The second invocation is fine.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
