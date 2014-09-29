From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/38] tracing: Create seq_buf layer in trace_seq
Date: Mon, 29 Sep 2014 13:58:54 +0200
Message-ID: <1411991947-130166-26-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbaI2L7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:17 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Create a seq_buf layer that trace_seq sits on. The seq_buf will not
be limited to page size. This will allow other usages of seq_buf
instead of a hard set PAGE_SIZE one that trace_seq has.

Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/mmutrace.h              |   2 +-
 include/linux/seq_buf.h              |  58 ++++++
 include/linux/trace_seq.h            |  10 +-
 kernel/trace/Makefile                |   1 +
 kernel/trace/seq_buf.c               | 348 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c                 |  39 ++--
 kernel/trace/trace_events.c          |   6 +-
 kernel/trace/trace_functions_graph.c |   6 +-
 kernel/trace/trace_seq.c             | 184 +++++++++---------
 9 files changed, 528 insertions(+), 126 deletions(-)
 create mode 100644 include/linux/seq_buf.h
 create mode 100644 kernel/trace/seq_buf.c

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 5aaf356..c70ab6b 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -22,7 +22,7 @@
 	__entry->unsync = sp->unsync;
 
 #define KVM_MMU_PAGE_PRINTK() ({				        \
-	const u32 saved_len = p->len;					\
+	const u32 saved_len = p->seq.len;				\
 	static const char *access_str[] = {			        \
 		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  \
 	};							        \
diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
new file mode 100644
index 0000000..23b3fa2
--- /dev/null
+++ b/include/linux/seq_buf.h
@@ -0,0 +1,58 @@
+#ifndef _LINUX_SEQ_BUF_H
+#define _LINUX_SEQ_BUF_H
+
+#include <linux/fs.h>
+
+#include <asm/page.h>
+
+/*
+ * Trace sequences are used to allow a function to call several other functions
+ * to create a string of data to use.
+ */
+
+/**
+ * seq_buf - seq buffer structure
+ * @buffer:	pointer to the buffer
+ * @size:	size of the buffer
+ * @len:	the amount of data inside the buffer
+ * @readpos:	The next position to read in the buffer.
+ * @overflow:	Set if more bytes should have been written to buffer
+ */
+struct seq_buf {
+	unsigned char		*buffer;
+	unsigned int		size;
+	unsigned int		len;
+	unsigned int		readpos;
+	unsigned int		overflow;
+};
+
+static inline void
+seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
+{
+	s->buffer = buf;
+	s->size = size;
+	s->len = 0;
+	s->readpos = 0;
+	s->overflow = 0;
+}
+
+extern __printf(2, 3)
+int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
+extern __printf(2, 0)
+int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args);
+extern int
+seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
+extern int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s);
+extern int seq_buf_to_user(struct seq_buf *s, char __user *ubuf,
+			   int cnt);
+extern int seq_buf_puts(struct seq_buf *s, const char *str);
+extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
+extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
+extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
+			      unsigned int len);
+extern int seq_buf_path(struct seq_buf *s, const struct path *path);
+
+extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
+			   int nmaskbits);
+
+#endif /* _LINUX_SEQ_BUF_H */
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index ea6c9de..27c98fd 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_TRACE_SEQ_H
 #define _LINUX_TRACE_SEQ_H
 
-#include <linux/fs.h>
+#include <linux/seq_buf.h>
 
 #include <asm/page.h>
 
@@ -12,16 +12,14 @@
 
 struct trace_seq {
 	unsigned char		buffer[PAGE_SIZE];
-	unsigned int		len;
-	unsigned int		readpos;
+	struct seq_buf		seq;
 	int			full;
 };
 
 static inline void
 trace_seq_init(struct trace_seq *s)
 {
-	s->len = 0;
-	s->readpos = 0;
+	seq_buf_init(&s->seq, s->buffer, PAGE_SIZE);
 	s->full = 0;
 }
 
