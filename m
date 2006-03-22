From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] fix sg leak when scsi_execute_async fails
Date: Wed, 22 Mar 2006 16:04:38 -0600
Message-ID: <1143065078.2650.3.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:31888 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932077AbWCVWH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 17:07:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, linux-scsi@vger.kernel.org

Doug found a bug where if scsi_execute_async fails, we are leaking
sg resources. scsi_do_req never failed so we did not have to handle
that case before.

Patch was made against scsi-misc. Not sure if this should
also go to stable?

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>



diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index a8b05ce..71994ea 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -748,6 +748,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
 		/*
 		 * most likely out of mem, but could also be a bad map
 		 */
+		sg_finish_rem_req(srp);
 		return -ENOMEM;
 	} else
 		return 0;


