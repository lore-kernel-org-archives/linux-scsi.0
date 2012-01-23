From: Greg KH <gregkh@suse.de>
Subject: [23/27] kernel.h: add printk_ratelimited and pr_<level>_rl
Date: Mon, 23 Jan 2012 15:41:09 -0800
Message-ID: <20120123234203.649739932@clark.kroah.org>
References: <20120123234224.GA19510@kroah.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120123234224.GA19510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Paolo Bonzini <pbonzini@redhat.com>, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Joe Perches <joe@perches.com>, Naohiro Ooiwa <nooiwa@miraclelinux.com>, Ingo Molnar <mingo@elte.hu>, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-scsi@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Joe Perches <joe@perches.com>

commit 8a64f336bc1d4aa203b138d29d5a9c414a9fbb47 upstream.

Add a printk_ratelimited statement expression macro that uses a per-call
ratelimit_state so that multiple subsystems output messages are not
suppressed by a global __ratelimit state.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: s/_rl/_ratelimited/g]
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kernel.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -407,6 +407,50 @@ static inline char *pack_hex_byte(char *
 #endif
 
 /*
+ * ratelimited messages with local ratelimit_state,
+ * no local ratelimit_state used in the !PRINTK case
+ */
+#ifdef CONFIG_PRINTK
+#define printk_ratelimited(fmt, ...)  ({		\
+	static struct ratelimit_state _rs = {		\
+		.interval = DEFAULT_RATELIMIT_INTERVAL, \
+		.burst = DEFAULT_RATELIMIT_BURST,       \
+	};                                              \
+							\
+	if (!__ratelimit(&_rs))                         \
+		printk(fmt, ##__VA_ARGS__);		\
+})
+#else
+/* No effect, but we still get type checking even in the !PRINTK case: */
+#define printk_ratelimited printk
+#endif
+
+#define pr_emerg_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+/* no pr_cont_ratelimited, don't do that... */
+/* If you are writing a driver, please use dev_dbg instead */
+#if defined(DEBUG)
+#define pr_debug_ratelimited(fmt, ...) \
+	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#else
+#define pr_debug_ratelimited(fmt, ...) \
+	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
+				     ##__VA_ARGS__); 0; })
+#endif
+
+/*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
  *