@@ -37,7 +35,7 @@ trace_seq_init(struct trace_seq *s)
 static inline unsigned char *
 trace_seq_buffer_ptr(struct trace_seq *s)
 {
-	return s->buffer + s->len;
+	return s->buffer + s->seq.len;
 }
 
 /*
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 67d6369..edc98c7 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
 obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_seq.o
+obj-$(CONFIG_TRACING) += seq_buf.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
new file mode 100644
index 0000000..5c3c65b
--- /dev/null
+++ b/kernel/trace/seq_buf.c
@@ -0,0 +1,348 @@
+/*
+ * seq_buf.c
+ *
+ * Copyright (C) 2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * The seq_buf is a handy tool that allows you to pass a descriptor around
+ * to a buffer that other functions can write to. It is similar to the
+ * seq_file functionality but has some differences.
+ *
+ * To use it, the seq_buf must be initialized with seq_buf_init().
+ * This will set up the counters within the descriptor. You can call
+ * seq_buf_init() more than once to reset the seq_buf to start
+ * from scratch.
+ *
+ */
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
+#include <linux/seq_buf.h>
+
+/* How much buffer is left on the seq_buf? */
+#define SEQ_BUF_LEFT(s) (((s)->size - 1) - (s)->len)
+
+/* How much buffer is written? */
+#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
+
+static inline void seq_buf_check_len(struct seq_buf *s)
+{
+	if (unlikely(s->len > (s->size - 1))) {
+		s->len = s->size - 1;
+		s->overflow = 1;
+	}
+}
+
+/**
+ * seq_buf_print_seq - move the contents of seq_buf into a seq_file
+ * @m: the seq_file descriptor that is the destination
+ * @s: the seq_buf descriptor that is the source.
+ *
+ * Returns zero on success, non zero otherwise
+ */
+int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s)
+{
+	unsigned int len = SEQ_BUF_USED(s);
+
+	return seq_write(m, s->buffer, len);
+}
+
+/**
+ * seq_buf_printf - sequence printing of trace information
+ * @s: seq_buf descriptor
+ * @fmt: printf format string
+ *
+ * Writes a printf() format into the sequence buffer.
+ *
+ * Returns number of bytes written.
+ */
+int seq_buf_printf(struct seq_buf *s, const char *fmt, ...)
+{
+	unsigned int len = SEQ_BUF_LEFT(s);
+	va_list ap;
+	int ret;
+
+	WARN_ON((int)len < 0);
+	va_start(ap, fmt);
+	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	va_end(ap);
+
+	s->len += ret;
+
+	seq_buf_check_len(s);
+
+	return ret;
+}
+
+/**
+ * seq_buf_bitmask - write a bitmask array in its ASCII representation
+ * @s:		seq_buf descriptor
+ * @maskp:	points to an array of unsigned longs that represent a bitmask
+ * @nmaskbits:	The number of bits that are valid in @maskp
+ *
+ * Writes a ASCII representation of a bitmask string into @s.
+ *
+ * Returns the number of bytes written.
+ */
+int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
+		    int nmaskbits)
+{
+	unsigned int len = SEQ_BUF_LEFT(s);
+	int ret;
+
+	WARN_ON((int)len < 0);
+	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
+	s->len += ret;
+	seq_buf_check_len(s);
+
+	return ret;
+}
+
+/**
+ * seq_buf_vprintf - write vprintf style into the sequence buffer
+ * @s: seq_buf descriptor
+ * @fmt: printf format string
+ *
+ * Write a vprintf() style into the sequence buffer.
+ *
+ * Returns the number of bytes written.
+ */
+int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
+{
+	unsigned int len = SEQ_BUF_LEFT(s);
+	int ret;
+
+	if (WARN_ON((int)len < 0))
+		printk("len=%d size=%d s->len=%d\n", len, s->size, s->len);
+	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
+	s->len += ret;
+	seq_buf_check_len(s);
+
+	return len;
+}
+
+/**
+ * seq_buf_bprintf - Write the printf string from binary arguments
+ * @s: seq_buf descriptor
+ * @fmt: The format string for the @binary arguments
+ * @binary: The binary arguments for @fmt.
+ *
+ * When recording in a fast path, a printf may be recorded with just
+ * saving the format and the arguments as they were passed to the
+ * function, instead of wasting cycles converting the arguments into
+ * ASCII characters. Instead, the arguments are saved in a 32 bit
+ * word array that is defined by the format string constraints.
+ *
+ * This function will take the format and the binary array and finish
+ * the conversion into the ASCII string within the buffer.
+ *
+ * Returns number of bytes written.
+ */
+int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
+{
+	unsigned int len = SEQ_BUF_LEFT(s);
+	int ret;
+
+	if (WARN_ON((int)len < 0))
+		printk("len=%d size=%d s->len=%d\n", len, s->size, s->len);
+	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+	s->len += ret;
+	seq_buf_check_len(s);
+
+	return len;
+}
+
+/**
+ * seq_buf_puts - sequence printing of simple string
+ * @s: seq_buf descriptor
+ * @str: simple string to record
+ *
+ * Copy a simple string into the sequence buffer.
+ *
+ * Returns number of bytes written.
+ */
+int seq_buf_puts(struct seq_buf *s, const char *str)
+{
+	unsigned int len = strlen(str);
+
+	if (len > SEQ_BUF_LEFT(s)) {
+		s->overflow = 1;
+		len = SEQ_BUF_LEFT(s);
+	}
+
+	memcpy(s->buffer + s->len, str, len);
+	s->len += len;
+	WARN_ON(s->len > (s->size - 1));
+
+	return len;
+}
+
+/**
+ * seq_buf_putc - sequence printing of simple character
+ * @s: seq_buf descriptor
+ * @c: simple character to record
+ *
+ * Copy a single character into the sequence buffer.
+ *
+ * Returns 1 if the character was written, 0 otherwise.
+ */
+int seq_buf_putc(struct seq_buf *s, unsigned char c)
+{
+	if (SEQ_BUF_LEFT(s) < 1) {
+		s->overflow = 1;
+		return 0;
+	}
+
+	s->buffer[s->len++] = c;
+	WARN_ON(s->len > (s->size - 1));
+
+	return 1;
+}
+
+/**
+ * seq_buf_putmem - write raw data into the sequenc buffer
+ * @s: seq_buf descriptor
+ * @mem: The raw memory to copy into the buffer
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * There may be cases where raw memory needs to be written into the
+ * buffer and a strcpy() would not work. Using this function allows
+ * for such cases.
+ *
+ * Returns the number of bytes written in the buffer.
+ */
+int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
+{
+	if (len > SEQ_BUF_LEFT(s)) {
+		s->overflow = 1;
+		len = SEQ_BUF_LEFT(s);
+	}
+
+	memcpy(s->buffer + s->len, mem, len);
+	s->len += len;
+	WARN_ON(s->len > (s->size - 1));
+
+	return len;
+}
+
+#define MAX_MEMHEX_BYTES	8U
+#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
+
+/**
+ * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
+ * @s: seq_buf descriptor
+ * @mem: The raw memory to write its hex ASCII representation of
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * This is similar to seq_buf_putmem() except instead of just copying the
+ * raw memory into the buffer it writes its ASCII representation of it
+ * in hex characters.
+ *
+ * Returns how much it wrote to the buffer.
+ */
+int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
+		       unsigned int len)
+{
+	unsigned char hex[HEX_CHARS];
+	const unsigned char *data = mem;
+	unsigned int start_len;
+	int i, j;
+	int cnt = 0;
+
+	while (len) {
+		start_len = min(len, HEX_CHARS - 1);
+#ifdef __BIG_ENDIAN
+		for (i = 0, j = 0; i < start_len; i++) {
+#else
+		for (i = start_len-1, j = 0; i >= 0; i--) {
+#endif
+			hex[j++] = hex_asc_hi(data[i]);
+			hex[j++] = hex_asc_lo(data[i]);
+		}
+		if (WARN_ON_ONCE(j == 0 || j/2 > len))
+			break;
+
+		/* j increments twice per loop */
+		len -= j / 2;
+		hex[j++] = ' ';
+
+		cnt += seq_buf_putmem(s, hex, j);
+	}
+	return cnt;
+}
+
+/**
+ * seq_buf_path - copy a path into the sequence buffer
+ * @s: seq_buf descriptor
+ * @path: path to write into the sequence buffer.
+ *
+ * Write a path name into the sequence buffer.
+ *
+ * Returns the number of bytes written into the buffer.
+ */
+int seq_buf_path(struct seq_buf *s, const struct path *path)
+{
+	unsigned int len = SEQ_BUF_LEFT(s);
+	unsigned char *p;
+	unsigned int start = s->len;
+
+	WARN_ON((int)len < 0);
+	p = d_path(path, s->buffer + s->len, len);
+	if (!IS_ERR(p)) {
+		p = mangle_path(s->buffer + s->len, p, "\n");
+		if (p) {
+			s->len = p - s->buffer;
+	WARN_ON(s->len > (s->size - 1));
+			return s->len - start;
+		}
+	} else {
+		s->buffer[s->len++] = '?';
+	WARN_ON(s->len > (s->size - 1));
+		return s->len - start;
+	}
+
+	s->overflow = 1;
+	return 0;
+}
+
+/**
+ * seq_buf_to_user - copy the squence buffer to user space
+ * @s: seq_buf descriptor
+ * @ubuf: The userspace memory location to copy to
+ * @cnt: The amount to copy
+ *
+ * Copies the sequence buffer into the userspace memory pointed to
+ * by @ubuf. It starts from the last read position (@s->readpos)
+ * and writes up to @cnt characters or till it reaches the end of
+ * the content in the buffer (@s->len), which ever comes first.
+ *
+ * On success, it returns a positive number of the number of bytes
+ * it copied.
+ *
+ * On failure it returns -EBUSY if all of the content in the
+ * sequence has been already read, which includes nothing in the
+ * sequenc (@s->len == @s->readpos).
+ *
+ * Returns -EFAULT if the copy to userspace fails.
+ */
+int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
+{
+	int len;
+	int ret;
+
+	if (!cnt)
+		return 0;
+
+	if (s->len <= s->readpos)
+		return -EBUSY;
+
+	len = s->len - s->readpos;
+	if (cnt > len)
+		cnt = len;
+	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
+	if (ret == cnt)
+		return -EFAULT;
+
+	cnt -= ret;
+
+	s->readpos += cnt;
+	return cnt;
+}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8a52839..0c46168 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -938,19 +938,20 @@ out:
 	return ret;
 }
 
