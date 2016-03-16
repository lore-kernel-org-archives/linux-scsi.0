From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] fnic: move printk()s outside of the critical code section.
Date: Wed, 16 Mar 2016 14:44:08 +0100
Message-ID: <1458135848-7770-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966614AbcCPNoM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2016 09:44:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hiralpat@cisco.com, sramars@cisco.com, buchino@cisco.com, jejb@linux.vnet.ibm.com

This patch moves a printk() outside of the code section where
interrupt are disabled. In some cases a flood of error messages may
cause a kernel panic.
It also removes one of the printk()s because the same error
message was printed twice.

[709686.317197] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 12
[709686.317200] CPU: 12 PID: 1963 Comm: systemd-journal Tainted: GF          O--------------   3.10.0-229.el7.x86_64 #1
[709686.317201] Hardware name: Cisco Systems Inc UCSB-B200-M3/UCSB-B200-M3, BIOS B200M3.2.2.3.6.030620151309 03/06/2015
[709686.317206]  ffffffff8182b2e8 00000000392722ba ffff88046fcc5c48 ffffffff81603f36
[709686.317209]  ffff88046fcc5cc8 ffffffff815fd7da 0000000000000010 ffff88046fcc5cd8
[709686.317211]  ffff88046fcc5c78 00000000392722ba ffff88046fcc5c88 000000000000000c
[709686.317212] Call Trace:
[709686.317221]  <NMI>  [<ffffffff81603f36>] dump_stack+0x19/0x1b
[709686.317223]  [<ffffffff815fd7da>] panic+0xd8/0x1e7
[709686.317227]  [<ffffffff8110a760>] ? watchdog_enable_all_cpus.part.2+0x40/0x40
[709686.317229]  [<ffffffff8110a822>] watchdog_overflow_callback+0xc2/0xd0
[709686.317233]  [<ffffffff8114c901>] __perf_event_overflow+0xa1/0x250
[709686.317235]  [<ffffffff8114d404>] perf_event_overflow+0x14/0x20
[709686.317239]  [<ffffffff810301fd>] intel_pmu_handle_irq+0x1fd/0x410
[709686.317242]  [<ffffffff811908d1>] ? unmap_kernel_range_noflush+0x11/0x20
[709686.317246]  [<ffffffff81373574>] ? ghes_copy_tofrom_phys+0x124/0x210
[709686.317249]  [<ffffffff8160cfcb>] perf_event_nmi_handler+0x2b/0x50
[709686.317251]  [<ffffffff8160c719>] nmi_handle.isra.0+0x69/0xb0
[709686.317252]  [<ffffffff8160c830>] do_nmi+0xd0/0x340
[709686.317256]  [<ffffffff8160bb71>] end_repeat_nmi+0x1e/0x2e
[709686.317260]  [<ffffffff812e24fd>] ? memcpy+0xd/0x110
[709686.317263]  [<ffffffff812e24fd>] ? memcpy+0xd/0x110
[709686.317265]  [<ffffffff812e24fd>] ? memcpy+0xd/0x110
[709686.317269]  <<EOE>>  [<ffffffff8132c297>] ? vgacon_scroll+0x2d7/0x330
[709686.317273]  [<ffffffff813a086c>] scrup+0xfc/0x110
[709686.317275]  [<ffffffff813a0920>] lf+0xa0/0xb0
[709686.317278]  [<ffffffff813a1b32>] vt_console_print+0x2d2/0x420
[709686.317283]  [<ffffffff8106f4a1>] call_console_drivers.constprop.15+0x91/0xf0
[709686.317287]  [<ffffffff8107069f>] console_unlock+0x3bf/0x400
[709686.317291]  [<ffffffff81070996>] vprintk_emit+0x2b6/0x530
[709686.317294]  [<ffffffff815fd961>] printk_emit+0x44/0x5b
[709686.317297]  [<ffffffff81070d98>] devkmsg_writev+0x158/0x1d0
[709686.317303]  [<ffffffff811c5ef9>] do_sync_readv_writev+0x79/0xd0
[709686.317307]  [<ffffffff811c73ee>] do_readv_writev+0xce/0x260
[709686.317310]  [<ffffffff811c8d18>] ? __sb_start_write+0x58/0x110
[709686.317314]  [<ffffffff811c7615>] vfs_writev+0x35/0x60
[709686.317318]  [<ffffffff811c776c>] SyS_writev+0x5c/0xd0
[709686.317322]  [<ffffffff81613da9>] system_call_fastpath+0x16/0x1b

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 266b909..f3032ca 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -958,23 +958,22 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 	case FCPIO_INVALID_PARAM:    /* some parameter in request invalid */
 	case FCPIO_REQ_NOT_SUPPORTED:/* request type is not supported */
 	default:
-		shost_printk(KERN_ERR, fnic->lport->host, "hdr status = %s\n",
-			     fnic_fcpio_status_to_str(hdr_status));
 		sc->result = (DID_ERROR << 16) | icmnd_cmpl->scsi_status;
 		break;
 	}
 
-	if (hdr_status != FCPIO_SUCCESS) {
-		atomic64_inc(&fnic_stats->io_stats.io_failures);
-		shost_printk(KERN_ERR, fnic->lport->host, "hdr status = %s\n",
-			     fnic_fcpio_status_to_str(hdr_status));
-	}
 	/* Break link with the SCSI command */
 	CMD_SP(sc) = NULL;
 	CMD_FLAGS(sc) |= FNIC_IO_DONE;
 
 	spin_unlock_irqrestore(io_lock, flags);
 
+	if (hdr_status != FCPIO_SUCCESS) {
+		atomic64_inc(&fnic_stats->io_stats.io_failures);
+		shost_printk(KERN_ERR, fnic->lport->host, "hdr status = %s\n",
+			     fnic_fcpio_status_to_str(hdr_status));
+	}
+
 	fnic_release_ioreq_buf(fnic, io_req, sc);
 
 	mempool_free(io_req, fnic->io_req_pool);
-- 
Maurizio Lombardi

