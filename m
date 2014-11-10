From: Hiral Shah <hishah@cisco.com>
Subject: [PATCH 4/5] [SCSI] Fnic: For Standalone C series, "sending VLAN request" message seen even if the link is down
Date: Mon, 10 Nov 2014 12:54:35 -0800
Message-ID: <1415652876-24570-4-git-send-email-hishah@cisco.com>
References: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-5.cisco.com ([173.37.142.92]:63691 "EHLO
	alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaKJVCj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 16:02:39 -0500
In-Reply-To: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Shah <hishah@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

When physical link between standalone C series and switch is down,
the fip timer is not turned off and timer expiration will keep sending
vlan request.

It can be fixed by stopping the fip_timer and
it will be restarted automatically when Link is up.

- Increment fnic version from 1.6.0.14 to 1.6.0.15

Signed-off-by: Hiral Shah <hishah@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Anil Chintalapati <achintal@cisco.com>
---
 drivers/scsi/fnic/fnic.h     | 2 +-
 drivers/scsi/fnic/fnic_fcs.c | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 5336e8d..977960b 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.14"
+#define DRV_VERSION		"1.6.0.15"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index f3984b4..bf0bbd4 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -135,6 +135,11 @@ void fnic_handle_link(struct work_struct *work)
 			fnic->lport->host->host_no, FNIC_FC_LE,
 			"Link Status: UP_DOWN",
 			strlen("Link Status: UP_DOWN"));
+		if (fnic->config.flags & VFCF_FIP_CAPABLE) {
+			FNIC_FCS_DBG(KERN_DEBUG, fnic->lport->host,
+				"deleting fip-timer during link-down\n");
+			del_timer_sync(&fnic->fip_timer);
+		}
 		fcoe_ctlr_link_down(&fnic->ctlr);
 	}
 
-- 
1.8.5.4

