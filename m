Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA65531634
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 16:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663106; cv=none; b=HQqMUjSoyHKoDMVfLJKFtSoCRoqmCIWMHN8gKCB4Df9gt9MbkQ0ukry5kzF2IC9MX1QOvyxdlu4VBEL3hUQ+2agajif8m5U/tCMubmd1ns8bTG4Wl7u96b7Xc+XvvTvPjl/S8y0nNIGFWslF+U2J1Pnci4auJ2uZ848MP44DTxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663106; c=relaxed/simple;
	bh=kgZrPmx/NyFTZxQkq//uth9TK84g9fa8u7sjNfnFGag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJpbin8wAovrH9qTrRwL+yeDw1uryldwWNGPoDXFym6y7y7+4YybYfjDkctsg2QjV6YnaJ0fTZxk/WqUFq41R2SKQJVyd6KMCYWxMoVvG8nmDYcxLCaTUdtiCj7tIszjKRzr1vnhDVmf/60WcEHGfLYFIB74GxJfpfUTVvmR10o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cl+Ugi+j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cl+Ugi+j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789663104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=65taMl2yTlmMjt0Af/cEbsAbd3mCjNHU7Qdvsgj6qag=;
	b=cl+Ugi+j/aA1gG08e0PyoGXnLIp+irk7ida8osva8SnQGp77K1XeGwmENMCcwBMTIEUj12
	gQmV9wK/Om0cHl4lSLIjyJU4VasASO4gNUziRAlkw/rNXfNICbXa+5iaCOC+dZJvAS0HrW
	fMOYe2m211YuONXW2eI3c8ZSHMNwzxs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-170-fy8tx8a2PPu998dE2LH1tw-1; Thu,
 17 Sep 2026 12:38:19 -0400
X-MC-Unique: fy8tx8a2PPu998dE2LH1tw-1
X-Mimecast-MFC-AGG-ID: fy8tx8a2PPu998dE2LH1tw_1789663097
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4071A180B5F6;
	Thu, 17 Sep 2026 16:38:17 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.rmtusga.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B7C161800352;
	Thu, 17 Sep 2026 16:38:13 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: driver-core@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Tarun Sahu <tarunsahu@google.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	kexec@lists.infradead.org,
	"Ewan Milne" <emilne@redhat.com>,
	"John Meneghini" <jmeneghi@redhat.com>,
	"Lombardi, Maurizio" <mlombard@redhat.com>,
	"Bart Van Assche" <bvanassche@acm.org>,
	"John Garry" <john.g.garry@oracle.com>,
	"Jeremy Allison" <jallison@ciq.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	"Pasha Tatashin" <tatashin@google.com>,
	David Jeffery <djeffery@redhat.com>
Subject: [PATCH 6/9] driver core: async device shutdown infrastructure
Date: Thu, 17 Sep 2026 12:37:41 -0400
Message-ID: <20260917163744.191748-7-djeffery@redhat.com>
In-Reply-To: <20260917163744.191748-1-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
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

Enabled by default, async shutdown can be explicitly enabled or disabled
by using the kernel parameter "core.async_shutdown=<bool>"

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 .../admin-guide/kernel-parameters.txt         |  10 ++
 drivers/base/base.h                           |   2 +
 drivers/base/core.c                           | 141 +++++++++++++++++-
 include/linux/device.h                        |   2 +
 4 files changed, 154 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..6532bd0bbfdf 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -995,6 +995,16 @@ Kernel parameters
 			seconds. A value of 0 disables the blank timer.
 			Defaults to 0.
 
+	core.async_shutdown=
+			[KNL]
+			Format: <bool>
+			Enable or disable asynchronous shutdown support. When
+			enabled, on system shutdown unrelated devices flagged
+			as async shutdown compatible may be shut down in
+			parallel and asynchronously. When disabled, device
+			shutdown is performed serially and synchronously.
+			Enabled by default.
+
 	coredump_filter=
 			[KNL] Change the default value for
 			/proc/<pid>/coredump_filter.
diff --git a/drivers/base/base.h b/drivers/base/base.h
index a5b7abc10ff0..40dbf588a5d6 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -103,6 +103,7 @@ struct driver_private {
  *			   dev_err_probe() for later retrieval via debugfs
  * @device: pointer back to the struct device that this structure is
  *	    associated with.
+ * @complete: completion for device shutdown ordering
  * @dead: This device is currently either in the process of or has been
  *	  removed from the system. Any asynchronous events scheduled for this
  *	  device should exit without taking any action.
@@ -119,6 +120,7 @@ struct device_private {
 	const struct device_driver *async_driver;
 	char *deferred_probe_reason;
 	struct device *device;
+	struct completion complete;
 	u8 dead:1;
 };
 #define to_device_private_parent(obj)	\
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 93605698affc..7fee6043dd37 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/async.h>
 #include <linux/blkdev.h>
 #include <linux/cleanup.h>
 #include <linux/cpufreq.h>
@@ -37,6 +38,11 @@
 #include "physical_location.h"
 #include "power/power.h"
 
+static bool async_shutdown = true;
+module_param(async_shutdown, bool, 0644);
+MODULE_PARM_DESC(async_shutdown, "Enable asynchronous device shutdown support");
+static bool async_shutdown_enabled;
+
 /* Device links support. */
 static LIST_HEAD(deferred_sync);
 static unsigned int defer_sync_state_count = 1;
@@ -3627,6 +3633,7 @@ static int device_private_init(struct device *dev)
 	klist_init(&dev->p->klist_children, klist_children_get,
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->p->deferred_probe);
+	init_completion(&dev->p->complete);
 	return 0;
 }
 
