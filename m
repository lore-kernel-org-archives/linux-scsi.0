Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22912BE7DD
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 13:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782913850; cv=none; b=dfPZuM9d0kkWxBgA12FzpGniCZ3d3if9mslXVEG/VvHX3fadca1ke5+rPzOt7ua6x5c/udhwc8f92eEyIV/EiCi0XOYmwIBv+px8Le1yp4/G8UaBAQAtUhbeY9ed1zp0EbwXzFM+fgb4ssa4GGYW70Qrjkm9BFt5E17lNa0uyc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782913850; c=relaxed/simple;
	bh=H6l9jSxep5Tj21LcsQI7ISrs1RkC5kc/k/VOiGh3Fng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKublK7tvY+2LSWsRIeabFRXjinnwFYRbfVCers+cF1nO1FYh5DN9NFndCfwVD36kTo7s9+EKUbUa185J7pljMPKIDpIeDCtXvsjogcS5YlDyjTABhryju2wo1kmxlrSTTc8C0ztVWF9e5czUTv88x2JwjNXrE755XGY7hQGIBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N8GDi+nv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N8GDi+nv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782913846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+nFPAVBpWgUR1X36PZ/lmagU7XjSBga3RsLirYRi04=;
	b=N8GDi+nv6KHa1mcQSb1QgAbLi6aa8U0Ca2xA9PRqne3KbKs/v9+Idlfr+lYvlJaylIhzaW
	x15dXdD5JlX8carVMyhdcZ70ptACGZbGIGtV/Cr/wA1qLYBvqi4e9LAEvmxFMh528qeL1E
	Pib26aySs1vvGWn5zOFlvVcuyjv8VsI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-6fJfttuPNbS7DCGx_AGIJA-1; Wed,
 01 Jul 2026 09:50:43 -0400
X-MC-Unique: 6fJfttuPNbS7DCGx_AGIJA-1
X-Mimecast-MFC-AGG-ID: 6fJfttuPNbS7DCGx_AGIJA_1782913840
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D2CC1944B24;
	Wed,  1 Jul 2026 13:50:39 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.rmtusga.csb (unknown [10.22.81.69])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 72107180076D;
	Wed,  1 Jul 2026 13:50:35 +0000 (UTC)
From: David Jeffery <djeffery@redhat.com>
To: driver-core@lists.linux.dev,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Tarun Sahu <tarunsahu@google.com>,
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
	kexec@lists.infradead.org,
	David Jeffery <djeffery@redhat.com>
Subject: [PATCH 2/5] driver core: do not always lock parent in shutdown
Date: Wed,  1 Jul 2026 09:50:12 -0400
Message-ID: <20260701135015.81937-3-djeffery@redhat.com>
In-Reply-To: <20260701135015.81937-1-djeffery@redhat.com>
References: <20260701135015.81937-1-djeffery@redhat.com>
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
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 74c693cd19cf..3b3d983b1747 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4865,14 +4865,10 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
 	return error;
 }
 
-static void shutdown_one_device(struct device *dev)
+static void __shutdown_one_device(struct device *dev)
 {
-	struct device *parent = dev->parent;
-
-	/* hold lock to avoid race with probe/release */
-	if (parent)
-		device_lock(parent);
-	device_lock(dev);
+	if (dev->p->dead)
+		return;
 
 	/* Don't allow any more runtime suspends */
 	pm_runtime_get_noresume(dev);
@@ -4892,12 +4888,32 @@ static void shutdown_one_device(struct device *dev)
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
+	if (dev->bus && dev->bus->need_parent_lock && !dev->p->dead &&
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
 
-	put_device(parent);
 	put_device(dev);
 }
 
@@ -4923,12 +4939,6 @@ void device_shutdown(void)
 		dev = list_entry(devices_kset->list.prev, struct device,
 				kobj.entry);
 
-		/*
-		 * hold reference count of device's parent to
-		 * prevent it from being freed because parent's
-		 * lock is to be held
-		 */
-		get_device(dev->parent);
 		get_device(dev);
 		/*
 		 * Make sure the device is off the kset list, in the
-- 
2.54.0

