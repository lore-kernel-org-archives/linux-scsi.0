From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [Trivial Patch] scsi_register-002
Date: Thu, 06 Feb 2003 14:11:34 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206053821.CD22F2C397@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: linux-scsi@vger.kernel.org

(Included in 2.5)
From:  Michael Still <mikal@stillhq.com>

  
  This patch has been generated as part of my scsi_register audit of the 2.5.45 kernel tree. scsi_register() can fail, returning a NULL pointer, and the failure case was not being handled here...
  
  
  
  

--- trivial-2.4.21-pre4/drivers/scsi/aacraid/linit.c.orig	2003-02-06 13:53:49.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/aacraid/linit.c	2003-02-06 13:53:49.000000000 +1100
@@ -203,6 +203,9 @@
 			 * specific information.
 			 */
 			host_ptr = scsi_register( template, sizeof(struct aac_dev) );
+			if(host_ptr == NULL)
+				continue;
+
 			/* 
 			 * These three parameters can be used to allow for wide SCSI 
 			 * and for host adapters that support multiple buses.
-- 
  Don't blame me: the Monkey is driving
  File: Michael Still <mikal@stillhq.com>: [Trivial Patch] scsi_register-002
