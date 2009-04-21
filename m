From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 4/10] mpt2sas : running out of message frames
Date: Tue, 21 Apr 2009 15:39:24 -0600
Message-ID: <20090421213921.GE18563@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og59.obsmtp.com ([64.18.14.183]:33853 "EHLO
	chip3og59.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbZDUVhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 17:37:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

The driver is not freeing message frame when returning failure from
_ctl_do_task_abort.   If you call this function 500 times when its unable
to find an active task mid, you end up with no message frames.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-04-09 16:40:38.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c	2009-04-09 16:44:05.000000000 -0600
@@ -714,8 +714,10 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPT
 
 		if (tm_request->TaskType ==
 		    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
-			if (_ctl_do_task_abort(ioc, &karg, tm_request))
+			if (_ctl_do_task_abort(ioc, &karg, tm_request)) {
+				mpt2sas_base_free_smid(ioc, smid);
 				goto out;
+			}
 		}
 
 		mutex_lock(&ioc->tm_cmds.mutex);
