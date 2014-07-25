From: jgross@suse.com
Subject: [PATCH V2 1/4] Add XEN pvSCSI protocol description
Date: Fri, 25 Jul 2014 13:37:30 +0200
Message-ID: <1406288253-13293-2-git-send-email-jgross@suse.com>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1406288253-13293-1-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: jgross@suse.com, xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com, target-devel@vger.kernel.org, konrad.wilk@oracle.com
List-Id: linux-scsi@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Add the definition of pvSCSI protocol used between the pvSCSI frontend in a
XEN domU and the pvSCSI backend in a XEN driver domain (usually Dom0).

This header was originally provided by Fujitsu for XEN based on Linux 2.6.18.
Changes are:
- added comment
- adapt to Linux style guide
- add support for larger SG-lists by putting them in an own granted page
- remove stale definitions

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 include/xen/interface/io/vscsiif.h | 102 +++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100644 include/xen/interface/io/vscsiif.h

diff --git a/include/xen/interface/io/vscsiif.h b/include/xen/interface/io/vscsiif.h
new file mode 100644
index 0000000..8bc747d
--- /dev/null
+++ b/include/xen/interface/io/vscsiif.h
@@ -0,0 +1,102 @@
+/******************************************************************************
+ * vscsiif.h
+ *
+ * Based on the blkif.h code.
+ *
+ * This interface is to be regarded as a stable API between XEN domains
+ * running potentially different Linux kernel versions.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright(c) FUJITSU Limited 2008.
+ */
+
+#ifndef __XEN__PUBLIC_IO_SCSI_H__
+#define __XEN__PUBLIC_IO_SCSI_H__
+
+#include "ring.h"
+#include "../grant_table.h"
+
+/* commands between backend and frontend */
+#define VSCSIIF_ACT_SCSI_CDB		1	/* SCSI CDB command */
+#define VSCSIIF_ACT_SCSI_ABORT		2	/* SCSI Device(Lun) Abort*/
+#define VSCSIIF_ACT_SCSI_RESET		3	/* SCSI Device(Lun) Reset*/
+
+/*
+ * Maximum scatter/gather segments per request.
+ *
+ * Considering balance between allocating at least 16 "vscsiif_request"
+ * structures on one page (4096 bytes) and the number of scatter/gather
+ * elements needed, we decided to use 26 as a magic number.
+ */
+#define VSCSIIF_SG_TABLESIZE		26
+
+/*
+ * based on Linux kernel 2.6.18
+ * Changing these values requires support of multiple protocols via the rings
+ * as "old clients" will blindly use these values and the resulting structure
+ * sizes.
+ */
+#define VSCSIIF_MAX_COMMAND_SIZE	16
+#define VSCSIIF_SENSE_BUFFERSIZE	96
+
+struct scsiif_request_segment {
+	grant_ref_t gref;
+	uint16_t offset;
+	uint16_t length;
+};
+
+/* Size of one request is 252 bytes */
+struct vscsiif_request {
+	uint16_t rqid;		/* private guest value, echoed in resp  */
+	uint8_t act;		/* command between backend and frontend */
+	uint8_t cmd_len;
+
+	uint8_t cmnd[VSCSIIF_MAX_COMMAND_SIZE];
+	uint16_t timeout_per_command;	/* The command is issued by twice
+					   the value in Backend. */
+	uint16_t channel, id, lun;
+	uint16_t padding;
+	uint8_t sc_data_direction;	/* for DMA_TO_DEVICE(1)
+					   DMA_FROM_DEVICE(2)
+					   DMA_NONE(3) requests */
+	uint8_t nr_segments;		/* Number of pieces of scatter-gather */
+#define VSCSIIF_SG_GRANT	0x80	/* flag: SG elements via grant page */
+					/* nr_segments counts grant pages with
+					   SG elements
+					   usable if "feature-sg-grant" set */
+
+	struct scsiif_request_segment seg[VSCSIIF_SG_TABLESIZE];
+	uint32_t reserved[3];
+};
+
+struct vscsiif_response {
+	uint16_t rqid;		/* identifies request */
+	uint8_t padding;
+	uint8_t sense_len;
+	uint8_t sense_buffer[VSCSIIF_SENSE_BUFFERSIZE];
+	int32_t rslt;
+	uint32_t residual_len;	/* request bufflen -
+				   return the value from physical device */
+	uint32_t reserved[36];
+};
+
+DEFINE_RING_TYPES(vscsiif, struct vscsiif_request, struct vscsiif_response);
+
+#endif /*__XEN__PUBLIC_IO_SCSI_H__*/
-- 
1.8.4.5
