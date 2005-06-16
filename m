From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 3/5] scsi host / scsi target state model update
Date: Thu, 16 Jun 2005 11:14:33 -0700
Message-ID: <20050616181433.GD20923@us.ibm.com>
References: <20050616181058.GA20923@us.ibm.com> <20050616181238.GB20923@us.ibm.com> <20050616181342.GC20923@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46290 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261787AbVFPSOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 14:14:04 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5GIE4Jt024109
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:14:04 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5GIE4an242364
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:14:04 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5GIE4Ts026064
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:14:04 -0400
Received: from hmsbounty.us.ibm.com (sig-9-48-50-108.mts.ibm.com [9.48.50.108])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j5GIE2nQ026000
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:14:03 -0400
Content-Disposition: inline
In-Reply-To: <20050616181342.GC20923@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add support to not allow additions to a host when it is being removed.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/hosts.c     |    2 +
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_scan.c |   21 ++++++++++++------
 linux-2.6.12-rc6-mm1-andmike/include/scsi/scsi_host.h |    9 +++++++
 3 files changed, 25 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/hosts.c~host_scan drivers/scsi/hosts.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/hosts.c~host_scan	2005-06-16 10:47:17.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/hosts.c	2005-06-16 10:47:17.000000000 -0700
@@ -133,7 +133,9 @@ EXPORT_SYMBOL(scsi_host_set_state);
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
+	down(&shost->scan_mutex);
 	scsi_host_set_state(shost, SHOST_CANCEL);
+	up(&shost->scan_mutex);
 	scsi_forget_host(shost);
 	scsi_proc_host_rm(shost);
 
diff -puN include/scsi/scsi_host.h~host_scan include/scsi/scsi_host.h
--- linux-2.6.12-rc6-mm1/include/scsi/scsi_host.h~host_scan	2005-06-16 10:47:17.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/include/scsi/scsi_host.h	2005-06-16 10:47:17.000000000 -0700
@@ -656,6 +656,15 @@ static inline struct device *scsi_get_de
         return shost->shost_gendev.parent;
 }
 
+/**
+ * scsi_host_scan_allowed - Is scanning of this host allowed
+ * @shost:	Pointer to Scsi_Host.
+ **/
+static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
+{
+	return shost->shost_state == SHOST_RUNNING;
+}
+
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
 
diff -puN drivers/scsi/scsi_scan.c~host_scan drivers/scsi/scsi_scan.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_scan.c~host_scan	2005-06-16 10:47:17.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_scan.c	2005-06-16 10:47:17.000000000 -0700
@@ -1218,9 +1218,12 @@ struct scsi_device *__scsi_add_device(st
 
 	get_device(&starget->dev);
 	down(&shost->scan_mutex);
-	res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
-	if (res != SCSI_SCAN_LUN_PRESENT)
-		sdev = ERR_PTR(-ENODEV);
+	if (scsi_host_scan_allowed(shost)) {
+		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
+					     hostdata);
+		if (res != SCSI_SCAN_LUN_PRESENT)
+			sdev = ERR_PTR(-ENODEV);
+	}
 	up(&shost->scan_mutex);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
@@ -1370,11 +1373,15 @@ int scsi_scan_host_selected(struct Scsi_
 		return -EINVAL;
 
 	down(&shost->scan_mutex);
-	if (channel == SCAN_WILD_CARD) 
-		for (channel = 0; channel <= shost->max_channel; channel++)
+	if (scsi_host_scan_allowed(shost)) {
+		if (channel == SCAN_WILD_CARD)
+			for (channel = 0; channel <= shost->max_channel;
+			     channel++)
+				scsi_scan_channel(shost, channel, id, lun,
+						  rescan);
+		else
 			scsi_scan_channel(shost, channel, id, lun, rescan);
-	else
-		scsi_scan_channel(shost, channel, id, lun, rescan);
+	}
 	up(&shost->scan_mutex);
 
 	return 0;
_
