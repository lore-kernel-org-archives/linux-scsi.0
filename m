From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ipr: Inhibit underlength data check for AFDASD in raw mode.
Date: Wed, 19 Aug 2015 11:47:05 -0300
Message-ID: <1439995626-16202-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:33410 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbbHSOra (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2015 10:47:30 -0400
Received: from /spool/local
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Wed, 19 Aug 2015 11:47:25 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id E8EEE3520078
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2015 10:46:16 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7JElkxD4345962
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2015 11:47:47 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7JElLOh021274
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2015 11:47:21 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Disable underlength error verification based on count of bytes actually
transferred for AF DASD devices when SIS pipe mode is enabled.

This avoids unexpected underlength errors when issuing some commands in
raw mode.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index a9aa389..db0c2cf 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6382,9 +6382,13 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	    (!ipr_is_gscsi(res) || scsi_cmd->cmnd[0] == IPR_QUERY_RSRC_STATE)) {
 		ioarcb->cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
 	}
-	if (res->raw_mode && ipr_is_af_dasd_device(res))
+	if (res->raw_mode && ipr_is_af_dasd_device(res)) {
 		ioarcb->cmd_pkt.request_type = IPR_RQTYPE_PIPE;
 
+		if (scsi_cmd->underflow == 0)
+			ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
+	}
+
 	if (ioa_cfg->sis64)
 		rc = ipr_build_ioadl64(ioa_cfg, ipr_cmd);
 	else
-- 
2.1.0

