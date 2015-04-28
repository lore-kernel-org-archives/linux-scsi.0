From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi_scan: fix queue depth initialisation problem
Date: Tue, 28 Apr 2015 14:24:10 -0700
Message-ID: <1430256250.2181.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34266 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965999AbbD1VYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2015 17:24:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>

From: James Bottomley <JBottomley@Odin.com>
Date: Sun, 26 Apr 2015 11:52:46 -0700
Subject: [PATCH] scsi_scan: fix queue depth initialisation problem

Currently we blindly use the value of cmd_per_lun as the initial setting for
queue_depth.  This fails miserably (hangs the system) if it is zero, which is
the default value for anything uninitialised in the template.  The net result
is that every host template has to set a value for cmd_per_lun.  Instead, use
a default value of 1 if the actual value is unset.  This should pave the way
for removing cmd_per_lun from all the templates and eventually from SCSI
itself.

Signed-off-by: James Bottomley <JBottomley@Odin.com>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60aae01..681a59a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -280,7 +280,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 				    sdev->host->cmd_per_lun, shost->bqt,
 				    shost->hostt->tag_alloc_policy);
 	}
-	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun);
+	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
+					sdev->host->cmd_per_lun : 1);
 
 	scsi_sysfs_device_initialize(sdev);
 


