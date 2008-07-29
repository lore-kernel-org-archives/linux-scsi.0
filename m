From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC] qla2xxx: Proposed protection of fcports field of struct
 scsi_qla_host
Date: Tue, 29 Jul 2008 14:49:43 +0400
Message-ID: <488EF5C7.7030305@vlnb.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050605070009090005030403"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:47127 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755586AbYG2Ktp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 06:49:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

This is a multi-part message in MIME format.
--------------050605070009090005030403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch is proposal for protection of fcports field of struct 
scsi_qla_host, which is currently unprotected.

The problem.

At the moment, in qla2xxx driver list fcports, which is part of struct 
scsi_qla_host, is unprotected by any way. Basically, only one function 
can add to this list new entries: qla2x00_configure_local_loop() 
(another one, qla2x00_configure_fabric(), can be called only from 
qla2x00_configure_local_loop()), no entries never deleted from this list 
(except on shutdown) and many functions can go through this list using 
list_for_each_entry().

The problem is that all traversing over fcports functions can be called 
not only from the DPC thread, where qla2x00_configure_local_loop() adds 
new entries, but also from many other threads. For example, 
qla2x00_get_starget_node_name() can be called by any thread via sysfs.

As it is known, simultaneous traversing over a list together with adding 
a new member to it is racy and can lead to a crash.

The proposed solution.

This patch proposes a fix for this issue by protecting fcports list 
using RCU list access functions. It is possible, because adding to the 
list is done from the only DPC thread, so it's selfprotected.

But the main purpose of this patch is to bring attention to this issue 
as well as to possibility of existence of similar issues in other places 
of qla2xxx driver. Particularly, this patch doesn't address the 
following 2 issues:

  - It wasn't investigated if there are possible bad consequences if 
some function, traveling over fcports list, missed just added to it new entry.

  - It wasn't investigated if it is possible if new entries can be added 
to fcports list by qla2x00_configure_local_loop() called not from DPC 
thread. According to the attached call tree made by KScope, 
qla2x00_configure_local_loop() also can be called from 
eh_host_reset_handler(). But I'm not sure, if there isn't any protection 
somewhere against that.

Also I wasn't deeply investigated if other fields of struct 
scsi_qla_host similarly incorrectly unprotected.

(BTW, IMHO the whole idea of never deleting entries from fcports list 
isn't quite good. Sure, it is impossible to have thousands of dead 
entries, but with virtual ports having hundreds of them is quite 
possible. I'm not sure if it's good to loose that memory.)

