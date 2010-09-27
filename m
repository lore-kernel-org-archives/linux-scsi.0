From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: fix array error logging
Date: Mon, 27 Sep 2010 10:05:40 -0700
Message-ID: <4CA0CEE4.1050104@linux.vnet.ibm.com>
References: <20100927165904.645771561@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57762 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758990Ab0I0RFy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 13:05:54 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o8RGof8L027771
	for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2010 12:50:41 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8RH5h3q1482838
	for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2010 13:05:43 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o8RH5g2E007512
	for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2010 13:05:43 -0400
In-Reply-To: <20100927165904.645771561@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

The structure definitions for reporting array errors did not have the correct
size for the Array WWID field.  This patch fixes those definitions.  It also
fixes part of the output formatting that did not have newlines and fixes size
calculations.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   10 +++++-----
 drivers/scsi/ipr.h |    9 +++++++--
 2 files changed, 12 insertions(+), 7 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-09-23 09:33:27.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-09-27 08:44:11.000000000 -0700
@@ -1671,7 +1671,7 @@ static void ipr_log_enhanced_array_error

 	array_entry = error->array_member;
 	num_entries = min_t(u32, be32_to_cpu(error->num_entries),
-			    sizeof(error->array_member));
+			    ARRAY_SIZE(error->array_member));

 	for (i = 0; i < num_entries; i++, array_entry++) {
 		if (!memcmp(array_entry->vpd.vpd.sn, zero_sn, IPR_SERIAL_NUM_LEN))
@@ -2152,8 +2152,8 @@ static void ipr_log_sis64_array_error(st
 	ipr_err_separator;

 	array_entry = error->array_member;
-	num_entries = min_t(u32, be32_to_cpu(error->num_entries),
-			    sizeof(error->array_member));
+	num_entries = min_t(u32, error->num_entries,
+		       	    ARRAY_SIZE(error->array_member);

 	for (i = 0; i < num_entries; i++, array_entry++) {

@@ -2167,10 +2167,10 @@ static void ipr_log_sis64_array_error(st

 		ipr_err("Array Member %d:\n", i);
 		ipr_log_ext_vpd(&array_entry->vpd);
-		ipr_err("Current Location: %s",
+		ipr_err("Current Location: %s\n",
 			 ipr_format_res_path(array_entry->res_path, buffer,
 					     sizeof(buffer)));
-		ipr_err("Expected Location: %s",
+		ipr_err("Expected Location: %s\n",
 			 ipr_format_res_path(array_entry->expected_res_path,
 					     buffer, sizeof(buffer)));

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-09-23 09:33:29.000000000 -0700
+++ b/drivers/scsi/ipr.h	2010-09-23 12:03:59.000000000 -0700
@@ -319,6 +319,11 @@ struct ipr_ext_vpd {
 	__be32 wwid[2];
 }__attribute__((packed));

+struct ipr_ext_vpd64 {
+	struct ipr_vpd vpd;
+	__be32 wwid[4];
+}__attribute__((packed));
+
 struct ipr_std_inq_data {
 	u8 peri_qual_dev_type;
 #define IPR_STD_INQ_PERI_QUAL(peri) ((peri) >> 5)
@@ -395,7 +400,7 @@ struct ipr_config_table_entry64 {
 	__be64 res_path;
 	struct ipr_std_inq_data std_inq_data;
 	u8 reserved2[4];
-	__be64 reserved3[2]; // description text
+	__be64 reserved3[2];
 	u8 reserved4[8];
 }__attribute__ ((packed, aligned (8)));

@@ -914,7 +919,7 @@ struct ipr_hostrcb_type_24_error {
 	u8 array_id;
 	u8 last_res_path[8];
 	u8 protection_level[8];
-	struct ipr_ext_vpd array_vpd;
+	struct ipr_ext_vpd64 array_vpd;
 	u8 description[16];
 	u8 reserved2[3];
 	u8 num_entries;

