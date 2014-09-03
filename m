From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/20] scsi: consolidate opcode lookup in scsi_opcode_sa_name()
Date: Wed,  3 Sep 2014 12:06:08 +0200
Message-ID: <1409738775-80876-14-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406AbaICKG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:28 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Consolidate the CDB opcode lookup in scsi_opcode_sa_name(),
so that we don't have to call several functions to figure
out the CDB opcode string.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 3aee43b..6076969 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -289,12 +289,19 @@ static struct sa_name_list sa_names_arr[] = {
 #define CDB_BYTE0_NAMES_SZ ARRAY_SIZE(cdb_byte0_names)
 
 static bool scsi_opcode_sa_name(int cmd, int service_action,
-				const char **sa_name)
+				const char **cdb_name, const char **sa_name)
 {
 	struct sa_name_list *sa_name_ptr = sa_names_arr;
 	const struct value_name_pair * arr = NULL;
 	int arr_sz, k;
 
+	*cdb_name = NULL;
+	if (cmd >= 0xc0)
+		return false;
+
+	if (cmd < CDB_BYTE0_NAMES_SZ)
+		*cdb_name = cdb_byte0_names[cmd];
+
 	for (k = 0; k < SA_NAME_LIST_SZ; ++k, ++sa_name_ptr) {
 		if (sa_name_ptr->cmd == cmd) {
 			arr = sa_name_ptr->arr;
@@ -319,7 +326,7 @@ static bool scsi_opcode_sa_name(int cmd, int service_action,
 static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 {
 	int sa, len, cdb0;
-	const char * name = NULL;
+	const char *cdb_name = NULL, *sa_name = NULL;
 
 	cdb0 = cdbp[0];
 	if (cdb0 == VARIABLE_LENGTH_CMD) {
@@ -335,21 +342,20 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 		len = cdb_len;
 	}
 
-	if (!scsi_opcode_sa_name(cdb0, sa, &name)) {
-		if (cdb0 < 0xc0) {
-			if (CDB_BYTE0_NAMES_SZ) {
-				name = cdb_byte0_names[cdb0];
-				if (name)
-					printk("%s", name);
-				else
-					printk("cdb[0]=0x%x (reserved)", cdb0);
-			} else
-				printk("cdb[0]=0x%x", cdb0);
-		} else
+	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
+		if (cdb_name)
+			printk("%s", cdb_name);
+		else if (cdb0 > 0xc0)
 			printk("cdb[0]=0x%x (vendor)", cdb0);
+		else if (cdb0 > 0x60 && cdb0 < 0x7e)
+			printk("cdb[0]=0x%x (reserved)", cdb0);
+		else
+			printk("cdb[0]=0x%x", cdb0);
 	} else {
-		if (name)
-			printk("%s", name);
+		if (sa_name)
+			printk("%s", sa_name);
+		else if (cdb_name)
+			printk("%s, sa=0x%x", cdb_name, sa);
 		else
 			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
 
-- 
1.8.5.2

