From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH as495] Retries in scsi_eh_tur
Date: Wed, 30 Mar 2005 15:05:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0503301449490.1441-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:19204 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262403AbVC3UFs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 15:05:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

I don't know if this patch is appropriate or not.  The problem lies in the 
way the error handler uses TEST UNIT READY to tell whether error recovery 
has succeeded.  The scsi_eh_tur function gives up after one round of 
retrying; after that it decides that more error recovery is needed.

However TUR is liable to report sense data indicating a retry is needed
when in fact error recovery has succeeded.  A typical example might be
SK=2, ASC=4, ASCQ=1 (Logical unit in process of becoming ready).  The mere
fact that we were able to get a sensible reply to the TUR should indicate
that the device is working well enough to stop error recovery.

I ran across a case back in January where this happened.  A CD-ROM drive
timed out the INQUIRY command, and a device reset fixed the blockage.  
But then the drive kept responding with 2/4/1 -- because it was spinning
up I suppose -- until the error handler gave up and placed it offline.  
If the initial INQUIRY had received the 2/4/1 instead, everything would
have worked okay.  It doesn't seem reasonable for things to fail just
because the error handler had started running.

So, what do you think of this patch?  After the single retry has been 
exhausted, it makes scsi_eh_tur return success if a NEEDS_RETRY response 
is received.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== drivers/scsi/scsi_error.c 1.48 vs edited =====
--- 1.48/drivers/scsi/scsi_error.c	2005-03-22 01:44:55 -05:00
+++ edited/drivers/scsi/scsi_error.c	2005-03-30 14:48:23 -05:00
@@ -810,9 +810,11 @@
 		__FUNCTION__, scmd, rtn));
 	if (rtn == SUCCESS)
 		return 0;
-	else if (rtn == NEEDS_RETRY)
+	else if (rtn == NEEDS_RETRY) {
 		if (retry_cnt--)
 			goto retry_tur;
+		return 0;
+	}
 	return 1;
 }
 

