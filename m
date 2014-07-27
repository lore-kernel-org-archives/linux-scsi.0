From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: qla4xxx: ql4_mbx.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 16:57:42 +0200
Message-ID: <1406473062-12509-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And in some cases modified to copy one character less than the overall
length, as the entire area is already zeroed.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 0a3312c..2b2756e 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1620,8 +1620,8 @@ int qla4xxx_get_chap(struct scsi_qla_host *ha, char *username, char *password,
 		goto exit_get_chap;
 	}
 
-	strncpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
-	strncpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
+	strlcpy(password, chap_table->secret, QL4_CHAP_MAX_SECRET_LEN);
+	strlcpy(username, chap_table->name, QL4_CHAP_MAX_NAME_LEN);
 	chap_table->cookie = __constant_cpu_to_le16(CHAP_VALID_COOKIE);
 
 exit_get_chap:
@@ -1663,8 +1663,8 @@ int qla4xxx_set_chap(struct scsi_qla_host *ha, char *username, char *password,
 	else
 		chap_table->flags |= BIT_7; /* local */
 	chap_table->secret_len = strlen(password);
-	strncpy(chap_table->secret, password, MAX_CHAP_SECRET_LEN);
-	strncpy(chap_table->name, username, MAX_CHAP_NAME_LEN);
+	strncpy(chap_table->secret, password, MAX_CHAP_SECRET_LEN - 1);
+	strncpy(chap_table->name, username, MAX_CHAP_NAME_LEN - 1);
 	chap_table->cookie = __constant_cpu_to_le16(CHAP_VALID_COOKIE);
 
 	if (is_qla40XX(ha)) {
@@ -1742,8 +1742,8 @@ int qla4xxx_get_uni_chap_at_index(struct scsi_qla_host *ha, char *username,
 		goto exit_unlock_uni_chap;
 	}
 
-	strncpy(password, chap_table->secret, MAX_CHAP_SECRET_LEN);
-	strncpy(username, chap_table->name, MAX_CHAP_NAME_LEN);
+	strlcpy(password, chap_table->secret, MAX_CHAP_SECRET_LEN);
+	strlcpy(username, chap_table->name, MAX_CHAP_NAME_LEN);
 
 	rval = QLA_SUCCESS;
 
@@ -2295,7 +2295,7 @@ int qla4_8xxx_set_param(struct scsi_qla_host *ha, int param)
 	if (param == SET_DRVR_VERSION) {
 		mbox_cmd[1] = SET_DRVR_VERSION;
 		strncpy((char *)&mbox_cmd[2], QLA4XXX_DRIVER_VERSION,
-			MAX_DRVR_VER_LEN);
+			MAX_DRVR_VER_LEN - 1);
 	} else {
 		ql4_printk(KERN_ERR, ha, "%s: invalid parameter 0x%x\n",
 			   __func__, param);
-- 
1.7.10.4
