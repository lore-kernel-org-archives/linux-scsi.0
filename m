From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/20] qla2xxx: Add notification message when an NPIV fails to acquire a port-id.
Date: Wed,  3 Jun 2009 09:55:23 -0700
Message-ID: <1244048131-56590-13-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbZFCQzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:35 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b32eb69..df919c0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2753,8 +2753,11 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		if (vp_idx == 0)
 			return;
 
-		if (MSB(stat) == 1)
+		if (MSB(stat) == 1) {
+			DEBUG2(printk("scsi(%ld): Could not acquire ID for "
+			    "VP[%d].\n", vha->host_no, vp_idx));
 			return;
+		}
 
 		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list)
 			if (vp_idx == vp->vp_idx)
-- 
1.6.3.1.244.gf9275

