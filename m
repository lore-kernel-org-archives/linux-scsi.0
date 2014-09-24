From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date: Wed, 24 Sep 2014 21:33:38 +0000
Message-ID: <bug-85101-11613-AaLrfiEiSd@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40733 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaIXVdm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 17:33:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E0B1F2028D
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 21:33:40 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6A86B20274
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 21:33:38 +0000 (UTC)
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85101

--- Comment #2 from linux-ide@crashplan.pro ---
In this case the hardware seems broken.

The P410 controller is only used for upgrading the HP SAS expander firmware.
This time we started with upgrading the controller firmware:
===
./ccissflash

    This program consists of two phases: device discovery and device update.
    No device will be updated until you answer.

Do you want to run device discovery?
(yes/no) yes
Finding hardware. This may take a few minutes.
Found 1 devices.

Do you want to upgrade the device that has older ROM?
(yes/no) yes
1 devices will be updated.
Updating: P410 Slot: 2 from [5.70] to [6.60]
Updating: P410 Slot: 2 from [5.70] to [6.60]

As part of the reboot process, you must power cycle the server and any external
array storage devices.
===

After power cycling the first three reboots were ok. Then a controller lockup
0x00130000 occurred 468 seconds after loading the hpsa module. Since then only
one boot/module loading was ok and since then the "time outs" are occurring:

