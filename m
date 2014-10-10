From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Fri, 10 Oct 2014 22:00:12 +0000
Message-ID: <bug-85151-11613-oWP3K9UUT3@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43904 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbaJJWAQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2014 18:00:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 26B6820204
	for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2014 22:00:15 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9DCD020212
	for <linux-scsi@vger.kernel.org>; Fri, 10 Oct 2014 22:00:12 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #13 from linux-ide@crashplan.pro ---
Note: having 2 pieces of the HP SAS expander connected at the same time, one to
each port of the Adaptec 7805H, results in a kernel oops:

   35.475138] sas: DONE DISCOVERY on port 7, pid:137, result:-70
[   35.477301] scsi 4:0:0:0: Enclosure         HP       HP SAS EXP Card  2.10
PQ: 0 ANSI: 5
[   35.479756] scsi 4:0:0:0: Attached scsi generic sg1 type 13
[   35.490335] ses 4:0:0:0: Attached Enclosure device
[   35.525143] BUG: unable to handle kernel NULL pointer dereference at
0000000000000290
[   35.525889] IP: [<ffffffffc05c9f44>] pm8001_dev_gone_notify+0x24/0x210
[pm80xx]
[   35.526618] PGD 0
[   35.527324] Oops: 0000 [#1] SMP
...
[   35.530609] CPU: 0 PID: 36 Comm: kworker/0:1 Tainted: G           OE 
3.17.0-031700rc7-generic #201409281835

And with the later mainline kernel:
[  153.518720] sas: DONE DISCOVERY on port 7, pid:127, result:-70
[  153.521380] scsi 4:0:0:0: Enclosure         HP       HP SAS EXP Card  2.10
PQ: 0 ANSI: 5
[  153.526442] scsi 4:0:0:0: Attached scsi generic sg1 type 13
[  153.539380] ses 4:0:0:0: Attached Enclosure device
[  153.551072] general protection fault: 0000 [#1] SMP
...
[  153.555559] CPU: 0 PID: 36 Comm: kworker/0:1 Tainted: G           OE 
3.17.0-999-generic #201409282205

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
