From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Fix BUG on adapter dump timeout
Date: Sat, 15 Oct 2011 09:08:56 -0500
Message-ID: <201110151408.p9FE8q8g009855@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35038 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1JOOJA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2011 10:09:00 -0400
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Sat, 15 Oct 2011 10:08:56 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p9FE8s42270224
	for <linux-scsi@vger.kernel.org>; Sat, 15 Oct 2011 10:08:54 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p9FE8r7j009900
	for <linux-scsi@vger.kernel.org>; Sat, 15 Oct 2011 11:08:53 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If an adapter dump times out, the ipr driver will abort the
dump and proceed to reset and recover the adapter. When an
adapter dump completes, the work thread which is reading the
adapter dump will initiate an adapter reset to recover the
adapter. However, when the adapter dump gets aborted, the
work thread should not initiate an adapter reset, since an
adapter reset is already in progress. This fixes a case of
calling pci_block_user_cfg_access overlapped, which results
in a BUG.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    4 +++-
 drivers/scsi/ipr.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.h~ipr_dump_timeout drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_dump_timeout	2011-10-15 09:06:38.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2011-10-15 09:06:38.000000000 -0500
@@ -1385,6 +1385,7 @@ struct ipr_ioa_cfg {
 	u8 needs_warm_reset:1;
 	u8 msi_received:1;
 	u8 sis64:1;
+	u8 dump_timeout:1;
 
 	u8 revid;
 
diff -puN drivers/scsi/ipr.c~ipr_dump_timeout drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_dump_timeout	2011-10-15 09:06:38.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2011-10-15 09:06:38.000000000 -0500
@@ -3109,7 +3109,7 @@ static void ipr_worker_thread(struct wor
 		kref_put(&dump->kref, ipr_release_dump);
 
 		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-		if (ioa_cfg->sdt_state == DUMP_OBTAINED)
+		if (ioa_cfg->sdt_state == DUMP_OBTAINED && !ioa_cfg->dump_timeout)
 			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		return;
@@ -7453,6 +7453,7 @@ static int ipr_reset_wait_for_dump(struc
 	else if (ioa_cfg->sdt_state == READ_DUMP)
 		ioa_cfg->sdt_state = ABORT_DUMP;
 
+	ioa_cfg->dump_timeout = 1;
 	ipr_cmd->job_step = ipr_reset_alert;
 
 	return IPR_RC_JOB_CONTINUE;
@@ -7617,6 +7618,7 @@ static int ipr_reset_restore_cfg_space(s
 
 		if (GET_DUMP == ioa_cfg->sdt_state) {
 			ioa_cfg->sdt_state = READ_DUMP;
+			ioa_cfg->dump_timeout = 0;
 			if (ioa_cfg->sis64)
 				ipr_reset_start_timer(ipr_cmd, IPR_SIS64_DUMP_TIMEOUT);
 			else
_

