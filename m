From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/9] iscsi: rm channel usage from iscsi
Date: Wed, 28 Jun 2006 12:00:29 -0500
Message-ID: <1151514029.11553.52.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:30899 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751426AbWF1REC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:04:02 -0400
Received: from [192.168.0.7] (c-69-180-139-167.hsd1.mn.comcast.net [69.180.139.167])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k5SH3fEN019951
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 12:04:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I do not remember what I was thinking when we added the channel
as a argument to the session create function. It was probably
due to too much cut and paste work from the FC transport class.

The channel is meaningless for iscsi drivers so this patch drops
its usage everywhere in the iscsi related code.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7e6e031..499e79f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1290,7 +1290,7 @@ iscsi_session_setup(struct iscsi_transpo
 	if (!try_module_get(iscsit->owner))
 		goto cls_session_fail;
 
-	cls_session = iscsi_create_session(shost, iscsit, 0);
+	cls_session = iscsi_create_session(shost, iscsit);
 	if (!cls_session)
 		goto module_put;
 	*(unsigned long*)shost->hostdata = (unsigned long)cls_session;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 8717ff5..bebeb7d 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -248,10 +248,9 @@ static int iscsi_user_scan(struct Scsi_H
 
 	mutex_lock(&ihost->mutex);
 	list_for_each_entry(session, &ihost->sessions, host_list) {
-		if ((channel == SCAN_WILD_CARD ||
-		     channel == session->channel) &&
+		if ((channel == SCAN_WILD_CARD || channel == 0) &&
 		    (id == SCAN_WILD_CARD || id == session->target_id))
-			scsi_scan_target(&session->dev, session->channel,
+			scsi_scan_target(&session->dev, 0,
 					 session->target_id, lun, 1);
 	}
 	mutex_unlock(&ihost->mutex);
@@ -297,7 +296,7 @@ EXPORT_SYMBOL_GPL(iscsi_block_session);
  **/
 struct iscsi_cls_session *
 iscsi_create_session(struct Scsi_Host *shost,
-		     struct iscsi_transport *transport, int channel)
+		     struct iscsi_transport *transport)
 {
 	struct iscsi_host *ihost;
 	struct iscsi_cls_session *session;
@@ -322,7 +321,6 @@ iscsi_create_session(struct Scsi_Host *s
 	ihost = shost->shost_data;
 
 	session->sid = iscsi_session_nr++;
-	session->channel = channel;
 	session->target_id = ihost->next_target_id++;
 
 	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u",
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 0539705..2e3cb37 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -187,7 +187,6 @@ struct iscsi_cls_session {
 	struct work_struct recovery_work;
 
 	int target_id;
-	int channel;
 
 	int sid;				/* session id */
 	void *dd_data;				/* LLD private data */
@@ -210,7 +209,7 @@ struct iscsi_host {
  * session and connection functions that can be used by HW iSCSI LLDs
  */
 extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
-				struct iscsi_transport *t, int channel);
+						struct iscsi_transport *t);
 extern int iscsi_destroy_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 					    uint32_t cid);


