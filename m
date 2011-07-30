From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/9] isci: fix sata response handling
Date: Fri, 29 Jul 2011 17:16:40 -0700
Message-ID: <20110730001639.28430.56963.stgit@localhost6.localdomain6>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab1G3AQk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 20:16:40 -0400
In-Reply-To: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: stable@kernel.org, linux-scsi@vger.kernel.org

A bug (likely copy/paste) that has been carried from the original
implementation.  The unsolicited frame handling structure returns the
d2h fis in the isci_request.stp.rsp buffer.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/request.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index a46e07a..b4cf998 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2399,22 +2399,19 @@ static void isci_task_save_for_upper_layer_completion(
 	}
 }
 
-static void isci_request_process_stp_response(struct sas_task *task,
-					      void *response_buffer)
+static void isci_process_stp_response(struct sas_task *task, struct dev_to_host_fis *fis)
 {
-	struct dev_to_host_fis *d2h_reg_fis = response_buffer;
 	struct task_status_struct *ts = &task->task_status;
 	struct ata_task_resp *resp = (void *)&ts->buf[0];
 
-	resp->frame_len = le16_to_cpu(*(__le16 *)(response_buffer + 6));
-	memcpy(&resp->ending_fis[0], response_buffer + 16, 24);
+	resp->frame_len = sizeof(*fis);
+	memcpy(resp->ending_fis, fis, sizeof(*fis));
 	ts->buf_valid_size = sizeof(*resp);
 
-	/**
-	 * If the device fault bit is set in the status register, then
+	/* If the device fault bit is set in the status register, then
 	 * set the sense data and return.
 	 */
-	if (d2h_reg_fis->status & ATA_DF)
+	if (fis->status & ATA_DF)
 		ts->stat = SAS_PROTO_RESPONSE;
 	else
 		ts->stat = SAM_STAT_GOOD;
@@ -2428,7 +2425,6 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 {
 	struct sas_task *task = isci_request_access_task(request);
 	struct ssp_response_iu *resp_iu;
-	void *resp_buf;
 	unsigned long task_flags;
 	struct isci_remote_device *idev = isci_lookup_device(task->dev);
 	enum service_response response       = SAS_TASK_UNDELIVERED;
@@ -2565,9 +2561,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 				task);
 
 			if (sas_protocol_ata(task->task_proto)) {
-				resp_buf = &request->stp.rsp;
-				isci_request_process_stp_response(task,
-								  resp_buf);
+				isci_process_stp_response(task, &request->stp.rsp);
 			} else if (SAS_PROTOCOL_SSP == task->task_proto) {
 
 				/* crack the iu response buffer. */

