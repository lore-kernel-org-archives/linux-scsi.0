From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 08/12] mptfusion: Task abort is not supported for Volumes
Date: Thu, 18 Mar 2010 19:23:19 +0530
Message-ID: <20100318135310.GI22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:50769 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114Ab0CROYV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:24:21 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

1) corrected return value as SUCCESS instead of 0.
2) Added check in mptscsih_abort.
mptfusion do not support task abort for Volumes.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 585d919..943919a 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1722,6 +1722,7 @@ mptscsih_get_tm_timeout(MPT_ADAPTER *ioc)
 	case FC:
 		return 40;
 	case SAS:
+		return 30;
 	case SPI:
 	default:
 		return 10;
@@ -1771,7 +1772,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		    ioc->name, SCpnt));
 		SCpnt->result = DID_NO_CONNECT << 16;
 		SCpnt->scsi_done(SCpnt);
-		retval = 0;
+		retval = SUCCESS;
 		goto out;
 	}
 
@@ -1786,6 +1787,17 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		goto out;
 	}
 
+	/* Task aborts are not supported for volumes.
+	 */
+	if (vdevice->vtarget->raidVolume) {
+		dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
+		    "task abort: raid volume (sc=%p)\n",
+		    ioc->name, SCpnt));
+		SCpnt->result = DID_RESET << 16;
+		retval = FAILED;
+		goto out;
+	}
+
 	/* Find this command
 	 */
 	if ((scpnt_idx = SCPNT_TO_LOOKUP_IDX(ioc, SCpnt)) < 0) {
