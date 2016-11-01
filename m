From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] scsi_dh_alua: Fix a reference counting bug
Date: Tue, 1 Nov 2016 08:19:57 -0600
Message-ID: <bf51a27f-d99f-4a43-867b-0b683ec1784d@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0051.outbound.protection.outlook.com ([104.47.34.51]:26144
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966312AbcKAOUM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 1 Nov 2016 10:20:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, tang.junhui@zte.com.cn, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The code at the end of alua_rtpg_work() is as follows:

	scsi_device_put(sdev);
	kref_put(&pg->kref, release_port_group);

In other words, alua_rtpg_queue() must hold an sdev reference and
a pg reference before queueing rtpg work. If no rtpg work is queued
no additional references should be held when alua_rtpg_queue()
returns. If no rtpg work is queued, ensure that alua_rtpg_queue()
only gives up the sdev reference if that reference was obtained by
the same alua_rtpg_queue() call.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Tang Junhui <tang.junhui@zte.com.cn>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f375167..7bb2068 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -891,6 +891,7 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 		/* Do not queue if the worker is already running */
 		if (!(pg->flags & ALUA_PG_RUNNING)) {
 			kref_get(&pg->kref);
+			sdev = NULL;
 			start_queue = 1;
 		}
 	}
@@ -902,7 +903,8 @@ static void alua_rtpg_queue(struct alua_port_group *pg,
 	if (start_queue &&
 	    !queue_delayed_work(alua_wq, &pg->rtpg_work,
 				msecs_to_jiffies(ALUA_RTPG_DELAY_MSECS))) {
-		scsi_device_put(sdev);
+		if (sdev)
+			scsi_device_put(sdev);
 		kref_put(&pg->kref, release_port_group);
 	}
 }
-- 
2.10.1

