From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/17] fcoe: runtime debugging with debug_logging module
	parameter
Date: Fri, 06 Feb 2009 10:56:27 -0800
Message-ID: <20090206185626.26188.52021.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37653 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbZBFS41 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:56:27 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

This patch adds runtime debugging so that the user
can echo into /sys/module/fcoe/parameters/debug_logging
to enable or disable debug logging for fcoe.

Currently only on(non-zero)/off(zero) is supported by
this parameter.

This patch adds the drivers/scsi/fcoe/fcoe.h file for
shared fcoe defines. Currently only the logging code
is there, but later it may be used for other common
code.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.h    |   31 ++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_sw.c |   16 ++++++++------
 drivers/scsi/fcoe/libfcoe.c |   48 +++++++++++++++++++++----------------------
 3 files changed, 63 insertions(+), 32 deletions(-)
 create mode 100644 drivers/scsi/fcoe/fcoe.h

diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
new file mode 100644
index 0000000..d15355f
--- /dev/null
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright(c) 2009 Intel Corporation. All rights reserved.
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
+#ifndef _FCOE_H_
+#define _FCOE_H_
+
+extern unsigned int debug_logging;
+
+#define FCOE_DBG(fmt, args...)				       \
+do {							       \
+	if (unlikely(debug_logging))			       \
+		printk(KERN_INFO "%s " fmt, __func__, ##args); \
+} while (0)
+
+#endif /* _FCOE_H_ */
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index cf83675..e861c36 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -38,6 +38,8 @@
 #include <scsi/libfcoe.h>
 #include <scsi/fc_transport_fcoe.h>
 
+#include "fcoe.h"
+
 #define FCOE_SW_VERSION	"0.1"
 #define	FCOE_SW_NAME	"fcoesw"
 #define	FCOE_SW_VENDOR	"Open-FCoE.org"
@@ -251,7 +253,7 @@ static int fcoe_sw_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
 	/* add the new host to the SCSI-ml */
 	rc = scsi_add_host(lp->host, dev);
 	if (rc) {
-		FC_DBG("fcoe_sw_shost_config:error on scsi_add_host\n");
+		FCOE_DBG("fcoe_sw_shost_config:error on scsi_add_host\n");
 		return rc;
 	}
 	sprintf(fc_host_symbolic_name(lp->host), "%s v%s over %s",
@@ -381,7 +383,7 @@ static int fcoe_sw_create(struct net_device *netdev)
 	shost = fcoe_host_alloc(&fcoe_sw_shost_template,
 				sizeof(struct fcoe_softc));
 	if (!shost) {
-		FC_DBG("Could not allocate host structure\n");
+		FCOE_DBG("Could not allocate host structure\n");
 		return -ENOMEM;
 	}
 	lp = shost_priv(shost);
@@ -390,35 +392,35 @@ static int fcoe_sw_create(struct net_device *netdev)
 	/* configure fc_lport, e.g., em */
 	rc = fcoe_sw_lport_config(lp);
 	if (rc) {
-		FC_DBG("Could not configure lport\n");
+		FCOE_DBG("Could not configure lport\n");
 		goto out_host_put;
 	}
 
 	/* configure lport network properties */
 	rc = fcoe_sw_netdev_config(lp, netdev);
 	if (rc) {
-		FC_DBG("Could not configure netdev for lport\n");
+		FCOE_DBG("Could not configure netdev for lport\n");
 		goto out_host_put;
 	}
 
 	/* configure lport scsi host properties */
 	rc = fcoe_sw_shost_config(lp, shost, &netdev->dev);
 	if (rc) {
-		FC_DBG("Could not configure shost for lport\n");
+		FCOE_DBG("Could not configure shost for lport\n");
 		goto out_host_put;
 	}
 
 	/* lport exch manager allocation */
 	rc = fcoe_sw_em_config(lp);
 	if (rc) {
-		FC_DBG("Could not configure em for lport\n");
+		FCOE_DBG("Could not configure em for lport\n");
 		goto out_host_put;
 	}
 
 	/* Initialize the library */
 	rc = fcoe_libfc_config(lp, &fcoe_sw_libfc_fcn_templ);
 	if (rc) {
-		FC_DBG("Could not configure libfc for lport!\n");
+		FCOE_DBG("Could not configure libfc for lport!\n");
 		goto out_lp_destroy;
 	}
 
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 2960710..594295b 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -46,7 +46,7 @@
 #include <scsi/libfcoe.h>
 #include <scsi/fc_transport_fcoe.h>
 
-static int debug_fcoe;
+#include "fcoe.h"
 
 #define FCOE_MAX_QUEUE_DEPTH  256
 
@@ -60,13 +60,16 @@ MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("FCoE");
 MODULE_LICENSE("GPL");
 
+unsigned int debug_logging;
+module_param(debug_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
+
 /* fcoe host list */
 LIST_HEAD(fcoe_hostlist);
 DEFINE_RWLOCK(fcoe_hostlist_lock);
 DEFINE_TIMER(fcoe_timer, NULL, 0, 0);
 struct fcoe_percpu_s *fcoe_percpu[NR_CPUS];
 
-
 /* Function Prototyes */
 static int fcoe_check_wait_queue(struct fc_lport *);
 static void fcoe_insert_wait_queue_head(struct fc_lport *, struct sk_buff *);
@@ -191,22 +194,19 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *dev,
 	fc = container_of(ptype, struct fcoe_softc, fcoe_packet_type);
 	lp = fc->lp;
 	if (unlikely(lp == NULL)) {
-		FC_DBG("cannot find hba structure");
+		FCOE_DBG("cannot find hba structure");
 		goto err2;
 	}
 
-	if (unlikely(debug_fcoe)) {
-		FC_DBG("skb_info: len:%d data_len:%d head:%p data:%p tail:%p "
-		       "end:%p sum:%d dev:%s", skb->len, skb->data_len,
-		       skb->head, skb->data, skb_tail_pointer(skb),
-		       skb_end_pointer(skb), skb->csum,
-		       skb->dev ? skb->dev->name : "<NULL>");
-
-	}
+	FCOE_DBG("skb_info: len:%d data_len:%d head:%p data:%p tail:%p "
+		 "end:%p sum:%d dev:%s", skb->len, skb->data_len,
+		 skb->head, skb->data, skb_tail_pointer(skb),
+		 skb_end_pointer(skb), skb->csum,
+		 skb->dev ? skb->dev->name : "<NULL>");
 
 	/* check for FCOE packet type */
 	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
-		FC_DBG("wrong FC type frame");
+		FCOE_DBG("wrong FC type frame");
 		goto err;
 	}
 
@@ -551,21 +551,19 @@ int fcoe_percpu_receive_thread(void *arg)
 		fr = fcoe_dev_from_skb(skb);
 		lp = fr->fr_dev;
 		if (unlikely(lp == NULL)) {
-			FC_DBG("invalid HBA Structure");
+			FCOE_DBG("invalid HBA Structure");
 			kfree_skb(skb);
 			continue;
 		}
 
 		stats = lp->dev_stats[smp_processor_id()];
 
-		if (unlikely(debug_fcoe)) {
-			FC_DBG("skb_info: len:%d data_len:%d head:%p data:%p "
-			       "tail:%p end:%p sum:%d dev:%s",
-			       skb->len, skb->data_len,
-			       skb->head, skb->data, skb_tail_pointer(skb),
-			       skb_end_pointer(skb), skb->csum,
-			       skb->dev ? skb->dev->name : "<NULL>");
-		}
+		FCOE_DBG("skb_info: len:%d data_len:%d head:%p data:%p "
+			 "tail:%p end:%p sum:%d dev:%s",
+			 skb->len, skb->data_len,
+			 skb->head, skb->data, skb_tail_pointer(skb),
+			 skb_end_pointer(skb), skb->csum,
+			 skb->dev ? skb->dev->name : "<NULL>");
 
 		/*
 		 * Save source MAC address before discarding header.
@@ -587,8 +585,8 @@ int fcoe_percpu_receive_thread(void *arg)
 		if (unlikely(FC_FCOE_DECAPS_VER(hp) != FC_FCOE_VER)) {
 			if (stats) {
 				if (stats->ErrorFrames < 5)
-					FC_DBG("unknown FCoE version %x",
-					       FC_FCOE_DECAPS_VER(hp));
+					FCOE_DBG("unknown FCoE version %x",
+						 FC_FCOE_DECAPS_VER(hp));
 				stats->ErrorFrames++;
 			}
 			kfree_skb(skb);
@@ -639,7 +637,7 @@ int fcoe_percpu_receive_thread(void *arg)
 		if (fr_flags(fp) & FCPHF_CRC_UNCHECKED) {
 			if (le32_to_cpu(fr_crc(fp)) !=
 			    ~crc32(~0, skb->data, fr_len)) {
-				if (debug_fcoe || stats->InvalidCRCCount < 5)
+				if (debug_logging || stats->InvalidCRCCount < 5)
 					printk(KERN_WARNING "fcoe: dropping "
 					       "frame with CRC error\n");
 				stats->InvalidCRCCount++;
@@ -908,7 +906,7 @@ static int fcoe_device_notification(struct notifier_block *notifier,
 	case NETDEV_REGISTER:
 		break;
 	default:
-		FC_DBG("unknown event %ld call", event);
+		FCOE_DBG("unknown event %ld call", event);
 	}
 	if (lp->link_up != new_link_up) {
 		if (new_link_up)

