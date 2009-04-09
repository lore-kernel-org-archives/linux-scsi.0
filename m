From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 4/4] mpt2sas: running out of message frames
Date: Thu, 9 Apr 2009 03:43:36 -0600
Message-ID: <20090409094334.GB7077@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og59.obsmtp.com ([64.18.14.183]:46415 "EHLO
	chip3og59.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935751AbZDIXjf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 19:39:35 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n39NIQPj028051
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 16:18:26 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n39NIRbB030461
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 16:18:27 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The driver is not freeing message frame when returning failure from
_ctl_do_task_abort.   If you call this function 500 times when its unable
to find an active task mid, you end up with no message frames.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uaprN a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
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
