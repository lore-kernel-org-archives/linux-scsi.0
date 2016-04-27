From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5] qla1280: Don't allocate 512kb of host tags
Date: Wed, 27 Apr 2016 10:48:52 +0200
Message-ID: <1461746932-123934-1-git-send-email-jthumshirn@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Michael Reed <mdr@sgi.com>, Laura Abbott <labbott@redhat.com>, Laurence Oberman <loberman@redhat.com>, Lee Duncan <lduncan@suse.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org, #@suse.de, v4.4@suse.de
List-Id: linux-scsi@vger.kernel.org

The qla1280 driver sets the scsi_host_template's can_queue field to 0xfffff
which results in an allocation failure when allocating the block layer tags
for the driver's queues. This was introduced with the change for host wide
tags in commit 64d513ac31b - "scsi: use host wide tags by default".

Reduce can_queue to MAX_OUTSTANDING_COMMANDS (512) to solve the allocation
error.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Fixes: 64d513ac31b - "scsi: use host wide tags by default"
Cc: stable@vger.kernel.org # v4.4
Cc: Laura Abbott <labbott@redhat.com>
Cc: Michael Reed <mdr@sgi.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
Changes to v4:
* Make subject more meaningfull
* Remove warning's backtrace
* Re-add reference to commit  64d513ac31b - "scsi: use host wide tags by default"

Changes to v3:
* Use  MAX_OUTSTANDING_COMMANDS insted of hard coded magical number

Changes to v2:
* Change can_queue to 512 upon James' request

 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 5d0ec42..634254a 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4214,7 +4214,7 @@ static struct scsi_host_template qla1280_driver_template = {
 	.eh_bus_reset_handler	= qla1280_eh_bus_reset,
 	.eh_host_reset_handler	= qla1280_eh_adapter_reset,
 	.bios_param		= qla1280_biosparam,
-	.can_queue		= 0xfffff,
+	.can_queue		= MAX_OUTSTANDING_COMMANDS,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.use_clustering		= ENABLE_CLUSTERING,
-- 
2.8.1