+/* TODO add a seq_buf_to_buffer() */
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
 
-	if (s->len <= s->readpos)
+	if (s->seq.len <= s->seq.readpos)
 		return -EBUSY;
 
-	len = s->len - s->readpos;
+	len = s->seq.len - s->seq.readpos;
 	if (cnt > len)
 		cnt = len;
-	memcpy(buf, s->buffer + s->readpos, cnt);
+	memcpy(buf, s->buffer + s->seq.readpos, cnt);
 
-	s->readpos += cnt;
+	s->seq.readpos += cnt;
 	return cnt;
 }
 
@@ -4313,6 +4314,8 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		goto out;
 	}
 
+	trace_seq_init(&iter->seq);
+
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
 	 * changes on it while we are reading.
@@ -4509,18 +4512,18 @@ waitagain:
 	trace_access_lock(iter->cpu_file);
 	while (trace_find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
-		int len = iter->seq.len;
+		int len = iter->seq.seq.len;
 
 		ret = print_trace_line(iter);
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
 			/* don't print partial lines */
-			iter->seq.len = len;
+			iter->seq.seq.len = len;
 			break;
 		}
 		if (ret != TRACE_TYPE_NO_CONSUME)
 			trace_consume(iter);
 
-		if (iter->seq.len >= cnt)
+		if (iter->seq.seq.len >= cnt)
 			break;
 
 		/*
@@ -4536,7 +4539,7 @@ waitagain:
 
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
-	if (iter->seq.readpos >= iter->seq.len)
+	if (iter->seq.seq.readpos >= iter->seq.seq.len)
 		trace_seq_init(&iter->seq);
 
 	/*
@@ -4574,16 +4577,16 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 
 	/* Seq buffer is page-sized, exactly what we need. */
 	for (;;) {
-		count = iter->seq.len;
+		count = iter->seq.seq.len;
 		ret = print_trace_line(iter);
-		count = iter->seq.len - count;
+		count = iter->seq.seq.len - count;
 		if (rem < count) {
 			rem = 0;
-			iter->seq.len -= count;
+			iter->seq.seq.len -= count;
 			break;
 		}
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			iter->seq.len -= count;
+			iter->seq.seq.len -= count;
 			break;
 		}
 
