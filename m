From: michaelc@cs.wisc.edu
Subject: [PATCH 4/7] cxgb3i - close all tcp connections upon chip reset
Date: Wed,  1 Apr 2009 13:11:26 -0500
Message-ID: <12386094913176-git-send-email-michaelc@cs.wisc.edu>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu>
 <12386094902138-git-send-email-michaelc@cs.wisc.edu>
 <12386094901595-git-send-email-michaelc@cs.wisc.edu>
 <123860949112-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41468 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933424AbZDASLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 14:11:43 -0400
In-Reply-To: <123860949112-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Xie <kxie@chelsio.com>

[PATCH 5/5 2.6.30] cxgb3i - close all tcp connections upon chip reset

From: Karen Xie <kxie@chelsio.com>

Keep track of offloaded tcp connections per adapter. Close all of the
connections upon reset.

Signed-off-by: Karen Xie <kxie@chelsio.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i_offload.c |  101 ++++++++++++++++++++++------------
 drivers/scsi/cxgb3i/cxgb3i_offload.h |   11 ++--
 2 files changed, 71 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index c2e434e..4d8654c 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -94,29 +94,30 @@ static int c3cn_get_port(struct s3_conn *c3cn, struct cxgb3i_sdev_data *cdata)
 	if (!cdata)
 		goto error_out;
 
