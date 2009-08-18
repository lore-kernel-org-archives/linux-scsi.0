From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 27/27] zfcp: optimize zfcp_qdio_account
Date: Tue, 18 Aug 2009 15:43:32 +0200
Message-ID: <20090818135032.364294000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57702 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985AbZHRNuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:35 -0400
Content-Disposition: inline; filename=704-zfcp-optimize-qdio_account.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Remove expensive ktime_get()/ktime_us_delta() functions from the hot
path and use get_clock_monotonic() instead. This elimates seven
function calls and avoids a lot of unnecessary calculations.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h  |    2 +-
 drivers/s390/scsi/zfcp_qdio.c |   11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2009-08-17 10:30:25.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-08-17 10:30:25.000000000 +0200
@@ -438,7 +438,7 @@ struct zfcp_qdio {
 	struct zfcp_qdio_queue	req_q;
 	spinlock_t		stat_lock;
 	spinlock_t		req_q_lock;
-	ktime_t			req_q_time;
+	unsigned long long	req_q_time;
 	u64			req_q_util;
 	atomic_t		req_q_full;
 	wait_queue_head_t	req_q_wq;
--- a/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 10:29:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 10:31:47.000000000 +0200
@@ -56,16 +56,15 @@ static void zfcp_qdio_zero_sbals(struct 
 }
 
 /* this needs to be called prior to updating the queue fill level */
-static void zfcp_qdio_account(struct zfcp_qdio *qdio)
+static inline void zfcp_qdio_account(struct zfcp_qdio *qdio)
 {
-	ktime_t now;
-	s64 span;
+	unsigned long long now, span;
 	int free, used;
 
 	spin_lock(&qdio->stat_lock);
-	now = ktime_get();
-	span = ktime_us_delta(now, qdio->req_q_time);
-	free = max(0, atomic_read(&qdio->req_q.count));
+	now = get_clock_monotonic();
+	span = (now - qdio->req_q_time) >> 12;
+	free = atomic_read(&qdio->req_q.count);
 	used = QDIO_MAX_BUFFERS_PER_Q - free;
 	qdio->req_q_util += used * span;
 	qdio->req_q_time = now;

