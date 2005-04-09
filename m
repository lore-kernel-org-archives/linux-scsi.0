From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/sym53c416.c: fix a wrong check
Date: Sun, 10 Apr 2005 01:10:57 +0200
Message-ID: <20050409231057.GS3632@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261399AbVDIXPT@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: lw_linux@hotmail.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The Coverity checker found that this for loop was wrong.

This patch changes it to what seems to be intended.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.12-rc2-mm2-full/drivers/scsi/sym53c416.c.old	2005-04-09 22:16:04.000000000 +0200
+++ linux-2.6.12-rc2-mm2-full/drivers/scsi/sym53c416.c	2005-04-09 22:16:28.000000000 +0200
@@ -803,19 +803,19 @@
 static int sym53c416_host_reset(Scsi_Cmnd *SCpnt)
 {
 	int base;
 	int scsi_id = -1;	
 	int i;
 
 	/* printk("sym53c416_reset\n"); */
 	base = SCpnt->device->host->io_port;
 	/* search scsi_id - fixme, we shouldnt need to iterate for this! */
-	for(i = 0; i < host_index && scsi_id != -1; i++)
+	for(i = 0; i < host_index && scsi_id == -1; i++)
 		if(hosts[i].base == base)
 			scsi_id = hosts[i].scsi_id;
 	outb(RESET_CHIP, base + COMMAND_REG);
 	outb(NOOP | PIO_MODE, base + COMMAND_REG);
 	outb(RESET_SCSI_BUS, base + COMMAND_REG);
 	sym53c416_init(base, scsi_id);
 	return SUCCESS;
 }
 
