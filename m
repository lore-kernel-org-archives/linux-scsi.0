From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: sym53c8xx parity errors on SuSE 9.1's hwscan?
Date: Thu, 23 Sep 2004 01:16:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3y8j1q4gs.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:37036 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S268107AbUIVXQz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2004 19:16:55 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Greetings,

SuSE Linux 9.1 (kernel 2.6.5 + SuSE patch set, but also 2.6.7 or a bit
milder in 2.6.9-rc2-mm1) uses some SuSE-specific "hwprobe" or "hwinfo"
tool to scan for hardware.

Whenever this tool, probing the PCI bus, hits my Tekram DC-390U or
DC-310U, the box logs a SCSI parity error, some timed out abort
messages, then the usual reset escalation; device reset (times out), bus
reset (times out), finally HBA reset (succeeds). The whole procedure
takes about 1 to 2 minutes before the bus is usable again.

If the machine is idle and has warm caches, I may occasionally see just
the parity error message, so it may look a bit like a race in sym53c8xx
or perhaps the hardware.

The problem seems to persist through current versions, although they can
_usually_ just fix up a phase error and continue immediately.

The problem did not exist when I was running 2.6.7 on SuSE 8.2.

I find it a bit intimidating that user-space (albeit with root
permissions) causes "SCSI" parity errors, and given the 2.6.9 logging
towards the end of the mail, I am wondering if SuSE's hwinfo stuff
triggers some race condition or manages to bypass the SCSI phase state
machine or if the probe confuses the chip. I haven't yet managed to
isolate (with strace) the cause.

Is there a useful debug setting for sym53c8xx that could shed some light
on what the user-space has attempted that led to the SCSI parity error?

Log from SuSE's 2.6.5-7.108-default during system boot-up:

Sep 22 15:15:09 merlin kernel: sym0: SCSI parity error detected: SCR1=3 DBC=50000000 SBCL=0
Sep 22 15:15:39 merlin kernel: sym0:1:0: ABORT operation started.
Sep 22 15:15:44 merlin kernel: sym0:1:0: ABORT operation timed-out.
Sep 22 15:15:44 merlin kernel: sym0:1:0: ABORT operation started.
Sep 22 15:15:49 merlin kernel: sym0:1:0: ABORT operation timed-out.
Sep 22 15:15:49 merlin kernel: sym0:1:0: DEVICE RESET operation started.
Sep 22 15:15:54 merlin kernel: sym0:1:0: DEVICE RESET operation timed-out.
Sep 22 15:15:54 merlin kernel: sym0:1:0: BUS RESET operation started.
Sep 22 15:15:54 merlin kernel: sym0: SCSI BUS reset detected.
Sep 22 15:15:54 merlin kernel: sym0: SCSI BUS has been reset.
Sep 22 15:15:54 merlin kernel: sym0:1:0: BUS RESET operation complete.

and a while later:

Sep 22 15:18:32 merlin kernel: sym0: SCSI parity error detected: SCR1=3 DBC=50000000 SBCL=0
Sep 22 15:18:32 merlin kernel: sym0: interrupted SCRIPT address not found.
Sep 22 15:18:32 merlin kernel: sym0: SCSI BUS reset detected.
Sep 22 15:18:32 merlin kernel: sym0: SCSI BUS has been reset.

2.6.9-rc2-mm1, although otherwise not useful for me (UDP networking)
logs this instead:

Sep 22 14:00:05 merlin kernel: sym0: SCSI parity error detected: SCR1=3 DBC=50000000 SBCL=0
Sep 22 14:00:05 merlin kernel: sym0: SCSI phase error fixup: CCB already dequeued.
Sep 22 14:00:05 merlin kernel: sym0: SCSI BUS reset detected.
Sep 22 14:00:05 merlin kernel: sym0: SCSI BUS has been reset.

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
