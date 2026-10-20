Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514713;
	b=WEhOTr+R0a00ZSVAAmI7pcq4AHQSbRnx6GEf4OBERFcBCYj/Mw1SODa67DiGA1lWxtgF
	 NH13W70qRbuZh0Pnb+nUXEVMa7uDoTTmpS5cLHsNVI37J3SFWxm0+1kduMz9+53YbOdtn
	 5b09iCzyiKw3738ExzHpKGc5UyrE3IblcH0iTB5dQXLA1ZH9ep4kwaWVWLgZ6ufKNtkUN
	 3EvFyxOpNpEfe86LoVxagI6fJuPL79Ok5+jHQ68CMYsinJ6pcCQi6Eh8M0tyD9pE7dOyU
	 lT3F8CXB3vOFG5PLqWMQ99RKNrDjhIbsLvrQq1wXaDmfJPTiNxH382ZvRRbALpIMVBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514713;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=bxjP7KUlohvZ2YPEyHIa7bKbPs42+xcSHkWZNTuvybw=;
	b=p7HkT938jtEAXrmQOBRtHEKvSma1I6OdulIKnFKCkRi0T/kDWPVKiJ41I1faTNdcHciA
	 9EIqySV9bzkNwu2+k6PfOYXzowhTbnFfGZXPB8jrzyi3ekiodguF/W/VqWZGLeq/pQKHH
	 h01EY8y1Xw/ITz+KXfs2xRP7leHWO+7aXFq/PLXGSLXBbLSwPiJoyAhthoMJJsJiTwgvJ
	 a69LHQCBwuKGKsEtosMofVlaoe1h6FRA1vipAPkYN0qDnI416ryfLmc2hoTH4OH4/Xf8Q
	 Nmqf27zBzMoqhnMEp21ftNx+WdPa+l8J9o1N59P1DllgmUhLwvI2C5bamWA8aFEZ+xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aoDe5gpx;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5BB60A4AE0
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 16:45:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C5BB60A4AE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aoDe5gpx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792514712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bxjP7KUlohvZ2YPEyHIa7bKbPs42+xcSHkWZNTuvybw=;
	b=aoDe5gpx9N0N74Qf+yn3OWMLLRFmxy9gSEC58kDIC7kGTnWsSyE+cNDCPNBIYEepM71HzL
	bEnDHSDk3WGGT3NFqmv0QZJ/xFYWrT6/slm01evnS5QIZsT0Vr7ExmNZ8mpNBRbep+Pr9a
	RPKCYoTqDzHlm1U7cmL6qV8Z/84K4v0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-fnxMTARHNV-bSHZRxYAnOQ-1; Tue,
 20 Oct 2026 16:45:08 +0000
X-MC-Unique: fnxMTARHNV-bSHZRxYAnOQ-1
X-Mimecast-MFC-AGG-ID: fnxMTARHNV-bSHZRxYAnOQ_1792514704
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 888F11953952;
	Tue, 20 Oct 2026 16:45:03 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 516C430001A2;
	Tue, 20 Oct 2026 16:45:00 +0000 (UTC)
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
Date: Tue, 20 Oct 2026 12:44:31 -0400
Message-ID: <20261020164435.80499-6-djeffery@redhat.com>
In-Reply-To: <20261020164435.80499-1-djeffery@redhat.com>
References: <20261020164435.80499-1-djeffery@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

