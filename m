From: madhu.iyengar@qlogic.com
Subject: [PATCH 4/4] qla2xxx: Fix virtual port failing to login after chip reset.
Date: Tue, 10 May 2011 11:18:18 -0700
Message-ID: <1305051498-16718-5-git-send-email-madhu.iyengar@qlogic.com>
References: <1305051498-16718-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:38283 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751535Ab1EJSYf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2011 14:24:35 -0400
In-Reply-To: <1305051498-16718-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

This patch ensures qla82xx_watchdog is not being run for the vport. It also
makes sure that beacon ON is not done for the vport, as it will lead to the
waking up of the dpc thread again and again.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e1efbc7..010f560 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3628,7 +3628,8 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	if (!pci_channel_offline(ha->pdev))
 		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
 
-	if (IS_QLA82XX(ha)) {
+	/* Make sure qla82xx_watchdog is run only for physical port */
+	if (!vha->vp_idx && IS_QLA82XX(ha)) {
 		if (test_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags))
 			start_dpc++;
 		qla82xx_watchdog(vha);
@@ -3709,8 +3710,8 @@ qla2x00_timer(scsi_qla_host_t *vha)
 		    atomic_read(&vha->loop_down_timer)));
 	}
 
-	/* Check if beacon LED needs to be blinked */
-	if (ha->beacon_blink_led == 1) {
+	/* Check if beacon LED needs to be blinked for physical host only */
+	if (!vha->vp_idx && (ha->beacon_blink_led == 1)) {
 		set_bit(BEACON_BLINK_NEEDED, &vha->dpc_flags);
 		start_dpc++;
 	}
-- 
1.6.0.2

