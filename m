From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi: move target_destroy call
Date: Tue, 14 Mar 2006 11:18:46 -0800
Message-ID: <20060314191846.GA16127@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:18893 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1752032AbWCNTUC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 14:20:02 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k2EJK2qW030673
	for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2006 14:20:02 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2EJMuHd168562
	for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2006 12:22:56 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2EJK0J8029223
	for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2006 12:20:01 -0700
Received: from hmsbounty.us.ibm.com (dyn9047022094.beaverton.ibm.com [9.47.22.94])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k2EJK0q8029159
	for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2006 12:20:00 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This patch moves the calling of target_destroy next to the list_del. This
closed a race being seen while doing a device add on the aic7xxx.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/scsi/scsi_scan.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_scan.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_scan.c	2006-03-12 14:39:27.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_scan.c	2006-03-14 11:09:00.000000000 -0800
@@ -288,10 +288,7 @@ static void scsi_target_dev_release(stru
 {
 	struct device *parent = dev->parent;
 	struct scsi_target *starget = to_scsi_target(dev);
-	struct Scsi_Host *shost = dev_to_shost(parent);
 
-	if (shost->hostt->target_destroy)
-		shost->hostt->target_destroy(starget);
 	kfree(starget);
 	put_device(parent);
 }
@@ -416,6 +413,8 @@ static void scsi_target_reap_usercontext
 	device_del(&starget->dev);
 	transport_destroy_device(&starget->dev);
 	spin_lock_irqsave(shost->host_lock, flags);
+	if (shost->hostt->target_destroy)
+		shost->hostt->target_destroy(starget);
 	list_del_init(&starget->siblings);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(&starget->dev);
