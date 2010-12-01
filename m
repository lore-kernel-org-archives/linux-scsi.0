From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/27] libfc: fix stats computation in fc_queuecommand()
Date: Tue, 30 Nov 2010 16:18:33 -0800
Message-ID: <20101201001833.18369.25364.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5175 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0LAASe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:34 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

There seems accumulation needed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index e82ff6e..eb3fe37 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1820,11 +1820,11 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		fsp->req_flags = FC_SRB_READ;
 		stats->InputRequests++;
-		stats->InputMegabytes = fsp->data_len;
+		stats->InputMegabytes += fsp->data_len;
 	} else if (sc_cmd->sc_data_direction == DMA_TO_DEVICE) {
 		fsp->req_flags = FC_SRB_WRITE;
 		stats->OutputRequests++;
-		stats->OutputMegabytes = fsp->data_len;
+		stats->OutputMegabytes += fsp->data_len;
 	} else {
 		fsp->req_flags = 0;
 		stats->ControlRequests++;

