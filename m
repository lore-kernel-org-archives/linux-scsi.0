From: giridhar.malavali@qlogic.com
Subject: [PATCH 4/5] qla2xxx: Fix to make conditional decision based on port number.
Date: Fri, 19 Mar 2010 17:04:01 -0700
Message-ID: <1269043442-2306-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36583 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752209Ab0CTAEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 20:04:06 -0400
In-Reply-To: <1269043442-2306-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Sarang Radke <sarang.radke@qlogic.com>

From: Sarang Radke <sarang.radke@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 4ee22a2..c944c5f 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -738,11 +738,11 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 			ha->flt_region_gold_fw = start;
 			break;
 		case FLT_REG_FCP_PRIO_0:
-			if (!(PCI_FUNC(ha->pdev->devfn) & 1))
+			if (ha->flags.port0)
 				ha->flt_region_fcp_prio = start;
 			break;
 		case FLT_REG_FCP_PRIO_1:
-			if (PCI_FUNC(ha->pdev->devfn) & 1)
+			if (!ha->flags.port0)
 				ha->flt_region_fcp_prio = start;
 			break;
 		}
-- 
1.6.2.rc1.30.gd43c

