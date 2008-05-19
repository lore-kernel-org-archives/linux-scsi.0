From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/3] qla2xxx: Revert "qla2xxx: Use proper HA during asynchronous event handling."
Date: Mon, 19 May 2008 14:25:39 -0700
Message-ID: <1211232341-44818-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080519212418.GH42403@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52429 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760518AbYESVZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 17:25:44 -0400
In-Reply-To: <20080519212418.GH42403@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

This reverts commit bd2a1846b2313e32d0270151a31a6b8335384a20.
The original (prior to the reverted commit) code was correct.
Additionally, the vp_idx should be checked during MBA_PORT_UPDATE
in order for proper handling to take place for a given vport.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   36 ++++++++++--------------------------
 1 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 14bcd7c..ec63b79 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -272,8 +272,6 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 	uint32_t	rscn_entry, host_pid;
 	uint8_t		rscn_queue_index;
 	unsigned long	flags;
-	scsi_qla_host_t	*vha;
-	int		i;
 
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
@@ -544,18 +542,10 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_PORT_UPDATE:		/* Port database update */
-		if ((ha->flags.npiv_supported) && (ha->num_vhosts)) {
-			for_each_mapped_vp_idx(ha, i) {
-				list_for_each_entry(vha, &ha->vp_list,
-				    vp_list) {
-					if ((mb[3] & 0xff)
-					    == vha->vp_idx) {
-						ha = vha;
-						break;
-					}
-				}
-			}
-		}
+		/* Only handle SCNs for our Vport index. */
+		if (ha->parent && ha->vp_idx != (mb[3] & 0xff))
+			break;
+
 		/*
 		 * If PORT UPDATE is global (recieved LIP_OCCURED/LIP_RESET
 		 * event etc. earlier indicating loop is down) then process
@@ -590,18 +580,12 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_RSCN_UPDATE:		/* State Change Registration */
-		if ((ha->flags.npiv_supported) && (ha->num_vhosts)) {
-			for_each_mapped_vp_idx(ha, i) {
-				list_for_each_entry(vha, &ha->vp_list,
-				    vp_list) {
-					if ((mb[3] & 0xff)
-					    == vha->vp_idx) {
-						ha = vha;
-						break;
-					}
-				}
-			}
-		}
+		/* Check if the Vport has issued a SCR */
+		if (ha->parent && test_bit(VP_SCR_NEEDED, &ha->vp_flags))
+			break;
+		/* Only handle SCNs for our Vport index. */
+		if (ha->parent && ha->vp_idx != (mb[3] & 0xff))
+			break;
 
 		DEBUG2(printk("scsi(%ld): Asynchronous RSCR UPDATE.\n",
 		    ha->host_no));
-- 
1.5.5.1.316.g377d9

