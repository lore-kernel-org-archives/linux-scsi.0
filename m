From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] 2.6+2.4 dpt_i2o driver timing out during tape erase operations
Date: Tue, 17 May 2005 16:00:29 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B0132AAF0@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:2998 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261724AbVEQUA3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 16:00:29 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j4HK0Sc32028
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2005 13:00:28 -0700
Received: from otce2k01.adaptec.com (otce2k01.adaptec.com [10.12.1.83])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j4HK0Sg03969
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2005 13:00:28 -0700
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Tape operation (erase) timeouts are overridden by the driver, the
purpose of the override was because disk drives and arrays on the
dpt_i2o based controllers could take up to 5 minutes to complete. The
override should only apply to disk drives and arrays (both appear as
DASD devices from the driver's perspective).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

--- a/drivers/scsi/dpt_i2o.c	Mon Apr  4 09:39:17 2005
+++ b/drivers/scsi/dpt_i2o.c	Mon Apr 25 07:21:50 2005
@@ -420,8 +420,9 @@
 		return 1;
 	}
 
-	if(cmd->eh_state != SCSI_STATE_QUEUED){
-		// If we are not doing error recovery
+	if ((cmd->eh_state != SCSI_STATE_QUEUED)
+	 && (cmd->device->type == TYPE_DISK)) {
+		/* If the controller is doing error recovery */
 		mod_timer(&cmd->eh_timeout, timeout);
 	}


Sincerely -- Mark Salyzyn
