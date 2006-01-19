From: Michael Reed <mdr@sgi.com>
Subject: qla2xxx: Recursion depth exceeded
Date: Thu, 19 Jan 2006 10:59:09 -0600
Message-ID: <43CFC55D.9080206@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:56023 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932285AbWASQ7Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 11:59:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>, Michael Reed <mdr@sgi.com>

This causes console input to stop being accepted and the inability to shutdown the system.


 QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
from the sles10-latest kernel received yesterday, which is essentially
2.6.15-git12.  This has rpfixes_2.diff already applied.

I did a switchdisable followed by a switchenable 5 seconds later.

Jan 19 10:35:16 duck klogd: qla2300 0012:00:02.1: LOOP DOWN detected (2).
Jan 19 10:35:16 duck klogd: qla2300 0012:00:02.0: LOOP DOWN detected (2).
Jan 19 10:35:16 duck klogd: qla2300 0012:00:01.1: LOOP DOWN detected (2).
Jan 19 10:35:16 duck klogd: qla2300 0012:00:01.0: LOOP DOWN detected (2).
Jan 19 10:35:16 duck klogd: qla2300 0002:01:06.0: LOOP DOWN detected (2).
Jan 19 10:35:16 duck klogd: qla2300 0002:01:04.1: LOOP DOWN detected (2).
Jan 19 10:35:16 duck klogd: qla2300 0002:01:06.1: LOOP DOWN detected (2).
Jan 19 10:35:16 duck klogd: qla2300 0002:01:04.0: LOOP DOWN detected (2).

Well, okay, SIX seconds later . :)

