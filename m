From: brking@us.ibm.com
Subject: [PATCH 18/26] ipr: Handle device autosense
Date: Tue, 01 Nov 2005 17:02:08 -0600
Message-ID: <200511012302.jA1N29tu016909@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:908 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751414AbVKAXCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:02:10 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N2Aqq022220
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:10 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N2Abn113754
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:10 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N29CV016961
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:02:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Some newer ipr adapters are capable of returning autosense from
devices that support it. This patch adds the data structures for
the autosense buffer.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.h |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_ioasa_autosense drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_ioasa_autosense	2005-11-01 16:08:09.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-11-01 16:08:09.000000000 -0600
@@ -403,23 +403,26 @@ struct ipr_ioadl_desc {
 struct ipr_ioasa_vset {
 	__be32 failing_lba_hi;
 	__be32 failing_lba_lo;
-	__be32 ioa_data[22];
+	__be32 reserved;
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ioasa_af_dasd {
 	__be32 failing_lba;
+	__be32 reserved[2];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ioasa_gpdd {
 	u8 end_state;
 	u8 bus_phase;
 	__be16 reserved;
-	__be32 ioa_data[23];
+	__be32 ioa_data[2];
 }__attribute__((packed, aligned (4)));
 
-struct ipr_ioasa_raw {
-	__be32 ioa_data[24];
-}__attribute__((packed, aligned (4)));
+struct ipr_auto_sense {
+	__be16 auto_sense_len;
+	__be16 ioa_data_len;
+	__be32 data[SCSI_SENSE_BUFFERSIZE/sizeof(__be32)];
+};
 
 struct ipr_ioasa {
 	__be32 ioasc;
@@ -446,6 +449,8 @@ struct ipr_ioasa {
 	__be32 fd_res_handle;
 
 	__be32 ioasc_specific;	/* status code specific field */
+#define IPR_ADDITIONAL_STATUS_FMT		0x80000000
+#define IPR_AUTOSENSE_VALID			0x40000000
 #define IPR_IOASC_SPECIFIC_MASK		0x00ffffff
 #define IPR_FIELD_POINTER_VALID		(0x80000000 >> 8)
 #define IPR_FIELD_POINTER_MASK		0x0000ffff
@@ -454,8 +459,9 @@ struct ipr_ioasa {
 		struct ipr_ioasa_vset vset;
 		struct ipr_ioasa_af_dasd dasd;
 		struct ipr_ioasa_gpdd gpdd;
-		struct ipr_ioasa_raw raw;
 	} u;
+
+	struct ipr_auto_sense auto_sense;
 }__attribute__((packed, aligned (4)));
 
 struct ipr_mode_parm_hdr {
_
