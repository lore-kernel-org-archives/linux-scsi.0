From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Fri,  3 Oct 2008 07:42:23 -0700 (PDT)
Message-ID: <20081003144223.26B6C108048@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbYJCOmv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2008 10:42:51 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m93EgNXS013484
	for <linux-scsi@vger.kernel.org>; Fri, 3 Oct 2008 07:42:24 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #9 from seokmann.ju@qlogic.com  2008-10-03 07:42 -------
Yes, please forward the syslog to us.
>From the log in comment #8, the RISC attempted to dump firmware right after the
RISC pause.
The dump image might contain clues explaining what was going on the time spot.
Could you forward the firmware dump to us? 
Here is the steps how to get the dump,
---
When a firmware dump is performed, a message similar to:

       Firmware dump saved to temp buffer (1/adcdabcd)

will be logged by the driver.

To retrieve the dump (do this *BEFORE* you unload the driver and
before the machine is reset), go to a console and type the following:

       $ wget ftp://ftp.qlogic.com/outgoing/linux/beta/8.x/test/qla_dmp.sh
       $ chmod 755 qla_dmp.sh
       $ ./qla_dmp.sh <host_no>

The value passed to qla_dmp.sh should be the same as the first integer
in the 'saved to temp buffer' string (in this example, 1).  If the
operation was successful, a message like to following should be
displayed:

       Firmware dumped to file fw_dump_1_20041217_023222.txt.gz

Send us the file and we can have the firmware folks take a look to see
what's going on.
---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
