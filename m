From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [Trivial Patch] scsi_register-004
Date: Mon, 23 Jun 2003 16:56:39 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623070135.83F4D2C274@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:31152 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263187AbTFWGr2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 02:47:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Achim Leubner <achim@vortex.de>, linux-scsi@vger.kernel.org

(Included in 2.5)
From:  Michael Still <mikal@stillhq.com>

  
  This patch has been generated as part of my scsi_register audit of the 2.5.45 kernel tree. scsi_register() can fail, returning a NULL pointer, and the failure case was not being handled here...
  
  
  
  

--- trivial-2.4.22-pre1/drivers/scsi/gdth.c.orig	2003-06-23 16:39:34.000000000 +1000
+++ trivial-2.4.22-pre1/drivers/scsi/gdth.c	2003-06-23 16:39:34.000000000 +1000
@@ -4029,6 +4029,9 @@
             break;
         if (gdth_search_isa(isa_bios)) {        /* controller found */
             shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	    if(shp == NULL)
+		    continue;
+
             ha = HADATA(shp);
             if (!gdth_init_isa(isa_bios,ha)) {
                 scsi_unregister(shp);
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Michael Still <mikal@stillhq.com>: [Trivial Patch] scsi_register-004
