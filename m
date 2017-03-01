From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] fnic: Ratelimit printks to avoid flooding when vlan is not set by the switch.i
Date: Tue, 28 Feb 2017 16:11:57 -0800
Message-ID: <1488327117-8574-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-7.cisco.com ([173.37.142.94]:48188 "EHLO
        alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdCAD1O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 22:27:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: satishkh@cisco.com, sebaddel@cisco.com, Satish Kharat <satishkh@satishkh.cisco.com>

From: Satish Kharat <satishkh@satishkh.cisco.com>

This is to avoid the log from being filled with vlan discovery
messages when there is no vlan configured on the switch.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic_fcs.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 3b7da66..8d2d86e 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -342,8 +342,11 @@ static void fnic_fcoe_send_vlan_req(struct fnic *fnic)
 
 	fnic_fcoe_reset_vlans(fnic);
 	fnic->set_vlan(fnic, 0);
-	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
-		  "Sending VLAN request...\n");
+
+	if (printk_ratelimit())
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host,
+			  "Sending VLAN request...\n");
+
 	skb = dev_alloc_skb(sizeof(struct fip_vlan));
 	if (!skb)
 		return;
@@ -1313,10 +1316,11 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 
 	spin_lock_irqsave(&fnic->vlans_lock, flags);
 	if (list_empty(&fnic->vlans)) {
-		/* no vlans available, try again */
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-			  "Start VLAN Discovery\n");
 		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
+		/* no vlans available, try again */
+		if (printk_ratelimit())
+			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+				  "Start VLAN Discovery\n");
 		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
 		return;
 	}
@@ -1332,10 +1336,11 @@ void fnic_handle_fip_timer(struct fnic *fnic)
 		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
 		break;
 	case FIP_VLAN_FAILED:
-		/* if all vlans are in failed state, restart vlan disc */
-		FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
-			  "Start VLAN Discovery\n");
 		spin_unlock_irqrestore(&fnic->vlans_lock, flags);
+		/* if all vlans are in failed state, restart vlan disc */
+		if (printk_ratelimit())
+			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+				  "Start VLAN Discovery\n");
 		fnic_event_enq(fnic, FNIC_EVT_START_VLAN_DISC);
 		break;
 	case FIP_VLAN_SENT:
-- 
2.5.5