@@ -4664,13 +4667,13 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		/* Copy the data into the page, so we can start over. */
 		ret = trace_seq_to_buffer(&iter->seq,
 					  page_address(spd.pages[i]),
-					  iter->seq.len);
+					  iter->seq.seq.len);
 		if (ret < 0) {
 			__free_page(spd.pages[i]);
 			break;
 		}
 		spd.partial[i].offset = 0;
-		spd.partial[i].len = iter->seq.len;
+		spd.partial[i].len = iter->seq.seq.len;
 
 		trace_seq_init(&iter->seq);
 	}
@@ -5671,7 +5674,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_read_events_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "read events: %ld\n", cnt);
 
-	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
+	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->seq.len);
 
 	kfree(s);
 
@@ -6634,11 +6637,11 @@ void
 trace_printk_seq(struct trace_seq *s)
 {
 	/* Probably should print a warning here. */
-	if (s->len >= TRACE_MAX_PRINT)
-		s->len = TRACE_MAX_PRINT;
+	if (s->seq.len >= TRACE_MAX_PRINT)
+		s->seq.len = TRACE_MAX_PRINT;
 
 	/* should be zero ended, but we are paranoid. */
-	s->buffer[s->len] = 0;
+	s->buffer[s->seq.len] = 0;
 
 	printk(KERN_TRACE "%s", s->buffer);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ef06ce7..6ef274b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1044,7 +1044,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	mutex_unlock(&event_mutex);
 
 	if (file)
-		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);
 
 	kfree(s);
 
