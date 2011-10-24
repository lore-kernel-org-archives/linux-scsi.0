From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 8/9] ib_srpt: Convert srp_max_rsp_size into per port configfs attribute
Date: Mon, 24 Oct 2011 05:33:41 +0000
Message-ID: <1319434422-15354-9-git-send-email-nab@linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:59594 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1JXFf3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2011 01:35:29 -0400
In-Reply-To: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the srp_max_rsp_size module parameter into a per
port configfs attribute.  This includes adding the necessary bits for
show + store attributes w/ min/max bounds checking, and dropping
the legacy WARN_ON() as sport_port is not available for all callers
of srpt_alloc_ioctx_ring() and srpt_free_ioctx_ring().

It also drops the legacy srp_max_rsp_size module parameter checks
in srpt_init_module(), and adds new MAX_SRPT_RSP_SIZE = 1024 for
proper bounds checking in srpt_tpg_attrib_store_srp_max_rsp_size().

Reported-by: Roland Dreier <roland@purestorage.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   67 +++++++++++++++++++++++---------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    3 +
 2 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 80ef5af..f4a900b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -83,11 +83,6 @@ module_param(srp_max_req_size, int, 0444);
 MODULE_PARM_DESC(srp_max_req_size,
 		 "Maximum size of SRP request messages in bytes.");
 
-static unsigned int srp_max_rsp_size = DEFAULT_MAX_RSP_SIZE;
-module_param(srp_max_rsp_size, int, 0444);
-MODULE_PARM_DESC(srp_max_rsp_size,
-		 "Maximum size of SRP response messages in bytes.");
-
 static int srpt_srq_size = DEFAULT_SRPT_SRQ_SIZE;
 module_param(srpt_srq_size, int, 0444);
 MODULE_PARM_DESC(srpt_srq_size,
@@ -687,7 +682,6 @@ static struct srpt_ioctx **srpt_alloc_ioctx_ring(struct srpt_device *sdev,
 
 	WARN_ON(ioctx_size != sizeof(struct srpt_recv_ioctx)
 		&& ioctx_size != sizeof(struct srpt_send_ioctx));
-	WARN_ON(dma_size != srp_max_req_size && dma_size != srp_max_rsp_size);
 
 	ring = kmalloc(ring_size * sizeof(ring[0]), GFP_KERNEL);
 	if (!ring)
@@ -717,8 +711,6 @@ static void srpt_free_ioctx_ring(struct srpt_ioctx **ioctx_ring,
 {
 	int i;
 
-	WARN_ON(dma_size != srp_max_req_size && dma_size != srp_max_rsp_size);
-
 	for (i = 0; i < ring_size; ++i)
 		srpt_free_ioctx(sdev, ioctx_ring[i], dma_size, dir);
 	kfree(ioctx_ring);
@@ -2384,7 +2376,8 @@ static void srpt_release_channel_work(struct work_struct *w)
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
 			     ch->sport->sdev, ch->rq_size,
-			     srp_max_rsp_size, DMA_TO_DEVICE);
+			     ch->sport->port_attrib.srp_max_rsp_size,
+			     DMA_TO_DEVICE);
 
 	spin_lock_irq(&sdev->spinlock);
 	list_del(&ch->list);
@@ -2568,7 +2561,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	ch->ioctx_ring = (struct srpt_send_ioctx **)
 		srpt_alloc_ioctx_ring(ch->sport->sdev, ch->rq_size,
 				      sizeof(*ch->ioctx_ring[0]),
-				      srp_max_rsp_size, DMA_TO_DEVICE);
+				      ch->sport->port_attrib.srp_max_rsp_size,
+				      DMA_TO_DEVICE);
 	if (!ch->ioctx_ring)
 		goto free_ch;
 
@@ -2676,8 +2670,8 @@ destroy_ib:
 free_ring:
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
 			     ch->sport->sdev, ch->rq_size,
-			     srp_max_rsp_size, DMA_TO_DEVICE);
-
+			     ch->sport->port_attrib.srp_max_rsp_size,
+			     DMA_TO_DEVICE);
 free_ch:
 	kfree(ch);
 
