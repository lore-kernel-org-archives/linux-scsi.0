From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 17/17] libfc: fix indefinite rport restart
Date: Fri, 11 Jun 2010 16:44:57 -0700
Message-ID: <20100611234457.4616.66863.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39246 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760253Ab0FKXo6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:58 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

Remote ports were restarting indefinitely after getting
rejects in PRLI.

Fix by adding a counter of restarts and limiting that with
the port login retry limit as well.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |    6 +++++-
 include/scsi/libfc.h          |    2 ++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index d385efc..363cde3 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -257,6 +257,7 @@ static void fc_rport_work(struct work_struct *work)
 	case RPORT_EV_READY:
 		ids = rdata->ids;
 		rdata->event = RPORT_EV_NONE;
+		rdata->major_retries = 0;
 		kref_get(&rdata->kref);
 		mutex_unlock(&rdata->rp_mutex);
 
@@ -323,7 +324,10 @@ static void fc_rport_work(struct work_struct *work)
 			if (port_id == FC_FID_DIR_SERV) {
 				rdata->event = RPORT_EV_NONE;
 				mutex_unlock(&rdata->rp_mutex);
-			} else if (rdata->flags & FC_RP_STARTED) {
+			} else if ((rdata->flags & FC_RP_STARTED) &&
+				   rdata->major_retries <
+				   lport->max_rport_retry_count) {
+				rdata->major_retries++;
 				rdata->event = RPORT_EV_NONE;
 				FC_RPORT_DBG(rdata, "work restart\n");
 				fc_rport_enter_plogi(rdata);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index db54c4a..6d78df7 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -189,6 +189,7 @@ struct fc_rport_libfc_priv {
  * @disc_id:        The discovery identifier
  * @maxframe_size:  The maximum frame size
  * @retries:        The retry count for the current state
+ * @major_retries:  The retry count for the entire PLOGI/PRLI state machine
  * @e_d_tov:        Error detect timeout value (in msec)
  * @r_a_tov:        Resource allocation timeout value (in msec)
  * @rp_mutex:       The mutex that protects the remote port
@@ -206,6 +207,7 @@ struct fc_rport_priv {
 	u16			    disc_id;
 	u16			    maxframe_size;
 	unsigned int	            retries;
+	unsigned int	            major_retries;
 	unsigned int	            e_d_tov;
 	unsigned int	            r_a_tov;
 	struct mutex                rp_mutex;

