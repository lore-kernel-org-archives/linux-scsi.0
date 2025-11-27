Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07516313266
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764258876; cv=none; b=ist1CjU0eTypDYbj2kSRGtMvd3+OrTTQeL+wWUTw9OAPUoQh5s+6hGfT//jzSKCcxkJzXsdjDMPaHEODjZxJez6EMK6UGR0lbBNLlUU3mV286su4A8K/dBUWs8DmajI4LGQqp1TROnsvMuJ61v6wmieY9tG/NfV1Oafs3Yonty8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764258876; c=relaxed/simple;
	bh=IggaIThoKT3o/zMIe/YIBze4xbZqQOTOUkALt7f2+r0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kclBHXe+n9Wu6KLkxWJa5G0gCmDH4JhRfFhtaoBWHZKfeu4O59rqB8Hmv8BpDMkGZQR6x/2mRiPt1OlzPORbHeptp6Fqyo+A32+HbFQ8kOe1wrz/fZP919toFQFPnDQUE2cH+0gnoQ6oGwAcMxgVptZ4N5UUw03TG7FSYEK4kqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZS0JoGxK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZS0JoGxK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764258874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ou4g2gpbqdyWYYdF4trm4Wyw1sQfHw28pV0QqLzlfAc=;
	b=ZS0JoGxKNkF1W0oZ/9AiJL9Pd84MmZrEjSI2a7tjDBgYT6DnGK1AgzKvsoRYITVBEs7RzM
	pT905H2u78srulgtDwBz7P6XrAbGexD+DwOw1VZJ+QOBtWqbbMA7UThnAb4zG3aCaYWqWI
	1P8lPghZxQE4pgNSQGist/jYP/EUzbw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-oGuaWfK9POKJ1NkOxmYQxQ-1; Thu,
 27 Nov 2025 10:54:31 -0500
X-MC-Unique: oGuaWfK9POKJ1NkOxmYQxQ-1
X-Mimecast-MFC-AGG-ID: oGuaWfK9POKJ1NkOxmYQxQ_1764258869
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DB32195609D;
	Thu, 27 Nov 2025 15:54:28 +0000 (UTC)
Received: from localhost (unknown [10.2.16.53])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 13FEF19560B0;
	Thu, 27 Nov 2025 15:54:25 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-block@vger.kernel.org
Cc: Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	linux-nvme@lists.infradead.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v2 0/4] block: add IOC_PR_READ_KEYS and IOC_PR_READ_RESERVATION ioctls
Date: Thu, 27 Nov 2025 10:54:20 -0500
Message-ID: <20251127155424.617569-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
 block/ioctl.c           | 87 +++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/pr.c  |  4 ++
 drivers/scsi/sd.c       | 11 +++++-
 4 files changed, 115 insertions(+), 1 deletion(-)

-- 
2.52.0

