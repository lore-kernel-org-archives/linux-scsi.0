From: Nicholas Krause <uboot477@gmail.com>
Subject: [PATCH] csiostor:Fix error handling in the function csio_hws_ready
Date: Tue,  4 Aug 2015 22:42:06 -0400
Message-ID: <1438742526-28530-1-git-send-email-uboot477@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: davem@davemloft.net, hariprasad@chelsio.com, praveenm@chelsio.com, thenzl@redhat.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicholas Krause <xerofoify@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Krause <xerofoify@gmail.com>

This fixes error handling in the function csio_hws_ready for when
this function calls csio_scim_cleanup_io to cleanup outstanding
commands by checking if it cleaned a error code to signal internal
failure and if so tell the user we are unable to clean up the
outstanding io commands by printing this to the console before

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/scsi/csiostor/csio_hw.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 622bdab..49c47d3 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -2445,11 +2445,17 @@ csio_hws_ready(struct csio_hw *hw, enum csio_hw_ev evt)
 		csio_set_state(&hw->sm, csio_hws_quiescing);
 		/* cleanup all outstanding cmds */
 		if (evt == CSIO_HWE_HBA_RESET ||
-		    evt == CSIO_HWE_PCIERR_DETECTED)
-			csio_scsim_cleanup_io(csio_hw_to_scsim(hw), false);
-		else
-			csio_scsim_cleanup_io(csio_hw_to_scsim(hw), true);
-
+		    evt == CSIO_HWE_PCIERR_DETECTED) {
+			if (csio_scsim_cleanup_io(csio_hw_to_scsim(hw), false)) {
+				csio_err(hw, "Unable to properly cleanup outstanding commands on this device\n");
+				return;
+			}
+		} else {
+			if (csio_scsim_cleanup_io(csio_hw_to_scsim(hw), true)) {
+				csio_err(hw, "Unable to properly cleanup outstanding commands on this device\n");
+				return;
+			}
+		}
 		csio_hw_intr_disable(hw);
 		csio_hw_mbm_cleanup(hw);
 		csio_evtq_stop(hw);
-- 
2.1.4
