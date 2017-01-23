From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 1/2] qla2xxx: Fix a recently introduced memory leak
Date: Mon, 23 Jan 2017 08:34:45 -0800
Message-ID: <20170123163446.9227-2-bart.vanassche@sandisk.com>
References: <20170123163446.9227-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0059.outbound.protection.outlook.com ([104.47.41.59]:56096
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750732AbdAWQe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 11:34:57 -0500
In-Reply-To: <20170123163446.9227-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Michael Hernandez <michael.hernandez@cavium.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org

qla2x00_probe_one() allocates IRQs before it initializes rsp_q_map
so IRQs must be freed even if rsp_q_map allocation did not occur.
This was detected by kmemleak.

Fixes: 4fa183455988 ("scsi: qla2xxx: Utilize pci_alloc_irq_vectors/pci_free_irq_vectors calls")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Michael Hernandez <michael.hernandez@cavium.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index dc88a09f9043..a94b0b6bd030 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3242,7 +3242,7 @@ qla2x00_free_irqs(scsi_qla_host_t *vha)
 	 * from a probe failure context.
 	 */
 	if (!ha->rsp_q_map || !ha->rsp_q_map[0])
-		return;
+		goto free_irqs;
 	rsp = ha->rsp_q_map[0];
 
 	if (ha->flags.msix_enabled) {
@@ -3262,6 +3262,7 @@ qla2x00_free_irqs(scsi_qla_host_t *vha)
 		free_irq(pci_irq_vector(ha->pdev, 0), rsp);
 	}
 
+free_irqs:
 	pci_free_irq_vectors(ha->pdev);
 }
 
-- 
2.11.0

