From: michaelc@cs.wisc.edu
Subject: [PATCH 2/2] iscsi: return data transfer residual for data-out commands
Date: Wed, 14 Nov 2007 14:38:43 -0600
Message-ID: <1195072726529-git-send-email-michaelc@cs.wisc.edu>
References: <1195072723101-git-send-email-michaelc@cs.wisc.edu>
 <1195072725716-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764746AbXKNUiw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2007 15:38:52 -0500
In-Reply-To: <1195072725716-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tony Battersby <tonyb@cybernetics.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Tony Battersby <tonyb@cybernetics.com>

Currently, the iSCSI driver returns the data transfer residual for
data-in commands (e.g. read) but not data-out commands (e.g. write).
This patch makes it return the data transfer residual for both types of
commands.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index efceed4..8b57af5 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -291,9 +291,6 @@ invalid_datalen:
 			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
 	}
 
-	if (sc->sc_data_direction == DMA_TO_DEVICE)
-		goto out;
-
 	if (rhdr->flags & ISCSI_FLAG_CMD_UNDERFLOW) {
 		int res_count = be32_to_cpu(rhdr->residual_count);
 
-- 
1.5.1.2

