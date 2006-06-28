From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 8/9] iscsi: pass target nr to session creation
Date: Wed, 28 Jun 2006 12:00:31 -0500
Message-ID: <1151514031.11553.54.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:31923 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751508AbWF1REz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:04:55 -0400
Received: from [192.168.0.7] (c-69-180-139-167.hsd1.mn.comcast.net [69.180.139.167])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k5SH4X90019961
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 12:04:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

So the drivers do not use the channel numbers, but some do
use the target numbers. We were just adding some goofy
variable that just increases for the target nr. This is useless
for software iscsi because it is always zero. And for qla4xxx
the target nr is actually the index of the target/session
in its FW or FLASH tables. We needed to expose this to userspace
so apps could access those numbers so this patch just adds the
target nr to the iscsi session creation functions. This way
when qla4xxx's Hw thinks a session is at target nr 4
in its hw, it is exposed as that number in sysfs.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 499e79f..7e6e031 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1290,7 +1290,7 @@ iscsi_session_setup(struct iscsi_transpo
 	if (!try_module_get(iscsit->owner))
 		goto cls_session_fail;
 
-	cls_session = iscsi_create_session(shost, iscsit);
+	cls_session = iscsi_create_session(shost, iscsit, 0);
 	if (!cls_session)
 		goto module_put;
 	*(unsigned long*)shost->hostdata = (unsigned long)cls_session;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f39da0c..7963c05 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -304,6 +304,8 @@ iscsi_alloc_session(struct Scsi_Host *sh
 	INIT_LIST_HEAD(&session->host_list);
 	INIT_LIST_HEAD(&session->sess_list);
 
+	/* this is released in the dev's release function */
+	scsi_host_get(shost);
 	session->dev.parent = &shost->shost_gendev;
 	session->dev.release = iscsi_session_release;
 	device_initialize(&session->dev);
@@ -313,18 +315,15 @@ iscsi_alloc_session(struct Scsi_Host *sh
 }
 EXPORT_SYMBOL_GPL(iscsi_alloc_session);
 
-int iscsi_add_session(struct iscsi_cls_session *session)
+int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	struct iscsi_host *ihost;
 	int err;
 
-	/* this is released in the dev's release function */
-	scsi_host_get(shost);
 	ihost = shost->shost_data;
-
 	session->sid = iscsi_session_nr++;
-	session->target_id = ihost->next_target_id++;
+	session->target_id = target_id;
 
 	snprintf(session->dev.bus_id, BUS_ID_SIZE, "session%u",
 		 session->sid);
@@ -356,7 +355,8 @@ EXPORT_SYMBOL_GPL(iscsi_add_session);
  **/
 struct iscsi_cls_session *
 iscsi_create_session(struct Scsi_Host *shost,
-		     struct iscsi_transport *transport)
+		     struct iscsi_transport *transport,
+		     unsigned int target_id)
 {
 	struct iscsi_cls_session *session;
 
@@ -364,7 +364,7 @@ iscsi_create_session(struct Scsi_Host *s
 	if (!session)
 		return NULL;
 
-	if (iscsi_add_session(session)) {
+	if (iscsi_add_session(session, target_id)) {
 		iscsi_free_session(session);
 		return NULL;
 	}
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 53493d5..f7b0db5 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -203,7 +203,6 @@ #define starget_to_session(_stgt) \
 	iscsi_dev_to_session(_stgt->dev.parent)
 
 struct iscsi_host {
-	int next_target_id;
 	struct list_head sessions;
 	struct mutex mutex;
 };
@@ -213,9 +212,11 @@ struct iscsi_host {
  */
 extern struct iscsi_cls_session *iscsi_alloc_session(struct Scsi_Host *shost,
 					struct iscsi_transport *transport);
-extern int iscsi_add_session(struct iscsi_cls_session *session);
+extern int iscsi_add_session(struct iscsi_cls_session *session,
+			     unsigned int target_id);
 extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
-						struct iscsi_transport *t);
+						struct iscsi_transport *t,
+						unsigned int target_id);
 extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern int iscsi_destroy_session(struct iscsi_cls_session *session);


