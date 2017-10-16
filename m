From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: gdth: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 16:55:02 -0700
Message-ID: <20171016235502.GA102608@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Achim Leubner <achim_leubner@adaptec.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/gdth.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index a4473356a9dc..c35f05c4c6bb 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3705,7 +3705,7 @@ static void gdth_log_event(gdth_evt_data *dvr, char *buffer)
 #ifdef GDTH_STATISTICS
 static u8	gdth_timer_running;
 
-static void gdth_timeout(unsigned long data)
+static void gdth_timeout(struct timer_list *unused)
 {
     u32 i;
     Scsi_Cmnd *nscp;
@@ -3743,8 +3743,6 @@ static void gdth_timer_init(void)
 	gdth_timer_running = 1;
 	TRACE2(("gdth_detect(): Initializing timer !\n"));
 	gdth_timer.expires = jiffies + HZ;
-	gdth_timer.data = 0L;
-	gdth_timer.function = gdth_timeout;
 	add_timer(&gdth_timer);
 }
 #else
@@ -5165,7 +5163,7 @@ static int __init gdth_init(void)
 	/* initializations */
 	gdth_polling = TRUE;
 	gdth_clear_events();
-	init_timer(&gdth_timer);
+	timer_setup(&gdth_timer, gdth_timeout, 0);
 
 	/* As default we do not probe for EISA or ISA controllers */
 	if (probe_eisa_isa) {
-- 
2.7.4


-- 
Kees Cook
Pixel Security
