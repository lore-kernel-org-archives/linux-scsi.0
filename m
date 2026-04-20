Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A8E17A300
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 15:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776698812; cv=none; b=iRYcA8HeM44f6UaljYAMDRvfAONN+wYMvJHvXhA/HagNNJUs90TYlrtXqtCbBgnmXnH/m89SwIv6kRp8ieKMvTjQ7PrjdYMV1wz/aCv34RPBcYYkVy9oGguYm08RN+exXnMoPFjz7OCDvCm9y9AvF3AdgBUKH3XLNjzGDRZwBjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776698812; c=relaxed/simple;
	bh=dATQRFKcNLJjjRyV6a0dyqXpJdGDzEDhkgxOQ+dCuZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqdzWdrEtFtimy9nvQ9Z6Zi5yWOeVJeGfBFH0XlxGAaJIvNylnQdVynD/BVjouJu50WUpp0yImLncEYnPjBY63aYjJXYf5q+TRGoGU3ZJcrzdtBDaaOq8/n4nQ3NRgCdx3AjVJuhkBHGeYLysxH+Xh+PLCyHT+6lXKBDPaIdCNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=APDsAXQA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="APDsAXQA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776698807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hcVVsfBQNN9rrh6Uf5d8BNbIQC5J9iqF/mHK2jES+/k=;
	b=APDsAXQAq2nsKFhmwG4HRIjCXYyF0ZD4auO7kGWk4rJjrXpxpNEqzfOIXIC0jnnCau2jB5
	qGhZBmi72sqOjXuOY5e1nYOSm45HQMGWVuYakK81y1sPWgmBz4d04rPJJKotGQ90LEfQ6V
	k+VECB6m0H4cFR62U+cstSedjHzfTWc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-ohZyS1s6OyOy4C4sgKJYyw-1; Mon,
 20 Apr 2026 11:26:43 -0400
X-MC-Unique: ohZyS1s6OyOy4C4sgKJYyw-1
X-Mimecast-MFC-AGG-ID: ohZyS1s6OyOy4C4sgKJYyw_1776698792
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD9A8195605E;
	Mon, 20 Apr 2026 15:26:32 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.65.236])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C7D819560B1;
	Mon, 20 Apr 2026 15:26:28 +0000 (UTC)
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
Subject: [PATCH 2/5] driver core: do not always lock parent in shutdown
Date: Mon, 20 Apr 2026 11:26:05 -0400
Message-ID: <20260420152608.6244-3-djeffery@redhat.com>
In-Reply-To: <20260420152608.6244-1-djeffery@redhat.com>
References: <20260420152608.6244-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
 drivers/base/core.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5353c6c22d49..a32fc7141957 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4783,13 +4783,8 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
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
 	device_lock(dev);
 
 	/* Don't allow any more runtime suspends */
@@ -4812,10 +4807,23 @@ static void shutdown_one_device(struct device *dev)
 	}
 
 	device_unlock(dev);
-	if (parent)
+}
+
+static void shutdown_one_device(struct device *dev)
+{
+	struct device *parent;
+
+	/* hold lock if needed to avoid race with probe/release */
+	if (dev->bus && dev->bus->need_parent_lock &&
+	    (parent = get_device(dev->parent))) {
+		device_lock(parent);
+		__shutdown_one_device(dev);
 		device_unlock(parent);
+		put_device(parent);
+	} else {
+		__shutdown_one_device(dev);
+	}
 
-	put_device(parent);
 	put_device(dev);
 }
 
@@ -4841,12 +4849,6 @@ void device_shutdown(void)
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
2.53.0

