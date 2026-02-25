Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EFD2DCF55
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772035943; cv=none; b=uJV5LUSXYss2RzyrF3CxyOlY+jN5sI0K7/Cihj36DBTWWldzJzO2oYHFSjFAhMu09VuXkYpaaO1IyqEdU7P/LKHy28Sc0YYh0Q2DsXQojJczE3tnkPiZheeGOjdq4aBZMqk1NXDK63dDMx18OsPfGC4OxDspDMBKmDRMor92PMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772035943; c=relaxed/simple;
	bh=mWppwI5NQTWcfcfpyt2uj6gBpVoa8+WPtY2YV1yqqRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGhratf0RmB2hbjI+fclQlZLa62pBC0EcwI2dBhOPPZubDp8EErgFwxa9Pt4yqY3p8MCDTfZ7xtWNL83uifjC+O7Njtm9H0SXRAV1JJfPldv11YD+7flS+Caypay0LROBCdMPkww/KwZ9/8Yq0C+Co3dLzAEqwZgwV3iPPS5e4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XYIQVjb/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XYIQVjb/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772035941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YwY473jKOyj8ZUeGWCvtQw/AcjeylegdXSOtGtl9HpU=;
	b=XYIQVjb/gV9oLa1Dfbrh++teEdUlJwhwRdHvaFXfnMCKcdtxX6CSogs1qOca70SnXqjhfp
	k4Vc5y7HE9E30LKaSoBqNRD7Ky4w314K210EG0sVbngRRUvVwAHmAaiUXX2CGyg6rFy5Eu
	RzHfWZnUOgFtEc9aJWpXbvj3P5ZnzjA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-482-K7yY-THmOeul8Rr9EMn42Q-1; Wed,
 25 Feb 2026 11:12:17 -0500
X-MC-Unique: K7yY-THmOeul8Rr9EMn42Q-1
X-Mimecast-MFC-AGG-ID: K7yY-THmOeul8Rr9EMn42Q_1772035936
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47DD01956055;
	Wed, 25 Feb 2026 16:12:15 +0000 (UTC)
Received: from mlombard-thinkpadt14gen4.rmtit.csb (unknown [10.44.32.217])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 27A601800370;
	Wed, 25 Feb 2026 16:12:10 +0000 (UTC)
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
Subject: [PATCH V3 1/3] lib: Introduce completion chain helper
Date: Wed, 25 Feb 2026 17:12:01 +0100
Message-ID: <20260225161203.76168-2-mlombard@redhat.com>
In-Reply-To: <20260225161203.76168-1-mlombard@redhat.com>
References: <20260225161203.76168-1-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Introduce a new helper library, the completion chain, designed to serialize
asynchronous operations that must complete in a strict First-In, First-Out
(FIFO) order.

Certain workflows, particularly in storage drivers, require operations to
complete in the same sequence they were submitted.
This helper provides a generic mechanism to enforce this ordering.

compl_chain: The main structure representing the queue of operations
compl_chain_entry: An entry embedded in a per-operation structure

The typical usage pattern is:

    * An operation is enqueued by calling compl_chain_add().

    * The worker thread for the operation calls
      compl_chain_wait(), which blocks until the previously
      enqueued operation has finished.

    * After the work is done, the thread calls compl_chain_complete().
      This signals the next operation in the chain that it can now
      proceed and removes the current entry from the list.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 include/linux/compl_chain.h |  35 +++++++++++
 lib/Makefile                |   2 +-
 lib/compl_chain.c           | 118 ++++++++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/compl_chain.h
 create mode 100644 lib/compl_chain.c

diff --git a/include/linux/compl_chain.h b/include/linux/compl_chain.h
new file mode 100644
index 000000000000..a2bf271144e0
--- /dev/null
+++ b/include/linux/compl_chain.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_COMPLETION_CHAIN_H
+#define _LINUX_COMPLETION_CHAIN_H
+
+#include <linux/list.h>
+#include <linux/completion.h>
+#include <linux/spinlock.h>
+
+struct compl_chain {
+	spinlock_t lock;
+	struct list_head list;
+};
+
+#define COMPL_CHAIN_INIT(name) \
+	{ .lock = __SPIN_LOCK_UNLOCKED((name).lock), \
+	  .list = LIST_HEAD_INIT((name).list) }
+
+#define DEFINE_COMPL_CHAIN(name) \
+	struct compl_chain name = COMPL_CHAIN_INIT(name)
+
+struct compl_chain_entry {
+	struct compl_chain *chain;
+	struct list_head list;
+	struct completion prev_finished;
+};
+
+void compl_chain_init(struct compl_chain *chain);
+void compl_chain_add(struct compl_chain *chain,
+			struct compl_chain_entry *entry);
+void compl_chain_wait(struct compl_chain_entry *entry);
+void compl_chain_complete(struct compl_chain_entry *entry);
+bool compl_chain_pending(struct compl_chain_entry *entry);
+void compl_chain_flush(struct compl_chain *chain);
+
+#endif /* _LINUX_COMPLETION_CHAIN_H */
diff --git a/lib/Makefile b/lib/Makefile
index 1b9ee167517f..c3ccd82bb190 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -58,7 +58,7 @@ obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
 	 bsearch.o find_bit.o llist.o lwq.o memweight.o kfifo.o \
 	 percpu-refcount.o rhashtable.o base64.o \
 	 once.o refcount.o rcuref.o usercopy.o errseq.o bucket_locks.o \
