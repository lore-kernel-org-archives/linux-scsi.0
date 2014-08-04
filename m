From: jgross@suse.com
Subject: [PATCH V3 1/4] Add XEN pvSCSI protocol description
Date: Mon,  4 Aug 2014 10:27:47 +0200
Message-ID: <1407140870-542-2-git-send-email-jgross@suse.com>
References: <1407140870-542-1-git-send-email-jgross@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbaHDI2G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2014 04:28:06 -0400
In-Reply-To: <1407140870-542-1-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com
Cc: Juergen Gross <jgross@suse.com>

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
 include/xen/interface/io/vscsiif.h | 208 +++++++++++++++++++++++++++++++++++++
 1 file changed, 208 insertions(+)
 create mode 100644 include/xen/interface/io/vscsiif.h

diff --git a/include/xen/interface/io/vscsiif.h b/include/xen/interface/io/vscsiif.h
new file mode 100644
index 0000000..ead1c0b
--- /dev/null
+++ b/include/xen/interface/io/vscsiif.h
@@ -0,0 +1,208 @@
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
+/*
+ * Front->back notifications: When enqueuing a new request, sending a
+ * notification can be made conditional on req_event (i.e., the generic
+ * hold-off mechanism provided by the ring macros). Backends must set
+ * req_event appropriately (e.g., using RING_FINAL_CHECK_FOR_REQUESTS()).
+ *
+ * Back->front notifications: When enqueuing a new response, sending a
+ * notification can be made conditional on rsp_event (i.e., the generic
+ * hold-off mechanism provided by the ring macros). Frontends must set
+ * rsp_event appropriately (e.g., using RING_FINAL_CHECK_FOR_RESPONSES()).
+ */
+
+/*
+ * Feature and Parameter Negotiation
+ * =================================
+ * The two halves of a Xen pvSCSI driver utilize nodes within the XenStore to
+ * communicate capabilities and to negotiate operating parameters.  This
+ * section enumerates these nodes which reside in the respective front and
+ * backend portions of the XenStore, following the XenBus convention.
+ *
+ * All data in the XenStore is stored as strings.  Nodes specifying numeric
+ * values are encoded in decimal.  Integer value ranges listed below are
+ * expressed as fixed sized integer types capable of storing the conversion
+ * of a properly formated node string, without loss of information.
+ *
+ * Any specified default value is in effect if the corresponding XenBus node
+ * is not present in the XenStore.
+ *
+ * XenStore nodes in sections marked "PRIVATE" are solely for use by the
+ * driver side whose XenBus tree contains them.
+ *
+ *****************************************************************************
+ *                            Backend XenBus Nodes
+ *****************************************************************************
+ *
+ *------------------ Backend Device Identification (PRIVATE) ------------------
+ *
+ * p-devname
+ *      Values:         string
+ *
+ *      A free string used to identify the physical device (e.g. a disk name).
+ *
+ * p-dev
+ *      Values:         string
+ *
+ *      A string specifying the backend device: either a 4-tuple "h:c:t:l"
+ *      (host, controller, target, lun, all integers), or a WWN (e.g.
+ *      "naa.60014054ac780582").
+ *
+ * v-dev
+ *      Values:         string
+ *
+ *      A string specifying the frontend device in form of a 4-tuple "h:c:t:l"
+ *      (host, controller, target, lun, all integers).
+ *
+ *--------------------------------- Features ---------------------------------
+ *
+ * feature-sg-grant
+ *      Values:         <uint16_t>
+ *      Default Value:  0
+ *
+ *      Specifies the maximum number of scatter/gather elements in grant pages
+ *      supported. If not set, the backend supports up to VSCSIIF_SG_TABLESIZE
+ *      SG elements specified directly in the request.
+ *
+ *****************************************************************************
+ *                            Frontend XenBus Nodes
+ *****************************************************************************
+ *
+ *----------------------- Request Transport Parameters -----------------------
+ *
+ * event-channel
+ *      Values:         <uint32_t>
+ *
+ *      The identifier of the Xen event channel used to signal activity
+ *      in the ring buffer.
+ *
+ * ring-ref
+ *      Values:         <uint32_t>
+ *
+ * protocol
+ *      Values:         string (XEN_IO_PROTO_ABI_*)
+ *      Default Value:  XEN_IO_PROTO_ABI_NATIVE
+ *
+ *      The machine ABI rules governing the format of all ring request and
+ *      response structures.
+ */
+
+/* Requests from the frontend to the backend */
+
+/*
+ * Request a SCSI operation specified via a CDB in vscsiif_request.cmnd.
+ * The target is specified via channel, id and lun.
+ */
+#define VSCSIIF_ACT_SCSI_CDB		1
+
+/*
+ * Request abort of a running operation for the specified target given by
+ * channel, id, lun and the operation's rqid in ref_rqid.
+ */
+#define VSCSIIF_ACT_SCSI_ABORT		2
+
+/*
+ * Request a device reset of the specified target (channel and id).
+ */
+#define VSCSIIF_ACT_SCSI_RESET		3
+
+/*
+ * Maximum scatter/gather segments per request.
+ *
+ * Considering balance between allocating at least 16 "vscsiif_request"
+ * structures on one page (4096 bytes) and the number of scatter/gather
+ * elements needed, we decided to use 26 as a magic number.
+ *
+ * If "feature-sg-grant" is set, more scatter/gather elements can be specified
+ * by placing them in one or more (up to VSCSIIF_SG_TABLESIZE) granted pages.
+ * In this case the vscsiif_request seg elements don't contain references to
+ * the user data, but to the SG elements referencing the user data.
+ */
+#define VSCSIIF_SG_TABLESIZE		26
+
+/*
+ * based on Linux kernel 2.6.18, still valid
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
+	uint8_t cmd_len;	/* valid CDB bytes */
+
+	uint8_t cmnd[VSCSIIF_MAX_COMMAND_SIZE];	/* the CDB */
+	uint16_t timeout_per_command;
+	uint16_t channel, id, lun;	/* (virtual) device specification */
+	uint16_t ref_rqid;		/* command abort reference */
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

