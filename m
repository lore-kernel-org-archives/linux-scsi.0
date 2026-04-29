Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7945038C415
	for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2026 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777485079; cv=none; b=o610ziBYULJiOAyGHsNKoZfw9I5BFVW2fyBrLG/ym1I5uqWRuUuyUJp5hL7eUaUJFQM6WBFXbtfkVgDYwHVWkih+FQbXPjHyJ0Fc7/WvmWoNbxAe9U/L6VZie8pxoRZHECqJyzmemreArExegxUZ0PFnPF9QYVfz2dV/eOyqjRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777485079; c=relaxed/simple;
	bh=Z3ca1mwVV9tvMoPvpLPM4RlOmGhZUMxjiOj6IqI81pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnNTEkhz8vcsJ8UVJUy0kXfB+a4WtbBxs6tYL3sCzXHC4abmxF6k46kO6X7R5AXSIuPapCa09iskDYCEZ/temAVDDJm8fhDGgAr4gZrQnEEzZSvAcvkyhunAB72Ek6t+SDdfI7492WwDlIogqwudqYTDShRGLur//NmzXXNSWqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SYT9hqcE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SYT9hqcE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777485077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U54ViaHQ6SdACiN5txV3sQNUzriUf70Auy/2LcwcU0s=;
	b=SYT9hqcE925287qkD5zy5lkotU0WkgY66R1u3rKnZf2VY3On9xSapIjVBXbOuI/u6A4cf9
	4lImwNTcLEPb+PSlmIadtwdyiKh52yWwbjxw4/HwrNf9nmc9Gpboo/ggYW9MEAMyAT4fLo
	Z+ARvnWgLTelW+KSW6xzHoIeKVSVLPU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-VbipQuUTOhiPukFtFJk__Q-1; Wed,
 29 Apr 2026 13:51:14 -0400
X-MC-Unique: VbipQuUTOhiPukFtFJk__Q-1
X-Mimecast-MFC-AGG-ID: VbipQuUTOhiPukFtFJk__Q_1777485071
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCF881800347;
	Wed, 29 Apr 2026 17:51:11 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.80.165])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 41FCC30001BB;
	Wed, 29 Apr 2026 17:51:06 +0000 (UTC)
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
	kexec@lists.infradead.org,
	David Jeffery <djeffery@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: [PATCH 4/5] PCI: Enable async shutdown support
Date: Wed, 29 Apr 2026 13:50:15 -0400
Message-ID: <20260429175016.7915-5-djeffery@redhat.com>
In-Reply-To: <20260429175016.7915-1-djeffery@redhat.com>
References: <20260429175016.7915-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Like its async suspend support, allow PCI device shutdown to be performed
asynchronously to reduce shutdown time.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 drivers/pci/probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b63cd0c310bc..86e855090553 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1045,6 +1045,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 
 	bus->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(bus->bridge);
+	device_enable_async_shutdown(bus->bridge);
 	pci_set_bus_of_node(bus);
 	pci_set_bus_msi_domain(bus);
 	if (bridge->msi_domain && !dev_get_msi_domain(&bus->dev) &&
@@ -2753,6 +2754,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	pci_reassigndev_resource_alignment(dev);
 
 	pci_init_capabilities(dev);
+	device_enable_async_shutdown(&dev->dev);
 
 	/*
 	 * Add the device to our list of discovered devices
-- 
2.53.0

