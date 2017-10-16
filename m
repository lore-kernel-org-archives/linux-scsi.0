From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: smartpqi: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:54:37 -0700
Message-ID: <20171016235437.GA102564@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: esc.storagedev@microsemi.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8fe918398336..b2880c7709e6 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2860,11 +2860,12 @@ static void pqi_event_worker(struct work_struct *work)
 
 #define PQI_HEARTBEAT_TIMER_INTERVAL	(10 * HZ)
 
-static void pqi_heartbeat_timer_handler(unsigned long data)
+static void pqi_heartbeat_timer_handler(struct timer_list *t)
 {
 	int num_interrupts;
 	u32 heartbeat_count;
-	struct pqi_ctrl_info *ctrl_info = (struct pqi_ctrl_info *)data;
+	struct pqi_ctrl_info *ctrl_info = from_timer(ctrl_info, t,
+						     heartbeat_timer);
 
 	pqi_check_ctrl_health(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
@@ -2902,8 +2903,6 @@ static void pqi_start_heartbeat_timer(struct pqi_ctrl_info *ctrl_info)
 
 	ctrl_info->heartbeat_timer.expires =
 		jiffies + PQI_HEARTBEAT_TIMER_INTERVAL;
-	ctrl_info->heartbeat_timer.data = (unsigned long)ctrl_info;
-	ctrl_info->heartbeat_timer.function = pqi_heartbeat_timer_handler;
 	add_timer(&ctrl_info->heartbeat_timer);
 }
 
@@ -6465,7 +6464,7 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 	INIT_DELAYED_WORK(&ctrl_info->rescan_work, pqi_rescan_worker);
 	INIT_DELAYED_WORK(&ctrl_info->update_time_work, pqi_update_time_worker);
 
-	init_timer(&ctrl_info->heartbeat_timer);
+	timer_setup(&ctrl_info->heartbeat_timer, pqi_heartbeat_timer_handler, 0);
 	INIT_WORK(&ctrl_info->ctrl_offline_work, pqi_ctrl_offline_worker);
 
 	sema_init(&ctrl_info->sync_request_sem,
-- 
2.7.4


-- 
Kees Cook
Pixel Security