@@ -3925,6 +3932,7 @@ bool kill_device(struct device *dev)
 	if (dev->p->dead)
 		return false;
 	dev->p->dead = true;
+	complete_all(&dev->p->complete);
 	return true;
 }
 EXPORT_SYMBOL_GPL(kill_device);
@@ -4903,6 +4911,40 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
 	return error;
 }
 
+static bool wants_async_shutdown(struct device *dev)
+{
+	return async_shutdown_enabled && dev_async_shutdown(dev);
+}
+
+static int wait_for_device_shutdown(struct device *dev, void *data)
+{
+	bool async = *(bool *)data;
+
+	if (!dev->p || !device_is_registered(dev))
+		return 0;
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
 	if (!dev->p || dev->p->dead)
@@ -4926,6 +4968,8 @@ static void __shutdown_one_device(struct device *dev)
 			dev_info(dev, "shutdown\n");
 		dev->driver->shutdown(dev);
 	}
+
+	complete_all(&dev->p->complete);
 }
 
 static void shutdown_one_device(struct device *dev)
@@ -4955,6 +4999,88 @@ static void shutdown_one_device(struct device *dev)
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
+
+	dev_clear_async_shutdown(dev);
+	return false;
+}
+
+
+static void start_async_shutdown_devices(void)
+{
+	struct device *dev, *next, *ndev, *needs_put = NULL;
+	bool clear_async = false;
+
+	if (!async_shutdown_enabled)
+		return;
+
+	spin_lock(&devices_kset->list_lock);
+restart:
+	list_for_each_entry_safe_reverse(dev, next, &devices_kset->list,
+					 kobj.entry) {
+		if (wants_async_shutdown(dev)) {
+			if (clear_async) {
+				dev_clear_async_shutdown(dev);
+				continue;
+			}
+			/* one device reference for this function */
+			get_device(dev);
+			/* another to pass to the async task */
+			get_device(dev);
+
+			if (!list_entry_is_head(next, &devices_kset->list,
+						kobj.entry))
+				ndev = get_device(next);
+			else
+				ndev = NULL;
+			spin_unlock(&devices_kset->list_lock);
+
+			if (shutdown_device_async(dev)) {
+				spin_lock(&devices_kset->list_lock);
+				list_del_init(&dev->kobj.entry);
+				spin_unlock(&devices_kset->list_lock);
+			} else {
+				/*
+				 * async failed, clean up extra reference
+				 * and run shutdown from the sync shutdown loop
+				 */
+				clear_async = true;
+				put_device(dev);
+			}
+			put_device(dev);
+
+			if (needs_put)
+				put_device(needs_put);
+			needs_put = ndev;
+			spin_lock(&devices_kset->list_lock);
+			/*
+			 * If the next device has been marked dead while the
+			 * spinlock was released, or if it has been unlinked
+			 * from the list, it may no longer be on the
+			 * devices_kset list. Restart the list walk to be safe.
+			 */
+			if (ndev && (ndev->p->dead || list_empty(&ndev->kobj.entry)))
+				goto restart;
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
@@ -4968,6 +5094,14 @@ void device_shutdown(void)
 
 	cpufreq_suspend();
 
+	async_shutdown_enabled = async_shutdown;
+
+	/*
+	 * Start async device threads where possible to maximize potential
+	 * parallelism and minimize false dependency on unrelated sync devices
+	 */
+	start_async_shutdown_devices();
+
 	spin_lock(&devices_kset->list_lock);
 	/*
 	 * Walk the devices list backward, shutting down each in turn.
@@ -4986,11 +5120,16 @@ void device_shutdown(void)
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
index aee79fd6b32b..1ebafa798462 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -612,6 +612,7 @@ enum struct_device_flags {
 	DEV_FLAG_OF_NODE_REUSED = 7,
 	DEV_FLAG_OFFLINE_DISABLED = 8,
 	DEV_FLAG_OFFLINE = 9,
+	DEV_FLAG_ASYNC_SHUTDOWN = 10,
 
 	DEV_FLAG_COUNT
 };
@@ -829,6 +830,7 @@ __create_dev_flag_accessors(dma_coherent, DEV_FLAG_DMA_COHERENT);
 __create_dev_flag_accessors(of_node_reused, DEV_FLAG_OF_NODE_REUSED);
 __create_dev_flag_accessors(offline_disabled, DEV_FLAG_OFFLINE_DISABLED);
 __create_dev_flag_accessors(offline, DEV_FLAG_OFFLINE);
+__create_dev_flag_accessors(async_shutdown, DEV_FLAG_ASYNC_SHUTDOWN);
 
 #undef __create_dev_flag_accessors
 
-- 
2.55.0

