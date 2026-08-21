Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9EF4D8D89
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 14:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322316; cv=none; b=ZdoFRus9vtzQIHBNzo0TkLn8FwJrTI+N8fgmpselvKNycPvE66wL4hJZjnGuooCKAgUoCKtBc4e4xZQZTIKU7Jk44oWnY/pB9/0LsEWB0NAPYFcsunCfzSOBtBCCPD5KWtEbS29TGhg4NfYkWW0tEj/UnY7klBIShGhAaREBlxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322316; c=relaxed/simple;
	bh=NMGsdHfv3kJB9yX9focVMEcZIChlcDtecusG5LE85CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSuZ0mQSMLZFus5AhfnXYptP/TgK74F8E1PCKdeDgbUgmNdU8sy/+RPiqoSUKqCYKsFlTscx0WioDeWa1MvKUT1EfTtInXJlaeNErVQQQO1kcHnwlFGVVqMzcHt6p0QjrulEsy1/RIFgkRXEXEm89tXQjsW2T+d6oLwwOYC7/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QT++ODcV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QT++ODcV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787322312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qUje89Fd4abdoDeewa2Je7uJEn5QSHfX2TySvfVb0Hk=;
	b=QT++ODcVzdXx5nkbpYMLaxF6wIdi0Xr3cmEQdtqW/+lHPXLJajCuqNQkAf4wl9HA4RsY6O
	7+LEnjJd6mXWfft3VRsOGla8c11cONvb+FXYg1pVrtujwF7sYCAadyCixR0VnfIOABhNKZ
	RGpUdDtcyG0xGx2WzG2GqX5THgVAQZI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-356-W2RI67c_PTGqth6y7MB6JA-1; Fri,
 21 Aug 2026 10:25:06 -0400
X-MC-Unique: W2RI67c_PTGqth6y7MB6JA-1
X-Mimecast-MFC-AGG-ID: W2RI67c_PTGqth6y7MB6JA_1787322304
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F9661801209;
	Fri, 21 Aug 2026 14:25:04 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E3681800346;
	Fri, 21 Aug 2026 14:25:01 +0000 (UTC)
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
	David Jeffery <djeffery@redhat.com>
Subject: [PATCH 7/9] PCI: Link a virtual function to its physical function
Date: Fri, 21 Aug 2026 10:24:12 -0400
Message-ID: <20260821142414.150892-8-djeffery@redhat.com>
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

With a PCI virtual function having the same bus for its parent
as the physical function it is associated with, there is no
explicit dependency between the two in the device tree. With
async shutdown, this can result in the PF being shutdown before the
VF has an opportunity to shutdown.

Link the VF as a consumer of the PF to note its dependency and
ensure clean shutdown ordering.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
---
 drivers/pci/iov.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index b0d24839c084..c75da093d60c 100644
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

