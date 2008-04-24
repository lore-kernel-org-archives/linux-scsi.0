From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 02/10] qla2xxx: Wakeup DPC thread to process any deferred-work requests.
Date: Thu, 24 Apr 2008 15:21:23 -0700
Message-ID: <1209075691-6539-2-git-send-email-andrew.vasquez@qlogic.com>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20337 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465AbYDXWVc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:21:32 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8b33b16..978d8bd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2599,6 +2599,10 @@ qla2x00_timer(scsi_qla_host_t *ha)
 		start_dpc++;
 	}
 
+	/* Process any deferred work. */
+	if (!list_empty(&ha->work_list))
+		start_dpc++;
+
 	/* Schedule the DPC routine if needed */
 	if ((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) ||
 	    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) ||
-- 
1.5.5.1.67.gbdb8

