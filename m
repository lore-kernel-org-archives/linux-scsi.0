From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] scsi-misc-2.5 fold scsi_alloc_cmd into __scsi_get_command
Date: Thu, 24 Apr 2003 10:03:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424100341.B32134@beaverton.ibm.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:2799 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263410AbTDXQzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 12:55:16 -0400
Content-Disposition: inline
In-Reply-To: <20030424100317.A32134@beaverton.ibm.com>; from patmans@us.ibm.com on Thu, Apr 24, 2003 at 10:03:17AM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patch against scsi-misc-2.5

scsi_alloc_cmd is real simple now, just fold it into __scsi_get_command.

diff -purN -X /home/patman/dontdiff rmhost_flock-2.5-cur/drivers/scsi/scsi.c rmsacmd-2.5-cur/drivers/scsi/scsi.c
--- rmhost_flock-2.5-cur/drivers/scsi/scsi.c	Thu Apr 24 09:14:47 2003
+++ rmsacmd-2.5-cur/drivers/scsi/scsi.c	Thu Apr 24 09:15:07 2003
@@ -254,23 +254,6 @@ static struct scsi_host_cmd_pool scsi_cm
 
 static DECLARE_MUTEX(host_cmd_pool_mutex);
 
-static struct scsi_cmnd *scsi_alloc_cmd(struct scsi_device *sdev,
-					    int gfp_mask)
-{
-	struct scsi_cmnd *cmd;
-
-	/*
-	 * Use any spare command first.
-	 */
-	cmd = sdev->spare_cmd;
-	if (cmd != NULL)
-		sdev->spare_cmd = NULL;
-	else 
-		cmd = kmem_cache_alloc(sdev->host->cmd_pool->slab,
-				gfp_mask | sdev->host->cmd_pool->gfp_mask);
-	return cmd;
-}
-
 /*
  * Function:	__scsi_get_command()
  *
@@ -286,7 +269,17 @@ static struct scsi_cmnd *scsi_alloc_cmd(
  */
 struct scsi_cmnd *__scsi_get_command(struct scsi_device *dev, int gfp_mask)
 {
-	struct scsi_cmnd *cmd = scsi_alloc_cmd(dev, gfp_mask);
+	struct scsi_cmnd *cmd;
+
+	/*
+	 * Use any spare command first.
+	 */
+	cmd = dev->spare_cmd;
+	if (cmd != NULL)
+		dev->spare_cmd = NULL;
+	else 
+		cmd = kmem_cache_alloc(dev->host->cmd_pool->slab,
+				gfp_mask | dev->host->cmd_pool->gfp_mask);
 
 	if (likely(cmd != NULL)) {
 		memset(cmd, 0, sizeof(*cmd));
