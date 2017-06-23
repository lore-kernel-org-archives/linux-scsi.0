From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/35] hptiop: Simplify reset handling
Date: Fri, 23 Jun 2017 15:02:31 +0200
Message-ID: <1498222975-71858-12-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32839 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752377AbdFWND0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:26 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The Highpoint driver only has one reset function, and that is
a host reset. So stop pretending we're doing anything else.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hptiop.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index db17ad1..71ee2b4 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1106,12 +1106,10 @@ static int hptiop_reset_hba(struct hptiop_hba *hba)
 
 static int hptiop_reset(struct scsi_cmnd *scp)
 {
-	struct Scsi_Host * host = scp->device->host;
-	struct hptiop_hba * hba = (struct hptiop_hba *)host->hostdata;
+	struct hptiop_hba * hba = (struct hptiop_hba *)scp->device->host->hostdata;
 
-	printk(KERN_WARNING "hptiop_reset(%d/%d/%d) scp=%p\n",
-			scp->device->host->host_no, scp->device->channel,
-			scp->device->id, scp);
+	printk(KERN_WARNING "hptiop_reset(%d/%d/%d)\n",
+	       scp->device->host->host_no, -1, -1);
 
 	return hptiop_reset_hba(hba)? FAILED : SUCCESS;
 }
@@ -1179,8 +1177,7 @@ static int hptiop_slave_config(struct scsi_device *sdev)
 	.module                     = THIS_MODULE,
 	.name                       = driver_name,
 	.queuecommand               = hptiop_queuecommand,
-	.eh_device_reset_handler    = hptiop_reset,
-	.eh_bus_reset_handler       = hptiop_reset,
+	.eh_host_reset_handler      = hptiop_reset,
 	.info                       = hptiop_info,
 	.emulated                   = 0,
 	.use_clustering             = ENABLE_CLUSTERING,
-- 
1.8.5.6
