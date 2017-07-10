From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH v2 2/4] scsi: scsi_dh_alua: print changes to RTPG state of all PGs
Date: Mon, 10 Jul 2017 19:47:35 -0300
Message-ID: <1499726857-7875-3-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.de, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, alua_rtpg() can change the 'state' and 'preferred'
values for the current port group _and_ of other port groups.

However, it reports that _only_ for the current port group.

This might cause uncertainty and confusion when going through
the kernel logs for analyzing/debugging scsi_dh_alua behavior,
which is not helpful during support and development scenarios.

So, print of such changes for all port groups, when it occurs.

It's possible to distinguish between the messages printed for
the current and other PGs by the 'supports' (supported states)
part, which is only printed for the current PG.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

---
v2:
- use lockdep_assert_held() instead of documenting locking conventions
  (Bart Van Assche <Bart.VanAssche@sandisk.com>)
- define two functions (with/without supported states information)
  (Bart Van Assche <Bart.VanAssche@sandisk.com>)
- simplify which device is used for printing the messages
  (use the evaluated scsi device and tell which PG the info is for)
- call the print functions from nearby places
  (right after modifying the PG data)

 drivers/scsi/device_handler/scsi_dh_alua.c | 63 +++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index a1cf3d6aa853..937341ddb767 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -529,6 +529,49 @@ static int alua_tur(struct scsi_device *sdev)
 }
 
 /*
+ * alua_rtpg_print - Print REPORT TARGET GROUP STATES information
+ * 		     (without supported states)
+ * @sdev: the device evaluated (source of information).
+ * @pg: the port group associated with the information.
+ */
+static void alua_rtpg_print(struct scsi_device *sdev,
+			    struct alua_port_group *pg)
+{
+	lockdep_assert_held(&pg->lock);
+
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: port group %02x state %c %s\n",
+		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
+		    pg->pref ? "preferred" : "non-preferred");
+}
+
+/*
+ * alua_rtpg_print_supported - Print REPORT TARGET GROUP STATES information
+ * 			       (with supported states)
+ * @sdev: the device evaluated (source of information).
+ * @pg: the port group associated with the information.
+ * @supported_states: the supported states information.
+ */
+static void alua_rtpg_print_supported(struct scsi_device *sdev,
+				      struct alua_port_group *pg,
+				      int supported_states)
+{
+	lockdep_assert_held(&pg->lock);
+
+	sdev_printk(KERN_INFO, sdev,
+		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
+		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
+		    pg->pref ? "preferred" : "non-preferred",
+		    supported_states & TPGS_SUPPORT_TRANSITION    ? 'T' : 't',
+		    supported_states & TPGS_SUPPORT_OFFLINE       ? 'O' : 'o',
+		    supported_states & TPGS_SUPPORT_LBA_DEPENDENT ? 'L' : 'l',
+		    supported_states & TPGS_SUPPORT_UNAVAILABLE   ? 'U' : 'u',
+		    supported_states & TPGS_SUPPORT_STANDBY       ? 'S' : 's',
+		    supported_states & TPGS_SUPPORT_NONOPTIMIZED  ? 'N' : 'n',
+		    supported_states & TPGS_SUPPORT_OPTIMIZED     ? 'A' : 'a');
+}
+
+/*
  * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
  * @sdev: the device to be evaluated.
  *
@@ -540,7 +583,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
 	struct scsi_sense_hdr sense_hdr;
 	struct alua_port_group *tmp_pg;
-	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
+	int len, k, off, bufflen = ALUA_RTPG_SIZE;
 	unsigned char *desc, *buff;
 	unsigned err, retval;
 	unsigned int tpg_desc_tbl_off;
@@ -674,9 +717,12 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 						h->sdev->access_state = desc[0];
 					}
 					rcu_read_unlock();
+
+					if (tmp_pg == pg)
+						alua_rtpg_print_supported(sdev, tmp_pg, desc[1]);
+					else
+						alua_rtpg_print(sdev, tmp_pg);
 				}
-				if (tmp_pg == pg)
-					valid_states = desc[1];
 				spin_unlock_irqrestore(&tmp_pg->lock, flags);
 			}
 			kref_put(&tmp_pg->kref, release_port_group);
@@ -685,17 +731,6 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	}
 
 	spin_lock_irqsave(&pg->lock, flags);
-	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
-		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
-		    pg->pref ? "preferred" : "non-preferred",
-		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
-		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
-		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
-		    valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
-		    valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
-		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
-		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
 	switch (pg->state) {
 	case SCSI_ACCESS_STATE_TRANSITIONING:
-- 
1.8.3.1