-	 generic-radix-tree.o bitmap-str.o
+	 generic-radix-tree.o bitmap-str.o compl_chain.o
 obj-y += string_helpers.o
 obj-y += hexdump.o
 obj-$(CONFIG_TEST_HEXDUMP) += test_hexdump.o
diff --git a/lib/compl_chain.c b/lib/compl_chain.c
new file mode 100644
index 000000000000..b1cb43753f52
--- /dev/null
+++ b/lib/compl_chain.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Author: Maurizio Lombardi <mlombard@redhat.com>
+ */
+#include <linux/compl_chain.h>
+
+/**
+ * compl_chain_init - Initialize a completion chain
+ * @chain: The completion chain to be initialized.
+ *
+ * Initializes a compl_chain structure
+ */
+void compl_chain_init(struct compl_chain *chain)
+{
+	spin_lock_init(&chain->lock);
+	INIT_LIST_HEAD(&chain->list);
+}
+EXPORT_SYMBOL_GPL(compl_chain_init);
+
+/**
+ * compl_chain_add - Add a new entry to the tail of the chain
+ * @chain: The completion chain to add the entry to.
+ * @entry: The entry to be enqueued.
+ *
+ * Adds a new entry to the end of the queue.
+ * If the chain is empty when this entry is added, it is immediately marked
+ * as ready to run, as there is no preceding entry to wait for.
+ */
+void compl_chain_add(struct compl_chain *chain,
+			struct compl_chain_entry *entry)
+{
+	init_completion(&entry->prev_finished);
+	INIT_LIST_HEAD(&entry->list);
+
+	WRITE_ONCE(entry->chain, chain);
+
+	spin_lock(&chain->lock);
+	if (list_empty(&chain->list))
+		complete_all(&entry->prev_finished);
+	list_add_tail(&entry->list, &chain->list);
+	spin_unlock(&chain->lock);
+}
+EXPORT_SYMBOL_GPL(compl_chain_add);
+
+/**
+ * compl_chain_wait - Wait for the preceding operation to finish
+ * @entry: The entry for the current operation.
+ *
+ * Blocks the current execution thread until compl_chain_complete()
+ * is executed against the previous entry in the chain.
+ */
+void compl_chain_wait(struct compl_chain_entry *entry)
+{
+	WARN_ON(!entry->chain);
+
+	wait_for_completion(&entry->prev_finished);
+}
+EXPORT_SYMBOL_GPL(compl_chain_wait);
+
+/**
+ * compl_chain_complete - Mark an entry as completed and signal the next one
+ * @entry: The entry to mark as completed.
+ *
+ * Removes the current entry from the chain and signals the next waiting
+ * entry (if one exists) that it is now allowed to proceed.
+ */
+void compl_chain_complete(struct compl_chain_entry *entry)
+{
+	struct compl_chain *chain = entry->chain;
+
+	WARN_ON(!chain);
+
+	wait_for_completion(&entry->prev_finished);
+
+	spin_lock(&chain->lock);
+	list_del(&entry->list);
+	if (!list_empty(&chain->list)) {
+		struct compl_chain_entry *next =
+			list_first_entry(&chain->list,
+					 struct compl_chain_entry, list);
+		complete_all(&next->prev_finished);
+	}
+	spin_unlock(&chain->lock);
+
+	WRITE_ONCE(entry->chain, NULL);
+}
+EXPORT_SYMBOL_GPL(compl_chain_complete);
+
+/**
+ * compl_chain_pending - Check if an entry is pending
+ * @entry: The entry to check.
+ *
+ * Returns true if an entry has been added to a chain and hasn't yet
+ * been completed.
+ */
+bool compl_chain_pending(struct compl_chain_entry *entry)
+{
+	return READ_ONCE(entry->chain) != NULL;
+}
+EXPORT_SYMBOL_GPL(compl_chain_pending);
+
+/**
+ * compl_chain_flush - Wait for all entries currently in the chain to finish
+ * @chain: The completion chain to flush.
+ *
+ * Enqueues a dummy entry into the chain and immediately calls
+ * compl_chain_complete() against it. Because operations execute in strict
+ * FIFO order, this acts as a barrier, blocking the calling thread until
+ * all previously enqueued entries have finished.
+ */
+void compl_chain_flush(struct compl_chain *chain)
+{
+	struct compl_chain_entry dummy_entry;
+
+	compl_chain_add(chain, &dummy_entry);
+	compl_chain_complete(&dummy_entry);
+}
+EXPORT_SYMBOL_GPL(compl_chain_flush);
-- 
2.53.0

