From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 3/4] scsi_dh_alua: do not call BUG_ON when updating port group
Date: Fri, 12 May 2017 15:15:07 +0200
Message-ID: <20170512131508.3231-4-mwilck@suse.com>
References: <20170512131508.3231-1-mwilck@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:36267 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755393AbdELNPq (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 12 May 2017 09:15:46 -0400
In-Reply-To: <20170512131508.3231-1-mwilck@suse.com>
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
 drivers/scsi/device_handler/scsi_dh_alua.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 2b60f493f90e..a59783020c66 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -652,9 +652,15 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
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
+						struct scsi_device *sdev =
+							h->sdev;
+						if (sdev)
+							sdev->access_state =
+								desc[0];
 					}
 					rcu_read_unlock();
 				}
@@ -694,11 +700,13 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			pg->expiry = 0;
 			rcu_read_lock();
 			list_for_each_entry_rcu(h, &pg->dh_list, node) {
-				BUG_ON(!h->sdev);
-				h->sdev->access_state =
+				struct scsi_device *sdev = h->sdev;
+				if (!sdev)
+					continue;
+				sdev->access_state =
 					(pg->state & SCSI_ACCESS_STATE_MASK);
 				if (pg->pref)
-					h->sdev->access_state |=
+					sdev->access_state |=
 						SCSI_ACCESS_STATE_PREFERRED;
 			}
 			rcu_read_unlock();
-- 
2.12.2
