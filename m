From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH v2 8/9] snic:Add event tracing to capture IO events.
Date: Wed, 11 Mar 2015 10:01:38 -0700
Message-ID: <1426093299-4511-9-git-send-email-nmusini@cisco.com>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-1.cisco.com ([173.37.142.88]:33700 "EHLO
	alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbbCKREP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2015 13:04:15 -0400
In-Reply-To: <1426093299-4511-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

snic_trc.h contains global trace structure definitions for snic driver

snic_trc.c adds tracing functionality to capture various IO events.
It maintains global trace buffer to maintain recent history of IO events.
It helps to understand the sequence of events prior to particular IO event,
or hung, panic, etc,.

v2
Added compile time macro SNIC_DEBUG_FS to handle debugfs dependent functionality.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic_trc.c | 183 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/snic/snic_trc.h | 121 ++++++++++++++++++++++++++++
 2 files changed, 304 insertions(+)
 create mode 100644 drivers/scsi/snic/snic_trc.c
 create mode 100644 drivers/scsi/snic/snic_trc.h

diff --git a/drivers/scsi/snic/snic_trc.c b/drivers/scsi/snic/snic_trc.c
new file mode 100644
index 0000000..5241557
--- /dev/null
+++ b/drivers/scsi/snic/snic_trc.c
@@ -0,0 +1,183 @@
+/*
+ * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/mempool.h>
+#include <linux/errno.h>
+
+#include "snic_io.h"
+#include "snic.h"
+#include "snic_os.h"
+
+/*
+ * snic_get_trc_buf : Allocates a trace record and returns.
+ */
+struct snic_trc_data *
+snic_get_trc_buf(void)
+{
+	struct snic_trc *trc = &snic_glob->trc;
+	struct snic_trc_data *td = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&trc->lock, flags);
+	td = &trc->buf[trc->wr_idx];
+	trc->wr_idx++;
+
+	if (trc->wr_idx == trc->max_idx)
+		trc->wr_idx = 0;
+
+	if (trc->wr_idx != trc->rd_idx) {
+		spin_unlock_irqrestore(&trc->lock, flags);
+
+		goto end;
+	}
+
+	trc->rd_idx++;
+	if (trc->rd_idx == trc->max_idx)
+		trc->rd_idx = 0;
+
+	td->ts = 0;	/* Marker for checking the record, for complete data*/
+	spin_unlock_irqrestore(&trc->lock, flags);
+
+end:
+
+	return td;
+} /* end of snic_get_trc_buf */
+
+/*
+ * snic_fmt_trc_data : Formats trace data for printing.
+ */
+static int
+snic_fmt_trc_data(struct snic_trc_data *td, char *buf, int buf_sz)
+{
+	int len = 0;
+	struct timespec tmspec;
+
+	jiffies_to_timespec(td->ts, &tmspec);
+
+	len += snprintf(buf, buf_sz,
+			"%lu.%10lu %-25s %3d %4x %16llx %16llx %16llx %16llx %16llx\n",
+			tmspec.tv_sec,
+			tmspec.tv_nsec,
+			td->fn,
+			td->hno,
+			td->tag,
+			td->data[0], td->data[1], td->data[2], td->data[3],
+			td->data[4]);
+
+	return len;
+} /* end of snic_fmt_trc_data */
+
+/*
+ * snic_get_trc_data : Returns a formatted trace buffer.
+ */
+int
+snic_get_trc_data(char *buf, int buf_sz)
+{
+	struct snic_trc_data *td = NULL;
+	struct snic_trc *trc = &snic_glob->trc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&trc->lock, flags);
+	if (trc->rd_idx == trc->wr_idx) {
+		spin_unlock_irqrestore(&trc->lock, flags);
+
+		return -1;
+	}
+	td = &trc->buf[trc->rd_idx];
+
+	if (td->ts == 0) {
+		/* write in progress. */
+		spin_unlock_irqrestore(&trc->lock, flags);
+
+		return -1;
+	}
+
+	trc->rd_idx++;
+	if (trc->rd_idx == trc->max_idx)
+		trc->rd_idx = 0;
+	spin_unlock_irqrestore(&trc->lock, flags);
+
+	return snic_fmt_trc_data(td, buf, buf_sz);
+} /* end of snic_get_trc_data */
+
+/*
+ * snic_trc_init() : Configures Trace Functionality for snic.
+ */
+int
+snic_trc_init(void)
+{
+	struct snic_trc *trc = &snic_glob->trc;
+	void *tbuf = NULL;
+	int tbuf_sz = 0, ret;
+
+	BUILD_BUG_ON(sizeof(struct snic_trc_data) != 64);
+
+	tbuf_sz = (snic_trace_max_pages * PAGE_SIZE);
+	tbuf = vmalloc(tbuf_sz);
+	if (!tbuf) {
+		SNIC_ERR("Failed to Allocate Trace Buffer Size. %d\n", tbuf_sz);
+		SNIC_ERR("Trace Facility not enabled.\n");
+		ret = -ENOMEM;
+
+		return ret;
+	}
+
+	memset(tbuf, 0, tbuf_sz);
+	trc->buf = (struct snic_trc_data *) tbuf;
+	spin_lock_init(&trc->lock);
+
+	ret = snic_trc_debugfs_init();
+	if (ret) {
+		SNIC_ERR("Failed to create Debugfs Files.\n");
+
+		goto error;
+	}
+
+	trc->max_idx = (tbuf_sz / SNIC_TRC_ENTRY_SZ);
+	trc->rd_idx = trc->wr_idx = 0;
+	trc->enable = 1;
+	SNIC_INFO("Trace Facility Enabled.\n Trace Buffer SZ %lu Pages.\n",
+		  tbuf_sz / PAGE_SIZE);
+	ret = 0;
+
+	return ret;
+
+error:
+	snic_trc_free();
+
+	return ret;
+} /* end of snic_trc_init */
+
+/*
+ * snic_trc_free : Releases the trace buffer and disables the tracing.
+ */
+void
+snic_trc_free(void)
+{
+	struct snic_trc *trc = &snic_glob->trc;
+
+	trc->enable = 0;
+	snic_trc_debugfs_term();
+
+	if (trc->buf) {
+		vfree(trc->buf);
+		trc->buf = NULL;
+	}
+
+	SNIC_INFO("Trace Facility Disabled.\n");
+} /* end of snic_trc_free */
diff --git a/drivers/scsi/snic/snic_trc.h b/drivers/scsi/snic/snic_trc.h
new file mode 100644
index 0000000..99de384
--- /dev/null
+++ b/drivers/scsi/snic/snic_trc.h
@@ -0,0 +1,121 @@
+/*
+ * Copyright 2014 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef __SNIC_TRC_H
+#define __SNIC_TRC_H
+
+#ifdef SNIC_DEBUG_FS
+
+extern ssize_t simple_read_from_buffer(void __user *to,
+					size_t count,
+					loff_t *ppos,
+					const void *from,
+					size_t available);
+
+extern unsigned int snic_trace_max_pages;
+
+/* Global Data structure for trace to manage trace functionality */
+struct snic_trc_data {
+	u64	ts;		/* Time Stamp */
+	char	*fn;		/* Ptr to Function Name */
+	u32	hno;		/* SCSI Host ID */
+	u32	tag;		/* Command Tag */
+	u64 data[5];
+} __attribute__((__packed__));
+
+#define SNIC_TRC_ENTRY_SZ  64	/* in Bytes */
+
+struct snic_trc {
+	spinlock_t lock;
+	struct snic_trc_data *buf;	/* Trace Buffer */
+	u32	max_idx;		/* Max Index into trace buffer */
+	u32	rd_idx;
+	u32	wr_idx;
+	u32	enable;			/* Control Variable for Tracing */
+
+	struct dentry *trc_enable;	/* debugfs file object */
+	struct dentry *trc_file;
+};
+
+int snic_trc_init(void);
+void snic_trc_free(void);
+int snic_trc_debugfs_init(void);
+void snic_trc_debugfs_term(void);
+struct snic_trc_data *snic_get_trc_buf(void);
+int snic_get_trc_data(char *buf, int buf_sz);
+
+int snic_debugfs_init(void);
+void snic_debugfs_term(void);
+
+static inline void
+snic_trace(char *fn, u16 hno, u32 tag, u64 d1, u64 d2, u64 d3, u64 d4, u64 d5)
+{
+	struct snic_trc_data *tr_rec = snic_get_trc_buf();
+
+	if (!tr_rec)
+		return;
+
+	tr_rec->fn = (char *)fn;
+	tr_rec->hno = hno;
+	tr_rec->tag = tag;
+	tr_rec->data[0] = d1;
+	tr_rec->data[1] = d2;
+	tr_rec->data[2] = d3;
+	tr_rec->data[3] = d4;
+	tr_rec->data[4] = d5;
+	tr_rec->ts = jiffies; /* Update time stamp at last */
+}
+
+#define SNIC_TRC(_hno, _tag, d1, d2, d3, d4, d5)			\
+	do {								\
+		if (unlikely(snic_glob->trc.enable))			\
+			snic_trace((char *)__func__,			\
+				   (u16)(_hno),				\
+				   (u32)(_tag),				\
+				   (u64)(d1),				\
+				   (u64)(d2),				\
+				   (u64)(d3),				\
+				   (u64)(d4),				\
+				   (u64)(d5));				\
+	} while (0)
+#else
+
+#define SNIC_TRC(_hno, _tag, d1, d2, d3, d4, d5)	\
+	do {						\
+		if (unlikely(snic_log_level & 0x2))	\
+			SNIC_DBG("SnicTrace: %s %2u %2u %llx %llx %llx %llx %llx", \
+				 (char *)__func__,	\
+				 (u16)(_hno),		\
+				 (u32)(_tag),		\
+				 (u64)(d1),		\
+				 (u64)(d2),		\
+				 (u64)(d3),		\
+				 (u64)(d4),		\
+				 (u64)(d5));		\
+	} while (0);
+#endif /* end of SNIC_DEBUG_FS */
+
+#define SNIC_TRC_CMD(sc)	\
+	((u64)sc->cmnd[0] << 56 | (u64)sc->cmnd[7] << 40 |	\
+	 (u64)sc->cmnd[8] << 32 | (u64)sc->cmnd[2] << 24 |	\
+	 (u64)sc->cmnd[3] << 16 | (u64)sc->cmnd[4] << 8 |	\
+	 (u64)sc->cmnd[5])
+
+#define SNIC_TRC_CMD_STATE_FLAGS(sc)	\
+	((u64) CMD_FLAGS(sc) << 32 | CMD_STATE(sc))
+
+#endif /* end of __SNIC_TRC_H */
-- 
1.8.5.4

