From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 05/12] ipr: Log error for SAS dual path switch
Date: Thu, 29 Mar 2007 12:43:09 -0500
Message-ID: <200703291743.l2THh9Nt003153@d03av01.boulder.ibm.com>
References: <11751901593854-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:36102 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934309AbXC2RnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2007 13:43:20 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2THhJXt020129
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 13:43:19 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2THhAuc024460
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:10 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2THhANS003180
	for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2007 11:43:10 -0600
In-Reply-To: <11751901593854-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


For ipr SAS adapters that support dual pathing, this
patch modifies ipr to log an error when a path fails.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_log_path_switch drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_log_path_switch	2007-03-28 16:53:17.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-03-29 09:06:29.000000000 -0500
@@ -4453,12 +4453,13 @@ static void ipr_dump_ioasa(struct ipr_io
 {
 	int i;
 	u16 data_len;
-	u32 ioasc;
+	u32 ioasc, fd_ioasc;
 	struct ipr_ioasa *ioasa = &ipr_cmd->ioasa;
 	__be32 *ioasa_data = (__be32 *)ioasa;
 	int error_index;
 
 	ioasc = be32_to_cpu(ioasa->ioasc) & IPR_IOASC_IOASC_MASK;
+	fd_ioasc = be32_to_cpu(ioasa->fd_ioasc) & IPR_IOASC_IOASC_MASK;
 
 	if (0 == ioasc)
 		return;
@@ -4466,7 +4467,10 @@ static void ipr_dump_ioasa(struct ipr_io
 	if (ioa_cfg->log_level < IPR_DEFAULT_LOG_LEVEL)
 		return;
 
-	error_index = ipr_get_error(ioasc);
+	if (ioasc == IPR_IOASC_BUS_WAS_RESET && fd_ioasc)
+		error_index = ipr_get_error(fd_ioasc);
+	else
+		error_index = ipr_get_error(ioasc);
 
 	if (ioa_cfg->log_level < IPR_MAX_LOG_LEVEL) {
 		/* Don't log an error if the IOA already logged one */
_
