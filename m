From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 12/12] scsi_debug: use locally assigned naa
Date: Mon, 25 Apr 2016 12:16:39 -0400
Message-ID: <1461600999-28893-13-git-send-email-dgilbert@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37019 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbcDYQRP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:17:15 -0400
In-Reply-To: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

Change NAA addresses used for SAS addresses from fake IEEE
registered NAA (5) to locally assigned NAA (3).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 46bdd3e..15f6d55 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -915,9 +915,10 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 static const char * inq_vendor_id = "Linux   ";
 static const char * inq_product_id = "scsi_debug      ";
 static const char *inq_product_rev = "0186";	/* version less '.' */
-static const u64 naa5_comp_a = 0x5222222000000000ULL;
-static const u64 naa5_comp_b = 0x5333333000000000ULL;
-static const u64 naa5_comp_c = 0x5111111000000000ULL;
+/* Use some locallu assigned NAAs for SAS addresses. */
+static const u64 naa3_comp_a = 0x3222222000000000ULL;
+static const u64 naa3_comp_b = 0x3333333000000000ULL;
+static const u64 naa3_comp_c = 0x3111111000000000ULL;
 
 /* Device identification VPD page. Returns number of bytes placed in arr */
 static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
@@ -951,12 +952,12 @@ static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
 			memcpy(arr + num, lu_name, 16);
 			num += 16;
 		} else {
-			/* NAA-5, Logical unit identifier (binary) */
+			/* NAA-3, Logical unit identifier (binary) */
 			arr[num++] = 0x1;  /* binary (not necessarily sas) */
 			arr[num++] = 0x3;  /* PIV=0, lu, naa */
 			arr[num++] = 0x0;
 			arr[num++] = 0x8;
-			put_unaligned_be64(naa5_comp_b + dev_id_num, arr + num);
+			put_unaligned_be64(naa3_comp_b + dev_id_num, arr + num);
 			num += 8;
 		}
 		/* Target relative port number */
@@ -969,14 +970,14 @@ static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
 		arr[num++] = 0x0;
 		arr[num++] = 0x1;	/* relative port A */
 	}
-	/* NAA-5, Target port identifier */
+	/* NAA-3, Target port identifier */
 	arr[num++] = 0x61;	/* proto=sas, binary */
 	arr[num++] = 0x93;	/* piv=1, target port, naa */
 	arr[num++] = 0x0;
 	arr[num++] = 0x8;
-	put_unaligned_be64(naa5_comp_a + port_a, arr + num);
+	put_unaligned_be64(naa3_comp_a + port_a, arr + num);
 	num += 8;
-	/* NAA-5, Target port group identifier */
+	/* NAA-3, Target port group identifier */
 	arr[num++] = 0x61;	/* proto=sas, binary */
 	arr[num++] = 0x95;	/* piv=1, target port group id */
 	arr[num++] = 0x0;
@@ -985,19 +986,19 @@ static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
 	arr[num++] = 0;
 	put_unaligned_be16(port_group_id, arr + num);
 	num += 2;
-	/* NAA-5, Target device identifier */
+	/* NAA-3, Target device identifier */
 	arr[num++] = 0x61;	/* proto=sas, binary */
 	arr[num++] = 0xa3;	/* piv=1, target device, naa */
 	arr[num++] = 0x0;
 	arr[num++] = 0x8;
-	put_unaligned_be64(naa5_comp_a + target_dev_id, arr + num);
+	put_unaligned_be64(naa3_comp_a + target_dev_id, arr + num);
 	num += 8;
 	/* SCSI name string: Target device identifier */
 	arr[num++] = 0x63;	/* proto=sas, UTF-8 */
 	arr[num++] = 0xa8;	/* piv=1, target device, SCSI name string */
 	arr[num++] = 0x0;
 	arr[num++] = 24;
-	memcpy(arr + num, "naa.52222220", 12);
+	memcpy(arr + num, "naa.32222220", 12);
 	num += 12;
 	snprintf(b, sizeof(b), "%08X", target_dev_id);
 	memcpy(arr + num, b, 8);
@@ -1076,7 +1077,7 @@ static int inquiry_vpd_88(unsigned char *arr, int target_dev_id)
 	arr[num++] = 0x93;	/* PIV=1, target port, NAA */
 	arr[num++] = 0x0;	/* reserved */
 	arr[num++] = 0x8;	/* length */
-	put_unaligned_be64(naa5_comp_a + port_a, arr + num);
+	put_unaligned_be64(naa3_comp_a + port_a, arr + num);
 	num += 8;
 	arr[num++] = 0x0;	/* reserved */
 	arr[num++] = 0x0;	/* reserved */
@@ -1091,7 +1092,7 @@ static int inquiry_vpd_88(unsigned char *arr, int target_dev_id)
 	arr[num++] = 0x93;	/* PIV=1, target port, NAA */
 	arr[num++] = 0x0;	/* reserved */
 	arr[num++] = 0x8;	/* length */
-	put_unaligned_be64(naa5_comp_a + port_b, arr + num);
+	put_unaligned_be64(naa3_comp_a + port_b, arr + num);
 	num += 8;
 
 	return num;
@@ -1920,10 +1921,10 @@ static int resp_sas_pcd_m_spg(unsigned char * p, int pcontrol, int target,
 		};
 	int port_a, port_b;
 
-	put_unaligned_be64(naa5_comp_a, sas_pcd_m_pg + 16);
-	put_unaligned_be64(naa5_comp_c + 1, sas_pcd_m_pg + 24);
-	put_unaligned_be64(naa5_comp_a, sas_pcd_m_pg + 64);
-	put_unaligned_be64(naa5_comp_c + 1, sas_pcd_m_pg + 72);
+	put_unaligned_be64(naa3_comp_a, sas_pcd_m_pg + 16);
+	put_unaligned_be64(naa3_comp_c + 1, sas_pcd_m_pg + 24);
+	put_unaligned_be64(naa3_comp_a, sas_pcd_m_pg + 64);
+	put_unaligned_be64(naa3_comp_c + 1, sas_pcd_m_pg + 72);
 	port_a = target_dev_id + 1;
 	port_b = port_a + 1;
 	memcpy(p, sas_pcd_m_pg, sizeof(sas_pcd_m_pg));
-- 
2.7.4

