From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 3/3] scsi_dh_alua: Warn if the first argument of alua_rtpg_queue() is NULL
Date: Fri, 17 Mar 2017 17:02:03 -0700
Message-ID: <20170318000203.7469-4-bart.vanassche@sandisk.com>
References: <20170318000203.7469-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:16594 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdCRAIM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2017 20:08:12 -0400
In-Reply-To: <20170318000203.7469-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Tang Junhui <tang.junhui@zte.com.cn>

Callers must provide a valid port group to alua_rtpg_queue().
Issue a kernel warning if that is not the case.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tang Junhui <tang.junhui@zte.com.cn>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index b6849d3ecefe..c01b47e5b55a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -876,7 +876,7 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
 	unsigned long flags;
 	struct workqueue_struct *alua_wq = kaluad_wq;
 
-	if (!pg || scsi_device_get(sdev))
+	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
 		return false;
 
 	spin_lock_irqsave(&pg->lock, flags);
-- 
2.12.0
