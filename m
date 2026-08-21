Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37704C0404
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 14:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322302; cv=none; b=a4Dc3fDhw2L1372TydQgElTcU3uS7GOgJSO665kB8vcFZ3bI9gVsxn2XVI4bKaNx5gcKMLSInM8qE+G1YzGqGOcBhYeN99kYtYlePzt+2WWLYHOtvJKWGi6kLBR9WN2WjJufPpO6ugjcCQpTEbEzjeMbcmbch9SytK510Rz9Ez4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322302; c=relaxed/simple;
	bh=W6FS670jxUF+AdAIfuFCT+t+f8ySA3Fg6X9MUK/oz/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHypFtgcZz+N9SKDVhKOkavKgAZUAGSx7PyuY6Rn0wj3QJCLkiQ/rO1bDerGl/e/SmTkVBnRsz9aBoTzc2bY8SdFaIJ7cnBl/jM7RUySznvogMTq31qxVutouTvMZwPb/YZLzBtHv91MuGETurQpK0et5EOEvNNoSXBSI+VlgPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nn1jXBoe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nn1jXBoe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787322296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BvLQwuQsxkf9F2xZNCYKTp5KyAP5LYYETgZttqdI30g=;
	b=Nn1jXBoe2Kk/JU7OB3NfaLojqrNf8jJt1Bu5A6GmM/1K5OWQ1fZXGthvFbUCdLaEHdLCF1
	g9M6Ve1w4O1b+v00HXwYwRKDwWse95wHfSqkIc3RLmAiGFT0O/Jq7PsRGUqFGgiAhZBj49
	jsRM/blM6JhbwaTKwgyir8j1mlFBv/M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-377-RH6zw2N2ODGYKZGfVV-FQg-1; Fri,
 21 Aug 2026 10:24:52 -0400
X-MC-Unique: RH6zw2N2ODGYKZGfVV-FQg-1
X-Mimecast-MFC-AGG-ID: RH6zw2N2ODGYKZGfVV-FQg_1787322290
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3688C1955BFE;
	Fri, 21 Aug 2026 14:24:50 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CAF8718005BB;
	Fri, 21 Aug 2026 14:24:47 +0000 (UTC)
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
Subject: [PATCH 2/9] driver core: prevent device_add() during system shutdown
Date: Fri, 21 Aug 2026 10:24:07 -0400
Message-ID: <20260821142414.150892-3-djeffery@redhat.com>
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
device_add incase of these states of the system.

While device_add() performs an initial check of system_is_shutting_down(),
a race window exists between this initial check and kobject_add(),
during which device_shutdown() may already be scanning devices_kset->list.
If device_shutdown() passes the device after kobject_add() registers it
onto devices_kset->list, device_add() would otherwise complete device
initialization and driver matching, leaving an active device running
after system shutdown finishes.

Fix this TOCTOU race by re-checking system_is_shutting_down() under
devices_kset->list_lock right after kobject_add().

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 83263e3fa5d4..bd9c2921e326 100644
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
@@ -3654,6 +3670,11 @@ int device_add(struct device *dev)
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
@@ -3703,6 +3724,18 @@ int device_add(struct device *dev)
 		goto Error;
 	}
 
+	/*
+	 * Check system_state again under list_lock to prevent a TOCTOU race
+	 * where device_shutdown() runs concurrently and misses this device.
+	 */
+	spin_lock(&devices_kset->list_lock);
+	if (unlikely(system_is_shutting_down())) {
+		spin_unlock(&devices_kset->list_lock);
+		error = -ESHUTDOWN;
+		goto ShutdownError;
+	}
+	spin_unlock(&devices_kset->list_lock);
+
 	/* notify platform of device entry */
 	device_platform_notify(dev);
 
@@ -3822,6 +3855,7 @@ int device_add(struct device *dev)
  attrError:
 	device_platform_notify_remove(dev);
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
+ ShutdownError:
 	glue_dir = get_glue_dir(dev);
 	kobject_del(&dev->kobj);
  Error:
-- 
2.55.0

