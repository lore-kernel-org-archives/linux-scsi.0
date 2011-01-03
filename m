From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/32] scsi/be2iscsi,qla2xxx: convert to alloc_workqueue()
Date: Mon,  3 Jan 2011 14:49:39 +0100
Message-ID: <1294062595-30097-17-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Jayamohan Kallickal <jayamohank@serverengines.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Switch to new workqueue interface alloc_workqueue().  These are
identity conversions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
Please feel free to take it into the subsystem tree or simply ack -
I'll route it through the wq tree.

Thanks.

 drivers/scsi/be2iscsi/be_main.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 75a85aa..4339196 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4276,7 +4276,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_q_irq%u",
 		 phba->shost->host_no);
-	phba->wq = create_workqueue(phba->wq_name);
+	phba->wq = alloc_workqueue(phba->wq_name, WQ_MEM_RECLAIM, 1);
 	if (!phba->wq) {
 		shost_printk(KERN_ERR, phba->shost, "beiscsi_dev_probe-"
 				"Failed to allocate work queue\n");
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c0876c..2cd0a77 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -356,7 +356,7 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 				"Can't create request queue\n");
 			goto fail;
 		}
-		ha->wq = create_workqueue("qla2xxx_wq");
+		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
 		vha->req = ha->req_q_map[req];
 		options |= BIT_1;
 		for (ques = 1; ques < ha->max_rsp_queues; ques++) {
-- 
1.7.1
