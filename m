From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/5] zfcp: Fix common FCP request reception
Date: Wed, 17 Nov 2010 14:23:40 +0100
Message-ID: <20101117132655.638426049@de.ibm.com>
References: <20101117132339.429099463@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:52835 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0KQN05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 08:26:57 -0500
Content-Disposition: inline; filename=700-zfcp-request-reception.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The reception of a common FCP request should only be evaluated if the
corresponding SCSI request data is available. Therefore put the
information under the lock protection and verify the existence before
processing.  This fixes the following kernel panic.

Unable to handle kernel pointer dereference at virtual kernel address 0000000180000000
Oops: 003b [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 0 Not tainted 2.6.35.7-45.x.20101007-s390xdefault #1
Process blast (pid: 9711, task: 00000000a3be8e40, ksp: 00000000b221bac0)
Krnl PSW : 0704300180000000 0000000000489878 (zfcp_fsf_fcp_handler_common+0x4c/0x3a0)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:3 PM:0 EA:3
Krnl GPRS: 00000000b663c1b8 0000000180000000 000000007ab5bdf0 0000000000000000
           00000000b0ccd800 0000000000000018 07000000a3be8e78 00000000b5d3e600
           000000007ab5bdf0 0000000000000066 00000000b72137f0 00000000b72137f0
           0000000000000000 00000000005a8178 00000000bdf37a60 00000000bdf379f0
Krnl Code: 0000000000489866: e3c030000004       lg      %r12,0(%r3)
           000000000048986c: e310c0000004       lg      %r1,0(%r12)
           0000000000489872: e31011e00004       lg      %r1,480(%r1)
          >0000000000489878: 581011ec           l       %r1,492(%r1)
           000000000048987c: a774001c           brc     7,4898b4
           0000000000489880: b91400b1           lgfr    %r11,%r1
           0000000000489884: 5810405c           l       %r1,92(%r4)
           0000000000489888: 5510d00c           cl      %r1,12(%r13)
Call Trace:
([<000000000010d344>] debug_event_common+0x22c/0x244)
 [<000000000048a0b4>] zfcp_fsf_fcp_cmnd_handler+0x2c/0x3b4
 [<000000000048b5b6>] zfcp_fsf_req_complete+0x1b6/0x9dc
 [<000000000048bede>] zfcp_fsf_reqid_check+0x102/0x138
 [<000000000048e478>] zfcp_qdio_int_resp+0x70/0x110
 [<000000000044a1ec>] qdio_kick_handler+0xb0/0x19c
 [<000000000044c228>] __tiqdio_inbound_processing+0x30c/0xebc
 [<000000000014a5fc>] tasklet_action+0x1b4/0x1e8
 [<000000000014b676>] __do_softirq+0x106/0x1cc
 [<000000000010d91a>] do_softirq+0xe6/0xec
 [<000000000014b0c8>] irq_exit+0xd4/0xd8
 [<00000000004307ec>] do_IRQ+0x7c0/0xf54
 [<0000000000114d28>] io_return+0x0/0x16
 [<000000000055fef0>] sub_preempt_count+0x50/0xe4
([<00000000b1f873c0>] 0xb1f873c0)
 [<000000000055e25a>] _raw_spin_unlock+0x46/0x74
 [<0000000000241c40>] __d_lookup+0x288/0x2c8
 [<000000000023502c>] do_lookup+0x7c/0x25c
 [<0000000000237fa8>] link_path_walk+0x5e4/0xe2c
 [<0000000000238a00>] path_walk+0x98/0x148
 [<0000000000238c98>] do_path_lookup+0x74/0xc0
 [<000000000023989c>] user_path_at+0x64/0xa4
 [<000000000022e366>] vfs_fstatat+0x4e/0xb0
 [<000000000022e4d6>] SyS_newstat+0x2e/0x54
 [<00000000001146de>] sysc_noemu+0x10/0x16
 [<0000020000153456>] 0x20000153456
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<000000000048a0ae>] zfcp_fsf_fcp_cmnd_handler+0x26/0x3b4

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-11-17 10:03:42.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-11-17 10:04:18.000000000 +0100
@@ -2069,8 +2069,6 @@ static void zfcp_fsf_fcp_cmnd_handler(st
 	struct fcp_resp_with_ext *fcp_rsp;
 	unsigned long flags;
 
-	zfcp_fsf_fcp_handler_common(req);
-
 	read_lock_irqsave(&req->adapter->abort_lock, flags);
 
 	scpnt = req->data;
@@ -2079,6 +2077,8 @@ static void zfcp_fsf_fcp_cmnd_handler(st
 		return;
 	}
 
+	zfcp_fsf_fcp_handler_common(req);
+
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
 		set_host_byte(scpnt, DID_TRANSPORT_DISRUPTED);
 		goto skip_fsfstatus;

