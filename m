From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/35] fdomain: move bus reset to host reset
Date: Fri, 23 Jun 2017 15:02:32 +0200
Message-ID: <1498222975-71858-13-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32865 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754162AbdFWND2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:28 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus reset function really is a host reset, so move it to
eh_host_reset_handler().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fdomain.c | 6 +++---
 drivers/scsi/fdomain.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

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
-- 
1.8.5.6
