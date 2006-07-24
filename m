From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/11] iscsi bugfixes: fix oops when removing session
Date: Mon, 24 Jul 2006 15:47:29 -0500
Message-ID: <1153774049.1040.37.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:17088 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751443AbWGXUte (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:49:34 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKnDJq012553
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:49:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Or Gerlitz:

We are touching the cls_session after we have freed
it. This causes a oops.

Signed-off-by: Or Gerlitz  <ogerlitz@voltaire.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 92186f0..775fd2a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1337,6 +1337,7 @@ void iscsi_session_teardown(struct iscsi
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct module *owner = cls_session->transport->owner;
 
 	scsi_remove_host(shost);
 
@@ -1345,7 +1346,7 @@ void iscsi_session_teardown(struct iscsi
 
 	iscsi_destroy_session(cls_session);
 	scsi_host_put(shost);
-	module_put(cls_session->transport->owner);
+	module_put(owner);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 


