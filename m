From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH 5/5 v2] zfcp: Issue FCP command without holding SCSI host_lock
Date: Thu, 18 Nov 2010 14:53:18 +0100
Message-ID: <20101118135317.GA5209@schmichrtp.ibm.com>
References: <20101117132339.429099463@de.ibm.com>
 <20101117132656.516066294@de.ibm.com>
 <4CE3DC06.2010402@panasas.com>
 <20101117141024.GA3589@schmichrtp.ibm.com>
 <4CE3E848.3010008@panasas.com>
 <20101118083414.GA3403@schmichrtp.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:42947 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965Ab0KRNxV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2010 08:53:21 -0500
Content-Disposition: inline
In-Reply-To: <20101118083414.GA3403@schmichrtp.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Boaz Harrosh <bharrosh@panasas.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Interrupting the connection to the FCP channel while I/O requests are
being issued can lead to this deadlock. scsi_dispatch_cmd already
holds the host_lock while the recovery trigger tries to acquire the
host_lock again when iterating through the scsi_devices.

 INFO: lockdep is turned off.
 BUG: spinlock lockup on CPU#1, blast/9660, 0000000078f38878
 CPU: 1 Not tainted 2.6.35.7SWEN2 #2
 Process blast (pid: 9660, task: 0000000071f75940, ksp: 0000000074393ac0)
        0000000074393640 00000000743935c0 0000000000000002 0000000000000000
        0000000074393660 00000000743935d8 00000000743935d8 00000000005590c2
        0000000000000000 0000000078f38878 0000000026ede800 0000000078f38878
        000000000000000d 040000000000000c 0000000074393628 0000000000000000
        0000000000000000 0000000000100b2a 00000000743935c0 0000000074393600
 Call Trace:
 ([<0000000000100a32>] show_trace+0xee/0x144)
  [<00000000003be202>] do_raw_spin_lock+0x112/0x178
  [<000000000055d408>] _raw_spin_lock_irqsave+0x90/0xb0
  [<00000000003f1514>] __scsi_iterate_devices+0x38/0xbc
  [<00000000004849b0>] zfcp_erp_clear_adapter_status+0xd0/0x16c
  [<000000000048587a>] zfcp_erp_adapter_reopen+0x3a/0xb4
  [<0000000000489812>] zfcp_fsf_req_send+0x166/0x180
  [<000000000048c8d6>] zfcp_fsf_fcp_cmnd+0x272/0x408
  [<000000000048f864>] zfcp_scsi_queuecommand+0x11c/0x1e0
  [<00000000003f1f2a>] scsi_dispatch_cmd+0x1d6/0x324
  [<00000000003f9910>] scsi_request_fn+0x42c/0x56c
  [<00000000003828ae>] __blk_run_queue+0x86/0x140
  [<000000000037f742>] elv_insert+0x11a/0x208
  [<000000000038104c>] blk_insert_cloned_request+0x84/0xe4
  [<000003c0032b7c64>] dm_dispatch_request+0x6c/0x94 [dm_mod]
  [<000003c0032b7d5c>] map_request+0xd0/0x100 [dm_mod]
  [<000003c0032b9a78>] dm_request_fn+0xec/0x1bc [dm_mod]
  [<0000000000382c0e>] generic_unplug_device+0x5a/0x6c
  [<000003c0032b7f98>] dm_unplug_all+0x74/0x9c [dm_mod]
  [<00000000001d1272>] sync_page+0x76/0x9c
  [<00000000001d12ba>] sync_page_killable+0x22/0x60
  [<000000000055a768>] __wait_on_bit_lock+0xc0/0x124
  [<00000000001d1140>] __lock_page_killable+0x78/0x84
  [<00000000001d351c>] generic_file_aio_read+0x5a4/0x7e8
  [<0000000000228ec0>] do_sync_read+0xc8/0x12c
  [<0000000000229edc>] vfs_read+0xac/0x1ac
  [<000000000022a0d8>] SyS_read+0x58/0xa8
  [<00000000001146de>] sysc_noemu+0x10/0x16
  [<00000200000493c4>] 0x200000493c4
 INFO: lockdep is turned off.

Call zfcp_fsf_fcp_cmnd without the host_lock and disable the
interrupts when acquiring the req_q_lock. According to the patch
description in "[PATCH] Eliminate error handler overload of the SCSI
serial number", the serial_number is not used, so simply drop the
queuecommand wrapper function and run zfcp_scsi_queuecommand without
holding the host_lock.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c  |    5 +++--
 drivers/s390/scsi/zfcp_scsi.c |    7 ++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2170,12 +2170,13 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
 	struct fsf_qtcb_bottom_io *io;
+	unsigned long flags;
 
 	if (unlikely(!(atomic_read(&zfcp_sdev->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return -EBUSY;
 
-	spin_lock(&qdio->req_q_lock);
+	spin_lock_irqsave(&qdio->req_q_lock, flags);
 	if (atomic_read(&qdio->req_q_free) <= 0) {
 		atomic_inc(&qdio->req_q_full);
 		goto out;
@@ -2239,7 +2240,7 @@ failed_scsi_cmnd:
 	zfcp_fsf_req_free(req);
 	scsi_cmnd->host_scribble = NULL;
 out:
-	spin_unlock(&qdio->req_q_lock);
+	spin_unlock_irqrestore(&qdio->req_q_lock, flags);
 	return retval;
 }
 
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -76,8 +76,8 @@ static void zfcp_scsi_command_fail(struc
 	scpnt->scsi_done(scpnt);
 }
 
-static int zfcp_scsi_queuecommand_lck(struct scsi_cmnd *scpnt,
-				  void (*done) (struct scsi_cmnd *))
+static
+int zfcp_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scpnt)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
@@ -87,7 +87,6 @@ static int zfcp_scsi_queuecommand_lck(st
 	/* reset the status for this request */
 	scpnt->result = 0;
 	scpnt->host_scribble = NULL;
-	scpnt->scsi_done = done;
 
 	scsi_result = fc_remote_port_chkready(rport);
 	if (unlikely(scsi_result)) {
@@ -127,8 +126,6 @@ static int zfcp_scsi_queuecommand_lck(st
 	return ret;
 }
 
-static DEF_SCSI_QCMD(zfcp_scsi_queuecommand)
-
 static int zfcp_scsi_slave_alloc(struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