-	if (c3cn->saddr.sin_port != 0) {
-		idx = ntohs(c3cn->saddr.sin_port) - cxgb3_sport_base;
-		if (idx < 0 || idx >= cxgb3_max_connect)
-			return 0;
-		if (!test_and_set_bit(idx, cdata->sport_map))
-			return -EADDRINUSE;
+	if (c3cn->saddr.sin_port) {
+		cxgb3i_log_error("connect, sin_port NON-ZERO %u.\n",
+				 c3cn->saddr.sin_port);
+		return -EADDRINUSE;
 	}
 
-	/* the sport_map_next may not be accurate but that is okay, sport_map
-	   should be */
-	start = idx = cdata->sport_map_next;
+	spin_lock_bh(&cdata->lock);
+	start = idx = cdata->sport_next;
 	do {
 		if (++idx >= cxgb3_max_connect)
 			idx = 0;
-		if (!(test_and_set_bit(idx, cdata->sport_map))) {
+		if (!cdata->sport_conn[idx]) {
 			c3cn->saddr.sin_port = htons(cxgb3_sport_base + idx);
-			cdata->sport_map_next = idx;
+			cdata->sport_next = idx;
+			cdata->sport_conn[idx] = c3cn;
+			spin_unlock_bh(&cdata->lock);
+
 			c3cn_conn_debug("%s reserve port %u.\n",
 					cdata->cdev->name,
 					cxgb3_sport_base + idx);
 			return 0;
 		}
 	} while (idx != start);
+	spin_unlock_bh(&cdata->lock);
 
 error_out:
 	return -EADDRNOTAVAIL;
@@ -124,15 +125,19 @@ error_out:
 
 static void c3cn_put_port(struct s3_conn *c3cn)
 {
-	struct cxgb3i_sdev_data *cdata = CXGB3_SDEV_DATA(c3cn->cdev);
+	if (!c3cn->cdev)
+		return;
 
 	if (c3cn->saddr.sin_port) {
+		struct cxgb3i_sdev_data *cdata = CXGB3_SDEV_DATA(c3cn->cdev);
 		int idx = ntohs(c3cn->saddr.sin_port) - cxgb3_sport_base;
 
 		c3cn->saddr.sin_port = 0;
 		if (idx < 0 || idx >= cxgb3_max_connect)
 			return;
-		clear_bit(idx, cdata->sport_map);
+		spin_lock_bh(&cdata->lock);
+		cdata->sport_conn[idx] = NULL;
+		spin_unlock_bh(&cdata->lock);
 		c3cn_conn_debug("%s, release port %u.\n",
 				cdata->cdev->name, cxgb3_sport_base + idx);
 	}
@@ -1305,11 +1310,7 @@ static void c3cn_release_offload_resources(struct s3_conn *c3cn)
 	struct t3cdev *cdev = c3cn->cdev;
 	unsigned int tid = c3cn->tid;
 
-	if (!cdev)
-		return;
-
 	c3cn->qset = 0;
-
 	c3cn_free_cpl_skbs(c3cn);
 
 	if (c3cn->wr_avail != c3cn->wr_max) {
@@ -1317,18 +1318,22 @@ static void c3cn_release_offload_resources(struct s3_conn *c3cn)
 		reset_wr_list(c3cn);
 	}
 
-	if (c3cn->l2t) {
-		l2t_release(L2DATA(cdev), c3cn->l2t);
-		c3cn->l2t = NULL;
-	}
-
-	if (c3cn->state == C3CN_STATE_CONNECTING) /* we have ATID */
-		s3_free_atid(cdev, tid);
-	else {		/* we have TID */
-		cxgb3_remove_tid(cdev, (void *)c3cn, tid);
-		c3cn_put(c3cn);
+	if (cdev) {
+		if (c3cn->l2t) {
+			l2t_release(L2DATA(cdev), c3cn->l2t);
+			c3cn->l2t = NULL;
+		}
+		if (c3cn->state == C3CN_STATE_CONNECTING)
+			/* we have ATID */
+			s3_free_atid(cdev, tid);
+		else {
+			/* we have TID */
+			cxgb3_remove_tid(cdev, (void *)c3cn, tid);
+			c3cn_put(c3cn);
+		}
 	}
 
+	c3cn->dst_cache = NULL;
 	c3cn->cdev = NULL;
 }
 
@@ -1417,17 +1422,18 @@ static void c3cn_active_close(struct s3_conn *c3cn)
 }
 
 /**
- * cxgb3i_c3cn_release - close and release an iscsi tcp connection
+ * cxgb3i_c3cn_release - close and release an iscsi tcp connection and any
+ * 	resource held
  * @c3cn: the iscsi tcp connection
  */
 void cxgb3i_c3cn_release(struct s3_conn *c3cn)
 {
 	c3cn_conn_debug("c3cn 0x%p, s %u, f 0x%lx.\n",
 			c3cn, c3cn->state, c3cn->flags);
-	if (likely(c3cn->state != C3CN_STATE_CONNECTING))
-		c3cn_active_close(c3cn);
-	else
+	if (unlikely(c3cn->state == C3CN_STATE_CONNECTING))
 		c3cn_set_flag(c3cn, C3CN_ACTIVE_CLOSE_NEEDED);
+	else if (likely(c3cn->state != C3CN_STATE_CLOSED))
+		c3cn_active_close(c3cn);
 	c3cn_put(c3cn);
 }
 
@@ -1656,7 +1662,6 @@ int cxgb3i_c3cn_connect(struct s3_conn *c3cn, struct sockaddr_in *usin)
 	c3cn_set_state(c3cn, C3CN_STATE_CLOSED);
 	ip_rt_put(rt);
 	c3cn_put_port(c3cn);
-	c3cn->daddr.sin_port = 0;
 	return err;
 }
 
@@ -1776,10 +1781,25 @@ out_err:
 static void sdev_data_cleanup(struct cxgb3i_sdev_data *cdata)
 {
 	struct adap_ports *ports = &cdata->ports;
+	struct s3_conn *c3cn;
 	int i;
 
+	for (i = 0; i < cxgb3_max_connect; i++) {
+		if (cdata->sport_conn[i]) {
+			c3cn = cdata->sport_conn[i];
+			cdata->sport_conn[i] = NULL;
+
+			spin_lock_bh(&c3cn->lock);
+			c3cn->cdev = NULL;
+			c3cn_set_flag(c3cn, C3CN_OFFLOAD_DOWN);
+			c3cn_closed(c3cn);
+			spin_unlock_bh(&c3cn->lock);
+		}
+	}
+
 	for (i = 0; i < ports->nports; i++)
 		NDEV2CDATA(ports->lldevs[i]) = NULL;
+
 	cxgb3i_free_big_mem(cdata);
 }
 
@@ -1821,21 +1841,27 @@ void cxgb3i_sdev_add(struct t3cdev *cdev, struct cxgb3_client *client)
 	struct cxgb3i_sdev_data *cdata;
 	struct ofld_page_info rx_page_info;
 	unsigned int wr_len;
-	int mapsize = DIV_ROUND_UP(cxgb3_max_connect,
-				   8 * sizeof(unsigned long));
+	int mapsize = cxgb3_max_connect * sizeof(struct s3_conn *);
 	int i;
 
 	cdata =  cxgb3i_alloc_big_mem(sizeof(*cdata) + mapsize, GFP_KERNEL);
-	if (!cdata)
+	if (!cdata) {
+		cxgb3i_log_warn("t3dev 0x%p, offload up, OOM %d.\n",
+				cdev, mapsize);
 		return;
+	}
 
 	if (cdev->ctl(cdev, GET_WR_LEN, &wr_len) < 0 ||
 	    cdev->ctl(cdev, GET_PORTS, &cdata->ports) < 0 ||
-	    cdev->ctl(cdev, GET_RX_PAGE_INFO, &rx_page_info) < 0)
+	    cdev->ctl(cdev, GET_RX_PAGE_INFO, &rx_page_info) < 0) {
+		cxgb3i_log_warn("t3dev 0x%p, offload up, ioctl failed.\n",
+				cdev);
 		goto free_cdata;
+	}
 
 	s3_init_wr_tab(wr_len);
 
