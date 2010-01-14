From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/3] scsi_transport_fc: Allow LLD to reset FC BSG timeout
Date: Thu, 14 Jan 2010 17:19:00 +0100
Message-ID: <20100114163344.885508000@de.ibm.com>
References: <20100114161859.790342000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:57503 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab0ANQdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 11:33:46 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.1/8.13.1) with ESMTP id o0EGXkSN021091
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 16:33:46 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0EGXjva1413244
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 17:33:45 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o0EGXj9R022372
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 17:33:45 +0100
Content-Disposition: inline; filename=bsg_job_timeout.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, James Smart <James.Smart@emulex.com>, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The hardware used with zfcp cannot abort a currently pending CT or ELS
request. Therefore we need the option to postpone the timeout
triggered request abort within the fc layer, since there is nothing
zfcp can do to stop the request at this point.

Cc: James Smart <James.Smart@emulex.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_transport_fc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_transport_fc.c	2010-01-14 16:44:42.000000000 +0100
+++ b/drivers/scsi/scsi_transport_fc.c	2010-01-14 16:44:43.000000000 +0100
@@ -3527,7 +3527,10 @@ fc_bsg_job_timeout(struct request *req)
 	if (!done && i->f->bsg_timeout) {
 		/* call LLDD to abort the i/o as it has timed out */
 		err = i->f->bsg_timeout(job);
-		if (err)
+		if (err == -EAGAIN) {
+			job->ref_cnt--;
+			return BLK_EH_RESET_TIMER;
+		} else if (err)
 			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
 				"abort failed with status %d\n", err);
 	}

