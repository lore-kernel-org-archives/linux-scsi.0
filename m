From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 01/23] qla2xxx: Correct race in loop_state assignment during reset handling.
Date: Fri,  8 Feb 2013 01:57:42 -0500
Message-ID: <1360306684-8286-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:2544 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759894Ab3BHHTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:09 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

There's a subtle race in the loop/bus-reset handling whereby a
VHA's loop-state can get incorrectly set to 'down' after the
loop-reset and firmware's completion of link re-negotiation.  The
original code incorrectly assumes that firmware AENs would arrive
only after mailbox-command execution to initiate the link-flap.

Here's a good case with the old code (AENs arrive after
mailbox-command completion):

	qla2xxx [0000:03:00.1]-8012:91: BUS RESET ISSUED nexus=91:0:4.
	qla2xxx [0000:03:00.1]-287d:91: FCPort state transitioned from ONLINE to LOST - portid=010100.
	qla2xxx [0000:03:00.1]-580e:91: Asynchronous P2P MODE received.
	qla2xxx [0000:03:00.1]-287d:91: FCPort state transitioned from ONLINE to LOST - portid=010400.
	qla2xxx [0000:03:00.1]-802b:91: BUS RESET SUCCEEDED nexus=91:0:4.
	qla2xxx [0000:03:00.1]-480b:91: Reset marker scheduled.
	qla2xxx [0000:03:00.1]-5812:91: Port database changed ffff 0006 0000.
	qla2xxx [0000:03:00.1]-505f:91: Link is operational (4 Gbps).
	qla2xxx [0000:03:00.1]-480c:91: Reset marker end.
	qla2xxx [0000:03:00.1]-480f:91: Loop resync scheduled.
	qla2xxx [0000:03:00.1]-8837:91: F/W Ready - OK.
	qla2xxx [0000:03:00.1]-883a:91: fw_state=3 (7, 0, 0, 0) curr time=170b8f315.
	qla2xxx [0000:03:00.1]-280e:91: HBA in F P2P topology.
	qla2xxx [0000:03:00.1]-2812:91: qla2x00_configure_hba success
	qla2xxx [0000:03:00.1]-2814:91: Configure loop -- dpc flags = 0x5260.

notice how the 'Port database changed' (8014) arrived after the
bus-reset handler completed 'BUS RESET SUCCEEDED'.

Now, here's a failing case with the old code (AENs arrive before
mailbox-command completion):

	qla2xxx [0000:03:00.1]-8012:91: BUS RESET ISSUED nexus=91:0:0.
	qla2xxx [0000:03:00.1]-580e:91: Asynchronous P2P MODE received.
	qla2xxx [0000:03:00.1]-287d:91: FCPort state transitioned from ONLINE to LOST - portid=010100.
	qla2xxx [0000:03:00.1]-287d:91: FCPort state transitioned from ONLINE to LOST - portid=010400.
	qla2xxx [0000:03:00.1]-4800:91: DPC handler sleeping.
	qla2xxx [0000:03:00.1]-5812:91: Port database changed ffff 0006 0000.
	qla2xxx [0000:03:00.1]-505f:91: Link is operational (4 Gbps).
	qla2xxx [0000:03:00.1]-802b:91: BUS RESET SUCCEEDED nexus=91:0:0.
	qla2xxx [0000:03:00.1]-480b:91: Reset marker scheduled.
	qla2xxx [0000:03:00.1]-480c:91: Reset marker end.
	qla2xxx [0000:03:00.1]-480f:91: Loop resync scheduled.
	qla2xxx [0000:03:00.1]-8837:91: F/W Ready - OK.
	qla2xxx [0000:03:00.1]-883a:91: fw_state=3 (7, 0, 0, 0) curr time=170be9eb2.
	qla2xxx [0000:03:00.1]-280e:91: HBA in F P2P topology.
	qla2xxx [0000:03:00.1]-2812:91: qla2x00_configure_hba success
	qla2xxx [0000:03:00.1]-2814:91: Configure loop -- dpc flags = 0x5260.
	qla2xxx [0000:03:00.1]-281e:91: Needs RSCN update and loop transition.
	qla2xxx [0000:03:00.1]-286a:91: qla2x00_configure_loop *** FAILED ***.
	qla2xxx [0000:03:00.1]-4810:91: Loop resync end.
	qla2xxx [0000:03:00.1]-4800:91: DPC handler sleeping.

This race would ultimately lead to devices go unexpectedly
offline until another link-flap or chip-reset would cause driver
re-discovery to take place.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2d2afdb..0612d25 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1305,14 +1305,14 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	}
 
 	if (ha->flags.enable_lip_full_login && !IS_CNA_CAPABLE(ha)) {
+		atomic_set(&vha->loop_state, LOOP_DOWN);
+		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
+		qla2x00_mark_all_devices_lost(vha, 0);
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
 			ql_dbg(ql_dbg_taskm, vha, 0x802d,
 			    "full_login_lip=%d.\n", ret);
 		}
-		atomic_set(&vha->loop_state, LOOP_DOWN);
-		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
-		qla2x00_mark_all_devices_lost(vha, 0);
 	}
 
 	if (ha->flags.enable_lip_reset) {
-- 
1.7.7

