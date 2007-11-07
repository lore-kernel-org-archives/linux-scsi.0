From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] iscsi: return data transfer residual for data-out
 commands
Date: Wed, 07 Nov 2007 13:06:28 -0500
Message-ID: <4731FEA4.5040206@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:1702 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757889AbXKGSG1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 13:06:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

Currently, the iSCSI driver returns the data transfer residual for
data-in commands (e.g. read) but not data-out commands (e.g. write).
This patch makes it return the data transfer residual for both types of
commands.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.24-rc2/drivers/scsi/libiscsi.c.orig	2007-11-07 12:52:20.000000000 -0500
+++ linux-2.6.24-rc2/drivers/scsi/libiscsi.c	2007-11-07 12:52:27.000000000 -0500
@@ -291,9 +291,6 @@ invalid_datalen:
 			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
 	}
 
-	if (sc->sc_data_direction == DMA_TO_DEVICE)
-		goto out;
-
 	if (rhdr->flags & ISCSI_FLAG_CMD_UNDERFLOW) {
 		int res_count = be32_to_cpu(rhdr->residual_count);
 


