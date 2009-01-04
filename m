From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3 of 4] sd: Fix tagging on platforms with signed char
Date: Sun, 04 Jan 2009 03:04:33 -0500
Message-ID: <b87c77ae7ab46cf677a8.1231056273@sermon.lab.mkp.net>
References: <patchbomb.1231056270@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:52476 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZADIWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jan 2009 03:22:41 -0500
In-Reply-To: <patchbomb.1231056270@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Switch tag arrays to u8 to prevent problems on platforms with signed
char.

Reported-by: Tim LaBerge <tim.laberge@Quantum.Com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 4 insertions(+), 4 deletions(-)
drivers/scsi/sd_dif.c |    8 ++++----



diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -142,7 +142,7 @@ static void sd_dif_type1_set_tag(void *p
 static void sd_dif_type1_set_tag(void *prot, void *tag_buf, unsigned int sectors)
 {
 	struct sd_dif_tuple *sdt = prot;
-	char *tag = tag_buf;
+	u8 *tag = tag_buf;
 	unsigned int i, j;
 
 	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
@@ -154,7 +154,7 @@ static void sd_dif_type1_get_tag(void *p
 static void sd_dif_type1_get_tag(void *prot, void *tag_buf, unsigned int sectors)
 {
 	struct sd_dif_tuple *sdt = prot;
-	char *tag = tag_buf;
+	u8 *tag = tag_buf;
 	unsigned int i, j;
 
 	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
@@ -256,7 +256,7 @@ static void sd_dif_type3_set_tag(void *p
 static void sd_dif_type3_set_tag(void *prot, void *tag_buf, unsigned int sectors)
 {
 	struct sd_dif_tuple *sdt = prot;
-	char *tag = tag_buf;
+	u8 *tag = tag_buf;
 	unsigned int i, j;
 
 	for (i = 0, j = 0 ; i < sectors ; i++, j += 6, sdt++) {
@@ -269,7 +269,7 @@ static void sd_dif_type3_get_tag(void *p
 static void sd_dif_type3_get_tag(void *prot, void *tag_buf, unsigned int sectors)
 {
 	struct sd_dif_tuple *sdt = prot;
-	char *tag = tag_buf;
+	u8 *tag = tag_buf;
 	unsigned int i, j;
 
 	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {


