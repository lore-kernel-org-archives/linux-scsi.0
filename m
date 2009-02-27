From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Fri, 27 Feb 2009 02:28:41 -0800 (PST)
Message-ID: <20090227102841.45126108043@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758225AbZB0K2o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 05:28:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1RASfbM019469
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2009 02:28:42 -0800
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #20 from seokmann.ju@qlogic.com  2009-02-27 02:28 -------
>From the log from #19, the multipathd caused recursive
interventions/interruptions to the target so that no more stable path to it is
available.
---
Feb 26 23:50:42 fred multipathd: sdh: directio checker reports path is down
Feb 26 23:50:42 fred multipathd: checker failed path 8:112 in map multi_3_db
Feb 26 23:50:42 fred multipathd: multi_3_db: remaining active paths: 1
Feb 26 23:50:42 fred kernel: [14020652.739423] device-mapper: multipath:
Failing path 8:112.
Feb 26 23:50:42 fred multipathd: sdj: directio checker reports path is down
Feb 26 23:50:42 fred multipathd: checker failed path 8:144 in map mpath7
Feb 26 23:50:42 fred multipathd: mpath7: remaining active paths: 0
---


And it, in turn, caused to trigger timout event followed by aborting commands,
as below.
---
Feb 26 23:50:41 fred kernel: [14020651.786979] qla2xxx_eh_abort(3): aborting sp
ffff81003c1360c0 from RISC. pid=334462.
Feb 26 23:50:41 fred kernel: [14020651.787849] scsi(3): ABORT status detected
0x5-0x0.
Feb 26 23:50:41 fred kernel: [14020651.788110] qla2xxx 0000:08:01.0:
scsi(3:0:3): Abort command issued -- 1 51a7e 2002.
Feb 26 23:50:41 fred kernel: [14020651.847108] qla2xxx_eh_abort(3): aborting sp
ffff81003c136dc0 from RISC. pid=334463.
Feb 26 23:50:41 fred kernel: [14020651.847973] scsi(3): ABORT status detected
0x5-0x0.
Feb 26 23:50:41 fred kernel: [14020651.848242] qla2xxx 0000:08:01.0:
scsi(3:0:9): Abort command issued -- 1 51a7f 2002.
---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
