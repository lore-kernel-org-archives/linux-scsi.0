Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8A8341AC7
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 02:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256115; cv=none; b=BOw2QHgpwXZONNhYn38n4eNiK0Y2rr1lwH+BEMu8ce15WxH5Bohyt3y2u/CUJdoXatkhSlsJi920yH8NZzWnf0SpjFWPaT5kYFdeBOZMGF/wDvVXlz8W7HPCuj6cg2esTFGdsCIVCMj9ilwi+SMCbeeYieC4XUadnNjfZaWMn04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256115; c=relaxed/simple;
	bh=vtM/iS4dqfQrB9RkKv94sd0lDNxuzz1siA09RPr39Tc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ida5v56PsqFtPDTmpl3NN6PFM23sYZF0Wk94BX6Bp2EGpEgjmM+lMoVaArKxkNbqBvfLiO+YZK0TPYG4MDPz7h1Uvm4fpCZguQnkDISyDu2WQn9hJftUsfYPZ/itwIA15gpZZRF8bUtQiPoe6Z2FvvDLmVP1NiFZLcveBcYrFG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XkVABHwx; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XkVABHwx"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c15f4732dfaso830880366b.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 19:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784256108; x=1784860908; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xttAFdPKvha9rdtsgqnJxKaba7YH7uAmltDFNffmYC0=;
        b=XkVABHwxSucrUXIg/csVgZDF5wKQAmvdkSF5r3ectuvufF624aJAqH54aGm2sd1U+m
         SeUk3NFJ/Tzoz59a4ufKX8njP+zMbzhUe1ET6K4LS6O1/LfXwgpcfYIqUPOli4q1KJO/
         yqra2yY4ewWmdD/61aDPnZLzJr3Ye8rmQ3ok1iyKarT5kaSSbvMT94JA0szF9jicz8EG
         w2VRcQnIrkdCxrgyH6V6YsZwJx9nLGhnwSc+xUa5Dj/MSqytfeof1k3ynGFVuz/r6pP+
         xXCMrzuW+CKi6yzg9Tp2h+oU2Vujp5P5TqnUPkm4DR5KuRbBUc6yuKYM9tG0MNk5J6F4
         tJBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784256108; x=1784860908;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xttAFdPKvha9rdtsgqnJxKaba7YH7uAmltDFNffmYC0=;
        b=NdZLPivL358oY+oG48zAPfJclIGQdDLa22wKkqrjPqzFRzEiQIIMcvx7LzxkDnjxNp
         /eXXpuSqe5uSgKpz3J04cbCpXL6k/WwViYdgsjRQQvIVWceRXb2ViEjmtgo1TZblAKse
         OyRPrma86iFJz3bpDT4xwHlTbLJYzTl9M4k4K5sHLLx26wJx0q+zZuv8BMMylzRT/sc/
         KzB8+ZKZxoiZm5ydVGvp61h9dwRlZDxHxMdZmBuZAJKRCNjK1Cd/gqBNGSHaaZ6vhoy6
         cUcVWswcmI73+HLD9eWWm8zFAM5vR82zx9M+98q9SqLirV4KFxEeK0Qc9bgYYjKRKsom
         2wbA==
X-Forwarded-Encrypted: i=1; AHgh+RoKzGUhUyM6WVKr2sn0YshkPx+16sN9WiKLfJsby1uB3Erceux74Pyb3nNNbXIQvUUkWNBHGJGJfdWp@vger.kernel.org
X-Gm-Message-State: AOJu0YzqeyAaZgDAwyheaZ2twZh78Io5fEt9mBGPG242BfCbeHv6/Jyl
	D54iHogq/pKvVm1eyNMLiK1NBi8sEPw1LEOZNm8OAUmVUbC2zVY+v0jwSNeax+WbtGrKhSiE31y
	CzlZEQvwWK5Xv+z8tZw==
X-Received: from ejbga4.prod.google.com ([2002:a17:906:b844:b0:c12:583d:cdca])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:724b:b0:c15:a06c:2bc6 with SMTP id a640c23a62f3a-c16b4834e99mr15780066b.47.1784256107376;
 Thu, 16 Jul 2026 19:41:47 -0700 (PDT)
Date: Thu, 16 Jul 2026 23:04:09 +0000
In-Reply-To: <20260716230411.2767394-1-tarunsahu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260716230411.2767394-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260716230411.2767394-6-tarunsahu@google.com>
Subject: [PATCH v19 5/7] driver core: async device shutdown infrastructure
From: Tarun Sahu <tarunsahu@google.com>
To: Shuah Khan <skhan@linuxfoundation.org>, Danilo Krummrich <dakr@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Rafael J. Wysocki" <rafael@kernel.org>
Cc: bvanassche@acm.org, john.g.garry@oracle.com, mlombard@redhat.com, 
	loberman@redhat.com, mclapinski@google.com, dmatlack@google.com, 
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, jordanrichards@google.com, souravsgl@google.com, 
	stuart.w.hayes@gmail.com, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, emilne@redhat.com, jmeneghi@redhat.com, 
	linux-scsi@vger.kernel.org, David Jeffery <djeffery@redhat.com>, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"

From: David Jeffery <djeffery@redhat.com>

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
index 31f95e86856e..55287f13b8d1 100644
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
@@ -3623,6 +3629,7 @@ static int device_private_init(struct device *dev)
 	klist_init(&dev->p->klist_children, klist_children_get,
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->p->deferred_probe);
+	init_completion(&dev->p->complete);
 	return 0;
 }
 
@@ -3928,6 +3935,7 @@ bool kill_device(struct device *dev)
 	if (dev->p->dead)
 		return false;
 	dev->p->dead = true;
+	complete_all(&dev->p->complete);
 	return true;
 }
 EXPORT_SYMBOL_GPL(kill_device);
@@ -4898,6 +4906,40 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
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
@@ -4921,6 +4963,8 @@ static void __shutdown_one_device(struct device *dev)
 			dev_info(dev, "shutdown\n");
 		dev->driver->shutdown(dev);
 	}
+
+	complete_all(&dev->p->complete);
 }
 
 static void shutdown_one_device(struct device *dev)
@@ -4950,6 +4994,88 @@ static void shutdown_one_device(struct device *dev)
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
@@ -4962,6 +5088,14 @@ void device_shutdown(void)
 
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
@@ -4980,11 +5114,16 @@ void device_shutdown(void)
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
2.55.0.229.g6434b31f56-goog

