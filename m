Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B963730C602
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773249156; cv=none; b=ieChkp1Jzy+Ejj7+Y8umF2b5gJirWAUYzCrHki8vlyU/kaxsy/BYEa932xhEX0bm+Dra5RntDGhFcyz4bCC0422raozpxjkqTWbzTga60PLFwqQdKQ/HZvc/t17L0ZLvI3Vq+yLTgIgJcVXxakGXqV41Vg7wDrVN4H0QqgrBXdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773249156; c=relaxed/simple;
	bh=smf1cv/33+w8lYWstEZFJTeO9XD8pEIQ+6W5VjFsI1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYEvp3Zz793wDSYWS/RBEklB1PfQvt2sE9PJNZniVSrbRQvLfwxAfNTooFBUFr736oCWpwRvu93f76uovPbR1HnO0eye+pjqfRr+16mXrY3rk5ahXXBc4cdXbOfzD98QKqnzIZB+8I8uX1hoRY1pHbddVLohobxtah57FGuADEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A2kMJ7zD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A2kMJ7zD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773249154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9T2YSKJkYK3HIdavys7SPymrtMl/e3/IqMElOMUrpxc=;
	b=A2kMJ7zDO7+3J/uITZmPwtdVbM5Gl2wsYu0F2Jfr/uL4u3HzSW5612YW7kpVer7bWEoCNl
	KM+Hov6/bvjGNy6fIQso28XakHtKk/QTTQNfnusWk/GiFN9dlBwmXOaJM7mf+FvvaAE+y/
	RoYk3clt0ieXmrE6iRNBdHG15pLfsYY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-vTNpWB8-MKqxFVaPFTU4Eg-1; Wed,
 11 Mar 2026 13:12:30 -0400
X-MC-Unique: vTNpWB8-MKqxFVaPFTU4Eg-1
X-Mimecast-MFC-AGG-ID: vTNpWB8-MKqxFVaPFTU4Eg_1773249149
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAB301800359;
	Wed, 11 Mar 2026 17:12:28 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.81.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A5D893000223;
	Wed, 11 Mar 2026 17:12:24 +0000 (UTC)
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
	David Jeffery <djeffery@redhat.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH 2/5] driver core: separate function to shutdown one device
Date: Wed, 11 Mar 2026 13:12:06 -0400
Message-ID: <20260311171209.9205-2-djeffery@redhat.com>
In-Reply-To: <20260311171209.9205-1-djeffery@redhat.com>
References: <20260311171209.9205-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Make a separate function for the part of device_shutdown() that does the
shutown for a single device.  This is in preparation for making device
shutdown asynchronous.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 65 ++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index eb54fc9680de..c2c35f95f751 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4782,6 +4782,40 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
 	return error;
 }
 
+static void shutdown_one_device(struct device *dev)
+{
+	/* hold lock to avoid race with probe/release */
+	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
+		device_lock(dev->parent);
+	device_lock(dev);
+
+	/* Don't allow any more runtime suspends */
+	pm_runtime_get_noresume(dev);
+	pm_runtime_barrier(dev);
+
+	if (dev->class && dev->class->shutdown_pre) {
+		if (initcall_debug)
+			dev_info(dev, "shutdown_pre\n");
+		dev->class->shutdown_pre(dev);
+	}
+	if (dev->bus && dev->bus->shutdown) {
+		if (initcall_debug)
+			dev_info(dev, "shutdown\n");
+		dev->bus->shutdown(dev);
+	} else if (dev->driver && dev->driver->shutdown) {
+		if (initcall_debug)
+			dev_info(dev, "shutdown\n");
+		dev->driver->shutdown(dev);
+	}
+
+	device_unlock(dev);
+	if (dev->parent && dev->bus && dev->bus->need_parent_lock)
+		device_unlock(dev->parent);
+
+	put_device(dev->parent);
+	put_device(dev);
+}
+
 /**
  * device_shutdown - call ->shutdown() on each device to shutdown.
  */
@@ -4818,36 +4852,7 @@ void device_shutdown(void)
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
 
-		/* hold lock to avoid race with probe/release */
-		if (parent && dev->bus && dev->bus->need_parent_lock)
-			device_lock(parent);
-		device_lock(dev);
-
-		/* Don't allow any more runtime suspends */
-		pm_runtime_get_noresume(dev);
-		pm_runtime_barrier(dev);
-
-		if (dev->class && dev->class->shutdown_pre) {
-			if (initcall_debug)
-				dev_info(dev, "shutdown_pre\n");
-			dev->class->shutdown_pre(dev);
-		}
-		if (dev->bus && dev->bus->shutdown) {
-			if (initcall_debug)
-				dev_info(dev, "shutdown\n");
-			dev->bus->shutdown(dev);
-		} else if (dev->driver && dev->driver->shutdown) {
-			if (initcall_debug)
-				dev_info(dev, "shutdown\n");
-			dev->driver->shutdown(dev);
-		}
-
-		device_unlock(dev);
-		if (parent && dev->bus && dev->bus->need_parent_lock)
-			device_unlock(parent);
-
-		put_device(dev);
-		put_device(parent);
+		shutdown_one_device(dev);
 
 		spin_lock(&devices_kset->list_lock);
 	}
-- 
2.53.0

