From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] Associate HBA and storage in rdac_controller to support
 partitions in storage
Date: Wed, 20 Jul 2011 14:22:28 -0700
Message-ID: <1311196948.5505.10779.camel@chandra-lucid.beaverton.ibm.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50532 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1GTVWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2011 17:22:36 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6KLGMGS022409
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2011 15:16:22 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p6KLMVI8192966
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2011 15:22:32 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p6KFMTmW011850
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2011 09:22:30 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
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
 drivers/scsi/device_handler/scsi_dh_rdac.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 214d7f0..67c2c99 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -149,6 +149,7 @@ struct rdac_controller {
 	} mode_select;
 	u8	index;
 	u8	array_name[ARRAY_LABEL_LEN];
+	struct Scsi_Host	*host;
 	spinlock_t		ms_lock;
 	int			ms_queued;
 	struct work_struct	ms_work;
@@ -380,7 +381,7 @@ static void release_controller(struct kref *kref)
 }
 
 static struct rdac_controller *get_controller(u8 *serial, int index,
-		char *array_name)
+		char *array_name, struct scsi_device *sdev)
 {
 	struct rdac_controller *ctlr, *tmp;
 
@@ -388,7 +389,8 @@ static struct rdac_controller *get_controller(u8 *serial, int index,
 
 	list_for_each_entry(tmp, &ctlr_list, node) {
 		if ((memcmp(tmp->serial, serial, SERIAL_NO_LEN) == 0) &&
-		          (tmp->index == index)) {
+		          (tmp->index == index) &&
+			  (tmp->host == sdev->host)) {
 			kref_get(&tmp->kref);
 			spin_unlock(&list_lock);
 			return tmp;
@@ -402,6 +404,7 @@ static struct rdac_controller *get_controller(u8 *serial, int index,
 	memcpy(ctlr->serial, serial, SERIAL_NO_LEN);
 	memcpy(ctlr->array_name, array_name, ARRAY_LABEL_LEN);
 	ctlr->index = index;
+	ctlr->host = sdev->host;
 
 	kref_init(&ctlr->kref);
 	ctlr->use_ms10 = -1;
@@ -525,7 +528,8 @@ static int initialize_controller(struct scsi_device *sdev,
 		if (err != SCSI_DH_OK)
 			return err;
 		inq_p80 = &h->inq.p80;
-		h->ctlr = get_controller(inq_p80->serial, index, array_name);
+		h->ctlr = get_controller(inq_p80->serial, index,
+							array_name, sdev);
 		if (!h->ctlr)
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
 	}
-- 
1.7.1



