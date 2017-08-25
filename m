From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 20/26] nsp32: drop bus reset
Date: Fri, 25 Aug 2017 13:57:15 +0200
Message-ID: <1503662241-127788-21-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49607 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756497AbdHYL6E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:04 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

bus reset is a host reset without nsp32hw_init(), and will always
return SUCCESS, thus disabling the use of host reset.
So drop bus reset in favour of host reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/nsp32.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 53c8477..107e191 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -201,7 +201,6 @@
 
 /* SCSI error handler */
 static int         nsp32_eh_abort     (struct scsi_cmnd *);
-static int         nsp32_eh_bus_reset (struct scsi_cmnd *);
 static int         nsp32_eh_host_reset(struct scsi_cmnd *);
 
 /* generate SCSI message */
@@ -276,8 +275,7 @@
 	.max_sectors			= 128,
 	.this_id			= NSP32_HOST_SCSIID,
 	.use_clustering			= DISABLE_CLUSTERING,
-	.eh_abort_handler       	= nsp32_eh_abort,
-	.eh_bus_reset_handler		= nsp32_eh_bus_reset,
+	.eh_abort_handler		= nsp32_eh_abort,
 	.eh_host_reset_handler		= nsp32_eh_host_reset,
 /*	.highmem_io			= 1, */
 };
@@ -2845,24 +2843,6 @@ static int nsp32_eh_abort(struct scsi_cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static int nsp32_eh_bus_reset(struct scsi_cmnd *SCpnt)
-{
-	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
-	unsigned int   base = SCpnt->device->host->io_port;
-
-	spin_lock_irq(SCpnt->device->host->host_lock);
-
-	nsp32_msg(KERN_INFO, "Bus Reset");	
-	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
-
-	nsp32_write2(base, IRQ_CONTROL, IRQ_CONTROL_ALL_IRQ_MASK);
-	nsp32_do_bus_reset(data);
-	nsp32_write2(base, IRQ_CONTROL, 0);
-
-	spin_unlock_irq(SCpnt->device->host->host_lock);
-	return SUCCESS;	/* SCSI bus reset is succeeded at any time. */
-}
-
 static void nsp32_do_bus_reset(nsp32_hw_data *data)
 {
 	unsigned int   base = data->BaseAddress;
-- 
1.8.5.6
