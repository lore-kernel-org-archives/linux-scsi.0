From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/20] scsi: merge print_opcode_name()
Date: Wed,  3 Sep 2014 12:06:07 +0200
Message-ID: <1409738775-80876-13-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbaICKGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:31 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Instead of having two versions of print_opcode_name() we
should be consolidating them into one version.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 90 +++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 364349c..3aee43b 100644
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
@@ -267,6 +266,28 @@ static struct sa_name_list sa_names_arr[] = {
 };
 #define SA_NAME_LIST_SZ ARRAY_SIZE(sa_names_arr)
 
+#else /* ifndef CONFIG_SCSI_CONSTANTS */
+static const char * cdb_byte0_names[] = NULL;
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
+#define SA_NAME_LIST_SZ ARRAY_SIZE(sa_names_arr)
+#define CDB_BYTE0_NAMES_SZ ARRAY_SIZE(cdb_byte0_names)
+
 static bool scsi_opcode_sa_name(int cmd, int service_action,
 				const char **sa_name)
 {
@@ -316,11 +337,14 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 
 	if (!scsi_opcode_sa_name(cdb0, sa, &name)) {
 		if (cdb0 < 0xc0) {
-			name = cdb_byte0_names[cdb0];
-			if (name)
-				printk("%s", name);
-			else
-				printk("cdb[0]=0x%x (reserved)", cdb0);
+			if (CDB_BYTE0_NAMES_SZ) {
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
@@ -334,50 +358,6 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
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