@@ -1210,7 +1210,7 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_init(s);
 
 	print_subsystem_event_filter(system, s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);
 
 	kfree(s);
 
@@ -1265,7 +1265,7 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	trace_seq_init(s);
 
 	func(s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);
 
 	kfree(s);
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index f0a0c98..4882734 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1291,9 +1291,9 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 	}
 
 	/* Strip ending newline */
-	if (s->buffer[s->len - 1] == '\n') {
-		s->buffer[s->len - 1] = '\0';
-		s->len--;
+	if (s->buffer[s->seq.len - 1] == '\n') {
+		s->buffer[s->seq.len - 1] = '\0';
+		s->seq.len--;
 	}
 
 	ret = trace_seq_puts(s, " */\n");
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index 1f24ed9..1de9670 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -27,10 +27,19 @@
 #include <linux/trace_seq.h>
 
 /* How much buffer is left on the trace_seq? */
-#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->len)
+#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->seq.len)
 
 /* How much buffer is written? */
-#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
+#define TRACE_SEQ_BUF_USED(s) min((s)->seq.len, (unsigned int)(PAGE_SIZE - 1))
+
+/*
+ * trace_seq should work with being initialized with 0s.
+ */
+static inline void __trace_seq_init(struct trace_seq *s)
+{
+	if (unlikely(!s->seq.size))
+		trace_seq_init(s);
+}
 
 /**
  * trace_print_seq - move the contents of trace_seq into a seq_file
@@ -43,10 +52,11 @@
  */
 int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
-	unsigned int len = TRACE_SEQ_BUF_USED(s);
 	int ret;
 
-	ret = seq_write(m, s->buffer, len);
+	__trace_seq_init(s);
+
+	ret = seq_buf_print_seq(m, &s->seq);
 
 	/*
 	 * Only reset this buffer if we successfully wrote to the
@@ -77,25 +87,25 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
  */
 int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
+	unsigned int save_len = s->seq.len;
 	va_list ap;
-	int ret;
 
-	if (s->full || !len)
+	if (s->full)
 		return 0;
 
+	__trace_seq_init(s);
+
 	va_start(ap, fmt);
-	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	seq_buf_vprintf(&s->seq, fmt, ap);
 	va_end(ap);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
+	if (unlikely(s->seq.overflow)) {
+		s->seq.len = save_len;
 		s->full = 1;
 		return 0;
 	}
 
-	s->len += ret;
-
 	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
@@ -116,14 +126,20 @@ EXPORT_SYMBOL_GPL(trace_seq_printf);
 int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 		      int nmaskbits)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
-	int ret;
+	unsigned int save_len = s->seq.len;
 
-	if (s->full || !len)
+	if (s->full)
 		return 0;
 
-	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
-	s->len += ret;
+	__trace_seq_init(s);
+
+	seq_buf_bitmask(&s->seq, maskp, nmaskbits);
+
+	if (unlikely(s->seq.overflow)) {
+		s->seq.len = save_len;
+		s->full = 1;
+		return 0;
+	}
 
 	return 1;
 }
@@ -144,23 +160,24 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
  */
 int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
+	unsigned int save_len = s->seq.len;
 	int ret;
 
-	if (s->full || !len)
+	if (s->full)
 		return 0;
 
-	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
+	__trace_seq_init(s);
+
+	ret = seq_buf_vprintf(&s->seq, fmt, args);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
+	if (s->seq.overflow) {
+		s->seq.len = save_len;
 		s->full = 1;
 		return 0;
 	}
 
-	s->len += ret;
-
-	return len;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_vprintf);
 
@@ -183,23 +200,24 @@ EXPORT_SYMBOL_GPL(trace_seq_vprintf);
  */
 int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
+	unsigned int save_len = s->seq.len;
 	int ret;
 
-	if (s->full || !len)
+	if (s->full)
 		return 0;
 
-	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+	__trace_seq_init(s);
+
+	ret = seq_buf_bprintf(&s->seq, fmt, binary);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
+	if (s->seq.overflow) {
+		s->seq.len = save_len;
 		s->full = 1;
 		return 0;
 	}
 
