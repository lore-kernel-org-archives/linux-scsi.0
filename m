From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/3] scsi_dh_alua: do not call BUG_ON when updating port group
Date: Fri, 28 Apr 2017 15:06:26 +0200
Message-ID: <20170428130626.32162-4-mwilck@suse.com>
References: <20170428130626.32162-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46152 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932337AbdD1NG6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Apr 2017 09:06:58 -0400
In-Reply-To: <20170428130626.32162-1-mwilck@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

alua_rtpg() can race with alua_bus_detach(). The assertion that
alua_dh_data *h->sdev must be non-NULL is not guaranteed because
alua_bus_detach sets this field to NULL before removing the entry
from the port group's dh_list.

This happens when a device is about to be removed, so don't BUG out
but continue silently.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 501855bde633..274fb49d0801 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -652,9 +652,13 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 					rcu_read_lock();
 					list_for_each_entry_rcu(h,
 						&tmp_pg->dh_list, node) {
-						/* h->sdev should always be valid */
-						BUG_ON(!h->sdev);
-						h->sdev->access_state = desc[0];
+						/*
+						 * We might be racing with
+						 * alua_bus_detach here
+						 */
+						if (h->sdev)
+							h->sdev->access_state =
+								desc[0];
 					}
 					rcu_read_unlock();
 				}
@@ -694,7 +698,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			pg->expiry = 0;
 			rcu_read_lock();
 			list_for_each_entry_rcu(h, &pg->dh_list, node) {
-				BUG_ON(!h->sdev);
+				if (!h->sdev)
+					continue;
 				h->sdev->access_state =
 					(pg->state & SCSI_ACCESS_STATE_MASK);
 				if (pg->pref)
-- 
2.12.2
