From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] qla4xxx: overflow in qla4xxx_set_chap_entry()
Date: Wed, 13 Nov 2013 10:48:11 +0300
Message-ID: <20131113074811.GF25541@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25552 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3KMHse (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2013 02:48:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Cc: iscsi-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We should cap the size of memcpy() because it comes from the network
and can't be trusted.

Fixes: 26ffd7b45fe9 ('[SCSI] qla4xxx: Add support to set CHAP entries')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a28d5e6..cf174a4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -802,6 +802,7 @@ static int qla4xxx_set_chap_entry(struct Scsi_Host *shost, void *data, int len)
 	int type;
 	int rem = len;
 	int rc = 0;
+	int size;
 
 	memset(&chap_rec, 0, sizeof(chap_rec));
 
@@ -816,12 +817,14 @@ static int qla4xxx_set_chap_entry(struct Scsi_Host *shost, void *data, int len)
 			chap_rec.chap_type = param_info->value[0];
 			break;
 		case ISCSI_CHAP_PARAM_USERNAME:
-			memcpy(chap_rec.username, param_info->value,
-			       param_info->len);
+			size = min_t(size_t, sizeof(chap_rec.username),
+				     param_info->len);
+			memcpy(chap_rec.username, param_info->value, size);
 			break;
 		case ISCSI_CHAP_PARAM_PASSWORD:
-			memcpy(chap_rec.password, param_info->value,
-			       param_info->len);
+			size = min_t(size_t, sizeof(chap_rec.password),
+				     param_info->len);
+			memcpy(chap_rec.password, param_info->value, size);
 			break;
 		case ISCSI_CHAP_PARAM_PASSWORD_LEN:
 			chap_rec.password_length = param_info->value[0];
