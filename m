From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [Trivial Patch] scsi_register-004
Date: Fri, 08 Nov 2002 19:25:44 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108083828.03AD32C3F3@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, achim@vortex.de

From:  Michael Still <mikal@stillhq.com>

  
  This patch has been generated as part of my scsi_register audit of the 2.5.45 kernel tree. scsi_register() can fail, returning a NULL pointer, and the failure case was not being handled here...
  
  
  
  

--- trivial-2.5-bk/drivers/scsi/gdth.c.orig	2002-11-08 18:47:03.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/gdth.c	2002-11-08 18:47:03.000000000 +1100
@@ -3991,6 +3991,9 @@
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
  Don't blame me: the Monkey is driving
  File: Michael Still <mikal@stillhq.com>: [Trivial Patch] scsi_register-004
