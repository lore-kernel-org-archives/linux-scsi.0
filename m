Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0294E77E7
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 16:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663102; cv=none; b=qvzMErbbuirvWlyxgRzqV93chs5HxZcwg8+uSuE/efIzqA7Dzu9AJmkl84w9KVv2oUJM+Rdwj/KD5MGwMKEbheDc8esF6NKnD37Xqy3jMcyUVOSB9AmBiCTsjEzBFzpe4GpZ4DKd2c5TA3Q3fxiTTgnpLtTziSh4aYAELL4P814=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663102; c=relaxed/simple;
	bh=Woa6N9v+SMe+iqq4nIasCho+fXRyxC/tVADO5/OfTKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSAEChc6AwNEpSAZ5/wDmMgVdIHUP+RvnQHa1S/zUoVjMOIF8WYJltkmbUgeh0CPlFCND7z6yESZvg2aWSe/rccHGEmOqsZtAvNzUavQ0+eAZ6nQIiKd5/muNv29x3W+9iPaMFKCuwn6uRWtMS1QH054lLQCY9i4mneaoMIeyv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=clmhPv/6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="clmhPv/6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789663099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bxjP7KUlohvZ2YPEyHIa7bKbPs42+xcSHkWZNTuvybw=;
	b=clmhPv/6l4tYFXmjjZoqfRSFlEVATGV33ejSi13Myr9S2fFLhXym/L0YoboWYEmTmHgIgW
	G501QCxfRJU7nNwFi+JqBDAs5s2bvcIkWOhXeJlqPP0pOCWxWGFYsY8FmEb5o/AWl7iP5V
	0suZfADtI9544dpuAW9ENa9ScfMYaZs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-33-d1egqnKpMDii9sPsfNsXyQ-1; Thu,
 17 Sep 2026 12:38:15 -0400
X-MC-Unique: d1egqnKpMDii9sPsfNsXyQ-1
X-Mimecast-MFC-AGG-ID: d1egqnKpMDii9sPsfNsXyQ_1789663093
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 746FB1955BE7;
	Thu, 17 Sep 2026 16:38:13 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.rmtusga.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5704C1800345;
	Thu, 17 Sep 2026 16:38:10 +0000 (UTC)
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
Subject: [PATCH 5/9] driver core: do not always lock parent in shutdown
Date: Thu, 17 Sep 2026 12:37:40 -0400
Message-ID: <20260917163744.191748-6-djeffery@redhat.com>
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

Don't lock a parent device unless it is needed in device_shutdown. This
is in preparation for making device shutdown asynchronous, when it will
be needed to allow children of a common parent to shut down
simultaneously.

And only acquire a reference to the parent device if the parent is to be
locked.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7fe3fa6870a7..93605698affc 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4903,12 +4903,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
 	return error;
 }
 
-static void shutdown_one_device(struct device *dev, struct device *parent)
+static void __shutdown_one_device(struct device *dev)
 {
-	/* hold lock to avoid race with probe/release */
-	if (parent)
-		device_lock(parent);
-	device_lock(dev);
+	if (!dev->p || dev->p->dead)
+		return;
 
 	/* Don't allow any more runtime suspends */
 	pm_runtime_get_noresume(dev);
@@ -4928,13 +4926,33 @@ static void shutdown_one_device(struct device *dev, struct device *parent)
 			dev_info(dev, "shutdown\n");
 		dev->driver->shutdown(dev);
 	}
+}
 
-	device_unlock(dev);
-	if (parent)
+static void shutdown_one_device(struct device *dev)
+{
+	struct device *parent;
+
+	device_lock(dev);
+
+	/* use parent lock if needed to avoid race with probe/release */
+	if (dev->p && !dev->p->dead && dev->bus && dev->bus->need_parent_lock &&
+	    (parent = get_device(dev->parent))) {
+		/* the parent lock needs to be acquired first, so re-lock */
+		device_unlock(dev);
+
+		device_lock(parent);
+		device_lock(dev);
+
+		__shutdown_one_device(dev);
+		device_unlock(dev);
 		device_unlock(parent);
+		put_device(parent);
+	} else {
+		__shutdown_one_device(dev);
+		device_unlock(dev);
+	}
 
 	put_device(dev);
-	put_device(parent);
 }
 
 /**
@@ -4942,7 +4960,7 @@ static void shutdown_one_device(struct device *dev, struct device *parent)
  */
 void device_shutdown(void)
 {
-	struct device *dev, *parent;
+	struct device *dev;
 
 	wait_for_device_probe();
 	device_block_probing();
@@ -4960,12 +4978,6 @@ void device_shutdown(void)
 		dev = list_entry(devices_kset->list.prev, struct device,
 				kobj.entry);
 
-		/*
-		 * hold reference count of device's parent to
-		 * prevent it from being freed because parent's
-		 * lock is to be held
-		 */
-		parent = get_device(dev->parent);
 		get_device(dev);
 		/*
 		 * Make sure the device is off the kset list, in the
@@ -4974,7 +4986,7 @@ void device_shutdown(void)
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
 
-		shutdown_one_device(dev, parent);
+		shutdown_one_device(dev);
 
 		spin_lock(&devices_kset->list_lock);
 	}
-- 
2.55.0