+	spin_lock_init(&cdata->lock);
 	INIT_LIST_HEAD(&cdata->list);
 	cdata->cdev = cdev;
 	cdata->client = client;
@@ -1847,6 +1873,7 @@ void cxgb3i_sdev_add(struct t3cdev *cdev, struct cxgb3_client *client)
 	list_add_tail(&cdata->list, &cdata_list);
 	write_unlock(&cdata_rwlock);
 
+	cxgb3i_log_info("t3dev 0x%p, offload up, added.\n", cdev);
 	return;
 
 free_cdata:
@@ -1861,6 +1888,8 @@ void cxgb3i_sdev_remove(struct t3cdev *cdev)
 {
 	struct cxgb3i_sdev_data *cdata = CXGB3_SDEV_DATA(cdev);
 
+	cxgb3i_log_info("t3dev 0x%p, offload down, remove.\n", cdev);
+
 	write_lock(&cdata_rwlock);
 	list_del(&cdata->list);
 	write_unlock(&cdata_rwlock);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index 275f23f..dab759d 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -135,11 +135,11 @@ enum c3cn_flags {
 	C3CN_ABORT_RPL_PENDING,	/* expecting an abort reply */
 	C3CN_TX_DATA_SENT,	/* already sent a TX_DATA WR */
 	C3CN_ACTIVE_CLOSE_NEEDED,	/* need to be closed */
+	C3CN_OFFLOAD_DOWN	/* offload function off */
 };
 
 /**
  * cxgb3i_sdev_data - Per adapter data.
- *
  * Linked off of each Ethernet device port on the adapter.
  * Also available via the t3cdev structure since we have pointers to our port
  * net_device's there ...
@@ -148,16 +148,17 @@ enum c3cn_flags {
  * @cdev:	t3cdev adapter
  * @client:	CPL client pointer
  * @ports:	array of adapter ports
- * @sport_map_next: next index into the port map
- * @sport_map:	source port map
+ * @sport_next: next port
+ * @sport_conn:	source port connection
  */
 struct cxgb3i_sdev_data {
 	struct list_head list;
 	struct t3cdev *cdev;
 	struct cxgb3_client *client;
 	struct adap_ports ports;
-	unsigned int sport_map_next;
-	unsigned long sport_map[0];
+	spinlock_t lock;
+	unsigned int sport_next;
+	struct s3_conn *sport_conn[0];
 };
 #define NDEV2CDATA(ndev) (*(struct cxgb3i_sdev_data **)&(ndev)->ec_ptr)
 #define CXGB3_SDEV_DATA(cdev) NDEV2CDATA((cdev)->lldev)
-- 
1.6.0.6