@@ -3294,6 +3288,7 @@ static void srpt_add_one(struct ib_device *device)
 		sport->sdev = sdev;
 		sport->port = i;
 		sport->port_attrib.srp_max_rdma_size = DEFAULT_MAX_RDMA_SIZE;
+		sport->port_attrib.srp_max_rsp_size = DEFAULT_MAX_RSP_SIZE;
 		INIT_WORK(&sport->work, srpt_refresh_port_work);
 		INIT_LIST_HEAD(&sport->port_acl_list);
 		spin_lock_init(&sport->port_acl_lock);
@@ -3737,8 +3732,49 @@ static ssize_t srpt_tpg_attrib_store_srp_max_rdma_size(
 
 TF_TPG_ATTRIB_ATTR(srpt, srp_max_rdma_size, S_IRUGO | S_IWUSR);
 
+static ssize_t srpt_tpg_attrib_show_srp_max_rsp_size(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+
+	return sprintf(page, "%u\n", sport->port_attrib.srp_max_rsp_size);
+}
+
+static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(page, 0, &val);
+	if (ret < 0) {
+		pr_err("strict_strtoul() failed with ret: %d\n", ret);
+		return -EINVAL;
+	}
+	if (val > MAX_SRPT_RSP_SIZE) {
+		pr_err("val: %lu exceeds MAX_SRPT_RSP_SIZE: %d\n", val,
+			MAX_SRPT_RSP_SIZE);
+		return -EINVAL;
+	}
+	if (val < MIN_MAX_RSP_SIZE) {
+		pr_err("val: %lu smaller than MIN_MAX_RSP_SIZE: %d\n", val,
+			MIN_MAX_RSP_SIZE);
+		return -EINVAL;
+	}
+	sport->port_attrib.srp_max_rsp_size = val;
+
+	return count;
+}
+
+TF_TPG_ATTRIB_ATTR(srpt, srp_max_rsp_size, S_IRUGO | S_IWUSR);
+
 static struct configfs_attribute *srpt_tpg_attrib_attrs[] = {
 	&srpt_tpg_attrib_srp_max_rdma_size.attr,
+	&srpt_tpg_attrib_srp_max_rsp_size.attr,
 	NULL,
 };
 
@@ -3937,13 +3973,6 @@ static int __init srpt_init_module(void)
 		goto out;
 	}
 
-	if (srp_max_rsp_size < MIN_MAX_RSP_SIZE) {
-		printk(KERN_ERR "invalid value %d for kernel module parameter"
-		       " srp_max_rsp_size -- must be at least %d.\n",
-		       srp_max_rsp_size, MIN_MAX_RSP_SIZE);
-		goto out;
-	}
-
 	if (srpt_srq_size < MIN_SRPT_SRQ_SIZE
 	    || srpt_srq_size > MAX_SRPT_SRQ_SIZE) {
 		printk(KERN_ERR "invalid value %d for kernel module parameter"
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index c9caa90..27b1027 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -115,6 +115,7 @@ enum {
 	DEFAULT_SRPT_SRQ_SIZE = 4095,
 	MAX_SRPT_SRQ_SIZE = 65535,
 	MAX_SRPT_RDMA_SIZE = 256U,
+	MAX_SRPT_RSP_SIZE = 1024,
 
 	MIN_MAX_REQ_SIZE = 996,
 	DEFAULT_MAX_REQ_SIZE
@@ -329,9 +330,11 @@ struct srpt_rdma_ch {
 /**
  * struct srpt_port_attib - Attributes for SRPT port
  * @srp_max_rdma_size: Maximum size of SRP RDMA transfers for new connections.
+ * @srp_max_rsp_size: Maximum size of SRP response messages in bytes.
  */
 struct srpt_port_attrib {
 	u32			srp_max_rdma_size;
+	u32			srp_max_rsp_size;
 };
 
 /**
-- 
1.7.2.5

