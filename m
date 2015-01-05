From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 7/8] megaraid_sas : Remove redundant code of memset
 load_balance_info to zero
Date: Mon, 5 Jan 2015 20:06:28 +0530
Message-ID: <201501051440.t05EeUX5030081@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0078.outbound.protection.outlook.com ([157.56.111.78]:42263
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753388AbbAEOwU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 09:52:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

struct fusion_context *fusion is already memset to '0', so remove redundant code of meset "fusion->load_balance_info" to '0'.

Signed-off-by: Chaitra Basappa <chaitra.basappa@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ac3c04a..d9215d7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5185,8 +5185,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 			((1 << PAGE_SHIFT) << instance->ctrl_context_pages));
 		INIT_LIST_HEAD(&fusion->cmd_pool);
 		spin_lock_init(&fusion->mpt_pool_lock);
-		memset(fusion->load_balance_info, 0,
-			sizeof(struct LD_LOAD_BALANCE_INFO) * MAX_LOGICAL_DRIVES_EXT);
 	}
 	break;
 	default: /* For all other supported controllers */
-- 
1.7.3

