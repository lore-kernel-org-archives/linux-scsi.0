From: michaelc@cs.wisc.edu
Subject: [PATCH 10/13] libfc fcoe: coding style fixups - use uX for definitions
Date: Sun, 29 Jun 2008 13:24:00 -0500
Message-ID: <1214763843-5548-11-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-5-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-6-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-7-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-8-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-9-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-10-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583AbYF2SYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 14:24:12 -0400
In-Reply-To: <1214763843-5548-10-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

I never knew there were so many ways to define a int. This driver
probably uses them all which makes my eyes hurt. This patch has us
use the uX/__uX definitions or unsigned int/long instead of the
bsd or sys way of defining them (yeah we actually use them both).

This patch also fixes some tabbing in the includes where we were
using spaces instead of tabs.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/fcoe/fcoe_def.h  |   30 +++---
 drivers/scsi/fcoe/fcoe_dev.c  |   18 ++--
 drivers/scsi/libfc/fc_disc.c  |   11 +--
 drivers/scsi/libfc/fc_exch.c  |   63 +++++++-------
 drivers/scsi/libfc/fc_frame.c |   16 ++--
 drivers/scsi/libfc/fc_lport.c |   19 ++---
 drivers/scsi/libfc/fc_rport.c |   13 ++--
 drivers/scsi/libfc/fc_scsi.c  |   22 +++---
 include/scsi/fc/fc_els.h      |    6 +-
 include/scsi/fc/fc_encaps.h   |  110 +++++++++++------------
 include/scsi/fc/fc_fc2.h      |   40 ++++----
 include/scsi/libfc/fc_frame.h |    4 +-
 include/scsi/libfc/libfc.h    |  192 ++++++++++++++++++++--------------------
 13 files changed, 268 insertions(+), 276 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_def.h b/drivers/scsi/fcoe/fcoe_def.h
index f8b2237..f053b50 100644
--- a/drivers/scsi/fcoe/fcoe_def.h
+++ b/drivers/scsi/fcoe/fcoe_def.h
@@ -66,17 +66,17 @@ struct fcoe_softc {
 	struct net_device *phys_dev;		/* device with ethtool_ops */
 	struct packet_type  fcoe_packet_type;
 	struct sk_buff_head fcoe_pending_queue;
-	uint16_t user_mfs;			/* configured max frame size */
+	u16 user_mfs;			/* configured max frame size */
 
-	uint8_t    dest_addr[ETH_ALEN];
-	uint8_t    ctl_src_addr[ETH_ALEN];
-	uint8_t    data_src_addr[ETH_ALEN];
+	u8 dest_addr[ETH_ALEN];
+	u8 ctl_src_addr[ETH_ALEN];
+	u8 data_src_addr[ETH_ALEN];
 	/*
 	 * fcoe protocol address learning related stuff
 	 */
-	uint16_t  flogi_oxid;
-	uint8_t   flogi_progress;
-	uint8_t   address_mode;
+	u16 flogi_oxid;
+	u8 flogi_progress;
+	u8 address_mode;
 };
 
 /*
@@ -84,14 +84,14 @@ struct fcoe_softc {
  */
 extern struct fcoe_info fcoei;
 
-void		fcoe_clean_pending_queue(struct fc_lport *fd);
-void		fcoe_watchdog(ulong vp);
-int		fcoe_destroy_interface(const char *ifname);
-int		fcoe_create_interface(const char *ifname);
-int		fcoe_xmit(struct fc_lport *, struct fc_frame *);
-int		fcoe_rcv(struct sk_buff *, struct net_device *,
-			 struct packet_type *, struct net_device *);
-int		fcoe_link_ok(struct fc_lport *);
+void fcoe_clean_pending_queue(struct fc_lport *fd);
+void fcoe_watchdog(ulong vp);
+int fcoe_destroy_interface(const char *ifname);
+int fcoe_create_interface(const char *ifname);
+int fcoe_xmit(struct fc_lport *, struct fc_frame *);
+int fcoe_rcv(struct sk_buff *, struct net_device *,
+	     struct packet_type *, struct net_device *);
+int fcoe_link_ok(struct fc_lport *);
 void fcoe_put_dev(struct fc_lport *dev);
 struct fcoe_softc *fcoe_find_fc_lport(const char *);
 #endif /* _FCOE_DEF_H_ */
diff --git a/drivers/scsi/fcoe/fcoe_dev.c b/drivers/scsi/fcoe/fcoe_dev.c
index 532092b..c0fc370 100644
--- a/drivers/scsi/fcoe/fcoe_dev.c
+++ b/drivers/scsi/fcoe/fcoe_dev.c
@@ -72,9 +72,9 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct fcoe_rcv_info *fr;
 	struct fcoe_softc *fc;
 	struct fcoe_dev_stats *stats;
-	u_int8_t *data;
+	u8 *data;
 	struct fc_frame_header *fh;
-	ushort oxid;
+	unsigned short oxid;
 	int cpu_idx;
 	struct fcoe_percpu_s *fps;
 	struct fcoe_info *fci = &fcoei;
