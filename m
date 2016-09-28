From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] scsi_dh_alua: Fix a reference counting bug
Date: Wed, 28 Sep 2016 16:45:20 -0700
Message-ID: <dbb073e5-817b-c2bd-26b1-b12752a9d82b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0081.outbound.protection.outlook.com ([104.47.38.81]:36127
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751839AbcI1Xqd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Sep 2016 19:46:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The code at the end of alua_rtpg_work() is as follows:

	scsi_device_put(sdev);
	kref_put(&pg->kref, release_port_group);

Make sure that all code that queues the work item associated
with alua_rtpg_work() holds both references.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 752b5c9..f7099e2 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -889,6 +889,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		/* Do not queue if the worker is already running */
 		if (!(pg->flags & ALUA_PG_RUNNING)) {
 			kref_get(&pg->kref);
+			scsi_device_get(sdev);
 			start_queue = 1;
 		}
 	}
-- 
2.10.0

