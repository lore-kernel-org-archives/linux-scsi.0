From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [Trivial Patch] scsi_register-002
Date: Fri, 08 Nov 2002 19:25:01 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108083828.3768D2C44A@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, alan@redhat.com

From:  Michael Still <mikal@stillhq.com>

  
  This patch has been generated as part of my scsi_register audit of the 2.5.45 kernel tree. scsi_register() can fail, returning a NULL pointer, and the failure case was not being handled here...
  
  
  
  

--- trivial-2.5-bk/drivers/scsi/aacraid/linit.c.orig	2002-11-08 18:47:02.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/aacraid/linit.c	2002-11-08 18:47:02.000000000 +1100
@@ -204,6 +204,9 @@
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
