From: madhu.iyengar@qlogic.com
Subject: [PATCH 05/12] qla2xxx: Group CS_RESET return status with other link level event statuses.
Date: Fri, 15 Oct 2010 11:27:42 -0700
Message-ID: <1287167269-8034-6-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36959 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756189Ab0JOSg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:28 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

Currently when we receive a CS_RESET as a response for a SCSI command the
driver will return DID_TRANSPORT_DISRUPTED back to the SCSI mid-layer.  There
are certain circumstances where this could cause the mid-layer to exhaust all of
its retries if the FC port goes away for a short time.  This will result in
commands being prematurly failed.  Moving the CS_RESET return code to be
grouped with other link level events will cause the FC transport layer to block
that target's queue thus preventing the premature exhaustion of retries.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e0e43d9..55870a3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1757,6 +1757,8 @@ check_scsi_status:
 	case CS_INCOMPLETE:
 	case CS_PORT_UNAVAILABLE:
 	case CS_TIMEOUT:
+	case CS_RESET:
+
 		/*
 		 * We are going to have the fc class block the rport
 		 * while we try to recover so instruct the mid layer
@@ -1781,10 +1783,6 @@ check_scsi_status:
 			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
 		break;
 
-	case CS_RESET:
-		cp->result = DID_TRANSPORT_DISRUPTED << 16;
-		break;
-
 	case CS_ABORTED:
 		cp->result = DID_RESET << 16;
 		break;
-- 
1.6.0.2

