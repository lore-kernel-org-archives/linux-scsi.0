Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A5B30C354
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929563; cv=none; b=i7zo1CuVISS0hI2OdATtiLE1Qw9lqwa8jc4ubsBmuWk/lofoVKAESIse0P9D6tDYj9NdpqfECxY5nUR9iLeJHTN7iEAGAV1n2sbyLkxN1Tkz9Or6XAn8DG/MuaPCnIjYzjTkMkkUAs8Q6vAIJZDsRG9AfssoQAGbZONFOljaAs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929563; c=relaxed/simple;
	bh=6mSehbpF+RItZ1Q8Et60jCpZ0rREFfenJveoiK1gS60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfG6rAxOp2xEhxd64wVFEyCUOh/9Kjpj159zZycmBjd7qL6wGqqJLzAQuFo6E5v/ConxFpBkTluHvPw4j7C0ozJihcqTYBYMAVwh9Hi92hBJgM/pu/8NdsQw+HBJdLiAsHJvZ5jJkLg4EIMcG/4Iqkg66+w/99utY7pDJdxcWJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RikB2As1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RikB2As1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773929558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OQ5/Jf7lfLb4nnTLYmHQMRrsCz1ABsjpH0OOeVo4OKY=;
	b=RikB2As18LG++aZ5CV5PrzffqTMEAZ3NKbe4R9aixfcKXMv9TKB6jI2dpol0B2Gea6QRik
	ZNcHpyX/qunr+NcsWxpBjV6kxUd2JJ7bsv0gNZiNskGq7c/xo1RdZSlIzqIg1A9Tskiz4g
	9x6zYeuHVfb1iOgcKflG6Xc/EzHqloY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-pzCk9WJuMxOC6OKCAGtQGg-1; Thu,
 19 Mar 2026 10:12:35 -0400
X-MC-Unique: pzCk9WJuMxOC6OKCAGtQGg-1
X-Mimecast-MFC-AGG-ID: pzCk9WJuMxOC6OKCAGtQGg_1773929536
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECAF019560A7;
	Thu, 19 Mar 2026 14:12:15 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.66.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BFC771800576;
	Thu, 19 Mar 2026 14:12:11 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: Tarun Sahu <tarunsahu@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	=?UTF-8?q?Micha=C5=82=20C=C5=82api=C5=84ski?= <mclapinski@google.com>,
	Jordan Richards <jordanrichards@google.com>,
	Ewan Milne <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Lombardi, Maurizio" <mlombard@redhat.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Helgaas <helgaas@kernel.org>,
	David Jeffery <djeffery@redhat.com>
Subject: [PATCH 3/5] driver core: async device shutdown infrastructure
Date: Thu, 19 Mar 2026 10:11:40 -0400
Message-ID: <20260319141142.5781-4-djeffery@redhat.com>
In-Reply-To: <20260319141142.5781-1-djeffery@redhat.com>
References: <20260319141142.5781-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Patterned after async suspend, allow devices to mark themselves as wanting
to perform async shutdown. Devices using async shutdown wait only for their
dependencies to shutdown before executing their shutdown routine.

Sync shutdown devices are shut down one at a time and will only wait for an
async shutdown device if the async device is a dependency.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/base.h    |   2 +
 drivers/base/core.c    | 104 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/device.h |  13 ++++++
 3 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 79d031d2d845..ea2a039e7907 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -113,6 +113,7 @@ struct driver_type {
  * @device - pointer back to the struct device that this structure is
  * associated with.
  * @driver_type - The type of the bound Rust driver.
+ * @complete - completion for device shutdown ordering
  * @dead - This device is currently either in the process of or has been
  *	removed from the system. Any asynchronous events scheduled for this
  *	device should exit without taking any action.
@@ -132,6 +133,7 @@ struct device_private {
 #ifdef CONFIG_RUST
 	struct driver_type driver_type;
 #endif
+	struct completion complete;
 	u8 dead:1;
 };
 #define to_device_private_parent(obj)	\
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2e9094f5c5aa..53568b820a13 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/async.h>
 #include <linux/blkdev.h>
 #include <linux/cleanup.h>
 #include <linux/cpufreq.h>
@@ -37,6 +38,10 @@
 #include "physical_location.h"
 #include "power/power.h"
 
+static bool async_shutdown = true;
+module_param(async_shutdown, bool, 0644);
+MODULE_PARM_DESC(async_shutdown, "Enable asynchronous device shutdown support");
+
 /* Device links support. */
 static LIST_HEAD(deferred_sync);
 static unsigned int defer_sync_state_count = 1;
@@ -3538,6 +3543,7 @@ static int device_private_init(struct device *dev)
 	klist_init(&dev->p->klist_children, klist_children_get,
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->p->deferred_probe);
+	init_completion(&dev->p->complete);
 	return 0;
 }
 
@@ -4782,6 +4788,37 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
 	return error;
 }
 