===
[  121.613269] HP HPSA Driver (v 3.4.0-1)
[  121.613344] hpsa 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM
control
[  121.613447] hpsa 0000:01:00.0: enabling device (0000 -> 0003)
[  121.613669] hpsa 0000:01:00.0: MSIX
[  121.613770] hpsa 0000:01:00.0: irq 46 for MSI/MSI-X
[  121.613843] hpsa 0000:01:00.0: irq 47 for MSI/MSI-X
[  121.613909] hpsa 0000:01:00.0: irq 48 for MSI/MSI-X
[  121.613981] hpsa 0000:01:00.0: irq 49 for MSI/MSI-X
[  121.614046] hpsa 0000:01:00.0: irq 50 for MSI/MSI-X
[  121.614117] hpsa 0000:01:00.0: irq 51 for MSI/MSI-X
[  121.614182] hpsa 0000:01:00.0: irq 52 for MSI/MSI-X
[  121.614251] hpsa 0000:01:00.0: irq 53 for MSI/MSI-X
[  121.634560] hpsa 0000:01:00.0: hpsa0: <0x323a> at IRQ 46 using DAC
[  127.171906] scsi4 : hpsa
[  127.174883] hpsa 0000:01:00.0: RAID              device c4b3t0l0 added.
[  127.175961] scsi 4:3:0:0: RAID              HP       P410             6.60
PQ: 0 ANSI: 5
[  127.176335] scsi 4:3:0:0: Attached scsi generic sg1 type 12
[  424.473998] HP HPSA Driver (v 3.4.0-1)
===
[   16.127857] HP HPSA Driver (v 3.4.0-1)
[   16.127927] hpsa 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM
control
[   16.128020] hpsa 0000:01:00.0: enabling device (0000 -> 0003)
[   16.128231] hpsa 0000:01:00.0: MSIX
[   16.128327] hpsa 0000:01:00.0: irq 46 for MSI/MSI-X
[   16.128394] hpsa 0000:01:00.0: irq 47 for MSI/MSI-X
[   16.128460] hpsa 0000:01:00.0: irq 48 for MSI/MSI-X
[   16.128524] hpsa 0000:01:00.0: irq 49 for MSI/MSI-X
[   16.128590] hpsa 0000:01:00.0: irq 50 for MSI/MSI-X
[   16.128660] hpsa 0000:01:00.0: irq 51 for MSI/MSI-X
[   16.128726] hpsa 0000:01:00.0: irq 52 for MSI/MSI-X
[   16.128791] hpsa 0000:01:00.0: irq 53 for MSI/MSI-X
[   16.149110] hpsa 0000:01:00.0: hpsa0: <0x323a> at IRQ 46 using DAC
[   34.767566] scsi4 : hpsa
[   34.770583] hpsa 0000:01:00.0: RAID              device c4b3t0l0 added.
[   34.771054] scsi 4:3:0:0: RAID              HP       P410             6.60
PQ: 0 ANSI: 5
===
[   48.389920] HP HPSA Driver (v 3.4.4-1)
[   48.389985] hpsa 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM
control
[   48.390059] hpsa 0000:01:00.0: enabling device (0000 -> 0003)
[   48.390239] hpsa 0000:01:00.0: MSIX
[   48.390312] hpsa 0000:01:00.0: irq 30 for MSI/MSI-X
[   48.390362] hpsa 0000:01:00.0: irq 31 for MSI/MSI-X
[   48.390453] hpsa 0000:01:00.0: Logical aborts not supported
[   48.410617] hpsa 0000:01:00.0: hpsa0: <0x323a> at IRQ 30 using DAC
[   53.947809] scsi host4: hpsa
[   53.953488] hpsa 0000:01:00.0: RAID              device c4b3t0l0 added.
[   53.953986] scsi 4:3:0:0: RAID              HP       P410             6.60
PQ: 0 ANSI: 5
===
[   17.076307] HP HPSA Driver (v 3.4.4-1)
[   17.076388] hpsa 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM
control
[   17.076483] hpsa 0000:01:00.0: enabling device (0000 -> 0003)
[   17.076695] hpsa 0000:01:00.0: MSIX
[   17.076782] hpsa 0000:01:00.0: irq 30 for MSI/MSI-X
[   17.076837] hpsa 0000:01:00.0: irq 31 for MSI/MSI-X
[   17.076942] hpsa 0000:01:00.0: Logical aborts not supported
[   17.097108] hpsa 0000:01:00.0: hpsa0: <0x323a> at IRQ 30 using DAC
[   33.659110] scsi host4: hpsa
[   33.663958] hpsa 0000:01:00.0: RAID              device c4b3t0l0 added.
[   33.664360] scsi 4:3:0:0: RAID              HP       P410             6.60
PQ: 0 ANSI: 5
[   33.665053] scsi 4:3:0:0: Attached scsi generic sg1 type 12
[  485.066696] hpsa 0000:01:00.0: Controller lockup detected: 0x00130000 
===
[   49.567169] HP HPSA Driver (v 3.4.4-1)
[   49.567251] hpsa 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM
control
[   49.567389] hpsa 0000:01:00.0: enabling device (0000 -> 0003)
[   49.567576] hpsa 0000:01:00.0: MSIX
[   49.567649] hpsa 0000:01:00.0: irq 30 for MSI/MSI-X
[   49.567705] hpsa 0000:01:00.0: irq 31 for MSI/MSI-X
[   49.567799] hpsa 0000:01:00.0: Logical aborts not supported
[   49.587966] hpsa 0000:01:00.0: hpsa0: <0x323a> at IRQ 30 using DAC
[   55.125143] scsi host4: hpsa
[   55.129439] hpsa 0000:01:00.0: RAID              device c4b3t0l0 added.
[   55.129832] scsi 4:3:0:0: RAID              HP       P410             6.60
PQ: 0 ANSI: 5
===
[   38.305788] HP HPSA Driver (v 3.4.4-1)
[   38.305854] hpsa 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM
control
[   38.306052] hpsa 0000:01:00.0: MSIX
[   38.306127] hpsa 0000:01:00.0: irq 29 for MSI/MSI-X
[   38.306179] hpsa 0000:01:00.0: irq 30 for MSI/MSI-X
[  163.163631] hpsa 0000:01:00.0: board not ready, timed out.
===
[   23.324890] HP HPSA Driver (v 3.4.0-1)
[   23.324957] hpsa 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM
control
[   23.325060] hpsa 0000:01:00.0: enabling device (0000 -> 0003)
[   23.325281] hpsa 0000:01:00.0: MSIX
[   23.325379] hpsa 0000:01:00.0: irq 45 for MSI/MSI-X
[   23.325453] hpsa 0000:01:00.0: irq 46 for MSI/MSI-X
[   23.325518] hpsa 0000:01:00.0: irq 47 for MSI/MSI-X
[   23.325591] hpsa 0000:01:00.0: irq 48 for MSI/MSI-X
[   23.325655] hpsa 0000:01:00.0: irq 49 for MSI/MSI-X
[   23.325728] hpsa 0000:01:00.0: irq 50 for MSI/MSI-X
[   23.325793] hpsa 0000:01:00.0: irq 51 for MSI/MSI-X
[   23.325865] hpsa 0000:01:00.0: irq 52 for MSI/MSI-X
[  148.185212] hpsa 0000:01:00.0: board not ready, timed out.
===

Right now loading the hpsa module permanently errors out with "board not ready,
timed out" and the "DS1: Diagnostics Error" LED turns Amber (=One of the server
diagnostics utilities has detected a controller error.)

Seems like a hardware issue, therefore this case can be closed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
