Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6DE30AD1A
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929541; cv=none; b=SVTx3TBEdy+aQ6zPef8vXqjQG2sDBxHuSL1aZUV9wsLPiC8X0wGU2sL36Opjhva8sARsd/6XzI0Up9E1ip3g5qDMdF5YEvr0H2KcKVOPliKkL/Q4PkowLeTMyf5hbrly4b6V4kR6v0AWNGdqrVb9Rx5L5j6KNJL0sWjuNUvVLgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929541; c=relaxed/simple;
	bh=IfyjG0oQAceFxDXb4D6xoWuus9aQ/LmlQ+KniKVfTBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HacuqdKjSU+JqLadH/wCf3OAaKntUXxnsGsJPC18ZU5iFV5WPee9lARctzta34sIMx+dXWhhsyGzjHozUuXUgidJMOYrelNl2jZySFa69aofBOwwcSilEtrj1ODat7pl9YJO8KwAY9qTFcY79NoJUxkNHTufcnkLkFy/ysvTxTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ycv+Me3+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ycv+Me3+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773929538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f9patlQbuB55/bJm1JsV9uGRmDphoePFBzZFkCXjCLA=;
	b=Ycv+Me3+abpJnhNysk5we44Ok+z41MzJtJO0o0LF1ObnHMlAB+xQnl8ESOtArXoFVXAkql
	Ry6pUy97/HuxDtfIqicF2XW2+m8FXU6yNBCKEKELovMOwCqa4OnDsiqbyWe2QLxczPbBtm
	xcI1jy384ExnZ82LZ1vmKNbiSvds7fg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-rWK4Yi85M2a3SwDFL_sLtg-1; Thu,
 19 Mar 2026 10:12:14 -0400
X-MC-Unique: rWK4Yi85M2a3SwDFL_sLtg-1
X-Mimecast-MFC-AGG-ID: rWK4Yi85M2a3SwDFL_sLtg_1773929531
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 787B71800625;
	Thu, 19 Mar 2026 14:12:11 +0000 (UTC)
Received: from fedora-work.redhat.com (unknown [10.22.66.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 07C2F180035F;
	Thu, 19 Mar 2026 14:12:06 +0000 (UTC)
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
Subject: [PATCH 2/5] driver core: do not always lock parent in shutdown
Date: Thu, 19 Mar 2026 10:11:39 -0400
Message-ID: <20260319141142.5781-3-djeffery@redhat.com>
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

Don't lock a parent device unless it is needed in device_shutdown. This
is in preparation for making device shutdown asynchronous, when it will
be needed to allow children of a common parent to shut down
simultaneously.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 10586298e18b..2e9094f5c5aa 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4782,13 +4782,8 @@ int device_change_owner(struct device *dev, kuid_t kuid, kgid_t kgid)
 	return error;
 }
 
-static void shutdown_one_device(struct device *dev)
+static void __shutdown_one_device(struct device *dev)
 {
-	struct device *parent = dev->parent;
-
-	/* hold lock to avoid race with probe/release */
-	if (parent)
-		device_lock(parent);
 	device_lock(dev);
 
 	/* Don't allow any more runtime suspends */
@@ -4811,10 +4806,20 @@ static void shutdown_one_device(struct device *dev)
 	}
 
 	device_unlock(dev);
-	if (parent)
-		device_unlock(parent);
+}
 
-	put_device(parent);
+static void shutdown_one_device(struct device *dev)
+{
+	/* hold lock to avoid race with probe/release */
+	if (dev->parent && dev->bus && dev->bus->need_parent_lock) {
+		device_lock(dev->parent);
+		__shutdown_one_device(dev);
+		device_unlock(dev->parent);
+	} else {
+		__shutdown_one_device(dev);
+	}
+
+	put_device(dev->parent);
 	put_device(dev);
 }
 
-- 
2.53.0

