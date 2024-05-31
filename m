Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3797380631;
	Fri, 31 May 2024 07:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141742; cv=none; b=pXsR3hhc+/MSqXU/7OtnYmujQGQo2NavZ0Y5jOug6m1GqxWSylQ6jI/K1Bn5upgPH1xNw8Y879MF6Ji4rr7sMrOiPd2c+2/uRAKWBQP3Tc7wHSzkeLQ+OjXokDhk1nm8n1aP0zXnodpsph+Gs+WLZlDSWoNT1Mp509dWHEp+cKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141742; c=relaxed/simple;
	bh=hlPcmeD9OIsIm6sYj1irZFMoX5dKeK3PVAUEe4ryMbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM4hifFVT9HeRib+m3jluJ5dv7/EPNXUpf+j1KJfCURbPsPYB3wK7ubPVbMhXbdJFGHkrfrKaBebhJC3Nc2gEvb7dvtchFmTtds7KCxgOaJhymQA5QwGfo9/5G5ZEzX6dtGTCKUg6i/AVleFIj6mlFPAdkx6xHhsNEWO5Hvo3xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fbXoGRqk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fbXoGRqk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FAwSfn6ckfnQfuPEUHGpbbgoT8gFgpbbTIk4PRDlm6U=; b=fbXoGRqkGTVOs0QpSZx1za9SJZ
	wqVDSjCy1no2SJW1DLELgUUweO0zbCp7XqisGNgydQGJuEz4rVDUKXUgRM5AmJuAPPjYJlYUvwtkh
	TWFfhZlnAQj3Rw/BSfNpRA6U1AHETgyqHOaeb5qOgQAV5sGO0cu1Qce5CKmhis721gFK7f6ewt+Hl
	mzjO2pXvW3XVfYoA51SiP+wqtSR6lDKtbcJiyvM1VF7YK5J/zJk0XCfyiKO92WAR3AjBFDLtodw43
	uZ6lQl/D07TmW80lgSIq98oUc4YJVGrlTrsAfUYYrzsd9K7Sfua52KNVwv31wAcbpsDwQ18f37u4H
	QmsvUDdw==;
Received: from 2a02-8389-2341-5b80-5ba9-f4da-76fa-44a9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5ba9:f4da:76fa:44a9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCx0S-00000009XbL-2AyO;
	Fri, 31 May 2024 07:48:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 05/14] sd: simplify the ZBC case in provisioning_mode_store
Date: Fri, 31 May 2024 09:48:00 +0200
Message-ID: <20240531074837.1648501-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531074837.1648501-1-hch@lst.de>
References: <20240531074837.1648501-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Don't reset the discard settings to no-op over and over when a user
writes to the provisioning attribute as that is already the default
mode for ZBC devices.  In hindsight we should have made writing to
the attribute fail for ZBC devices, but the code has probably been
around for far too long to change this now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3dff9150ce11e2..83aa17fea39d39 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -461,14 +461,13 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sd_is_zoned(sdkp)) {
-		sd_config_discard(sdkp, SD_LBP_DISABLE);
-		return count;
-	}
-
 	if (sdp->type != TYPE_DISK)
 		return -EINVAL;
 
+	/* ignore the provisioning mode for ZBC devices */
+	if (sd_is_zoned(sdkp))
+		return count;
+
 	mode = sysfs_match_string(lbp_mode, buf);
 	if (mode < 0)
 		return -EINVAL;
-- 
2.43.0

