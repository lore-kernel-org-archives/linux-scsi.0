From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 5/6] tgt: move tsk_mgmt_response callback to transport class
Date: Wed, 11 Jul 2007 15:08:22 +0900
Message-ID: <20070711150822Z.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56210 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976AbXGKGMF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2007 02:12:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

This moves tsk_mgmt_response callback in struct scsi_host_template to
struct scsi_transport_template since struct scsi_transport_template is
more suitable for the task management stuff.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_tgt_lib.c       |    2 +-
 drivers/scsi/scsi_transport_srp.c |   12 ++++++++++--
 include/scsi/scsi_host.h          |    3 ---
 include/scsi/scsi_transport.h     |    6 ++++++
 include/scsi/scsi_transport_srp.h |    1 +
 5 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 7d15173..0482143 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -577,7 +577,7 @@ int scsi_tgt_kspace_tsk_mgmt(int host_no
 		goto done;
 	}
 
-	err = shost->hostt->tsk_mgmt_response(shost, itn_id, mid, result);
+	err = shost->transportt->tsk_mgmt_response(shost, itn_id, mid, result);
 done:
 	scsi_host_put(shost);
 	return err;
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 8e5b41c..cdd001a 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -280,10 +280,17 @@ void srp_remove_host(struct Scsi_Host *s
 }
 EXPORT_SYMBOL_GPL(srp_remove_host);
 
-static int srp_it_nexus_response(struct Scsi_Host *shost, u64 id, int result)
+static int srp_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,
+				 int result)
 {
 	struct srp_internal *i = to_srp_internal(shost->transportt);
-	return i->f->it_nexus_response(shost, id, result);
+	return i->f->tsk_mgmt_response(shost, nexus, tm_id, result);
+}
+
+static int srp_it_nexus_response(struct Scsi_Host *shost, u64 nexus, int result)
+{
+	struct srp_internal *i = to_srp_internal(shost->transportt);
+	return i->f->it_nexus_response(shost, nexus, result);
 }
 
 /**
@@ -300,6 +307,7 @@ srp_attach_transport(struct srp_function
 	if (!i)
 		return NULL;
 
+	i->t.tsk_mgmt_response = srp_tsk_mgmt_response;
 	i->t.it_nexus_response = srp_it_nexus_response;
 
 	i->t.host_size = sizeof(struct srp_host_attrs);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index dcf4a20..0f482ba 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -145,9 +145,6 @@ #endif
 	int (* transfer_response)(struct scsi_cmnd *,
 				  void (*done)(struct scsi_cmnd *));
 
-	/* Used as callback for the completion of task management request. */
-	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64 mid, int result);
-
 	/*
 	 * This is an error handling strategy routine.  You don't need to
 	 * define one of these if you don't want to - there is a default
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index af5b3e1..0dfef75 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -71,6 +71,12 @@ struct scsi_transport_template {
 	 * for target drivers.
 	 */
 	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
+
+	/*
+	 * Used as callback for the completion of task management
+	 * request for target drivers.
+	 */
+	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 };
 
 #define transport_class_to_shost(tc) \
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index a705dbc..9c60ca1 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -22,6 +22,7 @@ struct srp_rport {
 
 struct srp_function_template {
 	/* for target drivers */
+	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
 };
 
-- 
1.4.3.2

