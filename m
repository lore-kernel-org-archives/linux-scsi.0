From: Michael Reed <mdr@sgi.com>
Subject: [PATCH] OOPS due to clearing eh_action prior to aborting eh command
Date: Wed, 07 Dec 2005 15:56:28 -0600
Message-ID: <43975A8C.2030208@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080808050601020300060904"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:16562 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1030380AbVLGV4n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2005 16:56:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, James.Smart@Emulex.Com, James.Bottomley@SteelEye.com, Jeremy Higdon <jeremy@sgi.com>

This is a multi-part message in MIME format.
--------------080808050601020300060904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

During my testing of fc transport attributes for the mpt fusion
driver, I came upon this OOPS.  (Actually, I've come upon it
too many times.  :(  )

Attached is a patch which addresses the issue.  Please give it a look.

Thanks,
 Mike


duck /root# dmesg -n8
duck /root# sync
duck /root# sync
duck /root# mptscsih: ioc0: attempting task abort! (sc=e0000034f74d4500)
sd 10:0:4:0:
        command: Read (10): 28 00 00 0e 11 00 00 01 00 00
mptscsih: ioc0: task abort: SUCCESS (sc=e0000034f74d4500)
scsi_send_eh_cmnd: wait_for_completion_timeout: 2500, 0

	( above message shows timeout value for command and time remaining
	upon return from wait_for_completion_timeout().
	  Return value of zero indicates that the command
	was timed out.)

mptscsih: ioc0: attempting task abort! (sc=e0000034f74d4500)
sd 10:0:4:0:
        command: Test Unit Ready: 00 00 00 00 00 00

Here's where the driver is called to abort it.  Unfortunately,
the eh_action pointer (done routine) was set to zero by now, so when
the command is returned, the system goes OOPS.

scsi_eh_done scmd: e0000034f74d4500 result: 80000, device e0000034f63ff000, host e0000034f7518800, action 0000000000000000
Unable to handle kernel NULL pointer dereference (address 0000000000000008)
swapper[0]: Oops 11020886081536 [1]
Modules linked in: autofs nfsd ipv6 nfs lockd sunrpc usbcore

Pid: 0, CPU 0, comm:              swapper
psr : 0000121008022038 ifs : 8000000000000388 ip  : [<a00000010073c2a1>]    Not tainted
ip is at _spin_lock_irqsave+0x41/0x1a0
unat: 0000000000000000 pfs : 0000000000000388 rsc : 0000000000000003
rnat: 5555555555555555 bsps: 000000000001003e pr  : 800000187f55a555
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000010073c280 b6  : e0000030023e5490 b7  : a0000001000e9f80
f6  : 1003e20c49ba5e353f7cf f7  : 1003e20c49ba5e353f7cf
f8  : 1003e00000000000000a0 f9  : 1003e00000000000004e2
f10 : 1003e000000000fa00000 f11 : 1003e000000003b9aca00
r1  : a000000100c9e500 r2  : 0000000000010001 r3  : a0000001008d8db0
r8  : 0000001008026038 r9  : e0000034f7518898 r10 : 00000000000000f4
r11 : 0000000000000002 r12 : a0000001008dfbb0 r13 : a0000001008d8000
r14 : a000000100aa88d8 r15 : 0000000000010002 r16 : a0000001008d8db0
r17 : 0000000000010001 r18 : 0000000000010002 r19 : 0000000000000013
r20 : 0000000000000000 r21 : 0000000000000000 r22 : 0000000000000000
r23 : 0000000000000004 r24 : 0000000000000000 r25 : a0000001008d8da4
r26 : a0000001008d8d90 r27 : 0000000000000073 r28 : 0000000000000000
r29 : 0000000000000073 r30 : e00000b0050f0060 r31 : 0000000000000000

Call Trace:
 [<a000000100013760>] show_stack+0x80/0xa0
                                sp=a0000001008df730 bsp=a0000001008d9398
 [<a000000100013fd0>] show_regs+0x850/0x880
                                sp=a0000001008df900 bsp=a0000001008d9338
 [<a000000100038250>] die+0x210/0x2a0
                                sp=a0000001008df910 bsp=a0000001008d92f0
 [<a00000010073f370>] ia64_do_page_fault+0x990/0xb40
                                sp=a0000001008df930 bsp=a0000001008d9288
 [<a00000010000bce0>] ia64_leave_kernel+0x0/0x290
                                sp=a0000001008df9e0 bsp=a0000001008d9288
 [<a00000010073c2a0>] _spin_lock_irqsave+0x40/0x1a0
                                sp=a0000001008dfbb0 bsp=a0000001008d9248
 [<a0000001000aaa00>] complete+0x20/0xa0
                                sp=a0000001008dfbb0 bsp=a0000001008d9218
 [<a00000010055a960>] scsi_eh_done+0xe0/0x100
                                sp=a0000001008dfbb0 bsp=a0000001008d91e8
 [<a0000001005df060>] mptscsih_io_done+0x540/0x960
                                sp=a0000001008dfbb0 bsp=a0000001008d9120
 [<a0000001005d6e40>] mpt_interrupt+0x4e0/0xde0
                                sp=a0000001008dfbb0 bsp=a0000001008d90c8
 [<a000000100106bb0>] handle_IRQ_event+0x90/0x120
                                sp=a0000001008dfbb0 bsp=a0000001008d9088
 [<a000000100106e70>] __do_IRQ+0x230/0x360
                                sp=a0000001008dfbb0 bsp=a0000001008d9030
 [<a000000100010400>] ia64_handle_irq+0xc0/0x160
                                sp=a0000001008dfbb0 bsp=a0000001008d8fe8
 [<a00000010000bce0>] ia64_leave_kernel+0x0/0x290
                                sp=a0000001008dfbb0 bsp=a0000001008d8fe8
 [<a000000100011db0>] default_idle+0x150/0x180
                                sp=a0000001008dfd80 bsp=a0000001008d8f78
 [<a000000100012ea0>] cpu_idle+0x1c0/0x2e0
                                sp=a0000001008dfe20 bsp=a0000001008d8f10
 [<a000000100009230>] rest_init+0x90/0xc0
                                sp=a0000001008dfe20 bsp=a0000001008d8ef8
 [<a00000010087d0e0>] start_kernel+0x520/0x5c0
                                sp=a0000001008dfe20 bsp=a0000001008d8e98
 [<a000000100008650>] __end_ivt_text+0x330/0x350
                                sp=a0000001008dfe30 bsp=a0000001008d8e00

Entering kdb (current=0xa0000001008d8000, pid 0) on processor 0 Oops: <NULL>
due to oops @ 0xa00000010073c2a1
 psr: 0x0000121008022038   ifs: 0x8000000000000388    ip: 0xa00000010073c2a0
unat: 0x0000000000000000   pfs: 0x0000000000000388   rsc: 0x0000000000000003
rnat: 0x5555555555555555  bsps: 0x000000000001003e    pr: 0x800000187f55a555
ldrs: 0x0000000000000000   ccv: 0x0000000000000000  fpsr: 0x0009804c8a70033f
  b0: 0xa00000010073c280    b6: 0xe0000030023e5490    b7: 0xa0000001000e9f80
  r1: 0xa000000100c9e500    r2: 0x0000000000010001    r3: 0xa0000001008d8db0
  r8: 0x0000001008026038    r9: 0xe0000034f7518898   r10: 0x00000000000000f4
 r11: 0x0000000000000002   r12: 0xa0000001008dfbb0   r13: 0xa0000001008d8000
 r14: 0xa000000100aa88d8   r15: 0x0000000000010002   r16: 0xa0000001008d8db0
 r17: 0x0000000000010001   r18: 0x0000000000010002   r19: 0x0000000000000013
 r20: 0x0000000000000000   r21: 0x0000000000000000   r22: 0x0000000000000000
 r23: 0x0000000000000004   r24: 0x0000000000000000   r25: 0xa0000001008d8da4
 r26: 0xa0000001008d8d90   r27: 0x0000000000000073   r28: 0x0000000000000000
 r29: 0x0000000000000073   r30: 0xe00000b0050f0060   r31: 0x0000000000000000
&regs = a0000001008df9f0
[0]kdb>



--------------080808050601020300060904
Content-Type: text/x-patch;
 name="scsi_error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_error.patch"

--- a/drivers/scsi/scsi_error.c	2005-12-07 13:41:19.000000000 -0800
+++ b/drivers/scsi/scsi_error.c	2005-12-07 12:52:59.576655059 -0800
@@ -459,9 +459,6 @@
 
 	timeleft = wait_for_completion_timeout(&done, timeout);
 
-	scmd->request->rq_status = RQ_SCSI_DONE;
-	shost->eh_action = NULL;
-
 	scsi_log_completion(scmd, SUCCESS);
 
 	SCSI_LOG_ERROR_RECOVERY(3,
@@ -500,6 +497,9 @@
 		rtn = FAILED;
 	}
 
+	scmd->request->rq_status = RQ_SCSI_DONE;
+	shost->eh_action = NULL;
+
 	return rtn;
 }
 

--------------080808050601020300060904--