@@ -199,18 +199,18 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 {
 	int indx;
 	int wlen, rc = 0;
-	u_int32_t crc;
+	u32 crc;
 	struct ethhdr *eh;
 	struct fcoe_crc_eof *cp;
 	struct sk_buff *skb;
 	struct fcoe_dev_stats *stats;
 	struct fc_frame_header *fh;
-	u_int hlen;		/* header length implies the version */
-	u_int tlen;		/* trailer length */
+	unsigned int hlen;		/* header length implies the version */
+	unsigned int tlen;		/* trailer length */
 	int flogi_in_progress = 0;
 	struct fcoe_softc *fc;
 	void *data;
-	uint8_t sof, eof;
+	u8 sof, eof;
 	struct fcoe_hdr *hp;
 
 	WARN_ON((fr_len(fp) % sizeof(uint32_t)) != 0);
@@ -358,9 +358,9 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 int fcoe_percpu_receive_thread(void *arg)
 {
 	struct fcoe_percpu_s *p = arg;
-	u_int32_t fr_len;
-	u_int hlen;
-	u_int tlen;
+	u32 fr_len;
+	unsigned int hlen;
+	unsigned int tlen;
 	struct fc_lport *lp;
 	struct fcoe_rcv_info *fr;
 	struct fcoe_dev_stats *stats;
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index fe50388..bccfd24 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -341,7 +341,7 @@ static void fc_disc_error(struct fc_lport *lp, struct fc_frame *fp)
  */
 static void fcdt_retry(struct fc_lport *lp)
 {
-	u_long delay = FCDT_RETRY_DELAY;
+	unsigned long delay = FCDT_RETRY_DELAY;
 
 	if (!lp->fl_disc_retries)
 		delay /= 4;	/* timeout faster first time */
@@ -471,7 +471,7 @@ static void fcdt_done(struct fc_lport *lp)
 	struct fc_remote_port *rp;
 	struct fc_remote_port *next;
 	struct fc_remote_port *held;
-	u_int disc_ver;
+	unsigned int disc_ver;
 
 	/*
 	 * Go through all remote_ports on the fabric which were not touched
@@ -594,7 +594,6 @@ static int fcdt_gpn_ft_parse(struct fc_lport *lp, void *buf, size_t len)
 	size_t plen;
 	size_t tlen;
 	int error = 0;
-
 	struct fc_disc_port *dp;
 
 	/*
@@ -692,9 +691,9 @@ static void fcdt_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_lport *lp = lp_arg;
 	struct fc_ct_hdr *cp;
 	struct fc_frame_header *fh;
-	u_int seq_cnt;
+	unsigned int seq_cnt;
 	void *buf = NULL;
-	u_int len;
+	unsigned int len;
 	int error;
 
 	if (IS_ERR(fp)) {
@@ -1078,7 +1077,7 @@ static void fcdt_gnn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 		struct fc_ct_hdr ct;
 		__be64 wwn;
 	} *cp;
-	u_int cmd;
+	unsigned int cmd;
 
 	if (IS_ERR(fp)) {
 		fcdt_gnn_id_error(dp, fp);
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index a663442..d861963 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -56,13 +56,13 @@ static int fc_exch_debug;
  * Sequence.
  */
 struct fc_seq {
-	uint8_t 	seq_id;		/* seq ID */
-	uint8_t 	seq_active;	/* active flag */
-	uint16_t 	seq_s_stat;	/* flags for sequence status block */
-	uint16_t	seq_cnt;	/* frames sent so far on sequence */
+	u8	seq_id;		/* seq ID */
+	u8	seq_active;	/* active flag */
+	u16	seq_s_stat;	/* flags for sequence status block */
+	u16	seq_cnt;	/* frames sent so far on sequence */
 	atomic_t 	seq_refcnt;	/* reference counter */
-	uint32_t 	seq_f_ctl;	/* F_CTL flags for frames */
-	uint32_t	seq_rec_data;	/* FC-4 value for REC */
+	u32	seq_f_ctl;	/* F_CTL flags for frames */
+	u32	seq_rec_data;	/* FC-4 value for REC */
 };
 
 /*
@@ -77,8 +77,8 @@ struct fc_exch {
 	struct fc_exch_mgr *ex_mp;	/* exchange manager */
 	fc_xid_t	ex_xid;		/* our exchange ID */
 	struct list_head	ex_list;	/* free or busy list linkage */
-	spinlock_t 	ex_lock;	/* lock covering exchange state */
-	atomic_t 	ex_refcnt;	/* reference counter */
+	spinlock_t	ex_lock;	/* lock covering exchange state */
+	atomic_t	ex_refcnt;	/* reference counter */
 	struct timer_list ex_timer;	/* timer for upper level protocols */
 
 	/*
@@ -90,10 +90,10 @@ struct fc_exch {
 	fc_fid_t	ex_orig_fid;	/* originator's FCID */
 	fc_fid_t	ex_s_id;	/* source ID */
 	fc_fid_t	ex_d_id;	/* destination ID */
-	uint32_t	ex_e_stat;	/* exchange status for ESB */
-	uint32_t	ex_r_a_tov;	/* r_a_tov from session (msec) */
-	uint8_t		ex_seq_id;	/* next sequence ID to use */
-	uint32_t	ex_f_ctl;	/* F_CTL flags for sequences */
+	u32		ex_e_stat;	/* exchange status for ESB */
+	u32		ex_r_a_tov;	/* r_a_tov from session (msec) */
+	u8		ex_seq_id;	/* next sequence ID to use */
+	u32		ex_f_ctl;	/* F_CTL flags for sequences */
 	enum fc_class	ex_class;	/* class of service */
 	struct fc_seq	ex_seq;		/* single sequence */
 
@@ -255,8 +255,8 @@ static char *fc_exch_rctl_names[] = FC_RCTL_NAMES_INIT;
 
 #define FC_TABLE_SIZE(x)   (sizeof (x) / sizeof (x[0]))
 
-static inline const char *fc_exch_name_lookup(u_int op, char **table,
-					      u_int max_index)
+static inline const char *fc_exch_name_lookup(unsigned int op, char **table,
+					      unsigned int max_index)
 {
 	const char *name = NULL;
 
@@ -267,7 +267,7 @@ static inline const char *fc_exch_name_lookup(u_int op, char **table,
 	return name;
 }
 
-static const char *fc_exch_rctl_name(u_int op)
+static const char *fc_exch_rctl_name(unsigned int op)
 {
 	return fc_exch_name_lookup(op, fc_exch_rctl_names,
 				   FC_TABLE_SIZE(fc_exch_rctl_names));
@@ -296,7 +296,7 @@ inline void fc_seq_hold(struct fc_seq *sp)
  * By implication, any previously originated sequence on this exchange
  * is complete, and we reallocate the same sequence.
  */
-static struct fc_seq *fc_seq_alloc(struct fc_exch *ep, u_int8_t seq_id)
+static struct fc_seq *fc_seq_alloc(struct fc_exch *ep, u8 seq_id)
 {
 	struct fc_seq *sp;
 
@@ -378,7 +378,8 @@ static void fc_exch_timeout(unsigned long ep_arg)
 /*
  * Internal version of fc_exch_timer_set - used with lock held.
  */
-static void fc_exch_timer_set_locked(struct fc_exch *ep, u_int timer_msec)
+static void fc_exch_timer_set_locked(struct fc_exch *ep,
+				     unsigned int timer_msec)
 {
 	if (!timer_pending(&ep->ex_timer))
 		fc_exch_hold(ep);		/* hold for timer */
@@ -392,7 +393,7 @@ static void fc_exch_timer_set_locked(struct fc_exch *ep, u_int timer_msec)
  * The timer is cancelled when it fires or when the exchange completes.
  * Returns non-zero if a timer couldn't be allocated.
  */
-void fc_exch_timer_set(struct fc_exch *ep, u_int timer_msec)
+void fc_exch_timer_set(struct fc_exch *ep, unsigned int timer_msec)
 {
 	spin_lock_bh(&ep->ex_lock);
 	fc_exch_timer_set_locked(ep, timer_msec);
@@ -496,7 +497,7 @@ static struct fc_exch *fc_exch_resp(struct fc_exch_mgr *mp,
 {
 	struct fc_exch *ep;
 	struct fc_frame_header *fh;
-	u_int16_t rx_id;
+	u16 rx_id;
 
 	ep = fc_exch_alloc(mp, 0);
 	if (ep) {
@@ -550,7 +551,7 @@ fc_seq_lookup_recip(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	struct fc_exch *ep = NULL;
 	struct fc_seq *sp = NULL;
 	enum fc_pf_rjt_reason reject = FC_RJT_NONE;
-	u_int32_t f_ctl;
+	u32 f_ctl;
 	fc_xid_t xid;
 
 	f_ctl = ntoh24(fh->fh_f_ctl);
@@ -658,7 +659,7 @@ static struct fc_seq *fc_seq_lookup_orig(struct fc_exch_mgr *mp,
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
 	struct fc_exch *ep;
 	struct fc_seq *sp = NULL;
-	u_int32_t f_ctl;
+	u32 f_ctl;
 	fc_xid_t xid;
 
 	f_ctl = ntoh24(fh->fh_f_ctl);
@@ -733,7 +734,7 @@ int fc_seq_send(struct fc_lport *lp, struct fc_seq *sp,
 	struct fc_exch *ep;
 	struct fc_frame_header *fh;
 	enum fc_class class;
-	u_int16_t fill = 0;
+	u16 fill = 0;
 	int error;
 
 	ep = fc_seq_exch(sp);
@@ -847,7 +848,7 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
 	struct fc_frame_header *rx_fh;
 	struct fc_frame_header *fh;
 	struct fc_lport *lp;
-	u_int f_ctl;
+	unsigned int f_ctl;
 
 	/*
 	 * Don't send ACKs for class 3.
@@ -962,7 +963,7 @@ fc_exch_send_ba_rjt(struct fc_frame *rx_fp, enum fc_ba_rjt_reason reason,
 	struct fc_frame_header *fh;
 	struct fc_ba_rjt *rp;
 	struct fc_lport *lp;
-	u_int f_ctl;
+	unsigned int f_ctl;
 
 	lp = fr_dev(rx_fp);
 	fp = fc_frame_alloc(lp, sizeof(*rp));
@@ -1024,7 +1025,7 @@ static void fc_exch_recv_req(struct fc_lport *lp, struct fc_exch_mgr *mp,
 	struct fc_exch *ep = NULL;
 	enum fc_sof sof;
 	enum fc_eof eof;
-	u_int32_t f_ctl;
+	u32 f_ctl;
 	enum fc_pf_rjt_reason reject;
 	void (*resp)(struct fc_seq *, struct fc_frame *fp, void *arg);
 	void *ex_arg;
@@ -1089,7 +1090,7 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	struct fc_seq *sp;
 	struct fc_exch *ep;
 	enum fc_sof sof;
-	u_int32_t f_ctl;
+	u32 f_ctl;
 	void (*resp)(struct fc_seq *, struct fc_frame *fp, void *arg);
 	void *ex_arg;
 
@@ -1199,8 +1200,8 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 {
 	struct fc_frame_header *fh;
 	struct fc_ba_acc *ap;
-	uint16_t low;
-	uint16_t high;
+	u16 low;
+	u16 high;
 
 	fh = fc_frame_header_get(fp);
 	if (fc_exch_debug)
@@ -1251,7 +1252,7 @@ static void fc_exch_recv_bls(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	struct fc_frame_header *fh;
 	struct fc_seq *sp;
 	struct fc_exch *ep;
-	uint32_t f_ctl;
+	u32 f_ctl;
 
 	fh = fc_frame_header_get(fp);
 	f_ctl = ntoh24(fh->fh_f_ctl);
@@ -1826,7 +1827,7 @@ struct fc_seq *fc_exch_seq_send(struct fc_lport *lp,
 	struct fc_exch *ep;
 	struct fc_seq *sp = NULL;
 	struct fc_frame_header *fh;
-	u_int16_t fill;
+	u16 fill;
 
 	ep = lp->tt.exch_get(lp);
 	if (!ep) {
@@ -1898,7 +1899,7 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 		  struct fc_frame *fp)
 {
 	struct fc_frame_header *fh = fc_frame_header_get(fp);
-	u_int32_t f_ctl;
+	u32 f_ctl;
 
 	if (!lp) {
 		FC_DBG("fcs_local_port_config needed before receiving");
diff --git a/drivers/scsi/libfc/fc_frame.c b/drivers/scsi/libfc/fc_frame.c
index e101eeb..1838c40 100644
--- a/drivers/scsi/libfc/fc_frame.c
+++ b/drivers/scsi/libfc/fc_frame.c
@@ -36,20 +36,20 @@
 /*
  * Check the CRC in a frame.
  */
-u_int32_t fc_frame_crc_check(struct fc_frame *fp)
+u32 fc_frame_crc_check(struct fc_frame *fp)
 {
-	u_int32_t crc;
-	u_int32_t error;
+	u32 crc;
+	u32 error;
 	const u_int8_t *bp;
-	u_int len;
+	unsigned int len;
 
 	WARN_ON(!fc_frame_is_linear(fp));
 	fr_flags(fp) &= ~FCPHF_CRC_UNCHECKED;
 	len = (fr_len(fp) + 3) & ~3;	/* round up length to include fill */
-	bp = (const u_int8_t *) fr_hdr(fp);
+	bp = (const u8 *) fr_hdr(fp);
 	crc = ~crc32(~0, bp, len);
-	error = crc ^ *(u_int32_t *) (bp + len);
-	return (error);
+	error = crc ^ *(u32 *) (bp + len);
+	return error;
 }
 EXPORT_SYMBOL(fc_frame_crc_check);
 
@@ -62,7 +62,7 @@ struct fc_frame *__fc_frame_alloc(size_t len)
 	struct fc_frame *fp;
 	struct sk_buff *skb;
 
-	WARN_ON((len % sizeof(uint32_t)) != 0);
+	WARN_ON((len % sizeof(u32)) != 0);
 	len += sizeof(struct fc_frame_header);
 	skb = dev_alloc_skb(len + FC_FRAME_HEADROOM + FC_FRAME_TAILROOM);
 	if (!skb)
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 805cb71..bc52bca 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -268,18 +268,16 @@ fc_lport_flogi_fill(struct fc_lport *lp,
  * Save parameters of remote switch.  Finish exchange.
  */
 static void
-fc_lport_flogi_resp(struct fc_seq *sp,
-			 struct fc_frame *fp,
-			 void *lp_arg)
+fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp, void *lp_arg)
 {
 	struct fc_lport *lp = lp_arg;
 	struct fc_frame_header *fh;
 	struct fc_els_flogi *flp;
 	fc_fid_t did;
-	u_int16_t csp_flags;
-	u_int r_a_tov;
-	u_int e_d_tov;
-	uint16_t mfs;
+	u16 csp_flags;
+	unsigned int r_a_tov;
+	unsigned int e_d_tov;
+	u16 mfs;
 
 	if (IS_ERR(fp))
 		goto out;
@@ -733,7 +731,7 @@ static void fc_lport_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 {
 	struct fc_lport *lp = lp_arg;
 	struct fc_frame *fp;
-	u_int len;
+	unsigned int len;
 	void *pp;
 	void *dp;
 	u32 f_ctl;
@@ -773,7 +771,7 @@ static void fc_lport_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 		struct fc_els_rnid_gen gen;
 	} *rp;
 	struct fc_seq_els_data rjt_data;
-	u_int8_t fmt;
+	u8 fmt;
 	size_t len;
 	u32 f_ctl;
 
@@ -1098,8 +1096,7 @@ int fc_set_mfs(struct fc_lport *lp, u32 mfs)
 }
 EXPORT_SYMBOL(fc_set_mfs);
 
-int fc_lport_init(struct fc_lport *lp,
-	    struct fc_transport_template *tmpl)
+int fc_lport_init(struct fc_lport *lp, struct fc_transport_template *tmpl)
 {
 //	if (!lp->tt.lp_event)
 //		lp->tt.lp_event = fc_lp_event;	
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index b121981..87d0469 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -74,7 +74,7 @@ static struct fc_remote_port *fc_remote_port_create(struct fc_lport *, struct fc
  * @rp:		the ptr to the remote port to be matched
  */
 static inline int fc_remote_port_fid_match(fc_fid_t fid,
-	const struct fc_remote_port *rp)
+					   const struct fc_remote_port *rp)
 {
 	return fid == rp->rport->port_id;
 }
@@ -258,7 +258,6 @@ static void libfc_remote_port_delete(struct fc_remote_port *rp)
 	struct fc_remote_port *found;
 	struct fc_lport *lp;
 
-
 	lp = rp->local_port;
 	fc_rp_list_lock(lp);
 	if (rp->rport->port_id != -1) {
@@ -798,9 +797,9 @@ static void fc_rport_plogi_recv_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_els_ls_rjt *rjp;
 	struct fc_els_flogi *plp;
 	fc_wwn_t wwpn, wwnn;
-	u_int tov;
-	uint16_t csp_seq;
-	uint16_t cssp_seq;
+	unsigned int tov;
+	u16 csp_seq;
+	u16 cssp_seq;
 	u8 op;
 	struct fc_remote_port *rp = rp_arg;
 
@@ -1311,8 +1310,8 @@ static void fc_rport_recv_prli_req(struct fc_remote_port *rp,
 	} *pp;
 	struct fc_els_spp *rspp;	/* request service param page */
 	struct fc_els_spp *spp;	/* response spp */
-	u_int len;
-	u_int plen;
+	unsigned int len;
+	unsigned int plen;
 	enum fc_els_rjt_reason reason = ELS_RJT_UNAB;
 	enum fc_els_rjt_explan explan = ELS_EXPL_NONE;
 	enum fc_els_spp_resp resp;
diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index bc2f1ac..c41807b 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -53,10 +53,10 @@ struct fc_scsi_pkt {
 	 * housekeeping stuff
 	 */
 	struct fc_lport *lp;	/* handle to hba struct */
-	uint16_t	state;		/* scsi_pkt state state */
-	uint16_t	tgt_flags;	/* target flags  */
+	u16		state;		/* scsi_pkt state state */
+	u16		tgt_flags;	/* target flags  */
 	atomic_t	ref_cnt;        /* only used byr REC ELS */
-	uint32_t	idx;		/* host given value */
+	u32		idx;		/* host given value */
 	/*
 	 * SCSI I/O related stuff
 	 */
@@ -75,7 +75,7 @@ struct fc_scsi_pkt {
 	/*
 	 * scsi cmd and data transfer information
 	 */
-	uint32_t	data_len;
+	u32		data_len;
 	/*
 	 * transport related veriables
 	 */
@@ -87,13 +87,13 @@ struct fc_scsi_pkt {
 	/*
 	 * scsi/fcp return status
 	 */
-	uint32_t	io_status;	/* SCSI result upper 24 bits */
-	uint8_t		cdb_status;
-	uint8_t		status_code;	/* OPENFC I/O status */
+	u32		io_status;	/* SCSI result upper 24 bits */
+	u8		cdb_status;
+	u8		status_code;	/* OPENFC I/O status */
 	/* bit 3 Underrun bit 2: overrun */
-	uint8_t		scsi_comp_flags;
-	uint32_t	req_flags;	/* bit 0: read bit:1 write */
-	uint32_t	scsi_resid;	/* residule length */
+	u8		scsi_comp_flags;
+	u32		req_flags;	/* bit 0: read bit:1 write */
+	u32		scsi_resid;	/* residule length */
 	/*
 	 * FCS related data struct
 	 */
@@ -102,7 +102,7 @@ struct fc_scsi_pkt {
 	/*
 	 * Error Processing
 	 */
-	uint8_t		recov_retry;	/* count of recovery retries */
+	u8		recov_retry;	/* count of recovery retries */
 	struct fc_seq	*recov_seq;	/* sequence for REC or SRR */
 };
 
diff --git a/include/scsi/fc/fc_els.h b/include/scsi/fc/fc_els.h
index 8130b14..e90ddbf 100644
--- a/include/scsi/fc/fc_els.h
+++ b/include/scsi/fc/fc_els.h
@@ -278,9 +278,9 @@ struct fc_els_cssp {
 	__be16		cp_rdfs;	/* receive data field size */
 	__be16		cp_con_seq;	/* concurrent sequences */
 	__be16		cp_ee_cred;	/* N-port end-to-end credit */
-	u_int8_t	_cp_resv1;	/* reserved */
-	u_int8_t	cp_open_seq;	/* open sequences per exchange */
-	u_int8_t	_cp_resv2[2];	/* reserved */
+	__u8		cp_resv1;	/* reserved */
+	__u8		cp_open_seq;	/* open sequences per exchange */
+	__u8		_cp_resv2[2];	/* reserved */
 };
 
 /*
diff --git a/include/scsi/fc/fc_encaps.h b/include/scsi/fc/fc_encaps.h
index a5116c6..f910708 100644
--- a/include/scsi/fc/fc_encaps.h
+++ b/include/scsi/fc/fc_encaps.h
@@ -27,116 +27,112 @@
  * The minimum frame length value in bytes is (32 + 24 + 4 + 4) * 4 = 64.
  * The maximum frame length value in bytes is (32 + 24 + 2112 + 4 + 4) = 2172.
  */
-#define FC_ENCAPS_MIN_FRAME_LEN  64     /* min frame len (bytes) (see above) */
-#define FC_ENCAPS_MAX_FRAME_LEN  (FC_ENCAPS_MIN_FRAME_LEN + FC_MAX_PAYLOAD)
+#define FC_ENCAPS_MIN_FRAME_LEN 64	/* min frame len (bytes) (see above) */
+#define FC_ENCAPS_MAX_FRAME_LEN (FC_ENCAPS_MIN_FRAME_LEN + FC_MAX_PAYLOAD)
 
 #define FC_ENCAPS_VER       1           /* current version number */
 
 struct fc_encaps_hdr {
-    __u8      fc_proto;               /* protocol number */
-    __u8      fc_ver;                 /* version of encapsulation */
-    __u8      fc_proto_n;             /* ones complement of protocol */
-    __u8      fc_ver_n;               /* ones complement of version */
+	__u8	fc_proto;	/* protocol number */
+	__u8	fc_ver;		/* version of encapsulation */
+	__u8	fc_proto_n;	/* ones complement of protocol */
+	__u8	fc_ver_n;	/* ones complement of version */
 
-    u_char      fc_proto_data[8];       /* protocol specific data */
+	unsigned char fc_proto_data[8]; /* protocol specific data */
 
-    __be16     fc_len_flags;           /* 10-bit length/4 w/ 6 flag bits */
-    __be16     fc_len_flags_n;         /* ones complement of length / flags */
+	__be16	fc_len_flags;	/* 10-bit length/4 w/ 6 flag bits */
+	__be16	fc_len_flags_n;	/* ones complement of length / flags */
 
-    /*
-     * Offset 0x10
-     */
-    __be32     fc_time[2];             /* time stamp: seconds and fraction */
-    __be32     fc_crc;                 /* CRC */
-    __be32     fc_sof;                 /* start of frame (see FC_SOF below) */
+	/*
+	 * Offset 0x10
+	 */
+	__be32	fc_time[2];	/* time stamp: seconds and fraction */
+	__be32	fc_crc;		/* CRC */
+	__be32	fc_sof;		/* start of frame (see FC_SOF below) */
 
-    /* 0x20 - FC frame content followed by EOF word */
+	/* 0x20 - FC frame content followed by EOF word */
 };
 
-#define FCIP_ENCAPS_HDR_LEN 0x20        /* expected length for asserts */
+#define FCIP_ENCAPS_HDR_LEN 0x20	/* expected length for asserts */
 
 /*
  * Macro's for making redundant copies of EOF and SOF.
  */
-#define FC_XY(x, y)         ((((x) & 0xff) << 8) | ((y) & 0xff))
-#define FC_XYXY(x, y)       ((FCIP_XY(x, y) << 16) | FCIP_XY(x, y))
-#define FC_XYNN(x, y)       (FCIP_XYXY(x, y) ^ 0xffff)
+#define FC_XY(x, y)		((((x) & 0xff) << 8) | ((y) & 0xff))
+#define FC_XYXY(x, y)		((FCIP_XY(x, y) << 16) | FCIP_XY(x, y))
+#define FC_XYNN(x, y)		(FCIP_XYXY(x, y) ^ 0xffff)
 
-#define FC_SOF_ENCODE(n)    FC_XYNN(n, n)
-#define FC_EOF_ENCODE(n)    FC_XYNN(n, n)
+#define FC_SOF_ENCODE(n)	FC_XYNN(n, n)
+#define FC_EOF_ENCODE(n)	FC_XYNN(n, n)
 
 /*
  * SOF / EOF bytes.
  */
 enum fc_sof {
-    FC_SOF_F =      0x28,   /* fabric */
-    FC_SOF_I4 =     0x29,   /* initiate class 4 */
-    FC_SOF_I2 =     0x2d,   /* initiate class 2 */
-    FC_SOF_I3 =     0x2e,   /* initiate class 3 */
-    FC_SOF_N4 =     0x31,   /* normal class 4 */
-    FC_SOF_N2 =     0x35,   /* normal class 2 */
-    FC_SOF_N3 =     0x36,   /* normal class 3 */
-    FC_SOF_C4 =     0x39,   /* activate class 4 */
+	FC_SOF_F =	0x28,	/* fabric */
+	FC_SOF_I4 =	0x29,	/* initiate class 4 */
+	FC_SOF_I2 =	0x2d,	/* initiate class 2 */
+	FC_SOF_I3 =	0x2e,	/* initiate class 3 */
+	FC_SOF_N4 =	0x31,	/* normal class 4 */
+	FC_SOF_N2 =	0x35,	/* normal class 2 */
+	FC_SOF_N3 =	0x36,	/* normal class 3 */
+	FC_SOF_C4 =	0x39,	/* activate class 4 */
 } __attribute__((packed));
 
 enum fc_eof {
-    FC_EOF_N =      0x41,   /* normal (not last frame of seq) */
-    FC_EOF_T =      0x42,   /* terminate (last frame of sequence) */
-    FC_EOF_RT =     0x44,
-    FC_EOF_DT =     0x46,   /* disconnect-terminate class-1 */
-    FC_EOF_NI =     0x49,   /* normal-invalid */
-    FC_EOF_DTI =    0x4e,   /* disconnect-terminate-invalid */
-    FC_EOF_RTI =    0x4f,
-    FC_EOF_A =      0x50,   /* abort */
+	FC_EOF_N =	0x41,	/* normal (not last frame of seq) */
+	FC_EOF_T =	0x42,	/* terminate (last frame of sequence) */
+	FC_EOF_RT =	0x44,
+	FC_EOF_DT =	0x46,	/* disconnect-terminate class-1 */
+	FC_EOF_NI =	0x49,	/* normal-invalid */
+	FC_EOF_DTI =	0x4e,	/* disconnect-terminate-invalid */
+	FC_EOF_RTI =	0x4f,
+	FC_EOF_A =	0x50,	/* abort */
 } __attribute__((packed));
 
-#define FC_SOF_CLASS_MASK   0x06        /* mask for class of service in SOF */
+#define FC_SOF_CLASS_MASK 0x06	/* mask for class of service in SOF */
 
 /*
  * Define classes in terms of the SOF code (initial).
  */
 enum fc_class {
-    FC_CLASS_NONE = 0,                  /* software value indicating no class */
-    FC_CLASS_2 =    FC_SOF_I2,
-    FC_CLASS_3 =    FC_SOF_I3,
-    FC_CLASS_4 =    FC_SOF_I4,
-    FC_CLASS_F =    FC_SOF_F,
-} __attribute__((packed));
+	FC_CLASS_NONE = 0,	/* software value indicating no class */
+	FC_CLASS_2 =	FC_SOF_I2,
+	FC_CLASS_3 =	FC_SOF_I3,
+	FC_CLASS_4 =	FC_SOF_I4,
+	FC_CLASS_F =	FC_SOF_F,
+};
 
 /*
  * Determine whether SOF code indicates the need for a BLS ACK.
  */
-static inline int
-fc_sof_needs_ack(enum fc_sof sof)
+static inline int fc_sof_needs_ack(enum fc_sof sof)
 {
-    return ((~sof) & 0x02);     /* true for class 1, 2, 4, 6, or F */
+	return ((~sof) & 0x02);	/* true for class 1, 2, 4, 6, or F */
 }
 
 /*
  * Given an fc_class, return the normal (non-initial) SOF value.
  */
-static inline enum fc_sof
-fc_sof_normal(enum fc_class class)
+static inline enum fc_sof fc_sof_normal(enum fc_class class)
 {
-    return (class + FC_SOF_N3 - FC_SOF_I3);      /* diff is always 8 */
+	return (class + FC_SOF_N3 - FC_SOF_I3);	/* diff is always 8 */
 }
 
 /*
  * Compute class from SOF value.
  */
-static inline enum fc_class
-fc_sof_class(enum fc_sof sof)
+static inline enum fc_class fc_sof_class(enum fc_sof sof)
 {
-    return ((sof & 0x7) | FC_SOF_F);
+	return ((sof & 0x7) | FC_SOF_F);
 }
 
 /*
  * Determine whether SOF is for the initial frame of a sequence.
  */
-static inline int
-fc_sof_is_init(enum fc_sof sof)
+static inline int fc_sof_is_init(enum fc_sof sof)
 {
-    return (sof < 0x30);
+	return (sof < 0x30);
 }
 
 #endif /* _FC_ENCAPS_H_ */
diff --git a/include/scsi/fc/fc_fc2.h b/include/scsi/fc/fc_fc2.h
index 38a2ab5..cff8a8c 100644
--- a/include/scsi/fc/fc_fc2.h
+++ b/include/scsi/fc/fc_fc2.h
@@ -34,18 +34,18 @@
  * Note that the fields aren't all naturally aligned.
  */
 struct fc_ssb {
-    u_int8_t    ssb_seq_id;             /* sequence ID */
-    u_int8_t    _ssb_resvd;
-    u_int16_t   ssb_low_seq_cnt;        /* lowest SEQ_CNT */
-
-    u_int16_t   ssb_high_seq_cnt;       /* highest SEQ_CNT */
-    u_int16_t   ssb_s_stat;             /* sequence status flags */
-
-    u_int16_t   ssb_err_seq_cnt;        /* error SEQ_CNT */
-    u_int8_t    ssb_fh_cs_ctl;          /* frame header CS_CTL */
-    u_int16_t   ssb_fh_ox_id;           /* frame header OX_ID */
-    u_int16_t   ssb_rx_id;              /* responder's exchange ID */
-    u_int8_t    _ssb_resvd2[2];
+	__u8	ssb_seq_id;		/* sequence ID */
+	__u8	_ssb_resvd;
+	__be16	ssb_low_seq_cnt;	/* lowest SEQ_CNT */
+
+	__be16	ssb_high_seq_cnt;	/* highest SEQ_CNT */
+	__be16	ssb_s_stat;		/* sequence status flags */
+
+	__be16	ssb_err_seq_cnt;	/* error SEQ_CNT */
+	__u8	ssb_fh_cs_ctl;		/* frame header CS_CTL */
+	__be16	ssb_fh_ox_id;		/* frame header OX_ID */
+	__be16	ssb_rx_id;		/* responder's exchange ID */
+	__u8	_ssb_resvd2[2];
 } PACKED;
 
 /*
@@ -83,16 +83,16 @@ struct fc_ssb {
  * Note that the fields aren't all naturally aligned.
  */
 struct fc_esb {
-    u_int8_t    esb_cs_ctl;             /* CS_CTL for frame header */
-    u_int16_t   esb_ox_id;              /* originator exchange ID */
-    u_int16_t   esb_rx_id;              /* responder exchange ID */
-    u_int32_t   esb_orig_fid;           /* fabric ID of originator */
-    u_int32_t   esb_resp_fid;           /* fabric ID of responder */
-    u_int32_t   esb_e_stat;             /* status */
-    u_int8_t    _esb_resvd[4];
-    u_int8_t    esb_service_params[112]; /* TBD */
-    u_int8_t    esb_seq_status[8];      /* sequence statuses, 8 bytes each */
-} PACKED;
+	__u8	esb_cs_ctl;		/* CS_CTL for frame header */
+	__be16	esb_ox_id;		/* originator exchange ID */
+	__be16	esb_rx_id;		/* responder exchange ID */
+	__be32	esb_orig_fid;		/* fabric ID of originator */
+	__be32	esb_resp_fid;		/* fabric ID of responder */
+	__be32	esb_e_stat;		/* status */
+	__u8	_esb_resvd[4];
+	__u8	esb_service_params[112]; /* TBD */
+	__u8	esb_seq_status[8];	/* sequence statuses, 8 bytes each */
+} __attribute__((packed));;
 
 
 /*
diff --git a/include/scsi/libfc/fc_frame.h b/include/scsi/libfc/fc_frame.h
index 1efb3d0..1aa303e 100644
--- a/include/scsi/libfc/fc_frame.h
+++ b/include/scsi/libfc/fc_frame.h
@@ -62,7 +62,7 @@ struct fcoe_rcv_info {
 	struct fc_seq	*fr_seq;	/* for use with exchange manager */
 	enum fc_sof	fr_sof;		/* start of frame delimiter */
 	enum fc_eof	fr_eof;		/* end of frame delimiter */
-	u_int8_t	fr_flags;	/* flags - see below */
+	u8		fr_flags;	/* flags - see below */
 };
 
 /*
@@ -224,7 +224,7 @@ fc_frame_set_offset(struct fc_frame *fp, u_int32_t offset)
  * The CRC immediately follows the last data item *AFTER* the length.
  * The return value is zero if the CRC matches.
  */
-u_int32_t fc_frame_crc_check(struct fc_frame *);
+u32 fc_frame_crc_check(struct fc_frame *);
 
 /*
  * Check for leaks.
diff --git a/include/scsi/libfc/libfc.h b/include/scsi/libfc/libfc.h
index 55ccace..49cabad 100644
--- a/include/scsi/libfc/libfc.h
+++ b/include/scsi/libfc/libfc.h
@@ -113,8 +113,8 @@ struct fc_exch_mgr;
  * it cannot be declared as uint64_t.
  */
 typedef unsigned long long fc_wwn_t;	/* world-wide name */
-typedef uint32_t	fc_fid_t;	/* fabric address */
-typedef uint16_t	fc_xid_t;	/* exchange ID */
+typedef u32	fc_fid_t;	/* fabric address */
+typedef u16	fc_xid_t;	/* exchange ID */
 
 enum ofc_io_speed {
 	OFC_SPEED_UNK = 0,
@@ -158,35 +158,35 @@ enum fc_sess_state {
  * Fibre Channel information about remote N port.
  */
 struct fc_remote_port {
-	struct list_head   rp_list;	      /* list under fc_virt_fab */
-	atomic_t	   rp_refcnt;	      /* reference count */
-	u_int		   rp_disc_ver;	      /* discovery instance */
-	u_int		   rp_fcp_parm;	      /* remote FCP service parameters */
-	u_int		   rp_local_fcp_parm; /* local FCP service parameters */
-	struct fc_rport    *rport;
-	uint16_t           tgt_flags;
+	struct list_head rp_list;	/* list under fc_virt_fab */
+	atomic_t	rp_refcnt;	/* reference count */
+	unsigned int	rp_disc_ver;	/* discovery instance */
+	unsigned int	rp_fcp_parm;	/* remote FCP service parameters */
+	unsigned int	rp_local_fcp_parm; /* local FCP service parameters */
+	struct fc_rport	*rport;
+	u16		tgt_flags;
 	struct hlist_node  rp_fid_hash_link;
 
 	/*
 	 * For now, there's just one session per remote port.
 	 * Eventually, for multipathing, there will be more.
 	 */
-	u_char		   rp_sess_ready;     /* session ready to be used */
-	void		   *dns_lookup;	      /* private dns lookup */
-	int		   dns_lookup_count;  /* number of attempted lookups */
+	unsigned char	rp_sess_ready;	/* session ready to be used */
+	void		*dns_lookup;	/* private dns lookup */
+	int		dns_lookup_count; /* number of attempted lookups */
 
 	/* fc_sess fields */
-	struct fc_lport    *local_port;    /* local port (aka LIF) */
-	enum fc_sess_state fs_state;	      /* session state */
-	fc_fid_t	   fs_local_fid;      /* local port fabric ID at create */
-	fc_fid_t	   fs_remote_fid;     /* remote port fabric ID */
-	uint		   fs_retries;	      /* retry count in current state */
-	struct timer_list  fs_timer;	      /* retry timer */
-	uint16_t	   fs_max_payload;    /* max payload size in bytes */
-	uint16_t	   fs_max_seq;	      /* max concurrent sequences */
-	uint		   fs_e_d_tov;	      /* negotiated e_d_tov (msec) */
-	uint		   fs_r_a_tov;	      /* received r_a_tov (msec) */
-	spinlock_t	   fs_lock;	      /* lock on state changes */
+	struct fc_lport	*local_port;	/* local port (aka LIF) */
+	enum fc_sess_state fs_state;	/* session state */
+	fc_fid_t	fs_local_fid;	/* local port fabric ID at create */
+	fc_fid_t	fs_remote_fid;	/* remote port fabric ID */
+	unsigned int	fs_retries;	/* retry count in current state */
+	struct timer_list  fs_timer;	/* retry timer */
+	u16		fs_max_payload;	/* max payload size in bytes */
+	u16		fs_max_seq;	/* max concurrent sequences */
+	unsigned int	fs_e_d_tov;	/* negotiated e_d_tov (msec) */
+	unsigned int	fs_r_a_tov;	/* received r_a_tov (msec) */
+	spinlock_t	fs_lock;	/* lock on state changes */
 };
 
 static inline void fc_rport_set_name(struct fc_remote_port *rp, fc_wwn_t wwpn,
@@ -200,37 +200,37 @@ static inline void fc_rport_set_name(struct fc_remote_port *rp, fc_wwn_t wwpn,
  * device specific information
  */
 struct fc_drv_info {
-	char 		model[64];
-	char 		vendor[64];
-	char 		sn[64];
-	char 		model_desc[256];
-	char 		hw_version[256];
-	char 		fw_version[256];
-	char 		opt_rom_version[256];
-	char 		drv_version[128];
-	char 		drv_name[128];
+	char		model[64];
+	char		vendor[64];
+	char		sn[64];
+	char		model_desc[256];
+	char		hw_version[256];
+	char		fw_version[256];
+	char		opt_rom_version[256];
+	char		drv_version[128];
+	char		drv_name[128];
 };
 
 /*
  * fcoe stats structure
  */
 struct fcoe_dev_stats {
-	uint64_t	SecondsSinceLastReset;
-	uint64_t	TxFrames;
-	uint64_t	TxWords;
-	uint64_t	RxFrames;
-	uint64_t	RxWords;
-	uint64_t	ErrorFrames;
-	uint64_t	DumpedFrames;
-	uint64_t	LinkFailureCount;
-	uint64_t	LossOfSignalCount;
-	uint64_t	InvalidTxWordCount;
-	uint64_t	InvalidCRCCount;
-	uint64_t	InputRequests;
-	uint64_t	OutputRequests;
-	uint64_t	ControlRequests;
-	uint64_t	InputMegabytes;
-	uint64_t	OutputMegabytes;
+	u64		SecondsSinceLastReset;
+	u64		TxFrames;
+	u64		TxWords;
+	u64		RxFrames;
+	u64		RxWords;
+	u64		ErrorFrames;
+	u64		DumpedFrames;
+	u64		LinkFailureCount;
+	u64		LossOfSignalCount;
+	u64		InvalidTxWordCount;
+	u64		InvalidCRCCount;
+	u64		InputRequests;
+	u64		OutputRequests;
+	u64		ControlRequests;
+	u64		InputMegabytes;
+	u64		OutputMegabytes;
 };
 
 /*
@@ -312,7 +312,7 @@ struct fc_transport_template {
 					void (*resp)(struct fc_seq *,
 						     struct fc_frame *fp,
 						     void *arg),
-					void *resp_arg,	u_int timer_msec,
+					void *resp_arg,	unsigned int timer_msec,
 					fc_fid_t sid, fc_fid_t did, u32 f_ctl);
 
 	/*
@@ -464,66 +464,66 @@ struct fc_lport {
 	struct list_head list;
 
 	/* Associations */
-	struct Scsi_Host   *host;
-	struct device	   fc_device;
-	struct fc_exch_mgr *emp;
-	struct fc_remote_port *fl_dns_rp;
-	struct fc_remote_port *fl_ptp_rp;
-	struct list_head      vf_remote_ports;	/* remote ports */
-	void                  *scsi_priv;
+	struct Scsi_Host	*host;
+	struct device		fc_device;
+	struct fc_exch_mgr	*emp;
+	struct fc_remote_port	*fl_dns_rp;
+	struct fc_remote_port	*fl_ptp_rp;
+	struct list_head	vf_remote_ports;	/* remote ports */
+	void			*scsi_priv;
 
 	/* Operational Information */
 	struct fc_transport_template tt;
-	uint16_t	   state;
-	uint16_t	   status;
-	atomic_t	   fcs_status;
-	uint8_t		   fs_disc_done;	 /* discovery complete */
-	enum fc_lport_state fl_state;	         /* state of FLOGI and dNS */	
-	ulong              fc_boot_time;
+	u16			state;
+	u16			status;
+	atomic_t		fcs_status;
+	u8			fs_disc_done;	/* discovery complete */
+	enum fc_lport_state	fl_state;	/* state of FLOGI and dNS */
+	unsigned long		fc_boot_time;
 
 	struct fc_host_statistics openfc_host_stat;
-	struct fcoe_dev_stats         *dev_stats[NR_CPUS];
-
-	fc_wwn_t	   wwpn;
-	fc_wwn_t	   wwnn;
-	fc_fid_t	   fl_fid;
-	uint8_t		   fl_retry_count;
-	uint8_t		   fl_logon_req;
-	u_int		   fl_disc_ver;
-	u_char		   fl_disc_retries;
-	u_char		   fl_disc_holdoff;
-	u_char		   fl_disc_in_prog;
-	u_char		   fl_disc_req;
-	u_short		   fl_disc_seq_cnt;
-	u_char		   fl_disc_buf_len;
+	struct fcoe_dev_stats	*dev_stats[NR_CPUS];
+
+	fc_wwn_t		wwpn;
+	fc_wwn_t		wwnn;
+	fc_fid_t		fl_fid;
+	u8			fl_retry_count;
+	u8			fl_logon_req;
+	unsigned int		fl_disc_ver;
+	unsigned char		fl_disc_retries;
+	unsigned char		fl_disc_holdoff;
+	unsigned char		fl_disc_in_prog;
+	unsigned char		fl_disc_req;
+	unsigned short		fl_disc_seq_cnt;
+	unsigned char		fl_disc_buf_len;
 
 	/* Capabilities */
-	char		   ifname[IFNAMSIZ];
-	uint32_t 	   capabilities;
-	ulong		   qdepth;
-	u32	           mfs;		        /* max FC payload size */
-	u_int              service_params;
-	u_int		   fl_e_d_tov;
-	u_int		   fl_r_a_tov;
-	uint8_t		   fl_retry_limit;
-	int                link_status;
-	u16		   link_speed;
-	u16		   link_supported_speeds;
-	struct fc_ns_fts   fl_ns_fts;		/* FC-4 type masks */
-	struct fc_els_rnid_gen fl_rnid_gen;	/* RNID information */
+	char			ifname[IFNAMSIZ];
+	u32			capabilities;
+	unsigned long		qdepth;
+	u32			mfs;		/* max FC payload size */
+	unsigned int		service_params;
+	unsigned int		fl_e_d_tov;
+	unsigned int		fl_r_a_tov;
+	u8			fl_retry_limit;
+	int			link_status;
+	u16			link_speed;
+	u16			link_supported_speeds;
+	struct fc_ns_fts	fl_ns_fts;	/* FC-4 type masks */
+	struct fc_els_rnid_gen	fl_rnid_gen;	/* RNID information */
 	
 	/* Locks */
-	spinlock_t	   fl_lock;		/* serializes state changes */
-	spinlock_t	   rp_lock;		/* lock for list of fc_rports */
+	spinlock_t		fl_lock;	/* serializes state changes */
+	spinlock_t		rp_lock;	/* lock for list of fc_rports */
 
-	struct hlist_head *vf_rport_by_fid;	/* remote ports by FCID */
+	struct hlist_head	*vf_rport_by_fid; /* remote ports by FCID */
 
 	/* Miscellaneous */
-	struct fc_gpn_ft_resp fl_disc_buf;	/* partial name buffer */
-	struct timer_list fl_timer;		/* timer for state events */
-	struct timer_list fl_disc_timer;	/* timer for continuing */
+	struct fc_gpn_ft_resp	fl_disc_buf;	/* partial name buffer */
+	struct timer_list	fl_timer;	/* timer for state events */
+	struct timer_list	fl_disc_timer;	/* timer for continuing */
 
-	void		  *drv_priv;
+	void			*drv_priv;
 	struct fc_drv_info drv_info;
 };
 
-- 
1.5.4.1

