From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/8] qla2xxx: Change GFP_ATOMIC to GFP_KERNEL for non-atomic allocations.
Date: Thu, 11 Sep 2008 21:22:48 -0700
Message-ID: <1221193374-77635-3-git-send-email-andrew.vasquez@qlogic.com>
References: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46751 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYILEW6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 00:22:58 -0400
In-Reply-To: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Both call-sites are sleeping-capable.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ee89ddd..57f24df 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2561,7 +2561,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 	rval = QLA_SUCCESS;
 
 	/* Try GID_PT to get device list, else GAN. */
-	swl = kcalloc(MAX_FIBRE_DEVICES, sizeof(sw_info_t), GFP_ATOMIC);
+	swl = kcalloc(MAX_FIBRE_DEVICES, sizeof(sw_info_t), GFP_KERNEL);
 	if (!swl) {
 		/*EMPTY*/
 		DEBUG2(printk("scsi(%ld): GID_PT allocations failed, fallback "
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 813bc77..ef15ad5 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1995,7 +1995,7 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
 	char *pmap;
 	dma_addr_t pmap_dma;
 
-	pmap = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &pmap_dma);
+	pmap = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pmap_dma);
 	if (pmap  == NULL) {
 		DEBUG2_3_11(printk("%s(%ld): **** Mem Alloc Failed ****",
 		    __func__, ha->host_no));
-- 
1.6.0.1.294.gda06a

