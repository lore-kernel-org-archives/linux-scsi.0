From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Move the eh_deadline module parameter definition to the top of hosts.c
Date: Mon, 12 Feb 2018 10:41:29 -0800
Message-ID: <20180212184129.25919-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19658 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbeBLSm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2018 13:42:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

The eh_deadline definition occurs in the middle of the code for
releasing a host. Avoid splitting the host release code by moving
the definition of the eh_deadline parameter to the top of the
hosts.c source file.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/hosts.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 57bf43e34863..a0a7e4ff255c 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -42,6 +42,12 @@
 #include "scsi_logging.h"
 
 
+static int shost_eh_deadline = -1;
+
+module_param_named(eh_deadline, shost_eh_deadline, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(eh_deadline,
+		 "SCSI EH timeout in seconds (should be between 0 and 2^31-1)");
+
 static DEFINE_IDA(host_index_ida);
 
 
@@ -358,12 +364,6 @@ static void scsi_host_dev_release(struct device *dev)
 	kfree(shost);
 }
 
-static int shost_eh_deadline = -1;
-
-module_param_named(eh_deadline, shost_eh_deadline, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(eh_deadline,
-		 "SCSI EH timeout in seconds (should be between 0 and 2^31-1)");
-
 static struct device_type scsi_host_type = {
 	.name =		"scsi_host",
 	.release =	scsi_host_dev_release,
-- 
2.16.1
