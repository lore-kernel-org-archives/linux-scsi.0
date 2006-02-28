From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Tue, 28 Feb 2006 21:14:31 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:9916 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932426AbWB1TL1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 14:11:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

This patch enables clustering and sets max_sectors to 0xffff to enable 
reading and writing of large blocks with tapes (and large transfers with 
sg). This change is needed after the sg and st drivers started using 
chained bios through scsi_request_async() in 2.6.16.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>

--- linux-2.6.16-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-04 13:25:48.000000000 +0200
+++ linux-2.6.16-rc5-k1/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-18 09:45:24.000000000 +0200
@@ -1978,7 +1978,8 @@ static struct scsi_host_template sym2_te
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
-	.use_clustering		= DISABLE_CLUSTERING,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.max_sectors		= 0xFFFF,
 #ifdef SYM_LINUX_PROC_INFO_SUPPORT
 	.proc_info		= sym53c8xx_proc_info,
 	.proc_name		= NAME53C8XX,
