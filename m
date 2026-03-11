Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4607F3451AF
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 17:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773249172; cv=none; b=if/Sm4tbMBLumGDEhRLRwyz84w5VNfU9GbEIkj6qvFUno7RHr7oN6jSL8xeQudo0fYd98soR5Ht266oyxY/sx7Jf1cnpFSTz/Ubkeoc0XMzEWwX/UzRzuWM/ccyFeqskO/LZTkcrMgq7fr+DqX8Qc4brnOEXzQXZg/ABeX2HYDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773249172; c=relaxed/simple;
	bh=mqov64Q7xERA+qUIkNCXJPQ+cTsi1l792QPgdzTZoaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSi4hnHvHwXDBUj0HfnQ30rotiRzyRSDHIfJo+4uQm7YxqOHfCPFFq+BU/atOkMG91bvG50HJWX65bK8ZoaCMYtJgmg4hIvIxafiuKJZAx/9YkkN0Ag/mfyE/hlAZZ18Axj5jnqQyjy3NauVdqUFmnUY5ydPm5VjwwEFLtokZ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TZja0yeg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TZja0yeg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773249170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yPVITJt2K8F+nk1Q0Tnua2+Ypue2g3iDX1HGsSsdoqI=;
	b=TZja0yegDlPmfWpvoBosFpvlefLITE5Tw3DiORWnjuC1W5z0zBi4xd76/eltW+0y9yLw6L
	+fn55bQYlvdtdWXnQ2UYA9LuLw2JTBIH2yZdBwCyRmZc79C0bmPovKujQqXiKStS24enYf
	M/+i3KADLq6W1uwoOF6ixLPwdO9uEfU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-WMUx9dcZML-ZkrAxTjPhRQ-1; Wed,
 11 Mar 2026 13:12:46 -0400
X-MC-Unique: WMUx9dcZML-ZkrAxTjPhRQ-1
X-Mimecast-MFC-AGG-ID: WMUx9dcZML-ZkrAxTjPhRQ_1773249164
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F1A319560A2;
	Wed, 11 Mar 2026 17:12:44 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.81.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CF703002D0E;
	Wed, 11 Mar 2026 17:12:39 +0000 (UTC)
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
	David Jeffery <djeffery@redhat.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH 4/5] pci: enable async shutdown support
Date: Wed, 11 Mar 2026 13:12:08 -0400
Message-ID: <20260311171209.9205-4-djeffery@redhat.com>
In-Reply-To: <20260311171209.9205-1-djeffery@redhat.com>
References: <20260311171209.9205-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Like its async suspend support, allow pci device shutdown to be performed
asynchronously to improve shutdown time.

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

