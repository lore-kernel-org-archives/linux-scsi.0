From: "Steven J. Magnani" <steve.magnani@digidescorp.com>
Subject: [PATCH] qla2xxx: eliminate dead code in qla24xx_process_bidir_cmd
Date: Thu, 30 Jan 2014 08:17:55 -0600
Message-ID: <1391091475-15629-1-git-send-email-steve@digidescorp.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:57973 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaA3OSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jan 2014 09:18:06 -0500
Received: by mail-ig0-f181.google.com with SMTP id j1so7238833iga.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2014 06:18:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Steven J. Magnani" <steve@digidescorp.com>

Coverity reports that the test of req_data_len vs. rsp_data_len is dead code.
This appears to be because the test occurs before any real assignment to
either variable.

Assuming that the sole in-tree execution path (QL_VND_DIAG_IO_CMD submitted
via FC pass-through on a host /dev/bsg/X) does not require the response to
have the same length as the request, all code related to the faulty test
can be removed. If this is not the case, the test should be moved much earlier
in the function since it does not depend on any resource acquitision.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
--- linux-3.13/drivers/scsi/qla2xxx/qla_bsg.c	2014-01-29 13:50:02.050802907 -0600
+++ b/drivers/scsi/qla2xxx/qla_bsg.c	2014-01-29 13:53:15.856549874 -0600
@@ -1732,8 +1732,6 @@ qla24xx_process_bidir_cmd(struct fc_bsg_
 	uint16_t nextlid = 0;
 	uint32_t tot_dsds;
 	srb_t *sp = NULL;
-	uint32_t req_data_len = 0;
-	uint32_t rsp_data_len = 0;
 
 	/* Check the type of the adapter */
 	if (!IS_BIDI_CAPABLE(ha)) {
@@ -1840,17 +1838,6 @@ qla24xx_process_bidir_cmd(struct fc_bsg_
 		goto done_unmap_sg;
 	}
 
-	if (req_data_len != rsp_data_len) {
-		rval = EXT_STATUS_BUSY;
-		ql_log(ql_log_warn, vha, 0x70aa,
-		    "req_data_len != rsp_data_len\n");
-		goto done_unmap_sg;
-	}
-
-	req_data_len = bsg_job->request_payload.payload_len;
-	rsp_data_len = bsg_job->reply_payload.payload_len;
-
-
 	/* Alloc SRB structure */
 	sp = qla2x00_get_sp(vha, &(vha->bidir_fcport), GFP_KERNEL);
 	if (!sp) {
--- linux-3.13/drivers/scsi/qla2xxx/qla_dbg.c	2014-01-29 13:50:49.435230824 -0600
+++ b/drivers/scsi/qla2xxx/qla_dbg.c	2014-01-29 13:53:43.960820829 -0600
@@ -38,7 +38,8 @@
  * |                              |                    | 0x7073-0x7075, |
  * |                              |                    | 0x707b,0x708c, |
  * |                              |                    | 0x70a5,0x70a6, |
- * |                              |                    | 0x70a8,0x70ab, |
+ * |                              |                    | 0x70a8,        |
+ * |                              |                    | 0x70aa-0x70ab, |
  * |                              |                    | 0x70ad-0x70ae, |
  * |                              |                    | 0x70d1-0x70db, |
  * |                              |                    | 0x7047,0x703b	|
