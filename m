From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 1/3] scsi_dh_rdac: Adding more debug options for
 scsi rdac handler
Date: Mon, 24 Aug 2009 18:11:46 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474BFD90E@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, "Chauhan,
	Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Adding the code to read the debug information during activate. This patch=
 collects the information about storage and controllers during rdac_activ=
ate.
=20
Signed-off-by: Babu Moger <babu.moger@lsi.com>

---
--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009=
-08-24 11:54:41.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-08-2=
4 12:08:33.000000000 -0500
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
+	u8			index;
+	u8			array_name[ARRAY_LABEL_LEN];
 };
 struct c8_inquiry {
 	u8	peripheral_info;
@@ -324,6 +327,13 @@ static struct rdac_controller *get_contr
 	/* initialize fields of controller */
 	memcpy(ctlr->subsys_id, subsys_id, SUBSYS_ID_LEN);
 	memcpy(ctlr->slot_id, slot_id, SLOT_ID_LEN);
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
@@ -381,6 +391,26 @@ static int get_lun(struct scsi_device *s
 	return err;
 }
=20
+static int get_array_name(struct scsi_device *sdev, struct rdac_dh_data =
*h)
+{
+	int err, i;
+	struct c8_inquiry *inqp;
+
+	err =3D submit_inquiry(sdev, 0xC8, sizeof(struct c8_inquiry), h);
+	if (err =3D=3D SCSI_DH_OK) {
+		inqp =3D &h->inq.c8;
+		if (inqp->page_code !=3D 0xc8)
+			return SCSI_DH_NOSYS;
+
+		for(i=3D0; i<30; ++i)
+			h->ctlr->array_name[i] =3D inqp->array_user_label[(2*i)+1];
+
+		h->ctlr->array_name[30] =3D '\0';
+	}
+		=09
+	return err;
+}
+
 static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data=
 *h)
 {
 	int err;
@@ -529,6 +559,10 @@ static int rdac_activate(struct scsi_dev
 		err =3D initialize_controller(sdev, h);
 		if (err !=3D SCSI_DH_OK)
 			goto done;
+
+		err =3D get_array_name(sdev, h);
+		if (err !=3D SCSI_DH_OK)
+			goto done;
 	}
=20
 	if (h->ctlr->use_ms10 =3D=3D -1) {
