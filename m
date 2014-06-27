From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/7] mptfc: Do not call fc_block_scsi_eh() on host reset
Date: Fri, 27 Jun 2014 08:27:00 +0200
Message-ID: <1403850425-89297-3-git-send-email-hare@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbaF0G1K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 02:27:10 -0400
In-Reply-To: <1403850425-89297-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

When we're resetting the host any remote port states will
be reset anyway, so it's pointless to wait for dev_loss_tmo
during host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/message/fusion/mptfc.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index bf2a2ce..b84dc26 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -104,7 +104,6 @@ static void mptfc_remove(struct pci_dev *pdev);
 static int mptfc_abort(struct scsi_cmnd *SCpnt);
 static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
 static int mptfc_bus_reset(struct scsi_cmnd *SCpnt);
-static int mptfc_host_reset(struct scsi_cmnd *SCpnt);
 
 static struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
@@ -122,7 +121,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.eh_abort_handler		= mptfc_abort,
 	.eh_device_reset_handler	= mptfc_dev_reset,
 	.eh_bus_reset_handler		= mptfc_bus_reset,
-	.eh_host_reset_handler		= mptfc_host_reset,
+	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_FC_CAN_QUEUE,
 	.this_id			= -1,
@@ -253,13 +252,6 @@ mptfc_bus_reset(struct scsi_cmnd *SCpnt)
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
1.7.12.4

