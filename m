From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/6] qla2xxx: Correct overwrite of pre-assigned init-control-block structure size.
Date: Thu,  5 Mar 2009 11:07:04 -0800
Message-ID: <1236280025-89526-6-git-send-email-andrew.vasquez@qlogic.com>
References: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5602 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbZCETHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 14:07:09 -0500
In-Reply-To: <1236280025-89526-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

The value is already pre-assigned prior to the qla2x00_mem_alloc().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 16c3476..3ddfa88 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2222,10 +2222,6 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 {
 	char	name[16];
 
-	ha->init_cb_size = sizeof(init_cb_t);
-	if (IS_QLA2XXX_MIDTYPE(ha))
-		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
-
 	ha->init_cb = dma_alloc_coherent(&ha->pdev->dev, ha->init_cb_size,
 		&ha->init_cb_dma, GFP_KERNEL);
 	if (!ha->init_cb)
-- 
1.6.2.rc0.55.g30aa4f

