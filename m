From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v2] Associate HBA and storage in rdac_controller to support
 partitions in storage
Date: Wed, 27 Jul 2011 11:22:56 -0700
Message-ID: <1311790976.3210.999.camel@chandra-lucid.beaverton.ibm.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54408 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1G0SYQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 14:24:16 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6RHt74d031104
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 13:55:07 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p6RIMxF7125192
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 14:22:59 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p6REMkRo017612
	for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 11:22:47 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>
Cc: dm-devel <dm-devel@redhat.com>, "Moger, Babu" <Babu.Moger@netapp.com>, yanling.Qi@netapp.com, "Stankey, Robert" <Robert.Stankey@netapp.com>

rdac hardware handler assumes that there is one-to-one relation ship
between the host and the controller w.r.t lun.  IOW, it does not
support "multiple storage partitions" within a storage.

Example:
HBA1 and HBA2 see lun 0 and 1 in storage A (1)
HBA3 and HBA4 see lun 0 and 1 in storage A (2)
HBA5 and HBA6 see lun 0 and 1 in storage A (3)

luns 0 and 1 in (1), (2) and (3) are totally different.

But, rdac handler treats the lun 0s (and lun 1s) as the same when
sending a mode select to the controller, which is wrong.

This patch makes the rdac hardware handler associate HBA and the
storage w.r.t lun (and not the host itself).

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index f57009b..27c9d65 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -158,6 +158,7 @@ struct rdac_controller {
 	} mode_select;
 	u8	index;
 	u8	array_name[ARRAY_LABEL_LEN];
+	struct Scsi_Host	*host;
 	spinlock_t		ms_lock;
 	int			ms_queued;
 	struct work_struct	ms_work;
@@ -370,7 +371,7 @@ static void release_controller(struct kref *kref)
 }
 
 static struct rdac_controller *get_controller(int index, char *array_name,
-						u8 *array_id)
+			u8 *array_id, struct scsi_device *sdev)
 {
 	struct rdac_controller *ctlr, *tmp;
 
@@ -378,7 +379,8 @@ static struct rdac_controller *get_controller(int index, char *array_name,
 
 	list_for_each_entry(tmp, &ctlr_list, node) {
 		if ((memcmp(tmp->array_id, array_id, UNIQUE_ID_LEN) == 0) &&
-			  (tmp->index == index)) {
+			  (tmp->index == index) &&
+			  (tmp->host == sdev->host)) {
 			kref_get(&tmp->kref);
 			spin_unlock(&list_lock);
 			return tmp;
@@ -391,6 +393,7 @@ static struct rdac_controller *get_controller(int index, char *array_name,
 	/* initialize fields of controller */
 	memcpy(ctlr->array_id, array_id, UNIQUE_ID_LEN);
 	ctlr->index = index;
+	ctlr->host = sdev->host;
 	memcpy(ctlr->array_name, array_name, ARRAY_LABEL_LEN);
 
 	kref_init(&ctlr->kref);
@@ -513,7 +516,7 @@ static int initialize_controller(struct scsi_device *sdev,
 			index = 0;
 		else
 			index = 1;
-		h->ctlr = get_controller(index, array_name, array_id);
+		h->ctlr = get_controller(index, array_name, array_id, sdev);
 		if (!h->ctlr)
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
 	}


