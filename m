From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mptfusion : mptscsih_abort return value should be SUCCESS instead of value 0.
Date: Mon, 25 Jan 2010 16:20:52 +0530
Message-ID: <20100125105052.GA32336@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:47333 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173Ab0AYLUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jan 2010 06:20:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org


retval should be SUCCESS/FAILED which is defined at scsi.h
retval = 0 is directing wrong return value. It must be retval = SUCCESS.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 8128d30..4a7d1af 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1801,7 +1801,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT "task abort: "
 		   "Command not in the active list! (sc=%p)\n", ioc->name,
 		   SCpnt));
-		retval = 0;
+		retval = SUCCESS;
 		goto out;
 	}
 
