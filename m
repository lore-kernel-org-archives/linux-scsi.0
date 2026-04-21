Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8D51509AB
	for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2026 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776792711; cv=none; b=aUXz1EOdiOWyvh02OX0vexMwgzUhp501QPmTHIrDKeJ/jG7DKnih+/cAOnn6Hjq4zoO/qPfm48fCpt5pPzhCx+XJCZZ8m1RNNnCKR+q9Uu7PfoWsNLG2yyIn5+yYPRwg2C7qGLPR0wfUcqo1F9K6ZvSBMppSSnJJBM64EZ3/a9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776792711; c=relaxed/simple;
	bh=Up5R66uNJccLdF+pYE2C2qZs8VYdophbwQPeQ7JrUkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnUmpI38U08rNmz0hkZ1AaC6sBOq8+mvrkcHE+TyBz8aEydyfnRmiPEpVF0tYb84EeMk/wBhB7TKkkow1cwN0LIVv88cKmfatlDxDdSey1QkDqjCd1KIOYtoZtbX9KP1PYgKe7eDmUuCMina+tjG4JjR0ClUusyffGPTb2faCog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iy7bwmis; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iy7bwmis"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776792709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=knAb5qavuH774ilkAdIoKt+5CocY+t8/ED+zsIsUsjs=;
	b=iy7bwmisMcoM0B5LUzlZWL2G1BlsJ60VmLG+kceBC+01EvycM2eYlLnm2QtvzxbIL8hZbw
	9uro/caRIEfw4rO4t9D5sPrdlVWyDbFaGLEadY7K/vGLmNGb+1F4HwNmE9nJ+Y3K80B1xM
	mJNRSUStG81tyVgH1Jli96tYiNS13w4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-dx62h7yTNNygahVmL7k_ww-1; Tue,
 21 Apr 2026 13:31:45 -0400
X-MC-Unique: dx62h7yTNNygahVmL7k_ww-1
X-Mimecast-MFC-AGG-ID: dx62h7yTNNygahVmL7k_ww_1776792703
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E33AC1956088;
	Tue, 21 Apr 2026 17:31:42 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.64.242])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2D5591956095;
	Tue, 21 Apr 2026 17:31:37 +0000 (UTC)
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
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	David Jeffery <djeffery@redhat.com>
Subject: [PATCH 3/5] driver core: async device shutdown infrastructure
Date: Tue, 21 Apr 2026 13:31:32 -0400
Message-ID: <20260421173133.7963-1-djeffery@redhat.com>
In-Reply-To: <e9c34e71-e5bf-40f3-9997-ee08c6204431@oracle.com>
References: <e9c34e71-e5bf-40f3-9997-ee08c6204431@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Patterned after async suspend, allow devices to mark themselves as wanting
to perform async shutdown. Devices using async shutdown wait only for their
dependencies to shutdown before executing their shutdown routine.

Sync shutdown devices are shut down one at a time and will only wait for an
async shutdown device if the async device is a dependency.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---

Updated to resolve conflicts with latest Linus tree


 drivers/base/base.h    |   2 +
 drivers/base/core.c    | 101 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/device.h |  14 +++++-
 3 files changed, 115 insertions(+), 2 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 30b416588617..8b155a91ac3a 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -116,6 +116,7 @@ struct driver_type {
  * @device: pointer back to the struct device that this structure is
  *	    associated with.
  * @driver_type: The type of the bound Rust driver.
+ * @complete: completion for device shutdown ordering
  * @dead: This device is currently either in the process of or has been
  *	  removed from the system. Any asynchronous events scheduled for this
  *	  device should exit without taking any action.
@@ -135,6 +136,7 @@ struct device_private {
 #ifdef CONFIG_RUST
 	struct driver_type driver_type;
 #endif
+	struct completion complete;
 	u8 dead:1;
 };
 #define to_device_private_parent(obj)	\
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 00979555995f..92f788fd813d 100644
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
@@ -3540,6 +3545,7 @@ static int device_private_init(struct device *dev)
 	klist_init(&dev->p->klist_children, klist_children_get,
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->p->deferred_probe);
+	init_completion(&dev->p->complete);
 	return 0;
 }
 
@@ -4799,6 +4805,37 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
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
@@ -4822,6 +4859,8 @@ static void __shutdown_one_device(struct device *dev)
 		dev->driver->shutdown(dev);
 	}
 
+	complete_all(&dev->p->complete);
+
 	device_unlock(dev);
 }
 
@@ -4843,6 +4882,55 @@ static void shutdown_one_device(struct device *dev)
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
+	if (needs_put)
+		put_device(needs_put);
+}
+
 /**
  * device_shutdown - call ->shutdown() on each device to shutdown.
  */
@@ -4855,6 +4943,12 @@ void device_shutdown(void)
 
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
@@ -4873,11 +4967,16 @@ void device_shutdown(void)
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
index 9c8fde6a3d86..424a229d69df 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -615,6 +615,8 @@ enum struct_device_flags {
  * @dma_skip_sync: DMA sync operations can be skipped for coherent buffers.
  * @dma_iommu: Device is using default IOMMU implementation for DMA and
  *		doesn't rely on dma_ops structure.
+ * @async_shutdown: Device shutdown may be run asynchronously and in parallel
+ *		to the shutdown of unrelated devices
  * @flags:	DEV_FLAG_XXX flags. Use atomic bitfield operations to modify.
  *
  * At the lowest level, every device in a Linux system is represented by an
@@ -738,7 +740,7 @@ struct device {
 #ifdef CONFIG_IOMMU_DMA
 	bool			dma_iommu:1;
 #endif
-
+	bool			async_shutdown:1;
 	DECLARE_BITMAP(flags, DEV_FLAG_COUNT);
 };
 
@@ -969,6 +971,16 @@ static inline bool device_async_suspend_enabled(struct device *dev)
 	return !!dev->power.async_suspend;
 }
 
+static inline void device_enable_async_shutdown(struct device *dev)
+{
+	dev->async_shutdown = true;
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

