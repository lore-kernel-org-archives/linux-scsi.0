From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/2] [SCSI] ibmvscsi: Fix SCSI scanning
Date: Sun, 19 Jun 2011 13:48:40 +0200
Message-ID: <201106191348.40759.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:40335 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1FSLsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2011 07:48:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Brian King <brking@linux.vnet.ibm.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>

Avoid that SCSI scanning triggers creation of targets with a non-zero
channel number.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: <stable@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

Note: this patch hasn't been tested yet.

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 3d391dc..c31adf5 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -498,6 +498,11 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 }
 
+static int ibmvscsi_target_alloc(struct scsi_target *starget)
+{
+	return starget->channel == 0 ? 0 : -ENODEV;
+}
+
 /**
  * ibmvscsi_reset_host - Reset the connection to the server
  * @hostdata:	struct ibmvscsi_host_data to reset
@@ -1803,6 +1808,7 @@ static struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IBM POWER Virtual SCSI Adapter " IBMVSCSI_VERSION,
 	.proc_name = "ibmvscsi",
+	.target_alloc = ibmvscsi_target_alloc,
 	.queuecommand = ibmvscsi_queuecommand,
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
-- 
1.7.3.4

