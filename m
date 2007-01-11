From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 05/21] libsas: Reset timer on taskless scsi_cmnds in sas_scsi_timed_out
Date: Thu, 11 Jan 2007 14:15:00 -0800
Message-ID: <20070111221500.3543.11097.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45865 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbXAKWOm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:42 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMFEdj020577
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:14 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEenU286524
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:40 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEeTK012228
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:40 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Every so often, a scsi_cmnd will time out, and the libsas timeout handler
will discover that the scsi_cmnd does not have a sas_task attached to it.
This can happen in two cases: (1) the scsi_cmnd actually made it through
libsas to the HBA and is now going through scsi_done, or (2) the
scsi_cmnd has been held up (host lock, slab alloc, etc) and libsas has
not yet attached a sas_task.  In both cases, it is safe to ask SCSI for
more time to process the command via EH_RESET_TIMER; we cannot blindly
return EH_HANDLED because if (2) happens, we could end up calling
scsi_done while another CPU is heading towards sas_queuecommand, which
causes slab corruption when sas_task_done updates the freed scsi_cmnd.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7774eb3..3f647c6 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -524,9 +524,13 @@ enum scsi_eh_timer_return sas_scsi_timed
 	unsigned long flags;
 
 	if (!task) {
-		SAS_DPRINTK("command 0x%p, task 0x%p, gone: EH_HANDLED\n",
-			    cmd, task);
-		return EH_HANDLED;
+		cmd->timeout_per_command /= 2;
+		SAS_DPRINTK("command 0x%p, task 0x%p, gone: %s\n",
+			    cmd, task, (cmd->timeout_per_command ?
+			    "EH_RESET_TIMER" : "EH_NOT_HANDLED"));
+		if (!cmd->timeout_per_command)
+			return EH_NOT_HANDLED;
+		return EH_RESET_TIMER;
 	}
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