Jan 19 10:35:22 duck klogd: qla2300 0012:00:02.1: LIP reset occured (f800).
Jan 19 10:35:22 duck klogd: qla2300 0012:00:01.1: LIP reset occured (f800).
Jan 19 10:35:22 duck klogd: qla2300 0012:00:02.0: LIP reset occured (f800).
Jan 19 10:35:22 duck klogd: qla2300 0012:00:01.0: LIP reset occured (f800).
Jan 19 10:35:22 duck klogd: qla2300 0002:01:06.0: LIP reset occured (f800).
Jan 19 10:35:22 duck klogd: qla2300 0002:01:04.1: LIP reset occured (f800).
Jan 19 10:35:22 duck klogd: qla2300 0002:01:06.1: LIP reset occured (f800).
Jan 19 10:35:22 duck klogd: qla2300 0002:01:04.0: LIP reset occured (f800).
Jan 19 10:35:42 duck klogd: qla2300 0002:01:04.1: LIP reset occured (f7f7).
Jan 19 10:35:42 duck klogd: qla2300 0012:00:02.1: LIP reset occured (f800).
Jan 19 10:35:42 duck klogd: qla2300 0012:00:01.1: LIP reset occured (f800).
Jan 19 10:35:42 duck klogd: qla2300 0012:00:02.0: LIP reset occured (f7f7).
Jan 19 10:35:42 duck klogd: qla2300 0002:01:06.1: LIP reset occured (f7f7).
Jan 19 10:35:42 duck klogd: qla2300 0012:00:01.0: LIP reset occured (f7f7).
Jan 19 10:35:42 duck klogd: qla2300 0002:01:04.0: LIP reset occured (f7f7).
Jan 19 10:35:42 duck klogd: qla2300 0002:01:06.0: LIP reset occured (f7f7).
Jan 19 10:35:42 duck klogd: qla2300 0012:00:02.0: LOOP UP detected (2 Gbps).
Jan 19 10:35:42 duck klogd: qla2300 0012:00:01.0: LOOP UP detected (2 Gbps).
Jan 19 10:35:42 duck klogd: qla2300 0002:01:04.1: LOOP UP detected (2 Gbps).
Jan 19 10:35:43 duck klogd: qla2300 0002:01:06.1: LOOP UP detected (2 Gbps).
Jan 19 10:35:43 duck klogd: qla2300 0002:01:06.0: LOOP UP detected (2 Gbps).
Jan 19 10:35:43 duck klogd: qla2300 0002:01:04.0: LOOP UP detected (2 Gbps).
Jan 19 10:35:43 duck klogd: qla2300 0012:00:02.1: LOOP UP detected (2 Gbps).
Jan 19 10:35:43 duck klogd: qla2300 0012:00:01.1: LOOP UP detected (2 Gbps).
Jan 19 10:35:45 duck klogd: run_workqueue: recursion depth exceeded: 4
Jan 19 10:35:45 duck klogd:
Jan 19 10:35:45 duck klogd: Call Trace:
Jan 19 10:35:45 duck klogd:  [<a000000100012b00>] show_stack+0x40/0xa0
Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35f9e0 bsp=e00000b07a3593b0
Jan 19 10:35:45 duck klogd:  [<a000000100012b90>] dump_stack+0x30/0x60
Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fbb0 bsp=e00000b07a359398
Jan 19 10:35:45 duck klogd:  [<a0000001000c9d90>] run_workqueue+0x90/0x280
Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fbb0 bsp=e00000b07a359358
Jan 19 10:35:45 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fbb0 bsp=e00000b07a359328
Jan 19 10:35:45 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a359300
Jan 19 10:35:45 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a3592e8
Jan 19 10:35:45 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a3592b8
Jan 19 10:35:45 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a359280
Jan 19 10:35:49 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:49 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a359258
Jan 19 10:35:49 duck klogd: run_workqueue: recursion depth exceeded: 4
Jan 19 10:35:49 duck klogd:
Jan 19 10:35:49 duck klogd: Call Trace:
Jan 19 10:35:49 duck klogd:  [<a000000100012b00>] show_stack+0x40/0xa0
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3f9e0 bsp=e00000b003f393b0
Jan 19 10:35:49 duck klogd:  [<a000000100012b90>] dump_stack+0x30/0x60
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39398
Jan 19 10:35:49 duck klogd:  [<a0000001000c9d90>] run_workqueue+0x90/0x280
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39358
Jan 19 10:35:49 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39328
Jan 19 10:35:49 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39300
Jan 19 10:35:49 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f392e8
Jan 19 10:35:49 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f392b8
Jan 19 10:35:49 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39280
Jan 19 10:35:49 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39258
Jan 19 10:35:49 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39230
Jan 19 10:35:49 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f391e8
Jan 19 10:35:49 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f391b8
Jan 19 10:35:49 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39190
Jan 19 10:35:49 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39178
Jan 19 10:35:49 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39148
Jan 19 10:35:49 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39110
Jan 19 10:35:49 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:49 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f390e8
Jan 19 10:35:50 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f390c0
Jan 19 10:35:50 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39080
Jan 19 10:35:50 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39050
Jan 19 10:35:50 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f39028
Jan 19 10:35:50 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f39010
Jan 19 10:35:50 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38fd8
Jan 19 10:35:50 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38fa0
Jan 19 10:35:50 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f78
Jan 19 10:35:50 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f50
Jan 19 10:35:50 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f10
Jan 19 10:35:50 duck klogd:  [<a0000001000cafb0>] worker_thread+0x1d0/0x260
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38ee0
Jan 19 10:35:50 duck klogd:  [<a0000001000d36c0>] kthread+0x220/0x2a0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fd50 bsp=e00000b003f38e98
Jan 19 10:35:50 duck klogd:  [<a000000100011090>] kernel_thread_helper+0xd0/0x100
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fe30 bsp=e00000b003f38e70
Jan 19 10:35:50 duck klogd:  [<a000000100009120>] start_kernel_thread+0x20/0x40
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fe30 bsp=e00000b003f38e70
Jan 19 10:35:50 duck klogd: run_workqueue: recursion depth exceeded: 5
Jan 19 10:35:50 duck klogd:
Jan 19 10:35:50 duck klogd: Call Trace:
Jan 19 10:35:50 duck klogd:  [<a000000100012b00>] show_stack+0x40/0xa0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3f980 bsp=e00000b003f39520
Jan 19 10:35:50 duck klogd:  [<a000000100012b90>] dump_stack+0x30/0x60
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39508
Jan 19 10:35:50 duck klogd:  [<a0000001000c9d90>] run_workqueue+0x90/0x280
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f394c8
Jan 19 10:35:50 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39498
Jan 19 10:35:50 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39470
Jan 19 10:35:50 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39458
Jan 19 10:35:50 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39428
Jan 19 10:35:50 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f393e8
Jan 19 10:35:50 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f393c0
Jan 19 10:35:50 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39398
Jan 19 10:35:50 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39358
Jan 19 10:35:50 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39328
Jan 19 10:35:50 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39300
Jan 19 10:35:50 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f392e8
Jan 19 10:35:50 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f392b8
Jan 19 10:35:50 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39280
Jan 19 10:35:50 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39258
Jan 19 10:35:50 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39230
Jan 19 10:35:50 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:50 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f391e8
Jan 19 10:35:50 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f391b8
Jan 19 10:35:51 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39190
Jan 19 10:35:51 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39178
Jan 19 10:35:51 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39148
Jan 19 10:35:51 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39110
Jan 19 10:35:51 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f390e8
Jan 19 10:35:51 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f390c0
Jan 19 10:35:51 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39080
Jan 19 10:35:51 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39050
Jan 19 10:35:51 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f39028
Jan 19 10:35:51 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f39010
Jan 19 10:35:51 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38fd8
Jan 19 10:35:51 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38fa0
Jan 19 10:35:51 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f78
Jan 19 10:35:51 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f50
Jan 19 10:35:51 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f10
Jan 19 10:35:51 duck klogd:  [<a0000001000cafb0>] worker_thread+0x1d0/0x260
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38ee0
Jan 19 10:35:51 duck klogd:  [<a0000001000d36c0>] kthread+0x220/0x2a0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fd50 bsp=e00000b003f38e98
Jan 19 10:35:51 duck klogd:  [<a000000100011090>] kernel_thread_helper+0xd0/0x100
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fe30 bsp=e00000b003f38e70
Jan 19 10:35:51 duck klogd:  [<a000000100009120>] start_kernel_thread+0x20/0x40
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fe30 bsp=e00000b003f38e70
Jan 19 10:35:51 duck klogd: run_workqueue: recursion depth exceeded: 6
Jan 19 10:35:51 duck klogd:
Jan 19 10:35:51 duck klogd: Call Trace:
Jan 19 10:35:51 duck klogd:  [<a000000100012b00>] show_stack+0x40/0xa0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3f920 bsp=e00000b003f39690
Jan 19 10:35:51 duck klogd:  [<a000000100012b90>] dump_stack+0x30/0x60
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f39678
Jan 19 10:35:51 duck klogd:  [<a0000001000c9d90>] run_workqueue+0x90/0x280
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f39638
Jan 19 10:35:51 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f39608
Jan 19 10:35:51 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f395d8
Jan 19 10:35:51 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f395c0
Jan 19 10:35:51 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39590
Jan 19 10:35:51 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39558
Jan 19 10:35:51 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39530
Jan 19 10:35:51 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39508
Jan 19 10:35:51 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f394c8
Jan 19 10:35:51 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39498
Jan 19 10:35:51 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39470
Jan 19 10:35:51 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39458
Jan 19 10:35:51 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39428
Jan 19 10:35:51 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f393e8
Jan 19 10:35:51 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f393c0
Jan 19 10:35:51 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39398
Jan 19 10:35:51 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39358
Jan 19 10:35:51 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39328
Jan 19 10:35:51 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:51 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39300
Jan 19 10:35:52 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f392e8
Jan 19 10:35:52 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f392b8
Jan 19 10:35:52 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39280
Jan 19 10:35:52 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39258
Jan 19 10:35:52 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39230
Jan 19 10:35:52 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f391e8
Jan 19 10:35:52 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f391b8
Jan 19 10:35:52 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39190
Jan 19 10:35:52 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39178
Jan 19 10:35:52 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39148
Jan 19 10:35:52 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39110
Jan 19 10:35:52 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f390e8
Jan 19 10:35:52 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f390c0
Jan 19 10:35:52 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39080
Jan 19 10:35:52 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39050
Jan 19 10:35:52 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f39028
Jan 19 10:35:52 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f39010
Jan 19 10:35:52 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38fd8
Jan 19 10:35:52 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38fa0
Jan 19 10:35:52 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f78
Jan 19 10:35:52 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f50
Jan 19 10:35:52 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f10
Jan 19 10:35:52 duck klogd:  [<a0000001000cafb0>] worker_thread+0x1d0/0x260
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38ee0
Jan 19 10:35:52 duck klogd:  [<a0000001000d36c0>] kthread+0x220/0x2a0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fd50 bsp=e00000b003f38e98
Jan 19 10:35:52 duck klogd:  [<a000000100011090>] kernel_thread_helper+0xd0/0x100
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fe30 bsp=e00000b003f38e70
Jan 19 10:35:52 duck klogd:  [<a000000100009120>] start_kernel_thread+0x20/0x40
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fe30 bsp=e00000b003f38e70
Jan 19 10:35:52 duck klogd: run_workqueue: recursion depth exceeded: 7
Jan 19 10:35:52 duck klogd:
Jan 19 10:35:52 duck klogd: Call Trace:
Jan 19 10:35:52 duck klogd:  [<a000000100012b00>] show_stack+0x40/0xa0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3f8c0 bsp=e00000b003f39800
Jan 19 10:35:52 duck klogd:  [<a000000100012b90>] dump_stack+0x30/0x60
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fa90 bsp=e00000b003f397e0
Jan 19 10:35:52 duck klogd:  [<a0000001000c9d90>] run_workqueue+0x90/0x280
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fa90 bsp=e00000b003f397a0
Jan 19 10:35:52 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fa90 bsp=e00000b003f39770
Jan 19 10:35:52 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f39748
Jan 19 10:35:52 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f39730
Jan 19 10:35:52 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f39700
Jan 19 10:35:52 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f396c8
Jan 19 10:35:52 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f396a0
Jan 19 10:35:52 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f39678
Jan 19 10:35:52 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f39638
Jan 19 10:35:52 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3faf0 bsp=e00000b003f39608
Jan 19 10:35:52 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f395d8
Jan 19 10:35:52 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:52 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f395c0
Jan 19 10:35:53 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39590
Jan 19 10:35:53 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39558
Jan 19 10:35:53 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39530
Jan 19 10:35:53 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39508
Jan 19 10:35:53 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f394c8
Jan 19 10:35:53 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fb50 bsp=e00000b003f39498
Jan 19 10:35:53 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39470
Jan 19 10:35:53 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39458
Jan 19 10:35:53 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39428
Jan 19 10:35:53 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f393e8
Jan 19 10:35:53 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f393c0
Jan 19 10:35:53 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39398
Jan 19 10:35:53 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39358
Jan 19 10:35:53 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fbb0 bsp=e00000b003f39328
Jan 19 10:35:53 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39300
Jan 19 10:35:53 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f392e8
Jan 19 10:35:53 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f392b8
Jan 19 10:35:53 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39280
Jan 19 10:35:53 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39258
Jan 19 10:35:53 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f39230
Jan 19 10:35:53 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f391e8
Jan 19 10:35:53 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc10 bsp=e00000b003f391b8
Jan 19 10:35:53 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39190
Jan 19 10:35:53 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39178
Jan 19 10:35:53 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39148
Jan 19 10:35:53 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39110
Jan 19 10:35:53 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f390e8
Jan 19 10:35:53 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f390c0
Jan 19 10:35:53 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39080
Jan 19 10:35:53 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fc70 bsp=e00000b003f39050
Jan 19 10:35:53 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f39028
Jan 19 10:35:53 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f39010
Jan 19 10:35:53 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38fd8
Jan 19 10:35:53 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38fa0
Jan 19 10:35:53 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f78
Jan 19 10:35:53 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f50
Jan 19 10:35:53 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38f10
Jan 19 10:35:53 duck klogd:  [<a0000001000cafb0>] worker_thread+0x1d0/0x260
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fcd0 bsp=e00000b003f38ee0
Jan 19 10:35:53 duck klogd:  [<a0000001000d36c0>] kthread+0x220/0x2a0
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fd50 bsp=e00000b003f38e98
Jan 19 10:35:53 duck klogd:  [<a000000100011090>] kernel_thread_helper+0xd0/0x100
Jan 19 10:35:53 duck klogd:                                 sp=e00000b003f3fe30 bsp=e00000b003f38e70
Jan 19 10:35:53 duck klogd:  [<a000000100009120>] start_kernel_thread+0x20/0x40
Jan 19 10:35:54 duck klogd:                                 sp=e00000b003f3fe30 bsp=e00000b003f38e70
Jan 19 10:35:54 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a359230
Jan 19 10:35:54 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a3591e8
Jan 19 10:35:54 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a3591b8
Jan 19 10:35:54 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc70 bsp=e00000b07a359190
Jan 19 10:35:54 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc70 bsp=e00000b07a359178
Jan 19 10:35:54 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc70 bsp=e00000b07a359148
Jan 19 10:35:54 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc70 bsp=e00000b07a359110
Jan 19 10:35:54 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc70 bsp=e00000b07a3590e8
Jan 19 10:35:54 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc70 bsp=e00000b07a3590c0
Jan 19 10:35:54 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc70 bsp=e00000b07a359080
Jan 19 10:35:54 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fc70 bsp=e00000b07a359050
Jan 19 10:35:54 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fcd0 bsp=e00000b07a359028
Jan 19 10:35:54 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fcd0 bsp=e00000b07a359010
Jan 19 10:35:54 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fcd0 bsp=e00000b07a358fd8
Jan 19 10:35:54 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fcd0 bsp=e00000b07a358fa0
Jan 19 10:35:54 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fcd0 bsp=e00000b07a358f78
Jan 19 10:35:54 duck klogd:  [<a00000010056f090>] qla2x00_rport_del+0x70/0xa0
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fcd0 bsp=e00000b07a358f50
Jan 19 10:35:54 duck klogd:  [<a0000001000c9ec0>] run_workqueue+0x1c0/0x280
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fcd0 bsp=e00000b07a358f10
Jan 19 10:35:54 duck klogd:  [<a0000001000cafb0>] worker_thread+0x1d0/0x260
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fcd0 bsp=e00000b07a358ee0
Jan 19 10:35:54 duck klogd:  [<a0000001000d36c0>] kthread+0x220/0x2a0
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fd50 bsp=e00000b07a358e98
Jan 19 10:35:54 duck klogd:  [<a000000100011090>] kernel_thread_helper+0xd0/0x100
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fe30 bsp=e00000b07a358e70
Jan 19 10:35:54 duck klogd:  [<a000000100009120>] start_kernel_thread+0x20/0x40
Jan 19 10:35:54 duck klogd:                                 sp=e00000b07a35fe30 bsp=e00000b07a358e70


