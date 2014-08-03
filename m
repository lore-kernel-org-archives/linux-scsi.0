From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] target: target_core_transport.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun,  3 Aug 2014 23:50:22 +0200
Message-ID: <1407102622-8806-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60490 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaHCVsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2014 17:48:55 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so4001997wib.15
        for <linux-scsi@vger.kernel.org>; Sun, 03 Aug 2014 14:48:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

Ensures that the string is null-terminate in connection with the
use of strncpy. Optimized code by replacing unnecessary sprintf
with strlcat and more, and simultaneously guarantees that the
string does not get bigger than sizeof.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/target/target_core_transport.c |   86 ++++++++++++++++----------------
 1 file changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7fa62fc..1dd1181 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -809,50 +809,51 @@ void transport_dump_vpd_proto_id(
 	unsigned char *p_buf,
 	int p_buf_len)
 {
-	unsigned char buf[VPD_TMP_BUF_SIZE];
 	int len;
-
-	memset(buf, 0, VPD_TMP_BUF_SIZE);
-	len = sprintf(buf, "T10 VPD Protocol Identifier: ");
+	unsigned char buf[VPD_TMP_BUF_SIZE] = "T10 VPD Protocol Identifier: ";
 
 	switch (vpd->protocol_identifier) {
 	case 0x00:
-		sprintf(buf+len, "Fibre Channel\n");
+		strlcat(buf, "Fibre Channel\n", sizeof(buf));
 		break;
 	case 0x10:
-		sprintf(buf+len, "Parallel SCSI\n");
+		strlcat(buf, "Parallel SCSI\n", sizeof(buf));
 		break;
 	case 0x20:
-		sprintf(buf+len, "SSA\n");
+		strlcat(buf, "SSA\n", sizeof(buf));
 		break;
 	case 0x30:
-		sprintf(buf+len, "IEEE 1394\n");
+		strlcat(buf, "IEEE 1394\n", sizeof(buf));
 		break;
 	case 0x40:
-		sprintf(buf+len, "SCSI Remote Direct Memory Access"
-				" Protocol\n");
+		strlcat(buf, "SCSI Remote Direct Memory Access Protocol\n",
+				sizeof(buf));
 		break;
 	case 0x50:
-		sprintf(buf+len, "Internet SCSI (iSCSI)\n");
+		strlcat(buf, "Internet SCSI (iSCSI)\n", sizeof(buf));
 		break;
 	case 0x60:
-		sprintf(buf+len, "SAS Serial SCSI Protocol\n");
+		strlcat(buf, "SAS Serial SCSI Protocol\n", sizeof(buf));
 		break;
 	case 0x70:
-		sprintf(buf+len, "Automation/Drive Interface Transport"
-				" Protocol\n");
+		strlcat(buf, "Automation/Drive Interface Transport Protocol\n",
+				sizeof(buf));
 		break;
 	case 0x80:
-		sprintf(buf+len, "AT Attachment Interface ATA/ATAPI\n");
+		strlcat(buf, "AT Attachment Interface ATA/ATAPI\n",
+				sizeof(buf));
 		break;
 	default:
-		sprintf(buf+len, "Unknown 0x%02x\n",
+		len = strlen(buf);
+		snprintf(&buf[len], sizeof(buf) - len, "Unknown 0x%02x\n",
 				vpd->protocol_identifier);
 		break;
 	}
 
-	if (p_buf)
+	if (p_buf) {
 		strncpy(p_buf, buf, p_buf_len);
+		p_buf[p_buf_len - 1] = '\0';
+	}
 	else
 		pr_debug("%s", buf);
 }
@@ -878,31 +879,33 @@ int transport_dump_vpd_assoc(
 	unsigned char *p_buf,
 	int p_buf_len)
 {
-	unsigned char buf[VPD_TMP_BUF_SIZE];
+	unsigned char buf[VPD_TMP_BUF_SIZE] =
+					"T10 VPD Identifier Association: ";
 	int ret = 0;
 	int len;
 
-	memset(buf, 0, VPD_TMP_BUF_SIZE);
-	len = sprintf(buf, "T10 VPD Identifier Association: ");
-
 	switch (vpd->association) {
 	case 0x00:
-		sprintf(buf+len, "addressed logical unit\n");
+		strlcat(buf, "addressed logical unit\n", sizeof(buf));
 		break;
 	case 0x10:
-		sprintf(buf+len, "target port\n");
+		strlcat(buf, "target port\n", sizeof(buf));
 		break;
 	case 0x20:
-		sprintf(buf+len, "SCSI target device\n");
+		strlcat(buf, "SCSI target device\n", sizeof(buf));
 		break;
 	default:
-		sprintf(buf+len, "Unknown 0x%02x\n", vpd->association);
+		len = strlen(buf);
+		snprintf(&buf[len], sizeof(buf) - len, "Unknown 0x%02x\n",
+				vpd->association);
 		ret = -EINVAL;
 		break;
 	}
 
-	if (p_buf)
+	if (p_buf) {
 		strncpy(p_buf, buf, p_buf_len);
+		p_buf[p_buf_len - 1] = '\0';
+	}
 	else
 		pr_debug("%s", buf);
 
@@ -926,34 +929,32 @@ int transport_dump_vpd_ident_type(
 	unsigned char *p_buf,
 	int p_buf_len)
 {
-	unsigned char buf[VPD_TMP_BUF_SIZE];
+	unsigned char buf[VPD_TMP_BUF_SIZE] = "T10 VPD Identifier Type: ";
 	int ret = 0;
 	int len;
 
-	memset(buf, 0, VPD_TMP_BUF_SIZE);
-	len = sprintf(buf, "T10 VPD Identifier Type: ");
-
 	switch (vpd->device_identifier_type) {
 	case 0x00:
-		sprintf(buf+len, "Vendor specific\n");
+		strlcat(buf, "Vendor specific\n", sizeof(buf));
 		break;
 	case 0x01:
-		sprintf(buf+len, "T10 Vendor ID based\n");
+		strlcat(buf, "T10 Vendor ID based\n", sizeof(buf));
 		break;
 	case 0x02:
-		sprintf(buf+len, "EUI-64 based\n");
+		strlcat(buf, "EUI-64 based\n", sizeof(buf));
 		break;
 	case 0x03:
-		sprintf(buf+len, "NAA\n");
+		strlcat(buf, "NAA\n", sizeof(buf));
 		break;
 	case 0x04:
-		sprintf(buf+len, "Relative target port identifier\n");
+		strlcat(buf, "Relative target port identifier\n", sizeof(buf));
 		break;
 	case 0x08:
-		sprintf(buf+len, "SCSI name string\n");
+		strlcat(buf, "SCSI name string\n", sizeof(buf));
 		break;
 	default:
-		sprintf(buf+len, "Unsupported: 0x%02x\n",
+		len = strlen(len);
+		snprintf(&buf[len], sizeof(buf) - len, "Unsupported: 0x%02x\n",
 				vpd->device_identifier_type);
 		ret = -EINVAL;
 		break;
@@ -990,8 +991,6 @@ int transport_dump_vpd_ident(
 	unsigned char buf[VPD_TMP_BUF_SIZE];
 	int ret = 0;
 
-	memset(buf, 0, VPD_TMP_BUF_SIZE);
-
 	switch (vpd->device_identifier_code_set) {
 	case 0x01: /* Binary */
 		snprintf(buf, sizeof(buf),
@@ -1009,14 +1008,17 @@ int transport_dump_vpd_ident(
 			&vpd->device_identifier[0]);
 		break;
 	default:
-		sprintf(buf, "T10 VPD Device Identifier encoding unsupported:"
-			" 0x%02x", vpd->device_identifier_code_set);
+		snprintf(buf, sizeof(buf),
+			"T10 VPD Device Identifier encoding unsupported: 0x%02x",
+			vpd->device_identifier_code_set);
 		ret = -EINVAL;
 		break;
 	}
 
-	if (p_buf)
+	if (p_buf) {
 		strncpy(p_buf, buf, p_buf_len);
+		p_buf[p_buf_len - 1] = '\0';
+	}
 	else
 		pr_debug("%s", buf);
 
-- 
1.7.10.4

