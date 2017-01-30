From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] libsas: remove sas_scsi_timed_out
Date: Mon, 30 Jan 2017 13:18:57 +0100
Message-ID: <1485778739-29036-3-git-send-email-hch@lst.de>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53930 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752758AbdA3MTW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2017 07:19:22 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cYAvQ-0003og-Je
        for linux-scsi@vger.kernel.org; Mon, 30 Jan 2017 12:19:13 +0000
In-Reply-To: <1485778739-29036-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

EH_NOT_HANDLED is the default case if no eh_timed_out method is provided,
so there is no need to supply it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/libsas/sas_init.c      | 1 -
 drivers/scsi/libsas/sas_internal.h  | 2 --
 drivers/scsi/libsas/sas_scsi_host.c | 7 -------
 3 files changed, 10 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 362da44..15ef8e2 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -560,7 +560,6 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
 	i = to_sas_internal(stt);
 	i->dft = dft;
 	stt->create_work_queue = 1;
-	stt->eh_timed_out = sas_scsi_timed_out;
 	stt->eh_strategy_handler = sas_scsi_recover_host;
 
 	return stt;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 9cf0bc2..b306b78 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -64,8 +64,6 @@ void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
 void sas_unregister_ports(struct sas_ha_struct *sas_ha);
 
-enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *);
-
 int  sas_init_events(struct sas_ha_struct *sas_ha);
 void sas_disable_revalidation(struct sas_ha_struct *ha);
 void sas_enable_revalidation(struct sas_ha_struct *ha);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 519dac4..9bd55bc 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -803,13 +803,6 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 		    shost->host_failed, tries);
 }
 
-enum blk_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
-{
-	scmd_dbg(cmd, "command %p timed out\n", cmd);
-
-	return BLK_EH_NOT_HANDLED;
-}
-
 int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 {
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
-- 
2.1.4

