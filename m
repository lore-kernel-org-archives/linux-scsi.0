From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/4] qla2xxx: Properly handle Vport state-change-notifications.
Date: Mon, 12 Nov 2007 10:30:59 -0800
Message-ID: <1194892260-27318-3-git-send-email-andrew.vasquez@qlogic.com>
References: <20071112182950.GC20765@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33202 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXKLSbW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2007 13:31:22 -0500
In-Reply-To: <20071112182950.GC20765@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Shyam Sundar <shyam.sundar@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

Drivers do SCRs for each Vport. When something changes in the
fabric, firmware generates one interrupt for each RSCN. Based on
the current implementation, in each case, we make recursive calls
to handle RSCN for physical and each subsequent virtual ports.
The fix is to also take into consideration the vp_idx, which is
set by the firmware to indicate the vport the RSCN was meant for.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 343af39..798b7e8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -575,12 +575,15 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		/* Check if the Vport has issued a SCR */
 		if (ha->parent && test_bit(VP_SCR_NEEDED, &ha->vp_flags))
 			break;
+		/* Only handle SCNs for our Vport index. */
+		if (ha->flags.npiv_supported && ha->vp_idx != mb[3])
+			break;
 
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
 		    ha->host_no));
 		DEBUG(printk(KERN_INFO
-		    "scsi(%ld): RSCN database changed -- %04x %04x.\n",
-		    ha->host_no, mb[1], mb[2]));
+		    "scsi(%ld): RSCN database changed -- %04x %04x %04x.\n",
+		    ha->host_no, mb[1], mb[2], mb[3]));
 
 		rscn_entry = (mb[1] << 16) | mb[2];
 		host_pid = (ha->d_id.b.domain << 16) | (ha->d_id.b.area << 8) |
-- 
1.5.3.5.643.g40e25