Broadcast message from root (pts/0) (Thu Jan 19 10:42:15 2006):

The system is going down for reboot NOW!
INIT: Sending processes the TERM signal
INIT: Sending processes the KILL signal
INIT: Pid 10642 [id 1] seems to hang
INIT: Pid 10643 [id 2] seems to hang
INIT: Pid 10644 [id 3] seems to hang
INIT: Pid 10645 [id 4] seems to hang
INIT: Pid 10646 [id 5] seems to hang
INIT: Pid 10647 [id 6] seems to hang
Boot logging started on /dev/ttySG0(/dev/console) at Thu Jan 19 10:42:22 2006
Master Resource Control: previous runlevel: 3, switching to runlevel: 6

root         1     0  1 10:24 ?        00:00:19 init [6]
root         2     1  0 10:24 ?        00:00:00 [migration/0]
root         3     1  0 10:24 ?        00:00:00 [ksoftirqd/0]
root         4     1  0 10:24 ?        00:00:00 [watchdog/0]
root         5     1  0 10:24 ?        00:00:00 [migration/1]
root         6     1  0 10:24 ?        00:00:00 [ksoftirqd/1]


0xe0000034f7698000      751        1  0    0   D  0xe0000034f7698380  qla2300_2_dpc
0xe0000034f7668000      825        1  0    0   D  0xe0000034f7668380  qla2300_3_dpc
0xe0000034f6300000      903        1  0    0   D  0xe0000034f6300380  qla2300_4_dpc
0xe0000034f63f8000      977        1  0    0   D  0xe0000034f63f8380  qla2300_5_dpc
0xe00000b078248000     1054        1  0    2   D  0xe00000b078248380  qla2300_6_dpc
0xe00000b078270000     1135        1  0    3   D  0xe00000b078270380  qla2300_7_dpc
0xe00000b078528000     1218        1  0    2   D  0xe00000b078528380  qla2300_8_dpc
0xe00000b078810000     1304        1  0    3   D  0xe00000b078810380  qla2300_9_dpc


