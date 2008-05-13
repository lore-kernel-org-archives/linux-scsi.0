From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/10] qla2xxx: Don't depend on mailbox return values while enabling FCE tracing.
Date: Mon, 12 May 2008 22:21:12 -0700
Message-ID: <1210656076-54720-6-git-send-email-andrew.vasquez@qlogic.com>
References: <20080513051948.GN22377@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52305 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbYEMFVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 01:21:24 -0400
In-Reply-To: <20080513051948.GN22377@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Recent firmwares no longer return the 'number of buffers' in
mailbox6.  The original code may result in a potential panic
during a FW-dump process due to the driver misinterpreting the
size of the allocated buffer.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3800876..bf3a6f0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2508,7 +2508,7 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *ha, dma_addr_t fce_dma,
 		if (mb)
 			memcpy(mb, mcp->mb, 8 * sizeof(*mb));
 		if (dwords)
-			*dwords = mcp->mb[6];
+			*dwords = buffers;
 	}
 
 	return rval;
-- 
1.5.5.1.211.g65ea3

