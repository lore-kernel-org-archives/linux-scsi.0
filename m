From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [Trivial Patch] scsi_register-008
Date: Thu, 06 Feb 2003 14:11:38 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206053821.47B0C2C2E3@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Achim Leubner <achim@vortex.de>, linux-scsi@vger.kernel.org

(Included in 2.5)
From:  Michael Still <mikal@stillhq.com>

  
  This patch has been generated as part of my scsi_register audit of the 2.5.45 kernel tree. scsi_register() can fail, returning a NULL pointer, and the failure case was not being handled here...
  
  
  
  

--- trivial-2.4.21-pre4/drivers/scsi/gdth.c.orig	2003-02-06 13:53:49.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/gdth.c	2003-02-06 13:53:49.000000000 +1100
@@ -4256,6 +4256,9 @@
             if (gdth_ctr_count >= MAXHA)
                 break;
             shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	    if(shp == NULL)
+		    continue;
+
             ha = HADATA(shp);
             if (!gdth_init_pci(&pcistr[ctr],ha)) {
                 scsi_unregister(shp);
-- 
  Don't blame me: the Monkey is driving
  File: Michael Still <mikal@stillhq.com>: [Trivial Patch] scsi_register-008
