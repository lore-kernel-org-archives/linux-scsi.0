From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 17/17] hpsa: dial down lockup detection during firmware flash
Date: Fri, 20 Apr 2012 10:07:48 -0500
Message-ID: <20120420150748.10596.78646.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Dial back the aggressiveness of the controller lockup detection thread.
Currently it will declare the controller to be locked up if it goes
for 10 seconds with no interrupts and no change in the heartbeat
register.  Dial back this to 30 seconds with no heartbeat change, and
also snoop the ioctl path and if a firmware flash command is detected,
dial it back further to 4 minutes until the firmware flash command
completes.  The reason for this is that during the firmware flash
operation, the controller apparently doesn't update the heartbeat
register as frequently as it is supposed to, and we can get a false
positive.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c     |   39 ++++++++++++++++++++++++++++++++++-----
 drivers/scsi/hpsa.h     |    2 ++
 drivers/scsi/hpsa_cmd.h |    1 +
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8213875..6245c52 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -568,12 +568,42 @@ static void set_performant_mode(struct ctlr_info *h, struct CommandList *c)
 	}
 }
 
+static int is_firmware_flash_cmd(u8 *cdb)
+{
+	return cdb[0] == BMIC_WRITE && cdb[6] == BMIC_FLASH_FIRMWARE;
+}
+
+/*
+ * During firmware flash, the heartbeat register may not update as frequently
+ * as it should.  So we dial down lockup detection during firmware flash. and
+ * dial it back up when firmware flash completes.
+ */
+#define HEARTBEAT_SAMPLE_INTERVAL_DURING_FLASH (240 * HZ)
+#define HEARTBEAT_SAMPLE_INTERVAL (30 * HZ)
+static void dial_down_lockup_detection_during_fw_flash(struct ctlr_info *h,
+		struct CommandList *c)
+{
+	if (!is_firmware_flash_cmd(c->Request.CDB))
+		return;
+	atomic_inc(&h->firmware_flash_in_progress);
+	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL_DURING_FLASH;
+}
+
+static void dial_up_lockup_detection_on_fw_flash_complete(struct ctlr_info *h,
+		struct CommandList *c)
+{
+	if (is_firmware_flash_cmd(c->Request.CDB) &&
+		atomic_dec_and_test(&h->firmware_flash_in_progress))
+		h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
+}
+
 static void enqueue_cmd_and_start_io(struct ctlr_info *h,
 	struct CommandList *c)
 {
 	unsigned long flags;
 
 	set_performant_mode(h, c);
+	dial_down_lockup_detection_during_fw_flash(h, c);
 	spin_lock_irqsave(&h->lock, flags);
 	addQ(&h->reqQ, c);
 	h->Qdepth++;
@@ -3377,6 +3407,7 @@ static inline void finish_cmd(struct CommandList *c)
 	spin_lock_irqsave(&c->h->lock, flags);
 	removeQ(c);
 	spin_unlock_irqrestore(&c->h->lock, flags);
+	dial_up_lockup_detection_on_fw_flash_complete(c->h, c);
 	if (likely(c->cmd_type == CMD_SCSI))
 		complete_scsi_command(c);
 	else if (c->cmd_type == CMD_IOCTL_PEND)
@@ -4560,9 +4591,6 @@ static void controller_lockup_detected(struct ctlr_info *h)
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
-#define HEARTBEAT_SAMPLE_INTERVAL (10 * HZ)
-#define HEARTBEAT_CHECK_MINIMUM_INTERVAL (HEARTBEAT_SAMPLE_INTERVAL / 2)
-
 static void detect_controller_lockup(struct ctlr_info *h)
 {
 	u64 now;
@@ -4573,7 +4601,7 @@ static void detect_controller_lockup(struct ctlr_info *h)
 	now = get_jiffies_64();
 	/* If we've received an interrupt recently, we're ok. */
 	if (time_after64(h->last_intr_timestamp +
-				(HEARTBEAT_CHECK_MINIMUM_INTERVAL), now))
+				(h->heartbeat_sample_interval), now))
 		return;
 
 	/*
@@ -4582,7 +4610,7 @@ static void detect_controller_lockup(struct ctlr_info *h)
 	 * otherwise don't care about signals in this thread.
 	 */
 	if (time_after64(h->last_heartbeat_timestamp +
-				(HEARTBEAT_CHECK_MINIMUM_INTERVAL), now))
+				(h->heartbeat_sample_interval), now))
 		return;
 
 	/* If heartbeat has not changed since we last looked, we're not ok. */
@@ -4624,6 +4652,7 @@ static void add_ctlr_to_lockup_detector_list(struct ctlr_info *h)
 {
 	unsigned long flags;
 
+	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
 	spin_lock_irqsave(&lockup_detector_lock, flags);
 	list_add_tail(&h->lockup_list, &hpsa_ctlr_list);
 	spin_unlock_irqrestore(&lockup_detector_lock, flags);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index fb51ef7..9816479 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -129,6 +129,8 @@ struct ctlr_info {
 	u64 last_intr_timestamp;
 	u32 last_heartbeat;
 	u64 last_heartbeat_timestamp;
+	u32 heartbeat_sample_interval;
+	atomic_t firmware_flash_in_progress;
 	u32 lockup_detected;
 	struct list_head lockup_list;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 43f1631..a894f2e 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -186,6 +186,7 @@ struct SenseSubsystem_info {
 #define BMIC_WRITE 0x27
 #define BMIC_CACHE_FLUSH 0xc2
 #define HPSA_CACHE_FLUSH 0x01	/* C2 was already being used by HPSA */
+#define BMIC_FLASH_FIRMWARE 0xF7
 
 /* Command List Structure */
 union SCSI3Addr {
