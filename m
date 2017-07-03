From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: isci: fix typo in function names
Date: Mon,  3 Jul 2017 11:17:27 +0100
Message-ID: <20170703101727.12600-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a couple of typos in function names and spelling of request
where the letters u and e are swapped:

scu_ssp_reqeust_construct_task_context
scu_sata_reqeust_construct_task_context

Fix the spelling of request.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/isci/request.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 47f66e949745..ed197bc8e801 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -213,7 +213,7 @@ static void sci_task_request_build_ssp_task_iu(struct isci_request *ireq)
  * @task_context:
  *
  */
-static void scu_ssp_reqeust_construct_task_context(
+static void scu_ssp_request_construct_task_context(
 	struct isci_request *ireq,
 	struct scu_task_context *task_context)
 {
@@ -425,7 +425,7 @@ static void scu_ssp_io_request_construct_task_context(struct isci_request *ireq,
 	u8 prot_type = scsi_get_prot_type(scmd);
 	u8 prot_op = scsi_get_prot_op(scmd);
 
-	scu_ssp_reqeust_construct_task_context(ireq, task_context);
+	scu_ssp_request_construct_task_context(ireq, task_context);
 
 	task_context->ssp_command_iu_length =
 		sizeof(struct ssp_cmd_iu) / sizeof(u32);
@@ -472,7 +472,7 @@ static void scu_ssp_task_request_construct_task_context(struct isci_request *ire
 {
 	struct scu_task_context *task_context = ireq->tc;
 
-	scu_ssp_reqeust_construct_task_context(ireq, task_context);
+	scu_ssp_request_construct_task_context(ireq, task_context);
 
 	task_context->control_frame                = 1;
 	task_context->priority                     = SCU_TASK_PRIORITY_HIGH;
@@ -495,7 +495,7 @@ static void scu_ssp_task_request_construct_task_context(struct isci_request *ire
  * the command buffer is complete. none Revisit task context construction to
  * determine what is common for SSP/SMP/STP task context structures.
  */
-static void scu_sata_reqeust_construct_task_context(
+static void scu_sata_request_construct_task_context(
 	struct isci_request *ireq,
 	struct scu_task_context *task_context)
 {
@@ -562,7 +562,7 @@ static void scu_stp_raw_request_construct_task_context(struct isci_request *ireq
 {
 	struct scu_task_context *task_context = ireq->tc;
 
-	scu_sata_reqeust_construct_task_context(ireq, task_context);
+	scu_sata_request_construct_task_context(ireq, task_context);
 
 	task_context->control_frame         = 0;
 	task_context->priority              = SCU_TASK_PRIORITY_NORMAL;
@@ -613,7 +613,7 @@ static void sci_stp_optimized_request_construct(struct isci_request *ireq,
 	struct scu_task_context *task_context = ireq->tc;
 
 	/* Build the STP task context structure */
-	scu_sata_reqeust_construct_task_context(ireq, task_context);
+	scu_sata_request_construct_task_context(ireq, task_context);
 
 	/* Copy over the SGL elements */
 	sci_request_build_sgl(ireq);
@@ -1401,7 +1401,7 @@ static enum sci_status sci_stp_request_pio_data_out_transmit_data(struct isci_re
  * @data_buffer: The buffer of data to be copied.
  * @length: The length of the data transfer.
  *
- * Copy the data from the buffer for the length specified to the IO reqeust SGL
+ * Copy the data from the buffer for the length specified to the IO request SGL
  * specified data region. enum sci_status
  */
 static enum sci_status
-- 
2.11.0
