Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE11F330D24;
	Fri, 24 Apr 2026 22:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777070567; cv=none; b=qJMp78/X51Ejkep7DZZCrQeZ/9futp/JKapJUHFf49KS0H9vPoUA3U/FyMQ1oBppnL/vKrZaAGRzLG7xzH4kHzs9BJrHbgXmOxk+4sAlnZXW7h2PMPmRFwMwaOzbItZV+NDFO6mds35d9cH6g7GNi/l8qHQugAnyP6vld18K3tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777070567; c=relaxed/simple;
	bh=3IkZRUXtSIAk+tN6lJ+0t5TMx88Z2orI1Eqq38jxCEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mujka9T2ks9RprUEOaRWzljGn+kRu4Dn4Ww/TfuSLRwkTdiq6+JsfJY+8SqxPlLx9pJm93P9uF/gHUEefYqhYlh1G4X6a2IX4Y8swxSRi8dSrMrFsJ11ndPz5Bh5WC/Rm4ANUe72TIipBCHbFQqAVFcFWXnAztlVltbLU2UVnGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ffyEo62/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ffyEo62/"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g2Sdr0DGRz1XLDnV;
	Fri, 24 Apr 2026 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777070556; x=1779662557; bh=RSzpF
	oKs2c7iGR0jCRAU1YHjT5r/vjcUwHf2IThLqYs=; b=ffyEo62/oTvAV704uqzub
	GlthaD3P5kWyMM7zpkK3sQKEHpfQS3cED/+Trbn4ajDw8zZQVM91kmT8wnSWqdZH
	sJvcTxJso25JolGhttrDpHLlkJM4T6RpAQDkD55JAe67X3CKt0dtNHT4MUXrSYsn
	9pyZJdCVOUQYZOmLg09y6LiVmCD4TF/n+H6+DVd4eO6iCHGrmyLP8Kd7QDEgej7z
	4ChPrxxOA2sOr16SAyGyJpL/4cLJdwz8mGB1ZK9EVPfPMtJQfYusH8UXDifH+dIZ
	w6Jxv32nEyp8XGQWy84KclXqVwjh2bYVj4sQn7XQ3VxgMNeKqkOmYlJTSiAMYTBI
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 91GQYhTGq13t; Fri, 24 Apr 2026 22:42:36 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g2Sdk6Lpdz1XQmtn;
	Fri, 24 Apr 2026 22:42:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 10/12] dm: Add support for copy offloading
Date: Fri, 24 Apr 2026 15:41:59 -0700
Message-ID: <20260424224201.1949243-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
In-Reply-To: <20260424224201.1949243-1-bvanassche@acm.org>
References: <20260424224201.1949243-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In dm_calculate_queue_limits(), clear the copy offload limits if the
device mapper driver does not support copy offloading. This is necessary
since blk_set_stacking_limits() sets the copy offload limits to their
maximum.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/dm-table.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index dc2eff6b739d..888c5bdca5f1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1816,6 +1816,14 @@ int dm_calculate_queue_limits(struct dm_table *t,
 			return -EINVAL;
=20
 combine_limits:
+		if (!(ti_limits.features & BLK_FEAT_STACKING_COPY_OFFL)) {
+			ti_limits.max_copy_hw_sectors =3D 0;
+			ti_limits.max_copy_src_segments =3D 0;
+			ti_limits.max_copy_dst_segments =3D 0;
+			ti_limits.max_user_copy_sectors =3D 0;
+			ti_limits.max_copy_sectors =3D 0;
+		}
+
 		/*
 		 * Merge this target's queue limits into the overall limits
 		 * for the table.
