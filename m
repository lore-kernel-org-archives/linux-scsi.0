From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/3] ipr only tcq cancel all
Date: Fri, 18 Jun 2004 16:17:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40D35BF0.1070306@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060109010902050905040609"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:52676 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264513AbUFRVRp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jun 2004 17:17:45 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060109010902050905040609
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------060109010902050905040609
Content-Type: text/plain;
 name="ipr_only_tcq_cancel_all.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_only_tcq_cancel_all.patch"


Some SCSI-IDE cdrom drives take up to 15 seconds to respond following
an abort being issued to them. This patch changes ipr to only send
a cancel all to a device as part of request sense processing when
the device is running tagged command queueing.


---

 linux-2.6.7-rc2-bjking1/drivers/scsi/ipr.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_only_tcq_cancel_all drivers/scsi/ipr.c
--- linux-2.6.7-rc2/drivers/scsi/ipr.c~ipr_only_tcq_cancel_all	2004-06-07 17:11:05.000000000 -0500
+++ linux-2.6.7-rc2-bjking1/drivers/scsi/ipr.c	2004-06-07 17:11:05.000000000 -0500
@@ -3535,6 +3535,11 @@ static void ipr_erp_cancel_all(struct ip
 
 	ipr_reinit_ipr_cmnd_for_erp(ipr_cmd);
 
+	if (!res->tcq_active) {
+		ipr_erp_request_sense(ipr_cmd);
+		return;
+	}
+
 	cmd_pkt = &ipr_cmd->ioarcb.cmd_pkt;
 	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
 	cmd_pkt->cdb[0] = IPR_CANCEL_ALL_REQUESTS;

_

--------------060109010902050905040609--

