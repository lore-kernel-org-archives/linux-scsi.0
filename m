Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8575E37BE70
	for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 12:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771935928; cv=none; b=VBozEqg/xYOmEECIHh0t9Hl3Swlme2+eTTOjfJaXPZ4FuHleUEUxMbi/+9aNFW6Xl7ufqYI8CsOklnvTf6mcGSjZnf7ci1LJxp6xtWeZe1bv3XXyxGqZsjepEaL5Ojl11/FpUNCQWSNAZre0ub3bQdUxzqEquxR5f/2rGsYp7uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771935928; c=relaxed/simple;
	bh=y8eAwPhfG+tLwHuiB4LmCOrHgj4rlQblXWbW1k3APRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QogdYwnj8ef1zenJTTlkljsUNh5+ahi9Rp93c/vZ3v8UaELYNYdmuMtMKHH4nEroniu99ElquUSQFAMUPw9xFA//+nTfzf+LV/f2C1bQQaI8SEdQnhCkELlho0dzSIwpuTWzR0kwOivRACzpRDwdAw1D89WVveLQV1WMUk1AofE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnI01s1g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnI01s1g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771935925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lGIs1mWUQvpjWOdEeiul6WbE3EEGo/gH1iDQuri5mPw=;
	b=CnI01s1gT6ZV1FlztGZXV/6JhKjwDGgF93J4j4NcMZ9YDEY25Ewpkb+mp05nBostxAxAGz
	oPqlGBWHCwaCb4TyKDSGTNvpQixt1foYJFgSrKVAakAPaQiCxj/Pk/B5bMHeiMNqwmptYd
	Yft/hzjQoXs7etSvHgvCaYIIeHNz4e4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-gSop_Si1NbahDnhuAotycg-1; Tue,
 24 Feb 2026 07:25:22 -0500
X-MC-Unique: gSop_Si1NbahDnhuAotycg-1
X-Mimecast-MFC-AGG-ID: gSop_Si1NbahDnhuAotycg_1771935921
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB6401956078;
	Tue, 24 Feb 2026 12:25:20 +0000 (UTC)
Received: from mlombard-thinkpadt14gen4.rmtit.csb (unknown [10.44.32.204])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0210D19560A2;
	Tue, 24 Feb 2026 12:25:16 +0000 (UTC)
From: Maurizio Lombardi <mlombard@redhat.com>
To: kbusch@kernel.org
Cc: hch@lst.de,
	hare@suse.de,
	chaitanyak@nvidia.com,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	James.Bottomley@HansenPartnership.com,
	mlombard@arkamax.eu,
	jmeneghi@redhat.com,
	emilne@redhat.com,
	bgurney@redhat.com
Subject: [PATCH V2 2/3] nvme-core: register namespaces in order during async scan
Date: Tue, 24 Feb 2026 13:25:04 +0100
Message-ID: <20260224122505.52401-3-mlombard@redhat.com>
In-Reply-To: <20260224122505.52401-1-mlombard@redhat.com>
References: <20260224122505.52401-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The fully asynchronous namespace scanning, while fast, can result in
namespaces being allocated and registered out of order. This leads to
unpredictable device naming across reboots which can be confusing
for users.

To solve this, introduce a serialization mechanism for the asynchronous
namespace scan. This is achieved by using the generic compl_chain helper,
which ensures that the initialization of one namespace (nvme_alloc_ns)
completes before the next one begins.

This approach preserves the performance benefits of asynchronous
identification while guaranteeing that the final device registration
occurs in the correct order.

Performance testing shows that this change has no noticeable impact on
scan times compared to the fully asynchronous method.

High latency NVMe/TCP, ~150ms ping, 100 namespaces

Synchronous namespace scan (RHEL-10.1): 32375ms
Fully async namespace scan (7.0-rc1):    2543ms
Async namespace scan with dependency chain (7.0-rc1): 2431ms

Low latency NVMe/TCP, ~0.2ms ping, 100 namespaces

Synchronous namespace scan (RHEL-10.1): 352ms
Fully async namespace scan (7.0-rc1):  248ms
Async namespace scan with dependency chain (7.0-rc1): 191ms

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/nvme/host/core.c | 94 +++++++++++++++++++++++++---------------
 drivers/nvme/host/nvme.h |  2 +
 2 files changed, 62 insertions(+), 34 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f5ebcaa2f859..24c62bdf8abc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4105,13 +4105,27 @@ static void nvme_ns_add_to_ctrl_list(struct nvme_ns *ns)
 	list_add_rcu(&ns->list, &ns->ctrl->namespaces);
 }
 
-static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
+/**
+ * struct async_scan_task - keeps track of controller & NSID to scan
+ * @entry               link to the completion chain list
+ * @ctrl:		Controller on which namespaces are being scanned
+ * @nsid:		The NSID to scan
+ */
+struct async_scan_task {
+	struct compl_chain_entry chain_entry;
+	struct nvme_ctrl *ctrl;
+	u32 nsid;
+};
+
+static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info,
+				struct compl_chain_entry *cc_entry)
 {
 	struct queue_limits lim = { };
 	struct nvme_ns *ns;
 	struct gendisk *disk;
 	int node = ctrl->numa_node;
 	bool last_path = false;
+	int r;
 
 	ns = kzalloc_node(sizeof(*ns), GFP_KERNEL, node);
 	if (!ns)
@@ -4134,7 +4148,19 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
 	ns->ctrl = ctrl;
 	kref_init(&ns->kref);
 
-	if (nvme_init_ns_head(ns, info))
+	/*
+	 * Wait for the previous async task to finish before
+	 * allocating the namespace.
+	 */
+	if (cc_entry)
+		compl_chain_wait(cc_entry);
+
+	r = nvme_init_ns_head(ns, info);
+
+	if (cc_entry)
+		compl_chain_complete(cc_entry);
+
+	if (r)
 		goto out_cleanup_disk;
 
 	/*
@@ -4309,7 +4335,8 @@ static void nvme_validate_ns(struct nvme_ns *ns, struct nvme_ns_info *info)
 		nvme_ns_remove(ns);
 }
 
-static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
+static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned int nsid,
+				struct compl_chain_entry *cc_entry)
 {
 	struct nvme_ns_info info = { .nsid = nsid };
 	struct nvme_ns *ns;
@@ -4348,40 +4375,30 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 
 	ns = nvme_find_get_ns(ctrl, nsid);
 	if (ns) {
+		/* Release the chain early so the next task can proceed */
+		if (cc_entry)
+			compl_chain_complete(cc_entry);
 		nvme_validate_ns(ns, &info);
 		nvme_put_ns(ns);
 	} else {
-		nvme_alloc_ns(ctrl, &info);
+		nvme_alloc_ns(ctrl, &info, cc_entry);
 	}
 }
 