-	s->len += ret;
-
-	return len;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_bprintf);
 
@@ -222,13 +240,14 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 	if (s->full)
 		return 0;
 
+	__trace_seq_init(s);
+
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
 		return 0;
 	}
 
-	memcpy(s->buffer + s->len, str, len);
-	s->len += len;
+	seq_buf_putmem(&s->seq, str, len);
 
 	return len;
 }
@@ -251,12 +270,14 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 	if (s->full)
 		return 0;
 
+	__trace_seq_init(s);
+
 	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
 		return 0;
 	}
 
-	s->buffer[s->len++] = c;
+	seq_buf_putc(&s->seq, c);
 
 	return 1;
 }
@@ -279,21 +300,19 @@ int trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 	if (s->full)
 		return 0;
 
+	__trace_seq_init(s);
+
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
 		return 0;
 	}
 
-	memcpy(s->buffer + s->len, mem, len);
-	s->len += len;
+	seq_buf_putmem(&s->seq, mem, len);
 
 	return len;
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem);
 
-#define MAX_MEMHEX_BYTES	8U
-#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-
 /**
  * trace_seq_putmem_hex - write raw memory into the buffer in ASCII hex
  * @s: trace sequence descriptor
@@ -309,35 +328,30 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem);
 int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 			 unsigned int len)
 {
-	unsigned char hex[HEX_CHARS];
-	const unsigned char *data = mem;
-	unsigned int start_len;
-	int i, j;
-	int cnt = 0;
+	unsigned int save_len = s->seq.len;
+	int ret;
 
 	if (s->full)
 		return 0;
 
-	while (len) {
-		start_len = min(len, HEX_CHARS - 1);
-#ifdef __BIG_ENDIAN
-		for (i = 0, j = 0; i < start_len; i++) {
-#else
-		for (i = start_len-1, j = 0; i >= 0; i--) {
-#endif
-			hex[j++] = hex_asc_hi(data[i]);
-			hex[j++] = hex_asc_lo(data[i]);
-		}
-		if (WARN_ON_ONCE(j == 0 || j/2 > len))
-			break;
-
-		/* j increments twice per loop */
-		len -= j / 2;
-		hex[j++] = ' ';
-
-		cnt += trace_seq_putmem(s, hex, j);
+	__trace_seq_init(s);
+
+	/* Each byte is represented by two chars */
+	if (len * 2 > TRACE_SEQ_BUF_LEFT(s)) {
+		s->full = 1;
+		return 0;
+	}
+
+	/* The added spaces can still cause an overflow */
+	ret = seq_buf_putmem_hex(&s->seq, mem, len);
+
+	if (unlikely(s->seq.overflow)) {
+		s->seq.len = save_len;
+		s->full = 1;
+		return 0;
 	}
-	return cnt;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
 
@@ -355,30 +369,28 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
  */
 int trace_seq_path(struct trace_seq *s, const struct path *path)
 {
-	unsigned char *p;
+	unsigned int save_len = s->seq.len;
+	int ret;
 
 	if (s->full)
 		return 0;
 
+	__trace_seq_init(s);
+
 	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
 		return 0;
 	}
 
-	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
-	if (!IS_ERR(p)) {
-		p = mangle_path(s->buffer + s->len, p, "\n");
-		if (p) {
-			s->len = p - s->buffer;
-			return 1;
-		}
-	} else {
-		s->buffer[s->len++] = '?';
-		return 1;
+	ret = seq_buf_path(&s->seq, path);
+
+	if (unlikely(s->seq.overflow)) {
+		s->seq.len = save_len;
+		s->full = 1;
+		return 0;
 	}
 
-	s->full = 1;
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_path);
 
@@ -404,25 +416,7 @@ EXPORT_SYMBOL_GPL(trace_seq_path);
  */
 int trace_seq_to_user(struct trace_seq *s, char __user *ubuf, int cnt)
 {
-	int len;
-	int ret;
-
-	if (!cnt)
-		return 0;
-
-	if (s->len <= s->readpos)
-		return -EBUSY;
-
-	len = s->len - s->readpos;
-	if (cnt > len)
-		cnt = len;
-	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
-	if (ret == cnt)
-		return -EFAULT;
-
-	cnt -= ret;
-
-	s->readpos += cnt;
-	return cnt;
+	__trace_seq_init(s);
+	return seq_buf_to_user(&s->seq, ubuf, cnt);
 }
 EXPORT_SYMBOL_GPL(trace_seq_to_user);
-- 
1.8.5.2

