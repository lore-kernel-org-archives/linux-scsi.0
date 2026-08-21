Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137074C955A
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 14:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322312; cv=none; b=FTDlAEuMzk0DBx0KaaNhlip3rtONdr6W7lZknxTIrc9uTn6i7XQN2zLvbMPPsHQrUgzHWE0d1+5u9hyGD2icr8UZUtWdDJfFzEgpw6vOtM7ZqwEYT7j858ft8ZDvtg46vGzcyJueuzJoFaVSeD/1LdcE6i/oszNsElWwkiRoEQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322312; c=relaxed/simple;
	bh=vCqJoa7y6H7gvwP6YHrfRy6NervclZ/8iIAEMaffwKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKO/g6V/MlLFeOzjdmc6+E/e0Xw6/keFc3ovjeI/jnxQIvLWStWNitvSlOCtncfhD6OlPtryNB3rQHOXKEIISjufCeScxfHkrPMyYLldzHAK4KMhNtqRq0/+wYPk0kV4z/ho/OUXSZm9PCeAW/TTnGfeTt1yUsjc8t3YvqgQ0Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKqArgl6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKqArgl6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787322309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jr+Ir/Uj5p87dzJoYXiMsCrjOYIUZwTUAT4lIZUqasw=;
	b=UKqArgl69lgXcSImQtbZWubLy5vkvox/A8m7xuZii3MPYbCcIv99FvkuqY3ujSgB4GhSKN
	x6Aztm2D7FajaLYM5R4j4n+fTr3SEW2mFDTKqnbOLPnrY76CmRkM+ffVDdgGyl+n4jwJnh
	wxp1aeCgKfoXoplDeHdM99wxtvmNpis=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-8ijUOe0-MlG3XBzXr8Ko8w-1; Fri,
 21 Aug 2026 10:25:03 -0400
X-MC-Unique: 8ijUOe0-MlG3XBzXr8Ko8w-1
X-Mimecast-MFC-AGG-ID: 8ijUOe0-MlG3XBzXr8Ko8w_1787322302
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF9561801BF4;
	Fri, 21 Aug 2026 14:25:01 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 689D8180034F;
	Fri, 21 Aug 2026 14:24:59 +0000 (UTC)
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
	David Jeffery <djeffery@redhat.com>
Subject: [PATCH 6/9] driver core: async device shutdown infrastructure
Date: Fri, 21 Aug 2026 10:24:11 -0400
Message-ID: <20260821142414.150892-7-djeffery@redhat.com>
In-Reply-To: <20260821142414.150892-1-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
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
index b5493a7f8f22..f0de215963c6 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -989,6 +989,16 @@ Kernel parameters
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
index cd725466c32d..42cd77486e00 100644
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
 
@@ -3932,6 +3939,7 @@ bool kill_device(struct device *dev)
 	if (dev->p->dead)
 		return false;
 	dev->p->dead = true;
+	complete_all(&dev->p->complete);
 	return true;
 }
 EXPORT_SYMBOL_GPL(kill_device);
@@ -4910,6 +4918,40 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
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
@@ -4933,6 +4975,8 @@ static void __shutdown_one_device(struct device *dev)
 			dev_info(dev, "shutdown\n");
 		dev->driver->shutdown(dev);
 	}
+
+	complete_all(&dev->p->complete);
 }
 
 static void shutdown_one_device(struct device *dev)
@@ -4962,6 +5006,88 @@ static void shutdown_one_device(struct device *dev)
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
@@ -4974,6 +5100,14 @@ void device_shutdown(void)
 
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
@@ -4992,11 +5126,16 @@ void device_shutdown(void)
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
index 7b2baffdd2f5..f913d72218f8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -610,6 +610,7 @@ enum struct_device_flags {
 	DEV_FLAG_OF_NODE_REUSED = 7,
 	DEV_FLAG_OFFLINE_DISABLED = 8,
 	DEV_FLAG_OFFLINE = 9,
+	DEV_FLAG_ASYNC_SHUTDOWN = 10,
 
 	DEV_FLAG_COUNT
 };
@@ -827,6 +828,7 @@ __create_dev_flag_accessors(dma_coherent, DEV_FLAG_DMA_COHERENT);
 __create_dev_flag_accessors(of_node_reused, DEV_FLAG_OF_NODE_REUSED);
 __create_dev_flag_accessors(offline_disabled, DEV_FLAG_OFFLINE_DISABLED);
 __create_dev_flag_accessors(offline, DEV_FLAG_OFFLINE);
+__create_dev_flag_accessors(async_shutdown, DEV_FLAG_ASYNC_SHUTDOWN);
 
 #undef __create_dev_flag_accessors
 
-- 
2.55.0

