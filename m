From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 02/26] mptfc: Do not call fc_block_scsi_eh() on host reset
Date: Fri, 25 Aug 2017 13:56:57 +0200
Message-ID: <1503662241-127788-3-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49529 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756495AbdHYL57 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:57:59 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we're resetting the host any remote port states will
be reset anyway, so it's pointless to wait for dev_loss_tmo
during host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/message/fusion/mptfc.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index d065062..6d461ca 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -104,7 +104,6 @@
 static int mptfc_abort(struct scsi_cmnd *SCpnt);
 static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
 static int mptfc_bus_reset(struct scsi_cmnd *SCpnt);
-static int mptfc_host_reset(struct scsi_cmnd *SCpnt);
 
 static struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
@@ -123,7 +122,7 @@
 	.eh_abort_handler		= mptfc_abort,
 	.eh_device_reset_handler	= mptfc_dev_reset,
 	.eh_bus_reset_handler		= mptfc_bus_reset,
-	.eh_host_reset_handler		= mptfc_host_reset,
+	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_FC_CAN_QUEUE,
 	.this_id			= -1,
@@ -254,13 +253,6 @@
 	    mptfc_block_error_handler(SCpnt, mptscsih_bus_reset, __func__);
 }
 
-static int
-mptfc_host_reset(struct scsi_cmnd *SCpnt)
-{
-	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_host_reset, __func__);
-}
-
 static void
 mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout)
 {
-- 
1.8.5.6
