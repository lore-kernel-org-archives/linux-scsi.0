From: Sasha Levin <sasha.levin@oracle.com>
Subject: [added to the 3.18 stable tree] qla2xxx: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed,  2 Mar 2016 15:27:09 -0500
Message-ID: <1456950474-1149-26-git-send-email-sasha.levin@oracle.com>
References: <1456950474-1149-1-git-send-email-sasha.levin@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1456950474-1149-1-git-send-email-sasha.levin@oracle.com>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, stable-commits@vger.kernel.org
Cc: Quinn Tran <quinn.tran@qlogic.com>, Alexander Gordeev <agordeev@redhat.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Sasha Levin <sasha.levin@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

This patch has been added to the 3.18 stable tree. If you have any
objections, please let us know.

===============

[ Upstream commit 84e32a06f4f8756ce9ec3c8dc7e97896575f0771 ]

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Log message code 0x00c6 preserved, although it is reported
after successful call to pci_enable_msix_range(), not before
possibly unsuccessful call to pci_enable_msix(). Consumers
of the error code should not notice the difference.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 +++++-----
 drivers/scsi/qla2xxx/qla_isr.c  |  4 ++--
 drivers/scsi/qla2xxx/qla_mid.c  |  4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |  6 ++++++
 drivers/scsi/qla2xxx/qla_tmpl.c | 16 ++++++++++++++++
 5 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a894b99..c919ac0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2146,7 +2146,7 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	/* Clear outstanding commands array. */
 	for (que = 0; que < ha->max_req_queues; que++) {
 		req = ha->req_q_map[que];
-		if (!req)
+		if (!req || !test_bit(que, ha->req_qid_map))
 			continue;
 		req->out_ptr = (void *)(req->ring + req->length);
 		*req->out_ptr = 0;
@@ -2163,7 +2163,7 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 
 	for (que = 0; que < ha->max_rsp_queues; que++) {
 		rsp = ha->rsp_q_map[que];
-		if (!rsp)
+		if (!rsp || !test_bit(que, ha->rsp_qid_map))
 			continue;
 		rsp->in_ptr = (void *)(rsp->ring + rsp->length);
 		*rsp->in_ptr = 0;
@@ -4908,7 +4908,7 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 
 	for (i = 1; i < ha->max_rsp_queues; i++) {
 		rsp = ha->rsp_q_map[i];
-		if (rsp) {
+		if (rsp && test_bit(i, ha->rsp_qid_map)) {
 			rsp->options &= ~BIT_0;
 			ret = qla25xx_init_rsp_que(base_vha, rsp);
 			if (ret != QLA_SUCCESS)
@@ -4923,8 +4923,8 @@ qla25xx_init_queues(struct qla_hw_data *ha)
 	}
 	for (i = 1; i < ha->max_req_queues; i++) {
 		req = ha->req_q_map[i];
-		if (req) {
-		/* Clear outstanding commands array. */
+		if (req && test_bit(i, ha->req_qid_map)) {
+			/* Clear outstanding commands array. */
 			req->options &= ~BIT_0;
 			ret = qla25xx_init_req_que(base_vha, req);
 			if (ret != QLA_SUCCESS)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a04a1b1..e191177 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2981,9 +2981,9 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		    "MSI-X: Failed to enable support "
 		    "-- %d/%d\n Retry with %d vectors.\n",
 		    ha->msix_count, ret, ret);
+		ha->msix_count = ret;
+		ha->max_rsp_queues = ha->msix_count - 1;
 	}
-	ha->msix_count = ret;
-	ha->max_rsp_queues = ha->msix_count - 1;
 	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
 				ha->msix_count, GFP_KERNEL);
 	if (!ha->msix_entries) {
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 5c2e031..7c0b33d 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -595,7 +595,7 @@ qla25xx_delete_queues(struct scsi_qla_host *vha)
 	/* Delete request queues */
 	for (cnt = 1; cnt < ha->max_req_queues; cnt++) {
 		req = ha->req_q_map[cnt];
-		if (req) {
+		if (req && test_bit(cnt, ha->req_qid_map)) {
 			ret = qla25xx_delete_req_que(vha, req);
 			if (ret != QLA_SUCCESS) {
 				ql_log(ql_log_warn, vha, 0x00ea,
@@ -609,7 +609,7 @@ qla25xx_delete_queues(struct scsi_qla_host *vha)
 	/* Delete response queues */
 	for (cnt = 1; cnt < ha->max_rsp_queues; cnt++) {
 		rsp = ha->rsp_q_map[cnt];
-		if (rsp) {
+		if (rsp && test_bit(cnt, ha->rsp_qid_map)) {
 			ret = qla25xx_delete_rsp_que(vha, rsp);
 			if (ret != QLA_SUCCESS) {
 				ql_log(ql_log_warn, vha, 0x00eb,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c51dee8..e859782 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -399,6 +399,9 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	int cnt;
 
 	for (cnt = 0; cnt < ha->max_req_queues; cnt++) {
+		if (!test_bit(cnt, ha->req_qid_map))
+			continue;
+
 		req = ha->req_q_map[cnt];
 		qla2x00_free_req_que(ha, req);
 	}
@@ -406,6 +409,9 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	ha->req_q_map = NULL;
 
 	for (cnt = 0; cnt < ha->max_rsp_queues; cnt++) {
+		if (!test_bit(cnt, ha->rsp_qid_map))
+			continue;
+
 		rsp = ha->rsp_q_map[cnt];
 		qla2x00_free_rsp_que(ha, rsp);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index a8c0c73..de46cb3 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -393,6 +393,10 @@ qla27xx_fwdt_entry_t263(struct scsi_qla_host *vha,
 	if (ent->t263.queue_type == T263_QUEUE_TYPE_REQ) {
 		for (i = 0; i < vha->hw->max_req_queues; i++) {
 			struct req_que *req = vha->hw->req_q_map[i];
+
+			if (!test_bit(i, vha->hw->req_qid_map))
+				continue;
+
 			if (req || !buf) {
 				length = req ?
 				    req->length : REQUEST_ENTRY_CNT_24XX;
@@ -406,6 +410,10 @@ qla27xx_fwdt_entry_t263(struct scsi_qla_host *vha,
 	} else if (ent->t263.queue_type == T263_QUEUE_TYPE_RSP) {
 		for (i = 0; i < vha->hw->max_rsp_queues; i++) {
 			struct rsp_que *rsp = vha->hw->rsp_q_map[i];
+
+			if (!test_bit(i, vha->hw->rsp_qid_map))
+				continue;
+
 			if (rsp || !buf) {
 				length = rsp ?
 				    rsp->length : RESPONSE_ENTRY_CNT_MQ;
@@ -632,6 +640,10 @@ qla27xx_fwdt_entry_t274(struct scsi_qla_host *vha,
 	if (ent->t274.queue_type == T274_QUEUE_TYPE_REQ_SHAD) {
 		for (i = 0; i < vha->hw->max_req_queues; i++) {
 			struct req_que *req = vha->hw->req_q_map[i];
+
+			if (!test_bit(i, vha->hw->req_qid_map))
+				continue;
+
 			if (req || !buf) {
 				qla27xx_insert16(i, buf, len);
 				qla27xx_insert16(1, buf, len);
@@ -643,6 +655,10 @@ qla27xx_fwdt_entry_t274(struct scsi_qla_host *vha,
 	} else if (ent->t274.queue_type == T274_QUEUE_TYPE_RSP_SHAD) {
 		for (i = 0; i < vha->hw->max_rsp_queues; i++) {
 			struct rsp_que *rsp = vha->hw->rsp_q_map[i];
+
+			if (!test_bit(i, vha->hw->rsp_qid_map))
+				continue;
+
 			if (rsp || !buf) {
 				qla27xx_insert16(i, buf, len);
 				qla27xx_insert16(1, buf, len);
-- 
2.5.0
