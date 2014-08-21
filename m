From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH V5 2/5] Add XEN pvSCSI protocol description
Date: Thu, 21 Aug 2014 15:26:26 -0400
Message-ID: <20140821192626.GC18662@laptop.dumpdata.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>
 <1408354310-6362-3-git-send-email-jgross@suse.com>
 <20140820132503.GE3120@laptop.dumpdata.com>
 <53F4AA55.3030004@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23878 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaHUT1K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2014 15:27:10 -0400
Content-Disposition: inline
In-Reply-To: <53F4AA55.3030004@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com, nab@linux-iscsi.org

On Wed, Aug 20, 2014 at 04:01:57PM +0200, Juergen Gross wrote:
> On 08/20/2014 03:25 PM, Konrad Rzeszutek Wilk wrote:
> >On Mon, Aug 18, 2014 at 11:31:47AM +0200, jgross@suse.com wrote:
> >>From: Juergen Gross <jgross@suse.com>
> >>
> >>Add the definition of pvSCSI protocol used between the pvSCSI frontend in a
> >>XEN domU and the pvSCSI backend in a XEN driver domain (usually Dom0).
> >>
> >>This header was originally provided by Fujitsu for XEN based on Linux 2.6.18.
> >>Changes are:
> >>- added comment
> >>- adapt to Linux style guide
> >>- add support for larger SG-lists by putting them in an own granted page
> >>- remove stale definitions
> >>
> >>Signed-off-by: Juergen Gross <jgross@suse.com>
> >>---
> >>  include/xen/interface/io/vscsiif.h | 214 +++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 214 insertions(+)
> >>  create mode 100644 include/xen/interface/io/vscsiif.h
> >>
> >>diff --git a/include/xen/interface/io/vscsiif.h b/include/xen/interface/io/vscsiif.h
> >>new file mode 100644
> >>index 0000000..4291889
> >>--- /dev/null
> >>+++ b/include/xen/interface/io/vscsiif.h
> >>@@ -0,0 +1,214 @@
> >>+/******************************************************************************
> >>+ * vscsiif.h
> >>+ *
> >>+ * Based on the blkif.h code.
> >>+ *
> >>+ * This interface is to be regarded as a stable API between XEN domains
> >>+ * running potentially different Linux kernel versions.
> >>+ *
> >>+ * Permission is hereby granted, free of charge, to any person obtaining a copy
> >>+ * of this software and associated documentation files (the "Software"), to
> >>+ * deal in the Software without restriction, including without limitation the
> >>+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> >>+ * sell copies of the Software, and to permit persons to whom the Software is
> >>+ * furnished to do so, subject to the following conditions:
> >>+ *
> >>+ * The above copyright notice and this permission notice shall be included in
> >>+ * all copies or substantial portions of the Software.
> >>+ *
> >>+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> >>+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> >>+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> >>+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> >>+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> >>+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> >>+ * DEALINGS IN THE SOFTWARE.
> >>+ *
> >>+ * Copyright(c) FUJITSU Limited 2008.
> >>+ */
> >>+
> >>+#ifndef __XEN__PUBLIC_IO_SCSI_H__
> >>+#define __XEN__PUBLIC_IO_SCSI_H__
> >>+
> >>+#include "ring.h"
> >>+#include "../grant_table.h"
> >>+
> >>+/*
> >>+ * Front->back notifications: When enqueuing a new request, sending a
> >>+ * notification can be made conditional on req_event (i.e., the generic
> >>+ * hold-off mechanism provided by the ring macros). Backends must set
> >>+ * req_event appropriately (e.g., using RING_FINAL_CHECK_FOR_REQUESTS()).
> >>+ *
> >>+ * Back->front notifications: When enqueuing a new response, sending a
> >>+ * notification can be made conditional on rsp_event (i.e., the generic
> >>+ * hold-off mechanism provided by the ring macros). Frontends must set
> >>+ * rsp_event appropriately (e.g., using RING_FINAL_CHECK_FOR_RESPONSES()).
> >>+ */
> >>+
> >>+/*
> >>+ * Feature and Parameter Negotiation
> >>+ * =================================
> >>+ * The two halves of a Xen pvSCSI driver utilize nodes within the XenStore to
> >>+ * communicate capabilities and to negotiate operating parameters.  This
> >>+ * section enumerates these nodes which reside in the respective front and
> >>+ * backend portions of the XenStore, following the XenBus convention.
> >>+ *
> >>+ * All data in the XenStore is stored as strings.  Nodes specifying numeric
> >>+ * values are encoded in decimal.  Integer value ranges listed below are
> >>+ * expressed as fixed sized integer types capable of storing the conversion
> >>+ * of a properly formated node string, without loss of information.
> >>+ *
> >>+ * Any specified default value is in effect if the corresponding XenBus node
> >>+ * is not present in the XenStore.
> >>+ *
> >>+ * XenStore nodes in sections marked "PRIVATE" are solely for use by the
> >>+ * driver side whose XenBus tree contains them.
> >>+ *
> >>+ *****************************************************************************
> >>+ *                            Backend XenBus Nodes
> >>+ *****************************************************************************
> >>+ *
> >>+ *------------------ Backend Device Identification (PRIVATE) ------------------
> >>+ *
> >>+ * p-devname
> >>+ *      Values:         string
> >>+ *
> >>+ *      A free string used to identify the physical device (e.g. a disk name).
> >>+ *
> >>+ * p-dev
> >>+ *      Values:         string
> >>+ *
> >>+ *      A string specifying the backend device: either a 4-tuple "h:c:t:l"
> >>+ *      (host, controller, target, lun, all integers), or a WWN (e.g.
> >>+ *      "naa.60014054ac780582").
> >>+ *
> >>+ * v-dev
> >>+ *      Values:         string
> >>+ *
> >>+ *      A string specifying the frontend device in form of a 4-tuple "h:c:t:l"
> >>+ *      (host, controller, target, lun, all integers).
> >>+ *
> >>+ *--------------------------------- Features ---------------------------------
> >>+ *
> >>+ * feature-sg-grant
> >>+ *      Values:         <uint16_t>
> >>+ *      Default Value:  0
> >>+ *
> >>+ *      Specifies the maximum number of scatter/gather elements in grant pages
> >>+ *      supported. If not set, the backend supports up to VSCSIIF_SG_TABLESIZE
> >>+ *      SG elements specified directly in the request.
> >>+ *
> >>+ *****************************************************************************
> >>+ *                            Frontend XenBus Nodes
> >>+ *****************************************************************************
> >>+ *
> >>+ *----------------------- Request Transport Parameters -----------------------
> >>+ *
> >>+ * event-channel
> >>+ *      Values:         <uint32_t>
> >>+ *
> >>+ *      The identifier of the Xen event channel used to signal activity
> >>+ *      in the ring buffer.
> >>+ *
> >>+ * ring-ref
> >>+ *      Values:         <uint32_t>
> >
> >Should there a bit of explanation here about what 'ring ref' is?
> 
> Uuh, yes. I'll add it.
> 
> >
> >>+ *
> >>+ * protocol
> >>+ *      Values:         string (XEN_IO_PROTO_ABI_*)
> >>+ *      Default Value:  XEN_IO_PROTO_ABI_NATIVE
> >>+ *
> >>+ *      The machine ABI rules governing the format of all ring request and
> >>+ *      response structures.
> >>+ */
> >>+
> >>+/* Requests from the frontend to the backend */
> >>+
> >>+/*
> >>+ * Request a SCSI operation specified via a CDB in vscsiif_request.cmnd.
> >>+ * The target is specified via channel, id and lun.
> >>+ */
> >>+#define VSCSIIF_ACT_SCSI_CDB		1
> >>+
> >>+/*
> >>+ * Request abort of a running operation for the specified target given by
> >>+ * channel, id, lun and the operation's rqid in ref_rqid.
> >>+ */
> >>+#define VSCSIIF_ACT_SCSI_ABORT		2
> >>+
> >>+/*
> >>+ * Request a device reset of the specified target (channel and id).
> >>+ */
> >>+#define VSCSIIF_ACT_SCSI_RESET		3
> >>+
> >>+/*
> >>+ * Preset scatter/gather elements for a following request. Deprecated.
> >>+ * Keeping the define only to avoid usage of the value "4" for other actions.
> >>+ */
> >>+#define VSCSIIF_ACT_SCSI_SG_PRESET	4
> >>+
> >>+/*
> >>+ * Maximum scatter/gather segments per request.
> >>+ *
> >>+ * Considering balance between allocating at least 16 "vscsiif_request"
> >>+ * structures on one page (4096 bytes) and the number of scatter/gather
> >>+ * elements needed, we decided to use 26 as a magic number.
> >>+ *
> >>+ * If "feature-sg-grant" is set, more scatter/gather elements can be specified
> >>+ * by placing them in one or more (up to VSCSIIF_SG_TABLESIZE) granted pages.
> >>+ * In this case the vscsiif_request seg elements don't contain references to
> >>+ * the user data, but to the SG elements referencing the user data.
> >
> >That sounds like the indirect descriptors that virtio and xen-block has.
> >More questions about that below.
> >>+ */
> >>+#define VSCSIIF_SG_TABLESIZE		26
> >>+
> >>+/*
> >>+ * based on Linux kernel 2.6.18, still valid
> >>+ * Changing these values requires support of multiple protocols via the rings
> >>+ * as "old clients" will blindly use these values and the resulting structure
> >>+ * sizes.
> >>+ */
> >>+#define VSCSIIF_MAX_COMMAND_SIZE	16
> >>+#define VSCSIIF_SENSE_BUFFERSIZE	96
> >>+
> >>+struct scsiif_request_segment {
> >>+	grant_ref_t gref;
> >>+	uint16_t offset;
> >>+	uint16_t length;
> >>+};
> >
> >Yeey, 8 byte data structure!
> >>+
> >>+/* Size of one request is 252 bytes */
> >>+struct vscsiif_request {
> >>+	uint16_t rqid;		/* private guest value, echoed in resp  */
> >>+	uint8_t act;		/* command between backend and frontend */
> >>+	uint8_t cmd_len;	/* valid CDB bytes */
> >>+
> >>+	uint8_t cmnd[VSCSIIF_MAX_COMMAND_SIZE];	/* the CDB */
> >>+	uint16_t timeout_per_command;
> >>+	uint16_t channel, id, lun;	/* (virtual) device specification */
> >>+	uint16_t ref_rqid;		/* command abort reference */
> >>+	uint8_t sc_data_direction;	/* for DMA_TO_DEVICE(1)
> >>+					   DMA_FROM_DEVICE(2)
> >>+					   DMA_NONE(3) requests */
> >>+	uint8_t nr_segments;		/* Number of pieces of scatter-gather */
> >>+#define VSCSIIF_SG_GRANT	0x80	/* flag: SG elements via grant page */
> >>+					/* nr_segments counts grant pages with
> >>+					   SG elements
> >
> >Stop missing. However I am a bit lost. It says that the 'nr_segments' will have the
> >count of grant pages with SG elements. Does that mean the req.seg[0].gref points
> >to an page which will have an array of grant references? And each grant reference
> >will point to a data page? What about the 'offset' and 'length' of them?
> >
> >Or does it mean that the 'reg.seg[0].gref' points an page that is filled with
> >'struct scsiif_request_segment' ? If so, where would the could of those
> >segments be in? In 'nr_segments'? If that is so where does the VSCSIIF_SG_GRANT
> >go? Won't we collide?
> 
> nr_segments (without the VSCSIIF_SG_GRANT bit) always counts the number
> of populated seg[] entries. If VSCSIIF_SG_GRANT is set, each seg[] entry
> references another array of struct scsiif_request_segment using a grant
> ref, offset into the granted page and a length of the array in bytes.

Shouldn't there be a comment about that? The blkif.h has a pretty lengthy
one when it comes to indirect descriptors that could be copied as it
sounds exactly like the same thing.
> 
> The resulting number of struct scsiif_request_segment is the sum of
> seg[0..nr_segments-1].length / sizeof(struct scsiif_request_segment).
> 

Where the nr_segments can only go Up to VSCSIIF_SG_TABLESIZE, so the max
total SG entries you can is 13312 ( 4096 / 8 = 512 max per page, times
26).
> >
> >
> >>+					   usable if "feature-sg-grant" set */
> >>+
> >>+	struct scsiif_request_segment seg[VSCSIIF_SG_TABLESIZE];
> >>+	uint32_t reserved[3];
> >
> >Or is the flag suppose to show up here?
> 
> No. There is no guarantee an "old" domU not aware of "feature-sg-grant"
> will have set reserved[] to zero.

<nods>
> 
> >>+};
> >>+
> >
> >The previous structure had an comment about the size of the structure.
> >Should it be here as well?
> 
> I can add one.

Thank you!
> 
> >
> >>+struct vscsiif_response {
> >>+	uint16_t rqid;		/* identifies request */
> >>+	uint8_t padding;
> >>+	uint8_t sense_len;
> >>+	uint8_t sense_buffer[VSCSIIF_SENSE_BUFFERSIZE];
> >>+	int32_t rslt;
> >>+	uint32_t residual_len;	/* request bufflen -
> >>+				   return the value from physical device */
> >>+	uint32_t reserved[36];
> >>+};
> >>+
> >>+DEFINE_RING_TYPES(vscsiif, struct vscsiif_request, struct vscsiif_response);
> >>+
> >>+#endif /*__XEN__PUBLIC_IO_SCSI_H__*/
> 
