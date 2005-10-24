From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bug 5489] New: Boot fails with BIOS memory remapping enabled
 on an Adaptec SCSI system with Asus A8V and 4GB of RAM
Date: Mon, 24 Oct 2005 11:58:52 -0700
Message-ID: <20051024115852.27a8b794.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:22660 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750908AbVJXS7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 14:59:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>



Begin forwarded message:

Date: Mon, 24 Oct 2005 09:41:29 -0700
From: bugme-daemon@kernel-bugs.osdl.org
To: akpm@osdl.org
Subject: [Bug 5489] New: Boot fails with BIOS memory remapping enabled on an Adaptec SCSI system with Asus A8V and 4GB of RAM


http://bugzilla.kernel.org/show_bug.cgi?id=5489

           Summary: Boot fails with BIOS memory remapping enabled on an
                    Adaptec SCSI system with Asus A8V and 4GB of RAM
    Kernel Version: 2.6.13.4
            Status: NEW
          Severity: high
             Owner: akpm@osdl.org
         Submitter: siegbert.baude@gmx.de


Most recent kernel where this bug did not occur: unknown
Distribution: SUSE 9.2
Hardware Environment: Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
                      <Adaptec 19160B Ultra160 SCSI adapter>
                      Asus A8V (newest BIOS) with 4GB of Crucial RAM
                      MAXTOR    Model: ATLAS10K4_36WLS   Rev: DFV0
                      Radeon 7000
Software Environment: Kernel build done on Suse 9.2:
Linux albatross 2.6.8-24.18-default #1 Fri Aug 19 11:56:28 UTC 2005 x86_64
x86_64 x86_64 GNU/Linux
 
Gnu C                  3.3.4
Gnu make               3.80
binutils               2.15.91.0.2
util-linux             2.12c
mount                  2.12c
module-init-tools      3.1-pre5
e2fsprogs              1.35
jfsutils               1.1.7
reiserfsprogs          3.6.18
reiser4progs           line
xfsprogs               2.6.13
quota-tools            3.11.
nfs-utils              1.0.6
Linux C Library        02 04:13 /lib64/tls/libc.so.6
Dynamic linker (ldd)   2.3.3
Linux C++ Library      5.0.7
Procps                 3.2.3
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
udev                   030

Problem Description:

The above system boots fine with the BIOS memory remapping option disabled. The
boot log of this case is attached as "2.6.13.4_without_remapping.txt".
If I however enable BIOS memory remapping to make full use of the 4GB RAM, the
boot fails within the scsi driver routines. This boot log is attached as
"2.6.13.4_with_remapping.txt".

The kernel I used for this test is a quite minimalistic, static (i.e. without
modules) vanilla kernel; its config file is attached as "config-2.6.13.4".

I also tried to boot with the newest SUSE 10.0 CD in rescue mode, which uses a
kernel with modules. The result is mostly the same. I attached the boot log with
disabled BIOS memory remapping as "SUSE-10.0-RESCUE-2.6.13-15_without_remapping.txt"
the log with enabled BIOS memory remapping as
"SUSE-10.0-RESCUE-2.6.13-15_with_remapping.txt".

The last one was caught in a loop, so I rebooted by SysRq.

On the SUSE AMD64 mailing list there was a report of a success with the A8V
(same BIOS), 4GB of RAM and BIOS memory remapping enabled, where the only
apparent difference seemed to be, that this was an IDE system, whereas mine is a
SCSI one. As booting always fails in the scsi part, I suspect an error in the
aic7xxx driver.

Steps to reproduce: Boot any recent kernel on a machine with an Adaptec 19160B,
Asus A8V and 4GB of RAM.

------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
