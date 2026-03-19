Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D163090CB
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 14:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929555; cv=none; b=d1gAGdSzJpIHEnIx3B0vkgy/ppv/1Ia3Q+300YLZuitV8+i2v7cBWHUSETEyWq0SI3A70/qkbygMUyf46x1OBLN1tLckMKpiAGSRb5/KCTaM0yvycnKnpmQmfhVVI3Kth8kyPW8k8gmLEzhWHTlZsX+eujFrJ/Jc56GtVrt2T+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929555; c=relaxed/simple;
	bh=4vvr+xDrAWxMxjnNh4nkvtXpBMA19u1S8MdxP1fEm4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrxDNdtlSfgS4OAo/N/tovgW6jfcrbSynM+w7wSYkgyRmzYlRhzeL0+pEL+VxSHodDb/5/QpruJxIDaQVh7azAQ2zWNX5cuwwzBWL7kuqHD5bxjaWfqvPJRzie+LxRyiiJvu0dfPr3dQxuHaMoGfCgXjUfzwcp2vqPxeWAACUTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g73bbAln; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g73bbAln"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773929552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jQvaSb3MuBGeMbb7vK8Mg571zM++WUT9vxPRh2XvaDA=;
	b=g73bbAlntF9o0D32173A5UzD8PbA82TRzdkHgRHTOG010trfvzYNa40H086NQO7nTKkfWM
	cq7VodJ6pQLSbVnXXUjl7jHUPPhWjMMPyvdZ8vnmfQ4MDL76aV6tilYDDiQ2X0NNhZNr25
	4BnDGMdtkLWNaQQUS81sjL9r+8J3oKI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-ih4dCwmYM1mBXk6becXcqQ-1; Thu,
 19 Mar 2026 10:12:29 -0400
X-MC-Unique: ih4dCwmYM1mBXk6becXcqQ-1
X-Mimecast-MFC-AGG-ID: ih4dCwmYM1mBXk6becXcqQ_1773929540
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C5AF1954B17;
	Thu, 19 Mar 2026 14:12:20 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.66.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 54A8E1800576;
	Thu, 19 Mar 2026 14:12:16 +0000 (UTC)
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
Subject: [PATCH 4/5] PCI: enable async shutdown support
Date: Thu, 19 Mar 2026 10:11:41 -0400
Message-ID: <20260319141142.5781-5-djeffery@redhat.com>
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

Like its async suspend support, allow PCI device shutdown to be performed
asynchronously to reduce shutdown time.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/pci/probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bccc7a4bdd79..4d98bab2163d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1040,6 +1040,7 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 
 	bus->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(bus->bridge);
+	device_enable_async_shutdown(bus->bridge);
 	pci_set_bus_of_node(bus);
 	pci_set_bus_msi_domain(bus);
 	if (bridge->msi_domain && !dev_get_msi_domain(&bus->dev) &&
@@ -2749,6 +2750,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	pci_reassigndev_resource_alignment(dev);
 
 	pci_init_capabilities(dev);
+	device_enable_async_shutdown(&dev->dev);
 
 	/*
 	 * Add the device to our list of discovered devices
-- 
2.53.0

