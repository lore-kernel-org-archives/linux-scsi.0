From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: qla4xxx: ql4_os.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:49:32 +0200
Message-ID: <1406386172-4142-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/qla4xxx/ql4_os.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 3202063..a07c53e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -756,9 +756,9 @@ static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 			continue;
 
 		chap_rec->chap_tbl_idx = i;
-		strncpy(chap_rec->username, chap_table->name,
+		strlcpy(chap_rec->username, chap_table->name,
 			ISCSI_CHAP_AUTH_NAME_MAX_LEN);
-		strncpy(chap_rec->password, chap_table->secret,
+		strlcpy(chap_rec->password, chap_table->secret,
 			QL4_CHAP_MAX_SECRET_LEN);
 		chap_rec->password_length = chap_table->secret_len;
 
@@ -6027,8 +6027,8 @@ static int qla4xxx_get_bidi_chap(struct scsi_qla_host *ha, char *username,
 		if (!(chap_table->flags & BIT_6)) /* Not BIDI */
 			continue;
 
-		strncpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
-		strncpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
+		strlcpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
+		strlcpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
 		ret = 0;
 		break;
 	}
@@ -6258,8 +6258,8 @@ static void qla4xxx_get_param_ddb(struct ddb_entry *ddb_entry,
 
 	tddb->tpgt = sess->tpgt;
 	tddb->port = conn->persistent_port;
-	strncpy(tddb->iscsi_name, sess->targetname, ISCSI_NAME_SIZE);
-	strncpy(tddb->ip_addr, conn->persistent_address, DDB_IPADDR_LEN);
+	strlcpy(tddb->iscsi_name, sess->targetname, ISCSI_NAME_SIZE);
+	strlcpy(tddb->ip_addr, conn->persistent_address, DDB_IPADDR_LEN);
 }
 
 static void qla4xxx_convert_param_ddb(struct dev_db_entry *fw_ddb_entry,
@@ -7764,7 +7764,7 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 		goto exit_ddb_logout;
 	}
 
-	strncpy(flash_tddb->iscsi_name, fnode_sess->targetname,
+	strlcpy(flash_tddb->iscsi_name, fnode_sess->targetname,
 		ISCSI_NAME_SIZE);
 
 	if (!strncmp(fnode_sess->portal_type, PORTAL_TYPE_IPV6, 4))
-- 
1.7.10.4
