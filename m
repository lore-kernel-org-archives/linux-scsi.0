From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH 5/6] scsi: megaraid_sas - return sync cache call with
	success
Date: Wed, 14 Feb 2007 13:00:55 -0800
Message-ID: <1171486855.4188.33.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48825 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964829AbXBOCK2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Feb 2007 21:10:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com


FW does not support SYNCHRONIZE_CACHE cmd. FW flush cache on its own.
So, we just return success from the megasas_queue_command.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

 drivers/scsi/megaraid/megaraid_sas.c |   12 ++++++++++++
 1 files changed, 12 insertions(+)

diff -uprN linux-feb13-new-p4/drivers/scsi/megaraid/megaraid_sas.c linux-feb13-new-p5/drivers/scsi/megaraid/megaraid_sas.c
--- linux-feb13-new-p4/drivers/scsi/megaraid/megaraid_sas.c	2007-02-14 04:34:31.000000000 -0800
+++ linux-feb13-new-p5/drivers/scsi/megaraid/megaraid_sas.c	2007-02-14 05:19:30.000000000 -0800
@@ -857,6 +857,18 @@ megasas_queue_command(struct scsi_cmnd *
 		goto out_done;
 	}
 
+	switch (scmd->cmnd[0]) {
+		case SYNCHRONIZE_CACHE:
+			/*
+			 * FW takes care of flush cache on its own
+			 * No need to send it down
+			 */
+			scmd->result = DID_OK << 16;
+			goto out_done;
+		default:
+			break;
+	}
+
 	/* Check if we can accept cmds */
 	if (instance->is_busy) {
 		sec = (jiffies - instance->last_time) / HZ;


