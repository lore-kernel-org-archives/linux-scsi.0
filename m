From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] 3w-{9,x}xxx don't work on big-endian MIPS
Date: Sun, 19 Dec 2010 18:04:36 GMT
Message-ID: <201012191804.oBJI4aL7008316@demeter2.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:45316 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0LSSEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Dec 2010 13:04:37 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBJI4aDj008338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 19 Dec 2010 18:04:36 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192





--- Comment #7 from ralf@linux-mips.org  2010-12-19 18:04:31 ---
64-bit PCI slots on the Sibyte evaluation boards are implemented using a
Hypertransport-to-PCI bridge.  Hypertransport however uses a separate port
address space from the native 32-bit PCI slots that port x on 32-bit PCI is
different from port x on the Hypertransport.  Memory mapped I/O is not affected
by the issue.

The in/out functions don't know which of the busses / port address spaces
they're operating on so they're always using the first bus that is the 32-bit
PCI bus.  Note that the new style API with iomap() / ioreadX() / iowriteX() is
not affected by this problem.

Would that explain the bug?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
