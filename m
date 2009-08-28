From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect the debug
 information during rdac_activate
Date: Fri, 28 Aug 2009 08:22:38 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474C65F3D@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:55278 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZH1OWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 10:22:41 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'device mapper development' <dm-devel@redhat.com>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Adding the code to read the debug information during activate. This patch collects the information about storage and controllers during rdac_activate.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

---
--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-08-27 18:17:23.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-27 18:27:23.000000000 -0500
@@ -112,6 +112,7 @@ struct c9_inquiry {
 
 #define SUBSYS_ID_LEN	16
 #define SLOT_ID_LEN	2
+#define ARRAY_LABEL_LEN	31
 
 struct c4_inquiry {
 	u8	peripheral_info;
@@ -135,6 +136,8 @@ struct rdac_controller {
 		struct rdac_pg_legacy legacy;
 		struct rdac_pg_expanded expanded;
 	} mode_select;
+	u8	index;
+	u8	array_name[ARRAY_LABEL_LEN];
 };
 struct c8_inquiry {
 	u8	peripheral_info;
@@ -324,6 +327,13 @@ static struct rdac_controller *get_contr
 	/* initialize fields of controller */
 	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
 	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
+
+	/* update the controller index */
+	if (slot_id[1] == 0x31)
+		ctlr->index = 0;
+	else
+		ctlr->index = 1;
+
 	kref_init(&ctlr->kref);
 	ctlr->use_ms10 = -1;
 	list_add(&ctlr->node, &ctlr_list);
@@ -381,6 +391,26 @@ static int get_lun(struct scsi_device *s
 	return err;
 }
 
+static int get_array_name(struct scsi_device *sdev, struct rdac_dh_data *h)
+{
+	int err, i;
+	struct c8_inquiry *inqp;
+
+	err = submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
+	if (err == SCSI_DH_OK) {
+		inqp = &h->inq.c8;
+		if (inqp->page_code != 0xc8)
+			return SCSI_DH_NOSYS;
+
+		for(i=0; i<ARRAY_LABEL_LEN-1; ++i)
+			h->ctlr->array_name[i] = inqp->array_user_label[(2*i)+1];
+
+		h->ctlr->array_name[ARRAY_LABEL_LEN-1] = '\0';
+	}
+			
+	return err;
+}
+
 static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
 {
 	int err;
@@ -529,6 +559,10 @@ static int rdac_activate(struct scsi_dev
 		err = initialize_controller(sdev, h);
 		if (err != SCSI_DH_OK)
 			goto done;
+
+		err = get_array_name(sdev, h);
+		if (err != SCSI_DH_OK)
+			goto done;
 	}
 
 	if (h->ctlr->use_ms10 == -1) {


