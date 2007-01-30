From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 03/12] sas_ata: sas_ata_qc_issue should return AC_ERR_*
Date: Tue, 30 Jan 2007 01:18:38 -0800
Message-ID: <20070130091838.31530.80531.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48767 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965451AbXA3JQH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:07 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9G5OF022914
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:05 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9G5nS293946
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:05 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9G5xL005733
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:05 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


The sas_ata_qc_issue function was incorrectly written to return error
codes such as -ENOMEM.  Since libata OR's qc->err_mask with the
return value, It is necessary to make my code return one of the
AC_ERR_ codes instead.  For now, use AC_ERR_SYSTEM because an error
here means that the OS couldn't send the command to the controller.

If anybody has a suggestion for a better AC_ERR_ code to use, please
suggest it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0bb1a14..46e1dbe 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -123,7 +123,7 @@ static void sas_ata_task_done(struct sas
 
 static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 {
-	int res = -ENOMEM;
+	int res;
 	struct sas_task *task;
 	struct domain_device *dev = qc->ap->private_data;
 	struct sas_ha_struct *sas_ha = dev->port->ha;
@@ -135,7 +135,7 @@ static unsigned int sas_ata_qc_issue(str
 
 	task = sas_alloc_task(GFP_ATOMIC);
 	if (!task)
-		goto out;
+		return AC_ERR_SYSTEM;
 	task->dev = dev;
 	task->task_proto = SAS_PROTOCOL_STP;
 	task->task_done = sas_ata_task_done;
@@ -187,12 +187,10 @@ static unsigned int sas_ata_qc_issue(str
 		SAS_DPRINTK("lldd_execute_task returned: %d\n", res);
 
 		sas_free_task(task);
-		if (res == -SAS_QUEUE_FULL)
-			return -ENOMEM;
+		return AC_ERR_SYSTEM;
 	}
 
-out:
-	return res;
+	return 0;
 }
 
 static u8 sas_ata_check_status(struct ata_port *ap)
