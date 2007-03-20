From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] correct SCSI_WAIT_SCAN selection for non-modular
	SCSI_SCAN_ASYNC builds.
Date: Tue, 20 Mar 2007 14:44:04 -0500
Message-ID: <1174419844.3522.44.camel@mulgrave.il.steeleye.com>
References: <20070320185632.GB22866@dmccrory-d810.qlogic.org>
	 <1174417867.3522.35.camel@mulgrave.il.steeleye.com>
	 <20070320191940.GB23330@dmccrory-d810.qlogic.org>
	 <1174419153.3522.41.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49226 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753169AbXCTToN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 15:44:13 -0400
In-Reply-To: <1174419153.3522.41.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2007-03-20 at 14:32 -0500, James Bottomley wrote:
> Is MODULE set to 'n'?  It looks like the symbol export is guarded by
> #ifdef MODULE for some reason ... other than that, I can't explain this.

In fact, that's the bug ... the modular config is MODULES not MODULE.
Can you try this:

James

---
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0949145..a67f315 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -181,10 +181,8 @@ int scsi_complete_async_scans(void)
 	return 0;
 }
 
-#ifdef MODULE
 /* Only exported for the benefit of scsi_wait_scan */
 EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
-#endif
 
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command


