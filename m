From: satishkh@cisco.com
Subject: [PATCH 1/1] scsi/libfc: fix a deadlock in fc_rport_work
Date: Thu,  5 Oct 2017 16:41:21 -0700
Message-ID: <1507246881-20508-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:46555 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdJEXvL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2017 19:51:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com

From: Satish Kharat <satishkh@cisco.com>

In places like fc_rport_recv_plogi_req and fcoe_ctlr_vn_add we
always take the lport disc_mutex lock before the rports mutex
(rp_mutex) lock. Gaurding list_del_rcu(&rdata->peers) with
disc.disc_mutex in fc_rport_work is correct but the rp_mutex lock
can and should to be dropped before taking that lock else results
in a deadlock.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/libfc/fc_rport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 5203258..31d31aa 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -383,11 +383,11 @@ static void fc_rport_work(struct work_struct *work)
 				fc_rport_enter_flogi(rdata);
 				mutex_unlock(&rdata->rp_mutex);
 			} else {
+				mutex_unlock(&rdata->rp_mutex);
 				FC_RPORT_DBG(rdata, "work delete\n");
 				mutex_lock(&lport->disc.disc_mutex);
 				list_del_rcu(&rdata->peers);
 				mutex_unlock(&lport->disc.disc_mutex);
-				mutex_unlock(&rdata->rp_mutex);
 				kref_put(&rdata->kref, fc_rport_destroy);
 			}
 		} else {
-- 
2.5.5
