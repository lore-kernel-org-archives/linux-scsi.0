From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15007] New: SCSI host adapter's scatter-gather list size Issue
Date: Fri, 8 Jan 2010 11:07:49 GMT
Message-ID: <bug-15007-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34391 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0AHLH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2010 06:07:56 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o08B7pPi027348
	for <linux-scsi@vger.kernel.org>; Fri, 8 Jan 2010 11:07:53 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15007

           Summary: SCSI host adapter's scatter-gather list size Issue
           Product: IO/Storage
           Version: 2.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: nick.cheng@areca.com.tw
                CC: akpm@linux-foundation.org
        Regression: No


I found if I set scatter-gather table size as 1024 Areca's RAID controller,
ARC1680, and then execute "mkfs.ext3 /dev/sdX" on a sas/sata volume which is
formated as NTFS, it will kill the controller and let it restart.
This issue pops up easily on Intel server board with multi-processors and so
far can not be reproduced on a volume with a original Linux filesystem such as,
ext3.
I also found the issue is on the write command with 128 sg entries, each with
4K byte in length. As the command comes from the upper layer, it lacks data in
the 128th sg entry.
I exits from 2.6.18 to 2.6.32.
I try to track kernel source code but so far there is no finding.
The driver is
ftp://ftp.areca.com.tw/RaidCards/AP_Drivers/Linux/DRIVER/SourceCode/arcmsr.1.20.0X.15-90605.zip.
Anybody can give it a try??
Thanks,

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
