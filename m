From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/3] ipr duplicate ioa reset fix
Date: Mon, 24 May 2004 09:39:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B2091C.70107@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080802070209030201000901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:37080 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263923AbUEXOjh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2004 10:39:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080802070209030201000901
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------080802070209030201000901
Content-Type: text/plain;
 name="ipr_duplicate_ioa_reset_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_duplicate_ioa_reset_fix.patch"


This patch closes a window where if a device had a cancel all
outstanding as a result of a check condition and the adapter
was reset for some reason, a request sense would still be issued,
which would end up timing out and issuing an additional adapter
reset. It could also result in a leak of command blocks, depending
on when it timed out.


---

 linux-2.6.6-bjking1/drivers/scsi/ipr.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_duplicate_ioa_reset_fix drivers/scsi/ipr.c
--- linux-2.6.6/drivers/scsi/ipr.c~ipr_duplicate_ioa_reset_fix	2004-05-23 21:43:35.000000000 -0500
+++ linux-2.6.6-bjking1/drivers/scsi/ipr.c	2004-05-23 21:43:47.000000000 -0500
@@ -3482,6 +3482,12 @@ static void ipr_reinit_ipr_cmnd_for_erp(
 static void ipr_erp_request_sense(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_cmd_pkt *cmd_pkt = &ipr_cmd->ioarcb.cmd_pkt;
+	u32 ioasc = be32_to_cpu(ipr_cmd->ioasa.ioasc);
+
+	if (IPR_IOASC_SENSE_KEY(ioasc) > 0) {
+		ipr_erp_done(ipr_cmd);
+		return;
+	}
 
 	ipr_reinit_ipr_cmnd_for_erp(ipr_cmd);
 

_

--------------080802070209030201000901--

