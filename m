From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Sun, 23 Nov 2008 11:21:28 -0800 (PST)
Message-ID: <20081123192128.41F63108042@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbYKWTVb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2008 14:21:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mANJLSSD014668
	for <linux-scsi@vger.kernel.org>; Sun, 23 Nov 2008 11:21:29 -0800
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646


cstamas@digitus.itk.ppke.hu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |cstamas@digitus.itk.ppke.hu




------- Comment #17 from cstamas@digitus.itk.ppke.hu  2008-11-23 11:21 -------
I also suffer from this bug:

Linux version 2.6.24-1-pve (root@oahu) (gcc version 4.1.2 20061115 (prerelease)
(Debian 4.1.1-21)) #1 SMP PREEMPT Fri Oct 24 11:34:13 CEST 2008 (Ubuntu
2.6.24-4.6-server)

Nov 22 07:35:37 somehost kernel: qla2xxx 0000:08:01.0: Mailbox command timeout
occured. Issuing ISP abort.
Nov 22 07:35:37 somehost kernel: qla2xxx 0000:08:01.0: Performing ISP error
recovery - ha= ffff8101618f0468.
Nov 22 07:35:38 somehost kernel: qla2xxx 0000:08:01.0: LOOP UP detected (2
Gbps).
Nov 22 07:35:38 somehost kernel: qla2xxx 0000:08:01.0: SNS scan failed --
assuming zero-entry result...
Nov 22 07:35:38 somehost kernel: APIC error on CPU1: 00(40)
Nov 22 07:35:38 somehost kernel: qla2xxx 0000:08:01.0: scsi(1:0:1): Abort
command issued -- 0 1acc93 2002.
Nov 22 07:36:12 somehost kernel:  rport-1:0-4: blocked FC remote port time out:
saving binding
Nov 22 07:36:13 somehost kernel: qla2xxx 0000:08:01.0: scsi(1:0:1): DEVICE
RESET ISSUED.
Nov 22 07:36:37 somehost kernel:  rport-1:0-0: blocked FC remote port time out:
removing rport
Nov 22 07:36:37 somehost kernel:  rport-1:0-1: blocked FC remote port time out:
removing rport
Nov 22 07:36:37 somehost kernel:  rport-1:0-2: blocked FC remote port time out:
removing rport
Nov 22 07:36:37 somehost kernel:  rport-1:0-3: blocked FC remote port time out:
removing rport

This is a HS21 with a Qlogic card:
08:01.0 Fibre Channel: QLogic Corp. QLA2422 Fibre Channel Adapter (rev 02)
08:01.1 Fibre Channel: QLogic Corp. QLA2422 Fibre Channel Adapter (rev 02)

I am using a DS4700 and the other machines works fine at the same time.

Another machine connected to the same fibre channel switch (the one which works
fine) has debugging mode enabled I include its logs here if it can give a hit
what event drove the HS21 machine crazy:

(log from a HS20 2.6.24.7 stock kernel)
06:01.0 Fibre Channel: QLogic Corp. ISP2312-based 2Gb Fibre Channel to PCI-X
HBA (rev 02)
06:01.1 Fibre Channel: QLogic Corp. ISP2312-based 2Gb Fibre Channel to PCI-X
HBA (rev 02)

