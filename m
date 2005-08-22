From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch] ibmvscsi timeout fix
Date: Mon, 22 Aug 2005 14:38:26 -0500
Message-ID: <20050822193826.GA2455@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.202]:5767 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1750731AbVHVTic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 15:38:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jschopp@austin.ibm.com, linuxppc64-dev@ozlabs.org

This patch fixes a long term borkenness in
ibmvscsi where we were using the wrong timeout
field from the scsi command (and using the 
wrong units.)  Now broken by the fact that the
scsi_cmnd timeout field is gone entirely.
This only worked before because all the SCSI
targets assumed that 0 was default.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>

--- linux-2.6.13-rc6-mm1-orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2005-08-22 13:54:20.111955197 -0500
+++ linux-2.6.13-rc6-mm1/drivers/scsi/ibmvscsi/ibmvscsi.c	2005-08-22 14:22:56.265042174 -0500
@@ -594,7 +594,7 @@
 	init_event_struct(evt_struct,
 			  handle_cmd_rsp,
 			  VIOSRP_SRP_FORMAT,
-			  cmnd->timeout);
+			  cmnd->timeout_per_command/HZ);
 
 	evt_struct->cmnd = cmnd;
 	evt_struct->cmnd_done = done;


-- 
Dave Boutcher
