From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/28] libfc: track FIP exchanges
Date: Tue, 20 Jul 2010 15:20:14 -0700
Message-ID: <20100720222014.17116.46391.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:8888 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932734Ab0GTWU1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:20:27 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>

From: Joe Eykholt <jeykholt@cisco.com>

When an exchange is received with a FIP encapsulation, we need
to know that the response must be sent via FIP and what the original
ELS opcode was.  This becomes important for VN2VN mode, where we may
receive FLOGI or LOGO from several peer VN_ports, and the LS_ACC or
LS_RJT must be sent FIP-encapsulated with the correct sub-type.

Add a field to the struct fc_frame, fr_encaps, to indicate the
encapsulation values.  That term is chosen to be neutral and
LLD-agnostic in case non-FCoE/FIP LLDs might find it useful.

The frame fr_encaps is transferred from the ingress frame to the
exchange by fc_exch_recv_req(), and back to the outgoing frame
by fc_seq_send().

This is taking the last byte in the skb->cb array.  If needed,
we could combine the info in sof, eof, flags, and encaps
together into one field, but it'd be better to do that if
and when its needed.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    2 ++
 include/scsi/fc_frame.h      |    3 +++
 include/scsi/libfc.h         |    2 ++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 104e0fb..61eabd3 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -464,6 +464,7 @@ static int fc_seq_send(struct fc_lport *lport, struct fc_seq *sp,
 
 	f_ctl = ntoh24(fh->fh_f_ctl);
 	fc_exch_setup_hdr(ep, fp, f_ctl);
+	fr_encaps(fp) = ep->encaps;
 
 	/*
 	 * update sequence count if this frame is carrying
@@ -1259,6 +1260,7 @@ static void fc_exch_recv_req(struct fc_lport *lport, struct fc_exch_mgr *mp,
 		sp = fr_seq(fp);	/* sequence will be held */
 		ep = fc_seq_exch(sp);
 		fc_seq_send_ack(sp, fp);
+		ep->encaps = fr_encaps(fp);
 
 		/*
 		 * Call the receive function.
diff --git a/include/scsi/fc_frame.h b/include/scsi/fc_frame.h
index 15427fa..29dd97d 100644
--- a/include/scsi/fc_frame.h
+++ b/include/scsi/fc_frame.h
@@ -51,6 +51,7 @@
 #define fr_sof(fp)	(fr_cb(fp)->fr_sof)
 #define fr_eof(fp)	(fr_cb(fp)->fr_eof)
 #define fr_flags(fp)	(fr_cb(fp)->fr_flags)
+#define fr_encaps(fp)	(fr_cb(fp)->fr_encaps)
 #define fr_max_payload(fp)	(fr_cb(fp)->fr_max_payload)
 #define fr_fsp(fp)	(fr_cb(fp)->fr_fsp)
 #define fr_crc(fp)	(fr_cb(fp)->fr_crc)
@@ -69,6 +70,7 @@ struct fcoe_rcv_info {
 	u8		fr_sof;		/* start of frame delimiter */
 	u8		fr_eof;		/* end of frame delimiter */
 	u8		fr_flags;	/* flags - see below */
+	u8		fr_encaps;	/* LLD encapsulation info (e.g. FIP) */
 	u8		granted_mac[ETH_ALEN]; /* FCoE MAC address */
 };
 
@@ -97,6 +99,7 @@ static inline void fc_frame_init(struct fc_frame *fp)
 	fr_dev(fp) = NULL;
 	fr_seq(fp) = NULL;
 	fr_flags(fp) = 0;
+	fr_encaps(fp) = 0;
 }
 
 struct fc_frame *fc_frame_alloc_fill(struct fc_lport *, size_t payload_len);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 24b91c9..8d297f9 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -412,6 +412,7 @@ struct fc_seq {
  * @esb_stat:     ESB exchange status
  * @r_a_tov:      Resouce allocation time out value (in msecs)
  * @seq_id:       The next sequence ID to use
+ * @encaps:       encapsulation information for lower-level driver
  * @f_ctl:        F_CTL flags for the sequence
  * @fh_type:      The frame type
  * @class:        The class of service
@@ -443,6 +444,7 @@ struct fc_exch {
 	u32		    esb_stat;
 	u32		    r_a_tov;
 	u8		    seq_id;
+	u8		    encaps;
 	u32		    f_ctl;
 	u8		    fh_type;
 	enum fc_class	    class;

