Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED364D90A5
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 14:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322317; cv=none; b=EwRr36Wth1QDak+ll6eKCwjCsMDP0YrJOFAYwgYEqZYC5rwHY8FpsOMLOk212n18f4p2dm60WgakYrviVFSe4Hduwizf6vPZLAhuvQGpjJAe0v45iVcCTspvL5BhUr8c0TarwSbJZVLCsXm+12krPI36dLxFTvr7/Z5V8nVlxsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322317; c=relaxed/simple;
	bh=QDnzyAXfkVtXx6dafjBq5IPhp7lT//fl6PxTNeIYJZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVq6fPdblmH0GcVwgt7HIrBjBl4ZUNvQLquub18/69zOhmIdibulZr5JjAP2N7SgpRZ93Yx8k7PKdOvuoGSCNYRAbAAyXblE7ZVmcck87JfugUcRo8Ds/mlB3ao/Ip+oqMHEMFjoYTzlIz3HnQMyJI6tTz7l2iwgqRy/khMtJRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X+UIenga; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X+UIenga"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787322315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2wH5PJaoSf+WZ0HADj6Qf/btDMSF680EsLu/bDLMdGU=;
	b=X+UIengadfaSef0y7eXOMdmwS6qgQ4LcQ/xPPwr2y11vzUN8KoFjuX8FTKpjFDzygZWBNW
	76CQfNlH/R1qXFaYRVQpNnQbdGMRRLjwJCArDxy4JvYlBe3XWM7crzpph+tYIcs5xQpDoN
	cTLMYSqRYuxsH6gParvqahDVFCd7s2E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-148-wb891n9mO46S-xNiZu2-Pw-1; Fri,
 21 Aug 2026 10:25:10 -0400
X-MC-Unique: wb891n9mO46S-xNiZu2-Pw-1
X-Mimecast-MFC-AGG-ID: wb891n9mO46S-xNiZu2-Pw_1787322307
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E43718011EC;
	Fri, 21 Aug 2026 14:25:07 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 93532180034F;
	Fri, 21 Aug 2026 14:25:04 +0000 (UTC)
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
	David Jeffery <djeffery@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 8/9] PCI: Enable async shutdown support
Date: Fri, 21 Aug 2026 10:24:13 -0400
Message-ID: <20260821142414.150892-9-djeffery@redhat.com>
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

Like its async suspend support, allow PCI device shutdown to be performed
asynchronously to reduce shutdown time.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dd0abbc63e18..af2381446406 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1046,6 +1046,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 
 	bus->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(bus->bridge);
+	dev_set_async_shutdown(bus->bridge);
 	pci_set_bus_of_node(bus);
 	pci_set_bus_msi_domain(bus);
 	if (bridge->msi_domain && !dev_get_msi_domain(&bus->dev) &&
@@ -2748,6 +2749,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	pci_reassigndev_resource_alignment(dev);
 
 	pci_init_capabilities(dev);
+	dev_set_async_shutdown(&dev->dev);
 
 	/*
 	 * Add the device to our list of discovered devices
-- 
2.55.0

