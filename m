From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/28] fcoe: make it possible to verify fcoe with sparse
Date: Tue, 20 Jul 2010 15:19:15 -0700
Message-ID: <20100720221915.17116.93752.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12642 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0GTWTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:16 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bart.vanassche@gmail.com>, jeykholt@cisco.com

From: Bart Van Assche <bvanassche@acm.org>

Analyzing fcoe with sparse currently fails. This is because struct
fcoe_rcv_info contains two enum members that have been declared with
__attribute__((packed)). Apparently gcc honors this attribute while sparse
ignores it. The result is that sizeof(struct fcoe_rcv_info)
== sizeof(struct sk_buff::cb) == 48 on a 64-bit system according to gcc, but
not according to sparse. The patch below modifies the definition of
struct fcoe_rcv_info such that gcc and sparse interpret this structure
definition in the same way. The current sparse output is as follows:

$ cd linux-2.6.34
$ make C=2 M=drivers/scsi/fcoe modules
 CHECK   drivers/scsi/fcoe/fcoe.c

include/scsi/fc_frame.h:81:9: error: invalid bitfield width, -1.
 CC [M]  drivers/scsi/fcoe/fcoe.o
 CHECK   drivers/scsi/fcoe/libfcoe.c

include/scsi/fc_frame.h:81:9: error: invalid bitfield width, -1.
drivers/scsi/fcoe/libfcoe.c:56:37: error: invalid initializer

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: jeykholt@cisco.com
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 include/scsi/fc_frame.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index 4d3e9c7..15427fa 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -66,8 +66,8 @@ struct fcoe_rcv_info {
 	struct fc_fcp_pkt *fr_fsp;	/* for the corresponding fcp I/O */
 	u32		fr_crc;
 	u16		fr_max_payload;	/* max FC payload */
-	enum fc_sof	fr_sof;		/* start of frame delimiter */
-	enum fc_eof	fr_eof;		/* end of frame delimiter */
+	u8		fr_sof;		/* start of frame delimiter */
+	u8		fr_eof;		/* end of frame delimiter */
 	u8		fr_flags;	/* flags - see below */
 	u8		granted_mac[ETH_ALEN]; /* FCoE MAC address */
 };

