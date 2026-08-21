Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5560F4C6EE0
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 14:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322304; cv=none; b=VVkCHa5J7OS4/Vpf1mEFbbqsMzxaxFTgFPJZ8ZQTO0GhSAeEaAz8XtPeHAi3b7owZIPlIRIywFV9d1nC6IW2x2yRiIPCTtN+gLX4wnpr2o9q3CrdH/h6lLHIRkj4gB8eqpfRVBQwxk6CimoK08b7nTGdgmXJV30pjCmFczpqpvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322304; c=relaxed/simple;
	bh=3lQMPdYbR1RntwK+bxjJtg5kiwvAYZO4Z6X9Nwg+SoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bp756r5cJO6xCCQc2/gzDd7/EH4nIi+0x7/Ks0Yc9sHvwI8UUQ5mrEvXiVNBleRU+AHAVLmRQxGGfqdkax/BOGypLqquyiDSlT8m/YevbIwRdvnYPehinLtumrkrtQBbq5JqKs1JUOWsKL3mXWsPpyrqY+OR+pDFzvJ7WxfQx+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FbEI0Z/f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FbEI0Z/f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787322299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IU0vv4gN2o5y5prXUpJQRh2FejWBebUitlBF1Qr8ENg=;
	b=FbEI0Z/fwJeAkfo8wFinbf56id4Qs11t9jXaqn/8EZMQuJkHB+mBzhX9t53i3070oMcW29
	xdU/rLD4DdmocUrm94ikhBd1WhRK4Iujd6uoNQc7L1TBOm1rfU3mm0GYBtY0hdJX8Rdll5
	3jpHDv2Kqsxxmxns12EdOCK4qZpwmL0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-255-E0vuZrlmMeSZFl2-63xpJw-1; Fri,
 21 Aug 2026 10:24:55 -0400
X-MC-Unique: E0vuZrlmMeSZFl2-63xpJw-1
X-Mimecast-MFC-AGG-ID: E0vuZrlmMeSZFl2-63xpJw_1787322293
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22CFF1954208;
	Fri, 21 Aug 2026 14:24:53 +0000 (UTC)
Received: from djeffery-thinkpadp1gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C2E6180034F;
	Fri, 21 Aug 2026 14:24:50 +0000 (UTC)
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
Subject: [PATCH 3/9] driver core: warn should device_move try to move a need_parent_lock device
Date: Fri, 21 Aug 2026 10:24:08 -0400
Message-ID: <20260821142414.150892-4-djeffery@redhat.com>
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

Currently, no device has need_parent_lock set and is moved by
device_move. need_parent_lock is only set by the usb bus and very
few device types ever use device_move.

Add a warning to device_move to catch should it ever be used on a
device with need_parent_lock set. The combination would break
the immutable relationship needed between parent and child for
need_parent_lock when locking and unlocking both.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/base/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index bd9c2921e326..75f5931165a8 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4712,6 +4712,14 @@ int device_move(struct device *dev, struct device *new_parent,
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

