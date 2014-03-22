From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71941] LSI SAS2116 does not detect disks
Date: Sat, 22 Mar 2014 14:11:54 +0000
Message-ID: <bug-71941-11613-0Pe0x6M452@https.bugzilla.kernel.org/>
References: <bug-71941-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39121 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaCVOL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Mar 2014 10:11:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6ABFD202BE
	for <linux-scsi@vger.kernel.org>; Sat, 22 Mar 2014 14:11:56 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9713F202D1
	for <linux-scsi@vger.kernel.org>; Sat, 22 Mar 2014 14:11:54 +0000 (UTC)
In-Reply-To: <bug-71941-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71941

kernel-bugzilla.20.drkshadow@spamgourmet.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #1 from kernel-bugzilla.20.drkshadow@spamgourmet.com ---
The issue turned out to be hardware: Some combination of flashing the firmware
and BIOS caused all disks to register.

I did get the 18.00.00.00 driver to compile under 3.13.6, however it gave me
its own problems: as I attempted to dd if="$f" of="$f" bs=65536 across every
disk in the system simultaneously, the system would, after 20-30 minutes, lock
solid. (This process proceeded fine if of=/dev/null; I'm doing this to find
disks that I know have sector errors.) I have no dmesg output. Further,
modprobe -r was _very_ slow on this driver, eventually printing to dmesg a
trace including "warn_slowpath_fmt".

Attached is a basic patch to get the new LSI driver to compile under 3.13.6,
but no guarantees as to the quality of anything.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
