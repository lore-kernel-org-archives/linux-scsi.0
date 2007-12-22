From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 1/2] Added simple OFC_DBG macro to log debug messages for
	entire fcoe code.
Date: Fri, 21 Dec 2007 16:24:30 -0800
Message-ID: <20071222002430.6543.14006.stgit@vdinit.jf.intel.com>
References: <20071222002255.6543.32102.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:14045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbXLVAau (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 19:30:50 -0500
In-Reply-To: <20071222002255.6543.32102.stgit@vdinit.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Vasu Dev <vasu.dev@intel.com>

Currently SA_LOG macro defined for libsa is used for logging all debug messages which is implemented around lengthy functions prefixed with sa_log. The SA_LOG eventually calls printk, so instead implemented more generic simple OFC_DBG macro directly calling printk with additional C function tracing.

Also fixed few warnings exposed by use of new OFC_DBG macro and changed log
level for CRC errors.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/fcoe/fcoe_dev.c        |   19 ++++---
 drivers/scsi/ofc/fcoe/fcoe_if.c         |    6 +-
 drivers/scsi/ofc/fcoe/fcoeinit.c        |    8 ++-
 drivers/scsi/ofc/fcoe/fcoeioctl.c       |    2 -
 drivers/scsi/ofc/include/ofc_dbg.h      |   37 +++++++++++++++
 drivers/scsi/ofc/include/sa_log.h       |   79 -------------------------------
 drivers/scsi/ofc/libfc/fc_disc_targ.c   |   20 ++++----
 drivers/scsi/ofc/libfc/fc_exch.c        |   14 +++--
 drivers/scsi/ofc/libfc/fc_frame.c       |    2 -
 drivers/scsi/ofc/libfc/fc_local_port.c  |   54 +++++++++++----------
 drivers/scsi/ofc/libfc/fc_port.c        |    2 -
 drivers/scsi/ofc/libfc/fc_print.c       |   16 +++---
 drivers/scsi/ofc/libfc/fc_remote_port.c |    6 +-
 drivers/scsi/ofc/libfc/fc_sess.c        |   40 ++++++++--------
 drivers/scsi/ofc/libfc/fcs_attr.c       |    2 -
 drivers/scsi/ofc/libfc/fcs_cmd.c        |    6 +-
 drivers/scsi/ofc/libfc/fcs_event.c      |    2 -
 drivers/scsi/ofc/libfc/fcs_state.c      |   30 ++++++------
 drivers/scsi/ofc/libsa/Makefile         |    1 
 drivers/scsi/ofc/libsa/sa_assert.c      |    8 ++-
 drivers/scsi/ofc/libsa/sa_cons_linux.c  |    2 -
 drivers/scsi/ofc/libsa/sa_event.c       |    2 -
 drivers/scsi/ofc/libsa/sa_hash_kern.c   |    4 +-
 drivers/scsi/ofc/libsa/sa_log.c         |    8 ++-
 drivers/scsi/ofc/libsa/sa_state.c       |   18 ++++---
 drivers/scsi/ofc/libsa/sa_timer.c       |    2 -
 drivers/scsi/ofc/openfc/openfc_attr.c   |    2 -
 drivers/scsi/ofc/openfc/openfc_if.c     |   30 ++++++------
 drivers/scsi/ofc/openfc/openfc_ioctl.c  |    6 +-
 drivers/scsi/ofc/openfc/openfc_pkt.c    |    6 +-
 drivers/scsi/ofc/openfc/openfc_scsi.c   |   40 ++++++++--------
 31 files changed, 216 insertions(+), 258 deletions(-)

diff --git a/drivers/scsi/ofc/fcoe/fcoe_dev.c b/drivers/scsi/ofc/fcoe/fcoe_dev.c
index df652b6..78f762d 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_dev.c
+++ b/drivers/scsi/ofc/fcoe/fcoe_dev.c
@@ -46,7 +46,7 @@
 #include "fc_fcoe_old.h"	/* also include old definitions */
 #include "fcdev.h"
 #include "fcoeioctl.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "fcoe_def.h"
 #include "crc32_le.h"
 
@@ -86,12 +86,12 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
 	fdev = fc->fd;
 	if (unlikely(fdev == NULL)) {
-		SA_LOG("cannot find hba structure");
+		OFC_DBG("cannot find hba structure");
 		goto err2;
 	}
 
 	if (unlikely(debug_fcoe)) {
-		SA_LOG("skb_info: len:%d data_len:%d head:%p data:%p tail:%p "
+		OFC_DBG("skb_info: len:%d data_len:%d head:%p data:%p tail:%p "
 		       "end:%p sum:%d dev:%s", skb->len, skb->data_len,
 		       skb->head, skb->data, skb->tail, skb->end, skb->csum,
 		       skb->dev ? skb->dev->name : "<NULL>");
@@ -100,7 +100,7 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	/* check for FCOE packet type */
 	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
-		SA_LOG("wrong FC type frame");
+		OFC_DBG("wrong FC type frame");
 		goto err;
 	}
 	data = skb->data;
@@ -454,7 +454,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		fr = fcoe_dev_from_skb(skb);
 		fc_dev = fr->fd;
 		if (unlikely(fc_dev == NULL)) {
-			SA_LOG("invalid HBA Structure");
+			OFC_DBG("invalid HBA Structure");
 			kfree_skb(skb);
 			continue;
 		}
@@ -462,7 +462,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		stats = fc_dev->dev_stats[smp_processor_id()];
 
 		if (unlikely(debug_fcoe)) {
-			SA_LOG("skb_info: len:%d data_len:%d head:%p data:%p "
+			OFC_DBG("skb_info: len:%d data_len:%d head:%p data:%p "
 			       "tail:%p end:%p sum:%d dev:%s",
 			       skb->len, skb->data_len,
 			       skb->head, skb->data, skb->tail, skb->end,
@@ -485,7 +485,7 @@ int fcoe_percpu_receive_thread(void *arg)
 
 			hp = (struct fcoe_hdr *)skb->data;
 			if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
-				SA_LOG("unknown FCoE version %x",
+				OFC_DBG("unknown FCoE version %x",
 				       FC_FCOE_DECAPS_VER(hp));
 				stats->ErrorFrames++;
 				kfree_skb(skb);
@@ -517,7 +517,7 @@ int fcoe_percpu_receive_thread(void *arg)
 			skb_linearize(skb);	/* not ideal */
 #endif
 		if (unlikely(fr_len + tlen > skb->len)) {
-			SA_LOG("short frame fr_len %x skb->len %x\n",
+			OFC_DBG("short frame fr_len %x skb->len %x\n",
 			       fr_len + tlen, skb->len);
 			stats->ErrorFrames++;
 			kfree_skb(skb);
@@ -551,7 +551,8 @@ int fcoe_percpu_receive_thread(void *arg)
 			openfc_rcv(fc_dev, fp);
 		} else {
 			if (debug_fcoe || stats->InvalidCRCCount < 5) {
-				SA_LOG("dropping frame with CRC error");
+				printk(KERN_WARNING \
+					"fcoe: dropping frame with CRC error");
 				fc_print_frame_hdr("frame with CRC error", fp);
 			}
 			stats->InvalidCRCCount++;
diff --git a/drivers/scsi/ofc/fcoe/fcoe_if.c b/drivers/scsi/ofc/fcoe/fcoe_if.c
index fd3c7a7..74e5ffc 100644
--- a/drivers/scsi/ofc/fcoe/fcoe_if.c
+++ b/drivers/scsi/ofc/fcoe/fcoe_if.c
@@ -52,7 +52,7 @@
 #include "fcdev.h"
 #include "fcoeioctl.h"
 #include "openfc_ioctl.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "fcoe_def.h"
 
 #ifndef BUILD_VERSION
@@ -222,7 +222,7 @@ int fcoe_create_interface(struct fcoe_info *fci, void *ptr)
 	ASSERT(fci != NULL);
 	fdev = openfc_alloc_dev(&fcoe_port_ops, sizeof(struct fcoe_softc));
 	if (unlikely(!fdev)) {
-		SA_LOG("couldn't allocate space for hba struct");
+		OFC_DBG("couldn't allocate space for hba struct");
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -236,7 +236,7 @@ int fcoe_create_interface(struct fcoe_info *fci, void *ptr)
 	 */
 	fc->real_dev = (void *)dev_get_by_name(&init_net, cfg->local_ifname);
 	if (fc->real_dev == NULL) {
-		SA_LOG("could not get network device for %s",
+		OFC_DBG("could not get network device for %s",
 		       cfg->local_ifname);
 		rc = -ENODEV;
 		goto out;
diff --git a/drivers/scsi/ofc/fcoe/fcoeinit.c b/drivers/scsi/ofc/fcoe/fcoeinit.c
index 3b80946..1ac7d69 100644
--- a/drivers/scsi/ofc/fcoe/fcoeinit.c
+++ b/drivers/scsi/ofc/fcoe/fcoeinit.c
@@ -34,7 +34,7 @@
 #include "fc_frame.h"
 #include "fcdev.h"
 #include "fcoeioctl.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 
 #include "fcoe_def.h"
 
@@ -209,7 +209,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 		rc = NOTIFY_OK;
 		break;
 	default:
-		SA_LOG("unknown event %d call", event);
+		OFC_DBG("unknown event %ld call", event);
 		rc = NOTIFY_OK;
 	}
 	if (fc_dev->fd_link_status != new_status) {
@@ -247,7 +247,7 @@ static int __init fcoeinit(void)
 	 */
 	fci->fcoe_major = fcoe_reg_char_dev();
 	if (fci->fcoe_major < 0) {
-		SA_LOG("failed to register the control device\n");
+		OFC_DBG("failed to register the control device\n");
 		rc = -ENODEV;
 		goto out;
 	}
@@ -293,7 +293,7 @@ static int __init fcoeinit(void)
 		}
 	}
 	if (rc < 0) {
-		SA_LOG("failed to initialize proc intrerface\n");
+		OFC_DBG("failed to initialize proc intrerface\n");
 		rc = -ENODEV;
 		goto out_chrdev;
 	}
diff --git a/drivers/scsi/ofc/fcoe/fcoeioctl.c b/drivers/scsi/ofc/fcoe/fcoeioctl.c
index 05609c7..a2f8a25 100644
--- a/drivers/scsi/ofc/fcoe/fcoeioctl.c
+++ b/drivers/scsi/ofc/fcoe/fcoeioctl.c
@@ -27,7 +27,7 @@
 #include "fc_frame.h"
 #include "fcdev.h"
 #include "fcoeioctl.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 
 #include "fcoe_def.h"
 
diff --git a/drivers/scsi/ofc/include/ofc_dbg.h b/drivers/scsi/ofc/include/ofc_dbg.h
new file mode 100644
index 0000000..31f2654
--- /dev/null
+++ b/drivers/scsi/ofc/include/ofc_dbg.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright(c) 2007 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained at www.Open-FCoE.org
+ */
+
+#ifndef _OFC_DBG_H_
+#define _OFC_DBG_H_
+
+#define OFC_DEBUG 1
+
+#ifdef OFC_DEBUG
+/*
+ * Log message.
+ */
+#define OFC_DBG(fmt, args...) \
+		do { \
+			printk(KERN_INFO "%s " fmt, __FUNCTION__, ##args); \
+		} while (0)
+#else
+#define OFC_DBG(fmt, args...)
+#endif
+
+#endif /* _OFC_DBG_H_ */
diff --git a/drivers/scsi/ofc/include/sa_log.h b/drivers/scsi/ofc/include/sa_log.h
deleted file mode 100644
index 4163a35..0000000
--- a/drivers/scsi/ofc/include/sa_log.h
+++ /dev/null
@@ -1,79 +0,0 @@
-/*
- * Copyright(c) 2007 Intel Corporation. All rights reserved.
- * 
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- * 
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- * 
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- * 
- * Maintained at www.Open-FCoE.org
- */
-
-#ifndef _LIBSA_SA_LOG_H_
-#define _LIBSA_SA_LOG_H_
-
-void sa_log(const char *format, ...);
-void sa_log_func(const char *func, const char *format, ...);
-void sa_log_err(int, const char *func, const char *format, ...);
-
-/*
- * These functions can be provided outside of libsa for those environments
- * that want to redirect them.
- */
-void sa_log_output(const char *);	/* log message */
-void sa_log_abort(const char *);	/* log message and abort */
-void sa_log_output_exit(const char *);	/* log message and exit */
-
-#define __SA_STRING(x)  #x
-
-/*
- * Log message.
- */
-#define SA_LOG(...) \
-            do {                                                        \
-                sa_log_func(__FUNCTION__, __VA_ARGS__);                 \
-            } while (0)
-
-#define SA_LOG_ERR(error, ...) \
-            do {                                                        \
-                sa_log_err(error, NULL, __VA_ARGS__);			\
-            } while (0)
-
-/*
- * Logging exits.
- */
-#define SA_LOG_EXIT(...) \
-            do {                                                        \
-                sa_log_func(__FUNCTION__, __VA_ARGS__);                 \
-                sa_log_func(__FUNCTION__, "exiting at %s:%d",           \
-                  __FILE__, __LINE__);                                  \
-                sa_log_output_exit(__FUNCTION__);           		\
-            } while (0)
-
-#define SA_LOG_ERR_EXIT(error, ...) \
-            do {                                                        \
-                sa_log_func(__FUNCTION__, __VA_ARGS__);                 \
-                sa_log_err(error, __FUNCTION__, "exiting at %s:%d", 	\
-                  __FILE__, __LINE__);                                  \
-                sa_log_output_exit(__FUNCTION__);           		\
-            } while (0)
-
-/*
- * Logging options.
- */
-#define SA_LOGF_TIME    0x0001      /* include timestamp in message */
-#define SA_LOGF_DELTA   0x0002      /* include time since last message */
-
-extern int sa_log_flags;            /* timestamp and other option flags */
-extern int sa_log_time_delta_min;   /* minimum diff to print in millisec */
-extern char *sa_log_prefix;         /* string to print before any message */
-
-#endif /* _LIBSA_SA_LOG_H_ */
diff --git a/drivers/scsi/ofc/libfc/fc_disc_targ.c b/drivers/scsi/ofc/libfc/fc_disc_targ.c
index 16d52b6..4906a2b 100644
--- a/drivers/scsi/ofc/libfc/fc_disc_targ.c
+++ b/drivers/scsi/ofc/libfc/fc_disc_targ.c
@@ -27,7 +27,7 @@
 #include "net_types.h"
 
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_timer.h"
 #include "sa_event.h"
 
@@ -374,12 +374,12 @@ static void fcdt_error(enum fc_event event, void *lp_arg)
 		if (lp->fl_disc_retries++ < FCDT_RETRY_LIMIT) {
 			fcdt_gpn_ft_req(lp);
 		} else {
-			SA_LOG("event %d - ending", event);
+			OFC_DBG("event %d - ending", event);
 			fcdt_done(lp);
 		}
 		break;
 	default:
-		SA_LOG("event %d - ending", event);
+		OFC_DBG("event %d - ending", event);
 		fcdt_done(lp);
 		break;
 	}
@@ -500,7 +500,7 @@ static void fcdt_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	    lp->fl_disc_seq_cnt == 0) {
 		cp = fc_frame_payload_get(fp, sizeof(*cp));
 		if (cp == NULL) {
-			SA_LOG("GPN_FT response too short.  len %d",
+			OFC_DBG("GPN_FT response too short.  len %d",
 			       fp->fr_len);
 		} else if (net16_get(&cp->ct_cmd) == FC_FS_ACC) {
 
@@ -510,17 +510,17 @@ static void fcdt_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 			buf = cp + 1;
 			len -= sizeof(*cp);
 		} else if (net16_get(&cp->ct_cmd) == FC_FS_RJT) {
-			SA_LOG("GPN_FT rejected reason %x exp %x "
+			OFC_DBG("GPN_FT rejected reason %x exp %x "
 			       "(check zoning)", cp->ct_reason, cp->ct_explan);
 			fcdt_done(lp);
 		} else {
-			SA_LOG("GPN_FT unexpected response code %x\n",
+			OFC_DBG("GPN_FT unexpected response code %x\n",
 			       net16_get(&cp->ct_cmd));
 		}
 	} else if (fp->fr_sof == FC_SOF_N3 && seq_cnt == lp->fl_disc_seq_cnt) {
 		buf = fh + 1;
 	} else {
-		SA_LOG("GPN_FT unexpected frame - out of sequence? "
+		OFC_DBG("GPN_FT unexpected frame - out of sequence? "
 		       "seq_cnt %x expected %x sof %x eof %x",
 		       seq_cnt, lp->fl_disc_seq_cnt, fp->fr_sof, fp->fr_eof);
 	}
@@ -606,7 +606,7 @@ static void fcdt_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	cp = fc_frame_payload_get(fp, sizeof(cp->ct));
 	if (cp == NULL) {
-		SA_LOG("GPN_ID response too short.  len %d", fp->fr_len);
+		OFC_DBG("GPN_ID response too short.  len %d", fp->fr_len);
 		return;
 	}
 	cmd = net16_get(&cp->ct.ct_cmd);
@@ -614,7 +614,7 @@ static void fcdt_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 	case FC_FS_ACC:
 		cp = fc_frame_payload_get(fp, sizeof(*cp));
 		if (cp == NULL) {
-			SA_LOG("GPN_ID response payload too short.  len %d",
+			OFC_DBG("GPN_ID response payload too short.  len %d",
 			       fp->fr_len);
 			break;
 		}
@@ -632,7 +632,7 @@ static void fcdt_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 		break;
 
 	default:
-		SA_LOG("GPN_ID unexpected CT response cmd %x\n", cmd);
+		OFC_DBG("GPN_ID unexpected CT response cmd %x\n", cmd);
 		break;
 	}
 	fc_remote_port_release(rp);
diff --git a/drivers/scsi/ofc/libfc/fc_exch.c b/drivers/scsi/ofc/libfc/fc_exch.c
index 4bbf3d2..4a19936 100644
--- a/drivers/scsi/ofc/libfc/fc_exch.c
+++ b/drivers/scsi/ofc/libfc/fc_exch.c
@@ -24,7 +24,7 @@
 #include "sa_kernel.h"
 #include "sa_assert.h"
 #include "net_types.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_hash.h"
 #include "sa_timer.h"
 
@@ -854,7 +854,7 @@ struct fc_seq *fc_seq_start(struct fc_exch *ep)
 	sp = fc_seq_alloc(ep, ep->ex_seq_id++);
 	ASSERT(sp);
 	if (fc_exch_debug)
-		SA_LOG("exch %4x f_ctl %6x seq %2x f_ctl %6x\n",
+		OFC_DBG("exch %4x f_ctl %6x seq %2x f_ctl %6x\n",
 		       ep->ex_xid, ep->ex_f_ctl, sp->seq_id, sp->seq_f_ctl);
 	spin_unlock_bh(&ep->ex_lock);
 	return sp;
@@ -1257,7 +1257,7 @@ void fc_exch_recv_req(struct fc_exch_mgr *mp, struct fc_frame *fp,
 			}
 			if (event != FC_EV_NONE) {
 				if (fc_exch_debug)
-					SA_LOG("exch: BLS rctl %x - %s\n",
+					OFC_DBG("exch: BLS rctl %x - %s\n",
 					       fh->fh_r_ctl,
 					       fc_exch_rctl_name(fh->fh_r_ctl));
 				if (errh)
@@ -1287,7 +1287,7 @@ void fc_exch_recv_req(struct fc_exch_mgr *mp, struct fc_frame *fp,
 		fc_seq_release(sp);
 	} else {
 		if (fc_exch_debug)
-			SA_LOG("exch/seq lookup failed: reject %x\n", reject);
+			OFC_DBG("exch/seq lookup failed: reject %x\n", reject);
 		fc_frame_free(fp);
 	}
 }
@@ -1403,7 +1403,7 @@ void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		atomic_inc(&mp->em_stats.ems_error_xid_not_found);
 		reject = FC_RJT_SEQ_ID;
 		if (fc_exch_debug)
-			SA_LOG("seq lookup failed: reject %x\n", reject);
+			OFC_DBG("seq lookup failed: reject %x\n", reject);
 	} else {
 		ep = fc_seq_exch(sp);
 		ASSERT(ep);
@@ -1427,7 +1427,7 @@ void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 			default:
 				spin_unlock_bh(&ep->ex_lock);
 				if (fc_exch_debug)
-					SA_LOG("BLS rctl %x - %s\n",
+					OFC_DBG("BLS rctl %x - %s\n",
 					       fh->fh_r_ctl,
 					       fc_exch_rctl_name(fh->fh_r_ctl));
 				break;
@@ -1435,7 +1435,7 @@ void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		} else {
 			atomic_inc(&mp->em_stats.ems_error_non_bls_resp);
 			if (fc_exch_debug) {
-				SA_LOG("non-BLS response to sequence");
+				OFC_DBG("non-BLS response to sequence");
 				fc_print_frame_hdr("fc_seq_recv_resp: "
 						   "non BLS response", fp);
 			}
diff --git a/drivers/scsi/ofc/libfc/fc_frame.c b/drivers/scsi/ofc/libfc/fc_frame.c
index 000416b..056df3d 100644
--- a/drivers/scsi/ofc/libfc/fc_frame.c
+++ b/drivers/scsi/ofc/libfc/fc_frame.c
@@ -24,7 +24,7 @@
 #include "sa_kernel.h"
 #include "net_types.h"
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "fc_fs.h"
 #include "fc_types.h"
 #include "fc_frame.h"
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/libfc/fc_local_port.c
index 66a1d47..95380f9 100644
--- a/drivers/scsi/ofc/libfc/fc_local_port.c
+++ b/drivers/scsi/ofc/libfc/fc_local_port.c
@@ -25,7 +25,7 @@
 #undef LIST_HEAD
 #include "net_types.h"
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_timer.h"
 #include "sa_event.h"
 #include "sa_hash.h"
@@ -234,14 +234,14 @@ static void fc_local_port_retry(struct fc_local_port *lp)
 	ASSERT(fc_local_port_locked(lp));
 	state = fc_local_port_state(lp);
 	if (lp->fl_retry_count == 0) {
-		SA_LOG("local port %6x alloc failure in state %s "
+		OFC_DBG("local port %6x alloc failure in state %s "
 		       "- will retry", lp->fl_fid, state);
 	}
 	if (lp->fl_retry_count < lp->fl_retry_limit) {
 		lp->fl_retry_count++;
 		sa_timer_set(&lp->fl_timer, lp->fl_e_d_tov * 1000);
 	} else {
-		SA_LOG("local port %6x alloc failure in state %s "
+		OFC_DBG("local port %6x alloc failure in state %s "
 		       "- retries exhausted", lp->fl_fid, state);
 		fc_local_port_state_event(lp, FC_EV_RJT);
 	}
@@ -377,7 +377,7 @@ fc_local_port_flogi_resp(struct fc_seq *sp, struct fc_frame *fp, void *lp_arg)
 	did = net24_get(&fh->fh_d_id);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
 		if (fc_local_port_debug)
-			SA_LOG("assigned fid %x", did);
+			OFC_DBG("assigned fid %x", did);
 		fc_local_port_lock(lp);
 		fc_local_port_set_fid_int(lp, did);
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
@@ -396,7 +396,7 @@ fc_local_port_flogi_resp(struct fc_seq *sp, struct fc_frame *fp, void *lp_arg)
 				if (e_d_tov > lp->fl_e_d_tov)
 					lp->fl_e_d_tov = e_d_tov;
 				lp->fl_r_a_tov = 2 * e_d_tov;
-				SA_LOG("point-to-point mode");
+				OFC_DBG("point-to-point mode");
 				fc_local_port_ptp_setup(lp,
 							net24_get(&fh->fh_s_id),
 							net64_get(&flp->
@@ -413,7 +413,7 @@ fc_local_port_flogi_resp(struct fc_seq *sp, struct fc_frame *fp, void *lp_arg)
 		}
 		fc_local_port_unlock_send(lp);
 	} else {
-		SA_LOG("bad FLOGI response\n");
+		OFC_DBG("bad FLOGI response\n");
 		fc_print_frame_hdr((char *)__FUNCTION__, fp);	/* XXX */
 	}
 	fc_frame_free(fp);
@@ -485,11 +485,11 @@ static void fc_local_port_recv_flogi_req(struct fc_seq *sp_in,
 		goto out;
 	remote_wwpn = net64_get(&flp->fl_wwpn);
 	if (remote_wwpn == lp->fl_port_wwn) {
-		SA_LOG("FLOGI from port with same WWPN %llx "
+		OFC_DBG("FLOGI from port with same WWPN %llx "
 		       "possible configuration error.", remote_wwpn);
 		goto out;
 	}
-	SA_LOG("FLOGI from port WWPN %llx ", remote_wwpn);
+	OFC_DBG("FLOGI from port WWPN %llx ", remote_wwpn);
 	fc_local_port_lock(lp);
 
 	/*
@@ -566,7 +566,7 @@ static void fc_local_port_sess_event(int event, void *lp_arg)
 	fc_local_port_hold(lp);
 	fc_local_port_lock(lp);
 	if (fc_local_port_debug) {
-		SA_LOG("local fid %6x dNS session event %d\n", lp->fl_fid,
+		OFC_DBG("local fid %6x dNS session event %d\n", lp->fl_fid,
 		       event);
 	}
 	switch (event) {
@@ -580,7 +580,7 @@ static void fc_local_port_sess_event(int event, void *lp_arg)
 		fc_local_port_state_event(lp, event);
 		break;
 	default:
-		SA_LOG("unexpected event %d from dNS session", event);
+		OFC_DBG("unexpected event %d from dNS session", event);
 		break;
 	}
 	fc_local_port_unlock_send(lp);
@@ -885,7 +885,7 @@ static void fc_local_port_log(void *lp_arg, const char *msg)
 {
 	struct fc_local_port *lp = lp_arg;
 
-	sa_log("local_port %6x %s", lp->fl_fid, msg);
+	OFC_DBG("local_port %6x %s", lp->fl_fid, msg);
 }
 
 int fc_local_port_table_create(struct fc_virt_fab *vp)
@@ -1016,7 +1016,7 @@ static void fc_local_port_set_fid_int(struct fc_local_port *lp, fc_fid_t fid)
 	vf = lp->fl_vf;
 	if (lp->fl_fid != fid) {
 		if (fc_local_port_debug) {
-			SA_LOG("changing local port fid from %x to %x",
+			OFC_DBG("changing local port fid from %x to %x",
 			       lp->fl_fid, fid);
 		}
 		fc_virt_fab_lock(vf);
@@ -1111,7 +1111,7 @@ static void fc_local_port_delete(struct fc_local_port *lp)
 	ASSERT(!atomic_read(&lp->fl_refcnt));
 
 	if (fc_local_port_debug)
-		SA_LOG("local port %6x delete", lp->fl_fid);
+		OFC_DBG("local port %6x delete", lp->fl_fid);
 	vf = lp->fl_vf;
 
 	fc_virt_fab_lock(vf);
@@ -1206,7 +1206,7 @@ static void fc_local_port_enter_init(struct fc_local_port *lp)
 	ASSERT(fc_local_port_locked(lp));
 
 	if (fc_local_port_debug)
-		SA_LOG("new state init");
+		OFC_DBG("new state init");
 	sess = lp->fl_dns_sess;
 	if (sess) {
 		fc_sess_event_deq(sess, fc_local_port_sess_event, lp);
@@ -1217,7 +1217,7 @@ static void fc_local_port_enter_init(struct fc_local_port *lp)
 
 	mfs = fc_port_get_max_frame_size(lp->fl_port);
 	if (mfs < FC_SP_MIN_MAX_PAYLOAD) {
-		SA_LOG("warning: port max frame size %d too small", mfs);
+		OFC_DBG("warning: port max frame size %d too small", mfs);
 		mfs = FC_SP_MIN_MAX_PAYLOAD + sizeof(struct fc_frame_header);
 	}
 	mfs -= sizeof(struct fc_frame_header);
@@ -1302,12 +1302,12 @@ static int fc_local_port_change(struct fc_local_port *lp,
 		break;
 	default:
 		if (fc_local_port_debug)
-			SA_LOG("unexpected event qualifier %x", ev_qual);
+			OFC_DBG("unexpected event qualifier %x", ev_qual);
 		break;
 	}
 	if (fc_local_port_debug)
-		SA_LOG("RSCN qual %x fid %x mask %x redisc %d",
-		       ev_qual, fid, mask, redisc, redisc);
+		OFC_DBG("RSCN qual %x fid %x mask %x redisc %d",
+		       ev_qual, fid, mask, redisc);
 	return redisc;
 }
 
@@ -1376,11 +1376,11 @@ static void fc_local_port_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		fc_seq_ls_acc(sp);
 		if (redisc && lp->fl_disc_cb) {
 			if (fc_local_port_debug)
-				SA_LOG("RSCN received: rediscovering");
+				OFC_DBG("RSCN received: rediscovering");
 			error = fc_disc_targ_restart(lp);
 			ASSERT_NOTIMPL(error == 0);
 		} else if (fc_local_port_debug) {
-			SA_LOG("RSCN received: not rediscovering. "
+			OFC_DBG("RSCN received: not rediscovering. "
 			       "redisc %d state %d disc_cb %p in_prog %d",
 			       redisc, lp->fl_state, lp->fl_disc_cb,
 			       lp->fl_disc_in_prog);
@@ -1649,7 +1649,7 @@ void fc_local_port_recv(struct fc_local_port *lp, struct fc_frame *fp)
 		break;
 
 	default:
-		SA_LOG("dropping invalid frame (eof %x)", fp->fr_eof);
+		OFC_DBG("dropping invalid frame (eof %x)", fp->fr_eof);
 		fc_print_frame_hdr("fc_local_port_recv - invalid frame", fp);
 		fc_frame_free(fp);
 		break;
@@ -1674,7 +1674,7 @@ static void fc_local_port_error(enum fc_event event, void *lp_arg)
 				event = FC_EV_RJT;
 		}
 		if (fc_local_port_debug)
-			SA_LOG("event %x %s retries %d limit %d",
+			OFC_DBG("event %x %s retries %d limit %d",
 			       event,
 			       sa_state_event_name(fc_local_port_state_table,
 						   event),
@@ -1706,7 +1706,7 @@ static void fc_local_port_port_event(int event, void *lp_arg)
 	struct fc_local_port *lp = lp_arg;
 
 	if (fc_local_port_debug)
-		SA_LOG("local fid %6x port event %d\n", lp->fl_fid, event);
+		OFC_DBG("local fid %6x port event %d\n", lp->fl_fid, event);
 	switch ((enum fc_event)event) {
 	case FC_EV_READY:
 		fc_local_port_lock(lp);
@@ -1721,7 +1721,7 @@ static void fc_local_port_port_event(int event, void *lp_arg)
 		break;
 
 	default:
-		SA_LOG("unexpected event %d", event);
+		OFC_DBG("unexpected event %d", event);
 		break;
 	}
 }
@@ -1770,7 +1770,7 @@ static void fc_local_port_gid_pn_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	resp = fc_frame_payload_get(fp, sizeof(resp->ct));
 	if (resp == NULL) {
-		SA_LOG("GID_PN response too short.  len %d", fp->fr_len);
+		OFC_DBG("GID_PN response too short.  len %d", fp->fr_len);
 		event = FC_EV_RJT;
 		goto out;
 	}
@@ -1790,7 +1790,7 @@ static void fc_local_port_gid_pn_resp(struct fc_seq *sp, struct fc_frame *fp,
 		 * does not exist in the nameserver
 		 */
 		if (fc_local_port_debug) {
-			SA_LOG("GID_PN for %llx rejected reason %x exp %x\n",
+			OFC_DBG("GID_PN for %llx rejected reason %x exp %x\n",
 			       rp->rp_port_wwn,
 			       resp->ct.ct_reason, resp->ct.ct_explan);
 		}
@@ -1799,7 +1799,7 @@ static void fc_local_port_gid_pn_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	default:
 		if (fc_local_port_debug) {
-			SA_LOG("GID_PN unexpected response code 0x%x\n",
+			OFC_DBG("GID_PN unexpected response code 0x%x\n",
 			       net16_get(&resp->ct.ct_cmd));
 		}
 		event = FC_EV_DOWN;
diff --git a/drivers/scsi/ofc/libfc/fc_port.c b/drivers/scsi/ofc/libfc/fc_port.c
index 257ba4a..191ab4f 100644
--- a/drivers/scsi/ofc/libfc/fc_port.c
+++ b/drivers/scsi/ofc/libfc/fc_port.c
@@ -20,7 +20,7 @@
 #include "sa_kernel.h"
 #include "sa_assert.h"
 #include "sa_error_inject.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_event.h"
 #include "fc_types.h"
 #include "fc_port.h"
diff --git a/drivers/scsi/ofc/libfc/fc_print.c b/drivers/scsi/ofc/libfc/fc_print.c
index 647a915..e21b4a0 100644
--- a/drivers/scsi/ofc/libfc/fc_print.c
+++ b/drivers/scsi/ofc/libfc/fc_print.c
@@ -24,7 +24,7 @@
 #include "sa_kernel.h"
 #include "sa_assert.h"
 #include "net_types.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "fc_fs.h"
 #include "fc_ils.h"
 #include "fc_els.h"
@@ -74,7 +74,7 @@ void fc_print_frame_hdr(const char *msg, const struct fc_frame *fp)
 	op = (u_char *) (fh + 1);
 
 	if (len < sizeof(*fh)) {
-		sa_log("dump_frame: %s: short frame: len 0x%lx\n", msg, len);
+		OFC_DBG("dump_frame: %s: short frame: len 0x%d\n", msg, len);
 	} else if (fc_print_verbose) {
 		fc_print_lookup(fh->fh_r_ctl, r_ctl, sizeof(r_ctl),
 				fc_print_rctls, sizeof(fc_print_rctls));
@@ -105,28 +105,28 @@ void fc_print_frame_hdr(const char *msg, const struct fc_frame *fp)
 			snprintf(opcode, sizeof(opcode), "op %x", op[0]);
 			break;
 		}
-		sa_log("%-15s %6.6x -> %6.6x xids %4.4x %4.4x %s %s %s",
+		OFC_DBG("%-15s %6.6x -> %6.6x xids %4.4x %4.4x %s %s %s",
 		       msg, net24_get(&fh->fh_s_id),
 		       net24_get(&fh->fh_d_id), net16_get(&fh->fh_ox_id),
 		       net16_get(&fh->fh_rx_id), r_ctl, type, opcode);
 	} else if (fc_print_hex) {
-		sa_log("%s frame: %zd (%zx) bytes sof %x eof %x\n",
+		OFC_DBG("%s frame: %zd (%zx) bytes sof %x eof %x\n",
 		       msg, len, len, fp->fr_sof, fp->fr_eof);
-		sa_log("    r_ctl %2x  d_id  %6x  cs_ctl %2x  s_id %6x\n",
+		OFC_DBG("    r_ctl %2x  d_id  %6x  cs_ctl %2x  s_id %6x\n",
 		       fh->fh_r_ctl, net24_get(&fh->fh_d_id),
 		       fh->fh_cs_ctl, net24_get(&fh->fh_s_id));
-		sa_log("    type  %2x  f_ctl %6x  seq_id %2x  "
+		OFC_DBG("    type  %2x  f_ctl %6x  seq_id %2x  "
 		       "seq_cnt %4x  df_ctl %2x\n",
 		       fh->fh_type, net24_get(&fh->fh_f_ctl),
 		       fh->fh_seq_id, net16_get(&fh->fh_seq_cnt),
 		       fh->fh_df_ctl);
-		sa_log("    ox_id %4x  rx_id %4x  parm_offset %x  "
+		OFC_DBG("    ox_id %4x  rx_id %4x  parm_offset %x  "
 		       "op %2.2x %2.2x %2.2x %2.2x\n",
 		       net16_get(&fh->fh_ox_id), net16_get(&fh->fh_rx_id),
 		       net32_get(&fh->fh_parm_offset), op[0], op[1], op[2],
 		       op[3]);
 	} else {
-		sa_log("%s frame: \n"
+		OFC_DBG("%s frame: \n"
 		       "    %6.6x -> %6.6x ox %4.4x rx %4.4x "
 		       "r_ctl %2.2x type %2.2x op %2.2x %2.2x %2.2x %2.2x\n",
 		       msg, net24_get(&fh->fh_s_id),
diff --git a/drivers/scsi/ofc/libfc/fc_remote_port.c b/drivers/scsi/ofc/libfc/fc_remote_port.c
index f3e2851..9a5e62a 100644
--- a/drivers/scsi/ofc/libfc/fc_remote_port.c
+++ b/drivers/scsi/ofc/libfc/fc_remote_port.c
@@ -29,7 +29,7 @@
 #include "sa_assert.h"
 #include "sa_event.h"
 #include "sa_hash.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 
 #include "fc_types.h"
 #include "fc_remote_port.h"
@@ -194,7 +194,7 @@ static void fc_remote_port_print(void *rp_arg, void *msg_arg)
 {
 	struct fc_remote_port *rp = rp_arg;
 
-	SA_LOG("%s rp %6x wwpn %16llx %p",
+	OFC_DBG("%s rp %6x wwpn %16llx %p",
 	       (char *)msg_arg, rp->rp_fid, rp->rp_port_wwn, rp);
 }
 
@@ -204,7 +204,7 @@ static void fc_remote_port_print(void *rp_arg, void *msg_arg)
 static void fc_remote_port_list(struct fc_virt_fab *vp, char *msg,
 				struct fc_remote_port *rp)
 {
-	SA_LOG("%s rp %6x %16llx %p", msg, rp->rp_fid, rp->rp_port_wwn, rp);
+	OFC_DBG("%s rp %6x %16llx %p", msg, rp->rp_fid, rp->rp_port_wwn, rp);
 	sa_hash_iterate(vp->vf_rport_by_wwpn, fc_remote_port_print, "");
 }
 #endif /* FC_REMOTE_PORT_DEBUG */
diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/libfc/fc_sess.c
index aabd472..34cc2b0 100644
--- a/drivers/scsi/ofc/libfc/fc_sess.c
+++ b/drivers/scsi/ofc/libfc/fc_sess.c
@@ -29,7 +29,7 @@
 #include "net_types.h"
 
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_timer.h"
 #include "sa_event.h"
 #include "sa_hash.h"
@@ -310,7 +310,7 @@ static void fc_sess_log(void *sess_arg, const char *msg)
 {
 	struct fc_sess *sess = sess_arg;
 
-	sa_log("sess to %6x %s", sess->fs_remote_fid, msg);
+	OFC_DBG("sess to %6x %s", sess->fs_remote_fid, msg);
 }
 
 /*
@@ -393,7 +393,7 @@ static void fc_sess_debug_print(void *sess_arg, void *arg)
 {
 	struct fc_sess *sess = sess_arg;
 
-	SA_LOG("fid %6.6x did %6.6x ref %d\n", sess->fs_local_fid,
+	OFC_DBG("fid %6.6x did %6.6x ref %d\n", sess->fs_local_fid,
 	       sess->fs_remote_fid, atomic_read(&sess->fs_refcnt));
 
 }
@@ -518,7 +518,7 @@ static void fc_sess_delete(struct fc_sess *sess, void *arg)
 	u_int64_t key;
 
 	if (fc_sess_debug)
-		SA_LOG("sess to %6x delete", sess->fs_remote_fid);
+		OFC_DBG("sess to %6x delete", sess->fs_remote_fid);
 	ASSERT(sess);
 	ASSERT(sess->fs_local_port);
 	ASSERT(sess->fs_remote_port);
@@ -595,7 +595,7 @@ void fc_sess_reset(struct fc_sess *sess)
 	u_int held;
 
 	if (fc_sess_debug)
-		SA_LOG("sess to %6x reset", sess->fs_remote_fid);
+		OFC_DBG("sess to %6x reset", sess->fs_remote_fid);
 	fc_sess_lock(sess);
 	started = sess->fs_started;
 	held = sess->fs_plogi_held;
@@ -753,14 +753,14 @@ static void fc_sess_retry(struct fc_sess *sess)
 	state = sa_state_name(fc_sess_state_table, sess->fs_state);
 	lp = sess->fs_local_port;
 	if (sess->fs_retries == 0)
-		SA_LOG("sess %6x alloc failure in state %s - will retry",
+		OFC_DBG("sess %6x alloc failure in state %s - will retry",
 		       sess->fs_remote_fid, state);
 	if (sess->fs_retries < lp->fl_retry_limit) {
 		sess->fs_retries++;
 		sa_timer_set(&sess->fs_timer, sess->fs_e_d_tov * 1000);
 	} else {
-		SA_LOG("sess %6x alloc failure in state %s - retries exhausted",
-		       sess->fs_remote_fid, state);
+		OFC_DBG("sess %6x alloc failure in state %s retries exhausted",
+						sess->fs_remote_fid, state);
 		fc_sess_state_event(sess, FC_EV_RJT);
 	}
 }
@@ -777,7 +777,7 @@ static void fc_sess_error(enum fc_event event, void *sess_arg)
 	    sess->fs_retries++ >= sess->fs_local_port->fl_retry_limit)
 		event = FC_EV_RJT;
 	if (fc_sess_debug)
-		SA_LOG("event %s retries %d",
+		OFC_DBG("event %s retries %d",
 		       sa_state_event_name(fc_sess_state_table, event),
 		       sess->fs_retries);
 	fc_sess_state_event(sess_arg, event);
@@ -819,7 +819,7 @@ static void fc_sess_plogi_recv_resp(struct fc_seq *sp, struct fc_frame *fp,
 		fc_sess_state_event(sess, FC_EV_ACC);
 	} else {
 		if (fc_sess_debug) {
-			SA_LOG("bad PLOGI response");
+			OFC_DBG("bad PLOGI response");
 			fc_print_frame_hdr((char *)__FUNCTION__, fp);
 		}
 		rjp = fc_frame_payload_get(fp, sizeof(*rjp));
@@ -892,7 +892,7 @@ static void fc_sess_els_recv_resp(struct fc_seq *sp, struct fc_frame *fp,
 		}
 		fc_sess_state_event(sess, FC_EV_ACC);
 	} else {
-		SA_LOG("bad ELS response\n");
+		OFC_DBG("bad ELS response\n");
 		fc_print_frame_hdr((char *)__FUNCTION__, fp);	/* XXX */
 		fc_sess_state_event(sess, FC_EV_RJT);
 	}
@@ -1207,7 +1207,7 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 	sid = net24_get(&fh->fh_s_id);
 	pl = fc_frame_payload_get(fp, sizeof(*pl));
 	if (!pl) {
-		SA_LOG("incoming PLOGI from %x too short", sid);
+		OFC_DBG("incoming PLOGI from %x too short", sid);
 		/* XXX TBD: send reject? */
 		fc_frame_free(fp);
 		return;
@@ -1236,12 +1236,12 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 			/*
 			 * The upper level protocol isn't expecting logins.
 			 */
-			SA_LOG("incoming PLOGI from %6x wwpn %llx state INIT "
+			OFC_DBG("incoming PLOGI from %6x wwpn %llx state INIT "
 			       "- reject\n", sid, wwpn);
 			reject = ELS_RJT_UNSUP;
 		} else {
 			if (fc_sess_debug)
-				SA_LOG("incoming PLOGI from %6x "
+				OFC_DBG("incoming PLOGI from %6x "
 				       "wwpn %llx state INIT "
 				       "- accept\n", sid, wwpn);
 		}
@@ -1253,14 +1253,14 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 		 * matches or was unknown.
 		 */
 		if (rp->rp_port_wwn != 0 && rp->rp_port_wwn != wwpn) {
-			SA_LOG("incoming PLOGI from name %llx expected %llx\n",
+			OFC_DBG("incoming PLOGI from name %llx expected %llx\n",
 			       wwpn, rp->rp_port_wwn);
 			reject = ELS_RJT_UNAB;
 		}
 		break;
 	case SESS_ST_PLOGI:
 		if (fc_sess_debug)
-			SA_LOG("incoming PLOGI from %x in PLOGI state %d",
+			OFC_DBG("incoming PLOGI from %x in PLOGI state %d",
 			       sid, sess->fs_state);
 		if (wwpn < lp->fl_port_wwn)
 			reject = ELS_RJT_INPROG;
@@ -1269,14 +1269,14 @@ static void fc_sess_recv_plogi_req(struct fc_sess *sess,
 	case SESS_ST_ERROR:
 	case SESS_ST_READY:
 		if (fc_sess_debug)
-			SA_LOG("incoming PLOGI from %x in logged-in state %d "
+			OFC_DBG("incoming PLOGI from %x in logged-in state %d "
 			       "- ignored for now", sid, sess->fs_state);
 		/* XXX TBD - should reset */
 		break;
 	case SESS_ST_NONE:
 	default:
 		if (fc_sess_debug)
-			SA_LOG("incoming PLOGI from %x in unexpected state %d",
+			OFC_DBG("incoming PLOGI from %x in unexpected state %d",
 			       sid, sess->fs_state);
 		break;
 	}
@@ -1455,7 +1455,7 @@ static void fc_sess_recv_prlo_req(struct fc_sess *sess, struct fc_seq *sp,
 	struct fc_frame_header *fh;
 
 	fh = fc_frame_header_get(fp);
-	SA_LOG("incoming PRLO from %x state %d",
+	OFC_DBG("incoming PRLO from %x state %d",
 	       net24_get(&fh->fh_s_id), sess->fs_state);
 	fc_seq_ls_rjt(sp, ELS_RJT_UNAB, ELS_EXPL_NONE);
 	fc_frame_free(fp);
@@ -1472,7 +1472,7 @@ static void fc_sess_recv_logo_req(struct fc_sess *sess, struct fc_seq *sp,
 
 	fh = fc_frame_header_get(fp);
 	if (fc_sess_debug)
-		SA_LOG("incoming LOGO from %x state %s %s",
+		OFC_DBG("incoming LOGO from %x state %s %s",
 			net24_get(&fh->fh_s_id),
 			sa_state_name(fc_sess_state_table, sess->fs_state),
 			sess->fs_started ? "started" : "not started");
diff --git a/drivers/scsi/ofc/libfc/fcs_attr.c b/drivers/scsi/ofc/libfc/fcs_attr.c
index f6e25d9..5b355de 100644
--- a/drivers/scsi/ofc/libfc/fcs_attr.c
+++ b/drivers/scsi/ofc/libfc/fcs_attr.c
@@ -36,7 +36,7 @@
 
 #include "sa_kernel.h"
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_event.h"
 #include "net_types.h"
 #include "fc_encaps.h"
diff --git a/drivers/scsi/ofc/libfc/fcs_cmd.c b/drivers/scsi/ofc/libfc/fcs_cmd.c
index 15214d6..5564f82 100644
--- a/drivers/scsi/ofc/libfc/fcs_cmd.c
+++ b/drivers/scsi/ofc/libfc/fcs_cmd.c
@@ -19,7 +19,7 @@
 
 #include "sa_kernel.h"
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "fc_types.h"
 #include "fc_event.h"
 #include "fc_frame.h"
@@ -177,7 +177,7 @@ int fcs_cmd_send(struct fcs_state *sp, struct fc_frame *fp,
 		rc = -EINTR;
 		break;
 	default:
-		SA_LOG("unexpected event %d", cp->fcc_event);
+		OFC_DBG("unexpected event %d", cp->fcc_event);
 		rc = -EINVAL;
 		break;
 	}
@@ -218,7 +218,7 @@ static void fcs_cmd_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 	if (offset + len > cp->fcc_resp_frame->fr_len)
 		error |= 0x20;
 	if (error) {
-		SA_LOG("rejecting - unexpected header fields %x", error);
+		OFC_DBG("rejecting - unexpected header fields %x", error);
 		fc_print_frame_hdr(__FUNCTION__, fp);	/* XXX */
 		cp->fcc_event = FC_EV_RJT;	/* cause error return */
 	} else {
diff --git a/drivers/scsi/ofc/libfc/fcs_event.c b/drivers/scsi/ofc/libfc/fcs_event.c
index a9aa699..d6ab9d9 100644
--- a/drivers/scsi/ofc/libfc/fcs_event.c
+++ b/drivers/scsi/ofc/libfc/fcs_event.c
@@ -33,7 +33,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "fc_types.h"
 #include "fc_frame.h"
 #include "fc_port.h"
diff --git a/drivers/scsi/ofc/libfc/fcs_state.c b/drivers/scsi/ofc/libfc/fcs_state.c
index 98fa4f2..d970ac9 100644
--- a/drivers/scsi/ofc/libfc/fcs_state.c
+++ b/drivers/scsi/ofc/libfc/fcs_state.c
@@ -19,7 +19,7 @@
 
 #include "sa_kernel.h"
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "fc_types.h"
 #include "fc_frame.h"
 #include "fc_port.h"
@@ -108,11 +108,11 @@ struct fcs_state *fcs_create(struct fcs_create_args *ap)
 	outer_port = ap->fca_port;
 	mfs = fc_port_get_max_frame_size(outer_port);
 	if (mfs < FC_MIN_MAX_PAYLOAD) {
-		SA_LOG("port max frame size only %d (0x%x) bytes - "
+		OFC_DBG("port max frame size only %d (0x%x) bytes - "
 		       "setting to %d", mfs, mfs, FC_MIN_MAX_PAYLOAD);
 		mfs = 1024;
 	} else if (mfs > FC_MAX_PAYLOAD + sizeof(struct fc_frame_header)) {
-		SA_LOG("port max frame size too large: %d (0x%x) bytes\n",
+		OFC_DBG("port max frame size too large: %d (0x%x) bytes\n",
 		       mfs, mfs);
 		mfs = FC_MAX_PAYLOAD + sizeof(struct fc_frame_header);
 	}
@@ -182,7 +182,7 @@ void fcs_recv(struct fcs_state *sp, struct fc_frame *fp)
 		fp->fr_in_port = sp->fs_inner_port;
 		fc_local_port_recv(sp->fs_local_port, fp);
 	} else {
-		SA_LOG("fcs_local_port_set needed before receiving");
+		OFC_DBG("fcs_local_port_set needed before receiving");
 		fc_frame_free(fp);
 	}
 }
@@ -278,7 +278,7 @@ static void fcs_local_port_event(int event, void *fcs_arg)
 			rc = fc_disc_targ_start(lp, FC_TYPE_FCP,
 						fcs_add_remote, sp);
 			if (rc != 0)
-				SA_LOG("target discovery start error %d", rc);
+				OFC_DBG("target discovery start error %d", rc);
 		} else {
 			(*sp->fs_args.fca_disc_done) (sp->fs_args.fca_cb_arg);
 		}
@@ -290,7 +290,7 @@ static void fcs_local_port_event(int event, void *fcs_arg)
 		fcs_ev_add(sp, OFC_EV_PT_OFFLINE, NULL, 0);
 		break;
 	default:
-		SA_LOG("unexpected event %d\n", event);
+		OFC_DBG("unexpected event %d\n", event);
 		break;
 	}
 }
@@ -306,13 +306,13 @@ static int fcs_local_port_prli_accept(struct fc_local_port *lp,
 
 	rp->rp_local_fcp_parm = sp->fs_args.fca_service_params;
 	if (fcs_debug)
-		SA_LOG("PRLI callback. remote %6x local %6x",
+		OFC_DBG("PRLI callback. remote %6x local %6x",
 		       rp->rp_fid, fc_local_port_get_fid(lp));
 	if (sp->fs_args.fca_prli_accept)
 		reject = (*sp->fs_args.fca_prli_accept) (sp->fs_args.fca_cb_arg,
 							 rp);
 	if (fcs_debug)
-		SA_LOG("%s remote fid %6x",
+		OFC_DBG("%s remote fid %6x",
 		       reject ? "reject" : "accept", rp->rp_fid);
 	return reject;
 }
@@ -341,7 +341,7 @@ static void fcs_add_remote(void *fcs_arg, struct fc_remote_port *rp,
 	if (event == FC_EV_CLOSED) {
 		ASSERT(rp->rp_sess_ready == 0);
 		if (fcs_debug)
-			SA_LOG("removing remote fid %x wwpn %llx ref %d",
+			OFC_DBG("removing remote fid %x wwpn %llx ref %d",
 			       rp->rp_fid, rp->rp_port_wwn,
 			       atomic_read(&rp->rp_refcnt));
 		fcs_ev_add(sp, OFC_EV_TARG_REMOVED,
@@ -354,7 +354,7 @@ static void fcs_add_remote(void *fcs_arg, struct fc_remote_port *rp,
 		rp->rp_fcs_priv = sp;
 		if (event == FC_EV_START) {
 			if (fcs_debug)
-				SA_LOG("new remote fid %x wwpn %llx",
+				OFC_DBG("new remote fid %x wwpn %llx",
 				       rp->rp_fid, rp->rp_port_wwn);
 			sess = rp->rp_sess;
 			if (sess) {
@@ -363,12 +363,12 @@ static void fcs_add_remote(void *fcs_arg, struct fc_remote_port *rp,
 				fc_sess_start(sess);
 			}
 		} else if (fcs_debug) {
-			SA_LOG("old remote fid %x wwpn %llx", rp->rp_fid,
+			OFC_DBG("old remote fid %x wwpn %llx", rp->rp_fid,
 			       rp->rp_port_wwn);
 		}
 	} else {
 		if (fcs_debug)
-			SA_LOG("discovery complete");
+			OFC_DBG("discovery complete");
 		if (!sp->fs_disc_done)
 			(*sp->fs_args.fca_disc_done) (sp->fs_args.fca_cb_arg);
 		sp->fs_disc_done = 1;
@@ -393,19 +393,19 @@ static void fcs_sess_event(int event, void *rp_arg)
 	case FC_EV_READY:
 		rp->rp_sess_ready = 1;
 		if (fcs_debug)
-			SA_LOG("remote %6x ready", rp->rp_fid);
+			OFC_DBG("remote %6x ready", rp->rp_fid);
 		(*sp->fs_args.fca_remote_port_state_change) (arg, rp);
 		fcs_ev_add(sp, OFC_EV_TARG_ONLINE,
 			   &rp->rp_port_wwn, sizeof(rp->rp_port_wwn));
 		break;
 	case FC_EV_RJT:	/* retries exhausted */
 		if (fcs_debug)
-			SA_LOG("remote %6x error", rp->rp_fid);
+			OFC_DBG("remote %6x error", rp->rp_fid);
 		break;
 	case FC_EV_CLOSED:
 		rp->rp_sess_ready = 0;
 		if (fcs_debug)
-			SA_LOG("remote %6x closed", rp->rp_fid);
+			OFC_DBG("remote %6x closed", rp->rp_fid);
 		(*sp->fs_args.fca_remote_port_state_change) (arg, rp);
 		fcs_ev_add(sp, OFC_EV_TARG_OFFLINE,
 			   &rp->rp_port_wwn, sizeof(rp->rp_port_wwn));
diff --git a/drivers/scsi/ofc/libsa/Makefile b/drivers/scsi/ofc/libsa/Makefile
index 90b5a25..1431906 100644
--- a/drivers/scsi/ofc/libsa/Makefile
+++ b/drivers/scsi/ofc/libsa/Makefile
@@ -9,6 +9,5 @@ libsa-y := \
 	sa_cons_linux.o \
 	sa_event.o \
 	sa_hash_kern.o \
-	sa_log.o \
 	sa_state.o \
 	sa_timer.o
diff --git a/drivers/scsi/ofc/libsa/sa_assert.c b/drivers/scsi/ofc/libsa/sa_assert.c
index 2e05946..0824bb6 100644
--- a/drivers/scsi/ofc/libsa/sa_assert.c
+++ b/drivers/scsi/ofc/libsa/sa_assert.c
@@ -24,14 +24,14 @@
 
 #include "sa_kernel.h"
 
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_assert.h"
 
 /*
  * Size of on-stack line buffers.
  * These shouldn't be to large for a kernel stack frame.
  */
-#define SA_LOG_BUF_LEN  200	/* on-stack line buffer size */
+#define OFC_DBG_BUF_LEN  200	/* on-stack line buffer size */
 
 /*
  * Assert failures.
@@ -39,12 +39,12 @@
 void assert_failed(const char *format, ...)
 {
 	va_list arg;
-	char buf[SA_LOG_BUF_LEN];
+	char buf[OFC_DBG_BUF_LEN];
 
 	va_start(arg, format);
 	vsnprintf(buf, sizeof(buf), format, arg);
 	va_end(arg);
-	sa_log_abort(buf);
+	panic(buf);
 }
 
 EXPORT_SYMBOL(assert_failed);
diff --git a/drivers/scsi/ofc/libsa/sa_cons_linux.c b/drivers/scsi/ofc/libsa/sa_cons_linux.c
index 6825e34..037866b 100644
--- a/drivers/scsi/ofc/libsa/sa_cons_linux.c
+++ b/drivers/scsi/ofc/libsa/sa_cons_linux.c
@@ -19,7 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include "sa_log.h"
+#include "ofc_dbg.h"
 
 void sa_log_output(const char *buf)
 {
diff --git a/drivers/scsi/ofc/libsa/sa_event.c b/drivers/scsi/ofc/libsa/sa_event.c
index d2aeb52..cf6596a 100644
--- a/drivers/scsi/ofc/libsa/sa_event.c
+++ b/drivers/scsi/ofc/libsa/sa_event.c
@@ -19,7 +19,7 @@
 
 #include "sa_kernel.h"
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_event.h"
 #include "queue.h"
 
diff --git a/drivers/scsi/ofc/libsa/sa_hash_kern.c b/drivers/scsi/ofc/libsa/sa_hash_kern.c
index 249ac1e..6046758 100644
--- a/drivers/scsi/ofc/libsa/sa_hash_kern.c
+++ b/drivers/scsi/ofc/libsa/sa_hash_kern.c
@@ -19,7 +19,7 @@
 
 #include "sa_kernel.h"
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_hash.h"
 
 struct sa_hash {
@@ -143,6 +143,6 @@ sa_hash_iterate(struct sa_hash *hp,
 		}
 	}
 	if (count != hp->sh_entries)
-		SA_LOG("sh_entries %d != count %d", hp->sh_entries, count);
+		OFC_DBG("sh_entries %d != count %d", hp->sh_entries, count);
 	ASSERT(count == hp->sh_entries);
 }
diff --git a/drivers/scsi/ofc/libsa/sa_log.c b/drivers/scsi/ofc/libsa/sa_log.c
index ddd9e58..a3e26cb 100644
--- a/drivers/scsi/ofc/libsa/sa_log.c
+++ b/drivers/scsi/ofc/libsa/sa_log.c
@@ -23,13 +23,13 @@
 #include <linux/string.h>
 
 #include "sa_kernel.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 
 /*
  * Size of on-stack line buffers.
  * These shouldn't be to large for a kernel stack frame.
  */
-#define SA_LOG_BUF_LEN  200	/* on-stack line buffer size */
+#define OFC_DBG_BUF_LEN  200	/* on-stack line buffer size */
 
 /*
  * log with a variable argument list.
@@ -39,7 +39,7 @@ static void sa_log_va(const char *func, const char *format, va_list arg)
 	size_t len;
 	size_t flen;
 	int add_newline;
-	char sa_buf[SA_LOG_BUF_LEN];
+	char sa_buf[OFC_DBG_BUF_LEN];
 	char *bp;
 
 	/*
@@ -102,7 +102,7 @@ static char *strerror_r(int err, char *buf, size_t len)
 void sa_log_err(int error, const char *func, const char *format, ...)
 {
 	va_list arg;
-	char buf[SA_LOG_BUF_LEN];
+	char buf[OFC_DBG_BUF_LEN];
 
 	if (func) {
 		sa_log("%s: error %d %s", func, error,
diff --git a/drivers/scsi/ofc/libsa/sa_state.c b/drivers/scsi/ofc/libsa/sa_state.c
index 047799a..732d26d 100644
--- a/drivers/scsi/ofc/libsa/sa_state.c
+++ b/drivers/scsi/ofc/libsa/sa_state.c
@@ -19,7 +19,7 @@
 
 #include "sa_kernel.h"
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_state.h"
 
 /*
@@ -112,7 +112,7 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 		switch (dp->sd_type) {
 		case SST_STATE:
 			if (dp->sd_in == 0) {
-				SA_LOG("state table %s has invalid state %d "
+				OFC_DBG("state table %s has invalid state %d "
 				       "at STATE entry %d",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
@@ -123,7 +123,7 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 			break;
 		case SST_FROM:
 			if (dp->sd_in == 0) {
-				SA_LOG("state table %s has invalid state %d "
+				OFC_DBG("state table %s has invalid state %d "
 				       "at FROM entry %d",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
@@ -132,7 +132,7 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 			break;
 		case SST_EVENT:
 			if (dp->sd_in == 0) {
-				SA_LOG("state table %s has invalid event %d "
+				OFC_DBG("state table %s has invalid event %d "
 				       "at EVENT entry %d",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
@@ -142,7 +142,7 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 			break;
 		case SST_HANDLER:
 			if (dp->sd_ptr == NULL) {
-				SA_LOG("state table %s has invalid hander %d "
+				OFC_DBG("state table %s has invalid hander %d "
 				       "at HANDLER entry %d",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
@@ -152,19 +152,19 @@ struct sa_state_table *sa_state_table_alloc(const char *name,
 			break;
 		case SST_NEXT:
 			if (cur_state == 0) {
-				SA_LOG("state table %s has no current state "
+				OFC_DBG("state table %s has no current state "
 				       "for NEXT entry %d",
 				       name, dp - state_desc);
 				error++;
 			}
 			if (dp->sd_in >= event_limit) {
-				SA_LOG("state table %s has event %d "
+				OFC_DBG("state table %s has event %d "
 				       "out of range at NEXT entry %d",
 				       name, dp->sd_in, dp - state_desc);
 				error++;
 			}
 			if (dp->sd_next == 0 || dp->sd_next >= state_limit) {
-				SA_LOG("state table %s has state %d "
+				OFC_DBG("state table %s has state %d "
 				       "out of range at NEXT entry %d",
 				       name, dp->sd_next, dp - state_desc);
 				error++;
@@ -313,7 +313,7 @@ sa_state_table_step(struct sa_state_table *tp, void *statep_arg,
 	} else if (next != 0) {
 		sa_state_table_enter(tp, statep, next, event, arg);
 	} else {
-		SA_LOG("state_table %s state %s (%d) "
+		OFC_DBG("state_table %s state %s (%d) "
 		       "event %s (%d) has no handler",
 		       tp->st_name, tp->st_states[old_state].st_name,
 		       old_state, tp->st_event_name[event], event);
diff --git a/drivers/scsi/ofc/libsa/sa_timer.c b/drivers/scsi/ofc/libsa/sa_timer.c
index 35a45ab..0e3d422 100644
--- a/drivers/scsi/ofc/libsa/sa_timer.c
+++ b/drivers/scsi/ofc/libsa/sa_timer.c
@@ -23,7 +23,7 @@
 #include <linux/jiffies.h>
 
 #include "sa_assert.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "sa_timer.h"
 
 /*
diff --git a/drivers/scsi/ofc/openfc/openfc_attr.c b/drivers/scsi/ofc/openfc/openfc_attr.c
index 28186e0..12b00c3 100644
--- a/drivers/scsi/ofc/openfc/openfc_attr.c
+++ b/drivers/scsi/ofc/openfc/openfc_attr.c
@@ -39,7 +39,7 @@
 #include "fcdev.h"
 #include "fcoeioctl.h"
 #include "fc_frame.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "openfc.h"
 #include "openfc_scsi_pkt.h"
 #include "fcs_state.h"
diff --git a/drivers/scsi/ofc/openfc/openfc_if.c b/drivers/scsi/ofc/openfc/openfc_if.c
index 6f9a276..8725845 100644
--- a/drivers/scsi/ofc/openfc/openfc_if.c
+++ b/drivers/scsi/ofc/openfc/openfc_if.c
@@ -40,7 +40,7 @@
 #include "fc_remote_port.h"
 #include "fcdev.h"
 #include "fc_frame.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "openfc.h"
 #include "openfc_scsi_pkt.h"
 #include "fcs_state.h"
@@ -147,7 +147,7 @@ void openfc_io_compl(struct fc_scsi_pkt *sp)
 	openfcp = sp->openfcp;
 
 	if (openfcp == NULL) {
-		SA_LOG("error could not find openfc hba softc");
+		OFC_DBG("error could not find openfc hba softc");
 		return;
 	}
 	if (timer_pending(&sp->timer))
@@ -156,7 +156,7 @@ void openfc_io_compl(struct fc_scsi_pkt *sp)
 	sc_cmd = sp->cmd;
 
 	if (sc_cmd == NULL) {
-		SA_LOG("command already returned back to OS");
+		OFC_DBG("command already returned back to OS");
 		return;
 	}
 	sp->cmd = NULL;
@@ -500,7 +500,7 @@ static int openfc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 
 		sp = openfc_alloc_scsi_pkt(openfcp);
 		if (sp == NULL) {
-			SA_LOG("could not allocate scsi_pkt");
+			OFC_DBG("could not allocate scsi_pkt");
 			sc_cmd->result = DID_NO_CONNECT << 16;
 			goto out;
 		}
@@ -548,7 +548,7 @@ int openfc_reset_if(struct openfc_softc *openfcp)
 	int rval;
 
 	if (atomic_read(&openfcp->fcs_status) != OPENFC_FCS_ONLINE) {
-		SA_LOG("FCS Offline can not reset");
+		OFC_DBG("FCS Offline can not reset");
 		goto out1;
 	}
 	if (openfcp->state != OPENFC_RUNNING)
@@ -558,7 +558,7 @@ int openfc_reset_if(struct openfc_softc *openfcp)
 	fcs_reset(openfcp->fcs_state);
 	sp = openfc_alloc_scsi_pkt(openfcp);
 	if (sp == NULL) {
-		SA_LOG("could not allocate scsi_pkt");
+		OFC_DBG("could not allocate scsi_pkt");
 		goto out1;
 	}
 	/*
@@ -620,7 +620,7 @@ static int openfc_slave_alloc(struct scsi_device *sdev)
 	tgtp = rport->dd_data;
 	disk = kzalloc(sizeof(struct os_lun), GFP_KERNEL);
 	if (!disk) {
-		SA_LOG("could not allocate lun structure");
+		OFC_DBG("could not allocate lun structure");
 		return -ENOMEM;
 	}
 	disk->lun_number = sdev->lun;
@@ -708,7 +708,7 @@ static void openfc_remote_port_state_change(void *arg,
 		rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
 		rport = fc_remote_port_add(openfcp->host, 0, &rport_ids);
 		if (!rport) {
-			SA_LOG("fc_remote_port_add failed");
+			OFC_DBG("fc_remote_port_add failed");
 			return;
 		}
 		/*
@@ -852,7 +852,7 @@ struct fcdev *openfc_alloc_dev(struct openfc_port_operations *fctt,
 	host = scsi_host_alloc(&openfc_driver_template,
 			       sizeof(struct openfc_softc) + privsize);
 	if (host == NULL) {
-		SA_LOG("openfc: Could not allocate host structure\n");
+		OFC_DBG("openfc: Could not allocate host structure\n");
 		return NULL;
 	}
 	openfcp = (struct openfc_softc *)host->hostdata;
@@ -906,7 +906,7 @@ struct fcdev *openfc_alloc_dev(struct openfc_port_operations *fctt,
 	 * create slab for pkt buffer
 	 */
 	if (openfc_create_scsi_slab(openfcp) < 0) {
-		SA_LOG("scsi pkt slab create failed");
+		OFC_DBG("scsi pkt slab create failed");
 		scsi_host_put(host);
 		return NULL;
 	}
@@ -950,7 +950,7 @@ int openfc_register(struct fcdev *dev)
 	 */
 	rc = scsi_add_host(openfcp->host, NULL);
 	if (rc) {
-		SA_LOG("error on scsi_add_host\n");
+		OFC_DBG("error on scsi_add_host\n");
 		goto out_host_put;
 	}
 
@@ -977,7 +977,7 @@ int openfc_register(struct fcdev *dev)
 	openfcp->status = OPENFC_LINK_UP;
 	port = fc_port_alloc();
 	if (!port) {
-		SA_LOG("Could not create fc_port structure");
+		OFC_DBG("Could not create fc_port structure");
 		goto out_host_rem;
 	}
 	openfcp->fcs_port = port;
@@ -1002,7 +1002,7 @@ int openfc_register(struct fcdev *dev)
 	ofc_fcs_args.fca_cb_arg = (void *)openfcp;
 	openfcp->fcs_state = fcs_create(&ofc_fcs_args);
 	if (openfcp->fcs_state == NULL) {
-		SA_LOG("Could not create fcs_state structure");
+		OFC_DBG("Could not create fcs_state structure");
 		fc_port_close_ingress(port);
 		goto out_host_rem;
 	}
@@ -1034,7 +1034,7 @@ int openfc_register(struct fcdev *dev)
 	snprintf(cp->class_id, sizeof(cp->class_id), "host%d", host->host_no);
 	rc = class_device_add(cp);
 	if (rc) {
-		SA_LOG("class_device_add failed rc %d", rc);
+		OFC_DBG("class_device_add failed rc %d", rc);
 		goto out_fcs;
 	}
 	if (dev->fd_link_status == TRANS_LINK_DOWN) {
@@ -1223,7 +1223,7 @@ static int __init openfc_init(void)
 	    fc_attach_transport(&openfc_transport_function);
 
 	if (openfc_transport_template == NULL) {
-		SA_LOG("fail to attach fc transport");
+		OFC_DBG("fail to attach fc transport");
 		return -1;
 	}
 	openfc_ioctl_init();
diff --git a/drivers/scsi/ofc/openfc/openfc_ioctl.c b/drivers/scsi/ofc/openfc/openfc_ioctl.c
index ababb58..d04164b 100644
--- a/drivers/scsi/ofc/openfc/openfc_ioctl.c
+++ b/drivers/scsi/ofc/openfc/openfc_ioctl.c
@@ -36,7 +36,7 @@
 #include "fcdev.h"
 #include "openfc.h"
 #include "openfc_ioctl.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "fcs_state.h"
 #include "fc_fs.h"
 #include "fc_gs.h"
@@ -523,11 +523,11 @@ int openfc_ioctl_init(void)
 	 */
 	openfc_major = openfc_reg_char_dev();
 	if (openfc_major < 0) {
-		SA_LOG("failed to register the control device\n");
+		OFC_DBG("failed to register the control device\n");
 		rc = -ENODEV;
 		goto out;
 	}
-	SA_LOG("Control device /dev/ofc major number %d\n", openfc_major);
+	OFC_DBG("Control device /dev/ofc major number %d\n", openfc_major);
 
 	openfc_class = class_create(THIS_MODULE, OPENFC_CLASS_NAME);
 	if (IS_ERR(openfc_class)) {
diff --git a/drivers/scsi/ofc/openfc/openfc_pkt.c b/drivers/scsi/ofc/openfc/openfc_pkt.c
index 215522c..baaa77f 100644
--- a/drivers/scsi/ofc/openfc/openfc_pkt.c
+++ b/drivers/scsi/ofc/openfc/openfc_pkt.c
@@ -43,7 +43,7 @@
 #include "fc_exch.h"
 #include "fc_sess.h"
 #include "fc_event.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #ifdef FCOE_TARGET_MODE
 #include "openfc_scst_pkt.h"
 #else
@@ -101,7 +101,7 @@ int openfc_free_scsi_pkt(struct fc_scsi_pkt *sp)
 		if (sp->state == OPENFC_SRB_FREE) {
 			kmem_cache_free(openfcp->openfc_scsi_pkt_cachep, sp);
 		} else {
-			SA_LOG("freeing scsi_pkt not marked free\n");
+			OFC_DBG("freeing scsi_pkt not marked free\n");
 		}
 	}
 	return 0;
@@ -151,7 +151,7 @@ int openfc_create_scsi_slab(struct openfc_softc *openfcp)
 			      NULL, NULL);
 #endif
 	if (openfcp->openfc_scsi_pkt_cachep == NULL) {
-		SA_LOG("Unable to allocate SRB cache...module load failed!");
+		OFC_DBG("Unable to allocate SRB cache...module load failed!");
 		return -ENOMEM;
 	}
 	return 0;
diff --git a/drivers/scsi/ofc/openfc/openfc_scsi.c b/drivers/scsi/ofc/openfc/openfc_scsi.c
index ecc5f9f..76b8d1d 100644
--- a/drivers/scsi/ofc/openfc/openfc_scsi.c
+++ b/drivers/scsi/ofc/openfc/openfc_scsi.c
@@ -45,7 +45,7 @@
 #include "fc_exch.h"
 #include "fc_sess.h"
 #include "fc_event.h"
-#include "sa_log.h"
+#include "ofc_dbg.h"
 #include "openfc.h"
 #include "openfc_scsi_pkt.h"
 #include "crc32_le.h"
@@ -121,7 +121,7 @@ static void openfc_scsi_recv_data(struct fc_scsi_pkt *fsp, struct fc_frame *fp)
 		    fc_frame_crc_check(fp))
 			goto crc_err;
 		if (openfc_debug) {
-			SA_LOG("data received past end.	 "
+			OFC_DBG("data received past end.	 "
 			       "len %zx offset %zx "
 			       "data_len %zx\n", len, offset, fsp->data_len);
 		}
@@ -200,7 +200,7 @@ crc_err:
 			sp = openfcp->fd.dev_stats[smp_processor_id()];
 			sp->ErrorFrames++;
 			if (sp->InvalidCRCCount++ < 5)
-				SA_LOG("CRC error on data frame");
+				OFC_DBG("CRC error on data frame");
 			/*
 			 * Assume the frame is total garbage.
 			 * We may have copied it over the good part
@@ -251,7 +251,7 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 		 * this should not never happen
 		 */
 		if (openfc_debug) {
-			SA_LOG("xfer-ready past end. len %zx offset %zx\n",
+			OFC_DBG("xfer-ready past end. len %zx offset %zx\n",
 			       len, offset);
 		}
 		openfcp->outstandingcmd[fsp->idx].ptr = NULL;
@@ -263,7 +263,7 @@ static void openfc_scsi_send_data(struct fc_scsi_pkt *fsp, struct fc_seq *sp,
 		 * and send an error notification to SCSI
 		 */
 		if (openfc_debug) {
-			SA_LOG("xfer-ready non-contiguous. "
+			OFC_DBG("xfer-ready non-contiguous. "
 			       "len %zx offset %zx\n", len, offset);
 		}
 	}
@@ -511,7 +511,7 @@ static void openfc_scsi_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 						fsp->io_status =
 						    (SUGGEST_RETRY << 24);
 					} else {
-						SA_LOG("xfer len less then "
+						OFC_DBG("xfer len less then "
 						       "data_len xfer-len %zx"
 						       " len %zx \n",
 						       fsp->xfer_len,
@@ -528,7 +528,7 @@ static void openfc_scsi_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 						fsp->io_status =
 						    (SUGGEST_RETRY << 24);
 					} else {
-						SA_LOG("xfer len greater than "
+						OFC_DBG("xfer len greater than "
 						       "data_len xfer-len %zx"
 						       " len %zx \n",
 						       fsp->xfer_len,
@@ -647,7 +647,7 @@ int openfc_scsi_send(struct fcdev *dev, struct fc_scsi_pkt *fsp)
 		}
 	}
 	if (idx == OPENFC_MAX_OUTSTANDING_COMMANDS) {
-		SA_LOG("outstanding cmd array is full");
+		OFC_DBG("outstanding cmd array is full");
 		spin_unlock_irqrestore(&openfcp->outstandingcmd_lock, flags);
 
 		/*
@@ -690,7 +690,7 @@ int openfc_scsi_send(struct fcdev *dev, struct fc_scsi_pkt *fsp)
 					FC_TYPE_FCP, 0);
 		} else {
 			openfcp->outstandingcmd[i].ptr = (void *)NULL;
-			SA_LOG("could not allocate frame");
+			OFC_DBG("could not allocate frame");
 			fc_seq_exch_complete(sp);
 			rc = -1;
 			goto out;
@@ -732,7 +732,7 @@ static void openfc_scsi_error(enum fc_event event, void *fsp_arg)
 		 * not sure about this case
 		 * But if we get here then abort the I/O
 		 */
-		SA_LOG(" exchange level timeout error");
+		OFC_DBG(" exchange level timeout error");
 		if (fsp->state == OPENFC_SRB_REC) {
 			ofsp = fsp->old_pkt;
 			diskp->tgtp->flags &= OPENFC_TGT_REC_NOT_SUPPORTED;
@@ -764,7 +764,7 @@ static void openfc_scsi_error(enum fc_event event, void *fsp_arg)
 		 * if we received this we may want to
 		 * cleanup the fc_transport --XXX
 		 */
-		SA_LOG(" FC level close error");
+		OFC_DBG(" FC level close error");
 		if (fsp->done) {
 			fsp->status_code = OPENFC_CMD_PLOGO;
 			(*fsp->done) (fsp);
@@ -774,7 +774,7 @@ static void openfc_scsi_error(enum fc_event event, void *fsp_arg)
 		/*
 		 * this is abort accepted case
 		 */
-		SA_LOG(" BLS Acc event");
+		OFC_DBG(" BLS Acc event");
 		if (fsp->state == OPENFC_SRB_ABORT_PENDING) {
 			fsp->state = OPENFC_SRB_ABORTED;
 			if (fsp->wait_for_comp)
@@ -786,7 +786,7 @@ static void openfc_scsi_error(enum fc_event event, void *fsp_arg)
 		/*
 		 * this is abort rejected case
 		 */
-		SA_LOG(" BLS reject event");
+		OFC_DBG(" BLS reject event");
 		if (fsp->state == OPENFC_SRB_ABORT_PENDING) {
 			if (fsp->wait_for_comp)
 				complete(&fsp->tm_done);
@@ -802,7 +802,7 @@ static void openfc_scsi_error(enum fc_event event, void *fsp_arg)
 		}
 		break;
 	default:
-		SA_LOG(" unknown event");
+		OFC_DBG(" unknown event");
 		if (fsp->done) {
 			fsp->status_code = OPENFC_CMD_PLOGO;
 			(*fsp->done) (fsp);
@@ -850,10 +850,10 @@ int openfc_abort_cmd(struct fcdev *dev, struct fc_scsi_pkt *fsp)
 	fsp->wait_for_comp = 1;
 	if (!wait_for_completion_timeout(&fsp->tm_done,
 					 msecs_to_jiffies(FCOE_TM_TIMEOUT))) {
-		SA_LOG("target abort cmd  failed");
+		OFC_DBG("target abort cmd  failed");
 		rc = FAILED;
 	} else if (fsp->state == OPENFC_SRB_ABORTED) {
-		SA_LOG("target abort cmd  passed");
+		OFC_DBG("target abort cmd  passed");
 		rc = SUCCESS;
 	}
 	if (fsp->seq_ptr) {
@@ -888,7 +888,7 @@ int openfc_target_reset(struct fcdev *dev, struct fc_scsi_pkt *fsp)
 		fc_seq_hold(sp);
 		fp = fc_frame_alloc(openfcp->fcs_port, sizeof(fsp->cdb_cmd));
 		if (fp == NULL) {
-			SA_LOG("could not allocate frame");
+			OFC_DBG("could not allocate frame");
 			fc_seq_exch_complete(sp);
 			return FAILED;
 		}
@@ -906,7 +906,7 @@ int openfc_target_reset(struct fcdev *dev, struct fc_scsi_pkt *fsp)
 						 msecs_to_jiffies
 						 (FCOE_TM_TIMEOUT))) {
 			fc_seq_exch_complete(sp);
-			SA_LOG("target reset failed");
+			OFC_DBG("target reset failed");
 			return FAILED;
 		}
 	}
@@ -928,7 +928,7 @@ int openfc_target_reset(struct fcdev *dev, struct fc_scsi_pkt *fsp)
 			 */
 			if (!ofsp->cmd) {
 				openfcp->outstandingcmd[idx].ptr = NULL;
-				SA_LOG("non scsi cmd in the array %d idx\n",
+				OFC_DBG("non scsi cmd in the array %d idx\n",
 				       idx);
 				goto out;
 			}
@@ -1235,7 +1235,7 @@ void openfc_scsi_rec_rcv(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 			openfc_timeout_error(ofsp);
 			break;
 		case ELS_RJT_UNSUP:
-			SA_LOG("device does not support REC\n");
+			OFC_DBG("device does not support REC\n");
 		default:
 			disk = ofsp->disk;
 			disk->tgtp->flags &= OPENFC_TGT_REC_NOT_SUPPORTED;

