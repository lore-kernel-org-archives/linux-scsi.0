From: Roland Dreier <rdreier@cisco.com>
Subject: [PATCH][SCSI] cxgb3i: Shrink .text by cleaning up cpl_handlers[] init
Date: Tue, 27 Apr 2010 22:34:56 -0700
Message-ID: <ada4oiwkum7.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15352 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0D1FfA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2010 01:35:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Karen Xie <kxie@chelsio.com>, Rakesh Ranjan <rakesh@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>

Using compile-time designated initializers for the cpl_handlers[]
array instead of open-coding the initialization in cxgb3_sdev_init()
is (IMHO) cleaner, and leads to substantially smaller code: on my
x86-64 build, bloat-o-meter shows:

add/remove: 0/0 grow/shrink: 5/7 up/down: 6/-117 (-111)
function                                     old     new   delta
do_close_con_rpl                              82      84      +2
process_close_con_rpl                        122     123      +1
is_cxgb3_dev                                 124     125      +1
cxgb3i_c3cn_rx_credits                       232     233      +1
act_open_req_arp_failure                     104     105      +1
do_act_open_rpl                              126     125      -1
do_abort_rpl                                 112     111      -1
cxgb3i_sdev_remove                           114     113      -1
do_wr_ack                                     61      59      -2
init_module                                   54      43     -11
cxgb3i_init_module                            54      43     -11
cxgb3i_sdev_init                             118      28     -90

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/scsi/cxgb3i/cxgb3i_init.c    |    5 +----
 drivers/scsi/cxgb3i/cxgb3i_offload.c |   23 ++++++++++++-----------
 drivers/scsi/cxgb3i/cxgb3i_offload.h |    4 +++-
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
index d0ab23a..580ff72 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_init.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
@@ -28,7 +28,6 @@ static void open_s3_dev(struct t3cdev *);
 static void close_s3_dev(struct t3cdev *);
 static void s3_event_handler(struct t3cdev *tdev, u32 event, u32 port);
 
-static cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS];
 static struct cxgb3_client t3c_client = {
 	.name = "iscsi_cxgb3",
 	.handlers = cxgb3i_cpl_handlers,
@@ -95,9 +94,7 @@ static int __init cxgb3i_init_module(void)
 {
 	int err;
 
-	err = cxgb3i_sdev_init(cxgb3i_cpl_handlers);
-	if (err < 0)
-		return err;
+	cxgb3i_sdev_init();
 
 	err = cxgb3i_iscsi_init();
 	if (err < 0)
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index a175be9..efc864e 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1260,6 +1260,17 @@ static int do_wr_ack(struct t3cdev *cdev, struct sk_buff *skb, void *ctx)
 	return 0;
 }
 
+cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS] = {
+	[CPL_ACT_ESTABLISH]	= do_act_establish,
+	[CPL_ACT_OPEN_RPL]	= do_act_open_rpl,
+	[CPL_PEER_CLOSE]	= do_peer_close,
+	[CPL_ABORT_REQ_RSS]	= do_abort_req,
+	[CPL_ABORT_RPL_RSS]	= do_abort_rpl,
+	[CPL_CLOSE_CON_RPL]	= do_close_con_rpl,
+	[CPL_TX_DMA_ACK]	= do_wr_ack,
+	[CPL_ISCSI_HDR]		= do_iscsi_hdr,
+};
+
 /*
  * for each connection, pre-allocate skbs needed for close/abort requests. So
  * that we can service the request right away.
@@ -1856,20 +1867,10 @@ void cxgb3i_sdev_cleanup(void)
 	write_unlock(&cdata_rwlock);
 }
 
-int cxgb3i_sdev_init(cxgb3_cpl_handler_func *cpl_handlers)
+void cxgb3i_sdev_init(void)
 {
-	cpl_handlers[CPL_ACT_ESTABLISH] = do_act_establish;
-	cpl_handlers[CPL_ACT_OPEN_RPL] = do_act_open_rpl;
-	cpl_handlers[CPL_PEER_CLOSE] = do_peer_close;
-	cpl_handlers[CPL_ABORT_REQ_RSS] = do_abort_req;
-	cpl_handlers[CPL_ABORT_RPL_RSS] = do_abort_rpl;
-	cpl_handlers[CPL_CLOSE_CON_RPL] = do_close_con_rpl;
-	cpl_handlers[CPL_TX_DMA_ACK] = do_wr_ack;
-	cpl_handlers[CPL_ISCSI_HDR] = do_iscsi_hdr;
-
 	if (cxgb3_max_connect > CXGB3I_MAX_CONN)
 		cxgb3_max_connect = CXGB3I_MAX_CONN;
-	return 0;
 }
 
 /**
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index 6a1d86b..b57c72b 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -163,8 +163,10 @@ struct cxgb3i_sdev_data {
 #define NDEV2CDATA(ndev) (*(struct cxgb3i_sdev_data **)&(ndev)->ec_ptr)
 #define CXGB3_SDEV_DATA(cdev) NDEV2CDATA((cdev)->lldev)
 
+extern cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS];
+
 void cxgb3i_sdev_cleanup(void);
-int cxgb3i_sdev_init(cxgb3_cpl_handler_func *);
+void cxgb3i_sdev_init(void);
 void cxgb3i_sdev_add(struct t3cdev *, struct cxgb3_client *);
 void cxgb3i_sdev_remove(struct t3cdev *);
 

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
