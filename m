From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Add missing command definitions
Date: Thu, 15 Oct 2009 14:43:23 -0400
Message-ID: <yq1hbu08pmc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:20849 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935273AbZJOSoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2009 14:44:13 -0400
Received: from rgminet15.oracle.com (rcsinet15.oracle.com [148.87.113.117])
	by rgminet11.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n9FIiq50017004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2009 18:44:54 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by rgminet15.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n9FIhXV5012777
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2009 18:43:33 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add definitions for UNMAP, WRITE SAME{16,32} and GET LBA STATUS
commands.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 63abb06..9129bcf 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -141,6 +141,7 @@ static const struct value_name_pair serv_out12_arr[] = {
 static const struct value_name_pair serv_in16_arr[] = {
 	{0x10, "Read capacity(16)"},
 	{0x11, "Read long(16)"},
+	{0x12, "Get LBA status"},
 };
 #define SERV_IN16_SZ ARRAY_SIZE(serv_in16_arr)
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 34c46ab..8b4deca 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -94,6 +94,7 @@ struct scsi_cmnd;
 #define WRITE_LONG            0x3f
 #define CHANGE_DEFINITION     0x40
 #define WRITE_SAME            0x41
+#define UNMAP		      0x42
 #define READ_TOC              0x43
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
@@ -122,9 +123,11 @@ struct scsi_cmnd;
 #define READ_16               0x88
 #define WRITE_16              0x8a
 #define VERIFY_16	      0x8f
+#define WRITE_SAME_16	      0x93
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
+#define SAI_GET_LBA_STATUS    0x12
 /* values for maintenance in */
 #define MI_REPORT_TARGET_PGS  0x0a
 /* values for maintenance out */
@@ -132,6 +135,7 @@ struct scsi_cmnd;
 /* values for variable length command */
 #define READ_32		      0x09
 #define WRITE_32	      0x0b
+#define WRITE_SAME_32	      0x0d
 
 /* Values for T10/04-262r7 */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
