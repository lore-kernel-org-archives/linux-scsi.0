From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v2 3/4] scsi: scsi_dh_alua: do not print RTPG state if it remains unavailable/standby
Date: Mon, 10 Jul 2017 19:47:36 -0300
Message-ID: <1499726857-7875-4-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.de, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Path checkers will check paths of a port group in unavailable/standby
state more frequently (as they are 'failed') - possibly for a long or
indefinite period of time, and/or for a large number of paths.

That might flood the kernel log with scsi_dh_alua RTPG state messages,
due to the recheck scheduled in alua_check_sense() to update PG state.

So, do not to print such message if unavailable/standby state remains
(i.e., the PG did not transition to/from such states). All other cases
continue to be printed.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

---
v2:
- changed v1's alua_state_remains() into alua_rtpg_print_check(),
  which includes in the states (not) to print for (deduplicates code).
- added support for Standby state too (requested in patch 1 of this set)
  (Bart Van Assche <Bart.VanAssche@sandisk.com>)
- remove superfluous parentheses in return statement.
  (Bart Van Assche <Bart.VanAssche@sandisk.com>)
- remove likely() hint
  (Bart Van Assche <Bart.VanAssche@sandisk.com>)

 drivers/scsi/device_handler/scsi_dh_alua.c | 35 ++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 937341ddb767..e0bf0827a980 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -572,6 +572,30 @@ static void alua_rtpg_print_supported(struct scsi_device *sdev,
 }
 
 /*
+ * alua_rtpg_print_check - Whether to print RTPG state information
+ * 			   on particular state transitions.
+ * @old_state: the old state value.
+ * @new_state: the new state value.
+ */
+static bool alua_rtpg_print_check(int old_state, int new_state)
+{
+	/*
+	 * Do not print RTPG state information in case
+	 * state remains either unavailable or standby.
+	 *
+	 * Print it for everything else.
+	 */
+
+	switch (old_state) {
+	case SCSI_ACCESS_STATE_UNAVAILABLE:
+	case SCSI_ACCESS_STATE_STANDBY:
+		return old_state != new_state;
+	default:
+		return 1;
+	}
+}
+
+/*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
  * @sdev: the device to be evaluated.
  *
@@ -706,6 +730,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 				if ((tmp_pg == pg) ||
 				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
 					struct alua_dh_data *h;
+					int tmp_pg_state_orig = tmp_pg->state;
 
 					tmp_pg->state = desc[0] & 0x0f;
 					tmp_pg->pref = desc[0] >> 7;
@@ -718,10 +743,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 					}
 					rcu_read_unlock();
 
-					if (tmp_pg == pg)
-						alua_rtpg_print_supported(sdev, tmp_pg, desc[1]);
-					else
-						alua_rtpg_print(sdev, tmp_pg);
+					if (alua_rtpg_print_check(tmp_pg_state_orig, tmp_pg->state)) {
+						if (tmp_pg == pg)
+							alua_rtpg_print_supported(sdev, tmp_pg, desc[1]);
+						else
+							alua_rtpg_print(sdev, tmp_pg);
+					}
 				}
 				spin_unlock_irqrestore(&tmp_pg->lock, flags);
 			}
-- 
1.8.3.1
