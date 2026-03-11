Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFE13451AF
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 17:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773249149; cv=none; b=CgnAfzH9bwjVIxGOlDdZiXZsWFLxy/Ulx9IarrH6TN1PXSObx4Mji8JCaCc9LFwlDIEkgk017lmEy6iZnNswBC49OspEaCNTgGGh8dfAvbZ93FiD1+h7omPCl+X0BBbrgSg5SJSW3CpEcMUjrNXfYX8Z4AsDtKmALDYM71skaF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773249149; c=relaxed/simple;
	bh=oMYSsjZWvjVXDDN94rVkng6pnmuGOjtrPyUOLFvljZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z8bYh4Ks6zzqHUg4o6BJWm0p+D+EvmAMTaJ/XxyHZqBDhCOq9EsnNPXRJo34mLlJnvcFbmWLncEDeB2WtPfzmpY6ymtCtWJ9D2XlyPUn/f2hwbJI34KdHe4XgNsWjX5iHgtcKufRNOYtoep8uqIEV5p5painXTgRLCD8I1K/Jzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UbovMP5U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UbovMP5U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773249147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hoR3Uf9D08Gkdy6PpJ8ADIRGGVcFR7T5AFLKuzSnTCc=;
	b=UbovMP5UUSwks7WbrYsU1BwIWYgI4XTC2MsmAeCg2kRAD/darQG5xFcSrN0rTt245SoGbX
	dekhZJ3FrGJ2o/B4oLEZ8OEvEmvcuX+uMsVEAK0KfOhfMOM+qqznoDJDjXEhqWrU6vkRLA
	1vS2Fsrq7BcRtAE6awIUaeJ5MFpIuVY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-dhO5FhoXOv6aeBfLs7swNQ-1; Wed,
 11 Mar 2026 13:12:24 -0400
X-MC-Unique: dhO5FhoXOv6aeBfLs7swNQ-1
X-Mimecast-MFC-AGG-ID: dhO5FhoXOv6aeBfLs7swNQ_1773249142
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A65B1956089;
	Wed, 11 Mar 2026 17:12:22 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.81.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF0D63000223;
	Wed, 11 Mar 2026 17:12:17 +0000 (UTC)
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
Subject: [PATCH 1/5] driver core: do not always lock parent in shutdown
Date: Wed, 11 Mar 2026 13:12:05 -0400
Message-ID: <20260311171209.9205-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Don't lock a parent device unless it is needed in device_shutdown. This
is in preparation for making device shutdown asynchronous, when it will
be needed to allow children of a common parent to shut down
simultaneously.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 791f9e444df8..eb54fc9680de 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4819,7 +4819,7 @@ void device_shutdown(void)
 		spin_unlock(&devices_kset->list_lock);
 
 		/* hold lock to avoid race with probe/release */
-		if (parent)
+		if (parent && dev->bus && dev->bus->need_parent_lock)
 			device_lock(parent);
 		device_lock(dev);
 
@@ -4843,7 +4843,7 @@ void device_shutdown(void)
 		}
 
 		device_unlock(dev);
-		if (parent)
+		if (parent && dev->bus && dev->bus->need_parent_lock)
 			device_unlock(parent);
 
 		put_device(dev);
-- 
2.53.0

