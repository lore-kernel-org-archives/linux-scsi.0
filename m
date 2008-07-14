From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/6] ibmvfc: Target refcounting fixes
Date: Mon, 14 Jul 2008 14:36:30 -0500
Message-ID: <200807141936.m6EJagn4026940@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:56983 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbYGNTgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2008 15:36:50 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6EJame2013142
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:48 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6EJaihH110530
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 13:36:44 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6EJagoq027048
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 13:36:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Fix up some refcounting on the ibmvfc drivers internal target struct
when accessed through some sysfs attributes.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   48 +++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_target_refs drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_target_refs	2008-07-11 08:39:24.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-07-11 08:54:55.000000000 -0500
@@ -854,39 +854,41 @@ static void ibmvfc_retry_host_init(struc
 }
 
 /**
- * __ibmvfc_find_target - Find the specified scsi_target (no locking)
+ * __ibmvfc_get_target - Find the specified scsi_target (no locking)
  * @starget:	scsi target struct
  *
  * Return value:
  *	ibmvfc_target struct / NULL if not found
  **/
-static struct ibmvfc_target *__ibmvfc_find_target(struct scsi_target *starget)
+static struct ibmvfc_target *__ibmvfc_get_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct ibmvfc_host *vhost = shost_priv(shost);
 	struct ibmvfc_target *tgt;
 
 	list_for_each_entry(tgt, &vhost->targets, queue)
-		if (tgt->target_id == starget->id)
+		if (tgt->target_id == starget->id) {
+			kref_get(&tgt->kref);
 			return tgt;
+		}
 	return NULL;
 }
 
 /**
- * ibmvfc_find_target - Find the specified scsi_target
+ * ibmvfc_get_target - Find the specified scsi_target
  * @starget:	scsi target struct
  *
  * Return value:
  *	ibmvfc_target struct / NULL if not found
  **/
-static struct ibmvfc_target *ibmvfc_find_target(struct scsi_target *starget)
+static struct ibmvfc_target *ibmvfc_get_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct ibmvfc_target *tgt;
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	tgt = __ibmvfc_find_target(starget);
+	tgt = __ibmvfc_get_target(starget);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return tgt;
 }
@@ -991,6 +993,17 @@ static void ibmvfc_set_rport_dev_loss_tm
 }
 
 /**
+ * ibmvfc_release_tgt - Free memory allocated for a target
+ * @kref:		kref struct
+ *
+ **/
+static void ibmvfc_release_tgt(struct kref *kref)
+{
+	struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
+	kfree(tgt);
+}
+
+/**
  * ibmvfc_get_starget_node_name - Get SCSI target's node name
  * @starget:	scsi target struct
  *
@@ -999,8 +1012,10 @@ static void ibmvfc_set_rport_dev_loss_tm
  **/
 static void ibmvfc_get_starget_node_name(struct scsi_target *starget)
 {
-	struct ibmvfc_target *tgt = ibmvfc_find_target(starget);
+	struct ibmvfc_target *tgt = ibmvfc_get_target(starget);
 	fc_starget_port_name(starget) = tgt ? tgt->ids.node_name : 0;
+	if (tgt)
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
 }
 
 /**
@@ -1012,8 +1027,10 @@ static void ibmvfc_get_starget_node_name
  **/
 static void ibmvfc_get_starget_port_name(struct scsi_target *starget)
 {
-	struct ibmvfc_target *tgt = ibmvfc_find_target(starget);
+	struct ibmvfc_target *tgt = ibmvfc_get_target(starget);
 	fc_starget_port_name(starget) = tgt ? tgt->ids.port_name : 0;
+	if (tgt)
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
 }
 
 /**
@@ -1025,8 +1042,10 @@ static void ibmvfc_get_starget_port_name
  **/
 static void ibmvfc_get_starget_port_id(struct scsi_target *starget)
 {
-	struct ibmvfc_target *tgt = ibmvfc_find_target(starget);
+	struct ibmvfc_target *tgt = ibmvfc_get_target(starget);
 	fc_starget_port_id(starget) = tgt ? tgt->scsi_id : -1;
+	if (tgt)
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
 }
 
 /**
@@ -2651,17 +2670,6 @@ static void ibmvfc_retry_tgt_init(struct
 }
 
 /**
- * ibmvfc_release_tgt - Free memory allocated for a target
- * @kref:		kref struct
- *
- **/
-static void ibmvfc_release_tgt(struct kref *kref)
-{
-	struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
-	kfree(tgt);
-}
-
-/**
  * ibmvfc_tgt_prli_done - Completion handler for Process Login
  * @evt:	ibmvfc event struct
  *
_
