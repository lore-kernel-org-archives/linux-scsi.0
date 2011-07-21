From: <kgudipat@brocade.com>
Subject: [PATCH 04/15] bfa: Check supported speed based on port mode
Date: Wed, 20 Jul 2011 17:01:07 -0700
Message-ID: <1311206467-1018-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56037 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073Ab1GUABe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 20:01:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Added logic to check the loopback test input speed based on port mode.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_svc.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 136f5f9..6e1ed9a 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -5553,11 +5553,29 @@ bfa_fcdiag_loopback(struct bfa_s *bfa, enum bfa_port_opmode opmode,
 		return BFA_STATUS_PORT_NOT_DISABLED;
 	}
 
-	/* Check if the speed is supported */
-	bfa_fcport_get_attr(bfa, &attr);
-	bfa_trc(fcdiag, attr.speed_supported);
-	if (speed > attr.speed_supported)
-		return BFA_STATUS_UNSUPP_SPEED;
+	/*
+	 * Check if input speed is supported by the port mode
+	 */
+	if (bfa_ioc_get_type(&bfa->ioc) == BFA_IOC_TYPE_FC) {
+		if (!(speed == BFA_PORT_SPEED_1GBPS ||
+		      speed == BFA_PORT_SPEED_2GBPS ||
+		      speed == BFA_PORT_SPEED_4GBPS ||
+		      speed == BFA_PORT_SPEED_8GBPS ||
+		      speed == BFA_PORT_SPEED_16GBPS ||
+		      speed == BFA_PORT_SPEED_AUTO)) {
+			bfa_trc(fcdiag, speed);
+			return BFA_STATUS_UNSUPP_SPEED;
+		}
+		bfa_fcport_get_attr(bfa, &attr);
+		bfa_trc(fcdiag, attr.speed_supported);
+		if (speed > attr.speed_supported)
+			return BFA_STATUS_UNSUPP_SPEED;
+	} else {
+		if (speed != BFA_PORT_SPEED_10GBPS) {
+			bfa_trc(fcdiag, speed);
+			return BFA_STATUS_UNSUPP_SPEED;
+		}
+	}
 
 	/* For Mezz card, port speed entered needs to be checked */
 	if (bfa_mfg_is_mezz(bfa->ioc.attr->card_type)) {
-- 
1.7.3.rc1

