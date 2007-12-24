From: Josip Rodin <joy@entuzijast.net>
Subject: qla2xxx panic'ing kernel with 'Bad RIP value' due to bad cable(?)
Date: Mon, 24 Dec 2007 03:30:27 +0100
Message-ID: <20071224023027.GA9423@keid.carnet.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from keid.CARNet.hr ([161.53.160.10]:53406 "EHLO keid.carnet.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXLXDBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Dec 2007 22:01:40 -0500
Received: from joy by keid.carnet.hr with local (Exim 4.63)
	(envelope-from <joy@entuzijast.net>)
	id 1J6d5H-0003Gy-NC
	for linux-scsi@vger.kernel.org; Mon, 24 Dec 2007 03:30:27 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I've got a machine crashing due to some sort of a bad fibre cable or
something, which is plugged into a QLA2312. I've gotten the same error on
the console twice now, so I guess it would be a good idea to report it
because it might indicate a slight error somewhere in the code, rather
than merely flaky hardware :)

CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000001fc602000 CR4: 00000000000006e0
Process swapper (pid: 0, veid=0, threadinfo ffff8101ff8f4000, task ffff8101ff8f2000)
Stack:  ffffffff8809c4e9 0000000000000031 ffffc2000042a000 ffff8101fdcdc528
 0000000000000020 0000000000000000 ffffffff8809d9d0 ffffffff805d52a0
 0000000000000046 4910000700818014 ffff8101ff8fbef0 0000000000000001
Call Trace:
 <IRQ>  [<ffffffff8809c4e9>] :qla2xxx:qla2x00_process_response_queue+0x149/0x230
 [<ffffffff8809d9d0>] :qla2xxx:qla2300_intr_handler+0x180/0x2d0
 [<ffffffff80263e84>] handle_IRQ_event+0x34/0x70
 [<ffffffff802658f9>] handle_fasteoi_irq+0x89/0x110
 [<ffffffff8020ccbb>] do_IRQ+0x7b/0x100
 [<ffffffff80208d50>] default_idle+0x0/0x40
 [<ffffffff8020a111>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff80208d79>] default_idle+0x29/0x40
 [<ffffffff80208dec>] cpu_idle+0x5c/0x80


Code:  Bad RIP value.
RIP  [<0000000000000000>] _stext+0x7fdf9000/0x20
 RSP <ffff8101ff8fbea0>
CR2: 0000000000000000
Kernel panic - not syncing: Aiee, killing interrupt handler!


The kernel log shows these kinds of things beforehand:

Dec 24 01:35:02 foo kernel: qla2xxx 0000:05:08.0: scsi(0:0:0:1): Mid-layer underflow detected (80000 of 80000 bytes)...returning error status.
Dec 24 01:37:13 foo kernel: qla2xxx 0000:05:08.0: scsi(0:0:1:1): Mid-layer underflow detected (80000 of 80000 bytes)...returning error status.
Dec 24 01:59:14 foo kernel: qla2xxx 0000:05:08.0: scsi(0:0:1): Abort command issued -- 0 13f39a 2002.
Dec 24 01:59:15 foo kernel: qla2xxx 0000:05:08.0: scsi(0:0:1): Abort command issued -- 1 13f39b 2002.

This is with Linux kernel 2.6.22-ovz005, which is a 2.6.22.12 with OpenVZ
patch added (and the latter doesn't touch drivers/scsi/qla2xxx/*).

FWIW. (Please Cc: responses.)

-- 
     2. That which causes joy or happiness.
