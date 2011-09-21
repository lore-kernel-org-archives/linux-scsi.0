From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Stop reading adapter dump prematurely
Date: Wed, 21 Sep 2011 08:51:11 -0500
Message-ID: <201109211351.p8LDp3Oi010340@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35888 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1IUN5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2011 09:57:41 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 21 Sep 2011 07:51:42 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8LDpCr7194926
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2011 07:51:13 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8LDp7Ps010488
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2011 07:51:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


When the ipr driver decides to dump the adapter, it changes the
sdt_state to GET_DUMP, then prepares the adapter so that the dump
can be read. However, if the ipr worker thread wakes up for some
reason before the driver has put the adapter in a state where it
can succesfully dump the adapter, the driver will start dumping
the adapter too early, which can potentially trigger a BUG check
in the pci config blocking API. Fix this by adding a new
sdt_state to differentiate between the ipr driver wanting to dump
the adapter in the near future and wanting to dump the adapter now.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   15 +++++++++++----
 drivers/scsi/ipr.h |    1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_dump_state_fix drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_dump_state_fix	2011-09-13 10:40:58.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2011-09-13 10:40:58.000000000 -0500
@@ -1360,6 +1360,7 @@ enum ipr_sdt_state {
 	INACTIVE,
 	WAIT_FOR_DUMP,
 	GET_DUMP,
+	READ_DUMP,
 	ABORT_DUMP,
 	DUMP_OBTAINED
 };
diff -puN drivers/scsi/ipr.c~ipr_dump_state_fix drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_dump_state_fix	2011-09-13 10:40:58.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2011-09-13 10:40:58.000000000 -0500
@@ -2901,7 +2901,7 @@ static void ipr_get_ioa_dump(struct ipr_
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
-	if (ioa_cfg->sdt_state != GET_DUMP) {
+	if (ioa_cfg->sdt_state != READ_DUMP) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		return;
 	}
@@ -3097,7 +3097,7 @@ static void ipr_worker_thread(struct wor
 	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
-	if (ioa_cfg->sdt_state == GET_DUMP) {
+	if (ioa_cfg->sdt_state == READ_DUMP) {
 		dump = ioa_cfg->dump;
 		if (!dump) {
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
@@ -7449,6 +7449,8 @@ static int ipr_reset_wait_for_dump(struc
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
 
 	if (ioa_cfg->sdt_state == GET_DUMP)
+		ioa_cfg->sdt_state = WAIT_FOR_DUMP;
+	else if (ioa_cfg->sdt_state == READ_DUMP)
 		ioa_cfg->sdt_state = ABORT_DUMP;
 
 	ipr_cmd->job_step = ipr_reset_alert;
@@ -7614,6 +7616,7 @@ static int ipr_reset_restore_cfg_space(s
 		ipr_cmd->job_step = ipr_reset_enable_ioa;
 
 		if (GET_DUMP == ioa_cfg->sdt_state) {
+			ioa_cfg->sdt_state = READ_DUMP;
 			if (ioa_cfg->sis64)
 				ipr_reset_start_timer(ipr_cmd, IPR_SIS64_DUMP_TIMEOUT);
 			else
@@ -8003,8 +8006,12 @@ static void ipr_initiate_ioa_reset(struc
 	if (ioa_cfg->ioa_is_dead)
 		return;
 
-	if (ioa_cfg->in_reset_reload && ioa_cfg->sdt_state == GET_DUMP)
-		ioa_cfg->sdt_state = ABORT_DUMP;
+	if (ioa_cfg->in_reset_reload) {
+		if (ioa_cfg->sdt_state == GET_DUMP)
+			ioa_cfg->sdt_state = WAIT_FOR_DUMP;
+		else if (ioa_cfg->sdt_state == READ_DUMP)
+			ioa_cfg->sdt_state = ABORT_DUMP;
+	}
 
 	if (ioa_cfg->reset_retries++ >= IPR_NUM_RESET_RELOAD_RETRIES) {
 		dev_err(&ioa_cfg->pdev->dev,
_

