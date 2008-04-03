From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 19/21] qla2xxx: Use proper HA during asynchrounous event handling.
Date: Thu,  3 Apr 2008 13:13:30 -0700
Message-ID: <1207253612-15538-19-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbYDCUNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:47 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

Changes are added to the driver so that it can behave properly
upon having asynchronous events, for example, addition of target
devices to the VPs.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 360af4e..285479b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -272,6 +272,8 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 	uint32_t	rscn_entry, host_pid;
 	uint8_t		rscn_queue_index;
 	unsigned long	flags;
+	scsi_qla_host_t	*vha;
+	int		i;
 
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
@@ -542,6 +544,18 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_PORT_UPDATE:		/* Port database update */
+		if ((ha->flags.npiv_supported) && (ha->num_vhosts)) {
+			for_each_mapped_vp_idx(ha, i) {
+				list_for_each_entry(vha, &ha->vp_list,
+				    vp_list) {
+					if ((mb[3] & 0xff)
+					    == vha->vp_idx) {
+						ha = vha;
+						break;
+					}
+				}
+			}
+		}
 		/*
 		 * If PORT UPDATE is global (recieved LIP_OCCURED/LIP_RESET
 		 * event etc. earlier indicating loop is down) then process
@@ -576,12 +590,18 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
-		/* Check if the Vport has issued a SCR */
-		if (ha->parent && test_bit(VP_SCR_NEEDED, &ha->vp_flags))
-			break;
-		/* Only handle SCNs for our Vport index. */
-		if (ha->flags.npiv_supported && ha->vp_idx != mb[3])
-			break;
+		if ((ha->flags.npiv_supported) && (ha->num_vhosts)) {
+			for_each_mapped_vp_idx(ha, i) {
+				list_for_each_entry(vha, &ha->vp_list,
+				    vp_list) {
+					if ((mb[3] & 0xff)
+					    == vha->vp_idx) {
+						ha = vha;
+						break;
+					}
+				}
+			}
+		}
 
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
 		    ha->host_no));
-- 
1.5.5.rc2

