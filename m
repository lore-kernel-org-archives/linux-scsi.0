Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313C24AD4BA
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368946; cv=none; b=UZAEUhjfQ80I+3dqUwdK4N61eHF22fRoaa1pgdmfRek/0AAmBLQVDOJeMQC1jgDiBAHtZNjXPl60hDdOrZCfDufvjrtJ2hHCtY7Qln88SWM6PkHWz4RPK7+XHtjyiE/tv8bJxCo0MXeyr4x0QGTfJJIicfWsKoZTaSShqEWHMLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368946; c=relaxed/simple;
	bh=IWHexqUg6916nspV1VRDVgr5pFAZ+u0l6fG7BM3sYa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vw0gaohr5orCMIm1yfiBTqlTu/XGy0rbZPXOki6dg5qIoeaXFEha2Uf3WSeMLEDTzm8xYOrkBQEkGm+wt4Jky8vbv8sa1eF9klay3yRILk3M48OrD7bSnIRiyUzn86+zZIzwJU8J/feueF66ovRDlCsVnKsiYlBhPxIoaJYgFnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N6n6g9tM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N6n6g9tM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788368944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxOEy23CdjWO+tWUfg0nkvoqJt9R/kFtS/CvH38ECoU=;
	b=N6n6g9tMLNMUSo03aWaSLR/9loP6ppYI5MtkRAnvQXqrpRhk4+Jy7Nmf17K5YHfwr2P5/z
	EKMVq96ogUi3RzgSOjn+acNRqSKeq0OlXdb82pRpTrmy0IOMXCOgTBXcNFkngXSll8IF5N
	rbCoQ7ppz9WvSseEIztLm0SUrbV9zCg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-278-BT5SXAruNeqn80UTKMXMYQ-1; Wed,
 02 Sep 2026 13:08:58 -0400
X-MC-Unique: BT5SXAruNeqn80UTKMXMYQ-1
X-Mimecast-MFC-AGG-ID: BT5SXAruNeqn80UTKMXMYQ_1788368936
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05CC31954223;
	Wed,  2 Sep 2026 17:08:56 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.rmtusga.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B49031955D8D;
	Wed,  2 Sep 2026 17:08:52 +0000 (UTC)
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
Subject: [PATCH 2/9] driver core: prevent device_add() during system shutdown
Date: Wed,  2 Sep 2026 13:07:27 -0400
Message-ID: <20260902170734.95504-3-djeffery@redhat.com>
In-Reply-To: <20260902170734.95504-1-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Tarun Sahu <tarunsahu@google.com>

In Async device shutdown, device_kset->list lock is released to handle
asynchronisation and hold again to get entry from device_kset->list.
Which will leave window when device_add can try to add the device to
device_kset list and temper with ongoing shutdown process. New added
device can be async type or sync type and might also introduce new
dependency which can cause device_shutdown path to deadlock. S is
waiting C to finish but C is never scheduled as it was added recently
from device_add path. And C can only be scheduled when main loops
continue to reach to C which is waiting on S.

So, When a system enters shutdown (SYSTEM_HALT, SYSTEM_POWER_OFF, or
SYSTEM_RESTART), new devices should not be allowed to be added.
Adding system_state check (system_is_shutting_down()) to avoid
device_add incase of these states of the system. And use srcu so the
device shutdown operation can synchronize device_add and ensure any
device_add in progress is finished.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 83263e3fa5d4..bce555dd74f6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -47,6 +47,22 @@ static bool fw_devlink_drv_reg_done;
 static bool fw_devlink_best_effort;
 static struct workqueue_struct *device_link_wq;
 
+/**
+ * system_is_shutting_down - Check if system state is not active.
+ *
+ * When system state is not active and in shutdown state, new devices
+ * should not be allowed to be added.
+ *
+ * If system_state is SYSTEM_HALT || SYSTEM_POWER_OFF || SYSTEM_RESTART
+ * this function will return true.
+ */
+static inline bool system_is_shutting_down(void)
+{
+	return system_state == SYSTEM_HALT ||
+	       system_state == SYSTEM_POWER_OFF ||
+	       system_state == SYSTEM_RESTART;
+}
+
 /**
  * __fwnode_link_add - Create a link between two fwnode_handles.
  * @con: Consumer end of the link.
@@ -3614,6 +3630,9 @@ static int device_private_init(struct device *dev)
 	return 0;
 }
 
+
+DEFINE_STATIC_SRCU(device_add_srcu);
+
 /**
  * device_add - add device to device hierarchy.
  * @dev: device.
@@ -3647,13 +3666,20 @@ int device_add(struct device *dev)
 	struct device *parent;
 	struct kobject *kobj;
 	struct class_interface *class_intf;
-	int error = -EINVAL;
+	int idx, error = -EINVAL;
 	struct kobject *glue_dir = NULL;
 
+	idx = srcu_read_lock(&device_add_srcu);
+
 	dev = get_device(dev);
 	if (!dev)
 		goto done;
 
+	if (unlikely(system_is_shutting_down())) {
+		error = -ESHUTDOWN;
+		goto done;
+	}
+
 	if (!dev->p) {
 		error = device_private_init(dev);
 		if (error)
@@ -3803,6 +3829,7 @@ int device_add(struct device *dev)
 	}
 done:
 	put_device(dev);
+	srcu_read_unlock(&device_add_srcu, idx);
 	return error;
  SysEntryError:
 	if (MAJOR(dev->devt))
@@ -4877,6 +4904,7 @@ void device_shutdown(void)
 
 	wait_for_device_probe();
 	device_block_probing();
+	synchronize_srcu(&device_add_srcu);
 
 	cpufreq_suspend();
 
-- 
2.55.0

