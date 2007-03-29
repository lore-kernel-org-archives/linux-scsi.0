From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 10/12] ipr: Return better qc_issue errors
Date: Thu, 29 Mar 2007 12:43:43 -0500
Message-ID: <200703291743.l2THhhLn021901@d03av04.boulder.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:37726 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934307AbXC2Rnp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 13:43:45 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THhjhv021159
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:45 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THhjLm124852
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:45 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THhiDa021969
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:45 -0600
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


If qc_issue fails for some reason, return a better error
to libata.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_sata_qc_issue_error drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sata_qc_issue_error	2007-03-29 09:20:29.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-29 09:20:29.000000000 -0500
@@ -5128,7 +5128,7 @@ static unsigned int ipr_qc_issue(struct 
 	struct ipr_ioarcb_ata_regs *regs;
 
 	if (unlikely(!ioa_cfg->allow_cmds || ioa_cfg->ioa_is_dead))
-		return -EIO;
+		return AC_ERR_SYSTEM;
 
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioarcb = &ipr_cmd->ioarcb;
@@ -5173,7 +5173,7 @@ static unsigned int ipr_qc_issue(struct 
 
 	default:
 		WARN_ON(1);
-		return -1;
+		return AC_ERR_INVALID;
 	}
 
 	mb();
_
