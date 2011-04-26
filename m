From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 01/03] mptfusion: Remove debug print from mptscsih_qcmd()
Date: Tue, 26 Apr 2011 12:09:15 +0530
Message-ID: <20110426063911.GC6066@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:45988 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077Ab1DZGTk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2011 02:19:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Remove debug print from mptscsih_qcmd function call.
This debug print cause flood of prints and difficult to debug other issues.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0d9b82a..2d8a483 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1415,11 +1415,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p, done()=%p\n",
 		ioc->name, SCpnt, done));
 
-	if (ioc->taskmgmt_quiesce_io) {
-		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT "qcmd: SCpnt=%p timeout + 60HZ\n",
-			ioc->name, SCpnt));
+	if (ioc->taskmgmt_quiesce_io)
 		return SCSI_MLQUEUE_HOST_BUSY;
-	}
 
 	/*
 	 *  Put together a MPT SCSI request...
