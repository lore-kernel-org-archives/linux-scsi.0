From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/8] lpfc 8.3.8: (BSG2) Create lpfc_bsg.h
Date: Tue, 26 Jan 2010 23:09:22 -0500
Message-ID: <1264565382.2972.5.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:39262 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112Ab0A0EKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 23:10:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Create lpfc_bsg.h 
  - structures, etc used by bsg-related routines.

 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.h |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
--- a/drivers/scsi/lpfc/lpfc_bsg.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.h	2010-01-26 22:43:20.000000000 -0500
@@ -0,0 +1,98 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2010 Emulex.  All rights reserved.                *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *******************************************************************/
+/* bsg definitions
+ * No pointers to user data are allowed, all application buffers and sizes will
+ * derived through the bsg interface.
+ *
+ * These are the vendor unique structures passed in using the bsg
+ * FC_BSG_HST_VENDOR message code type.
+ */
+#define LPFC_BSG_VENDOR_SET_CT_EVENT	1
+#define LPFC_BSG_VENDOR_GET_CT_EVENT	2
+#define LPFC_BSG_VENDOR_SEND_MGMT_RESP	3
+#define LPFC_BSG_VENDOR_DIAG_MODE	4
+#define LPFC_BSG_VENDOR_DIAG_TEST	5
+#define LPFC_BSG_VENDOR_GET_MGMT_REV	6
+#define LPFC_BSG_VENDOR_MBOX		7
+
+struct set_ct_event {
+	uint32_t command;
+	uint32_t type_mask;
+	uint32_t ev_req_id;
+	uint32_t ev_reg_id;
+};
+
+struct get_ct_event {
+	uint32_t command;
+	uint32_t ev_reg_id;
+	uint32_t ev_req_id;
+};
+
+struct get_ct_event_reply {
+	uint32_t immed_data;
+	uint32_t type;
+};
+
+struct send_mgmt_resp {
+	uint32_t command;
+	uint32_t tag;
+};
+
+
+#define INTERNAL_LOOP_BACK 0x1 /* adapter short cuts the loop internally */
+#define EXTERNAL_LOOP_BACK 0x2 /* requires an external loopback plug */
+
+struct diag_mode_set {
+	uint32_t command;
+	uint32_t type;
+	uint32_t timeout;
+};
+
+struct diag_mode_test {
+	uint32_t command;
+};
+
+#define LPFC_WWNN_TYPE		0
+#define LPFC_WWPN_TYPE		1
+
+struct get_mgmt_rev {
+	uint32_t command;
+};
+
+#define MANAGEMENT_MAJOR_REV   1
+#define MANAGEMENT_MINOR_REV   0
+
+/* the MgmtRevInfo structure */
+struct MgmtRevInfo {
+	uint32_t a_Major;
+	uint32_t a_Minor;
+};
+
+struct get_mgmt_rev_reply {
+	struct MgmtRevInfo info;
+};
+
+struct dfc_mbox_req {
+	uint32_t command;
+	uint32_t inExtWLen;
+	uint32_t outExtWLen;
+	uint8_t mbOffset;
+};
+


