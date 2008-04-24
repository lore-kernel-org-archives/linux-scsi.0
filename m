From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/10] qla2xxx: Correct ISP84XX verify-chip response handling.
Date: Thu, 24 Apr 2008 15:21:24 -0700
Message-ID: <1209075691-6539-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20337 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbYDXWVd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:21:33 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Earlier code could trigger an infinite-retry if 1st invocation
returned a non-CS_COMPLETE status.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7d0a8a4..a9cb829 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2982,8 +2982,8 @@ qla84xx_verify_chip(struct scsi_qla_host *ha, uint16_t *status)
 	/* We update the firmware with only one data sequence. */
 	options |= VCO_END_OF_DATA;
 
-	retry = 0;
 	do {
+		retry = 0;
 		memset(mn, 0, sizeof(*mn));
 		mn->p.req.entry_type = VERIFY_CHIP_IOCB_TYPE;
 		mn->p.req.entry_count = 1;
-- 
1.5.5.1.67.gbdb8

