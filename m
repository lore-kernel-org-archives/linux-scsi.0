From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 26/27] zfcp: Remove duplicated code for debug timestamps
Date: Tue, 18 Aug 2009 15:43:31 +0200
Message-ID: <20090818135032.224181000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:47073 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964AbZHRNub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:31 -0400
Content-Disposition: inline; filename=705-zfcp-debug-timestamps.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The timestamp calculation used for s390dbf output is the same in a
private zfcp function and in debug.c. Replace both with a common
inline function.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 arch/s390/include/asm/timex.h |    8 ++++++++
 arch/s390/kernel/debug.c      |    8 +-------
 arch/s390/kernel/time.c       |    1 +
 drivers/s390/scsi/zfcp_dbf.c  |   19 +++----------------
 4 files changed, 13 insertions(+), 23 deletions(-)

--- a/arch/s390/include/asm/timex.h	2009-08-17 11:08:55.000000000 +0200
+++ b/arch/s390/include/asm/timex.h	2009-08-17 11:12:35.000000000 +0200
@@ -88,6 +88,14 @@ int get_sync_clock(unsigned long long *c
 void init_cpu_timer(void);
 unsigned long long monotonic_clock(void);
 
+void tod_to_timeval(__u64, struct timespec *);
+
+static inline
+void stck_to_timespec(unsigned long long stck, struct timespec *ts)
+{
+	tod_to_timeval(stck - TOD_UNIX_EPOCH, ts);
+}
+
 extern u64 sched_clock_base_cc;
 
 #endif
--- a/arch/s390/kernel/debug.c	2009-08-17 11:08:54.000000000 +0200
+++ b/arch/s390/kernel/debug.c	2009-08-17 11:11:22.000000000 +0200
@@ -63,8 +63,6 @@ typedef struct
 } debug_sprintf_entry_t;
 
 
-extern void tod_to_timeval(uint64_t todval, struct timespec *xtime);
-
 /* internal function prototyes */
 
 static int debug_init(void);
@@ -1450,17 +1448,13 @@ debug_dflt_header_fn(debug_info_t * id, 
 			 int area, debug_entry_t * entry, char *out_buf)
 {
 	struct timespec time_spec;
-	unsigned long long time;
 	char *except_str;
 	unsigned long caller;
 	int rc = 0;
 	unsigned int level;
 
 	level = entry->id.fields.level;
-	time = entry->id.stck;
-	/* adjust todclock to 1970 */
-	time -= 0x8126d60e46000000LL - (0x3c26700LL * 1000000 * 4096);
-	tod_to_timeval(time, &time_spec);
+	stck_to_timespec(entry->id.stck, &time_spec);
 
 	if (entry->id.fields.exception)
 		except_str = "*";
--- a/arch/s390/kernel/time.c	2009-08-17 11:08:55.000000000 +0200
+++ b/arch/s390/kernel/time.c	2009-08-17 11:11:22.000000000 +0200
@@ -90,6 +90,7 @@ void tod_to_timeval(__u64 todval, struct
 	todval -= (sec * 1000000) << 12;
 	xtime->tv_nsec = ((todval * 1000) >> 12);
 }
+EXPORT_SYMBOL(tod_to_timeval);
 
 void clock_comparator_work(void)
 {
--- a/drivers/s390/scsi/zfcp_dbf.c	2009-08-17 11:09:56.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-08-17 11:11:22.000000000 +0200
@@ -38,19 +38,6 @@ static void zfcp_dbf_hexdump(debug_info_
 	}
 }
 
-/* FIXME: this duplicate this code in s390 debug feature */
-static void zfcp_dbf_timestamp(unsigned long long stck, struct timespec *time)
-{
-	unsigned long long sec;
-
-	stck -= 0x8126d60e46000000LL - (0x3c26700LL * 1000000 * 4096);
-	sec = stck >> 12;
-	do_div(sec, 1000000);
-	time->tv_sec = sec;
-	stck -= (sec * 1000000) << 12;
-	time->tv_nsec = ((stck * 1000) >> 12);
-}
-
 static void zfcp_dbf_tag(char **p, const char *label, const char *tag)
 {
 	int i;
@@ -107,7 +94,7 @@ static int zfcp_dbf_view_header(debug_in
 	char *p = out_buf;
 
 	if (strncmp(dump->tag, "dump", ZFCP_DBF_TAG_SIZE) != 0) {
-		zfcp_dbf_timestamp(entry->id.stck, &t);
+		stck_to_timespec(entry->id.stck, &t);
 		zfcp_dbf_out(&p, "timestamp", "%011lu:%06lu",
 			     t.tv_sec, t.tv_nsec);
 		zfcp_dbf_out(&p, "cpu", "%02i", entry->id.fields.cpuid);
@@ -320,7 +307,7 @@ static void zfcp_dbf_hba_view_response(c
 	zfcp_dbf_out(p, "fsf_command", "0x%08x", r->fsf_command);
 	zfcp_dbf_out(p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
 	zfcp_dbf_out(p, "fsf_seqno", "0x%08x", r->fsf_seqno);
-	zfcp_dbf_timestamp(r->fsf_issued, &t);
+	stck_to_timespec(r->fsf_issued, &t);
 	zfcp_dbf_out(p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
 	zfcp_dbf_out(p, "fsf_prot_status", "0x%08x", r->fsf_prot_status);
 	zfcp_dbf_out(p, "fsf_status", "0x%08x", r->fsf_status);
@@ -976,7 +963,7 @@ static int zfcp_dbf_scsi_view_format(deb
 		zfcp_dbf_out(&p, "old_fsf_reqid", "0x%0Lx", r->old_fsf_reqid);
 	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
 	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
-	zfcp_dbf_timestamp(r->fsf_issued, &t);
+	stck_to_timespec(r->fsf_issued, &t);
 	zfcp_dbf_out(&p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
 
 	if (strncmp(r->tag, "rslt", ZFCP_DBF_TAG_SIZE) == 0) {

