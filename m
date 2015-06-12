From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/4] ipr: Endian / sparse fixes
Date: Thu, 11 Jun 2015 20:45:20 -0500
Message-ID: <201506120145.t5C1jK1N019458@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35128 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbFLBpZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2015 21:45:25 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 11 Jun 2015 19:45:24 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 711EE3E40030
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 19:45:22 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5C1h40W34799796
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 18:43:04 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5C1jLGB019578
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 19:45:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, gbertazi@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Some misc fixes for endianness checking with sparse so sparse with
endian checking now runs clean. Fixes a minor bug in the process
which was uncovered by sparse which would result in unnecessary
error recovery for check conditions.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   13 +++++++------
 drivers/scsi/ipr.h |   13 ++++++-------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_endian_fixes drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_endian_fixes	2015-06-11 20:18:29.102541573 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2015-06-11 20:18:29.112541485 -0500
@@ -1007,13 +1007,13 @@ struct ipr_hostrcb_type_24_error {
 struct ipr_hostrcb_type_07_error {
 	u8 failure_reason[64];
 	struct ipr_vpd vpd;
-	u32 data[222];
+	__be32 data[222];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_type_17_error {
 	u8 failure_reason[64];
 	struct ipr_ext_vpd vpd;
-	u32 data[476];
+	__be32 data[476];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_config_element {
@@ -1291,18 +1291,17 @@ struct ipr_resource_entry {
 	(((res)->bus << 24) | ((res)->target << 8) | (res)->lun)
 
 	u8 ata_class;
-
-	u8 flags;
-	__be16 res_flags;
-
 	u8 type;
 
+	u16 flags;
+	u16 res_flags;
+
 	u8 qmodel;
 	struct ipr_std_inq_data std_inq_data;
 
 	__be32 res_handle;
 	__be64 dev_id;
-	__be64 lun_wwn;
+	u64 lun_wwn;
 	struct scsi_lun dev_lun;
 	u8 res_path[8];
 
diff -puN drivers/scsi/ipr.c~ipr_endian_fixes drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_endian_fixes	2015-06-11 20:18:29.107541529 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-06-11 20:18:29.121541408 -0500
@@ -1159,7 +1159,8 @@ static void ipr_init_res_entry(struct ip
 
 	if (ioa_cfg->sis64) {
 		proto = cfgtew->u.cfgte64->proto;
-		res->res_flags = cfgtew->u.cfgte64->res_flags;
+		res->flags = be16_to_cpu(cfgtew->u.cfgte64->flags);
+		res->res_flags = be16_to_cpu(cfgtew->u.cfgte64->res_flags);
 		res->qmodel = IPR_QUEUEING_MODEL64(res);
 		res->type = cfgtew->u.cfgte64->res_type;
 
@@ -1307,8 +1308,8 @@ static void ipr_update_res_entry(struct 
 	int new_path = 0;
 
 	if (res->ioa_cfg->sis64) {
-		res->flags = cfgtew->u.cfgte64->flags;
-		res->res_flags = cfgtew->u.cfgte64->res_flags;
+		res->flags = be16_to_cpu(cfgtew->u.cfgte64->flags);
+		res->res_flags = be16_to_cpu(cfgtew->u.cfgte64->res_flags);
 		res->type = cfgtew->u.cfgte64->res_type;
 
 		memcpy(&res->std_inq_data, &cfgtew->u.cfgte64->std_inq_data,
@@ -1894,7 +1895,7 @@ static void ipr_log_array_error(struct i
  * Return value:
  * 	none
  **/
-static void ipr_log_hex_data(struct ipr_ioa_cfg *ioa_cfg, u32 *data, int len)
+static void ipr_log_hex_data(struct ipr_ioa_cfg *ioa_cfg, __be32 *data, int len)
 {
 	int i;
 
@@ -2264,7 +2265,7 @@ static void ipr_log_fabric_error(struct 
 			((unsigned long)fabric + be16_to_cpu(fabric->length));
 	}
 
-	ipr_log_hex_data(ioa_cfg, (u32 *)fabric, add_len);
+	ipr_log_hex_data(ioa_cfg, (__be32 *)fabric, add_len);
 }
 
 /**
@@ -2358,7 +2359,7 @@ static void ipr_log_sis64_fabric_error(s
 			((unsigned long)fabric + be16_to_cpu(fabric->length));
 	}
 
-	ipr_log_hex_data(ioa_cfg, (u32 *)fabric, add_len);
+	ipr_log_hex_data(ioa_cfg, (__be32 *)fabric, add_len);
 }
 
 /**
_

