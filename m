From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] scsi: add sg_io_v4 structure
Date: Sat, 16 Dec 2006 00:18:24 +0900 (JST)
Message-ID: <20061216001758I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:38626 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbWLOT4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Dec 2006 14:56:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dougg@torque.net, jens.axboe@oracle.com

This patch adds sg_io_v4 structure that Doug proposed last month.

There's one major change from the RFC. I dropped iovec, which needs
compat stuff. The bsg code simply calls blk_rq_map_user against
dout_xferp/din_xferp. So if possible, the page frames are directly
mapped. If not possible, the block layer allocates new page frames and
does memory copies.

Doug, could you comment on this?

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

---
 include/scsi/sg.h |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 519c49a..3877fb3 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -107,6 +107,45 @@ typedef struct sg_io_hdr
     unsigned int info;          /* [o] auxiliary information */
 } sg_io_hdr_t;  /* 64 bytes long (on i386) */
 
+struct sg_io_v4 {
+	int32_t guard;		/* [i] 'Q' to differentiate from v3 */
+	uint32_t protocol;	/* [i] 0 -> SCSI , .... */
+	uint32_t subprotocol;	/* [i] 0 -> SCSI command, 1 -> SCSI task
+				   management function, .... */
+
+	uint32_t request_len;	/* [i] in bytes */
+	uint64_t request;	/* [i], [*i] {SCSI: cdb} */
+	uint32_t request_attr;	/* [i] {SCSI: task attribute} */
+	uint32_t request_tag;	/* [i] {SCSI: task tag (only if flagged)} */
+	uint32_t request_priority;	/* [i] {SCSI: task priority} */
+	uint32_t max_response_len;	/* [i] in bytes */
+	uint64_t response;	/* [i], [*o] {SCSI: (auto)sense data} */
+
+	/* "din_" for data in (from device); "dout_" for data out (to device) */
+	uint32_t dout_xfer_len;	/* [i] bytes to be transferred to device */
+	uint32_t din_xfer_len;	/* [i] bytes to be transferred from device */
+	uint64_t dout_xferp;	/* [i], [*i] */
+	uint64_t din_xferp;	/* [i], [*o] */
+
+	uint32_t timeout;	/* [i] units: millisecond */
+	uint32_t flags;		/* [i] bit mask */
+	uint64_t usr_ptr;	/* [i->o] unused internally */
+	uint32_t spare_in;	/* [i] */
+
+	uint32_t driver_status;	/* [o] 0 -> ok */
+	uint32_t transport_status;	/* [o] 0 -> ok */
+	uint32_t device_status;	/* [o] {SCSI: command completion status} */
+	uint32_t retry_delay;	/* [o] {SCSI: status auxiliary information} */
+	uint32_t info;		/* [o] additional information */
+	uint32_t duration;	/* [o] time to complete, in milliseconds */
+	uint32_t response_len;	/* [o] bytes of response actually written */
+	int32_t din_resid;	/* [o] actual_din_xfer_len - din_xfer_len */
+	uint32_t generated_tag;	/* [o] {SCSI: task tag that transport chose} */
+	uint32_t spare_out;	/* [o] */
+
+	uint32_t padding;
+};
+
 #define SG_INTERFACE_ID_ORIG 'S'
 
 /* Use negative values to flag difference from original sg_header structure */
-- 
1.4.1.1


