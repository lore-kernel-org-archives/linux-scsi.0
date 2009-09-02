From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: changes to collect
 the rdac debug information during the initialization
Date: Wed, 2 Sep 2009 17:12:55 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474CCCE67@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, 'device mapper development' <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "'sekharan@linux.vnet.ibm.com'" <sekharan@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Adding the code to read the debug information during initialization. This=
 patch collects the information about storage and controllers during rdac=
_activate.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>

---

--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009=
-09-02 09:49:23.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-09-0=
2 10:04:40.000000000 -0500
@@ -112,6 +112,7 @@ struct c9_inquiry {
=20
 #define SUBSYS_ID_LEN	16
 #define SLOT_ID_LEN	2
+#define ARRAY_LABEL_LEN	31
=20
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
@@ -303,7 +306,8 @@ static void release_controller(struct kr
 	kfree(ctlr);
 }
=20
-static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id=
)
+static struct rdac_controller *get_controller(u8 *subsys_id, u8 *slot_id=
,
+						char *array_name)
 {
 	struct rdac_controller *ctlr, *tmp;
=20
@@ -324,6 +328,14 @@ static struct rdac_controller *get_contr
 	/* initialize fields of controller */
 	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
 	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
+	memcpy(ctlr->array_name, array_name, ARRAY_LABEL_LEN);
+
+	/* update the controller index */
+	if (slot_id[1] =3D=3D 0x31)
+		ctlr->index =3D 0;
+	else
+		ctlr->index =3D 1;
+
 	kref_init(&ctlr->kref);
 	ctlr->use_ms10 =3D -1;
 	list_add(&ctlr->node, &ctlr_list);
@@ -363,9 +375,10 @@ done:
 	return err;
 }
=20
-static int get_lun(struct scsi_device *sdev, struct rdac_dh_data *h)
+static int get_lun_info(struct scsi_device *sdev, struct rdac_dh_data *h=
,
+			char *array_name)
 {
-	int err;
+	int err, i;
 	struct c8_inquiry *inqp;
=20
 	err =3D submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
@@ -377,6 +390,11 @@ static int get_lun(struct scsi_device *s
 		    inqp->page_id[2] !=3D 'i' || inqp->page_id[3] !=3D 'd')
 			return SCSI_DH_NOSYS;
 		h->lun =3D inqp->lun[7]; /* Uses only the last byte */
+
+		for(i=3D0; i<ARRAY_LABEL_LEN-1; ++i)
+			*(array_name+i) =3D inqp->array_user_label[(2*i)+1];
+
+		*(array_name+ARRAY_LABEL_LEN-1) =3D '\0';
 	}
 	return err;
 }
@@ -410,7 +428,7 @@ static int check_ownership(struct scsi_d
 }
=20
 static int initialize_controller(struct scsi_device *sdev,
-				 struct rdac_dh_data *h)
+				 struct rdac_dh_data *h, char *array_name)
 {
 	int err;
 	struct c4_inquiry *inqp;
@@ -418,7 +436,8 @@ static int initialize_controller(struct=20
 	err =3D submit_inquiry(sdev, 0xC4, sizeof(struct c4_inquiry), h);
 	if (err =3D=3D SCSI_DH_OK) {
 		inqp =3D &h->inq.c4;
-		h->ctlr =3D get_controller(inqp->subsys_id, inqp->slot_id);
+		h->ctlr =3D get_controller(inqp->subsys_id, inqp->slot_id,
+					array_name);
 		if (!h->ctlr)
 			err =3D SCSI_DH_RES_TEMP_UNAVAIL;
 	}
@@ -520,13 +539,14 @@ static int rdac_activate(struct scsi_dev
 {
 	struct rdac_dh_data *h =3D get_rdac_data(sdev);
 	int err =3D SCSI_DH_OK;
+	char array_name[ARRAY_LABEL_LEN];
=20
 	err =3D check_ownership(sdev, h);
 	if (err !=3D SCSI_DH_OK)
 		goto done;
=20
 	if (!h->ctlr) {
-		err =3D initialize_controller(sdev, h);
+		err =3D initialize_controller(sdev, h, array_name);
 		if (err !=3D SCSI_DH_OK)
 			goto done;
 	}
@@ -656,6 +676,7 @@ static int rdac_bus_attach(struct scsi_d
 	struct rdac_dh_data *h;
 	unsigned long flags;
 	int err;
+	char array_name[ARRAY_LABEL_LEN];
=20
 	scsi_dh_data =3D kzalloc(sizeof(struct scsi_device_handler *)
 			       + sizeof(*h) , GFP_KERNEL);
@@ -670,7 +691,7 @@ static int rdac_bus_attach(struct scsi_d
 	h->lun =3D UNINITIALIZED_LUN;
 	h->state =3D RDAC_STATE_ACTIVE;
=20
-	err =3D get_lun(sdev, h);
+	err =3D get_lun_info(sdev, h, array_name);
 	if (err !=3D SCSI_DH_OK)
 		goto failed;
=20
