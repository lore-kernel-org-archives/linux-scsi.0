From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/26] scsi: consolidate opcode lookup in scsi_opcode_sa_name()
Date: Mon,  6 Oct 2014 11:01:16 +0200
Message-ID: <1412586086-129821-17-git-send-email-hare@suse.de>
References: <1412586086-129821-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbaJFJBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2014 05:01:35 -0400
In-Reply-To: <1412586086-129821-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Consolidate the CDB opcode lookup in scsi_opcode_sa_name(),
so that we don't have to call several functions to figure
out the CDB opcode string.

Reviewed_by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellweg <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 3b22740..6d34d1f 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -29,6 +29,7 @@
 #define THIRD_PARTY_COPY_OUT 0x83
 #define THIRD_PARTY_COPY_IN 0x84
 
+#define VENDOR_SPECIFIC_CDB 0xc0
 
 struct sa_name_list {
 	int opcode;
@@ -286,12 +287,19 @@ static struct sa_name_list sa_names_arr[] = {
 #endif /* CONFIG_SCSI_CONSTANTS */
 
 static bool scsi_opcode_sa_name(int opcode, int service_action,
-				const char **sa_name)
+				const char **cdb_name, const char **sa_name)
 {
 	struct sa_name_list *sa_name_ptr = sa_names_arr;
 	const struct value_name_pair *arr = NULL;
 	int arr_sz, k;
 
+	*cdb_name = NULL;
+	if (opcode >= VENDOR_SPECIFIC_CDB)
+		return false;
+
+	if (opcode < ARRAY_SIZE(cdb_byte0_names))
+		*cdb_name = cdb_byte0_names[opcode];
+
 	for (k = 0; sa_name_ptr->opcode; ++k, ++sa_name_ptr) {
 		if (sa_name_ptr->opcode == opcode) {
 			arr = sa_name_ptr->arr;
@@ -316,7 +324,7 @@ static bool scsi_opcode_sa_name(int opcode, int service_action,
 static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 {
 	int sa, len, cdb0;
-	const char *name = NULL;
+	const char *cdb_name = NULL, *sa_name = NULL;
 
 	cdb0 = cdbp[0];
 	if (cdb0 == VARIABLE_LENGTH_CMD) {
@@ -332,21 +340,20 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 		len = cdb_len;
 	}
 
-	if (!scsi_opcode_sa_name(cdb0, sa, &name)) {
-		if (cdb0 < 0xc0) {
-			if (ARRAY_SIZE(cdb_byte0_names) > 1) {
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
+		else if (cdb0 >= VENDOR_SPECIFIC_CDB)
 			printk("cdb[0]=0x%x (vendor)", cdb0);
+		else if (cdb0 >= 0x60 && cdb0 < 0x7e)
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

