From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/3] zfcp: Use correct length for FCP_RSP_INFO
Date: Tue, 05 Oct 2010 17:12:55 +0200
Message-ID: <20101005151359.222149946@de.ibm.com>
References: <20101005151252.217141720@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:57624 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0JEPOL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2010 11:14:11 -0400
Content-Disposition: inline; filename=715-zfcp-rsp-info-len.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Use the FCP_RSP_INFO length to correctly skip the FCP_RSP_INFO field.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.h linux-2.6-patched/drivers/s390/scsi/zfcp_fc.h
--- linux-2.6/drivers/s390/scsi/zfcp_fc.h	2010-10-05 15:57:41.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.h	2010-10-05 15:58:22.000000000 +0200
@@ -270,7 +270,7 @@ void zfcp_fc_eval_fcp_rsp(struct fcp_res
 	if (unlikely(rsp_flags & FCP_SNS_LEN_VAL)) {
 		sense = (char *) &fcp_rsp[1];
 		if (rsp_flags & FCP_RSP_LEN_VAL)
-			sense += fcp_rsp->ext.fr_sns_len;
+			sense += fcp_rsp->ext.fr_rsp_len;
 		sense_len = min(fcp_rsp->ext.fr_sns_len,
 				(u32) SCSI_SENSE_BUFFERSIZE);
 		memcpy(scsi->sense_buffer, sense, sense_len);

