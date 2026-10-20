Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792514704;
	b=QhHfWdjP3tZwt6po8PRU0vNS5CJlKLNkpdLn0qA01+E2THrzoeSzg5PLFn4iAVjD5out
	 92HPGMnHUWxYaLne9shDTFEYscW18qikcVWHl7idyjV9QJPycormDY89jig+zYnR6LnH2
	 HuN5aIU/5aBdM9DwIUi06w1BNeIRQvqENBYF/F1cigMHNM10jvRxafBfNVA7pHRhrl95+
	 fU/+PCmfZHfGD3YM/4FmG+xla4m2aNCc2tU+2ZGqADbrWrLcBUHBLAg0zYPa+CKx2nWoa
	 7vxpiudj524hMCJ5W8q2tYxkj7lcgxeNBC5W6yKaCXLynUMDe4Zv1e+99JCWfIaMR0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792514704;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=OLtaBWF2S8xYQupQu7qrCH159MdeXfdQdbvdeZt1vZM=;
	b=V7cuEXDbTVX9skVetbM/FjOdsr8VZCRFLUjN3EbGPgRRHCE89reDzWDMiF22Kt5jupvO
	 dl1WXlrVtYCDVDzKPmt5c558X86U+ctXNIiJc/urnqcdEsBSeTGpJ7/Tlm402R7ZMxNB+
	 VHwEK52aZKcCYX1GvK1JW9DeFos9x6FiICFrdvZ7DAPsv8mnYWyKkNslspeDBg4SWlwdw
	 7jsku0TNeP6SrNFquO/MNeEuLEUCZY2ml4Q1NkUGcDsIxo5QNuXRiv+yGyr5Q9yAlcbAK
	 ARHhkvNzVI1Xo6gOuyW5r4t3PPLfIcJbuZhv8RniUhHY8bzIXBLHGEt19oeeBxgnt1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ivG513yv;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BD060A2615
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 16:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68BD060A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ivG513yv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792514703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLtaBWF2S8xYQupQu7qrCH159MdeXfdQdbvdeZt1vZM=;
	b=ivG513yvL52pJz204cC6fbsghpmz+B6nrXpuI41CpFp9jvtpMPlrUDBeXAinL4IyGT5lxt
	0nJybx2kSNkSe7ymMICZpugOS35seuHnmOST+DOJr5BoNc93E19BwKPQzX4llGyN7ESlX1
	reiufqZR2zPqFpSCiyWQaSzT8THqRKo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-3teFs58-MqKA_K66TtvFKw-1; Tue,
 20 Oct 2026 16:44:59 +0000
X-MC-Unique: 3teFs58-MqKA_K66TtvFKw-1
X-Mimecast-MFC-AGG-ID: 3teFs58-MqKA_K66TtvFKw_1792514696
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 496A61945109;
	Tue, 20 Oct 2026 16:44:56 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0F48D30001A2;
	Tue, 20 Oct 2026 16:44:52 +0000 (UTC)
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
Subject: [PATCH 3/9] driver core: warn should device_move try to move a need_parent_lock device
Date: Tue, 20 Oct 2026 12:44:29 -0400
Message-ID: <20261020164435.80499-4-djeffery@redhat.com>
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

Currently, no device has need_parent_lock set and is moved by
device_move. need_parent_lock is only set by the usb bus and very
few device types ever use device_move.

Add a warning to device_move to catch should it ever be used on a
device with need_parent_lock set. The combination would break
the immutable relationship needed between parent and child for
need_parent_lock when locking and unlocking both.

Suggested-by: Tarun Sahu <tarunsahu@google.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index bce555dd74f6..e8a62c8f0ad3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4705,6 +4705,14 @@ int device_move(struct device *dev, struct device *new_parent,
 	if (!dev)
 		return -EINVAL;
 
+	/*
+	 * device_move() should not be used on devices with need_parent_lock
+	 * set. Concurrent reparenting will violate the immutable
+	 * relationship needed while locking and unlocking both parent and
+	 * child.
+	 */
+	WARN_ON(dev->bus && dev->bus->need_parent_lock);
+
 	device_pm_lock();
 	new_parent = get_device(new_parent);
 	new_parent_kobj = get_device_parent(dev, new_parent);
-- 
2.55.0

