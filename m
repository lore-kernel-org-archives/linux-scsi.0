From: sullivan <sullivan@austin.ibm.com>
Subject: [PATCH] ide-scsi cleanup bug
Date: Wed, 17 Jul 2002 14:58:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020717145820.F1136@austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="eqp4TxRxnD4KrmFZ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following patch is against lk 2.5.26. The prior implementation called  
scsi_unregister(host) from idescsi_cleanup(), removing the Scsi_Host instance 
from the scsi_hostlist. Later when scsi_unregister_host(&template) was called 
from exit_idescsi_module() but since the Scsi_Host instance had already been 
removed no matches for the template were found and the device instances 
remained.

The patch moves the scsi_unregister_host(&template) to idescsi_cleanup(). 
Since scsi_unregister_host() invokes scsi_unregister() this part of the 
cleanup also occurs normally.


--eqp4TxRxnD4KrmFZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.5.26-ide-scsi.patch"

diff -Naur linux-2.5.26/drivers/scsi/ide-scsi.c linux-2.5.26-patched/drivers/scsi/ide-scsi.c
--- linux-2.5.26/drivers/scsi/ide-scsi.c	Tue Jul 16 18:49:24 2002
+++ linux-2.5.26-patched/drivers/scsi/ide-scsi.c	Wed Jul 17 19:14:35 2002
@@ -491,14 +491,13 @@
 	MOD_DEC_USE_COUNT;
 }
 
+static Scsi_Host_Template template;
 static int idescsi_cleanup (struct ata_device *drive)
 {
-	struct Scsi_Host *host = drive->driver_data;
-
 	if (ide_unregister_subdriver (drive)) {
 		return 1;
 	}
-	scsi_unregister(host);
+	scsi_unregister_host(&template);
 
 	return 0;
 }
@@ -801,7 +800,6 @@
 static void __exit exit_idescsi_module(void)
 {
 	unregister_ata_driver(&ata_ops);
-	scsi_unregister_host(&template);
 }
 
 module_init(init_idescsi_module);

--eqp4TxRxnD4KrmFZ--
