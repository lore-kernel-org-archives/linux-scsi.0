From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/28] fdomain: move bus reset to host reset
Date: Wed, 28 Jun 2017 10:24:58 +0200
Message-ID: <1498638316-44420-11-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751656AbdF1IbH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:07 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus reset function really is a host reset, so move it to
eh_host_reset_handler().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fdomain.c             | 6 +++---
 drivers/scsi/fdomain.h             | 2 +-
 drivers/scsi/pcmcia/fdomain_stub.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index b87ab38..ebbe5a3 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -933,7 +933,7 @@ struct Scsi_Host *__fdomain_16x0_detect(struct scsi_host_template *tpnt )
       }
    }
 
-   fdomain_16x0_bus_reset(NULL);
+   fdomain_16x0_host_reset(NULL);
 
    if (fdomain_test_loopback()) {
       printk(KERN_ERR  "scsi: <fdomain> Detection failed (loopback test failed at port base 0x%x)\n", port_base);
@@ -1568,7 +1568,7 @@ static int fdomain_16x0_abort(struct scsi_cmnd *SCpnt)
    return SUCCESS;
 }
 
-int fdomain_16x0_bus_reset(struct scsi_cmnd *SCpnt)
+int fdomain_16x0_host_reset(struct scsi_cmnd *SCpnt)
 {
    unsigned long flags;
 
@@ -1758,7 +1758,7 @@ struct scsi_host_template fdomain_driver_template = {
 	.info			= fdomain_16x0_info,
 	.queuecommand		= fdomain_16x0_queue,
 	.eh_abort_handler	= fdomain_16x0_abort,
-	.eh_bus_reset_handler	= fdomain_16x0_bus_reset,
+	.eh_host_reset_handler	= fdomain_16x0_host_reset,
 	.bios_param		= fdomain_16x0_biosparam,
 	.release		= fdomain_16x0_release,
 	.can_queue		= 1,
diff --git a/drivers/scsi/fdomain.h b/drivers/scsi/fdomain.h
index 47021d9..5cbe86b 100644
--- a/drivers/scsi/fdomain.h
+++ b/drivers/scsi/fdomain.h
@@ -21,4 +21,4 @@
 extern struct scsi_host_template fdomain_driver_template;
 extern int fdomain_setup(char *str);
 extern struct Scsi_Host *__fdomain_16x0_detect(struct  scsi_host_template *tpnt );
-extern int fdomain_16x0_bus_reset(struct scsi_cmnd *SCpnt);
+extern int fdomain_16x0_host_reset(struct scsi_cmnd *SCpnt);
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index 714b248..953a792 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -173,7 +173,7 @@ static void fdomain_release(struct pcmcia_device *link)
 
 static int fdomain_resume(struct pcmcia_device *link)
 {
-	fdomain_16x0_bus_reset(NULL);
+	fdomain_16x0_host_reset(NULL);
 
 	return 0;
 }
-- 
1.8.5.6
