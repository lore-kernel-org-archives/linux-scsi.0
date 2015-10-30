From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH 2/5] ipr: Clear NO_ULEN_CHK bit when resource is a vset.
Date: Fri, 30 Oct 2015 14:49:06 -0200
Message-ID: <1446223749-17416-2-git-send-email-krisman@linux.vnet.ibm.com>
References: <1446223749-17416-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:53564 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbbJ3Qtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 12:49:33 -0400
Received: from /spool/local
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Fri, 30 Oct 2015 14:49:30 -0200
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id B74BE352007C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 12:48:16 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
	by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9UGlbTi15598070
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 14:47:38 -0200
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
	by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9UGnPjp000838
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 14:49:25 -0200
In-Reply-To: <1446223749-17416-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

According to the IPR specification, Inhibit Underlength Checking bit
must be disabled when sending commands to vsets.  Enabling this bit for
vset might cause SCSI commands to fail with an Illegal Request.

Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 4034cd3..da957b3 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6364,7 +6364,7 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	ipr_cmd->done = ipr_scsi_eh_done;
 
 	if (ipr_is_gscsi(res) || ipr_is_vset_device(res)) {
-		if (scsi_cmd->underflow == 0)
+		if (scsi_cmd->underflow == 0 && !ipr_is_vset_device(res))
 			ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
 
 		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
-- 
2.1.0

