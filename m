From: Dave Jones <davej@redhat.com>
Subject: fix qla2xxx inline failure.
Date: Wed, 15 Sep 2004 07:32:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915113254.GA17683@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:18901 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265211AbUIOLdB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 07:33:01 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.10) with ESMTP id i8FBX03j014616
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2004 07:33:00 -0400
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id i8FBX0r15855
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2004 07:33:00 -0400
Received: from devserv.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by devserv.devel.redhat.com (8.12.11/8.12.10) with ESMTP id i8FBWsbc027217
	for <linux-scsi@vger.kernel.org>; Wed, 15 Sep 2004 07:32:54 -0400
Received: (from davej@localhost)
	by devserv.devel.redhat.com (8.12.11/8.12.11/Submit) id i8FBWskw027215
	for linux-scsi@vger.kernel.org; Wed, 15 Sep 2004 07:32:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  CC [M]  drivers/scsi/qla2xxx/qla_os.o
drivers/scsi/qla2xxx/qla_os.c: In function `qla2x00_queuecommand':
drivers/scsi/qla2xxx/qla_os.c:315: sorry, unimplemented: inlining failed in call to 'qla2x00_callback': function not considered for inlining
drivers/scsi/qla2xxx/qla_os.c:269: sorry, unimplemented: called from here
drivers/scsi/qla2xxx/qla_os.c:315: sorry, unimplemented: inlining failed in call to 'qla2x00_callback': function not considered for inlining
drivers/scsi/qla2xxx/qla_os.c:269: sorry, unimplemented: called from here
make[1]: *** [drivers/scsi/qla2xxx/qla_os.o] Error 1


Fixed by hoisting qla2x00_callback up a few dozen lines.
Also removed now useless prototype.

Signed-off-by: Dave Jones <davej@redhat.com>


--- 1/drivers/scsi/qla2xxx/qla_os.c	2004-09-15 01:16:55.000000000 +0100
+++ 2/drivers/scsi/qla2xxx/qla_os.c	2004-09-15 12:31:30.423920264 +0100
@@ -229,73 +229,11 @@ qla2x00_stop_timer(scsi_qla_host_t *ha)
 
 void qla2x00_cmd_timeout(srb_t *);
 
-static __inline__ void qla2x00_callback(scsi_qla_host_t *, struct scsi_cmnd *);
 static __inline__ void sp_put(struct scsi_qla_host * ha, srb_t *sp);
 static __inline__ void sp_get(struct scsi_qla_host * ha, srb_t *sp);
 static __inline__ void
 qla2x00_delete_from_done_queue(scsi_qla_host_t *, srb_t *); 
 
-/**************************************************************************
-* sp_put
-*
-* Description:
-*   Decrement reference count and call the callback if we're the last
-*   owner of the specified sp. Will get the host_lock before calling
-*   the callback.
-*
-* Input:
-*   ha - pointer to the scsi_qla_host_t where the callback is to occur.
-*   sp - pointer to srb_t structure to use.
-*
-* Returns:
-*
-**************************************************************************/
-static inline void
-sp_put(struct scsi_qla_host * ha, srb_t *sp)
-{
-        if (atomic_read(&sp->ref_count) == 0) {
-		qla_printk(KERN_INFO, ha,
-			"%s(): **** SP->ref_count not zero\n",
-			__func__);
-                DEBUG2(BUG();)
-
-                return;
-	}
-
-        if (!atomic_dec_and_test(&sp->ref_count)) {
-                return;
-        }
-
-        qla2x00_callback(ha, sp->cmd);
-}
-
-/**************************************************************************
-* sp_get
-*
-* Description:
-*   Increment reference count of the specified sp.
-*
-* Input:
-*   sp - pointer to srb_t structure to use.
-*
-* Returns:
-*
-**************************************************************************/
-static inline void
-sp_get(struct scsi_qla_host * ha, srb_t *sp)
-{
-        atomic_inc(&sp->ref_count);
-
-        if (atomic_read(&sp->ref_count) > 2) {
-		qla_printk(KERN_INFO, ha,
-			"%s(): **** SP->ref_count greater than two\n",
-			__func__);
-                DEBUG2(BUG();)
-
-		return;
-	}
-}
-
 /*
 * qla2x00_callback
 *      Returns the completed SCSI command to LINUX.
@@ -366,6 +304,67 @@ qla2x00_callback(scsi_qla_host_t *ha, st
 	(*(cmd)->scsi_done)(cmd);
 }
 
+/**************************************************************************
+* sp_put
+*
+* Description:
+*   Decrement reference count and call the callback if we're the last
+*   owner of the specified sp. Will get the host_lock before calling
+*   the callback.
+*
+* Input:
+*   ha - pointer to the scsi_qla_host_t where the callback is to occur.
+*   sp - pointer to srb_t structure to use.
+*
+* Returns:
+*
+**************************************************************************/
+static inline void
+sp_put(struct scsi_qla_host * ha, srb_t *sp)
+{
+        if (atomic_read(&sp->ref_count) == 0) {
+		qla_printk(KERN_INFO, ha,
+			"%s(): **** SP->ref_count not zero\n",
+			__func__);
+                DEBUG2(BUG();)
+
+                return;
+	}
+
+        if (!atomic_dec_and_test(&sp->ref_count)) {
+                return;
+        }
+
+        qla2x00_callback(ha, sp->cmd);
+}
+
+/**************************************************************************
+* sp_get
+*
+* Description:
+*   Increment reference count of the specified sp.
+*
+* Input:
+*   sp - pointer to srb_t structure to use.
+*
+* Returns:
+*
+**************************************************************************/
+static inline void
+sp_get(struct scsi_qla_host * ha, srb_t *sp)
+{
+        atomic_inc(&sp->ref_count);
+
+        if (atomic_read(&sp->ref_count) > 2) {
+		qla_printk(KERN_INFO, ha,
+			"%s(): **** SP->ref_count greater than two\n",
+			__func__);
+                DEBUG2(BUG();)
+
+		return;
+	}
+}
+
 static inline void 
 qla2x00_delete_from_done_queue(scsi_qla_host_t *dest_ha, srb_t *sp) 
 {
