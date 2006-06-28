From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 5/9] iscsi: fix session refcouting
Date: Wed, 28 Jun 2006 12:00:27 -0500
Message-ID: <1151514027.11553.51.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:30387 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751446AbWF1RDg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:03:36 -0400
Received: from [192.168.0.7] (c-69-180-139-167.hsd1.mn.comcast.net [69.180.139.167])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k5SH3Ee1019948
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 12:03:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

iscsi_tcp and iser cannot be rmmod from the kernel when sessions
are running because session removal is driven from userspace. For
those modules we get a module reference when a session is
created then drop it when the session is removed.

For qla4xxx, they can jsut remove the sessions from the pci remove
function like normal HW drivers, so this patch moves the module
reference from the transport class functions shared by all
drivers to the libiscsi functions only used be software iscsi
modules.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7c76a98..7e6e031 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1287,13 +1287,18 @@ iscsi_session_setup(struct iscsi_transpo
 	if (scsi_add_host(shost, NULL))
 		goto add_host_fail;
 
+	if (!try_module_get(iscsit->owner))
+		goto cls_session_fail;
+
 	cls_session = iscsi_create_session(shost, iscsit, 0);
 	if (!cls_session)
-		goto cls_session_fail;
+		goto module_put;
 	*(unsigned long*)shost->hostdata = (unsigned long)cls_session;
 
 	return cls_session;
 
+module_put:
+	module_put(iscsit->owner);
 cls_session_fail:
 	scsi_remove_host(shost);
 add_host_fail:
@@ -1325,6 +1330,7 @@ void iscsi_session_teardown(struct iscsi
 
 	iscsi_destroy_session(cls_session);
 	scsi_host_put(shost);
+	module_put(cls_session->transport->owner);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -228,13 +228,11 @@ static struct iscsi_cls_conn *iscsi_conn
 static void iscsi_session_release(struct device *dev)
 {
 	struct iscsi_cls_session *session = iscsi_dev_to_session(dev);
-	struct iscsi_transport *transport = session->transport;
 	struct Scsi_Host *shost;
 
 	shost = iscsi_session_to_shost(session);
 	scsi_host_put(shost);
 	kfree(session);
-	module_put(transport->owner);
 }
 
 static int iscsi_is_session_dev(const struct device *dev)
@@ -305,13 +303,11 @@ iscsi_create_session(struct Scsi_Host *s
 	struct iscsi_cls_session *session;
 	int err;
 
-	if (!try_module_get(transport->owner))
-		return NULL;
-
 	session = kzalloc(sizeof(*session) + transport->sessiondata_size,
 			  GFP_KERNEL);
 	if (!session)
-		goto module_put;
+		return NULL;
+
 	session->transport = transport;
 	session->recovery_tmo = 120;
 	INIT_WORK(&session->recovery_work, session_recovery_timedout, session);
@@ -349,8 +345,6 @@ iscsi_create_session(struct Scsi_Host *s
 
 free_session:
 	kfree(session);
-module_put:
-	module_put(transport->owner);
 	return NULL;
 }
 


