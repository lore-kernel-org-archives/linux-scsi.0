From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/24] libfc: Cleanup libfc_function_template comments
Date: Fri, 27 Feb 2009 10:55:39 -0800
Message-ID: <20090227185539.25509.71436.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43819 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbZB0Szl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:55:41 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Made the comments more like the comments for struct scsi_host_template.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/libfc.h |  107 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 66 insertions(+), 41 deletions(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 37df48e..282829c 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -336,31 +336,17 @@ struct fc_exch {
 
 struct libfc_function_template {
 
-	/**
-	 * Mandatory Fields
-	 *
-	 * These handlers must be implemented by the LLD.
-	 */
-
 	/*
 	 * Interface to send a FC frame
-	 */
-	int (*frame_send)(struct fc_lport *lp, struct fc_frame *fp);
-
-	/**
-	 * Optional Fields
 	 *
-	 * The LLD may choose to implement any of the following handlers.
-	 * If LLD doesn't specify hander and leaves its pointer NULL then
-	 * the default libfc function will be used for that handler.
-	 */
-
-	/**
-	 * ELS/CT interfaces
+	 * STATUS: REQUIRED
 	 */
+	int (*frame_send)(struct fc_lport *lp, struct fc_frame *fp);
 
 	/*
-	 * elsct_send - sends ELS/CT frame
+	 * Interface to send ELS/CT frames
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	struct fc_seq *(*elsct_send)(struct fc_lport *lport,
 				     struct fc_rport *rport,
@@ -370,9 +356,6 @@ struct libfc_function_template {
 					     struct fc_frame *fp,
 					     void *arg),
 				     void *arg, u32 timer_msec);
-	/**
-	 * Exhance Manager interfaces
-	 */
 
 	/*
 	 * Send the FC frame payload using a new exchange and sequence.
@@ -404,6 +387,8 @@ struct libfc_function_template {
 	 * timer_msec argument is specified. The timer is canceled when
 	 * it fires or when the exchange is done. The exchange timeout handler
 	 * is registered by EM layer.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	struct fc_seq *(*exch_seq_send)(struct fc_lport *lp,
 					struct fc_frame *fp,
@@ -415,14 +400,18 @@ struct libfc_function_template {
 					void *arg, unsigned int timer_msec);
 
 	/*
-	 * send a frame using existing sequence and exchange.
+	 * Send a frame using an existing sequence and exchange.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*seq_send)(struct fc_lport *lp, struct fc_seq *sp,
 			struct fc_frame *fp);
 
 	/*
-	 * Send ELS response using mainly infomation
-	 * in exchange and sequence in EM layer.
+	 * Send an ELS response using infomation from a previous
+	 * exchange and sequence.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*seq_els_rsp_send)(struct fc_seq *sp, enum fc_els_cmd els_cmd,
 				 struct fc_seq_els_data *els_data);
@@ -434,6 +423,8 @@ struct libfc_function_template {
 	 * A timer_msec can be specified for abort timeout, if non-zero
 	 * timer_msec value is specified then exchange resp handler
 	 * will be called with timeout error if no response to abort.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*seq_exch_abort)(const struct fc_seq *req_sp,
 			      unsigned int timer_msec);
@@ -441,6 +432,8 @@ struct libfc_function_template {
 	/*
 	 * Indicate that an exchange/sequence tuple is complete and the memory
 	 * allocated for the related objects may be freed.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*exch_done)(struct fc_seq *sp);
 
@@ -448,6 +441,8 @@ struct libfc_function_template {
 	 * Assigns a EM and a free XID for an new exchange and then
 	 * allocates a new exchange and sequence pair.
 	 * The fp can be used to determine free XID.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	struct fc_exch *(*exch_get)(struct fc_lport *lp, struct fc_frame *fp);
 
@@ -455,12 +450,16 @@ struct libfc_function_template {
 	 * Release previously assigned XID by exch_get API.
 	 * The LLD may implement this if XID is assigned by LLD
 	 * in exch_get().
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*exch_put)(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			 u16 ex_id);
 
 	/*
 	 * Start a new sequence on the same exchange/sequence tuple.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	struct fc_seq *(*seq_start_next)(struct fc_seq *sp);
 
@@ -468,26 +467,33 @@ struct libfc_function_template {
 	 * Reset an exchange manager, completing all sequences and exchanges.
 	 * If s_id is non-zero, reset only exchanges originating from that FID.
 	 * If d_id is non-zero, reset only exchanges sending to that FID.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*exch_mgr_reset)(struct fc_lport *,
 			       u32 s_id, u32 d_id);
 
-	void (*rport_flush_queue)(void);
-	/**
-	 * Local Port interfaces
+	/*
+	 * Flush the rport work queue. Generally used before shutdown.
+	 *
+	 * STATUS: OPTIONAL
 	 */
+	void (*rport_flush_queue)(void);
 
 	/*
-	 * Receive a frame to a local port.
+	 * Receive a frame for a local port.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*lport_recv)(struct fc_lport *lp, struct fc_seq *sp,
 			   struct fc_frame *fp);
 
-	int (*lport_reset)(struct fc_lport *);
-
-	/**
-	 * Remote Port interfaces
+	/*
+	 * Reset the local port.
+	 *
+	 * STATUS: OPTIONAL
 	 */
+	int (*lport_reset)(struct fc_lport *);
 
 	/*
 	 * Create a remote port
@@ -502,26 +508,33 @@ struct libfc_function_template {
 	 * - PLOGI
 	 * - PRLI
 	 * - RTV
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*rport_login)(struct fc_rport *rport);
 
 	/*
 	 * Logoff, and remove the rport from the transport if
 	 * it had been added. This will send a LOGO to the target.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*rport_logoff)(struct fc_rport *rport);
 
 	/*
 	 * Recieve a request from a remote port.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*rport_recv_req)(struct fc_seq *, struct fc_frame *,
 			       struct fc_rport *);
 
-	struct fc_rport *(*rport_lookup)(const struct fc_lport *, u32);
-
-	/**
-	 * FCP interfaces
+	/*
+	 * lookup an rport by it's port ID.
+	 *
+	 * STATUS: OPTIONAL
 	 */
+	struct fc_rport *(*rport_lookup)(const struct fc_lport *, u32);
 
 	/*
 	 * Send a fcp cmd from fsp pkt.
@@ -529,30 +542,38 @@ struct libfc_function_template {
 	 *
 	 * The resp handler is called when FCP_RSP received.
 	 *
+	 * STATUS: OPTIONAL
 	 */
 	int (*fcp_cmd_send)(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
 			    void (*resp)(struct fc_seq *, struct fc_frame *fp,
 					 void *arg));
 
 	/*
-	 * Used at least durring linkdown and reset
+	 * Cleanup the FCP layer, used durring link down and reset
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*fcp_cleanup)(struct fc_lport *lp);
 
 	/*
 	 * Abort all I/O on a local port
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*fcp_abort_io)(struct fc_lport *lp);
 
-	/**
-	 * Discovery interfaces
+	/*
+	 * Receive a request for the discovery layer.
+	 *
+	 * STATUS: OPTIONAL
 	 */
-
 	void (*disc_recv_req)(struct fc_seq *,
 			      struct fc_frame *, struct fc_lport *);
 
 	/*
 	 * Start discovery for a local port.
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*disc_start)(void (*disc_callback)(struct fc_lport *,
 						 enum fc_disc_event),
@@ -561,6 +582,8 @@ struct libfc_function_template {
 	/*
 	 * Stop discovery for a given lport. This will remove
 	 * all discovered rports
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*disc_stop) (struct fc_lport *);
 
@@ -568,6 +591,8 @@ struct libfc_function_template {
 	 * Stop discovery for a given lport. This will block
 	 * until all discovered rports are deleted from the
 	 * FC transport class
+	 *
+	 * STATUS: OPTIONAL
 	 */
 	void (*disc_stop_final) (struct fc_lport *);
 };

