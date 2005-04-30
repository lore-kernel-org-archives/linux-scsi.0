From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] call correct scsi_done function in scsi_dispatch_cmd
Date: Fri, 29 Apr 2005 17:20:13 -0700
Message-ID: <4272CF3D.80808@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050009030105020206040109"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36839 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S263078AbVD3AUU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 20:20:20 -0400
Received: from [192.168.0.2] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j3U0KJDJ020252
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2005 19:20:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050009030105020206040109
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

scsi_dispatch_cmd currently calls scsi_done when the device is in the 
SDEV_DEL state, but at this point the command has not had a timer added 
to it (this is done a couple lines down) so scsi_done just returns and 
the command is lost. The attached patch made against 2.6.12-rc3 calls 
__scsi_done in this case so the comamnd will be returned upwards.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

--------------050009030105020206040109
Content-Type: text/x-patch;
 name="call-correct-done.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="call-correct-done.patch"

--- linux-2.6.12-rc3/drivers/scsi/scsi.c.orig	2005-04-29 17:05:01.323994458 -0700
+++ linux-2.6.12-rc3/drivers/scsi/scsi.c	2005-04-29 17:05:18.406145282 -0700
@@ -542,7 +542,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		 * that the device is no longer present */
 		cmd->result = DID_NO_CONNECT << 16;
 		atomic_inc(&cmd->device->iorequest_cnt);
-		scsi_done(cmd);
+		__scsi_done(cmd);
 		/* return 0 (because the command has been processed) */
 		goto out;
 	}

--------------050009030105020206040109--
