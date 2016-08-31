From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 11/15] smartpqi: scsi queuecommand cleanup
Date: Wed, 31 Aug 2016 14:55:11 -0500
Message-ID: <147267331138.22907.3283526888162495977.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0061.outbound.protection.outlook.com ([104.47.41.61]:58432
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752605AbcHaTzb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 15:55:31 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

minor cleanup of scsi queue command function

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index db248c1..f0672ed 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4514,7 +4514,7 @@ static int pqi_aio_submit_io(struct pqi_ctrl_info *ctrl_info,
 }
 
 static int pqi_scsi_queue_command(struct Scsi_Host *shost,
-				struct scsi_cmnd *scmd)
+	struct scsi_cmnd *scmd)
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
@@ -4532,6 +4532,12 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost,
 		return 0;
 	}
 
+	/*
+	 * This is necessary because the SML doesn't zero out this field during
+	 * error recovery.
+	 */
+	scmd->result = 0;
+
 	hwq = blk_mq_unique_tag_to_hwq(blk_mq_unique_tag(scmd->request));
 	if (hwq >= ctrl_info->num_queue_groups)
 		hwq = 0;

