Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1751257851
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2025 16:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764174974; cv=none; b=omoSrm1VafwcdoXjr1Je/u2fj9dqFqMPNS3AiyCoZXi8w3zls6qnUpyowLT6QsC1cROerEhPTKnCVI7gMkmCZwQvYQQ6BtuG2OK+h2ilLbQmOGhyqbLBrbg+Lm5KTDEeK+vgqzAG7Y/nuyFP0llTs4G37HURkYmYsWX35ik5+Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764174974; c=relaxed/simple;
	bh=t1WBGDn4nkjwC+1pkvMnmGCaagP+vHBvMlJD6YiLB7o=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=oz5kEU2Xo4g8UBiZ5u3PnnphaxOSmAEhAo4pDgY/DMv0qJI1iMTNgzakS1uoPp+q0seHXmNmGPu92sAaoF48uzUr/7bAjXV6JYkWYOoUDNfwDRlA3L/cXqGxmIkYuVq3QKTqYcJFmO85BTbEIvfsxFGtnE0TTjLJGZTWh6HbEYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hobafREM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hobafREM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764174971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DoS6Oj4etNgwsMajVTmJIqYHnPKCCag9vshgTAQJXtY=;
	b=hobafREMPpFSKDbIN5G7HJol221sluHq2EJzxfpunADNZPgX3LhXmifhRLLUutUtJ/1urN
	A0Y91YbpLN0yyTCkGIG3dGsAIcPLWdlc1h7fm8eD/BGKOOHb3i66683Zc0mTF8+4b2C00G
	cZILyjHWs4TZKIHToJuYsFDTgKpbM6c=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-nquCTKv3Ox2_N7An0300BA-1; Wed,
 26 Nov 2025 11:36:06 -0500
X-MC-Unique: nquCTKv3Ox2_N7An0300BA-1
X-Mimecast-MFC-AGG-ID: nquCTKv3Ox2_N7An0300BA_1764174964
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E366B18001FE;
	Wed, 26 Nov 2025 16:36:03 +0000 (UTC)
Received: from localhost (unknown [10.2.16.50])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B9D3A18002A6;
	Wed, 26 Nov 2025 16:36:01 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-block@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Mike Christie <michael.christie@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 0/4] block: add IOC_PR_READ_KEYS and IOC_PR_READ_RESERVATION ioctls
Date: Wed, 26 Nov 2025 11:35:56 -0500
Message-ID: <20251126163600.583036-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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

 include/uapi/linux/pr.h | 14 ++++++++
 block/ioctl.c           | 79 +++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/pr.c  |  5 +++
 drivers/scsi/sd.c       | 11 +++++-
 4 files changed, 108 insertions(+), 1 deletion(-)

-- 
2.52.0

