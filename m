From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/5] qla4xxx: Silence gcc warning
Date: Wed, 17 Apr 2013 05:15:26 -0400
Message-ID: <1366190130-16556-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:28393 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751585Ab3DQJjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 05:39:14 -0400
In-Reply-To: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

=46rom: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

=46ix followig gcc warning:-
drivers/scsi/qla4xxx/ql4_os.c: In function =E2=80=98qla4xxx_sysfs_ddb_g=
et_param=E2=80=99:
drivers/scsi/qla4xxx/ql4_os.c:6279:
warning: comparison is always true due to limited range of data type
drivers/scsi/qla4xxx/ql4_os.c:6290:
warning: comparison is always true due to limited range of data type
drivers/scsi/qla4xxx/ql4_os.c: In function =E2=80=98qla4xxx_sysfs_ddb_d=
elete=E2=80=99:
drivers/scsi/qla4xxx/ql4_os.c:6593:
warning: =E2=80=98ddb_size=E2=80=99 may be used uninitialized in this f=
unction

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_o=
s.c
index a47f999..5479cd3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6276,8 +6276,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flas=
h_session *fnode_sess,
 			rc =3D sprintf(buf, "\n");
 		break;
 	case ISCSI_FLASHNODE_DISCOVERY_PARENT_IDX:
-		if ((fnode_sess->discovery_parent_idx) >=3D 0  &&
-		    (fnode_sess->discovery_parent_idx < MAX_DDB_ENTRIES))
+		if (fnode_sess->discovery_parent_idx < MAX_DDB_ENTRIES)
 			parent_index =3D fnode_sess->discovery_parent_idx;
=20
 		rc =3D sprintf(buf, "%u\n", parent_index);
@@ -6287,8 +6286,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flas=
h_session *fnode_sess,
 			parent_type =3D ISCSI_DISC_PARENT_ISNS;
 		else if (fnode_sess->discovery_parent_type =3D=3D DDB_NO_LINK)
 			parent_type =3D ISCSI_DISC_PARENT_UNKNOWN;
-		else if (fnode_sess->discovery_parent_type >=3D 0  &&
-			 fnode_sess->discovery_parent_type < MAX_DDB_ENTRIES)
+		else if (fnode_sess->discovery_parent_type < MAX_DDB_ENTRIES)
 			parent_type =3D ISCSI_DISC_PARENT_SENDTGT;
 		else
 			parent_type =3D ISCSI_DISC_PARENT_UNKNOWN;
@@ -6590,7 +6588,7 @@ static int qla4xxx_sysfs_ddb_delete(struct iscsi_=
bus_flash_session *fnode_sess)
 	struct dev_db_entry *fw_ddb_entry =3D NULL;
 	dma_addr_t fw_ddb_entry_dma;
 	uint16_t *ddb_cookie =3D NULL;
-	size_t ddb_size;
+	size_t ddb_size =3D 0;
 	void *pddb =3D NULL;
 	int target_id;
 	int rc =3D 0;
--=20
1.8.2.GIT

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
