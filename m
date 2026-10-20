Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514728;
	b=N4jA+k6dpIxfg2ZCP+z2GOvzdYICIKBaasuQBhLDlFdm+iOpRoaqMfBCagj+wiROlUWw
	 OtnJpzXvwTesD9395+fgD2SZY+eQMEOLkAy//zqA9eHdZ7mJUWqvCQj2AoSbVdO2mvuTk
	 7N7UOIj9lU4zJh0PLGhJVUL3+dDNmkgWzBxi2oFAR9QCrQ1uyrW/HhSPbaW247x9MaoN4
	 N6PzSsQTliFT0IjMmmazQIa3Ih/VpC6gmOcg1/WTVEd8zXcDESL42J1yQu+0dQMKl07pC
	 hYNkSC8TX4G+WSDca9DTGPFuj3UF52nChJyJr72CZlparHK+RvIxhjJVnofEYtWZ5dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514728;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=exa5f/DcwNCR5E0w8unUqAO11f1n98HF5VNU5M/lSuA=;
	b=rAebSVv3pJUizXwKCMUJk79T38AIai+htAu+e1qGBpWCJ58s3EjeMYgbe7LuOehrqVQb
	 F3hktCSng0qscoUCbGL5M8V5jyp5AA1iMJfBs1AoaTGMXL+wAnoZ6yL4PFajkj+fEuDti
	 ybtH+dYPPmGlrbC27EhwyVklN/gqzzJn1wvEwIUeG3pCj01+3oKKu7wDYhryAeZTF/5G4
	 YCwJDoJopUNM0Uh+XCzsqAZvTp8sIRKqjBVTgM+l2Y/Xax2ItXH83BOqvVzahwl1JOw7B
	 AUpffaQondyZn6xON4/JgcQaTygNVgk2YcA/TjnmSQisKpeH7RkS9psMeAoWwkaDagQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MLgsAeTK;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE58E60A6F77
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 16:45:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE58E60A6F77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MLgsAeTK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792514727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exa5f/DcwNCR5E0w8unUqAO11f1n98HF5VNU5M/lSuA=;
	b=MLgsAeTKrb0TrYszXs1J8zwWyUs9LlZa3hj28lXexyTrZlY3Z+NhA41T7Qk8WuhMyr/zXi
	t4Ur9vdaMTkMVXfn0PZiZU8DmYcXixtDWBh95gXbfbVeJYbBHWXJ1z+WKhsDeiW7DEs+hL
	WX1FCJmSn9SncLlCU6Uvx2eR/0fmFcg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-JrlojP41PRiJLgF9H6qwug-1; Tue,
 20 Oct 2026 12:45:21 -0400
X-MC-Unique: JrlojP41PRiJLgF9H6qwug-1
X-Mimecast-MFC-AGG-ID: JrlojP41PRiJLgF9H6qwug_1792514719
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19F7D195C25C;
	Tue, 20 Oct 2026 16:45:19 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7DC830001A2;
	Tue, 20 Oct 2026 16:45:15 +0000 (UTC)
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
	David Jeffery <djeffery@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: [PATCH 9/9] scsi: Enable async shutdown support
Date: Tue, 20 Oct 2026 12:44:35 -0400
Message-ID: <20261020164435.80499-10-djeffery@redhat.com>
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

Like scsi's async suspend support, allow scsi devices to be shut down
asynchronously to reduce system shutdown time.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/hosts.c      | 2 ++
 drivers/scsi/scsi_sysfs.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e72055c1ebbb..75592f41ef39 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -272,6 +272,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_set_active(&shost->shost_gendev);
 	pm_runtime_enable(&shost->shost_gendev);
 	device_enable_async_suspend(&shost->shost_gendev);
+	dev_set_async_shutdown(&shost->shost_gendev);
 
 	error = device_add(&shost->shost_gendev);
 	if (error)
@@ -282,6 +283,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	get_device(shost->shost_gendev.parent);
 
 	device_enable_async_suspend(&shost->shost_dev);
+	dev_set_async_shutdown(&shost->shost_dev);
 
 	get_device(&shost->shost_gendev);
 	error = device_add(&shost->shost_dev);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9480432f650b..52e1e38dc027 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1387,6 +1387,7 @@ static int scsi_target_add(struct scsi_target *starget)
 	pm_runtime_set_active(&starget->dev);
 	pm_runtime_enable(&starget->dev);
 	device_enable_async_suspend(&starget->dev);
+	dev_set_async_shutdown(&starget->dev);
 
 	return 0;
 }
@@ -1413,6 +1414,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	transport_configure_device(&starget->dev);
 
 	device_enable_async_suspend(&sdev->sdev_gendev);
+	dev_set_async_shutdown(&sdev->sdev_gendev);
 	scsi_autopm_get_target(starget);
 	pm_runtime_set_active(&sdev->sdev_gendev);
 	if (!sdev->rpm_autosuspend)
@@ -1432,6 +1434,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	}
 
 	device_enable_async_suspend(&sdev->sdev_dev);
+	dev_set_async_shutdown(&sdev->sdev_dev);
 	error = device_add(&sdev->sdev_dev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
-- 
2.55.0

