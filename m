From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/2] IB/srp: Fix SCSI scanning
Date: Sun, 19 Jun 2011 13:48:24 +0200
Message-ID: <201106191348.24122.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:40313 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1FSLsd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2011 07:48:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Roland Dreier <roland@purestorage.com>, David Dillow <dillowda@ornl.gov>

Avoid that SCSI scanning triggers creation of targets with non-zero
channel or non-zero id.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: David Dillow <dillowda@ornl.gov>
Cc: <stable@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ee165fd..de4fd32 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -110,6 +110,11 @@ static const char *srp_target_info(struct Scsi_Host *host)
 	return host_to_target(host)->target_name;
 }
 
+static int srp_target_alloc(struct scsi_target *starget)
+{
+	return starget->channel == 0 && starget->id == 0 ? 0 : -ENODEV;
+}
+
 static int srp_target_is_topspin(struct srp_target_port *target)
 {
 	static const u8 topspin_oui[3] = { 0x00, 0x05, 0xad };
@@ -1836,6 +1841,7 @@ static struct scsi_host_template srp_template = {
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
 	.info				= srp_target_info,
+	.target_alloc			= srp_target_alloc,
 	.queuecommand			= srp_queuecommand,
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
-- 
1.7.3.4

