Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170905;
	b=1sZlGLoPSSUfC47SOQ2w4PpHwS0vjoxo40zfMYagbyUDPpoareS0mBntpNv0e/Y4BcJ9
	 LZiaSGkiZViEZJ/ctDCR9KSB4Jv2/pfVG1UhiJWH9frsdoEQuQ89b5mRJPtRZFnFtlXpR
	 zGFGN3K5KEEM2ONYi/NUlHGq2wVZuE8/fDIm+wYJA3NGWdES7ABLHGjHm1AIbzS2e5Twu
	 /9ykq6MlFwFdPbcSF+pCqfAdNHMuXeMYVMzwNWPm9lBNtAqmWGTB7daXIfi2Y0L9eUJvY
	 Q49ZoAhWy51IojF4kAL6r0xpWFdRLu22ivRFiPCBnF+sk1i6aAQQ51YaV5VTpqgzbGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170905;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QlNI+CS9C292zxh1KVBjnCmUthmZFrW3aFe7rlr3lPo=;
	b=rpIc9oLEO6p0KtlVeNu+7nJRXVmsk60e0dBZAaZbAVEUmVnIjGILIx0eL5HdOuAOayEB
	 aiCNq3G8UlmBwBYYd7F6hufkNgL7fztavrupeHPWzPByVueMJDsCPss02JrKdSsL3Sv0d
	 pBVtYactREt5KpCaubxhAjEqt7+w2vwq1o/MKmsXzabVBUAqnaBhNHZVclZ/vnKygp9bR
	 hPXfRpJVNhrNv2yiv39/7p+u/xYn+I4Wm6t5d5W5JIlaWSGsgczOnSqqQDDUx7MwwAr+z
	 7/qu9oOXTMM3NKUee0o/aEMVic06fKWqyLeCDq1FTeqp4QAFeV/ypQ+jh9wgJdJk7ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=b8nc4Xfa;
	arc=none smtp.remote-ip=95.215.58.149
Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC496606D825
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC496606D825
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=b8nc4Xfa
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=zGxGuv8VhmxQDKGvPD7JkzGiFLkWBpRa5MQ8Ta/vS5c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170903; v=1; x=1794775703;
 b=b8nc4XfaD2zE8DbGFCdftnKpnKM79s1S1LWN1bvT46Gm6nplIK0R0f26Ib5DDNUnwSM9LzU7
 J84CXShAQEfKd4JRGR3wPiYfdbeoyYDXAf0Ljg49034WfWhOPAsTWDNPnwz+64gfDXZSMtxeX6p
 7TChOIlUVIEP2oFHniESBnYo=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 3caf6acd72947ce7;
	Sun, 08 Nov 2026 20:48:23 +0000
X-Mizu-Trace-ID: 3caf6acd72947ce7
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
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 24/29] scsi: sd: add multipath disk class
Date: Sun,  8 Nov 2026 20:47:28 +0000
Message-ID: <20261108204733.557995-25-john.garry@linux.dev>
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

Add a new class, sd_mpath_disk_class, which is the multipath version of
the scsi_disk class.

Structure sd_mpath_disk is introduced to manage the multipath gendisk.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/sd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h |  3 +++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dc45df819c42..03617029a552 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -70,6 +70,7 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 #include <scsi/scsi_common.h>
+#include <scsi/scsi_multipath.h>
 
 #include "sd.h"
 #include "scsi_priv.h"
@@ -113,6 +114,39 @@ static mempool_t *sd_page_pool;
 static mempool_t *sd_large_page_pool;
 static atomic_t sd_large_page_pool_users = ATOMIC_INIT(0);
 static struct lock_class_key sd_bio_compl_lkclass;
+#ifdef CONFIG_SCSI_MULTIPATH
+struct sd_mpath_disk {
+	struct scsi_mpath_head		*scsi_mpath_head;
+};
+
+static void sd_mpath_disk_release(struct device *dev)
+{
+}
+
+static const struct class sd_mpath_disk_class = {
+	.name = "scsi_mpath_disk",
+	.dev_release = sd_mpath_disk_release,
+};
+
+static int sd_mpath_class_register(void)
+{
+	return class_register(&sd_mpath_disk_class);
+}
+
+static void sd_mpath_class_unregister(void)
+{
+	class_unregister(&sd_mpath_disk_class);
+}
+#else /* CONFIG_SCSI_MULTIPATH */
+static int sd_mpath_class_register(void)
+{
+	return 0;
+}
+
+static void sd_mpath_class_unregister(void)
+{
+}
+#endif
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -4474,11 +4508,15 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
+	err = sd_mpath_class_register();
+	if (err)
+		goto err_out_class;
+
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_class;
+		goto err_out_mpath_class;
 	}
 
 	err = scsi_register_driver(&sd_template);
@@ -4489,6 +4527,8 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
+err_out_mpath_class:
+	sd_mpath_class_unregister();
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -4514,6 +4554,7 @@ static void __exit exit_sd(void)
 		mempool_destroy(sd_large_page_pool);
 
 	class_unregister(&sd_disk_class);
+	sd_mpath_class_unregister();
 
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(sd_major(i), "sd");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 574af8243016..22438173ea2f 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -83,6 +83,9 @@ struct zoned_disk_info {
 
 struct scsi_disk {
 	struct scsi_device *device;
+#ifdef CONFIG_SCSI_MULTIPATH
+	struct sd_mpath_disk *sd_mpath_disk;
+#endif
 
 	/*
 	 * disk_dev is used to show attributes in /sys/class/scsi_disk/,
-- 
2.43.0

