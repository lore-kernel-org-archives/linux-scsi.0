From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 05/06] mptfusion: Fix Incorrect return value in mptscsih_dev_reset
Date: Thu, 3 Feb 2011 15:34:40 +0530
Message-ID: <20110203100429.GF23502@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58429 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929Ab1BCKu7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2011 05:50:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org, peter.petrakis@canonical.com


There's a branch at the end of this function that
is supposed to normalize the return value with what
the mid-layer expects. In this one case, we get it wrong.

Also increase the verbosity of the INFO level printk
at the end of mptscsih_abort to include the actual return value
and the scmd->serial_number. The reason being success
or failure is actually determined by the state of
the internal tag list when a TMF is issued, and not the
return value of the TMF cmd. The serial_number is also
used in this decision, thus it's useful to know for debugging
purposes.

Signed-off-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Acked-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index b1496b3..7a4c479 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1873,8 +1873,9 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	}
 
  out:
-	printk(MYIOC_s_INFO_FMT "task abort: %s (sc=%p)\n",
-	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), SCpnt);
+	printk(MYIOC_s_INFO_FMT "task abort: %s (rv=%04x) (sc=%p) (sn=%ld)\n",
+	    ioc->name, ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), retval,
+	    SCpnt, SCpnt->serial_number);
 
 	return retval;
 }
@@ -1911,7 +1912,7 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 
 	vdevice = SCpnt->device->hostdata;
 	if (!vdevice || !vdevice->vtarget) {
-		retval = SUCCESS;
+		retval = 0;
 		goto out;
 	}
 
