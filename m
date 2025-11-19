Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912DF332EBD
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763592173; cv=none; b=rYCD16/dW/whbDi0dnt1wRjlJd55YDyq8CFD/UDDnPqZcRvgo+9ztM5qS9Y5wW4xVnB8+R9FtHNtv9Vw7thkOgUZL1HqE08Wa0p3QLc2H0jfqN8O+OaKyTPpTvf96tQDvV89IGxgcwoCSir+NGbfM6V9EidwAFQXJrR4dx6kD0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763592173; c=relaxed/simple;
	bh=B/BgXU5jGXqJ8fx8DyMLnoTeMyEquDEs1wZn5Q9FMGU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JfnSorkM9QadexTVN00TpkIJv55jFOvVd2eofuS0/tFYg2c96ogI9CASnCje24JnFUQ+s3QzcFhap5h98k2wdqAELxggNHZ5BOhigucKXyHgrrabuyoUsMwga8Z+M6qEc9CAFvgsoDfjZ3pYiw2kuYpQNCXKDcjVaB+9lEo44Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=XpU1b4FH; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="XpU1b4FH"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqsz-006kxE-PT; Wed, 19 Nov 2025 23:42:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To
	:Message-Id:Date:Subject:Cc:To:From;
	bh=7Jg96M0LjfV6/eOJGD1SEnq9R+t62GdGi4Bj0LyUpIg=; b=XpU1b4FHNKlpt6uwtsYlM79geS
	N2oR9Qnt6KgDPVal4oFlF7GAgyv8JNyloJjV3NA88L0/vKvVHgLzHwi/MSf9LjntyiGon647xG7Rm
	/m4I8QSpM7TsIPNRzOmL5V1/LQqGuQbkWlGWoZdoxHoMuSLnRH5YXICQ3v7jPbYhTbVQba/374OEo
	7TJ7q3meKGbrzxZvuKVxB6w3lqAJpjK49sWeZh96FNwyGm6m5vNjJkYQsOtRTosh509xr3Z6B+q6e
	CCa0pLHG+2ZnIylMoZrwON/A+JT0LK68d8lxpJPphtgysMjCmry62l4tagrDn9hqNjQA0/ld3QaDb
	fkrqhZGw==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight.linux_spam@runbox.com>)
	id 1vLqsz-00086G-H3; Wed, 19 Nov 2025 23:42:49 +0100
Received: by submission03.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vLqsh-00Fos6-4t; Wed, 19 Nov 2025 23:42:31 +0100
From: david.laight.linux@gmail.com
To: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 26/44] drivers/scsi: use min() instead of min_t()
Date: Wed, 19 Nov 2025 22:41:22 +0000
Message-Id: <20251119224140.8616-27-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Laight <david.laight.linux@gmail.com>

min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
and so cannot discard significant bits.

In this case the 'unsigned long' value is small enough that the result
is ok.

Detected by an extra check added to min_t().

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 drivers/scsi/hosts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 17173239301e..b15896560cf6 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -247,7 +247,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	shost->dma_dev = dma_dev;
 
 	if (dma_dev->dma_mask) {
-		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
+		shost->max_sectors = min(shost->max_sectors,
 				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
 	}
 
-- 
2.39.5

