From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Thu, 20 Feb 2014 15:44:26 -0500
Message-ID: <1392929071-16555-5-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1392929071-16555-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: laijs@cn.fujitsu.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
and a nasty surprise in terms of reentrancy guarantee as workqueue
considers work items to be different if they don't have the same work
function.

firewire core-device and sbp2 have been been multiplexing work items
with multiple work functions.  Introduce fw_device_workfn() and
sbp2_lu_workfn() which invoke fw_device->workfn and
sbp2_logical_unit->workfn respectively and always use the two
functions as the work functions and update the users to set the
->workfn fields instead of overriding work functions using
PREPARE_DELAYED_WORK().

It would probably be best to route this with other related updates
through the workqueue tree.

Compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net
Cc: Chris Boot <bootc@bootc.net>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
---
 drivers/firewire/core-device.c | 22 +++++++++++++++-------
 drivers/firewire/sbp2.c        | 17 +++++++++++++----
 include/linux/firewire.h       |  1 +
 3 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index de4aa40..2c6d5e1 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -916,7 +916,7 @@ static int lookup_existing_device(struct device *dev, void *data)
 		old->config_rom_retries = 0;
 		fw_notice(card, "rediscovered device %s\n", dev_name(dev));
 
-		PREPARE_DELAYED_WORK(&old->work, fw_device_update);
+		old->workfn = fw_device_update;
 		fw_schedule_device_work(old, 0);
 
 		if (current_node == card->root_node)
@@ -1075,7 +1075,7 @@ static void fw_device_init(struct work_struct *work)
 	if (atomic_cmpxchg(&device->state,
 			   FW_DEVICE_INITIALIZING,
 			   FW_DEVICE_RUNNING) == FW_DEVICE_GONE) {
-		PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
+		device->workfn = fw_device_shutdown;
 		fw_schedule_device_work(device, SHUTDOWN_DELAY);
 	} else {
 		fw_notice(card, "created device %s: GUID %08x%08x, S%d00\n",
@@ -1196,13 +1196,20 @@ static void fw_device_refresh(struct work_struct *work)
 		  dev_name(&device->device), fw_rcode_string(ret));
  gone:
 	atomic_set(&device->state, FW_DEVICE_GONE);
-	PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
+	device->workfn = fw_device_shutdown;
 	fw_schedule_device_work(device, SHUTDOWN_DELAY);
  out:
 	if (node_id == card->root_node->node_id)
 		fw_schedule_bm_work(card, 0);
 }
 
+static void fw_device_workfn(struct work_struct *work)
+{
+	struct fw_device *device = container_of(to_delayed_work(work),
+						struct fw_device, work);
+	device->workfn(work);
+}
+
 void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 {
 	struct fw_device *device;
@@ -1252,7 +1259,8 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		 * power-up after getting plugged in.  We schedule the
 		 * first config rom scan half a second after bus reset.
 		 */
-		INIT_DELAYED_WORK(&device->work, fw_device_init);
+		device->workfn = fw_device_init;
+		INIT_DELAYED_WORK(&device->work, fw_device_workfn);
 		fw_schedule_device_work(device, INITIAL_DELAY);
 		break;
 
@@ -1268,7 +1276,7 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		if (atomic_cmpxchg(&device->state,
 			    FW_DEVICE_RUNNING,
 			    FW_DEVICE_INITIALIZING) == FW_DEVICE_RUNNING) {
-			PREPARE_DELAYED_WORK(&device->work, fw_device_refresh);
+			device->workfn = fw_device_refresh;
 			fw_schedule_device_work(device,
 				device->is_local ? 0 : INITIAL_DELAY);
 		}
@@ -1283,7 +1291,7 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		smp_wmb();  /* update node_id before generation */
 		device->generation = card->generation;
 		if (atomic_read(&device->state) == FW_DEVICE_RUNNING) {
-			PREPARE_DELAYED_WORK(&device->work, fw_device_update);
+			device->workfn = fw_device_update;
 			fw_schedule_device_work(device, 0);
 		}
 		break;
@@ -1308,7 +1316,7 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 		device = node->data;
 		if (atomic_xchg(&device->state,
 				FW_DEVICE_GONE) == FW_DEVICE_RUNNING) {
-			PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
+			device->workfn = fw_device_shutdown;
 			fw_schedule_device_work(device,
 				list_empty(&card->link) ? 0 : SHUTDOWN_DELAY);
 		}
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 281029d..7aef911 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -146,6 +146,7 @@ struct sbp2_logical_unit {
 	 */
 	int generation;
 	int retries;
+	work_func_t workfn;
 	struct delayed_work work;
 	bool has_sdev;
 	bool blocked;
@@ -864,7 +865,7 @@ static void sbp2_login(struct work_struct *work)
 	/* set appropriate retry limit(s) in BUSY_TIMEOUT register */
 	sbp2_set_busy_timeout(lu);
 
-	PREPARE_DELAYED_WORK(&lu->work, sbp2_reconnect);
+	lu->workfn = sbp2_reconnect;
 	sbp2_agent_reset(lu);
 
 	/* This was a re-login. */
@@ -918,7 +919,7 @@ static void sbp2_login(struct work_struct *work)
 	 * If a bus reset happened, sbp2_update will have requeued
 	 * lu->work already.  Reset the work from reconnect to login.
 	 */
-	PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+	lu->workfn = sbp2_login;
 }
 
 static void sbp2_reconnect(struct work_struct *work)
@@ -952,7 +953,7 @@ static void sbp2_reconnect(struct work_struct *work)
 		    lu->retries++ >= 5) {
 			dev_err(tgt_dev(tgt), "failed to reconnect\n");
 			lu->retries = 0;
-			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
+			lu->workfn = sbp2_login;
 		}
 		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 
@@ -972,6 +973,13 @@ static void sbp2_reconnect(struct work_struct *work)
 	sbp2_conditionally_unblock(lu);
 }
 
+static void sbp2_lu_workfn(struct work_struct *work)
+{
+	struct sbp2_logical_unit *lu = container_of(to_delayed_work(work),
+						struct sbp2_logical_unit, work);
+	lu->workfn(work);
+}
+
 static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 {
 	struct sbp2_logical_unit *lu;
@@ -998,7 +1006,8 @@ static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 	lu->blocked  = false;
 	++tgt->dont_block;
 	INIT_LIST_HEAD(&lu->orb_list);
-	INIT_DELAYED_WORK(&lu->work, sbp2_login);
+	lu->workfn = sbp2_login;
+	INIT_DELAYED_WORK(&lu->work, sbp2_lu_workfn);
 
 	list_add_tail(&lu->link, &tgt->lu_list);
 	return 0;
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 5d7782e..c3683bd 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -200,6 +200,7 @@ struct fw_device {
 	unsigned irmc:1;
 	unsigned bc_implemented:2;
 
+	work_func_t workfn;
 	struct delayed_work work;
 	struct fw_attribute_group attribute_group;
 };
-- 
1.8.5.3


------------------------------------------------------------------------------
Managing the Performance of Cloud-Based Applications
Take advantage of what the Cloud has to offer - Avoid Common Pitfalls.
Read the Whitepaper.
http://pubads.g.doubleclick.net/gampad/clk?id=121054471&iu=/4140/ostg.clktrk
