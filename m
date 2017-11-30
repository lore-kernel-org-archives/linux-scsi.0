From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/2] Convert a source code comment into a runtime check
Date: Thu, 30 Nov 2017 14:44:56 -0800
Message-ID: <20171130224456.23100-3-bart.vanassche@wdc.com>
References: <20171130224456.23100-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:2571 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbdK3Wo7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Nov 2017 17:44:59 -0500
In-Reply-To: <20171130224456.23100-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_error.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b22a9a23c74c..1622eacbf577 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -61,9 +61,10 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
 static int scsi_try_to_abort_cmd(struct scsi_host_template *,
 				 struct scsi_cmnd *);
 
-/* called with shost->host_lock held */
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
+	lockdep_assert_held(shost->host_lock);
+
 	if (atomic_read(&shost->host_busy) == shost->host_failed) {
 		trace_scsi_eh_wakeup(shost);
 		wake_up_process(shost->ehandler);
-- 
2.15.0