2008-11-22_06:35:37.55516 kern.warn: scsi(1): Asynchronous RSCR UPDATE.
2008-11-22_06:35:37.55520 kern.info: scsi(1): RSCN database changed -- 0001
0600.
2008-11-22_06:35:38.18991 kern.warn: scsi(1): qla2x00_loop_resync()
2008-11-22_06:35:38.18998 kern.warn: scsi(1): F/W Ready - OK
2008-11-22_06:35:38.23641 kern.warn: scsi(1): fw_state=3 curr time=69fc0e46.
2008-11-22_06:35:38.23646 kern.warn: scsi(1): Configure loop -- dpc flags
=0x40000a0
2008-11-22_06:35:38.48711 kern.warn: scsi(1): RSCN queue entry[30] =
[00/010600].
2008-11-22_06:35:38.48713 kern.warn: scsi(1): GID_PT entry - nn
200000112593fc1c pn 210000112593fc1c portid=010100.
2008-11-22_06:35:38.48716 kern.warn: scsi(1): GID_PT entry - nn
200000112593f89c pn 210000112593f89c portid=010200.
2008-11-22_06:35:38.48718 kern.warn: scsi(1): GID_PT entry - nn
200000145e241c2c pn 210000145e241c2c portid=010400.
2008-11-22_06:35:38.48719 kern.warn: scsi(1): GID_PT entry - nn
2000001b3205b641 pn 2100001b3205b641 portid=010600.
2008-11-22_06:35:38.48720 kern.warn: scsi(1): GID_PT entry - nn
2000001b32056b41 pn 2100001b32056b41 portid=010700.
2008-11-22_06:35:38.48721 kern.warn: scsi(1): GID_PT entry - nn
200400a0b8293358 pn 202400a0b8293358 portid=010f00.
2008-11-22_06:35:38.48723 kern.warn: scsi(1): device wrap (010f00)
2008-11-22_06:35:38.48725 kern.warn: scsi(1): Trying Fabric Login w/loop id
0x0083 for port 010600.
2008-11-22_06:35:38.48726 kern.warn: scsi(1): LOOP READY
2008-11-22_06:35:38.48727 kern.warn: scsi(1): qla2x00_loop_resync - end
2008-11-22_06:35:38.54288 kern.warn: scsi(1): Asynchronous RSCR UPDATE.
2008-11-22_06:35:38.54294 kern.info: scsi(1): RSCN database changed -- 0001
0600.
2008-11-22_06:35:39.18405 kern.warn: scsi(1): qla2x00_loop_resync()
2008-11-22_06:35:39.18412 kern.warn: scsi(1): F/W Ready - OK
2008-11-22_06:35:39.21856 kern.warn: scsi(1): fw_state=3 curr time=69fc0f3d.
2008-11-22_06:35:39.21862 kern.warn: scsi(1): Configure loop -- dpc flags
=0x40000a0
2008-11-22_06:35:39.25176 kern.warn: scsi(1): RSCN queue entry[31] =
[00/010600].
2008-11-22_06:35:39.27638 kern.warn: scsi(1): GID_PT entry - nn
200000112593fc1c pn 210000112593fc1c portid=010100.
2008-11-22_06:35:39.29344 kern.warn: scsi(1): GID_PT entry - nn
200000112593f89c pn 210000112593f89c portid=010200.
2008-11-22_06:35:39.30982 kern.warn: scsi(1): GID_PT entry - nn
200000145e241c2c pn 210000145e241c2c portid=010400.
2008-11-22_06:35:39.32600 kern.warn: scsi(1): GID_PT entry - nn
2000001b3205b641 pn 2100001b3205b641 portid=010600.
2008-11-22_06:35:39.34160 kern.warn: scsi(1): GID_PT entry - nn
2000001b32056b41 pn 2100001b32056b41 portid=010700.
2008-11-22_06:35:39.35693 kern.warn: scsi(1): GID_PT entry - nn
200400a0b8293358 pn 202400a0b8293358 portid=010f00.
2008-11-22_06:35:39.35699 kern.warn: scsi(1): device wrap (010f00)
2008-11-22_06:35:39.38467 kern.warn: scsi(1): Trying Fabric Login w/loop id
0x0083 for port 010600.
2008-11-22_06:35:39.39794 kern.warn: scsi(1): LOOP READY
2008-11-22_06:35:39.39801 kern.warn: scsi(1): qla2x00_loop_resync - end
2008-11-22_06:36:43.23921 kern.warn: scsi(1): Asynchronous RSCR UPDATE.
2008-11-22_06:36:43.23925 kern.info: scsi(1): RSCN database changed -- 0001
0600.
2008-11-22_06:36:44.17780 kern.warn: scsi(1): qla2x00_loop_resync()
2008-11-22_06:36:44.17787 kern.warn: scsi(1): F/W Ready - OK
2008-11-22_06:36:44.19975 kern.warn: scsi(1): fw_state=3 curr time=69fc4eb4.
2008-11-22_06:36:44.19981 kern.warn: scsi(1): Configure loop -- dpc flags
=0x40000a0
2008-11-22_06:36:44.22040 kern.warn: scsi(1): RSCN queue entry[0] =
[00/010600].
2008-11-22_06:36:44.23846 kern.warn: scsi(1): GID_PT entry - nn
200000112593fc1c pn 210000112593fc1c portid=010100.
2008-11-22_06:36:44.24914 kern.warn: scsi(1): GID_PT entry - nn
200000112593f89c pn 210000112593f89c portid=010200.
2008-11-22_06:36:44.25921 kern.warn: scsi(1): GID_PT entry - nn
200000145e241c2c pn 210000145e241c2c portid=010400.
2008-11-22_06:36:44.26910 kern.warn: scsi(1): GID_PT entry - nn
2000001b3205b641 pn 2100001b3205b641 portid=010600.
2008-11-22_06:36:44.28411 kern.warn: scsi(1): GID_PT entry - nn
2000001b32056b41 pn 2100001b32056b41 portid=010700.
2008-11-22_06:36:44.28776 kern.warn: scsi(1): GID_PT entry - nn
200400a0b8293358 pn 202400a0b8293358 portid=010f00.
2008-11-22_06:36:44.28783 kern.warn: scsi(1): device wrap (010f00)
2008-11-22_06:36:44.30339 kern.warn: scsi(1): Trying Fabric Login w/loop id
0x0083 for port 010600.
2008-11-22_06:36:44.31129 kern.warn: scsi(1): LOOP READY
2008-11-22_06:36:44.31136 kern.warn: scsi(1): qla2x00_loop_resync - end
2008-11-22_06:36:44.34305 kern.warn: scsi(1): Asynchronous RSCR UPDATE.
2008-11-22_06:36:44.34306 kern.info: scsi(1): RSCN database changed -- 0001
0600.
2008-11-22_06:36:45.06317 kern.warn: scsi(1): Asynchronous RSCR UPDATE.
2008-11-22_06:36:45.06319 kern.info: scsi(1): RSCN database changed -- 0001
0600.
2008-11-22_06:36:45.17397 kern.warn: scsi(1): qla2x00_loop_resync()
2008-11-22_06:36:45.17404 kern.warn: scsi(1): F/W Ready - OK 
2008-11-22_06:36:45.18965 kern.warn: scsi(1): fw_state=3 curr time=69fc4fad.
2008-11-22_06:36:45.18972 kern.warn: scsi(1): Configure loop -- dpc flags
=0x40000a0
2008-11-22_06:36:45.20585 kern.warn: scsi(1): RSCN queue entry[1] =
[00/010600].
2008-11-22_06:36:45.20592 kern.warn: scsi(1): Skipping duplicate RSCN queue
entry found at [2].
2008-11-22_06:36:45.22195 kern.warn: scsi(1): RSCN queue entry[2] =
[00/010600].
2008-11-22_06:36:45.23816 kern.warn: scsi(1): GID_PT entry - nn
200000112593fc1c pn 210000112593fc1c portid=010100.
2008-11-22_06:36:45.24727 kern.warn: scsi(1): GID_PT entry - nn
200000112593f89c pn 210000112593f89c portid=010200.
2008-11-22_06:36:45.25633 kern.warn: scsi(1): GID_PT entry - nn
200000145e241c2c pn 210000145e241c2c portid=010400.
2008-11-22_06:36:45.26791 kern.warn: scsi(1): GID_PT entry - nn
2000001b3205b641 pn 2100001b3205b641 portid=010600.
2008-11-22_06:36:45.27679 kern.warn: scsi(1): GID_PT entry - nn
2000001b32056b41 pn 2100001b32056b41 portid=010700.
2008-11-22_06:36:45.28572 kern.warn: scsi(1): GID_PT entry - nn
200400a0b8293358 pn 202400a0b8293358 portid=010f00.
2008-11-22_06:36:45.28578 kern.warn: scsi(1): device wrap (010f00)
2008-11-22_06:36:45.30173 kern.warn: scsi(1): Trying Fabric Login w/loop id
0x0083 for port 010600.
2008-11-22_06:36:45.30980 kern.warn: scsi(1): LOOP READY
2008-11-22_06:36:45.30985 kern.warn: scsi(1): qla2x00_loop_resync - end
2008-11-22_06:37:45.99458 kern.warn: scsi(1): Asynchronous RSCR UPDATE.
2008-11-22_06:37:45.99466 kern.info: scsi(1): RSCN database changed -- 0001
0600.
2008-11-22_06:37:46.17424 kern.warn: scsi(1): qla2x00_loop_resync()
2008-11-22_06:37:46.17431 kern.warn: scsi(1): F/W Ready - OK 
2008-11-22_06:37:46.19055 kern.warn: scsi(1): fw_state=3 curr time=69fc8b3f.
2008-11-22_06:37:46.19062 kern.warn: scsi(1): Configure loop -- dpc flags
=0x40000a0
2008-11-22_06:37:46.20666 kern.warn: scsi(1): RSCN queue entry[3] =
[00/010600].
2008-11-22_06:37:46.22193 kern.warn: scsi(1): GID_PT entry - nn
200000112593fc1c pn 210000112593fc1c portid=010100.
2008-11-22_06:37:46.23109 kern.warn: scsi(1): GID_PT entry - nn
200000112593f89c pn 210000112593f89c portid=010200.
2008-11-22_06:37:46.24022 kern.warn: scsi(1): GID_PT entry - nn
200000145e241c2c pn 210000145e241c2c portid=010400.
2008-11-22_06:37:46.24921 kern.warn: scsi(1): GID_PT entry - nn
2000001b32056b41 pn 2100001b32056b41 portid=010700.
2008-11-22_06:37:46.25818 kern.warn: scsi(1): GID_PT entry - nn
200400a0b8293358 pn 202400a0b8293358 portid=010f00.
2008-11-22_06:37:46.25825 kern.warn: scsi(1): device wrap (010f00)
2008-11-22_06:37:46.27411 kern.warn: scsi(1): LOOP READY
2008-11-22_06:37:46.27418 kern.warn: scsi(1): qla2x00_loop_resync - end
2008-11-22_06:37:47.08468 kern.warn: scsi(1): Asynchronous RSCR UPDATE.
2008-11-22_06:37:47.08470 kern.info: scsi(1): RSCN database changed -- 0001
0600.
2008-11-22_06:37:47.17403 kern.warn: scsi(1): qla2x00_loop_resync()
2008-11-22_06:37:47.17410 kern.warn: scsi(1): F/W Ready - OK 
2008-11-22_06:37:47.18983 kern.warn: scsi(1): fw_state=3 curr time=69fc8c39.
2008-11-22_06:37:47.18994 kern.warn: scsi(1): Configure loop -- dpc flags
=0x40000a0
2008-11-22_06:37:47.20616 kern.warn: scsi(1): RSCN queue entry[4] =
[00/010600].
2008-11-22_06:37:47.22248 kern.warn: scsi(1): GID_PT entry - nn
200000112593fc1c pn 210000112593fc1c portid=010100.
2008-11-22_06:37:47.23159 kern.warn: scsi(1): GID_PT entry - nn
200000112593f89c pn 210000112593f89c portid=010200.
2008-11-22_06:37:47.24107 kern.warn: scsi(1): GID_PT entry - nn
200000145e241c2c pn 210000145e241c2c portid=010400.
2008-11-22_06:37:47.24995 kern.warn: scsi(1): GID_PT entry - nn
2000001b3205b641 pn 2100001b3205b641 portid=010600.
2008-11-22_06:37:47.25876 kern.warn: scsi(1): GID_PT entry - nn
2000001b32056b41 pn 2100001b32056b41 portid=010700.
2008-11-22_06:37:47.26760 kern.warn: scsi(1): GID_PT entry - nn
200400a0b8293358 pn 202400a0b8293358 portid=010f00.
2008-11-22_06:37:47.26766 kern.warn: scsi(1): device wrap (010f00)
2008-11-22_06:37:47.28333 kern.warn: scsi(1): Trying Fabric Login w/loop id
0x0083 for port 010600.
2008-11-22_06:37:47.29128 kern.warn: scsi(1): LOOP READY
2008-11-22_06:37:47.29135 kern.warn: scsi(1): qla2x00_loop_resync - end

I downgraded the buggy machine as a workaround to an earlier kernel hoping it
will fix the problems outlined here.

Regards,
   cstamas
--
Csillag Tamas (cstamas)
http://digitus.itk.ppke.hu/~cstamas


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