This patch is against 2.6.26

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_attr.c linux-2.6.26/drivers/scsi/qla2xxx/qla_attr.c
--- linux-2.6.26/drivers/scsi/qla2xxx/qla_attr.c	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/drivers/scsi/qla2xxx/qla_attr.c	2008-07-24 10:08:12.000000000 +0400
@@ -921,7 +921,7 @@ qla2x00_get_starget_node_name(struct scs
 	fc_port_t *fcport;
 	u64 node_name = 0;
 
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry_rcu(fcport, &ha->fcports, list) {
 		if (fcport->rport &&
 		    starget->id == fcport->rport->scsi_target_id) {
 			node_name = wwn_to_u64(fcport->node_name);
@@ -940,7 +940,7 @@ qla2x00_get_starget_port_name(struct scs
 	fc_port_t *fcport;
 	u64 port_name = 0;
 
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry_rcu(fcport, &ha->fcports, list) {
 		if (fcport->rport &&
 		    starget->id == fcport->rport->scsi_target_id) {
 			port_name = wwn_to_u64(fcport->port_name);
@@ -959,7 +959,7 @@ qla2x00_get_starget_port_id(struct scsi_
 	fc_port_t *fcport;
 	uint32_t port_id = ~0U;
 
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry_rcu(fcport, &ha->fcports, list) {
 		if (fcport->rport &&
 		    starget->id == fcport->rport->scsi_target_id) {
 			port_id = fcport->d_id.b.domain << 16 |
diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h
--- linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/drivers/scsi/qla2xxx/qla_def.h	2008-07-24 10:07:39.000000000 +0400
@@ -2403,7 +2403,14 @@ typedef struct scsi_qla_host {
 
 	struct list_head	work_list;
 
-	/* Fibre Channel Device List. */
+	/*
+	 * Fibre Channel Device List.
+	 *
+	 * This list can be accessed from many contexts, including concurrently.
+	 * So, although anything never deleted from this list, it needs the
+	 * corresponding protection anyway. Let's do it by making access to
+	 * it using RCU functions.
+	 */
 	struct list_head	fcports;
 
 	/* RSCN queue. */
diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_init.c linux-2.6.26/drivers/scsi/qla2xxx/qla_init.c
--- linux-2.6.26/drivers/scsi/qla2xxx/qla_init.c	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/drivers/scsi/qla2xxx/qla_init.c	2008-07-24 10:11:56.000000000 +0400
@@ -2071,7 +2071,7 @@ qla2x00_configure_local_loop(scsi_qla_ho
 	/*
 	 * Mark local devices that were present with FCF_DEVICE_LOST for now.
 	 */
-	list_for_each_entry(fcport, &pha->fcports, list) {
+	list_for_each_entry_rcu(fcport, &pha->fcports, list) {
 		if (fcport->vp_idx != ha->vp_idx)
 			continue;
 
@@ -2136,7 +2136,7 @@ qla2x00_configure_local_loop(scsi_qla_ho
 		/* Check for matching device in port list. */
 		found = 0;
 		fcport = NULL;
-		list_for_each_entry(fcport, &pha->fcports, list) {
+		list_for_each_entry_rcu(fcport, &pha->fcports, list) {
 			if (fcport->vp_idx != ha->vp_idx)
 				continue;
 
@@ -2165,7 +2165,7 @@ qla2x00_configure_local_loop(scsi_qla_ho
 				list_add_tail(&new_fcport->vp_fcport,
 				    &ha->vp_fcports);
 			}
-			list_add_tail(&new_fcport->list, &pha->fcports);
+			list_add_tail_rcu(&new_fcport->list, &pha->fcports);
 
 			/* Allocate a new replacement fcport. */
 			fcport = new_fcport;
@@ -2405,7 +2405,7 @@ qla2x00_configure_fabric(scsi_qla_host_t
 		 * Logout all previous fabric devices marked lost, except
 		 * tape devices.
 		 */
-		list_for_each_entry(fcport, &pha->fcports, list) {
+		list_for_each_entry_rcu(fcport, &pha->fcports, list) {
 			if (fcport->vp_idx !=ha->vp_idx)
 				continue;
 
@@ -2439,7 +2439,7 @@ qla2x00_configure_fabric(scsi_qla_host_t
 		 * Scan through our port list and login entries that need to be
 		 * logged in.
 		 */
-		list_for_each_entry(fcport, &pha->fcports, list) {
+		list_for_each_entry_rcu(fcport, &pha->fcports, list) {
 			if (fcport->vp_idx != ha->vp_idx)
 				continue;
 
@@ -2494,10 +2494,13 @@ qla2x00_configure_fabric(scsi_qla_host_t
 				fcport->vp_idx = ha->vp_idx;
 				list_add_tail(&fcport->vp_fcport,
 				    &ha->vp_fcports);
-				list_move_tail(&fcport->list,
+				list_del(&fcport->list);
+				list_add_tail_rcu(&fcport->list,
 				    &ha->parent->fcports);
-			} else
-				list_move_tail(&fcport->list, &ha->fcports);
+			} else {
+				list_del(&fcport->list);
+				list_add_tail_rcu(&fcport->list, &ha->fcports);
+			}
 		}
 	} while (0);
 
@@ -2680,7 +2683,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 
 		/* Locate matching device in database. */
 		found = 0;
-		list_for_each_entry(fcport, &pha->fcports, list) {
+		list_for_each_entry_rcu(fcport, &pha->fcports, list) {
 			if (new_fcport->vp_idx != fcport->vp_idx)
 				continue;
 			if (memcmp(new_fcport->port_name, fcport->port_name,
@@ -2810,7 +2813,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t
 		/* Check for loop ID being already in use. */
 		found = 0;
 		fcport = NULL;
-		list_for_each_entry(fcport, &pha->fcports, list) {
+		list_for_each_entry_rcu(fcport, &pha->fcports, list) {
 			if (fcport->loop_id == dev->loop_id && fcport != dev) {
 				/* ID possibly in use */
 				found++;
@@ -2924,7 +2927,7 @@ qla2x00_device_resync(scsi_qla_host_t *h
 
 		rval = QLA_SUCCESS;
 
-		list_for_each_entry(fcport, &pha->fcports, list) {
+		list_for_each_entry_rcu(fcport, &pha->fcports, list) {
 			if (fcport->vp_idx != ha->vp_idx)
 				continue;
 
@@ -3219,7 +3222,7 @@ qla2x00_update_fcports(scsi_qla_host_t *
 	fc_port_t *fcport;
 
 	/* Go with deferred removal of rport references. */
-	list_for_each_entry(fcport, &ha->fcports, list)
+	list_for_each_entry_rcu(fcport, &ha->fcports, list)
 		if (fcport->drport)
 			qla2x00_rport_del(fcport);
 }
diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_mid.c linux-2.6.26/drivers/scsi/qla2xxx/qla_mid.c
--- linux-2.6.26/drivers/scsi/qla2xxx/qla_mid.c	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/drivers/scsi/qla2xxx/qla_mid.c	2008-07-24 10:12:02.000000000 +0400
@@ -95,7 +95,7 @@ qla2x00_mark_vp_devices_dead(scsi_qla_ho
 	fc_port_t *fcport;
 	scsi_qla_host_t *pha = to_qla_parent(vha);
 
-	list_for_each_entry(fcport, &pha->fcports, list) {
+	list_for_each_entry_rcu(fcport, &pha->fcports, list) {
 		if (fcport->vp_idx != vha->vp_idx)
 			continue;
 
diff -upr linux-2.6.26/drivers/scsi/qla2xxx/qla_os.c linux-2.6.26/drivers/scsi/qla2xxx/qla_os.c
--- linux-2.6.26/drivers/scsi/qla2xxx/qla_os.c	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/drivers/scsi/qla2xxx/qla_os.c	2008-07-24 10:13:45.000000000 +0400
@@ -1009,7 +1009,7 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 	}
 
 	if (ha->flags.enable_target_reset) {
-		list_for_each_entry(fcport, &ha->fcports, list) {
+		list_for_each_entry_rcu(fcport, &ha->fcports, list) {
 			if (fcport->port_type != FCT_TARGET)
 				continue;
 
@@ -1915,7 +1915,7 @@ qla2x00_mark_all_devices_lost(scsi_qla_h
 	fc_port_t *fcport;
 	scsi_qla_host_t *pha = to_qla_parent(ha);
 
-	list_for_each_entry(fcport, &pha->fcports, list) {
+	list_for_each_entry_rcu(fcport, &pha->fcports, list) {
 		if (ha->vp_idx != 0 && ha->vp_idx != fcport->vp_idx)
 			continue;
 		/*
@@ -2348,7 +2348,7 @@ qla2x00_do_dpc(void *data)
 			    ha->host_no));
 
 			next_loopid = 0;
-			list_for_each_entry(fcport, &ha->fcports, list) {
+			list_for_each_entry_rcu(fcport, &ha->fcports, list) {
 				/*
 				 * If the port is not ONLINE then try to login
 				 * to it if we haven't run out of retries.
@@ -2524,7 +2524,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	 * the port it marked DEAD.
 	 */
 	t = 0;
-	list_for_each_entry(fcport, &ha->fcports, list) {
+	list_for_each_entry_rcu(fcport, &ha->fcports, list) {
 		if (fcport->port_type != FCT_TARGET)
 			continue;
 


--------------050605070009090005030403
Content-Type: image/png;
 name="Screenshot-Calling Functions Tree.png"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="Screenshot-Calling Functions Tree.png"

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
hmEYxoL/D/aGoefds34jAAAAAElFTkSuQmCC
--------------050605070009090005030403--
