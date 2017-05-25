From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 3/7] qla2xxx: Fix crash due to mismatch mumber of Q-pair creation for Multi queue
Date: Wed, 24 May 2017 18:06:20 -0700
Message-ID: <20170525010624.8886-4-himanshu.madhani@cavium.com>
References: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0045.outbound.protection.outlook.com ([104.47.42.45]:17662
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162190AbdEYBGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 21:06:38 -0400
In-Reply-To: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@cavium.com>

when driver is loaded with Multi Queue enabled, it was
noticed that there was one less queue pair created.

Following message would indicate this

"No resources to create additional q pair."

The result of one less queue pair means that system can crash,
if the block mq layer thinks there is an extra hardware queue
available, and the driver will use a NULL ptr qpair in that instance.

Following stack trace is seen in one of the crash

irq_create_affinity_masks+0x98/0x530
irq_create_affinity_masks+0x98/0x530
__pci_enable_msix+0x321/0x4e0
mutex_lock+0x12/0x40
pci_alloc_irq_vectors_affinity+0xb5/0x140
qla24xx_enable_msix+0x79/0x530 [qla2xxx]
qla2x00_request_irqs+0x61/0x2d0 [qla2xxx]
qla2x00_probe_one+0xc73/0x2390 [qla2xxx]
ida_simple_get+0x98/0x100
kernfs_next_descendant_post+0x40/0x50
local_pci_probe+0x45/0xa0
pci_device_probe+0xfc/0x140
driver_probe_device+0x2c5/0x470
__driver_attach+0xdd/0xe0
driver_probe_device+0x470/0x470
bus_for_each_dev+0x6c/0xc0
driver_attach+0x1e/0x20
bus_add_driver+0x45/0x270
driver_register+0x60/0xe0
__pci_register_driver+0x4c/0x50
qla2x00_module_init+0x1ce/0x21e [qla2xxx]

Cc: <stable@vger.kernel.org> # 4.10
Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 1 +
 drivers/scsi/qla2xxx/qla_init.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ae119018dfaa..eddbc1218a39 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3425,6 +3425,7 @@ struct qla_hw_data {
 	uint8_t 	max_req_queues;
 	uint8_t 	max_rsp_queues;
 	uint8_t		max_qpairs;
+	uint8_t		num_qpairs;
 	struct qla_qpair *base_qpair;
 	struct qla_npiv_entry *npiv_info;
 	uint16_t	nvram_npiv_size;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 034743309ada..0391fc317003 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7543,12 +7543,13 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos, int v
 		/* Assign available que pair id */
 		mutex_lock(&ha->mq_lock);
 		qpair_id = find_first_zero_bit(ha->qpair_qid_map, ha->max_qpairs);
-		if (qpair_id >= ha->max_qpairs) {
+		if (ha->num_qpairs >= ha->max_qpairs) {
 			mutex_unlock(&ha->mq_lock);
 			ql_log(ql_log_warn, vha, 0x0183,
 			    "No resources to create additional q pair.\n");
 			goto fail_qid_map;
 		}
+		ha->num_qpairs++;
 		set_bit(qpair_id, ha->qpair_qid_map);
 		ha->queue_pair_map[qpair_id] = qpair;
 		qpair->id = qpair_id;
@@ -7635,6 +7636,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos, int v
 fail_msix:
 	ha->queue_pair_map[qpair_id] = NULL;
 	clear_bit(qpair_id, ha->qpair_qid_map);
+	ha->num_qpairs--;
 	mutex_unlock(&ha->mq_lock);
 fail_qid_map:
 	kfree(qpair);
@@ -7660,6 +7662,7 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
 	mutex_lock(&ha->mq_lock);
 	ha->queue_pair_map[qpair->id] = NULL;
 	clear_bit(qpair->id, ha->qpair_qid_map);
+	ha->num_qpairs--;
 	list_del(&qpair->qp_list_elem);
 	if (list_empty(&vha->qp_list))
 		vha->flags.qpairs_available = 0;
-- 
2.12.0
