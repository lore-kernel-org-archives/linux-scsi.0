Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342A5280325
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 21:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764625422; cv=none; b=Mpm3acxyHYv2gYDCnVqRaI28Qrc0TcKVbyNb/YifYHi7itOPu3M77eR+c9/kVvvMojjURFvrgGX1MbUOS/3GUipouhuMZfiwo76QaS1BVhdGDLp+D2cOfH5l23oJ7CNcc9EETrRt4v3wSfuHO3N9Ja6xUf8rsA9U+nnz4AHDnus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764625422; c=relaxed/simple;
	bh=TR0EdIYUty1k7XAJrVdGgQmooXt5n/aX214Ma7BluEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoGmzAc3XcQ4NGliycJRJOABen+4rUAokmzEVqJirBIhHiFUh6LfazBYHCdO8OKuUGlNGIht9Y4u6GnseXsM2Ir7dAnGmjw/S5ZLyL7B3y4peBlL2EUsx8slyJjrAtJAPoOAfipTjvXpJLw66RHNt8Psfksr2gliY2Xrhhv+F5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fglgigmA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fglgigmA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764625420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PU3aIbnMU+BuREK+bEcl6eAdFWIrI+XOFPkJF/Fkm1k=;
	b=fglgigmAbBT4iGbN7h9CMC2796TlSzxhOHfNjqLzeh9OIx4sgbiZaikcYAr3U88nroXZq1
	klSrhnMM/P+gjBQnuj2LytRrKVOuGmEspFsEz1+lotuJbScXLYQawoo547LXu3zYEqrNAp
	FRk8ilfXIBtjAfpBYhL9uHqCgfVtAio=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-_SWH00H-NZm_sx_DcSsCYA-1; Mon,
 01 Dec 2025 16:43:37 -0500
X-MC-Unique: _SWH00H-NZm_sx_DcSsCYA-1
X-Mimecast-MFC-AGG-ID: _SWH00H-NZm_sx_DcSsCYA_1764625415
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 021DA180048E;
	Mon,  1 Dec 2025 21:43:35 +0000 (UTC)
Received: from localhost (unknown [10.2.16.172])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D34330001A4;
	Mon,  1 Dec 2025 21:43:33 +0000 (UTC)
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
Subject: [PATCH v3 1/4] scsi: sd: reject invalid pr_read_keys() num_keys values
Date: Mon,  1 Dec 2025 16:43:26 -0500
Message-ID: <20251201214329.933945-2-stefanha@redhat.com>
In-Reply-To: <20251201214329.933945-1-stefanha@redhat.com>
References: <20251201214329.933945-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The pr_read_keys() interface has a u32 num_keys parameter. The SCSI
PERSISTENT RESERVE IN command has a maximum READ KEYS service action
size of 65536 bytes. Reject num_keys values that are too large to fit
into the SCSI command.

This will become important when pr_read_keys() is exposed to untrusted
userspace via an <linux/pr.h> ioctl.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 drivers/scsi/sd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0252d3f6bed17..32ae4898cea7c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1974,9 +1974,19 @@ static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info)
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
+	if (check_mul_overflow(num_keys, 8, &data_len) ||
+	    check_add_overflow(data_len, 8, &data_len) ||
+	    data_len > USHRT_MAX)
+		return -EINVAL;
+
 	data = kzalloc(data_len, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-- 
2.52.0

