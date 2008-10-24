From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/5] qla2xxx: Do not honour max_vports from firmware for 2G ISPs and below.
Date: Fri, 24 Oct 2008 15:13:46 -0700
Message-ID: <1224886428-31799-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1224886428-31799-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:14169 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbYJXWNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 18:13:50 -0400
In-Reply-To: <1224886428-31799-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

For 23XX ISPs, max_vports may return an invalid value.
Do not honour it.

Cc: Stable Tree <stable@kernel.org>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ecf91ad..4218f20 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -964,7 +964,6 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 				    &ha->fw_minor_version,
 				    &ha->fw_subminor_version,
 				    &ha->fw_attributes, &ha->fw_memory_size);
-				qla2x00_resize_request_q(ha);
 				ha->flags.npiv_supported = 0;
 				if ((IS_QLA24XX(ha) || IS_QLA25XX(ha) ||
 				     IS_QLA84XX(ha)) &&
@@ -976,6 +975,7 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
 				}
+				qla2x00_resize_request_q(ha);
 
 				if (ql2xallocfwdump)
 					qla2x00_alloc_fw_dump(ha);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 36bc685..3402746 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1964,7 +1964,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 			*cur_iocb_cnt = mcp->mb[7];
 		if (orig_iocb_cnt)
 			*orig_iocb_cnt = mcp->mb[10];
-		if (max_npiv_vports)
+		if (ha->flags.npiv_supported && max_npiv_vports)
 			*max_npiv_vports = mcp->mb[11];
 	}
 
-- 
1.6.0.2.526.g5c283

