From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12742] New: Spinning up disk is observed on standby paths until timeout, resulting in longer path restoration time.
Date: Fri, 20 Feb 2009 02:20:26 -0800 (PST)
Message-ID: <bug-12742-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544AbZBTKVA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2009 05:21:00 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1KAKQ7p002964
	for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2009 02:20:27 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12742

           Summary: Spinning up disk is observed on standby paths until
                    timeout, resulting in longer path restoration time.
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.27
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: narayanan.rengarajan@hp.com


Latest working kernel version: 2.6.27
Earliest failing kernel version:
Distribution: suse
Hardware Environment:x86_64
Software Environment:sd
Problem Description:

Steps to reproduce:
 1. present a standby lun to the host
 2. do a discovery from the host (scan the scsi bus)
 3. Spinning of disks is  observed in  /var/log/messages

Whenever a device goes offline and comes back, the new sd device takes longer
time to get created. This is because of the spinning up of disk in
sd_spinup_disk fuction as the standby paths would return device not ready with
0x04/0x0b asc/ascq.

recommended patch :
                   diff -pNaur /usr/src/linux/drivers/scsi/sd.c sd.c
--- /usr/src/linux/drivers/scsi/sd.c    2009-02-09 22:24:56.000000000 +0530
+++ sd.c        2009-02-19 16:39:16.000000000 +0530
@@ -1181,8 +1181,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
                 */
                if (sense_valid &&
                    sshdr.sense_key == NOT_READY &&
-                   sshdr.asc == 4 && sshdr.ascq == 3) {
-                       break;          /* manual intervention required */
+                   sshdr.asc == 4 && (sshdr.ascq == 3 || sshdr.ascq == 0x0b ||
sshdr.ascq == 0x0c) ) {
+                       break;  /* manual intervention required || Standby ||
Unavailable */

                /*
                 * Issue command to spin up drive when not ready


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