[0]kdb> btp 1304
Stack traceback for pid 1304
0xe00000b078810000     1304        1  0    3   D  0xe00000b078810380  qla2300_9_dpc
0xa000000100717990 schedule+0x2290
        args (0xe00000b00393de00, 0xa0000001000ca0b0, 0x309, 0xa0000001000ca0a0, 0x1)
0xa0000001000ca0c0 flush_cpu_workqueue+0x140
        args (0xe00000b00393de00, 0x225, 0xe00000b078810000, 0xa0000001000ca220, 0x288)
0xa0000001000ca220 flush_workqueue+0xc0
        args (0xe000003007114700, 0x0, 0xa0000001000ca3e0, 0x184, 0x205)
0xa0000001000ca3e0 flush_scheduled_work+0x20
        args (0xa000000100554570, 0x307, 0x307)
0xa000000100554570 fc_rport_tgt_remove+0xf0
        args (0xe00000b07a1cb600, 0xe00000b07a1cb878, 0xe00000b07853c000, 0xa000000100554820, 0x389)
0xa000000100554820 fc_rport_terminate+0xa0
        args (0xe00000b07a1cb600, 0xe00000b07a1cb650, 0xe00000b07853c058, 0xe00000b07853c000, 0xa000000100554950)
0xa000000100554950 fc_remote_port_delete+0x50
        args (0xe00000b07a1cb600, 0x3a98, 0xa00000010056f090, 0x287, 0xe00000b07853c4e8)
0xa00000010056f090 qla2x00_rport_del+0x70
        args (0xe00000b07a1c75f0, 0xe00000b07a1cb600, 0xa00000010056f100, 0x48c, 0x48f)
0xa00000010056f100 qla2x00_reg_remote_port+0x40
        args (0xe00000b07853c4b8, 0xe00000b07a1c7580, 0x3, 0x3, 0xfffffff0)
0xa00000010056f6b0 qla2x00_update_fcport+0x1f0
        args (0xe00000b07853c4b8, 0xe00000b07a1c7580, 0xe00000b07853c4b8, 0xa00000010056f820, 0x30b)
