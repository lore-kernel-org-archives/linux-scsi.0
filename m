From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 18/21] qla2xxx: Check DFLG_NO_CABLE only on physical port.
Date: Thu,  3 Apr 2008 13:13:29 -0700
Message-ID: <1207253612-15538-18-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761729AbYDCUNp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:45 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

As there is no actual cable connection on vports, made change so
that the driver checks DFLG_NO_CABLE against ha->device_flags
only for physical port.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4c50b9b..8b33b16 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2577,7 +2577,8 @@ qla2x00_timer(scsi_qla_host_t *ha)
 			set_bit(RESTART_QUEUES_NEEDED, &ha->dpc_flags);
 			start_dpc++;
 
-			if (!(ha->device_flags & DFLG_NO_CABLE)) {
+			if (!(ha->device_flags & DFLG_NO_CABLE) &&
+			    !ha->parent) {
 				DEBUG(printk("scsi(%ld): Loop down - "
 				    "aborting ISP.\n",
 				    ha->host_no));
-- 
1.5.5.rc2

