From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/20] scsi_dh_alua: Allow workqueue to run synchronously
Date: Tue,  8 Dec 2015 08:37:32 +0100
Message-ID: <1449560260-53407-13-git-send-email-hare@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46132 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201AbbLHHhr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 02:37:47 -0500
In-Reply-To: <1449560260-53407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Some arrays may only capable of handling one STPG at a time,
so this patch implements a module option 'sync_stpg' to have
STPGs submitted synchronously.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6fcdcd5..525449f 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -73,6 +73,10 @@ static uint optimize_stpg;
 module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(optimize_stpg, "Allow use of a non-optimized path, rather than sending a STPG, when implicit TPGS is supported (0=No,1=Yes). Default is 0.");
 
+static uint sync_stpg;
+module_param(sync_stpg, uint, S_IRUGO);
+MODULE_PARM_DESC(sync_stpg, "Issue STPG synchronously (0=No,1=Yes). Default is 0.");
+
 static LIST_HEAD(port_group_list);
 static DEFINE_SPINLOCK(port_group_lock);
 static struct workqueue_struct *kaluad_wq;
@@ -1019,9 +1023,11 @@ static struct scsi_device_handler alua_dh = {
 
 static int __init alua_init(void)
 {
-	int r;
+	int r, max_active = 0;
 
-	kaluad_wq = alloc_workqueue("kaluad", WQ_MEM_RECLAIM, 0);
+	if (sync_stpg)
+		max_active = 1;
+	kaluad_wq = alloc_workqueue("kaluad", WQ_MEM_RECLAIM, max_active);
 	if (!kaluad_wq) {
 		/* Temporary failure, bypass */
 		return SCSI_DH_DEV_TEMP_BUSY;
-- 
1.8.5.6

