From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/3] ipr scsi busy io hang
Date: Mon, 24 May 2004 09:39:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B20917.1060709@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010305010102030202010004"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:20096 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263663AbUEXOjV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2004 10:39:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010305010102030202010004
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James,

Here are a couple more ipr bug fixes. Please apply.

Thanks

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------010305010102030202010004
Content-Type: text/plain;
 name="ipr_scsi_busy_io_hang.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_scsi_busy_io_hang.patch"


This patch fixes a hang in io that can occur when a device returns
scsi status other than a check condition.


---

 linux-2.6.6-bjking1/drivers/scsi/ipr.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~ipr_scsi_busy_io_hang drivers/scsi/ipr.c
--- linux-2.6.6/drivers/scsi/ipr.c~ipr_scsi_busy_io_hang	2004-05-23 21:35:28.000000000 -0500
+++ linux-2.6.6-bjking1/drivers/scsi/ipr.c	2004-05-23 21:40:15.000000000 -0500
@@ -2884,6 +2884,7 @@ static int ipr_slave_alloc(struct scsi_d
 		    (res->cfgte.res_addr.lun == sdev->lun)) {
 			res->sdev = sdev;
 			res->add_to_ml = 0;
+			res->in_erp = 0;
 			sdev->hostdata = res;
 			res->needs_sync_complete = 1;
 			break;
@@ -3435,8 +3436,10 @@ static void ipr_erp_done(struct ipr_cmnd
 		       SCSI_SENSE_BUFFERSIZE);
 	}
 
-	if (res)
+	if (res) {
 		res->needs_sync_complete = 1;
+		res->in_erp = 0;
+	}
 	ipr_unmap_sglist(ioa_cfg, ipr_cmd);
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
 	scsi_cmd->scsi_done(scsi_cmd);
@@ -3756,6 +3759,7 @@ static void ipr_erp_start(struct ipr_ioa
 			ipr_erp_cancel_all(ipr_cmd);
 			return;
 		}
+		res->needs_sync_complete = 1;
 		break;
 	case IPR_IOASC_NR_INIT_CMD_REQUIRED:
 		break;

_

--------------010305010102030202010004--

