From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10974] New: 2.6.25 regression: delay needed after audio CD insertion
Date: Tue, 24 Jun 2008 02:27:52 -0700 (PDT)
Message-ID: <bug-10974-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758651AbYFXJ2Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2008 05:28:24 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5O9Rq4Z017461
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2008 02:27:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10974

           Summary: 2.6.25 regression: delay needed after audio CD insertion
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.25
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: geert@linux-m68k.org


Latest working kernel version: 2.6.24
Hardware Environment: PS3
Problem Description: Audio CD cannot be read within 10 seconds after insertion

Steps to reproduce:
  1. Insert an audio CD
  2. Run the following command as soon as the blue CD/DVD/BD drive LED
     stops blinking and is lit continuously:

     cdparanoia -Z -q 1-1[:1] /dev/null || echo failed

On 2.6.25 (and current mainline), you have to wait ca. 10 seconds after
insertion, or it will fail.
On 2.6.24 and older, it just works immediately.

(I could reproduce it on an Athlon with sym53c8xx SCSI running a Debianized
 2.6.25 kernel, too, but I didn't try a 2.6.24 kernel there)

The problem was introduced by:

commit 38582a62ecd337de4212004c7d4844899dc57890
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Wed Feb 6 13:01:58 2008 -0600

    [SCSI] sr: fix test unit ready responses

References: http://lkml.org/lkml/2008/6/13/89


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
