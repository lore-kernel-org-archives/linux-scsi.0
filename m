From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: aic94xx: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:54:47 -0700
Message-ID: <20171016235447.GA102579@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tomas Henzl <thenzl@redhat.com>, Quentin Lambert <lambert.quentin@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Tomas Henzl <thenzl@redhat.com>
Cc: Quentin Lambert <lambert.quentin@gmail.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/aic94xx/aic94xx_hwi.c |  3 +--
 drivers/scsi/aic94xx/aic94xx_hwi.h |  5 ++---
 drivers/scsi/aic94xx/aic94xx_scb.c |  6 +++---
 drivers/scsi/aic94xx/aic94xx_tmf.c | 13 ++++++-------
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index ec09438184a3..5402b85b0bdc 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -1175,8 +1175,7 @@ static void asd_start_scb_timers(struct list_head *list)
 	struct asd_ascb *ascb;
 	list_for_each_entry(ascb, list, list) {
 		if (!ascb->uldd_timer) {
-			ascb->timer.data = (unsigned long) ascb;
-			ascb->timer.function = asd_ascb_timedout;
+			ascb->timer.function = (TIMER_FUNC_TYPE)asd_ascb_timedout;
 			ascb->timer.expires = jiffies + AIC94XX_SCB_TIMEOUT;
 			add_timer(&ascb->timer);
 		}
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
index 8c1c28239e93..8f147e720cfd 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -291,8 +291,7 @@ static inline void asd_init_ascb(struct asd_ha_struct *asd_ha,
 	INIT_LIST_HEAD(&ascb->list);
 	ascb->scb = ascb->dma_scb.vaddr;
 	ascb->ha = asd_ha;
-	ascb->timer.function = NULL;
-	init_timer(&ascb->timer);
+	timer_setup(&ascb->timer, NULL, 0);
 	ascb->tc_index = -1;
 }
 
@@ -392,7 +391,7 @@ void asd_control_led(struct asd_ha_struct *asd_ha, int phy_id, int op);
 void asd_turn_led(struct asd_ha_struct *asd_ha, int phy_id, int op);
 int  asd_enable_phys(struct asd_ha_struct *asd_ha, const u8 phy_mask);
 
-void asd_ascb_timedout(unsigned long data);
+void asd_ascb_timedout(struct timer_list *t);
 int  asd_chip_hardrst(struct asd_ha_struct *asd_ha);
 
 #endif
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index fdac7c2fef37..22873ce8bbfa 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -866,12 +866,12 @@ void asd_build_initiate_link_adm_task(struct asd_ascb *ascb, int phy_id,
  * Upper layers can implement their own timeout function, say to free
  * resources they have with this SCB, and then call this one at the
  * end of their timeout function.  To do this, one should initialize
- * the ascb->timer.{function, data, expires} prior to calling the post
+ * the ascb->timer.{function, expires} prior to calling the post
  * function. The timer is started by the post function.
  */
-void asd_ascb_timedout(unsigned long data)
+void asd_ascb_timedout(struct timer_list *t)
 {
-	struct asd_ascb *ascb = (void *) data;
+	struct asd_ascb *ascb = from_timer(ascb, t, timer);
 	struct asd_seq_data *seq = &ascb->ha->seq;
 	unsigned long flags;
 
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index d4c35df3d4ae..4637119c09d8 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -35,15 +35,14 @@
 static int asd_enqueue_internal(struct asd_ascb *ascb,
 		void (*tasklet_complete)(struct asd_ascb *,
 					 struct done_list_struct *),
-				void (*timed_out)(unsigned long))
+				void (*timed_out)(struct timer_list *t))
 {
 	int res;
 
 	ascb->tasklet_complete = tasklet_complete;
 	ascb->uldd_timer = 1;
 
-	ascb->timer.data = (unsigned long) ascb;
-	ascb->timer.function = timed_out;
+	ascb->timer.function = (TIMER_FUNC_TYPE)timed_out;
 	ascb->timer.expires = jiffies + AIC94XX_SCB_TIMEOUT;
 
 	add_timer(&ascb->timer);
@@ -87,9 +86,9 @@ static void asd_clear_nexus_tasklet_complete(struct asd_ascb *ascb,
 	asd_ascb_free(ascb);
 }
 
-static void asd_clear_nexus_timedout(unsigned long data)
+static void asd_clear_nexus_timedout(struct timer_list *t)
 {
-	struct asd_ascb *ascb = (void *)data;
+	struct asd_ascb *ascb = from_timer(ascb, t, timer);
 	struct tasklet_completion_status *tcs = ascb->uldd_task;
 
 	ASD_DPRINTK("%s: here\n", __func__);
@@ -261,9 +260,9 @@ static int asd_clear_nexus_index(struct sas_task *task)
 
 /* ---------- TMFs ---------- */
 
-static void asd_tmf_timedout(unsigned long data)
+static void asd_tmf_timedout(struct timer_list *t)
 {
-	struct asd_ascb *ascb = (void *) data;
+	struct asd_ascb *ascb = from_timer(ascb, t, timer);
 	struct tasklet_completion_status *tcs = ascb->uldd_task;
 
 	ASD_DPRINTK("tmf timed out\n");
-- 
2.7.4


-- 
Kees Cook
Pixel Security
