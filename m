From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
Date: Tue, 14 May 2013 15:45:43 +0800
Message-ID: <5191EBA7.9010303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: john.stultz@linaro.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>From 18072c1c3506a7e37ee485307a2c343efe5af4d0 Mon Sep 17 00:00:00 2001
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Mon, 13 May 2013 15:45:24 +0900
Subject: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()

Introduce a new timestamp function local_time_seconds() to hide the conversion of system time in UTC to local time seconds.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 include/linux/time.h |    1 +
 kernel/time.c        |   11 +++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 22d81b3..1aec534 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -271,4 +271,5 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_nsec = ns;
 }
 
+extern u32 local_time_seconds(void);
 #endif
diff --git a/kernel/time.c b/kernel/time.c
index d3617db..715377d 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -712,3 +712,14 @@ struct timespec timespec_add_safe(const struct timespec lhs,
 
 	return res;
 }
+
+/*
+ * Convert system time in UTC to local time seconds.
+ */
+u32 local_time_seconds(void)
+{
+	struct timeval utc;
+	do_gettimeofday(&utc);
+	return (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
+}
+EXPORT_SYMBOL(local_time_seconds);
-- 
1.7.1