[0]more>
0xa00000010056f820 qla2x00_fabric_dev_login+0x140
        args (0xe00000b07853c4b8, 0xe00000b07a1c7580, 0x0, 0xa000000100571f40, 0x694)
0xa000000100571f40 qla2x00_configure_loop+0x2320
        args (0xe00000b07853c4b8, 0xe00000b07a1c7580, 0xe00000b07853e6e8, 0xe00000b07a1c41b4, 0xe00000b07a1c7580)
0xa000000100574210 qla2x00_loop_resync+0x1b0
        args (0xff, 0x0, 0xa0000001005692b0, 0x30b, 0x40000a0)
0xa0000001005692b0 qla2x00_do_dpc+0xb30
        args (0xe00000b07853c4b8, 0x4000090, 0x4000090, 0xa000000100011090, 0x286)
0xa000000100011090 kernel_thread_helper+0xd0
        args (0xa00000010083f8f0, 0xe00000b07853c4b8, 0xa000000100009120, 0x2, 0xa000000100d115c0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010083f8f0, 0xe00000b07853c4b8)



[0]kdb> btp 1218
Stack traceback for pid 1218
0xe00000b078528000     1218        1  0    2   D  0xe00000b078528380  qla2300_8_dpc
0xa000000100717990 schedule+0x2290
        args (0xe00000b00393de00, 0xa0000001000ca0b0, 0x309, 0xa0000001000ca0a0, 0x1)
0xa0000001000ca0c0 flush_cpu_workqueue+0x140
        args (0xe00000b00393de00, 0x226, 0xe00000b078528000, 0xa0000001000ca220, 0x288)
0xa0000001000ca220 flush_workqueue+0xc0
        args (0xe000003007114700, 0x0, 0xa0000001000ca3e0, 0x184, 0x205)
0xa0000001000ca3e0 flush_scheduled_work+0x20
        args (0xa000000100554570, 0x307, 0x307)
0xa000000100554570 fc_rport_tgt_remove+0xf0
        args (0xe00000b003f52600, 0xe00000b003f52878, 0xe00000b078234000, 0xa000000100554820, 0x389)
0xa000000100554820 fc_rport_terminate+0xa0
        args (0xe00000b003f52600, 0xe00000b003f52650, 0xe00000b078234058, 0xe00000b078234000, 0xa000000100554950)
0xa000000100554950 fc_remote_port_delete+0x50
        args (0xe00000b003f52600, 0x3a98, 0xa00000010056f090, 0x287, 0xe00000b0782344e8)
0xa00000010056f090 qla2x00_rport_del+0x70
        args (0xe00000b07a3897f0, 0xe00000b003f52600, 0xa00000010056f100, 0x48c, 0x48f)
0xa00000010056f100 qla2x00_reg_remote_port+0x40
        args (0xe00000b0782344b8, 0xe00000b07a389780, 0x3, 0x3, 0xfffffff0)
0xa00000010056f6b0 qla2x00_update_fcport+0x1f0
        args (0xe00000b0782344b8, 0xe00000b07a389780, 0xe00000b0782344b8, 0xa00000010056f820, 0x30b)
[0]more>
0xa00000010056f820 qla2x00_fabric_dev_login+0x140
        args (0xe00000b0782344b8, 0xe00000b07a389780, 0x0, 0xa000000100571f40, 0x694)
0xa000000100571f40 qla2x00_configure_loop+0x2320
        args (0xe00000b0782344b8, 0xe00000b07a389780, 0xe00000b0782366e8, 0xe00000b078524734, 0xe00000b07a389780)
0xa000000100574210 qla2x00_loop_resync+0x1b0
        args (0xfd, 0x0, 0xa0000001005692b0, 0x30b, 0x40000a0)
0xa0000001005692b0 qla2x00_do_dpc+0xb30
        args (0xe00000b0782344b8, 0x4000090, 0x4000090, 0xa000000100011090, 0x286)
0xa000000100011090 kernel_thread_helper+0xd0
        args (0xa00000010083f8f0, 0xe00000b0782344b8, 0xa000000100009120, 0x2, 0xa000000100d115c0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010083f8f0, 0xe00000b0782344b8)




[0]kdb> btp 1135
Stack traceback for pid 1135
0xe00000b078270000     1135        1  0    3   D  0xe00000b078270380  qla2300_7_dpc
0xa000000100717990 schedule+0x2290
        args (0xe00000b00393de80, 0xa0000001000ca0b0, 0x309, 0xa0000001000ca0a0, 0x1)
0xa0000001000ca0c0 flush_cpu_workqueue+0x140
        args (0xe00000b00393de80, 0x1f4, 0xe00000b078270000, 0xa0000001000ca220, 0x288)
0xa0000001000ca220 flush_workqueue+0xc0
        args (0xe000003007114700, 0x2, 0xa0000001000ca3e0, 0x184, 0x205)
0xa0000001000ca3e0 flush_scheduled_work+0x20
        args (0xa000000100554570, 0x307, 0x307)
0xa000000100554570 fc_rport_tgt_remove+0xf0
        args (0xe00000b0781ab580, 0xe00000b0781ab7f8, 0xe00000b07a23c000, 0xa000000100554820, 0x389)
0xa000000100554820 fc_rport_terminate+0xa0
        args (0xe00000b0781ab580, 0xe00000b0781ab5d0, 0xe00000b07a23c058, 0xe00000b07a23c000, 0xa000000100554950)
0xa000000100554950 fc_remote_port_delete+0x50
        args (0xe00000b0781ab580, 0x3a98, 0xa00000010056f090, 0x287, 0xe00000b07a23c4e8)
