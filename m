From: brking@us.ibm.com
Subject: [PATCH 13/15] ipr: Sparse fixes
Date: Mon, 21 Feb 2005 15:09:48 -0600
Message-ID: <200502212109.j1LL9nH6002927@d03av03.boulder.ibm.com>
Received: from e32.co.us.ibm.com ([32.97.110.130]:34701 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262133AbVBUVJv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 16:09:51 -0500
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.195.12])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j1LL9o5j508012
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 16:09:50 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay03.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1LL9oUK137360
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:50 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j1LL9nAT002966
	for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2005 14:09:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Various fixes to make sparse happy

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c |   30 +++++++++++-------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_sparse_fixes drivers/scsi/ipr.c
--- linux-2.6.11-rc4-bk9/drivers/scsi/ipr.c~ipr_sparse_fixes	2005-02-21 13:16:36.000000000 -0600
+++ linux-2.6.11-rc4-bk9-bjking1/drivers/scsi/ipr.c	2005-02-21 13:16:36.000000000 -0600
@@ -1013,9 +1013,7 @@ static void ipr_log_array_error(struct i
 	int i;
 	struct ipr_hostrcb_type_04_error *error;
 	struct ipr_hostrcb_array_data_entry *array_entry;
-	u8 zero_sn[IPR_SERIAL_NUM_LEN];
-
-	memset(zero_sn, '0', IPR_SERIAL_NUM_LEN);
+	const u8 zero_sn[IPR_SERIAL_NUM_LEN] = { [0 ... IPR_SERIAL_NUM_LEN-1] = '0' };
 
 	error = &hostrcb->hcam.u.error.u.type_04_error;
 
@@ -1036,7 +1034,7 @@ static void ipr_log_array_error(struct i
 		if (!memcmp(array_entry->serial_num, zero_sn, IPR_SERIAL_NUM_LEN))
 			continue;
 
-		if (error->exposed_mode_adn == i) {
+		if (be32_to_cpu(error->exposed_mode_adn) == i) {
 			ipr_err("Exposed Array Member %d:\n", i);
 		} else {
 			ipr_err("Array Member %d:\n", i);
@@ -1437,7 +1435,7 @@ static int ipr_wait_iodbg_ack(struct ipr
  **/
 static int ipr_get_ldump_data_section(struct ipr_ioa_cfg *ioa_cfg,
 				      u32 start_addr,
-				      u32 *dest, u32 length_in_words)
+				      __be32 *dest, u32 length_in_words)
 {
 	volatile u32 temp_pcii_reg;
 	int i, delay = 0;
@@ -1529,7 +1527,7 @@ static int ipr_sdt_copy(struct ipr_ioa_c
 {
 	int bytes_copied = 0;
 	int cur_len, rc, rem_len, rem_page_len;
-	u32 *page;
+	__be32 *page;
 	unsigned long lock_flags = 0;
 	struct ipr_ioa_dump *ioa_dump = &ioa_cfg->dump->ioa_dump;
 
@@ -1537,7 +1535,7 @@ static int ipr_sdt_copy(struct ipr_ioa_c
 	       (ioa_dump->hdr.len + bytes_copied) < IPR_MAX_IOA_DUMP_SIZE) {
 		if (ioa_dump->page_offset >= PAGE_SIZE ||
 		    ioa_dump->page_offset == 0) {
-			page = (u32 *)__get_free_page(GFP_ATOMIC);
+			page = (__be32 *)__get_free_page(GFP_ATOMIC);
 
 			if (!page) {
 				ipr_trace;
@@ -1752,8 +1750,8 @@ static void ipr_get_ioa_dump(struct ipr_
 	 on entries in this table */
 	sdt = &ioa_dump->sdt;
 
-	rc = ipr_get_ldump_data_section(ioa_cfg, start_addr, (u32 *)sdt,
-					sizeof(struct ipr_sdt) / sizeof(u32));
+	rc = ipr_get_ldump_data_section(ioa_cfg, start_addr, (__be32 *)sdt,
+					sizeof(struct ipr_sdt) / sizeof(__be32));
 
 	/* Smart Dump table is ready to use and the first entry is valid */
 	if (rc || (be32_to_cpu(sdt->hdr.state) != IPR_FMT2_SDT_READY_TO_USE)) {
@@ -3542,7 +3540,7 @@ static void ipr_dump_ioasa(struct ipr_io
 	u16 data_len;
 	u32 ioasc;
 	struct ipr_ioasa *ioasa = &ipr_cmd->ioasa;
-	u32 *ioasa_data = (u32 *)ioasa;
+	__be32 *ioasa_data = (__be32 *)ioasa;
 	int error_index;
 
 	ioasc = be32_to_cpu(ioasa->ioasc) & IPR_IOASC_IOASC_MASK;
@@ -4314,7 +4312,7 @@ static void ipr_modify_ioafp_mode_page_2
  * 	none
  **/
 static void ipr_build_mode_select(struct ipr_cmnd *ipr_cmd,
-				  u32 res_handle, u8 parm, u32 dma_addr,
+				  __be32 res_handle, u8 parm, u32 dma_addr,
 				  u8 xfer_len)
 {
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
@@ -4389,7 +4387,7 @@ static int ipr_ioafp_mode_select_page28(
  * 	none
  **/
 static void ipr_build_mode_sense(struct ipr_cmnd *ipr_cmd,
-				 u32 res_handle,
+				 __be32 res_handle,
 				 u8 parm, u32 dma_addr, u8 xfer_len)
 {
 	struct ipr_ioadl_desc *ioadl = ipr_cmd->ioadl;
@@ -4874,8 +4872,8 @@ static void ipr_get_unit_check_buffer(st
 	}
 
 	memset(&sdt, 0, sizeof(struct ipr_uc_sdt));
-	rc = ipr_get_ldump_data_section(ioa_cfg, mailbox, (u32 *) &sdt,
-					(sizeof(struct ipr_uc_sdt)) / sizeof(u32));
+	rc = ipr_get_ldump_data_section(ioa_cfg, mailbox, (__be32 *) &sdt,
+					(sizeof(struct ipr_uc_sdt)) / sizeof(__be32));
 
 	if (rc || (be32_to_cpu(sdt.hdr.state) != IPR_FMT2_SDT_READY_TO_USE) ||
 	    !(sdt.entry[0].flags & IPR_SDT_VALID_ENTRY)) {
@@ -4894,8 +4892,8 @@ static void ipr_get_unit_check_buffer(st
 
 	rc = ipr_get_ldump_data_section(ioa_cfg,
 					be32_to_cpu(sdt.entry[0].bar_str_offset),
-					(u32 *)&hostrcb->hcam,
-					min(length, (int)sizeof(hostrcb->hcam)) / sizeof(u32));
+					(__be32 *)&hostrcb->hcam,
+					min(length, (int)sizeof(hostrcb->hcam)) / sizeof(__be32));
 
 	if (!rc)
 		ipr_handle_log_data(ioa_cfg, hostrcb);
_
