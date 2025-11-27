Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5D23375A0
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764258880; cv=none; b=XDASbzodFNKP5j8AdrS6IsA2Y5aBr6pX3NxeZHtV78KgqlWXRGFo0+JNMQ6xZ50f9z9qVYrvWhTNc/n0sIZXvAwMaSVkduIZiGnZTqWImJM5yyK10N70NV9fWpCG8wPRqQncVlU15EPpdHv3ndIwNWV+0oJ+/4SS7A01lfqHHQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764258880; c=relaxed/simple;
	bh=EyFIbKgcE2nNkpl/0llNSGiEXglIJGx3J0RgOMEIjfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcSIkac8L/VA/GDkfNIqMAGtrV+iJXKHAsBSyiN0btSkW3s12nWXfvb43+eRim4/X6ihW8TIkesgC5SLlVzgmbw1YzrkJydZl58VvojTLCt5K+Td/GFKe3sSg4idIWvVsYWcTjifUu0aBMMzVJ+VIWDsmsiB92fXMfPTjlaQ+LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QsjcsMX7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QsjcsMX7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764258877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9eGE6EKz24C+DQ/SaMTDwnGe0jrgOz1z3E9DUmUtjrk=;
	b=QsjcsMX7A6nfDSq8eK1xE4hnlWja0FPnqWLpUgwctzmGdnn6V/dFLK6zoYZg+bEh07z6pa
	AVxun7fpMPwGXIIVVppNlPK0ZHFsk6soCT/cgS4UCVXv6wEbOu3SrazAHJ9HqofhlSpvEE
	T197+qL+cM/HyxjPzmsbC9nEjpdCcXw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-203-8uz7N-XOMO2lb15TkskJNA-1; Thu,
 27 Nov 2025 10:54:32 -0500
X-MC-Unique: 8uz7N-XOMO2lb15TkskJNA-1
X-Mimecast-MFC-AGG-ID: 8uz7N-XOMO2lb15TkskJNA_1764258870
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87040180049F;
	Thu, 27 Nov 2025 15:54:30 +0000 (UTC)
Received: from localhost (unknown [10.2.16.53])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8FAAB19560B0;
	Thu, 27 Nov 2025 15:54:29 +0000 (UTC)
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
Subject: [PATCH v2 1/4] scsi: sd: reject invalid pr_read_keys() num_keys values
Date: Thu, 27 Nov 2025 10:54:21 -0500
Message-ID: <20251127155424.617569-2-stefanha@redhat.com>
In-Reply-To: <20251127155424.617569-1-stefanha@redhat.com>
References: <20251127155424.617569-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The pr_read_keys() interface has a u32 num_keys parameter. The SCSI
PERSISTENT RESERVE IN command has a maximum READ KEYS service action
size of 65536 bytes. Reject num_keys values that are too large to fit
into the SCSI command.

This will become important when pr_read_keys() is exposed to untrusted
userspace via an <linux/pr.h> ioctl.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 drivers/scsi/sd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0252d3f6bed17..e436ed977cdb4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1974,9 +1974,18 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info)
 {
 	int result, i, data_offset, num_copy_keys;
 	u32 num_keys = keys_info->num_keys;
-	int data_len = num_keys * 8 + 8;
+	int data_len;
 	u8 *data;
 
+	/*
+	 * Each reservation key takes 8 bytes and there is an 8-byte header
+	 * before the reservation key list. The total size must fit into the
+	 * 16-bit ALLOCATION LENGTH field.
+	 */
+	if (num_keys > (USHRT_MAX / 8) - 1)
+		return -EINVAL;
+
+	data_len = num_keys * 8 + 8;
 	data = kzalloc(data_len, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-- 
2.52.0

