From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 09/12] sas_ata: Assign sas_task to scsi_cmnd to enable EH for ATA devices
Date: Tue, 30 Jan 2007 01:18:55 -0800
Message-ID: <20070130091855.31530.25102.stgit@elm3a70.beaverton.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48825 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965455AbXA3JQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jan 2007 04:16:24 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0U9GMV2023165
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:22 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0U9GMUp299096
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:22 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0U9GLiZ017233
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2007 04:16:21 -0500
In-Reply-To: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


The SATL should connect the scsi_cmnd to the sas_task (despite the presence
of libata) so that requests to abort scsi_cmnds headed to the ATA device
can be processed by the EH and aborted correctly.  The abort status should
still be propagated from sas -> ata -> scsi.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 7ebda69..8111222 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -119,6 +119,8 @@ static void sas_ata_task_done(struct sas
 	}
 
 	qc->lldd_task = NULL;
+	if (qc->scsicmd)
+		ASSIGN_SAS_TASK(qc->scsicmd, NULL);
 	ata_qc_complete(qc);
 	spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
 
@@ -184,6 +186,9 @@ static unsigned int sas_ata_qc_issue(str
 		break;
 	}
 
+	if (qc->scsicmd)
+		ASSIGN_SAS_TASK(qc->scsicmd, task);
+
 	if (sas_ha->lldd_max_execute_num < 2)
 		res = i->dft->lldd_execute_task(task, 1, GFP_ATOMIC);
 	else
@@ -193,6 +198,8 @@ static unsigned int sas_ata_qc_issue(str
 	if (res) {
 		SAS_DPRINTK("lldd_execute_task returned: %d\n", res);
 
+		if (qc->scsicmd)
+			ASSIGN_SAS_TASK(qc->scsicmd, NULL);
 		sas_free_task(task);
 		return AC_ERR_SYSTEM;
 	}
