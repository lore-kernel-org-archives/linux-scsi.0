From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [Trivial Patch] scsi_register-002
Date: Mon, 23 Jun 2003 16:56:32 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623070134.A15482C074@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:25776 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262422AbTFWGr2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 02:47:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org

(Included in 2.5)
From:  Michael Still <mikal@stillhq.com>

  
  This patch has been generated as part of my scsi_register audit of the 2.5.45 kernel tree. scsi_register() can fail, returning a NULL pointer, and the failure case was not being handled here...
  
  
  
  

--- trivial-2.4.22-pre1/drivers/scsi/aacraid/linit.c.orig	2003-06-23 16:39:34.000000000 +1000
+++ trivial-2.4.22-pre1/drivers/scsi/aacraid/linit.c	2003-06-23 16:39:34.000000000 +1000
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
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Michael Still <mikal@stillhq.com>: [Trivial Patch] scsi_register-002