0xa00000010056f090 qla2x00_rport_del+0x70
        args (0xe00000b07a23b970, 0xe00000b0781ab580, 0xa00000010056f100, 0x48c, 0x48f)
0xa00000010056f100 qla2x00_reg_remote_port+0x40
        args (0xe00000b07a23c4b8, 0xe00000b07a23b900, 0x3, 0x3, 0xfffffff0)
0xa00000010056f6b0 qla2x00_update_fcport+0x1f0
        args (0xe00000b07a23c4b8, 0xe00000b07a23b900, 0xe00000b07a23c4b8, 0xa00000010056f820, 0x30b)
[0]more>
0xa00000010056f820 qla2x00_fabric_dev_login+0x140
        args (0xe00000b07a23c4b8, 0xe00000b07a23b900, 0x0, 0xa000000100571f40, 0x694)
0xa000000100571f40 qla2x00_configure_loop+0x2320
        args (0xe00000b07a23c4b8, 0xe00000b07a23b900, 0xe00000b07a23e6e8, 0xe00000b07884f934, 0xe00000b07a23bb00)
0xa000000100574210 qla2x00_loop_resync+0x1b0
        args (0xfe, 0x0, 0xa0000001005692b0, 0x30b, 0x40000a0)
0xa0000001005692b0 qla2x00_do_dpc+0xb30
        args (0xe00000b07a23c4b8, 0x4000090, 0x4000090, 0xa000000100011090, 0x286)
0xa000000100011090 kernel_thread_helper+0xd0
        args (0xa00000010083f8f0, 0xe00000b07a23c4b8, 0xa000000100009120, 0x2, 0xa000000100d115c0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010083f8f0, 0xe00000b07a23c4b8)



[0]kdb> btp 1054
Stack traceback for pid 1054
0xe00000b078248000     1054        1  0    2   D  0xe00000b078248380  qla2300_6_dpc
0xa000000100717990 schedule+0x2290
        args (0xe00000b00393de00, 0xa0000001000ca0b0, 0x309, 0xa0000001000ca0a0, 0x1)
0xa0000001000ca0c0 flush_cpu_workqueue+0x140
        args (0xe00000b00393de00, 0x226, 0xe00000b078248000, 0xa0000001000ca220, 0x288)
0xa0000001000ca220 flush_workqueue+0xc0
        args (0xe000003007114700, 0x0, 0xa0000001000ca3e0, 0x184, 0x205)
0xa0000001000ca3e0 flush_scheduled_work+0x20
        args (0xa000000100554570, 0x307, 0x307)
0xa000000100554570 fc_rport_tgt_remove+0xf0
        args (0xe00000b00396f880, 0xe00000b00396faf8, 0xe00000b07a0d0000, 0xa000000100554820, 0x389)
0xa000000100554820 fc_rport_terminate+0xa0
        args (0xe00000b00396f880, 0xe00000b00396f8d0, 0xe00000b07a0d0058, 0xe00000b07a0d0000, 0xa000000100554950)
0xa000000100554950 fc_remote_port_delete+0x50
        args (0xe00000b00396f880, 0x3a98, 0xa00000010056f090, 0x287, 0xe00000b07a0d04e8)
0xa00000010056f090 qla2x00_rport_del+0x70
        args (0xe00000b0781d1570, 0xe00000b00396f880, 0xa00000010056f100, 0x48c, 0x48f)
0xa00000010056f100 qla2x00_reg_remote_port+0x40
        args (0xe00000b07a0d04b8, 0xe00000b0781d1500, 0x3, 0x3, 0xfffffff0)
0xa00000010056f6b0 qla2x00_update_fcport+0x1f0
        args (0xe00000b07a0d04b8, 0xe00000b0781d1500, 0xe00000b07a0d04b8, 0xa00000010056f820, 0x30b)
[0]more>
0xa00000010056f820 qla2x00_fabric_dev_login+0x140
        args (0xe00000b07a0d04b8, 0xe00000b0781d1500, 0x0, 0xa000000100571f40, 0x694)
0xa000000100571f40 qla2x00_configure_loop+0x2320
        args (0xe00000b07a0d04b8, 0xe00000b0781d1500, 0xe00000b07a0d26e8, 0xe00000b078524334, 0xe00000b0781d1500)
0xa000000100574210 qla2x00_loop_resync+0x1b0
        args (0xfe, 0x0, 0xa0000001005692b0, 0x30b, 0x40000a0)
0xa0000001005692b0 qla2x00_do_dpc+0xb30
        args (0xe00000b07a0d04b8, 0x4000090, 0x4000090, 0xa000000100011090, 0x286)
0xa000000100011090 kernel_thread_helper+0xd0
        args (0xa00000010083f8f0, 0xe00000b07a0d04b8, 0xa000000100009120, 0x2, 0xa000000100d115c0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010083f8f0, 0xe00000b07a0d04b8)



[0]kdb> btp 977
Stack traceback for pid 977
0xe0000034f63f8000      977        1  0    0   D  0xe0000034f63f8380  qla2300_5_dpc
0xa000000100717990 schedule+0x2290
        args (0xe00000b00393de00, 0xa0000001000ca0b0, 0x309, 0xa0000001000ca0a0, 0x1)
0xa0000001000ca0c0 flush_cpu_workqueue+0x140
        args (0xe00000b00393de00, 0x222, 0xe0000034f63f8000, 0xa0000001000ca220, 0x288)
0xa0000001000ca220 flush_workqueue+0xc0
        args (0xe000003007114700, 0x0, 0xa0000001000ca3e0, 0x184, 0x205)
0xa0000001000ca3e0 flush_scheduled_work+0x20
        args (0xa000000100554570, 0x307, 0x307)
0xa000000100554570 fc_rport_tgt_remove+0xf0
        args (0xe0000034f668b580, 0xe0000034f668b7f8, 0xe0000034f63f4000, 0xa000000100554820, 0x389)
