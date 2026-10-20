Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514701;
	b=uM4ty8bvawu//JXbrmmrLpMlN0KYZE4b4toaetzBN4hjLk9z3okNgbLFzjITXEZXQcSb
	 Ui7L9iWQEpHB2VKyiIXr4VeGRPeMwYIOoJbWfgIKJy3ssMjSGsmPaib1PIx6E6lixTFBt
	 Gd8le3kjItXVdo+I1ea465HmkFqEzkgTRINAdbQrTQ7A8myeh+GgEMnk3owaGTeTdauHx
	 Mww6wGFFNMot8nYLkJzkqs8JWfUh8PNa9hKpdj4GPXXeigeVtTDPTctgsYlh44c/kLgv6
	 SJapaQG2toMgnu/PNIJmZTDm4zjFx+QdDwvlSTRaEDdbqnuOeT35wZifmAdyQsDlRHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514701;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=FxOEy23CdjWO+tWUfg0nkvoqJt9R/kFtS/CvH38ECoU=;
	b=zGk1tfKUw8TQXaG8Br9/Gz7DIwjoYiLlkykGM6ncbooYJbjsGOPdLLNHUVCpx6bq3Gkf
	 Eh6KHMbXK+Vc1/mBv4eMbS5JfodXFR5JHzCDqF0/xO/pB19LX9dmk+LvqP1XVH4W8dbXA
	 QzEO0aW3Dt5ke9nEn5FtkcUDGtJjSXhnDeIkhxSO8L2/qlZp8ripBFss8VWgnOv9F7gli
	 Mq/xmzpfp143mrswHZx3dKRnAAUYhejHfjnDUab09//AZC9h2FvgOkiUHLPWQpme8atL2
	 x6vy+RHWGShgUCjCHoI/eT9dCD84hRWtcsAmwmTKvCyuMeAzVPgZRlhnZAaE1k0PCaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=X41g5f0l;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AB060A3812
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 16:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89AB060A3812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=X41g5f0l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792514699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FxOEy23CdjWO+tWUfg0nkvoqJt9R/kFtS/CvH38ECoU=;
	b=X41g5f0lE0L2dkb4XUwlSCZa5RfNIuo+IybP/uDLFRcfozO/+Qw63SrE+5U/z89J/XHW0x
	uxare6lMiypzwu+E7n+Pb0ocYmxK7Gk3PL09ZPS8moTVF6/oFz9ThrLz6gfUdXz3ghqCF1
	KP8Et/TOglhgDkpDUVw0tLnS2lSIwG8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-zvZ-0V2qMVGSaQHrKCF9KQ-1; Tue,
 20 Oct 2026 16:44:55 +0000
X-MC-Unique: zvZ-0V2qMVGSaQHrKCF9KQ-1
X-Mimecast-MFC-AGG-ID: zvZ-0V2qMVGSaQHrKCF9KQ_1792514692
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEB351945CB3;
	Tue, 20 Oct 2026 16:44:52 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C8D6630001A2;
	Tue, 20 Oct 2026 16:44:48 +0000 (UTC)
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
Date: Tue, 20 Oct 2026 12:44:28 -0400
Message-ID: <20261020164435.80499-3-djeffery@redhat.com>
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

