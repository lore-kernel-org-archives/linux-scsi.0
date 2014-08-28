From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/22] Implement scsi_opcode_sa_name
Date: Thu, 28 Aug 2014 19:33:25 +0200
Message-ID: <1409247216-76074-12-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaH1Rdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:41 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Implement a lookup array for SERVICE ACTION commands instead
of hardcoding it in a large switch statement.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 130 +++++++++++++++++++----------------------------
 1 file changed, 53 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 323e944..813c482 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -244,102 +244,77 @@ static const struct value_name_pair variable_length_arr[] = {
 };
 #define VARIABLE_LENGTH_SZ ARRAY_SIZE(variable_length_arr)
 
-static const char * get_sa_name(const struct value_name_pair * arr,
-			        int arr_sz, int service_action)
+struct sa_name_list {
+	int cmd;
+	const struct value_name_pair *arr;
+	int arr_sz;
+};
+
+static struct sa_name_list sa_names_arr[] = {
+	{VARIABLE_LENGTH_CMD, variable_length_arr, VARIABLE_LENGTH_SZ},
+	{MAINTENANCE_IN, maint_in_arr, MAINT_IN_SZ},
+	{MAINTENANCE_OUT, maint_out_arr, MAINT_OUT_SZ},
+	{PERSISTENT_RESERVE_IN, pr_in_arr, PR_IN_SZ},
+	{PERSISTENT_RESERVE_OUT, pr_out_arr, PR_OUT_SZ},
+	{SERVICE_ACTION_IN_12, serv_in12_arr, SERV_IN12_SZ},
+	{SERVICE_ACTION_OUT_12, serv_out12_arr, SERV_OUT12_SZ},
+	{SERVICE_ACTION_BIDIRECTIONAL, serv_bidi_arr, SERV_BIDI_SZ},
+	{SERVICE_ACTION_IN_16, serv_in16_arr, SERV_IN16_SZ},
+	{SERVICE_ACTION_OUT_16, serv_out16_arr, SERV_OUT16_SZ},
+	{THIRD_PARTY_COPY_IN, tpc_in_arr, TPC_IN_SZ},
+	{THIRD_PARTY_COPY_OUT, tpc_out_arr, TPC_OUT_SZ},
+	{0, NULL, 0},
+};
+#define SA_NAME_LIST_SZ ARRAY_SIZE(sa_names_arr)
+
+static int scsi_opcode_sa_name(int cmd, int service_action,
+			       const char **sa_name)
 {
-	int k;
+	struct sa_name_list *sa_name_ptr = sa_names_arr;
+	const struct value_name_pair * arr = NULL;
+	int arr_sz, k;
+
+	for (k = 0; k < SA_NAME_LIST_SZ; ++k, ++sa_name_ptr) {
+		if (sa_name_ptr->cmd == cmd) {
+			arr = sa_name_ptr->arr;
+			arr_sz = sa_name_ptr->arr_sz;
+			break;
+		}
+	}
+	if (!arr)
+		return 0;
 
 	for (k = 0; k < arr_sz; ++k, ++arr) {
 		if (service_action == arr->value)
 			break;
 	}
-	return (k < arr_sz) ? arr->name : NULL;
+	if (k < arr_sz)
+		*sa_name = arr->name;
+
+	return 1;
 }
 
 /* attempt to guess cdb length if cdb_len==0 . No trailing linefeed. */
 static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 {
 	int sa, len, cdb0;
-	int fin_name = 0;
 	const char * name;
 
 	cdb0 = cdbp[0];
-	switch(cdb0) {
-	case VARIABLE_LENGTH_CMD:
+	if (cdb0 == VARIABLE_LENGTH_CMD) {
 		len = scsi_varlen_cdb_length(cdbp);
 		if (len < 10) {
 			printk("short variable length command, "
 			       "len=%d ext_len=%d", len, cdb_len);
-			break;
+			return;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
-		name = get_sa_name(variable_length_arr, VARIABLE_LENGTH_SZ,
-				   sa);
-		if (name)
-			printk("%s", name);
-		else
-			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
-
-		if ((cdb_len > 0) && (len != cdb_len))
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
-
-		break;
-	case MAINTENANCE_IN:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(maint_in_arr, MAINT_IN_SZ, sa);
-		fin_name = 1;
-		break;
-	case MAINTENANCE_OUT:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(maint_out_arr, MAINT_OUT_SZ, sa);
-		fin_name = 1;
-		break;
-	case PERSISTENT_RESERVE_IN:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(pr_in_arr, PR_IN_SZ, sa);
-		fin_name = 1;
-		break;
-	case PERSISTENT_RESERVE_OUT:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(pr_out_arr, PR_OUT_SZ, sa);
-		fin_name = 1;
-		break;
-	case SERVICE_ACTION_IN_12:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(serv_in12_arr, SERV_IN12_SZ, sa);
-		fin_name = 1;
-		break;
-	case SERVICE_ACTION_OUT_12:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(serv_out12_arr, SERV_OUT12_SZ, sa);
-		fin_name = 1;
-		break;
-	case SERVICE_ACTION_BIDIRECTIONAL:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(serv_bidi_arr, SERV_BIDI_SZ, sa);
-		fin_name = 1;
-		break;
-	case SERVICE_ACTION_IN_16:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(serv_in16_arr, SERV_IN16_SZ, sa);
-		fin_name = 1;
-		break;
-	case SERVICE_ACTION_OUT_16:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(serv_out16_arr, SERV_OUT16_SZ, sa);
-		fin_name = 1;
-		break;
-	case THIRD_PARTY_COPY_IN:
-		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(tpc_in_arr, TPC_IN_SZ, sa);
-		fin_name = 1;
-		break;
-	case THIRD_PARTY_COPY_OUT:
+	} else {
 		sa = cdbp[1] & 0x1f;
-		name = get_sa_name(tpc_out_arr, TPC_OUT_SZ, sa);
-		fin_name = 1;
-		break;
-	default:
+		len = cdb_len;
+	}
+
+	if (!scsi_opcode_sa_name(cdb0, sa, &name)) {
 		if (cdb0 < 0xc0) {
 			name = cdb_byte0_names[cdb0];
 			if (name)
@@ -348,13 +323,14 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 				printk("cdb[0]=0x%x (reserved)", cdb0);
 		} else
 			printk("cdb[0]=0x%x (vendor)", cdb0);
-		break;
-	}
-	if (fin_name) {
+	} else {
 		if (name)
 			printk("%s", name);
 		else
 			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
+
+		if ((cdb_len > 0) && (len != cdb_len))
+			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
 	}
 }
 
-- 
1.8.5.2