-/**
- * struct async_scan_info - keeps track of controller & NSIDs to scan
- * @ctrl:	Controller on which namespaces are being scanned
- * @next_nsid:	Index of next NSID to scan in ns_list
- * @ns_list:	Pointer to list of NSIDs to scan
- *
- * Note: There is a single async_scan_info structure shared by all instances
- * of nvme_scan_ns_async() scanning a given controller, so the atomic
- * operations on next_nsid are critical to ensure each instance scans a unique
- * NSID.
- */
-struct async_scan_info {
-	struct nvme_ctrl *ctrl;
-	atomic_t next_nsid;
-	__le32 *ns_list;
-};
-
 static void nvme_scan_ns_async(void *data, async_cookie_t cookie)
 {
-	struct async_scan_info *scan_info = data;
-	int idx;
-	u32 nsid;
+	struct async_scan_task *task = data;
+
+	nvme_scan_ns(task->ctrl, task->nsid, &task->chain_entry);
 
-	idx = (u32)atomic_fetch_inc(&scan_info->next_nsid);
-	nsid = le32_to_cpu(scan_info->ns_list[idx]);
+	/*
+	 * If the task failed early and returned without completing the
+	 * chain entry, ensure the chain progresses safely.
+	 */
+	if (compl_chain_pending(&task->chain_entry))
+		compl_chain_complete(&task->chain_entry);
 
-	nvme_scan_ns(scan_info->ctrl, nsid);
+	kfree(task);
 }
 
 static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
@@ -4411,14 +4428,12 @@ static int nvme_scan_ns_list(struct nvme_ctrl *ctrl)
 	u32 prev = 0;
 	int ret = 0, i;
 	ASYNC_DOMAIN(domain);
-	struct async_scan_info scan_info;
+	struct async_scan_task *task;
 
 	ns_list = kzalloc(NVME_IDENTIFY_DATA_SIZE, GFP_KERNEL);
 	if (!ns_list)
 		return -ENOMEM;
 
-	scan_info.ctrl = ctrl;
-	scan_info.ns_list = ns_list;
 	for (;;) {
 		struct nvme_command cmd = {
 			.identify.opcode	= nvme_admin_identify,
@@ -4434,20 +4449,30 @@ static int nvme_scan_ns_list(struct nvme_ctrl *ctrl)
 			goto free;
 		}
 
-		atomic_set(&scan_info.next_nsid, 0);
 		for (i = 0; i < nr_entries; i++) {
 			u32 nsid = le32_to_cpu(ns_list[i]);
 
 			if (!nsid)	/* end of the list? */
 				goto out;
-			async_schedule_domain(nvme_scan_ns_async, &scan_info,
+
+			task = kmalloc_obj(*task);
+			if (!task) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			task->nsid = nsid;
+			task->ctrl = ctrl;
+			compl_chain_add(&ctrl->scan_chain, &task->chain_entry);
+
+			async_schedule_domain(nvme_scan_ns_async, task,
 						&domain);
 			while (++prev < nsid)
 				nvme_ns_remove_by_nsid(ctrl, prev);
 		}
-		async_synchronize_full_domain(&domain);
 	}
  out:
+	async_synchronize_full_domain(&domain);
 	nvme_remove_invalid_namespaces(ctrl, prev);
  free:
 	async_synchronize_full_domain(&domain);
@@ -4466,7 +4491,7 @@ static void nvme_scan_ns_sequential(struct nvme_ctrl *ctrl)
 	kfree(id);
 
 	for (i = 1; i <= nn; i++)
-		nvme_scan_ns(ctrl, i);
+		nvme_scan_ns(ctrl, i, NULL);
 
 	nvme_remove_invalid_namespaces(ctrl, nn);
 }
@@ -5094,6 +5119,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 
 	mutex_init(&ctrl->scan_lock);
 	INIT_LIST_HEAD(&ctrl->namespaces);
+	compl_chain_init(&ctrl->scan_chain);
 	xa_init(&ctrl->cels);
 	ctrl->dev = dev;
 	ctrl->ops = ops;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9a5f28c5103c..95f8c40ec86b 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -17,6 +17,7 @@
 #include <linux/wait.h>
 #include <linux/t10-pi.h>
 #include <linux/ratelimit_types.h>
+#include <linux/compl_chain.h>
 
 #include <trace/events/block.h>
 
@@ -294,6 +295,7 @@ struct nvme_ctrl {
 	struct blk_mq_tag_set *tagset;
 	struct blk_mq_tag_set *admin_tagset;
 	struct list_head namespaces;
+	struct compl_chain scan_chain;
 	struct mutex namespaces_lock;
 	struct srcu_struct srcu;
 	struct device ctrl_device;
-- 
2.53.0

