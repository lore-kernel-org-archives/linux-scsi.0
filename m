From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 11/12] scsi: arcmsr: Fix suspend/resume of
 ACB_ADAPTER_TYPE_B
Date: Wed, 19 Dec 2018 16:59:48 +0800
Message-ID: <1545209988.4457.47.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Fix suspend/resume of ACB_ADAPTER_TYPE_B

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 30dff6c..9f85d5a 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1110,12 +1110,21 @@ static int arcmsr_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto controller_stop;
-	if (acb->adapter_type == ACB_ADAPTER_TYPE_E) {
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg = acb->pmuB;
+		reg->post_qbuffer[0] = 0;
+		reg->postq_index = 0;
+		reg->doneq_index = 0;
+		break;
+		}
+	case ACB_ADAPTER_TYPE_E:
 		writel(0, &acb->pmuE->host_int_status);
 		writel(ARCMSR_HBEMU_DOORBELL_SYNC, &acb->pmuE->iobound_doorbell);
 		acb->in_doorbell = 0;
 		acb->out_doorbell = 0;
 		acb->doneq_index = 0;
+		break;
 	}
 	arcmsr_iop_init(acb);
 	arcmsr_init_get_devmap_timer(acb);
