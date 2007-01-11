From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 06/21] libsas: Destroy the task collector thread after releasing ports
Date: Thu, 11 Jan 2007 14:15:03 -0800
Message-ID: <20070111221503.3543.79790.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48204 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbXAKWOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:45 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMEhfW026748
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:43 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEhoK273470
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:43 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEhmn012420
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:43 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


If we use task collector mode, we can end up destroying the task collector
thread before we release the ports, which is bad if a port release causes
a disk I/O (such as cache flushing).

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 90cce34..4df73d6 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -127,12 +127,13 @@ Undo_phys:
 
 int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 {
+	sas_unregister_ports(sas_ha);
+
 	if (sas_ha->lldd_max_execute_num > 1) {
 		sas_shutdown_queue(sas_ha);
+		sas_ha->lldd_max_execute_num = 1;
 	}
 
-	sas_unregister_ports(sas_ha);
-
 	return 0;
 }
 