0xa000000100554820 fc_rport_terminate+0xa0
        args (0xe0000034f668b580, 0xe0000034f668b5d0, 0xe0000034f63f4058, 0xe0000034f63f4000, 0xa000000100554950)
0xa000000100554950 fc_remote_port_delete+0x50
        args (0xe0000034f668b580, 0x3a98, 0xa00000010056f090, 0x287, 0xe0000034f63f44e8)
0xa00000010056f090 qla2x00_rport_del+0x70
        args (0xe0000034f61f5d70, 0xe0000034f668b580, 0xa00000010056f100, 0x48c, 0x48f)
0xa00000010056f100 qla2x00_reg_remote_port+0x40
        args (0xe0000034f63f44b8, 0xe0000034f61f5d00, 0x3, 0x3, 0xfffffff0)
0xa00000010056f6b0 qla2x00_update_fcport+0x1f0
        args (0xe0000034f63f44b8, 0xe0000034f61f5d00, 0xe0000034f63f44b8, 0xa00000010056f820, 0x30b)
[0]more>
0xa00000010056f820 qla2x00_fabric_dev_login+0x140
        args (0xe0000034f63f44b8, 0xe0000034f61f5d00, 0x0, 0xa000000100571f40, 0x694)
0xa000000100571f40 qla2x00_configure_loop+0x2320
        args (0xe0000034f63f44b8, 0xe0000034f61f5d00, 0xe0000034f63f66e8, 0xe0000034f635f1b4, 0xe0000034f61f5d00)
0xa000000100574210 qla2x00_loop_resync+0x1b0
        args (0xfe, 0x0, 0xa0000001005692b0, 0x30b, 0x40000a0)
0xa0000001005692b0 qla2x00_do_dpc+0xb30
        args (0xe0000034f63f44b8, 0x4000090, 0x4000090, 0xa000000100011090, 0x286)
0xa000000100011090 kernel_thread_helper+0xd0
        args (0xa00000010083f8f0, 0xe0000034f63f44b8, 0xa000000100009120, 0x2, 0xa000000100d115c0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010083f8f0, 0xe0000034f63f44b8)



Stack traceback for pid 751
0xe0000034f7698000      751        1  0    0   D  0xe0000034f7698380  qla2300_2_dpc
0xa000000100717990 schedule+0x2290
        args (0xe00000b00393de00, 0xa0000001000ca0b0, 0x309, 0xa0000001000ca0a0, 0x1)
0xa0000001000ca0c0 flush_cpu_workqueue+0x140
        args (0xe00000b00393de00, 0x21f, 0xe0000034f7698000, 0xa0000001000ca220, 0x288)
0xa0000001000ca220 flush_workqueue+0xc0
        args (0xe000003007114700, 0x0, 0xa0000001000ca3e0, 0x184, 0x205)
0xa0000001000ca3e0 flush_scheduled_work+0x20
        args (0xa000000100554570, 0x307, 0x307)
0xa000000100554570 fc_rport_tgt_remove+0xf0
        args (0xe0000034f75b0200, 0xe0000034f75b0478, 0xe0000034f7678000, 0xa000000100554820, 0x389)
0xa000000100554820 fc_rport_terminate+0xa0
        args (0xe0000034f75b0200, 0xe0000034f75b0250, 0xe0000034f7678058, 0xe0000034f7678000, 0xa000000100554950)
0xa000000100554950 fc_remote_port_delete+0x50
        args (0xe0000034f75b0200, 0x3a98, 0xa00000010056f090, 0x287, 0xe0000034f76784e8)
0xa00000010056f090 qla2x00_rport_del+0x70
        args (0xe0000034f6692970, 0xe0000034f75b0200, 0xa00000010056f100, 0x48c, 0x48f)
0xa00000010056f100 qla2x00_reg_remote_port+0x40
        args (0xe0000034f76784b8, 0xe0000034f6692900, 0x3, 0x3, 0xfffffff0)
0xa00000010056f6b0 qla2x00_update_fcport+0x1f0
        args (0xe0000034f76784b8, 0xe0000034f6692900, 0xe0000034f76784b8, 0xa00000010056f820, 0x30b)
[0]more>
0xa00000010056f820 qla2x00_fabric_dev_login+0x140
        args (0xe0000034f76784b8, 0xe0000034f6692900, 0x0, 0xa000000100571f40, 0x694)
0xa000000100571f40 qla2x00_configure_loop+0x2320
        args (0xe0000034f76784b8, 0xe0000034f6692900, 0xe0000034f767a6e8, 0xe0000034f7589db4, 0xe0000034f7556780)
0xa000000100574210 qla2x00_loop_resync+0x1b0
        args (0xff, 0x0, 0xa0000001005692b0, 0x30b, 0x40000a0)
0xa0000001005692b0 qla2x00_do_dpc+0xb30
        args (0xe0000034f76784b8, 0x4000090, 0x4000090, 0xa000000100011090, 0x286)
0xa000000100011090 kernel_thread_helper+0xd0
        args (0xa00000010083f8f0, 0xe0000034f76784b8, 0xa000000100009120, 0x2, 0xa000000100d115c0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010083f8f0, 0xe0000034f76784b8)



[0]kdb> btp 825
Stack traceback for pid 825
0xe0000034f7668000      825        1  0    0   D  0xe0000034f7668380  qla2300_3_dpc
0xa000000100717990 schedule+0x2290
        args (0xe00000b00393de00, 0xa0000001000ca0b0, 0x309, 0xa0000001000ca0a0, 0x1)
0xa0000001000ca0c0 flush_cpu_workqueue+0x140
        args (0xe00000b00393de00, 0x21f, 0xe0000034f7668000, 0xa0000001000ca220, 0x288)
