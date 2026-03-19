Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14893090CB
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 14:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929557; cv=none; b=S7d7ItSXw5a+DVcegqN8X5XpFlFvZICkWgzIpkbbdEhhxSNFmS8GVLpTzV3vmPm3pp3hoDy8NiNp5BYdfmw4QyTrmkT247gUXMOnc84PcOV2qvWkP9cHh58cOilGUzhBjfV++EB11kZjI6c67dfkX8tTA1b0nGazh3sWFbbRAZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929557; c=relaxed/simple;
	bh=ZS9R2CooQDezB+WIJnc8X5IeXYWMu8ZBSkFXu1xP+24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJo3wKsE3q0qfEuyy1Y5/Ilq3OTPJngRQ1Qt43vv2RZIIZkG7A42CsmJm/N91pVnEX7w/xDJ1CNM3S5lgOeKi6iV2yj9sQUpe4gzSWHwTRymd4eXDBCxnR5ZmuScCPj944ikz5ON36Qq7MaaxkPZ0RUdPSLHdb/7PuiRim5hndY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lungrv8N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lungrv8N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773929554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdgaP8ORLsWTjy97D1Ac7KNDjoWNyGxBr7xWgrx8peE=;
	b=Lungrv8NFlPgNj8e3HMZeugAHL/Cx1c4XiTYTUUJpr0G7gg3KmwKdYl34nmJGvA0IZ2s+K
	INn2mVbr3PZeyYJVEyBM6LTVkUWkapNnmCGCDA60iVG46zZ1ttvEx6MyEe5bhOjTjLM/+x
	9MSyUiGODNIFIale+n2yJYxTsgQI36E=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-FJ55uTLQNseO0C85eSUjLw-1; Thu,
 19 Mar 2026 10:12:30 -0400
X-MC-Unique: FJ55uTLQNseO0C85eSUjLw-1
X-Mimecast-MFC-AGG-ID: FJ55uTLQNseO0C85eSUjLw_1773929545
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F29E195608E;
	Thu, 19 Mar 2026 14:12:25 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.66.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CE8A41800351;
	Thu, 19 Mar 2026 14:12:20 +0000 (UTC)
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
	David Jeffery <djeffery@redhat.com>
Subject: [PATCH 5/5] scsi: enable async shutdown support
Date: Thu, 19 Mar 2026 10:11:42 -0400
Message-ID: <20260319141142.5781-6-djeffery@redhat.com>
In-Reply-To: <20260319141142.5781-1-djeffery@redhat.com>
References: <20260319141142.5781-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Like scsi's async suspend support, allow scsi devices to be shut down
asynchronously to reduce system shutdown time.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/hosts.c      | 3 +++
 drivers/scsi/scsi_scan.c  | 1 +
 drivers/scsi/scsi_sysfs.c | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e047747d4ecf..dfb38a82c0bf 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -273,6 +273,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_set_active(&shost->shost_gendev);
 	pm_runtime_enable(&shost->shost_gendev);
 	device_enable_async_suspend(&shost->shost_gendev);
+	device_enable_async_shutdown(&shost->shost_gendev);
 
 	error = device_add(&shost->shost_gendev);
 	if (error)
@@ -282,6 +283,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	get_device(shost->shost_gendev.parent);
 
 	device_enable_async_suspend(&shost->shost_dev);
+	device_enable_async_shutdown(&shost->shost_dev);
 
 	get_device(&shost->shost_gendev);
 	error = device_add(&shost->shost_dev);
@@ -519,6 +521,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
 	shost->shost_gendev.bus = &scsi_bus_type;
 	shost->shost_gendev.type = &scsi_host_type;
 	scsi_enable_async_suspend(&shost->shost_gendev);
+	device_enable_async_shutdown(&shost->shost_gendev);
 
 	device_initialize(&shost->shost_dev);
 	shost->shost_dev.parent = &shost->shost_gendev;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60c06fa4ec32..c42b33e8ea8a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -518,6 +518,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	dev->bus = &scsi_bus_type;
 	dev->type = &scsi_target_type;
 	scsi_enable_async_suspend(dev);
+	device_enable_async_shutdown(dev);
 	starget->id = id;
 	starget->channel = channel;
 	starget->can_queue = 0;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 6b8c5c05f294..c76ba17b206f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1370,6 +1370,7 @@ static int scsi_target_add(struct scsi_target *starget)
 	pm_runtime_set_active(&starget->dev);
 	pm_runtime_enable(&starget->dev);
 	device_enable_async_suspend(&starget->dev);
+	device_enable_async_shutdown(&starget->dev);
 
 	return 0;
 }
@@ -1396,6 +1397,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_configure_device(&starget->dev);
 
 	device_enable_async_suspend(&sdev->sdev_gendev);
+	device_enable_async_shutdown(&sdev->sdev_gendev);
 	scsi_autopm_get_target(starget);
 	pm_runtime_set_active(&sdev->sdev_gendev);
 	if (!sdev->rpm_autosuspend)
@@ -1415,6 +1417,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	}
 
 	device_enable_async_suspend(&sdev->sdev_dev);
+	device_enable_async_shutdown(&sdev->sdev_dev);
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
@@ -1670,6 +1673,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.type = &scsi_dev_type;
 	scsi_enable_async_suspend(&sdev->sdev_gendev);
+	device_enable_async_shutdown(&sdev->sdev_gendev);
 	dev_set_name(&sdev->sdev_gendev, "%d:%d:%d:%llu",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	sdev->sdev_gendev.groups = hostt->sdev_groups;
-- 
2.53.0

