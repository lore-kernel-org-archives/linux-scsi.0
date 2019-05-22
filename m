From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 023/167] scsi: qla2xxx: Fix a qla24xx_enable_msix() error path
Date: Wed, 22 May 2019 15:26:18 -0400
Message-ID: <20190522192842.25858-23-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Himanshu Madhani <hmadhani@marvell.com>, Giridhar Malavali <gmalavali@marvell.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 24afabdbd0b3553963a2bbf465895492b14d1107 ]

Make sure that the allocated interrupts are freed if allocating memory for
the msix_entries array fails.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <gmalavali@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e073eb16f8a4a..df94ef816826b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3395,7 +3395,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		ql_log(ql_log_fatal, vha, 0x00c8,
 		    "Failed to allocate memory for ha->msix_entries.\n");
 		ret = -ENOMEM;
-		goto msix_out;
+		goto free_irqs;
 	}
 	ha->flags.msix_enabled = 1;
 
@@ -3477,6 +3477,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 
 msix_out:
 	return ret;
+
+free_irqs:
+	pci_free_irq_vectors(ha->pdev);
+	goto msix_out;
 }
 
 int
-- 
2.20.1
