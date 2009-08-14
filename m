From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13982] New: [libata] (?) causing Hardlock in 2.6.30.4 during
 simultaneous read & write
Date: Fri, 14 Aug 2009 08:26:29 GMT
Message-ID: <bug-13982-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40919 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbZHNI02 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2009 04:26:28 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7E8QTuv007694
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2009 08:26:29 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13982

           Summary: [libata] (?) causing Hardlock in 2.6.30.4 during
                    simultaneous read & write
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.30.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: wylda@volny.cz
        Regression: No


Created an attachment (id=22713)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=22713)
kernel config

Hi.

HW: Server Board Intel STL2, 2x P3 @ 1GHz, 1GB ECC RAM

SW: self-compiled kernel 2.6.30.4 on Debian Lenny

Symptom: PC completely stops responding (ping, ALT+F2..., Numlock,
CTRL-ALT-DEL, ALT-SysRq)

Traces: No Oops, nothing in syslog etc.


I think it's not HW failure, because it never happened when

 * 2x dd if=/dev/zero bs=1M count=200000 | md5sum -b

 * 2x dd if=/dev/zero of=test-x bs=1M count=200000

such tests take a long time on this HW (51min and 85min) and checksums always
OK. Tested many times.



Anyway i'm usually able to invoke Hardlock in 2min. I use a script:

#!/bin/bash

dd if=/dev/zero bs=1M count=200000 | md5sum -b &
dd if=/dev/zero bs=1M count=200000 | md5sum -b &
cd /home/pik/a
md5sum -c office.md5 &
cd /home/pik/b
md5sum -c office.md5 &

So i run this stress script _and_ begin FTP write to the same HDD. Usually
Hardlock itself, but if it does not Hardlock in 60sec i can help it with
another dd (dd if=/dev/zero of=test1 bs=1M count=200000).


Also why should not be HW failure - No complains of EDAC and happens on
different HW:

 * PATA drive IC35L040AVVA07 on ServerWorks OSB4 (MOBO's chipset aka IB6566
South Bridge)

 * SATA drives 2xWD5000AADS in md0 on Sil3114

 * Network card: PCI-X, Intel 1Gbps 82543GC

 * Network card: PCI Realtek RT8139


Today when doing last test for bugreport there was a trace, but the HardLock
was not 100% same (as always ping stopped working, console switching did not
work, no Numlock reaction, but Alt-SysRq worked). Hope its not misleading - see
attachment.


Another prove(?), that this is not HW failure:
  * never happens with Debian's 2.6.26-17lenny1 all_generic_ide=1 gcc4.1.3
  * easy to trigger with 2.6.30.4 gcc4.3.2

...i know know different kernel version, kernel parameters and gcc, but HW
error would occurred anyway.


config kernel, dmesg, lspci atached.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
