From: brking@us.ibm.com
Subject: [PATCH 04/16] ipr: Sparse warnings fixes
Date: Wed, 04 Aug 2004 17:31:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042233.i74MX4Cu121840@northrelay02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:58617 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267468AbUHDWcH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:32:07 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, mika@osdl.org



From: Mika Kukkonen <mika@osdl.org>
The following patch fixes some sparse warnings.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_fix_sparse_warnings drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_fix_sparse_warnings	2004-08-04 17:17:26.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:26.000000000 -0500
@@ -880,11 +880,13 @@ static void ipr_process_ccn(struct ipr_c
  **/
 static void ipr_log_vpd(struct ipr_std_inq_vpids *vpids, u8 *serial_num)
 {
-	char buffer[max_t(int, sizeof(struct ipr_std_inq_vpids),
-			  IPR_SERIAL_NUM_LEN) + 1];
+	char buffer[IPR_VENDOR_ID_LEN + IPR_PROD_ID_LEN
+		    + IPR_SERIAL_NUM_LEN];
 
-	memcpy(buffer, vpids, sizeof(struct ipr_std_inq_vpids));
-	buffer[sizeof(struct ipr_std_inq_vpids)] = '\0';
+	memcpy(buffer, vpids->vendor_id, IPR_VENDOR_ID_LEN);
+	memcpy(buffer + IPR_VENDOR_ID_LEN, vpids->product_id,
+	       IPR_PROD_ID_LEN);
+	buffer[IPR_VENDOR_ID_LEN + IPR_PROD_ID_LEN] = '\0';
 	ipr_err("Vendor/Product ID: %s\n", buffer);
 
 	memcpy(buffer, serial_num, IPR_SERIAL_NUM_LEN);
_
