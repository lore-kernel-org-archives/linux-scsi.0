From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14577] New: Data Corruption with Adaptec 52445
Date: Tue, 10 Nov 2009 13:31:55 GMT
Message-ID: <bug-14577-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43237 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZKJNbt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 08:31:49 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAADVtPW014543
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 13:31:55 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14577

           Summary: Data Corruption with Adaptec 52445
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.32-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AACRAID
        AssignedTo: scsi_drivers-aacraid@kernel-bugs.osdl.org
        ReportedBy: lkolbe@techfak.uni-bielefeld.de
        Regression: Yes


Created an attachment (id=23725)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23725)
dmesg of the running (and failing) 2.6.32-rc6 on this system

When booting this system with the 2.6.32-rc6 kernel, we see immediate data
corruption on the root filesystem:

[   21.813985] Adding 4194296k swap on /dev/mapper/system-swap.  Priority:-1
extents:1 across:4194296k 
[   21.903794] sd 0:0:0:0: [sda] Unhandled sense code
[   21.903865] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[   21.903998] sd 0:0:0:0: [sda] Sense Key : Hardware Error [current] 
[   21.904219] sd 0:0:0:0: [sda] Add. Sense: Internal target failure
[   21.904382] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 00 01 bf 00 00 08 00
[   21.905051] end_request: I/O error, dev sda, sector 447
[   21.905122] Buffer I/O error on device dm-0, logical block 0
[   21.905191] lost page write due to I/O error on dm-0
[   21.905271] EXT3 FS on dm-0, internal journal
[   23.263958] sd 0:0:0:0: [sda] Unhandled sense code
[   23.264029] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[   23.264162] sd 0:0:0:0: [sda] Sense Key : Hardware Error [current] 
[   23.264368] sd 0:0:0:0: [sda] Add. Sense: Internal target failure
[   23.264531] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 bc 11 cf 00 00 08 00
[   23.265186] end_request: I/O error, dev sda, sector 12325327
[   23.265257] Buffer I/O error on device dm-1, logical block 492034
[   23.265327] lost page write due to I/O error on dm-1
[   23.364800] kjournald starting.  Commit interval 5 seconds
[   23.423871] sd 0:0:0:0: [sda] Unhandled sense code
[   23.423874] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[   23.423877] sd 0:0:0:0: [sda] Sense Key : Hardware Error [current] 
[   23.423880] sd 0:0:0:0: [sda] Add. Sense: Internal target failure
[   23.423886] sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 80 01 bf 00 00 08 00
[   23.423893] end_request: I/O error, dev sda, sector 8389055
[   23.423983] Buffer I/O error on device dm-1, logical block 0
[   23.424052] lost page write due to I/O error on dm-1

On 2.6.30 the system works 'fine' (in that it doesn't shredder the filesystems
on bootup). dmesg, lspci, lsscsi all attached later.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
