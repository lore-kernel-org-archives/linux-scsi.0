From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/4] qla2xxx: Perform fast mailbox read of flash regardless of size nor address alignment.
Date: Tue, 12 Jan 2010 12:59:49 -0800
Message-ID: <1263329991-307-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1263329991-307-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54867 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752952Ab0ALU74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2010 15:59:56 -0500
In-Reply-To: <1263329991-307-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 010e69b..371dc89 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2292,11 +2292,14 @@ qla25xx_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 	uint32_t faddr, left, burst;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (IS_QLA25XX(ha) || IS_QLA81XX(ha))
+		goto try_fast;
 	if (offset & 0xfff)
 		goto slow_read;
 	if (length < OPTROM_BURST_SIZE)
 		goto slow_read;
 
+try_fast:
 	optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
 	    &optrom_dma, GFP_KERNEL);
 	if (!optrom) {
-- 
1.6.2.rc1.30.gd43c

