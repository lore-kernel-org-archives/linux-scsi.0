Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16E024468C
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2025 16:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764174974; cv=none; b=m3Px3AVecqOZqRgqUcEc7GxjiN1SFEVn8J0zBGSHcpe7Uehc8LZuoRiBhNNDbOYCvJoLD0K9f96LSTMrEyMIsIS99HtcO7338Fc6X6Ndep4hu73BaEhipVoAB+qAkn31g1rB9L0sBIDMK4ofxtttToVRnyA8lo/eK+7hxAw2KlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764174974; c=relaxed/simple;
	bh=hwN0X3MlXRgzLf/i/Ti7PYZd5dSD1XSxvGZQlmoWXRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/Kxn8dx5RNZyqjiQkqLHuvYMxUzafYX7nmvVsxfsbPBWuYIlz8lM+0zJhbTo76ZpDsAhVqpWvlVuHTF/aJcZTFce4k+mk1656Y8WOTqIkGi3RNRQJEwtvLU7WACm1rqIfnLRVoWiy1rj9ySkeauhF7KKDsW/Gmh+mBtkqh2VDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LWGbOZo3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LWGbOZo3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764174971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n8ULdLo4b3ORYhVubgD3gy7oPbpY6qArrsrgQiRkmsY=;
	b=LWGbOZo3mwPypE46sTP2N5qiDG+FjmQqlundWrOLZKeKDA65RtOjFyOpZYjElFkULpyGUh
	80Pxjrou84mULlfFxZKiOHVscoJmv6W/NS3PkxobvQ82II/Rt88N3q+XuYmc9hq/cIRSbU
	rfPlDMGYeadY6JZAsS+5UI6ELDwgEZ0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-9p40aK1TNFeth8KEkFpF8g-1; Wed,
 26 Nov 2025 11:36:09 -0500
X-MC-Unique: 9p40aK1TNFeth8KEkFpF8g-1
X-Mimecast-MFC-AGG-ID: 9p40aK1TNFeth8KEkFpF8g_1764174967
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33FAA1800451;
	Wed, 26 Nov 2025 16:36:07 +0000 (UTC)
Received: from localhost (unknown [10.2.16.50])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6C4A319560A2;
	Wed, 26 Nov 2025 16:36:05 +0000 (UTC)
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
Subject: [PATCH 1/4] scsi: sd: reject invalid pr_read_keys() num_keys values
Date: Wed, 26 Nov 2025 11:35:57 -0500
Message-ID: <20251126163600.583036-2-stefanha@redhat.com>
In-Reply-To: <20251126163600.583036-1-stefanha@redhat.com>
References: <20251126163600.583036-1-stefanha@redhat.com>
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
index 0252d3f6bed17..d65646f35f453 100644
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
+	if (num_keys > (65536 - 8) / 8)
+		return -EINVAL;
+
+	data_len = num_keys * 8 + 8;
 	data = kzalloc(data_len, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-- 
2.52.0

