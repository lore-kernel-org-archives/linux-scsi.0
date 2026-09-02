Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DEB3C10B9
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 20:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788379581; cv=none; b=sD3wlK7ekjiLhZFBMcgzOmZBYQ2mqf7EDzn2xEr29SNztyv9f3lq1/AEuZHt+k+4QauEV65QFcjUbzeqcQ9XGfOzJQimUOuIdLziodi5nIixB1b+XhrQxxbknnlY6Yma+c+XkZjUcvgn5Te4o96cAUHDjGnjCQqVmTNQF+Bu+8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788379581; c=relaxed/simple;
	bh=Eech0gy65GAyXynFCo9H4txIPW1uvlMnLzdl3n7agz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1usnJHEav9RN6KM83z+IZKBgBFHoUT0ZxWkYUhLNJVnuHgVz0hPrKuLcbZXwY5Awxj+MFtTKfqn46LcWws1Ods0sSjnIKD8EiOhtdL+Vemc/pLHmByqT9Vv/MqOPZI4fMK74qg35fhSls6uOjuf8r8GWcd+6OESnl1iR1I6MEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f+DGh39G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f+DGh39G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788379579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UMvbLiMb+sF2mtOC2uLwr9SRzXheSA2PXAvP/FINdPY=;
	b=f+DGh39Go1nBKCCTWdO6+F3/Osa7hg3EEDuaIItZjCBCA4GqOqFnFnVgJG+OctikQOaOlq
	zFNuaYxwrFjHwnh9z6Oq0E9je2h1onDa1NUhYV54XSVkmzEXYjfYZVc8aZpilPIZbVW0kt
	/LM2ckxlomwe2pwwrfnzf2m60Nh2Kf8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-l6utWQtSM8iZ4kPy_-lR3g-1; Wed,
 02 Sep 2026 16:06:15 -0400
X-MC-Unique: l6utWQtSM8iZ4kPy_-lR3g-1
X-Mimecast-MFC-AGG-ID: l6utWQtSM8iZ4kPy_-lR3g_1788379571
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B45F195DE47;
	Wed,  2 Sep 2026 20:06:11 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.17.16.153])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 247C61955F04;
	Wed,  2 Sep 2026 20:06:08 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Hannes Reinecke <hare@suse.de>,
	Jesse Taube <jtaubepe@redhat.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	"Ewan D . Milne" <emilne@redhat.com>,
	shinichiro.kawasaki@wdc.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	Muneendra Kumar <muneendra.kumar@broadcom.com>
Subject: [PATCH v2 5/7] nvme: sysfs: emit the marginal path state in show_state()
Date: Wed,  2 Sep 2026 16:05:45 -0400
Message-ID: <20260902200547.184734-6-jtaubepe@redhat.com>
In-Reply-To: <20260902200547.184734-1-jtaubepe@redhat.com>
References: <20260902200547.184734-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Bryan Gurney <bgurney@redhat.com>

If a controller has received a link integrity or congestion event, and
has the NVME_CTRL_MARGINAL flag set, emit "marginal" in the state
instead of "live", to identify the marginal paths.

Co-developed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
V10 -> V1:
 - No change
V1 -> V2:
 - Only emit "marginal" if port is "live"
---
 drivers/nvme/host/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 75b2d69b5957..9ede6b37f27a 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -526,6 +526,9 @@ static ssize_t nvme_sysfs_show_state(struct device *dev,
 		[NVME_CTRL_DEAD]	= "dead",
 	};
 
+	if (state == NVME_CTRL_LIVE && nvme_ctrl_is_marginal(ctrl))
+		return sysfs_emit(buf, "%s\n", "marginal");
+
 	if (state < ARRAY_SIZE(state_name) && state_name[state])
 		return sysfs_emit(buf, "%s\n", state_name[state]);
 
-- 
2.55.0

