From: Alison Schofield <amsfield22@gmail.com>
Subject: [RESEND PATCH v2] scsi: gdth: replace struct timeval with ktime_get_real_seconds()
Date: Wed, 17 Feb 2016 21:29:34 -0800
Message-ID: <1455773374-2863-1-git-send-email-amsfield22@gmail.com>
References: <20151119214304.GA16713@d830.WORKGROUP>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151119214304.GA16713@d830.WORKGROUP>
Sender: linux-kernel-owner@vger.kernel.org
To: achim_leubner@pmc-sierra.com, martin.petersen@oracle.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, y2038@lists.linaro.org
List-Id: linux-scsi@vger.kernel.org

struct timeval will overflow on 32-bit systems in y2038 and is being
removed from the kernel. Replace the use of struct timeval and
do_gettimeofday() with ktime_get_real_seconds() which provides a 64-bit
seconds value and is y2038 safe.

gdth driver requires changes in two areas:

1) gdth_store_event() loads two u32 timestamp fields for ioctl GDTIOCTL_EVENT

   These timestamp fields are part of struct gdth_evt_str used for passing
   event data to userspace. At the first instance of an event we do
   (first_stamp=last_stamp="current time"). If that same event repeats,
   we do (last_stamp="current time") AND increment same_count to indicate
   how many times the event has repeated since first_stamp.

   This patch replaces the use of timeval and do_gettimeofday() with
   ktime_get_real_seconds() cast to u32 to extend the timestamp fields
   to y2106.

   Beyond y2106, the userspace tools (ie. RAID controller monitors) can
   work around the time rollover and this driver would still not need to
   change.

   Alternative: The alternative approach is to introduce a new ioctl in gdth
   with the u32 time fields defined as u64.  This would require userspace
   changes now, but not in y2106.

2)  gdth_show_info() calculates elapsed time using u32 first_stamp

    It is adding events with timestamps to a seq_file.  Timestamps are
    calculated as the "current time" minus the first_stamp.

    This patch replaces the use of timeval and do_gettimeofday() with
    ktime_get_real_seconds() cast to u32 to calculate the timestamp.

    This elapsed time calculation is safe even when the time wraps (beyond
    y2106) due to how unsigned subtraction works. A comment has been added
    to the code to indicate this safety.

    Alternative: This piece itself doesn't warrant an alternative, but
    if we do introduce a new structure & ioctl with u64 timestamps, this
    would change accordingly.

Signed-off-by: Alison Schofield <amsfield22@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
Changes in v2:
- remove unnecessary ktime.h includes
- add comment in code to explain elapsed time calculation
- add detail and alternatives to changelog


 drivers/scsi/gdth.c      |  7 ++-----
 drivers/scsi/gdth_proc.c | 11 ++++++++---
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 71e1380..0a76774 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2838,7 +2838,6 @@ static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, u16 source,
                                       u16 idx, gdth_evt_data *evt)
 {
     gdth_evt_str *e;
-    struct timeval tv;
 
     /* no GDTH_LOCK_HA() ! */
     TRACE2(("gdth_store_event() source %d idx %d\n", source, idx));
@@ -2854,8 +2853,7 @@ static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, u16 source,
             !strcmp((char *)&ebuffer[elastidx].event_data.event_string,
             (char *)&evt->event_string)))) { 
         e = &ebuffer[elastidx];
-        do_gettimeofday(&tv);
-        e->last_stamp = tv.tv_sec;
+	e->last_stamp = (u32)ktime_get_real_seconds();
         ++e->same_count;
     } else {
         if (ebuffer[elastidx].event_source != 0) {  /* entry not free ? */
@@ -2871,8 +2869,7 @@ static gdth_evt_str *gdth_store_event(gdth_ha_str *ha, u16 source,
         e = &ebuffer[elastidx];
         e->event_source = source;
         e->event_idx = idx;
-        do_gettimeofday(&tv);
-        e->first_stamp = e->last_stamp = tv.tv_sec;
+	e->first_stamp = e->last_stamp = (u32)ktime_get_real_seconds();
         e->same_count = 1;
         e->event_data = *evt;
         e->application = 0;
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index e66e997..be609db 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -148,7 +148,6 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
     gdth_cmd_str *gdtcmd;
     gdth_evt_str *estr;
     char hrec[161];
-    struct timeval tv;
 
     char *buf;
     gdth_dskstat_str *pds;
@@ -540,8 +539,14 @@ int gdth_show_info(struct seq_file *m, struct Scsi_Host *host)
         if (estr->event_data.eu.driver.ionode == ha->hanum &&
             estr->event_source == ES_ASYNC) { 
             gdth_log_event(&estr->event_data, hrec);
-            do_gettimeofday(&tv);
-            sec = (int)(tv.tv_sec - estr->first_stamp);
+
+	    /*
+	     * Elapsed seconds subtraction with unsigned operands is
+	     * safe from wrap around in year 2106.  Executes as:
+	     * operand a + (2's complement operand b) + 1
+	     */
+
+	    sec = (int)((u32)ktime_get_real_seconds() - estr->first_stamp);
             if (sec < 0) sec = 0;
             seq_printf(m," date- %02d:%02d:%02d\t%s\n",
                            sec/3600, sec%3600/60, sec%60, hrec);
-- 
2.1.4