+static bool wants_async_shutdown(struct device *dev)
+{
+	return async_shutdown && dev->async_shutdown;
+}
+
+static int wait_for_device_shutdown(struct device *dev, void *data)
+{
+	bool async = *(bool *)data;
+
+	if (async || wants_async_shutdown(dev))
+		wait_for_completion(&dev->p->complete);
+
+	return 0;
+}
+
+static void wait_for_shutdown_dependencies(struct device *dev, bool async)
+{
+	struct device_link *link;
+	int idx;
+
+	device_for_each_child(dev, &async, wait_for_device_shutdown);
+
+	idx = device_links_read_lock();
+
+	dev_for_each_link_to_consumer(link, dev)
+		if (!device_link_flag_is_sync_state_only(link->flags))
+			wait_for_device_shutdown(link->consumer, &async);
+
+	device_links_read_unlock(idx);
+}
+
 static void __shutdown_one_device(struct device *dev)
 {
 	device_lock(dev);
@@ -4805,6 +4842,8 @@ static void __shutdown_one_device(struct device *dev)
 		dev->driver->shutdown(dev);
 	}
 
+	complete_all(&dev->p->complete);
+
 	device_unlock(dev);
 }
 
@@ -4823,6 +4862,58 @@ static void shutdown_one_device(struct device *dev)
 	put_device(dev);
 }
 
+static void async_shutdown_handler(void *data, async_cookie_t cookie)
+{
+	struct device *dev = data;
+
+	wait_for_shutdown_dependencies(dev, true);
+	shutdown_one_device(dev);
+}
+
+static bool shutdown_device_async(struct device *dev)
+{
+	if (async_schedule_dev_nocall(async_shutdown_handler, dev))
+		return true;
+	return false;
+}
+
+
+static void early_async_shutdown_devices(void)
+{
+	struct device *dev, *next, *needs_put = NULL;
+
+	if (!async_shutdown)
+		return;
+
+	spin_lock(&devices_kset->list_lock);
+
+	list_for_each_entry_safe_reverse(dev, next, &devices_kset->list,
+					 kobj.entry) {
+		if (wants_async_shutdown(dev)) {
+			get_device(dev->parent);
+			get_device(dev);
+
+			if (shutdown_device_async(dev)) {
+				list_del_init(&dev->kobj.entry);
+			} else {
+				/*
+				 * async failed, clean up extra references
+				 * and run from the standard shutdown loop
+				 */
+				needs_put = dev;
+				break;
+			}
+		}
+	}
+
+	spin_unlock(&devices_kset->list_lock);
+
+	if (needs_put) {
+		put_device(needs_put->parent);
+		put_device(needs_put);
+	}
+}
+
 /**
  * device_shutdown - call ->shutdown() on each device to shutdown.
  */
@@ -4835,6 +4926,12 @@ void device_shutdown(void)
 
 	cpufreq_suspend();
 
+	/*
+	 * Start async device threads where possible to maximize potential
+	 * parallelism and minimize false dependency on unrelated sync devices
+	 */
+	early_async_shutdown_devices();
+
 	spin_lock(&devices_kset->list_lock);
 	/*
 	 * Walk the devices list backward, shutting down each in turn.
@@ -4859,11 +4956,16 @@ void device_shutdown(void)
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
 
-		shutdown_one_device(dev);
+		if (!wants_async_shutdown(dev) || !shutdown_device_async(dev)) {
+			wait_for_shutdown_dependencies(dev, false);
+			shutdown_one_device(dev);
+		}
 
 		spin_lock(&devices_kset->list_lock);
 	}
 	spin_unlock(&devices_kset->list_lock);
+
+	async_synchronize_full();
 }
 
 /*
diff --git a/include/linux/device.h b/include/linux/device.h
index 0be95294b6e6..da1db7d235c9 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -551,6 +551,8 @@ struct device_physical_location {
  * @dma_skip_sync: DMA sync operations can be skipped for coherent buffers.
  * @dma_iommu: Device is using default IOMMU implementation for DMA and
  *		doesn't rely on dma_ops structure.
+ * @async_shutdown: Device shutdown may be run asynchronously and in parallel
+ *		to the shutdown of unrelated devices
  *
  * At the lowest level, every device in a Linux system is represented by an
  * instance of struct device. The device structure contains the information
@@ -669,6 +671,7 @@ struct device {
 #ifdef CONFIG_IOMMU_DMA
 	bool			dma_iommu:1;
 #endif
+	bool			async_shutdown:1;
 };
 
 /**
@@ -824,6 +827,16 @@ static inline bool device_async_suspend_enabled(struct device *dev)
 	return !!dev->power.async_suspend;
 }
 
+static inline bool device_enable_async_shutdown(struct device *dev)
+{
+	return dev->async_shutdown = true;
+}
+
+static inline bool device_async_shutdown_enabled(struct device *dev)
+{
+	return !!dev->async_shutdown;
+}
+
 static inline bool device_pm_not_required(struct device *dev)
 {
 	return dev->power.no_pm;
-- 
2.53.0

