From: Shanker Balan <shanu@exocore.com>
Subject: aic7xxx: SCSI Bus Reset
Date: Tue, 24 Dec 2002 16:51:59 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021224112158.GA667@exocore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from godzilla.exocore.com ([202.141.128.95])
	(authenticated)
	by premium.exocore.com (8.11.6/8.11.6) with ESMTP id gBOBM5p03497
	for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2002 16:52:06 +0530
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Hello:

I am experience aic7xxx SCSI reset errors which happens every so often
on my NFS server:

Hardware:

Gigabyte GA-7DPXDw Dual SMP Motherboard with 512MB of RAM
2 AMD Athlon 1900
Adaptec AIC-7892A U160/m (rev 02)
QUANTUM  Model: ATLAS10K3_18_SCA
QUANTUM  Model: ATLAS10K3_73_SCA
QUANTUM  Model: ATLAS10K3_73_SCA

Software:

RedHat Linux 7.3 with all updates
[root@master root]# uname -r
2.4.18-18.7.x

In the hope of solving the problem I tried the following with no
success:

- Non-SMP kernel
- SMP kernel in NOAPIC mode
- Booted an older RedHat kernel
- Replaced SCSI controller
- Replaced SCSI cables
- Swapped SCSI controller slots

Here is a snip from syslog:

Dec 24 16:20:38 master kernel: scsi0:0:0:0: Attempting to queue an ABORT message
Dec 24 16:20:38 master kernel: scsi0:0:0:0: Command found on device queue
Dec 24 16:20:38 master kernel: aic7xxx_abort returns 0x2002
Dec 24 16:20:48 master kernel: scsi0:0:0:0: Attempting to queue an ABORT message
Dec 24 16:20:48 master kernel: scsi0:0:0:0: Command found on device queue
Dec 24 16:20:48 master kernel: aic7xxx_abort returns 0x2002 Dec 24 16:20:54 master kernel: scsi0:0:0:0: Attempting to queue an ABORT
message
Dec 24 16:20:54 master kernel: scsi0: Dumping Card State while idle, at SEQADDR 0x9
[...]
Dec 24 16:20:55 master kernel: scsi0:0:0:0: Device is disconnected, re-queuing SCB
Dec 24 16:20:55 master kernel: Recovery code sleeping Dec 24 16:20:55 master kernel: (scsi0:A:0:0): Abort Tag Message Sent
Dec 24 16:20:55 master kernel: (scsi0:A:0:0): SCB 9 - Abort Tag Completed.
Dec 24 16:20:55 master kernel: Recovery SCB completes
Dec 24 16:20:55 master kernel: Recovery code awake
Dec 24 16:20:55 master kernel: aic7xxx_abort returns 0x2002
Dec 24 16:20:55 master kernel: scsi0:0:0:0: Attempting to queue an ABORT message
Dec 24 16:20:55 master kernel: scsi0:0:0:0: Command not found
Dec 24 16:20:55 master kernel: aic7xxx_abort returns 0x2002
Dec 24 16:20:55 master kernel: scsi0:0:0:0: Attempting to queue an ABORT message
Dec 24 16:20:55 master kernel: scsi0:0:0:0: Command not found

The full log is at http://people.exocore.com/shanu/scsi_reset.log

This is goes on for a couple of minutes. Sometimes things come crashing
down immediately and sometimes its still usable after the SCSI reset.

I have tried to track down the problem by going thru the linux-scsi
archives and searching google groups but I still have not been able to
find a solution.

Things which I am yet to try:

- Flash motherboard BIOS
- Change motherboard
- Change disks

What I would like to know is how to interpret the SCSI messages so that
I can have a better understanding of the problem and make suitable
changes to the system.

Thank you for your time!


-- Shanu
http://shankerbalan.com/

lspci:

00:08.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
	Subsystem: Adaptec 29160 Ultra160 SCSI Controller
	Flags: bus master, 66Mhz, medium devsel, latency 32, IRQ 11
	BIST result: 00
	I/O ports at e400 [disabled] [size=256]
	Memory at f7100000 (64-bit, non-prefetchable) [size=4K]
	Expansion ROM at <unassigned> [disabled]
	[size=128K] Capabilities: [dc] Power Management version 2




-- 
It will be advantageous to cross the great stream ... the Dragon is on
the wing in the Sky ... the Great Man rouses himself to his Work.
