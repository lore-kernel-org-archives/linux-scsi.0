Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170876;
	b=FxmgstUdG8r73DXOn+PHTqGsNaEcz7E/xFIV9eiDczQavZGpn9+5m7BtGOgW2zMJEUGY
	 /JS2Aw6YJzuuWgF60/Oa3DWJYwrbBmliwsxw5D5ejiDiNeULYajSIx44BcLN8oAuCkjDz
	 vCZIWgpFtHE9aUzV9fwmaFlVbF5tKtXtMwYD6A4/VCFIkA4QiN9F8x9CMfhk5Eb/U5Ofk
	 PAbLRY0LUPoFXZiqW/KCUX7MfyfMF2zVpx7jm/Xt//5SwRiOm12P93Haq+vR54f8Bzv7t
	 Q0K+i5JurWr5Vsi76arEG+fMm4DvQg9RZikIn+p0tNW3ZRVOmIhT8Dp6eOgG/43GmMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170876;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=e/ENcDTT/46/JqAXL/szZUWwi4iIP1GEc08oJGPBrmo=;
	b=vDI6vAX3v08L//gsG2aeY/kMJ65x7je2QP2qA6q5xrm89HhdqV8cnKZVAkKnkfeq/HaJ
	 cHn9VXBQ9ck0w11dKBkiAH0yGEaSo+Snbd0WSeKY64HsSdPXzL+56TXlpgKKYT0sgGUAH
	 Pb1zovLa2h7UJ54FJ9LlyiN1mc6QDvFI8YDusnKuos0CDqFE5+TpzBJGkq2VykkeoZgbQ
	 asPaZFVEajvo9uF/1N+IxqJ3lP8ZWz5oSAbzi3LIZstsJCGyYO62TepQ6FXBNATV8A/mu
	 Zc25u7Eg95zPsj58AYs67Cv//y9HOWMqlrYzT3oy+Q+Wa0OEwtKS65kkQdiOsHqQC7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CYaEu3qM;
	arc=none smtp.remote-ip=95.215.58.24
Received: from mta1.migadu.com (out-24.mta1.migadu.com [95.215.58.24])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772CA606A322
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:47:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 772CA606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CYaEu3qM
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MZn8yrwKf5iQXSOFESiRDw+YiIRgNh5gAITR+UTucsU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170873; v=1; x=1794775673;
 b=CYaEu3qMK1rqlylLHp5liht6NyRDfpYSnyT5OsZNxBPSSOPi0WpVzCbLx7rz3cMblDO+Ru9V
 iv5YfmNNaA73Rmq0IUCVd7b07CAzInBp/bEAsCsCxu7jc2QFIEck915JgukpNR0IG316O8RmIRd
 vUqBeAz6lh3EIQlGkrZRxfqY=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 10538c3942c06036;
	Sun, 08 Nov 2026 20:47:53 +0000
X-Mizu-Trace-ID: 10538c3942c06036
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v9 02/29] libmultipath: Add initial framework
Date: Sun,  8 Nov 2026 20:47:06 +0000
Message-ID: <20261108204733.557995-3-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add initial framework for libmultipath. libmultipath is a library for
multipath-capable block drivers, such as NVMe. The main function is to
support path management, path selection, and failover handling.

Basic support to add and remove the head structure - mpath_head - is
included.

This main purpose of this structure is to manage available paths and path
selection. It is quite similar to the multipath functionality in
nvme_ns_head. It also manages the multipath gendisk.

Each path is represented by the mpath_device structure. It should hold a
pointer to the per-path gendisk and also a list element for all siblings
of paths. For NVMe, there would be a mpath_device per nvme_ns.

All the libmultipath code is more or less taken from
drivers/nvme/host/multipath.c, which was originally authored by Christoph
Hellwig <hch@lst.de>.

Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: John Garry <john.garry@linux.dev>
---
 include/linux/multipath.h | 28 ++++++++++++++++
 lib/Kconfig               |  6 ++++
 lib/Makefile              |  2 ++
 lib/multipath.c           | 68 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)
 create mode 100644 include/linux/multipath.h
 create mode 100644 lib/multipath.c

