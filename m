Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514719;
	b=BVTQRk8mbeZk0ebuUvM6he+QGHQOXYOa7zQGoqZwbu21qazDguwl+nX/BMyXCCYc5pof
	 WRlhMe5cs3gc7UYcFcxjLTrTZtRJ/bqEwUsocnXX2Xm+L/qeajfI47zoB+Al4BAdBiBrl
	 IuzbHsI1Pbat4dz146GncGD+Fovr12tlNtA1R/3b0tNEg5UgK7WoXFlfsdc9Ad7onv4EQ
	 yTxMPi2FQ6PiqltebFR+mR4boHAfKmzeGMdRRfllGVgyt8Kfr3uP68Chmr6+xieQfTH0q
	 DaOKNDb94XJQ0YSQyJ1UTrQefuGUc44XAznjom3G8WcSj5T+OAcJmahsuEk6m4aGNMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514719;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=6CVM95O8nJA2j5PntuVbYrjGyYXMZc4AlBaFKMW1Qic=;
	b=ls9VdwXu9BFfMGEsJzOu1b9jPb351Tq+oDlmKvvS9MlxWDYnzh0AccK8LHTaDwh+MWs4
	 UH4RtB3pbVIwgTPJq5ksvFsGWNz7dx/LSseDFzyjoYgiSrvYiyRmJiplP6nptfrqvmMea
	 SGhXDrv0pJW+qOYoiwMrCOaklrHTV0z6Et2YeiqKReM8O95Wra1jbuzypkBjBEWRQEFPo
	 FqdYwlZVDGHVQ8jk5fqCb1B/aVX/EyR9xj/tkzZC8ylmItUddb9roElfNLC3jUOkeW+7m
	 nedSR8HjtU4fUuPnF/P7kjrjAE+jt+pVYZN2gu+L+0K22fn2fU75+IYzeD14zmlCkNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EZGqUZAT;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A6860A261F
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 16:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27A6860A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EZGqUZAT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792514717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6CVM95O8nJA2j5PntuVbYrjGyYXMZc4AlBaFKMW1Qic=;
	b=EZGqUZATkaJWLIovzhm0RmcX6NIuWugkNacFlp+vt8XvN5wps3zsue3KJfAEcrKH52qQfC
	ydw9u5L+7qlI4uH/q6+LMRAIaK+U/T89N+cr2gcCkROAsjPilXtXfLnocdMNYXs3/jn6VF
	aAq5jqHZdS42YTS+zBpCTNOVrT+7g4w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-349-ujwPqpUtPIa42pYUcohVfw-1; Tue,
 20 Oct 2026 16:45:13 +0000
X-MC-Unique: ujwPqpUtPIa42pYUcohVfw-1
X-Mimecast-MFC-AGG-ID: ujwPqpUtPIa42pYUcohVfw_1792514711
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A2F51945CB3;
	Tue, 20 Oct 2026 16:45:11 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 604D13000617;
	Tue, 20 Oct 2026 16:45:07 +0000 (UTC)
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
Date: Tue, 20 Oct 2026 12:44:33 -0400
Message-ID: <20261020164435.80499-8-djeffery@redhat.com>
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

