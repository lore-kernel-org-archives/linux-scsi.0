From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v2 net-next 09/11] Revert "scsi: qedi: Allocate IRQs based on msix_cnt"
Date: Sun, 26 May 2019 15:22:28 +0300
Message-ID: <20190526122230.30039-10-michal.kalderon@marvell.com>
References: <20190526122230.30039-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190526122230.30039-1-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, davem@davemloft.net
Cc: dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>
List-Id: linux-scsi@vger.kernel.org

From: Manish Rangankar <mrangankar@marvell.com>

 Always request for number of irqs equals to number of queues.

This reverts commit 1a291bce5eaf5374627d337157544aa6499ce34a.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index e5db9a9954dc..f07e0814a657 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1336,7 +1336,7 @@ static int qedi_request_msix_irq(struct qedi_ctx *qedi)
 	int i, rc, cpu;
 
 	cpu = cpumask_first(cpu_online_mask);
-	for (i = 0; i < qedi->int_info.msix_cnt; i++) {
+	for (i = 0; i < MIN_NUM_CPUS_MSIX(qedi); i++) {
 		rc = request_irq(qedi->int_info.msix[i].vector,
 				 qedi_msix_handler, 0, "qedi",
 				 &qedi->fp_array[i]);
-- 
2.14.5
