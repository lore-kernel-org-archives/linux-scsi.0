From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] advansys: use correct srb_tag in adv_isr_callback
Date: Wed, 26 Sep 2018 19:41:07 +0800
Message-ID: <20180926114107.13532-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matthew@wil.cx, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

'srb_tag' should be used in the scsi_host_find_tag,
rather than 'scsiqp->srb_tag'.

Fixes: 9c17c62aedb0 ("advansys: use shared host tag map for command lookup")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/advansys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 713f690..23f313c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -5966,7 +5966,7 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	 * completed ADV_SCSI_REQ_Q structure.
 	 */
 	srb_tag = le32_to_cpu(scsiqp->srb_tag);
-	scp = scsi_host_find_tag(boardp->shost, scsiqp->srb_tag);
+	scp = scsi_host_find_tag(boardp->shost, srb_tag);
 
 	ASC_DBG(1, "scp 0x%p\n", scp);
 	if (scp == NULL) {
-- 
1.8.3.1