diff --git a/include/linux/multipath.h b/include/linux/multipath.h
new file mode 100644
index 000000000000..407d985cd31f
--- /dev/null
+++ b/include/linux/multipath.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#ifndef _LIBMULTIPATH_H
+#define _LIBMULTIPATH_H
+
+#include <linux/blkdev.h>
+#include <linux/srcu.h>
+
+struct mpath_device {
+	struct list_head	siblings;
+	struct gendisk		*disk;
+};
+
+struct mpath_head {
+	struct srcu_struct	srcu;
+	struct list_head	dev_list;	/* list of all mpath_devs */
+	struct mutex		lock;
+
+	refcount_t		refcount;
+
+	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
+};
+
+int mpath_get_head(struct mpath_head *mpath_head);
+void mpath_put_head(struct mpath_head *mpath_head);
+int mpath_head_init(struct mpath_head *mpath_head);
+void mpath_head_uninit(struct mpath_head *mpath_head);
+
+#endif // _LIBMULTIPATH_H
diff --git a/lib/Kconfig b/lib/Kconfig
index 1e42f5167c68..3580bab7c2b1 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -630,3 +630,9 @@ config UNION_FIND
 
 config MIN_HEAP
 	bool
+
+config LIBMULTIPATH
+	bool "MULTIPATH BLOCK DRIVER LIBRARY"
+	depends on BLOCK
+	help
+	  If you say yes here then you get a multipath lib for block drivers
diff --git a/lib/Makefile b/lib/Makefile
index a2afe954805c..b4c0da268b67 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -350,3 +350,5 @@ CONTEXT_ANALYSIS_test_context-analysis.o := y
 obj-$(CONFIG_CONTEXT_ANALYSIS_TEST) += test_context-analysis.o
 
 subdir-$(CONFIG_FORTIFY_SOURCE) += test_fortify
+
+obj-$(CONFIG_LIBMULTIPATH)	+= multipath.o
diff --git a/lib/multipath.c b/lib/multipath.c
new file mode 100644
index 000000000000..31ef98980ba4
--- /dev/null
+++ b/lib/multipath.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2017-2018 Christoph Hellwig.
+ *
+ * Base on NVMe multipath support in drivers/nvme/host/multipath.c
+ */
+#include <linux/module.h>
+#include <linux/multipath.h>
+#include <linux/wait_bit.h>
+
+static struct workqueue_struct *mpath_wq;
+
+int mpath_get_head(struct mpath_head *mpath_head)
+{
+	if (!refcount_inc_not_zero(&mpath_head->refcount))
+		return -ENXIO;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpath_get_head);
+
+void mpath_put_head(struct mpath_head *mpath_head)
+{
+	refcount_t *refcount = &mpath_head->refcount;
+
+	if (refcount_dec_and_test(&mpath_head->refcount))
+		wake_up_var(refcount);
+}
+EXPORT_SYMBOL_GPL(mpath_put_head);
+
+void mpath_head_uninit(struct mpath_head *mpath_head)
+{
+	refcount_t *refcount = &mpath_head->refcount;
+
+	if (!refcount_dec_and_test(refcount))
+		wait_var_event(refcount, !refcount_read(refcount));
+	cleanup_srcu_struct(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_head_uninit);
+
+int mpath_head_init(struct mpath_head *mpath_head)
+{
+	memset(mpath_head, 0, sizeof(*mpath_head));
+	INIT_LIST_HEAD(&mpath_head->dev_list);
+	mutex_init(&mpath_head->lock);
+	refcount_set(&mpath_head->refcount, 1);
+
+	return init_srcu_struct(&mpath_head->srcu);
+}
+EXPORT_SYMBOL_GPL(mpath_head_init);
+
+static int __init mpath_init(void)
+{
+	mpath_wq = alloc_workqueue("mpath-wq",
+			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
+	if (!mpath_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+static void __exit mpath_exit(void)
+{
+	destroy_workqueue(mpath_wq);
+}
+
+module_init(mpath_init);
+module_exit(mpath_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("libmultipath");
-- 
2.43.0

