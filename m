From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/38] scsi: merge print_opcode_name()
Date: Mon, 29 Sep 2014 13:58:43 +0200
Message-ID: <1411991947-130166-15-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbaI2L7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:14 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Instead of having two versions of print_opcode_name() we
should be consolidating them into one version.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 91 ++++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index b9eb6a1..c1cdfab 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -30,6 +30,11 @@
 #define THIRD_PARTY_COPY_IN 0x84
 
 
+struct sa_name_list {
+	int cmd;
+	const struct value_name_pair *arr;
+	int arr_sz;
+};
 
 #ifdef CONFIG_SCSI_CONSTANTS
 static const char * cdb_byte0_names[] = {
@@ -244,12 +249,6 @@ static const struct value_name_pair variable_length_arr[] = {
 };
 #define VARIABLE_LENGTH_SZ ARRAY_SIZE(variable_length_arr)
 
-struct sa_name_list {
-	int cmd;
-	const struct value_name_pair *arr;
-	int arr_sz;
-};
-
 static struct sa_name_list sa_names_arr[] = {
 	{VARIABLE_LENGTH_CMD, variable_length_arr, VARIABLE_LENGTH_SZ},
 	{MAINTENANCE_IN, maint_in_arr, MAINT_IN_SZ},
@@ -265,7 +264,26 @@ static struct sa_name_list sa_names_arr[] = {
 	{THIRD_PARTY_COPY_OUT, tpc_out_arr, TPC_OUT_SZ},
 	{0, NULL, 0},
 };
-#define SA_NAME_LIST_SZ ARRAY_SIZE(sa_names_arr)
+
+#else /* ifndef CONFIG_SCSI_CONSTANTS */
+static const char *cdb_byte0_names[];
+
+static struct sa_name_list sa_names_arr[] = {
+	{VARIABLE_LENGTH_CMD, NULL, 0},
+	{MAINTENANCE_IN, NULL, 0},
+	{MAINTENANCE_OUT, NULL, 0},
+	{PERSISTENT_RESERVE_IN, NULL, 0},
+	{PERSISTENT_RESERVE_OUT, NULL, 0},
+	{SERVICE_ACTION_IN_12, NULL, 0},
+	{SERVICE_ACTION_OUT_12, NULL, 0},
+	{SERVICE_ACTION_BIDIRECTIONAL, NULL, 0},
+	{SERVICE_ACTION_IN_16, NULL, 0},
+	{SERVICE_ACTION_OUT_16, NULL, 0},
+	{THIRD_PARTY_COPY_IN, NULL, 0},
+	{THIRD_PARTY_COPY_OUT, NULL, 0},
+	{0, NULL, 0},
+};
+#endif /* CONFIG_SCSI_CONSTANTS */
 
 static bool scsi_opcode_sa_name(int cmd, int service_action,
 				const char **sa_name)
@@ -274,7 +292,7 @@ static bool scsi_opcode_sa_name(int cmd, int service_action,
 	const struct value_name_pair *arr = NULL;
 	int arr_sz, k;
 
-	for (k = 0; k < SA_NAME_LIST_SZ; ++k, ++sa_name_ptr) {
+	for (k = 0; k < ARRAY_SIZE(sa_names_arr); ++k, ++sa_name_ptr) {
 		if (sa_name_ptr->cmd == cmd) {
 			arr = sa_name_ptr->arr;
 			arr_sz = sa_name_ptr->arr_sz;
@@ -316,11 +334,14 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 
 	if (!scsi_opcode_sa_name(cdb0, sa, &name)) {
 		if (cdb0 < 0xc0) {
-			name = cdb_byte0_names[cdb0];
-			if (name)
-				printk("%s", name);
-			else
-				printk("cdb[0]=0x%x (reserved)", cdb0);
+			if (ARRAY_SIZE(cdb_byte0_names)) {
+				name = cdb_byte0_names[cdb0];
+				if (name)
+					printk("%s", name);
+				else
+					printk("cdb[0]=0x%x (reserved)", cdb0);
+			} else
+				printk("cdb[0]=0x%x", cdb0);
 		} else
 			printk("cdb[0]=0x%x (vendor)", cdb0);
 	} else {
@@ -334,50 +355,6 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 	}
 }
 
-#else /* ifndef CONFIG_SCSI_CONSTANTS */
-
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
-{
-	int sa, len, cdb0;
-
-	cdb0 = cdbp[0];
-	switch(cdb0) {
-	case VARIABLE_LENGTH_CMD:
-		len = scsi_varlen_cdb_length(cdbp);
-		if (len < 10) {
-			printk("short opcode=0x%x command, len=%d "
-			       "ext_len=%d", cdb0, len, cdb_len);
-			break;
-		}
-		sa = (cdbp[8] << 8) + cdbp[9];
-		printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
-		if (len != cdb_len)
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
-		break;
-	case MAINTENANCE_IN:
-	case MAINTENANCE_OUT:
-	case PERSISTENT_RESERVE_IN:
-	case PERSISTENT_RESERVE_OUT:
-	case SERVICE_ACTION_IN_12:
-	case SERVICE_ACTION_OUT_12:
-	case SERVICE_ACTION_BIDIRECTIONAL:
-	case SERVICE_ACTION_IN_16:
-	case SERVICE_ACTION_OUT_16:
-	case THIRD_PARTY_COPY_IN:
-	case THIRD_PARTY_COPY_OUT:
-		sa = cdbp[1] & 0x1f;
-		printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
-		break;
-	default:
-		if (cdb0 < 0xc0)
-			printk("cdb[0]=0x%x", cdb0);
-		else
-			printk("cdb[0]=0x%x (vendor)", cdb0);
-		break;
-	}
-}
-#endif
-
 void __scsi_print_command(unsigned char *cdb)
 {
 	int k, len;
-- 
1.8.5.2

