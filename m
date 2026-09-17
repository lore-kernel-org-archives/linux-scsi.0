Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764885304AE
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 16:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663109; cv=none; b=aSLpNmTKWCbpSmN8iaeDwOYY4SnSeZBYLx+4+GwUtd/9eBHPriEwI5vE4q921WfYhhG7EK8sWJdGE/KG/WFInh1nB9/Fq5f5Mbbi/esFQMO7e8TlXOesDjJc6m3qcvLREQ4th5dr4Fesf70gtmaMW45jVSLNlXt5TDDmNOlJJcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663109; c=relaxed/simple;
	bh=eNLC4ZzypIvS3WzbYcz7lFQurlQk7Y3PYIywCoFC+MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th8BByWK9i+nXHcNJNpJgdO9zaatjWS8GGLBIlz+jCQvWv+qfbNUe3LJPe1c/QLY864moTTRxryxOEgYKau9vOZi/ZHo9i6c2JVu9xkwGZTP8aRtaG55I5ATi34GWmRDjhKpVBWEA5iIbKBsUUbdqlYCGD0CFwe/y6XHbNb2W4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AwNslG6k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AwNslG6k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789663106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6CVM95O8nJA2j5PntuVbYrjGyYXMZc4AlBaFKMW1Qic=;
	b=AwNslG6klItLL6WqWd2n5wUpZl2jzPJx88sTbebKmsieKRW3k3oUIMfB0SGk/wVNGyL4q9
	gpsulGgYoRSUi5gqc1tAgxk9J5bBva318AqyEtC8D5lgSqtcbl0nbIrxhOiI8iUJc0CAdM
	emq0Cz4bpuESUH2EA/29tok6XqgZ4KE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-489-IyQ06wh3MyeKK2BB8h10PA-1; Thu,
 17 Sep 2026 12:38:23 -0400
X-MC-Unique: IyQ06wh3MyeKK2BB8h10PA-1
X-Mimecast-MFC-AGG-ID: IyQ06wh3MyeKK2BB8h10PA_1789663100
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C82E21955DB3;
	Thu, 17 Sep 2026 16:38:20 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.rmtusga.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8430C1800361;
	Thu, 17 Sep 2026 16:38:17 +0000 (UTC)
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
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 7/9] PCI: Link a virtual function to its physical function
Date: Thu, 17 Sep 2026 12:37:42 -0400
Message-ID: <20260917163744.191748-8-djeffery@redhat.com>
In-Reply-To: <20260917163744.191748-1-djeffery@redhat.com>
References: <20260917163744.191748-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

With a PCI virtual function having the same bus for its parent
as the physical function it is associated with, there is no
explicit dependency between the two in the device tree. With
async shutdown, this can result in the PF being shutdown before the
VF has an opportunity to shutdown.

Link the VF as a consumer of the PF to note its dependency and
ensure clean shutdown ordering.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/iov.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 9d408fb8ac25..9b74211c6ab4 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -382,14 +382,20 @@ int pci_iov_add_virtfn(struct pci_dev *dev, int id)
 	}
 
 	pci_device_add(virtfn, virtfn->bus);
+	if (!device_link_add(&virtfn->dev, &dev->dev, DL_FLAG_STATELESS)) {
+		rc = -ENOMEM;
+		goto failed1;
+	}
+
 	rc = pci_iov_sysfs_link(dev, virtfn, id);
 	if (rc)
-		goto failed1;
+		goto unlink;
 
 	pci_bus_add_device(virtfn);
 
 	return 0;
-
+unlink:
+	device_link_remove(&virtfn->dev, &dev->dev);
 failed1:
 	pci_stop_and_remove_bus_device(virtfn);
 	pci_dev_put(dev);
@@ -421,6 +427,7 @@ void pci_iov_remove_virtfn(struct pci_dev *dev, int id)
 	if (virtfn->dev.kobj.sd)
 		sysfs_remove_link(&virtfn->dev.kobj, "physfn");
 
+	device_link_remove(&virtfn->dev, &dev->dev);
 	pci_stop_and_remove_bus_device(virtfn);
 	virtfn_remove_bus(dev->bus, virtfn->bus);
 
-- 
2.55.0

