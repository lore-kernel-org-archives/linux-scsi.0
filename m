From: Michael Reed <mdr@sgi.com>
Subject: fc transport recursion depth exceeded
Date: Mon, 06 Feb 2006 15:13:30 -0600
Message-ID: <43E7BBFA.5070906@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:45198 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932098AbWBFVNm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 16:13:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Hi James,

I was testing with the qlogic board this afternoon and observed these
messages in the dmesg output.  They were generated in response to a
switchdisable ; sleep 5 ; switchenable command sequence on my switch.

end_request: I/O error, dev sdbz, sector 1282218
sd 4:0:34:0: SCSI error: return code = 0x10000
run_workqueue: recursion depth exceeded: 4

Call Trace:
end_request: I/O error, dev sdbz, sector 1282250
 [<a000000100012ae0>] show_stack+0x40/0xa0
                                sp=e0000034f6a8f9e0 bsp=e0000034f6a894c0
sd 4:0:34:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdbz, sector 1282282
 [<a000000100012b70>] dump_stack+0x30/0x60
                                sp=e0000034f6a8fbb0 bsp=e0000034f6a894a8
 [<a0000001000c8f10>] run_workqueue+0x90/0x280
                                sp=e0000034f6a8fbb0 bsp=e0000034f6a89468
 [<a0000001000c9150>] flush_cpu_workqueue+0x50/0x1e0
                                sp=e0000034f6a8fbb0 bsp=e0000034f6a89438
 [<a0000001000c9350>] flush_workqueue+0x70/0x160
                                sp=e0000034f6a8fc10 bsp=e0000034f6a89410
 [<a00000010052b130>] scsi_flush_work+0x90/0xc0
                                sp=e0000034f6a8fc10 bsp=e0000034f6a893e8
 [<a000000100547480>] fc_rport_tgt_remove+0x100/0x140
                                sp=e0000034f6a8fc10 bsp=e0000034f6a893b8
 [<a0000001005475b0>] fc_shost_remove_rports+0xf0/0x1c0
                                sp=e0000034f6a8fc10 bsp=e0000034f6a89388
 [<a0000001000c9040>] run_workqueue+0x1c0/0x280
                                sp=e0000034f6a8fc10 bsp=e0000034f6a89348
 [<a0000001000c9150>] flush_cpu_workqueue+0x50/0x1e0
                                sp=e0000034f6a8fc10 bsp=e0000034f6a89318
 [<a0000001000c9350>] flush_workqueue+0x70/0x160
                                sp=e0000034f6a8fc70 bsp=e0000034f6a892f0
 [<a00000010052b130>] scsi_flush_work+0x90/0xc0
                                sp=e0000034f6a8fc70 bsp=e0000034f6a892d0
 [<a000000100547480>] fc_rport_tgt_remove+0x100/0x140
                                sp=e0000034f6a8fc70 bsp=e0000034f6a892a0
 [<a0000001005475b0>] fc_shost_remove_rports+0xf0/0x1c0
                                sp=e0000034f6a8fc70 bsp=e0000034f6a89270
 [<a0000001000c9040>] run_workqueue+0x1c0/0x280
                                sp=e0000034f6a8fc70 bsp=e0000034f6a89230
 [<a0000001000c9150>] flush_cpu_workqueue+0x50/0x1e0
                                sp=e0000034f6a8fc70 bsp=e0000034f6a89200
 [<a0000001000c9350>] flush_workqueue+0x70/0x160
                                sp=e0000034f6a8fcd0 bsp=e0000034f6a891d0
 [<a00000010052b130>] scsi_flush_work+0x90/0xc0
                                sp=e0000034f6a8fcd0 bsp=e0000034f6a891b0
 [<a000000100547480>] fc_rport_tgt_remove+0x100/0x140
                                sp=e0000034f6a8fcd0 bsp=e0000034f6a89180
 [<a0000001005475b0>] fc_shost_remove_rports+0xf0/0x1c0
                                sp=e0000034f6a8fcd0 bsp=e0000034f6a89150
 [<a0000001000c9040>] run_workqueue+0x1c0/0x280
                                sp=e0000034f6a8fcd0 bsp=e0000034f6a89110
 [<a0000001000ca130>] worker_thread+0x1d0/0x260
                                sp=e0000034f6a8fcd0 bsp=e0000034f6a890e0
 [<a0000001000d1f00>] kthread+0x220/0x2a0
                                sp=e0000034f6a8fd50 bsp=e0000034f6a89098
 [<a000000100011070>] kernel_thread_helper+0xd0/0x100
                                sp=e0000034f6a8fe30 bsp=e0000034f6a89070
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e0000034f6a8fe30 bsp=e0000034f6a89070
sd 3:0:35:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdcr, sector 1745339
sd 6:0:33:0: SCSI error: return code = 0x10000
end_request: I/O error, dev sdek, sector 2880792


This happened a number of times during the single test event.

Mike
