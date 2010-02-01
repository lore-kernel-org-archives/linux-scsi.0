From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: [PATCH 1/2 v2] scsi: add __print_hex() to ftrace
Date: Mon, 01 Feb 2010 14:05:01 +0900
Message-ID: <4B6660FD.2020408@jp.fujitsu.com>
References: <4B665EC9.6000608@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B665EC9.6000608@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

This is the same patch from v1.

__print_hex() prints values in an array in hex (w/o '0x') (space separated)
EX) 92 33 32 f3 ee 4d

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Signed-off-by: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>


---

 linux-2.6.33-rc6-trace-kei/include/linux/ftrace_event.h |    3 +++
 linux-2.6.33-rc6-trace-kei/include/trace/ftrace.h       |    3 +++
 linux-2.6.33-rc6-trace-kei/kernel/trace/trace_output.c  |   15 +++++++++++++++
 3 files changed, 21 insertions(+)

diff -puN include/linux/ftrace_event.h~ftrace_print_hex include/linux/ftrace_event.h
--- linux-2.6.33-rc6-trace/include/linux/ftrace_event.h~ftrace_print_hex	2010-02-01 11:56:32.000000000 +0900
+++ linux-2.6.33-rc6-trace-kei/include/linux/ftrace_event.h	2010-02-01 11:56:32.000000000 +0900
@@ -24,6 +24,9 @@ const char *ftrace_print_flags_seq(struc
 const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
 				     const struct trace_print_flags *symbol_array);
 
+const char *ftrace_print_hex_seq(struct trace_seq *p,
+				 const unsigned char *buf, int len);
+
 /*
  * The trace entry - the most basic unit of tracing. This is what
  * is printed in the end as a single line in the trace output, such as:
diff -puN include/trace/ftrace.h~ftrace_print_hex include/trace/ftrace.h
--- linux-2.6.33-rc6-trace/include/trace/ftrace.h~ftrace_print_hex	2010-02-01 11:56:32.000000000 +0900
+++ linux-2.6.33-rc6-trace-kei/include/trace/ftrace.h	2010-02-01 11:56:32.000000000 +0900
@@ -321,6 +321,9 @@ ftrace_format_##name(struct ftrace_event
 		ftrace_print_symbols_seq(p, value, symbols);		\
 	})
 
+#undef __print_hex
+#define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static enum print_line_t						\
diff -puN kernel/trace/trace_output.c~ftrace_print_hex kernel/trace/trace_output.c
--- linux-2.6.33-rc6-trace/kernel/trace/trace_output.c~ftrace_print_hex	2010-02-01 11:56:32.000000000 +0900
+++ linux-2.6.33-rc6-trace-kei/kernel/trace/trace_output.c	2010-02-01 11:56:32.000000000 +0900
@@ -355,6 +355,21 @@ ftrace_print_symbols_seq(struct trace_se
 }
 EXPORT_SYMBOL(ftrace_print_symbols_seq);
 
+const char *
+ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
+{
+	int i;
+	const char *ret = p->buffer + p->len;
+
+	for (i = 0; i < buf_len; i++)
+		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);
+
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(ftrace_print_hex_seq);
+
 #ifdef CONFIG_KRETPROBES
 static inline const char *kretprobed(const char *name)
 {

_
