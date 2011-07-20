From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] Use WWID from C8 page instead of Subsystem id from C4 page
 to identify storage
Date: Wed, 20 Jul 2011 14:18:56 -0700
Message-ID: <1311196736.5505.10775.camel@chandra-lucid.beaverton.ibm.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53736 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab1GTVTA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 17:19:00 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6KL6Poi022343
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2011 17:06:25 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p6KLIxT7177742
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2011 17:18:59 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p6KHIk1K004994
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2011 14:18:46 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, "Moger, Babu" <Babu.Moger@netapp.com>, yanling.Qi@netapp.com, "Stankey, Robert" <Robert.Stankey@netapp.com>

rdac hardware handler uses "Subsystem Identifier" from C4 inquiry page
to uniquely identify a storage. The problem with that is that if any 
any of the bytes are non-ascii, subsys_id will all be spaces (hex
0x20). This creates lot of problems especially when there are multiple
rdac storages are connected to the server.

Use "Storage Array Unique Identifier" from C8 inquiry page, which is the
world wide unique identifier for the storage array, to uniquely identify
the storage.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index e7fc70d..a5d1669 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -128,25 +128,7 @@ struct c4_inquiry {
 	u8	reserved[2];
 };
 
-struct rdac_controller {
-	u8			subsys_id[SUBSYS_ID_LEN];
-	u8			slot_id[SLOT_ID_LEN];
-	int			use_ms10;
-	struct kref		kref;
-	struct list_head	node; /* list of all controllers */
-	union			{
-		struct rdac_pg_legacy legacy;
-		struct rdac_pg_expanded expanded;
-	} mode_select;
-	u8	index;
-	u8	array_name[ARRAY_LABEL_LEN];
-	spinlock_t		ms_lock;
-	int			ms_queued;
-	struct work_struct	ms_work;
-	struct scsi_device	*ms_sdev;
-	struct list_head	ms_head;
-};
-
+#define UNIQUE_ID_LEN 16
 struct c8_inquiry {
 	u8	peripheral_info;
 	u8	page_code; /* 0xC8 */
@@ -159,12 +141,30 @@ struct c8_inquiry {
 	u8	vol_user_label_len;
 	u8	vol_user_label[60];
 	u8	array_uniq_id_len;
-	u8	array_unique_id[16];
+	u8	array_unique_id[UNIQUE_ID_LEN];
 	u8	array_user_label_len;
 	u8	array_user_label[60];
 	u8	lun[8];
 };
 
+struct rdac_controller {
+	u8			array_id[UNIQUE_ID_LEN];
+	int			use_ms10;
+	struct kref		kref;
+	struct list_head	node; /* list of all controllers */
+	union			{
+		struct rdac_pg_legacy legacy;
+		struct rdac_pg_expanded expanded;
+	} mode_select;
+	u8	index;
+	u8	array_name[ARRAY_LABEL_LEN];
+	spinlock_t		ms_lock;
+	int			ms_queued;
+	struct work_struct	ms_work;
+	struct scsi_device	*ms_sdev;
+	struct list_head	ms_head;
+};
+
 struct c2_inquiry {
 	u8	peripheral_info;
 	u8	page_code;	/* 0xC2 */
@@ -369,16 +369,16 @@ static void release_controller(struct kref *kref)
 	kfree(ctlr);
 }
 
-static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id,
-						char *array_name)
+static struct rdac_controller *get_controller(int index, char *array_name,
+						u8 *array_id)
 {
 	struct rdac_controller *ctlr, *tmp;
 
 	spin_lock(&list_lock);
 
 	list_for_each_entry(tmp, &ctlr_list, node) {
-		if ((memcmp(tmp->subsys_id, subsys_id, SUBSYS_ID_LEN) == 0) &&
-			  (memcmp(tmp->slot_id, slot_id, SLOT_ID_LEN) == 0)) {
+		if ((memcmp(tmp->array_id, array_id, UNIQUE_ID_LEN) == 0) &&
+			  (tmp->index == index)) {
 			kref_get(&tmp->kref);
 			spin_unlock(&list_lock);
 			return tmp;
@@ -389,16 +389,10 @@ static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id,
 		goto done;
 
 	/* initialize fields of controller */
-	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
-	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
+	memcpy(ctlr->array_id, array_id, UNIQUE_ID_LEN);
+	ctlr->index = index;
 	memcpy(ctlr->array_name, array_name, ARRAY_LABEL_LEN);
 
-	/* update the controller index */
-	if (slot_id[1] == 0x31)
-		ctlr->index = 0;
-	else
-		ctlr->index = 1;
-
 	kref_init(&ctlr->kref);
 	ctlr->use_ms10 = -1;
 	ctlr->ms_queued = 0;
@@ -444,7 +438,7 @@ done:
 }
 
 static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
-			char *array_name)
+			char *array_name, u8 *array_id)
 {
 	int err, i;
 	struct c8_inquiry *inqp;
@@ -463,6 +457,8 @@ static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h,
 			*(array_name+i) = inqp->array_user_label[(2*i)+1];
 
 		*(array_name+ARRAY_LABEL_LEN-1) = '\0';
+		memset(array_id, 0, UNIQUE_ID_LEN);
+		memcpy(array_id, inqp->array_unique_id, inqp->array_uniq_id_len);
 	}
 	return err;
 }
@@ -504,16 +500,20 @@ static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 }
 
 static int initialize_controller(struct scsi_device *sdev,
-				 struct rdac_dh_data *h, char *array_name)
+		struct rdac_dh_data *h, char *array_name, u8 *array_id)
 {
-	int err;
+	int err, index;
 	struct c4_inquiry *inqp;
 
 	err = submit_inquiry(sdev, 0xC4, sizeof(struct c4_inquiry), h);
 	if (err == SCSI_DH_OK) {
 		inqp = &h->inq.c4;
-		h->ctlr = get_controller(inqp->subsys_id, inqp->slot_id,
-					array_name);
+		/* get the controller index */
+		if (inqp->slot_id[1] == 0x31)
+			index = 0;
+		else
+			index = 1;
+		h->ctlr = get_controller(index, array_name, array_id);
 		if (!h->ctlr)
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
 	}
@@ -835,6 +835,7 @@ static int rdac_bus_attach(struct scsi_device *sdev)
 	unsigned long flags;
 	int err;
 	char array_name[ARRAY_LABEL_LEN];
+	char array_id[UNIQUE_ID_LEN];
 
 	scsi_dh_data = kzalloc(sizeof(*scsi_dh_data)
 			       + sizeof(*h) , GFP_KERNEL);
@@ -849,11 +850,11 @@ static int rdac_bus_attach(struct scsi_device *sdev)
 	h->lun = UNINITIALIZED_LUN;
 	h->state = RDAC_STATE_ACTIVE;
 
-	err = get_lun_info(sdev, h, array_name);
+	err = get_lun_info(sdev, h, array_name, array_id);
 	if (err != SCSI_DH_OK)
 		goto failed;
 
-	err = initialize_controller(sdev, h, array_name);
+	err = initialize_controller(sdev, h, array_name, array_id);
 	if (err != SCSI_DH_OK)
 		goto failed;
 


