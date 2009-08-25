From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 31/64] libfc: rename rport event CREATED to READY
Date: Tue, 25 Aug 2009 14:01:12 -0700
Message-ID: <20090825210112.1553.29679.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbZHYVBK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:01:10 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

Remote ports will become READY more than once after
ADISC is implemented in a later patch.

The event callback that has been called "CREATED" will mean "READY".
Rename it now in preparation for those changes.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |    2 +-
 drivers/scsi/libfc/fc_lport.c |    4 ++--
 drivers/scsi/libfc/fc_rport.c |    4 ++--
 include/scsi/libfc.h          |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 5f839b6..e5e5b26 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -118,7 +118,7 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 		    rdata->ids.port_id);
 
 	switch (event) {
-	case RPORT_EV_CREATED:
+	case RPORT_EV_READY:
 		if (disc) {
 			mutex_lock(&disc->disc_mutex);
 			list_add_tail(&rdata->peers, &disc->rports);
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a7fe6b8..016f771 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -147,14 +147,14 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 		     rdata->ids.port_id);
 
 	switch (event) {
-	case RPORT_EV_CREATED:
+	case RPORT_EV_READY:
 		if (rdata->ids.port_id == FC_FID_DIR_SERV) {
 			mutex_lock(&lport->lp_mutex);
 			if (lport->state == LPORT_ST_DNS) {
 				lport->dns_rp = rdata;
 				fc_lport_enter_rpn_id(lport);
 			} else {
-				FC_LPORT_DBG(lport, "Received an CREATED event "
+				FC_LPORT_DBG(lport, "Received an READY event "
 					     "on port (%6x) for the directory "
 					     "server, but the lport is not "
 					     "in the DNS state, it's in the "
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index d0a4542..50959ba 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -244,7 +244,7 @@ static void fc_rport_work(struct work_struct *work)
 	rport = rdata->rport;
 
 	switch (event) {
-	case RPORT_EV_CREATED:
+	case RPORT_EV_READY:
 		ids = rdata->ids;
 		rdata->event = RPORT_EV_NONE;
 		mutex_unlock(&rdata->rp_mutex);
@@ -413,7 +413,7 @@ static void fc_rport_enter_ready(struct fc_rport_priv *rdata)
 
 	if (rdata->event == RPORT_EV_NONE)
 		queue_work(rport_event_queue, &rdata->event_work);
-	rdata->event = RPORT_EV_CREATED;
+	rdata->event = RPORT_EV_READY;
 }
 
 /**
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index a94d216..d324df8 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -167,7 +167,7 @@ struct fc_disc_port {
 
 enum fc_rport_event {
 	RPORT_EV_NONE = 0,
-	RPORT_EV_CREATED,
+	RPORT_EV_READY,
 	RPORT_EV_FAILED,
 	RPORT_EV_STOP,
 	RPORT_EV_LOGO

