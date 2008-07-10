From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/18] qla2xxx: Correct vport management of MBA_PORT_UPDATE.
Date: Thu, 10 Jul 2008 16:55:57 -0700
Message-ID: <1215734163-40825-12-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbYGJX4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:08 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

By allowing the qla2x00_alert_all_vps() to manage per-vport
recognition of the MBA.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ec63b79..874d802 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -542,10 +542,6 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_PORT_UPDATE:		/* Port database update */
-		/* Only handle SCNs for our Vport index. */
-		if (ha->parent && ha->vp_idx != (mb[3] & 0xff))
-			break;
-
 		/*
 		 * If PORT UPDATE is global (recieved LIP_OCCURED/LIP_RESET
 		 * event etc. earlier indicating loop is down) then process
-- 
1.5.6.2.292.ga9a3

