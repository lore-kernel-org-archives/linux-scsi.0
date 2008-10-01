From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Wed,  1 Oct 2008 15:40:23 -0700 (PDT)
Message-ID: <20081001224023.41641108048@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbYJAWkp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 18:40:45 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m91MeNHG001514
	for <linux-scsi@vger.kernel.org>; Wed, 1 Oct 2008 15:40:24 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #8 from grin@grin.hu  2008-10-01 15:40 -------
Hm, I go some logs which contain messages like

Oct  2 00:23:05 galamb kernel: [139240.696070] qla2xxx 0000:08:01.1: RISC
paused -- HCCR=0, Dumping firmware!
Oct  2 00:23:05 galamb kernel: [139240.696097] qla2xxx 0000:08:01.1: Firmware
has been previously dumped (ffffc20000bcc000) -- ignoring request...
Oct  2 00:23:05 galamb kernel: [139241.494343] scsi(4): dpc: sched
qla2x00_abort_isp ha = ffff81007bd84460
Oct  2 00:23:05 galamb kernel: [139241.494350] qla2xxx 0000:08:01.1: Performing
ISP error recovery - ha= ffff81007bd84460.
Oct  2 00:23:05 galamb kernel: [139241.530998] scsi(4): **** Load RISC code
****
Oct  2 00:23:05 galamb kernel: [139241.547277] scsi(4): Verifying Checksum of
loaded RISC code.
Oct  2 00:23:05 galamb kernel: [139241.564201] scsi(4): Checksum OK, start
firmware.
Oct  2 00:23:06 galamb kernel: [139241.747606] scsi(4): Issue init firmware.
Oct  2 00:23:06 galamb kernel: [139242.296514] scsi(4): Asynchronous P2P MODE
received.
Oct  2 00:23:06 galamb kernel: [139242.316473] scsi(4): Asynchronous LOOP UP (4
Gbps).
Oct  2 00:23:06 galamb kernel: [139242.316479] qla2xxx 0000:08:01.1: LOOP UP
detected (4 Gbps).
Oct  2 00:23:06 galamb kernel: [139242.336435] scsi(4): Asynchronous PORT
UPDATE.
Oct  2 00:23:06 galamb kernel: [139242.336440] scsi(4): Port database changed
ffff 0006 0000.
Oct  2 00:23:06 galamb kernel: [139242.356395] scsi(4): Asynchronous PORT
UPDATE ignored 0000/0004/0600.
Oct  2 00:23:06 galamb kernel: [139242.376358] scsi(4): Asynchronous PORT
UPDATE ignored 0000/0007/0b00.
Oct  2 00:23:06 galamb kernel: [139242.396353] scsi(4): F/W Ready - OK 
Oct  2 00:23:06 galamb kernel: [139242.416315] scsi(4): fw_state=3 curr
time=100d44784.
Oct  2 00:23:06 galamb kernel: [139242.416321] qla2x00_restart_isp(): Start
configure loop, status = 0
Oct  2 00:23:06 galamb kernel: [139242.436258] scsi(4): Configure loop -- dpc
flags =0x4080048
Oct  2 00:23:06 galamb kernel: [139242.456218] scsi(4): RSCN queue entry[0] =
[00/000000].
Oct  2 00:23:06 galamb kernel: [139242.456223] scsi(4): device_resync: rscn
overflow.
Oct  2 00:23:06 galamb kernel: [139242.492382] scsi(4): fcport-0 - port retry
count: 2 remaining
Oct  2 00:23:06 galamb kernel: [139242.492406] scsi(4): RFT_ID exiting
normally.
Oct  2 00:23:06 galamb kernel: [139242.512366] scsi(4): RFF_ID exiting
normally.
Oct  2 00:23:06 galamb kernel: [139242.532324] scsi(4): RNN_ID exiting
normally.
Oct  2 00:23:06 galamb kernel: [139242.556047] scsi(4): RSNN_NN exiting
normally.
Oct  2 00:23:07 galamb kernel: [139242.632113] scsi(4): GID_PT entry - nn
200100e08bba4036 pn 210100e08bba4036 portid=010400.
Oct  2 00:23:07 galamb kernel: [139242.655856] scsi(4): GID_PT entry - nn
200400a0b8263784 pn 200500a0b8263785 portid=011300.
Oct  2 00:23:07 galamb kernel: [139242.731982] scsi(4): GPSC ext entry - fpn
200400c0dd0daf7b speeds=6000 speed=2000.
Oct  2 00:23:07 galamb kernel: [139242.755684] scsi(4): GPSC ext entry - fpn
201300c0dd0daf7b speeds=e000 speed=2000.
Oct  2 00:23:07 galamb kernel: [139242.775629] qla24xx_fabric_logout(4): failed
to complete IOCB -- completion status (31)  ioparam=a/0.
Oct  2 00:23:07 galamb kernel: [139242.775634] scsi(4): device wrap (011300)
Oct  2 00:23:07 galamb kernel: [139242.775639] scsi(4): Trying Fabric Login
w/loop id 0x0081 for port 011300.
Oct  2 00:23:07 galamb kernel: [139242.831751] qla2xxx 0000:08:01.1: iIDMA
adjusted to 4 GB/s on 200500a0b8263785.
Oct  2 00:23:07 galamb kernel: [139242.831787] scsi(4): LOOP READY
Oct  2 00:23:07 galamb kernel: [139242.831789] qla2x00_restart_isp(): Configure
loop done, status = 0x0
Oct  2 00:23:07 galamb kernel: [139242.833926] qla2xxx 0000:08:01.1:
scsi(4:0:0:6): Mid-layer underflow detected (40000 of 40000 bytes)...returning
error status.
Oct  2 00:23:07 galamb kernel: [139242.843912] qla2xxx 0000:08:01.1:
scsi(4:0:0:3): Mid-layer underflow detected (10000 of 10000 bytes)...returning
error status.

under 2.6.24+openvz. It was repeatedly generated by asking LVM to move a whole
physical volume (PV) to another one, which caused a constant, medium rate
dataflow in both directions. The link went up later, and the move so far did
not crash the machine.

It may be important to mention that FC#0 is link down (really), FC#1 is active.
When FC1 reports link down, mailbox timeouts, etc, FC0 logs _lots_ of firmware
dump requests (thousands), which I guess could eventually crash the machine
(but so far didn't).

If anyone requests I can provide the full syslog (not as an attachment though).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
