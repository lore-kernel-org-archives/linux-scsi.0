From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15185] New: Sending a 48bit ATA-Command with "CheckCondition"
 through SG_IO does not return correct 48bit sense descriptor
Date: Sun, 31 Jan 2010 11:30:00 GMT
Message-ID: <bug-15185-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36221 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab0AaLaB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2010 06:30:01 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0VBU0hV015549
	for <linux-scsi@vger.kernel.org>; Sun, 31 Jan 2010 11:30:00 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15185

           Summary: Sending a 48bit ATA-Command with "CheckCondition"
                    through SG_IO does not return correct 48bit sense
                    descriptor
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: stefan.huebner@stud.tu-ilmenau.de
        Regression: No


Example: sending a correct "READ_NATIVE_MAX_ADDRESS_EXT" to /dev/sdd (opened
O_RDWR | O_NONBLOCK) via ATA_PASSTHROUGH_16 (SCSI-Command 0x85) with the EXTEND
and the CHECK_CONDITION bits set to 1 yields sense data in descriptor-format. 
Unfortunately, the descriptor does not have EXTEND set, and by that only
returns 24 Bits of LBA.

This obviously is a bug, as the SAT-2 Draft says: "If the sense data is for an
ATA PASS-THROUGH (16) command with the EXTEND bit set to one, then the SATL
shall return the 48-bit extended status and shall set the EXTEND bit to one."

Contents of important data-structures for SG_IO:
sg_io_hdr.cmdlen = 16
*sg_io_hdr.cmdp = {0x85 0x07 0x20 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
0x00 0x00 0x27 0x00}

sense-data after command:
0x72 0x00 0x00 0x00 0x00 0x00 0x00 0x0e 0x09 0x0c 0x00 0x00 0x00 0x00 0x00 0xaf
0x00 0x6d 0x00 0x70 0x00 0x50
meaning: descriptor-sense, no error
descriptor:
 code=0x09 -> ATA-Return descriptor
 length=0x0c
 EXTEND=0
 Error = 0x00
 SectorCount = 0x00
 LBA_Low = 0xaf
 LBA_Mid = 0x6d
 LBA_High= 0x70
 Device  = 0
 Status  = DeviceReady | DeferredWriteError

The drive used should be reporting a native max lba of 0x74706daf (1.02TB), so
the expected sense data should look like:
0x72 0x00 0x00 0x00 0x00 0x00 0x00 0x0e 0x09 0x0c 0x01 0x00 0x00 0x00 0x6d 0xaf
0x74 0x70 0x00 0x00 0x00 0x50

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
