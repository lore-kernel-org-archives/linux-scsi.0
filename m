From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] scsi: remove tsk_mgmt_response and it_nexus_response transport methods
Date: Mon, 30 Jan 2017 13:18:59 +0100
Message-ID: <1485778739-29036-5-git-send-email-hch@lst.de>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53934 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752814AbdA3MTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2017 07:19:22 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cYAvX-0003oz-LN
        for linux-scsi@vger.kernel.org; Mon, 30 Jan 2017 12:19:20 +0000
In-Reply-To: <1485778739-29036-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

They are never called and just dispatch to methods of the same names in
the FC and SRP transport classes that are never implemented.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_transport_fc.c  | 17 -----------------
 drivers/scsi/scsi_transport_srp.c | 16 ----------------
 include/scsi/scsi_transport.h     | 12 ------------
 include/scsi/scsi_transport_srp.h |  7 -------
 4 files changed, 52 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 9a6ea6f..1be3394 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2160,19 +2160,6 @@ fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
 	return 0;
 }
 
-static int fc_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,
-				int result)
-{
-	struct fc_internal *i = to_fc_internal(shost->transportt);
-	return i->f->tsk_mgmt_response(shost, nexus, tm_id, result);
-}
-
-static int fc_it_nexus_response(struct Scsi_Host *shost, u64 nexus, int result)
-{
-	struct fc_internal *i = to_fc_internal(shost->transportt);
-	return i->f->it_nexus_response(shost, nexus, result);
-}
-
 struct scsi_transport_template *
 fc_attach_transport(struct fc_function_template *ft)
 {
@@ -2214,10 +2201,6 @@ fc_attach_transport(struct fc_function_template *ft)
 
 	i->t.user_scan = fc_user_scan;
 
-	/* target-mode drivers' functions */
-	i->t.tsk_mgmt_response = fc_tsk_mgmt_response;
-	i->t.it_nexus_response = fc_it_nexus_response;
-
 	/*
 	 * Setup SCSI Target Attributes.
 	 */
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 75b57a1..3c5d898 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -794,19 +794,6 @@ void srp_stop_rport_timers(struct srp_rport *rport)
 }
 EXPORT_SYMBOL_GPL(srp_stop_rport_timers);
 
-static int srp_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,
-				 int result)
-{
-	struct srp_internal *i = to_srp_internal(shost->transportt);
-	return i->f->tsk_mgmt_response(shost, nexus, tm_id, result);
-}
-
-static int srp_it_nexus_response(struct Scsi_Host *shost, u64 nexus, int result)
-{
-	struct srp_internal *i = to_srp_internal(shost->transportt);
-	return i->f->it_nexus_response(shost, nexus, result);
-}
-
 /**
  * srp_attach_transport  -  instantiate SRP transport template
  * @ft:		SRP transport class function template
@@ -821,9 +808,6 @@ srp_attach_transport(struct srp_function_template *ft)
 	if (!i)
 		return NULL;
 
-	i->t.tsk_mgmt_response = srp_tsk_mgmt_response;
-	i->t.it_nexus_response = srp_it_nexus_response;
-
 	i->t.host_size = sizeof(struct srp_host_attrs);
 	i->t.host_attrs.ac.attrs = &i->host_attrs[0];
 	i->t.host_attrs.ac.class = &srp_host_class.class;
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 6c3bb9f..cbb6bb0 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -56,18 +56,6 @@ struct scsi_transport_template {
 	 * Allows a transport to override the default error handler.
 	 */
 	void (* eh_strategy_handler)(struct Scsi_Host *);
-
-	/*
-	 * Used as callback for the completion of i_t_nexus request
-	 * for target drivers.
-	 */
-	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
-
-	/*
-	 * Used as callback for the completion of task management
-	 * request for target drivers.
-	 */
-	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 };
 
 #define transport_class_to_shost(tc) \
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 20d9679..dd09633 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -88,10 +88,6 @@ struct srp_rport {
  * @terminate_rport_io: Callback function for terminating all outstanding I/O
  *     requests for an rport.
  * @rport_delete: Callback function that deletes an rport.
- *
- * Fields that are only relevant for SRP target drivers:
- * @tsk_mgmt_response: Callback function for sending a task management response.
- * @it_nexus_response: Callback function for processing an IT nexus response.
  */
 struct srp_function_template {
 	/* for initiator drivers */
@@ -103,9 +99,6 @@ struct srp_function_template {
 	int (*reconnect)(struct srp_rport *rport);
 	void (*terminate_rport_io)(struct srp_rport *rport);
 	void (*rport_delete)(struct srp_rport *rport);
-	/* for target drivers */
-	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
-	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
 };
 
 extern struct scsi_transport_template *
-- 
2.1.4

