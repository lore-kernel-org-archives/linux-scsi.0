From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1/2] scsi: arcmsr: Fix error of resuming from hibernation
 for adapter type E
Date: Mon, 09 Jul 2018 18:24:53 +0800
Message-ID: <1531131893.5779.13.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

>From Ching Huang <ching2048@areca.com.tw>

Fix error of resuming from hibernation for adapter type E.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 732b5d9..12316ef 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1061,6 +1061,13 @@ static int arcmsr_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	if (arcmsr_request_irq(pdev, acb) == FAILED)
 		goto controller_stop;
+	if (acb->adapter_type == ACB_ADAPTER_TYPE_E) {
+		writel(0, &acb->pmuE->host_int_status);
+		writel(ARCMSR_HBEMU_DOORBELL_SYNC, &acb->pmuE->iobound_doorbell);
+		acb->in_doorbell = 0;
+		acb->out_doorbell = 0;
+		acb->doneq_index = 0;
+	}
 	arcmsr_iop_init(acb);
 	arcmsr_init_get_devmap_timer(acb);
 	if (set_date_time)
