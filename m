From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [Trivial Patch] scsi_register-006
Date: Mon, 16 Dec 2002 21:39:46 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021216210037.E2C0E2C136@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Achim Leubner <achim@vortex.de>, linux-scsi@vger.kernel.org

(Included in 2.5)
From:  Michael Still <mikal@stillhq.com>

  
  This patch has been generated as part of my scsi_register audit of the 2.5.45 kernel tree. scsi_register() can fail, returning a NULL pointer, and the failure case was not being handled here...
  
  
  
  

--- trivial-2.4.21-pre1/drivers/scsi/gdth.c.orig	2002-12-16 17:22:29.000000000 +1100
+++ trivial-2.4.21-pre1/drivers/scsi/gdth.c	2002-12-16 17:22:29.000000000 +1100
@@ -4143,6 +4143,9 @@
             break;
         if (gdth_search_eisa(eisa_slot)) {      /* controller found */
             shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	    if(shp == NULL)
+		    continue;
+
             ha = HADATA(shp);
             if (!gdth_init_eisa(eisa_slot,ha)) {
                 scsi_unregister(shp);
-- 
  Don't blame me: the Monkey is driving
  File: Michael Still <mikal@stillhq.com>: [Trivial Patch] scsi_register-006
