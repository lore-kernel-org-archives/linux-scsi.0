From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 7610] New: sense key error when sending even
 number of bytes to /dev/st0
Date: Fri, 1 Dec 2006 11:29:30 -0800
Message-ID: <20061201112930.cff7f276.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:32725 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1031751AbWLAT3f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Dec 2006 14:29:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>



Begin forwarded message:

Date: Fri, 1 Dec 2006 08:40:16 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 7610] New: sense key error when sending even number of bytes to /dev/st0


http://bugzilla.kernel.org/show_bug.cgi?id=7610

           Summary: sense key error when sending even number of bytes to
                    /dev/st0
    Kernel Version: 2.6.19
            Status: NEW
          Severity: normal
             Owner: other_modules@kernel-bugs.osdl.org
         Submitter: bergenia@pair.com


Most recent kernel where this bug did *NOT* occur: unknown
Distribution: Debian, but using kernel from kernel.org
Hardware Environment: Dell Poweredge 2800 Xeon, Quantum DLT VS160 tape drive, 
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 3960D Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
Software Environment: 
Gnu C                  3.3.5
Gnu make               3.80
binutils               2.15
util-linux             2.12p
mount                  2.12p
module-init-tools      3.2.2
e2fsprogs              1.37
nfs-utils              1.0.6
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.1
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.2.1
udev                   088
Modules Loaded         st parport_pc parport

Problem Description: 
When sending an even number of bytes to /dev/st0, I get the following error in
/var/log/kernel:

Nov 30 16:13:47 mugsy kernel: st0: Current: sense key: Illegal Request
Nov 30 16:13:47 mugsy kernel:     Additional sense: Invalid field in cdb

Steps to reproduce:
this will write to the tape:

echo "A" > /dev/st0
echo "ABC" > /dev/st0

this will not write to the tape and will produce the kernel error:

echo "AB" > /dev/st0
echo "ABCD" > /dev/st0

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