0xa0000001000ca220 flush_workqueue+0xc0
        args (0xe000003007114700, 0x0, 0xa0000001000ca3e0, 0x184, 0x205)
0xa0000001000ca3e0 flush_scheduled_work+0x20
        args (0xa000000100554570, 0x307, 0x307)
0xa000000100554570 fc_rport_tgt_remove+0xf0
        args (0xe0000034f75b1a00, 0xe0000034f75b1c78, 0xe0000034f63e4000, 0xa000000100554820, 0x389)
0xa000000100554820 fc_rport_terminate+0xa0
        args (0xe0000034f75b1a00, 0xe0000034f75b1a50, 0xe0000034f63e4058, 0xe0000034f63e4000, 0xa000000100554950)
0xa000000100554950 fc_remote_port_delete+0x50
        args (0xe0000034f75b1a00, 0x3a98, 0xa00000010056f090, 0x287, 0xe0000034f63e44e8)
0xa00000010056f090 qla2x00_rport_del+0x70
        args (0xe0000034f63dc5f0, 0xe0000034f75b1a00, 0xa00000010056f100, 0x48c, 0x48f)
0xa00000010056f100 qla2x00_reg_remote_port+0x40
        args (0xe0000034f63e44b8, 0xe0000034f63dc580, 0x3, 0x3, 0xfffffff0)
0xa00000010056f6b0 qla2x00_update_fcport+0x1f0
        args (0xe0000034f63e44b8, 0xe0000034f63dc580, 0xe0000034f63e44b8, 0xa00000010056f820, 0x30b)
[0]more>
0xa00000010056f820 qla2x00_fabric_dev_login+0x140
        args (0xe0000034f63e44b8, 0xe0000034f63dc580, 0x0, 0xa000000100571f40, 0x694)
0xa000000100571f40 qla2x00_configure_loop+0x2320
        args (0xe0000034f63e44b8, 0xe0000034f63dc580, 0xe0000034f63e66e8, 0xe0000034f60dfd34, 0xe0000034f63dc580)
0xa000000100574210 qla2x00_loop_resync+0x1b0
        args (0xfe, 0x0, 0xa0000001005692b0, 0x30b, 0x40000a0)
0xa0000001005692b0 qla2x00_do_dpc+0xb30
        args (0xe0000034f63e44b8, 0x4000090, 0x4000090, 0xa000000100011090, 0x286)
0xa000000100011090 kernel_thread_helper+0xd0
        args (0xa00000010083f8f0, 0xe0000034f63e44b8, 0xa000000100009120, 0x2, 0xa000000100d115c0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010083f8f0, 0xe0000034f63e44b8)


[0]kdb> btp 903
Stack traceback for pid 903
0xe0000034f6300000      903        1  0    0   D  0xe0000034f6300380  qla2300_4_dpc
0xa000000100717990 schedule+0x2290
        args (0xe00000b00393de00, 0xa0000001000ca0b0, 0x309, 0xa0000001000ca0a0, 0x1)
0xa0000001000ca0c0 flush_cpu_workqueue+0x140
        args (0xe00000b00393de00, 0x225, 0xe0000034f6300000, 0xa0000001000ca220, 0x288)
0xa0000001000ca220 flush_workqueue+0xc0
        args (0xe000003007114700, 0x0, 0xa0000001000ca3e0, 0x184, 0x205)
0xa0000001000ca3e0 flush_scheduled_work+0x20
        args (0xa000000100554570, 0x307, 0x307)
0xa000000100554570 fc_rport_tgt_remove+0xf0
        args (0xe0000034f6575d80, 0xe0000034f6575ff8, 0xe0000034f6694000, 0xa000000100554820, 0x389)
0xa000000100554820 fc_rport_terminate+0xa0
        args (0xe0000034f6575d80, 0xe0000034f6575dd0, 0xe0000034f6694058, 0xe0000034f6694000, 0xa000000100554950)
0xa000000100554950 fc_remote_port_delete+0x50
        args (0xe0000034f6575d80, 0x3a98, 0xa00000010056f090, 0x287, 0xe0000034f66944e8)
0xa00000010056f090 qla2x00_rport_del+0x70
        args (0xe0000034f6692170, 0xe0000034f6575d80, 0xa00000010056f100, 0x48c, 0x48f)
0xa00000010056f100 qla2x00_reg_remote_port+0x40
        args (0xe0000034f66944b8, 0xe0000034f6692100, 0x3, 0x3, 0xfffffff0)
0xa00000010056f6b0 qla2x00_update_fcport+0x1f0
        args (0xe0000034f66944b8, 0xe0000034f6692100, 0xe0000034f66944b8, 0xa00000010056f820, 0x30b)
[0]more>
0xa00000010056f820 qla2x00_fabric_dev_login+0x140
        args (0xe0000034f66944b8, 0xe0000034f6692100, 0x0, 0xa000000100571f40, 0x694)
0xa000000100571f40 qla2x00_configure_loop+0x2320
        args (0xe0000034f66944b8, 0xe0000034f6692100, 0xe0000034f66966e8, 0xe0000034f657b734, 0xe0000034f6692300)
0xa000000100574210 qla2x00_loop_resync+0x1b0
        args (0xff, 0x0, 0xa0000001005692b0, 0x30b, 0x40000a0)
0xa0000001005692b0 qla2x00_do_dpc+0xb30
        args (0xe0000034f66944b8, 0x4000090, 0x4000090, 0xa000000100011090, 0x286)
0xa000000100011090 kernel_thread_helper+0xd0
        args (0xa00000010083f8f0, 0xe0000034f66944b8, 0xa000000100009120, 0x2, 0xa000000100d115c0)
0xa000000100009120 start_kernel_thread+0x20
        args (0xa00000010083f8f0, 0xe0000034f66944b8)

