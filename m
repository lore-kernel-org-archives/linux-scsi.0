Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E2679CF
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764625419; cv=none; b=FKxfRdUq3jiAMsU7RiwAYk3Ob4uFzlfO7Lv2EG/AN8XV1KIxrTTmeqkuOxwKQoEekn5jLV+gba4anH9mPku4H/gOIBT987cC46idjtJesWdGwwHbI8NF1OSuLaN+vOzFhN4c1KpwVfI5hwEiO+FFXVvR2aiVMuDU7/QIgix1wdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764625419; c=relaxed/simple;
	bh=TF1L8dce8PYnSwcys2POXqQBeYsWcN0+q74aEjOLug0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RIQz3JLOExCUzJT0pxRT7HqjV8FjaQ0qZScLyiJ3/F78yp9OvwPpJe87fDOgASKDZ8Kmm13klJ2bmGDSc74ur4rMF85zfyNSAxt4sdBSuMeUDAEklq+CqBBBCoLeOHer42BlYqxTZpZz7j8YuK1Yg8ytFgx/22ELhYDueSN1/cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYr+8alq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYr+8alq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764625416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yrYQN3GFchT9vktyOBuE240rtI/tNrya4XeIT60BS5g=;
	b=TYr+8alqx1s7bHZrjEEVmYn0wr77U3xdjGPgE53T/bqzwydONyBKQwO1ZKev0+W4AwaYtj
	PJxpR9mOKhMZqyi4qmnSa69cjXEMHCrmA6i80M9jEWeCZ22eb41vQuSwrKKIz0oOxTCXAa
	xPnYXlwOqrYpbyzWq5mcLUMNIqK2Qdk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-326-aBrDrz7yNLyJJu19yzJ8HQ-1; Mon,
 01 Dec 2025 16:43:34 -0500
X-MC-Unique: aBrDrz7yNLyJJu19yzJ8HQ-1
X-Mimecast-MFC-AGG-ID: aBrDrz7yNLyJJu19yzJ8HQ_1764625413
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 101991800452;
	Mon,  1 Dec 2025 21:43:32 +0000 (UTC)
Received: from localhost (unknown [10.2.16.172])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CE40F19560A7;
	Mon,  1 Dec 2025 21:43:30 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Mike Christie <michael.christie@oracle.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-nvme@lists.infradead.org,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v3 0/4] block: add IOC_PR_READ_KEYS and IOC_PR_READ_RESERVATION ioctls
Date: Mon,  1 Dec 2025 16:43:25 -0500
Message-ID: <20251201214329.933945-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

v3:
- Use checked_mul_overflow(), struct_size(), etc to avoid duplicating size calculations [Christoph]
- Don't use __free() from cleanup.h [Christoph, Krzysztof]
- Drop one-time use num_copy_keys local variable [Christoph]
- Rename inout local variable to read_keys [Christoph]

v2:
- Fix num_keys validation in patches 1-3 [Hannes]
- Declare local variables at beginning of scope [Hannes]

This series exposes struct pr_ops pr_read_keys() and pr_read_reservations() to
userspace as ioctls, making it possible to list registered reservation keys and
report the current reservation on a block device.

The new ioctls are needed by applications or cluster managers that rely on
inspecting the PR state. This is something that has been possible with SCSI-
and NVME-specific commands but not with the PR ioctls. I hope to move QEMU from
SG_IO to PR ioctls so that NVMe host block devices can be supported alongside
SCSI devices without protocol-specific commands.

These ioctls will also make troubleshooting possible with the blkpr(8)
util-linux tool, for which I have prepared a separate patch series.

Stefan Hajnoczi (4):
  scsi: sd: reject invalid pr_read_keys() num_keys values
  nvme: reject invalid pr_read_keys() num_keys values
  block: add IOC_PR_READ_KEYS ioctl
  block: add IOC_PR_READ_RESERVATION ioctl

 include/uapi/linux/pr.h | 14 +++++++
 block/ioctl.c           | 84 +++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/pr.c  |  6 ++-
 drivers/scsi/sd.c       | 12 +++++-
 4 files changed, 114 insertions(+), 2 deletions(-)

-- 
2.52.0

